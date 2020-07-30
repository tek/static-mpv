{}:
let
  static-haskell-nix = fetchTarball https://github.com/nh2/static-haskell-nix/archive/master.tar.gz;
  pkgs = import "${static-haskell-nix}/nixpkgs.nix";

  stack2nix-script = import "${static-haskell-nix}/static-stack2nix-builder/stack2nix-script.nix" {
    inherit pkgs;
    stack-project-dir = toString ./.;
    hackageSnapshot = "2020-07-30T00:00:00Z";
  };
in {
  inherit stack2nix-script;
}
