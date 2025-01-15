{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  inih,
  systemd,
  scdoc,
}:

stdenv.mkDerivation {
  pname = "xdg-desktop-portal-termfilechooser";
  version = "unstable-2024-01-12";

  src = fetchFromGitHub {
    owner = "boydaihungst";
    repo = "xdg-desktop-portal-termfilechooser";
    rev = "master";
    sha256 = "sha256-2WTpt5vgVmVPZIowx+aY2MXzjxNaoGWSs3jnsQsizKk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    scdoc
  ];

  buildInputs = [
    inih
    systemd
  ];

  mesonFlags = [
    "-Dauto_features=enabled"
    "-Dsd-bus-provider=libsystemd"
  ];

  meta = with lib; {
    description = "XDG Desktop Portal backend for choosing files with terminal file managers";
    homepage = "https://github.com/boydaihungst/xdg-desktop-portal-termfilechooser";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
