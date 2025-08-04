{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    clinfo
    vulkan-tools
    mesa-demos
  ];
}
