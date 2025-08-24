{ lib, ... }:
let
  types = import ./types.nix { inherit lib; };
in
{
  inherit types;
}
