{ ... }:
{
  home.file.".config/easyeffects/input/masc_voice_noise_reduction.json".text =
    ''${builtins.readFile ./masc_voice_noise_reduction.json}'';
  services.easyeffects = {
    enable = true;
    preset = "masc_voice_noise_reduction";
  };
}
