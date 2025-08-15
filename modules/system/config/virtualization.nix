{
  pkgs,
  username,
  ...
}:
{
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
  environment.systemPackages = with pkgs; [
    libvirt
    podman-compose
  ];

  programs.virt-manager.enable = true;

  virtualisation = {
    containers.enable = true;
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true; # docker alias
      defaultNetwork.settings.dns_enabled = true; # containers can communicate
    };
    oci-containers = {
      backend = "podman";
    };
  };
  users.extraUsers."${username}".extraGroups = [
    "podman"
    "libvirtd" # https://wiki.nixos.org/wiki/OSX-KVM
  ];

  hardware.nvidia-container-toolkit.enable = true;
}
