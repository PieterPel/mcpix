{ lib
, inputs
, pkgs
, ...
}:

{
  convert = import ./convert.nix { inherit lib; };
  merge = import ./merge.nix { inherit lib inputs pkgs; };
  config = import ./config.nix { inherit lib inputs pkgs; };
}
