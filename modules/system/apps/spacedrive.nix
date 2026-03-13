{ pkgs, ... }:

let
  spacedrive-latest = pkgs.spacedrive.overrideAttrs (
    finalAttrs: previousAttrs: rec {
      version = "v2.0.0-alpha.2";

      src = pkgs.fetchurl {
        url = "https://github.com/spacedriveapp/spacedrive/releases/download/${version}/Spacedrive-linux-x86_64.deb";
        hash = "sha256-KzRPBtyX5x4ZLlZd6SgAS/cy/7irXt7v+b3Yuq9GETo=";
      };
    }
  );
in
{
  environment.systemPackages = [
    spacedrive-latest
  ];
}
