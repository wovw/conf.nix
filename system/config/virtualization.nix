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
  ];

  programs.virt-manager.enable = true;
  services.qemuGuest.enable = true;

  virtualisation = {
    libvirtd = {
      enable = true;
    };
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
    };
  };
}
