{ pkgs }:
let
    version = "1.0.1-a.19";
    downloadUrl = {
        specific.url = "https://github.com/zen-browser/desktop/releases/download/${version}/zen.linux-specific.tar.bz2";
        specific.sha256 = "1g7nq1yfaya97m43vnkjj1nd9g570viy8hj45c523hcyr1z92rjq";
    };

    # nvidia-vaapi-driver
    policiesContent = builtins.toJSON {
        policies = {
            preferences = {
                "media.ffmpeg.vaapi.enabled" = true;
                "media.rdd-ffmpeg.enabled" = true;
                "media.av1.enabled" = false;
                "gfx.x11-egl.force-enabled" = true;
                "widget.dmabuf.force-enabled" = true;
            };
        };
    };

    runtimeLibs = with pkgs;
        [
            libGL
            libGLU
            libevent
            libffi
            libjpeg
            libpng
            libstartup_notification
            libvpx
            libwebp
            stdenv.cc.cc
            fontconfig
            libxkbcommon
            zlib
            freetype
            gtk3
            libxml2
            dbus
            xcb-util-cursor
            alsa-lib
            libpulseaudio
            pango
            atk
            cairo
            gdk-pixbuf
            glib
            udev
            libva
            mesa
            libnotify
            cups
            pciutils
            ffmpeg
            libglvnd
            pipewire
            speechd
        ]
        ++ (with pkgs.xorg; [
            libxcb
            libX11
            libXcursor
            libXrandr
            libXi
            libXext
            libXcomposite
            libXdamage
            libXfixes
            libXScrnSaver
        ]);

    downloadData = downloadUrl.specific;
in
    pkgs.stdenv.mkDerivation {
        inherit version;
        pname = "zen-browser";

        src = builtins.fetchTarball {
            url = downloadData.url;
            sha256 = downloadData.sha256;
        };

        desktopSrc = ./.;

        phases = ["installPhase" "fixupPhase"];

        nativeBuildInputs = [pkgs.makeWrapper pkgs.copyDesktopItems pkgs.wrapGAppsHook];

        unpackPhase = ''
            cp -r $src/* .
            chmod -R +w .
            mkdir -p distribution
            echo '${policiesContent}' > distribution/policies.json
        '';

        installPhase = ''
            mkdir -p $out/{bin,opt/zen} && cp -r $src/* $out/opt/zen
            ln -s $out/opt/zen/zen $out/bin/zen

            install -D $desktopSrc/zen.desktop $out/share/applications/zen.desktop
            install -D $src/browser/chrome/icons/default/default16.png $out/share/icons/hicolor/16x16/apps/zen.png
            install -D $src/browser/chrome/icons/default/default32.png $out/share/icons/hicolor/32x32/apps/zen.png
            install -D $src/browser/chrome/icons/default/default48.png $out/share/icons/hicolor/48x48/apps/zen.png
            install -D $src/browser/chrome/icons/default/default64.png $out/share/icons/hicolor/64x64/apps/zen.png
            install -D $src/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen.png
            '';

        fixupPhase = ''
            chmod 755 $out/bin/zen $out/opt/zen/*

            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/zen
            wrapProgram $out/opt/zen/zen --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
                --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen \
                --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/zen-bin
            wrapProgram $out/opt/zen/zen-bin --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}" \
                --set MOZ_LEGACY_PROFILES 1 --set MOZ_ALLOW_DOWNGRADE 1 --set MOZ_APP_LAUNCHER zen \
                --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"

            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/glxtest
            wrapProgram $out/opt/zen/glxtest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"

            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/updater
            wrapProgram $out/opt/zen/updater --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"

            patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/zen/vaapitest
            wrapProgram $out/opt/zen/vaapitest --set LD_LIBRARY_PATH "${pkgs.lib.makeLibraryPath runtimeLibs}"
            '';

        meta.mainProgram = "zen";
    }
