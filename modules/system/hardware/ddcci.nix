{ inputs, ... }:
{
  imports = [
    inputs.nixos-ddcci-nvidia.nixosModules.default
  ];
}
