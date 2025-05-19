{
  pkgs,
  ...
}:
{
  environment.sessionVariables = {
    LIBVIRT_DEFAULT_URI = "qemu:///system";
  };
  environment.systemPackages = with pkgs; [
    libvirt
    virt-viewer
    podman-compose
  ];

  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;

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
}
