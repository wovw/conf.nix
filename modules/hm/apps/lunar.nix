{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  pkgs,
}:
let
  update = pkgs.writeShellApplication {
    name = "update";

    runtimeInputs = with pkgs; [
      curl
      yq
    ];

    text = ''
      set -eu -o pipefail

      target="$(dirname "$(readlink -f "$0")")/package.nix"
      host="https://launcherupdates.lunarclientcdn.com"
      metadata=$(curl "$host/latest-linux.yml")
      version=$(echo "$metadata" | yq .version -r)
      hash=$(echo "$metadata" | yq .sha512 -r)

      sed -i "s@version = .*;@version = \"$version\";@g" "$target"
      sed -i "s@hash.* = .*;@hash = \"sha512-$hash\";@g" "$target"
    '';
  };
in
appimageTools.wrapType2 rec {
  pname = "lunarclient";
  version = "3.3.5";

  src = fetchurl {
    url = "https://launcherupdates.lunarclientcdn.com/Lunar%20Client-${version}.AppImage";
    hash = "sha512-DHDo+4qZvsagquMKwdkXG0CBQh0fRPogNdMrOcUbDcisml7/j2sBe+jjOSLOB4ipOB1ULSXmqBugtvb6gDUbzQ==";
  };

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands =
    let
      contents = appimageTools.extract { inherit pname version src; };
    in
    ''
      wrapProgram $out/bin/lunarclient \
        --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"
      install -Dm444 ${contents}/lunarclient.desktop -t $out/share/applications/
      install -Dm444 ${contents}/lunarclient.png -t $out/share/pixmaps/
      substituteInPlace $out/share/applications/lunarclient.desktop \
        --replace-fail 'Exec=AppRun --no-sandbox %U' 'Exec=lunarclient' \
    '';

  passthru.updateScript = "${update}/bin/update";

  meta = with lib; {
    description = "Free Minecraft client with mods, cosmetics, and performance boost";
    homepage = "https://www.lunarclient.com/";
    license = with licenses; [ unfree ];
    mainProgram = "lunarclient";
    maintainers = with maintainers; [
      Technical27
      surfaceflinger
    ];
    platforms = [ "x86_64-linux" ];
  };
}
