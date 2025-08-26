{ pkgs, inputs, ... }:

let
  mcpixLib = import ../lib { lib = pkgs.lib; };
in
{
  libTests = import ./lib {
    lib = mcpixLib;
    inherit inputs pkgs;
  };
}
