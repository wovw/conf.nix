{
  pkgs,
  username,
  ...
}:
{
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
  };
  environment.systemPackages = with pkgs; [
    libvirt
    podman-compose
    lazydocker
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
      dockerSocket.enable = true;
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
