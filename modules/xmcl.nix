{
  pkgs,
  ...
}:
with pkgs;
let
  pname = "xmcl";
  version = "0.48.0";
  src = fetchurl {
    url = "https://github.com/Voxelum/x-minecraft-launcher/releases/download/v${version}/${pname}-${version}-x86_64.AppImage";
    hash = "sha256-qa6bzPqyfOTZFshLFdxLI285q3cQqbWCVi8Py6LBgoo=";
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
