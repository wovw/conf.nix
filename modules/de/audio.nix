{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    deepfilternet # LADSPA binary
  ];

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      # @see https://discourse.nixos.org/t/bluetooh-not-working/48430/3
      wireplumber.configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/10-bluez.conf" ''
          monitor.bluez.properties = {
            bluez5.roles = [ a2dp_sink a2dp_source bap_sink bap_source hsp_hs hsp_ag hfp_hf hfp_ag ]
            bluez5.codecs = [ sbc sbc_xq aac ]
            bluez5.enable-sbc-xq = true
            bluez5.hfphsp-backend = "native"
          }
        '')
      ];

      # Inject the DeepFilterNet LADSPA plugin directly into the PipeWire DAG
      extraConfig.pipewire."99-deepfilter" = {
        "context.modules" = [
          {
            "name" = "libpipewire-module-filter-chain";
            "args" = {
              "node.description" = "DeepFilter Noise Canceling Mic";
              "media.name" = "DeepFilter Noise Canceling Mic";
              "filter.graph" = {
                "nodes" = [
                  {
                    "type" = "ladspa";
                    "name" = "DeepFilter";
                    # Use string interpolation to dynamically link the correct Nix store path
                    "plugin" = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                    "label" = "deep_filter_mono";
                    "control" = {
                      "Attenuation Limit (dB)" = 60.0;
                    };
                  }
                ];
              };
              "capture.props" = {
                "node.name" = "capture.deepfilter_input";
                "node.passive" = true;
                # DeepFilterNet natively operates at 48kHz. Locking it prevents resampling overhead.
                "audio.rate" = 48000;
                # Enforce Mono channel mapping for PulseAudio translation
                "audio.channels" = 1;
                "audio.position" = [ "MONO" ];
              };
              "playback.props" = {
                "node.name" = "deepfilter_source";
                "media.class" = "Audio/Source";
                "audio.rate" = 48000;
                # Enforce Mono channel mapping for PulseAudio translation
                "audio.channels" = 1;
                "audio.position" = [ "MONO" ];
                # pipewire-pulse reads the display name from the playback node
                "node.description" = "DeepFilter Noise Canceling Mic";
              };
            };
          }
        ];
      };
    };
  };
}
