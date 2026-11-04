{ pkgs ? import <nixpkgs> { }
, lib ? pkgs.lib
, enableDemo ? true
, enableFull ? false
}:

assert lib.assertMsg (enableDemo || enableFull)
  "xplane-nix: Enable at least one feature flag (`enableDemo = true` or `enableFull = true`).";

let
  installerRaw = pkgs.stdenv.mkDerivation {
    pname = "xplane-12-installer-unwrapped";
    version = "12";

    src = pkgs.fetchurl {
      url = "https://lookup.x-plane.com/_lookup_12_/download/X-Plane12InstallerLinux.zip";
      hash = "sha256-5Dg9qkilIu09cJveIngVHM5y6RyF0cQ8iIHihtWicDY=";
    };

    nativeBuildInputs = [ pkgs.unzip ];

    dontStrip = true;
    dontPatchELF = true;

    unpackPhase = ''
      runHook preUnpack
      unzip -q "$src"
      runHook postUnpack
    '';

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/bin"
      cp "X-Plane 12 Installer Linux" "$out/bin/xplane-installer"
      chmod +x "$out/bin/xplane-installer"
      runHook postInstall
    '';
  };

  mkXplaneFhs = edition:
    pkgs.buildFHSEnv {
      name = "xplane-${edition}";

      targetPkgs = p: [
        installerRaw
        p.stdenv.cc.cc
        p.zlib
        p.glib
        p.glib-networking
        p.gtk3
        p.webkitgtk_4_1
        p.libsoup_3
        p.pango
        p.harfbuzz
        p.cairo
        p.gdk-pixbuf
        p.at-spi2-atk
        p.dbus
        p.fontconfig
        p.freetype
        p.libxkbcommon
        p.wayland
        (p.libX11 or p.xorg.libX11)
        (p.libXext or p.xorg.libXext)
        (p.libXrender or p.xorg.libXrender)
        (p.libXrandr or p.xorg.libXrandr)
        (p.libXi or p.xorg.libXi)
        (p.libXcursor or p.xorg.libXcursor)
        (p.libXinerama or p.xorg.libXinerama)
        (p.libXxf86vm or p.xorg.libXxf86vm)
        p.libGL
        p.libGLU
        p.vulkan-loader
        p.openal
        p.alsa-lib
        p.libpulseaudio
        p.curl
        p.udev
      ];

      runScript = pkgs.writeShellScript "xplane-${edition}-launcher" ''
        export GIO_EXTRA_MODULES="${pkgs.glib-networking}/lib/gio/modules"
        INSTALL_DIR="$HOME/X-Plane-12-${edition}"
        GAME_BIN="$INSTALL_DIR/X-Plane-x86_64"

        if [ "''${1:-}" = "--installer" ] || [ ! -x "$GAME_BIN" ]; then
          if [ "''${1:-}" = "--installer" ]; then
            shift
          fi
          echo "Starting X-Plane 12 (${edition}) installer..."
          echo "Select '$INSTALL_DIR' as your install destination."
          exec "${installerRaw}/bin/xplane-installer" "$@"
        else
          cd "$INSTALL_DIR"
          exec "$GAME_BIN" "$@"
        fi
      '';
    };
in
pkgs.symlinkJoin {
  name = "xplane-12";
  paths =
    (lib.optional enableDemo (mkXplaneFhs "demo"))
    ++ (lib.optional enableFull (mkXplaneFhs "full"));
}
