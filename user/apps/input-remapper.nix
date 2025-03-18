{ ... }:
{
  xdg.configFile."input-remapper-2/presets/Logitech M705/scroll-click.json".text = ''
    [
        {
            "input_combination": [
                {
                    "type": 2,
                    "code": 8,
                    "origin_hash": "ed94ae4ae00baebce72b5b6c80a43ea0",
                    "analog_threshold": -1
                }
            ],
            "target_uinput": "mouse",
            "output_symbol": "BTN_RIGHT",
            "mapping_type": "key_macro",
            "release_timeout": 0.001
        },
        {
            "input_combination": [
                {
                    "type": 2,
                    "code": 11,
                    "origin_hash": "ed94ae4ae00baebce72b5b6c80a43ea0",
                    "analog_threshold": -1
                }
            ],
            "target_uinput": "mouse",
            "output_symbol": "disable",
            "mapping_type": "key_macro"
        },
        {
            "input_combination": [
                {
                    "type": 2,
                    "code": 8,
                    "origin_hash": "ed94ae4ae00baebce72b5b6c80a43ea0",
                    "analog_threshold": 1
                }
            ],
            "target_uinput": "keyboard",
            "output_symbol": "disable",
            "mapping_type": "key_macro"
        },
        {
            "input_combination": [
                {
                    "type": 2,
                    "code": 11,
                    "origin_hash": "ed94ae4ae00baebce72b5b6c80a43ea0",
                    "analog_threshold": 1
                }
            ],
            "target_uinput": "keyboard",
            "output_symbol": "disable",
            "mapping_type": "key_macro"
        }
    ]
  '';
}
