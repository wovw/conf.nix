{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  pkgs,
}:
let
  sources = builtins.fromJSON (builtins.readFile ../../../sources.json);
  lunarSrc = sources.lunar;

  version = lunarSrc.version;
  hash = lunarSrc.hash;
  url = builtins.replaceStrings [ "{version}" ] [ version ] lunarSrc.url;

  # for manual updates
  update = pkgs.writeShellApplication {
    name = "update";

    runtimeInputs = with pkgs; [
      curl
      yq
      jq
    ];

    text = ''
      set -eu -o pipefail

      target="../../../sources.json"
      host="https://launcherupdates.lunarclientcdn.com"
      metadata=$(curl "$host/latest-linux.yml")
      version=$(echo "$metadata" | yq .version -r)
      hash=$(echo "$metadata" | yq .sha512 -r)

      url="https://launcherupdates.lunarclientcdn.com/Lunar%20Client-$version.AppImage"

      jq --arg version "$version" \
         --arg hash "sha512-$hash" \
         --arg url "$url" \
         '.lunar.version = $version | .lunar.hash = $hash | .lunar.url = $url' \
         "$target" > "$target.tmp"
      mv "$target.tmp" "$target"

      echo "Updated Lunar to version $version"
    '';
  };
in
appimageTools.wrapType2 rec {
  pname = "lunarclient";
  inherit version;

  src = fetchurl {
    inherit url hash;
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
