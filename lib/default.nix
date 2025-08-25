{ lib, ... }:
let
  types = import ./types.nix { inherit lib; };
  merging = import ./merging.nix { inherit lib; };
  convert = import ./convert.nix { inherit lib; };
in
{
  inherit types;
  inherit (merging) mkMergedConfig;
  inherit convert;
}

