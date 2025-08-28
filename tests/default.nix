{ pkgs, mcp-servers-nix, ... }:

let
  mcpixLib = import ../modules/lib { lib = pkgs.lib; };
in
{
  libTests = import ./lib {
    lib = mcpixLib;
    inherit pkgs mcp-servers-nix;
  };
}
