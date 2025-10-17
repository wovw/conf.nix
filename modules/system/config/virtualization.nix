{
  pkgs,
  username,
  ...
}:
{
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
    DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock";
    ZSH_DISABLE_COMPFIX = "true";
  };
  environment.systemPackages = with pkgs; [
    libvirt
    podman-compose
    distrobox
    lazydocker
  ];

  environment.etc."distrobox/distrobox.conf".text = ''
    container_additional_volumes="/nix/store:/nix/store:ro /etc/profiles/per-user:/etc/profiles/per-user:ro /etc/static/profiles/per-user:/etc/static/profiles/per-user:ro"
  '';

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
    "kvm"
    "podman"
    "libvirt"
    "libvirtd"
  ];

  hardware.nvidia-container-toolkit.enable = true;
}
