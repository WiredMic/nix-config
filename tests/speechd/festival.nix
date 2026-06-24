{
  pkgs,
  self,
  lib,
  ...
}:

{
  name = "speechd-festival";

  _module.args.self = self;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = builtins.attrValues self.nixosModules;

      boot.kernelModules = [ "snd-aloop" ];

      programs.festival = {
        enable = true;
        defaultVoice = "kal_diphone";
        extraVoices = voices: with voices; [ kal_diphone ];
        withSpeechdSupport = true;
      };

      services.festival.enable = true;
      services.speechd.enable = true;

      environment.systemPackages = [ pkgs.alsa-utils ];

      users.users.machine = {
        isNormalUser = true;
        linger = true;
        password = "machine";
      };
    };

  testScript = ''
    machine.start()
    machine.wait_for_unit("multi-user.target")

    machine.systemctl("start festival.service", "machine")
    machine.wait_for_unit("festival.service", "machine")

    machine.systemctl("start speech-dispatcher.service", "machine")
    machine.wait_for_unit("speech-dispatcher.service", "machine")

    # Direct Festival test
    machine.succeed(
      "echo '(utt.save.wave (utt.synth (Utterance Text \"Festival test. Festival test.\")) \"/tmp/tts-out.wav\" (quote riff))' | festival --pipe"
    )
    size = int(machine.succeed("stat -c %s /tmp/tts-out.wav").strip())
    assert size > 44, f"Festival WAV too small: {size} bytes"

    # spd-say test: record the loopback while spd-say speaks
    machine.execute("arecord -D hw:Loopback,1,0 -f S16_LE -r 16000 -c 1 -d 10 /tmp/spd-out.wav &")
    machine.sleep(1)

    machine.succeed("spd-say -o festival -w 'Test from Speech Dispatcher via Festival. Second sentence.'")

    machine.sleep(2)

    spd_size = int(machine.succeed("stat -c %s /tmp/spd-out.wav").strip())
    assert spd_size > 100_000, f"spd→festival WAV too small, likely no audio: {spd_size} bytes"

    machine.fail(
      "journalctl --no-pager -o cat"
      " | grep -qE 'command not found|Cannot load wavefile|SIOD ERROR'"
    )

    print("✅ speechd-festival test passed")
  '';
}
