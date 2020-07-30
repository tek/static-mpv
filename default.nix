{}:
let
  # static-haskell-nix = fetchTarball https://github.com/nh2/static-haskell-nix/archive/master.tar.gz;
  static-haskell-nix = ../../nix/static-haskell-nix;

  mpvArgs = {
    alsaSupport = false;
    youtubeSupport = false;
    archiveSupport = false;
    bluraySupport = false;
    bs2bSupport = false;
    cacaSupport = false;
    cmsSupport = false;
    jackaudioSupport = false;
    libpngSupport = true;
    openalSupport = false;
    pulseSupport = false;
    rubberbandSupport = false;
    sambaSupport = false;
    screenSaverSupport = false;
    sdl2Support = false;
    sndioSupport = false;
    speexSupport = false;
    theoraSupport = false;
    vaapiSupport = false;
    vapoursynthSupport = false;
    vdpauSupport = false;
    xineramaSupport = false;
    xvSupport = false;
    zimgSupport = false;
    cddaSupport = false;
    drmSupport = false;
    dvdnavSupport = false;
    waylandSupport = false;
    vulkanSupport = false;
  };

  overlay = self: super: {
    gnutls = super.gnutls.overrideAttrs (_: { doCheck = false; });
    mpv = super.mpv.override mpvArgs;
    haskell = super.haskell // {
      packages = super.haskell.packages // {
        ghc865 = super.haskell.packages.ghc865.override {
          overrides = _: superH: {
            static-mpv = self.haskell.lib.overrideCabal superH.static-mpv (_: {
              configureFlags = [
                "--extra-include-dirs=${self.mpv}/include"
                "--extra-lib-dirs=${self.mpv}/lib"
              ];
            });
          };
        };
      };
    };
  };
  builder = import "${static-haskell-nix}/static-stack2nix-builder/default.nix" {
    normalPkgs = (import "${static-haskell-nix}/nixpkgs.nix").appendOverlays [overlay];
    stack2nix-output-path = "${./stack2nix-output.nix}";
    compiler = "ghc865";
    cabalPackageName = "static-mpv";
  };
  pkgs = builder.haskell-static-nix_output.pkgs.appendOverlays [overlay];
  deps = with pkgs; [
    mpv
    alsaLib
    lua
    libcaca
    libdrm
    libdvdnav
    libX11
    libXext
    libXinerama
    libXrandr
    libXv
    libpng
    libpng12
    libpng_apng
  ];
  libs = "--libs mpv lua libdrm libpng";
in
  pkgs.haskell.lib.appendConfigureFlag (
    pkgs.staticHaskellHelpers.addStaticLinkerFlagsWithPkgconfig builder.static_package deps libs
  ) "--ld-option=-Wl,--start-group --ld-option=-Wl,-lstdc++"
