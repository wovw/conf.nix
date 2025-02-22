{
  pkgs,
  ...
}:
with pkgs;
let
  pname = "lm-studio";
  version = "0.3.8-4";
  src = fetchurl {
    url = "https://installers.lmstudio.ai/linux/x64/${version}/LM-Studio-${version}-x64.AppImage";
    hash = "sha256-JnuEYU+vitBGS0WZdcleVW1DfZ+MonXz6U+ObUlsePM=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname src version; };

  meta = with lib; {
    mainProgram = "lm-studio";
    description = "Desktop application for running local LLMs";
    homepage = "https://lmstudio.ai/";
    license = licenses.unfree;
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
