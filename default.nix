{}:
let
  static-haskell-nix = fetchTarball https://github.com/nh2/static-haskell-nix/archive/master.tar.gz;

  overlay = self: super: {
    gnutls = super.gnutls.overrideAttrs (_: { doCheck = false; });
    mpv = super.mpv.override { sambaSupport = false; youtubeSupport = false; };
  };
  builder = import "${static-haskell-nix}/static-stack2nix-builder/default.nix" {
    normalPkgs = (import "${static-haskell-nix}/nixpkgs.nix").appendOverlays [overlay];
    stack2nix-output-path = "${./stack2nix-output.nix}";
    compiler = "ghc865";
    cabalPackageName = "static-mpv";
  };
  pkgs = builder.haskell-static-nix_output.pkgs.appendOverlays [overlay];
in 
  pkgs.haskell.lib.appendConfigureFlag (
    pkgs.staticHaskellHelpers.addStaticLinkerFlagsWithPkgconfig builder.static_package [pkgs.mpv] "--libs libmpv"
  ) "--ld-option=-Wl,--start-group --ld-option=-Wl,-lstdc++"
