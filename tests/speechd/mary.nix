{
  pkgs,
  self,
  lib,
  ...
}:

{
  name = "speechd-marytts";

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = builtins.attrValues self.nixosModules;

      boot.kernelModules = [ "snd-aloop" ];

      services.marytts = {
        enable = true;
        port = 5646;
        voices = [
          (pkgs.fetchzip {
            url = "https://github.com/marytts/voice-bits1-hsmm/releases/download/v5.2/voice-bits1-hsmm-5.2.zip";
            hash = "sha256-1nK+qZxjumMev7z5lgKr660NCKH5FDwvZ9sw/YYYeaA=";
          })
        ];

      };

      services.speechd.enable = lib.mkForce false;

      services.speechd2 = {
        enable = true;
        modules = {
          espeakNg.enable = false;
          mary = {
            enable = true;
            debug = true;
            port = config.services.marytts.port;
          };
        };
        defaultModule = "mary";
        logLevel = 4;
        logDir = "/tmp/speech-debug";
        audioOutputMethod = "libao";
        extraConfig = "DisableAutoSpawn";
      };

      environment.systemPackages = [ pkgs.alsa-utils ];

      users.users.machine = {
        isNormalUser = true;
        linger = true;
        password = "machine";
      };
    };

  testScript =
    { nodes, ... }:
    let
      logDir = nodes.machine.services.speechd2.logDir;
      defaultModule = nodes.machine.services.speechd2.defaultModule;
    in
    ''
      import re

      machine.start()
      machine.wait_for_unit("multi-user.target")

      # Dump user journal to help debug if mary fails to start
      machine.succeed("'journalctl --user -xeu mary.service --no-pager' || true")

      machine.systemctl("reset-failed marytts.service")
      machine.systemctl("start marytts.service")
      machine.wait_for_unit("marytts.service")
      machine.wait_for_open_port(${toString nodes.machine.services.marytts.port})

      machine.systemctl("start speech-dispatcher.service", "machine")
      machine.wait_for_unit("speech-dispatcher.service", "machine")

      # spd-say test: record the loopback while spd-say speaks
      machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 10 /tmp/spd-out.wav &")
      machine.sleep(1)

      machine.succeed(
          "su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -w 'Test from Speech Dispatcher via ${defaultModule}. Second sentence.'\""
      )

      machine.sleep(2)

      spd_size = int(machine.succeed("stat -c %s /tmp/spd-out.wav").strip())
      assert spd_size > 100_000, f"spd→mary WAV too small, likely no audio: {spd_size} bytes"

      # --- Log directory and content ---
      machine.succeed("test -d ${logDir}")
      machine.succeed("test -n \"$(ls ${logDir})\"")
      print(machine.succeed("ls ${logDir}"))

      machine.succeed("ls ${logDir}/speech-dispatcher.log")
      print(machine.succeed("cat ${logDir}/speech-dispatcher.log"))
      print(machine.succeed("cat ${logDir}/dummy.log"))
      machine.succeed("ls ${logDir}/${defaultModule}.log")


      # --- No fatal errors in journal ---
      journal = machine.succeed("su - machine -c 'journalctl --user --no-pager -o cat'")

      pattern = re.compile(
          r"Unknown Config-Option|Could not initialize engine|has no voice|"
          r"Failed to set synthesis voice|Failed to set punctuation list|FATAL|core dumped",
          re.IGNORECASE,
      )
      matches = [line for line in journal.splitlines() if pattern.search(line)]
      if matches:
          print("Found problem lines:\n" + "\n".join(matches))
          raise AssertionError("Found error patterns in journal")
    '';
}
