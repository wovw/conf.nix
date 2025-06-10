{
  pkgs,
  ...
}:
with pkgs;
let
  pname = "xmcl";
  version = "0.51.1";
  src = fetchurl {
    url = "https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-dhptGQNKjeCHBkuSCbkcrYJ/F/rx2HicRfAES5VWaxM=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

  meta = with lib; {
    mainProgram = "xmcl";
    description = "X Minecraft Launcher";
    homepage = "https://github.com/Voxelum/x-minecraft-launcher";
    license = licenses.mit;
    platforms = platforms.linux;
  };
in
appimageTools.wrapType2 {
  inherit
    pname
    version
    src
    meta
    ;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop $out/share/applications/${pname}.desktop
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';
}
