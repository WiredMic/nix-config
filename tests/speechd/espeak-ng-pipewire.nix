{
  pkgs,
  self,
  lib,
  ...
}:
let
  audioOutputMethod = "pipewire";
in
{
  name = "speechd-espeak-ng-${audioOutputMethod}";

  nodes.machine =
    { config, pkgs, ... }:
    let
      espeak-ng-en = pkgs.espeak-ng.overrideAttrs (old: {
        postInstall = (old.postInstall or "") + ''
          # Keep only English dict and lang files
          find $out/share/espeak-ng-data -maxdepth 1 -name "*_dict" \
            ! -name "en_dict" -delete

          find $out/share/espeak-ng-data/lang -mindepth 1 -type f \
            ! -name "en" ! -name "en-*" -delete

          find $out/share/espeak-ng-data/voices/!v -mindepth 1 -type f \
            ! -name "en" ! -name "en-*" -delete
        '';
      });
    in
    {
      imports = builtins.attrValues self.nixosModules;

      boot.kernelModules = [ "snd-aloop" ];

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };

      services.speechd.enable = lib.mkForce false;

      services.speechd2 = {
        enable = true;
        modules.espeakNg = {
          enable = true;
          debug = true;
        };
        defaultModule = "espeakNg";
        logLevel = 5;
        logDir = "/tmp/speech-debug";
        audioOutputMethod = "pipewire";
        extraConfig = "DisableAutoSpawn";
      };

      environment.systemPackages = [
        pkgs.alsa-utils
        pkgs.python3
      ];

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

      machine.wait_for_unit("pipewire.socket", "machine")

      # Poke the socket to trigger pipewire.service activation
      machine.succeed(
          "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 pw-cli info'"
      )

      # Now pipewire.service should be up, and wireplumber pulled in as its dependency
      machine.wait_for_unit("pipewire.service", "machine")
      machine.wait_for_unit("wireplumber.service", "machine")

      machine.sleep(3)
      print(machine.succeed(
          "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 journalctl --user -u wireplumber --no-pager'"
      ))
      print(machine.succeed(
          "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 wpctl status'"
      ))

      # --- Sound Icons Test ---
      machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 5 /tmp/sound-icon-out.wav &")
      machine.sleep(1)

      status, out = machine.execute(
          "su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 python3 -c \\\""
          "import speechd; c = speechd.SSIPClient('test'); c.sound_icon('message'); c.close()"
          "\\\"\" 2>&1"
      )
      print(f"sound_icon exit={status}\n{out}")

      machine.sleep(2)
      icon_size = int(machine.succeed("stat -c %s /tmp/sound-icon-out.wav").strip())
      assert icon_size > 1_000, f"sound icon produced no audio: {icon_size} bytes"

      # --- Audio output test ---
      machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 10 /tmp/spd-out.wav &")
      machine.sleep(1)

      print(machine.succeed(
          "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 wpctl status'"
      ))
      sinks = machine.succeed(
          "su - machine -c 'XDG_RUNTIME_DIR=/run/user/1000 wpctl status' "
          "| grep -A5 Sinks"
      )
      print(sinks)
      assert "Loopback" in sinks or "*" in sinks, "no default sink found before running speechd tests"

      status, out = machine.execute(
          "su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 timeout 15 spd-say -o ${defaultModule} -w 'Test from Speech Dispatcher via eSpeak NG. Second sentence.'\" 2>&1"
      )
      print(f"spd-say exit={status}\n{out}")
      if status == 124:
          print(machine.succeed("su - machine -c 'journalctl --user --no-pager -u speech-dispatcher'"))
          raise AssertionError("spd-say timed out — likely stuck waiting on audio sink")

      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -w 'Test a single sentence.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -w 'Test from Speech Dispatcher via eSpeak NG. Second sentence.'\"")

      machine.sleep(2)

      spd_size = int(machine.succeed("stat -c %s /tmp/spd-out.wav").strip())
      assert spd_size > 100_000, f"spd→espeak-ng WAV too small, likely no audio: {spd_size} bytes"

      # --- Rate / pitch / volume options ---
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -r 50 -w 'Fast speech rate test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -r -50 -w 'Slow speech rate test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -p 50 -w 'High pitch test.'\"")
      machine.succeed("su - machine -c \"XDG_RUNTIME_DIR=/run/user/1000 spd-say -o ${defaultModule} -i 50 -w 'High volume test.'\"")

      # --- Log directory and content ---
      machine.succeed("test -d ${logDir}")
      print(machine.succeed("ls ${logDir}"))
      machine.succeed("test -n \"$(ls ${logDir})\"")

      # machine.fail("grep -qE 'ADD TEST HERE' ${logDir}/speech-dispatcher.log")
      # machine.fail("grep -qE 'ADD TEST HERE' ${logDir}/${defaultModule}.log")

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
