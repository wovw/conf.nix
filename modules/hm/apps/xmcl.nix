{
  pkgs,
  ...
}:
with pkgs;
let
  sources = builtins.fromJSON (builtins.readFile ../../../sources.json);
  xmclSrc = sources.xmcl;

  pname = "xmcl";
  version = xmclSrc.version;
  hash = xmclSrc.hash;
  url = builtins.replaceStrings [ "{version}" ] [ version ] xmclSrc.url;

  src = fetchurl {
    inherit url hash;
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
