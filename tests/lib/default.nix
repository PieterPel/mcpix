{ pkgs, ... }:

{
  convert = import ./convert.nix { lib = pkgs.lib; };
}
