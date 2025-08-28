{ lib
, pkgs
, mcp-servers-nix
, ...
}:

{
  convert = import ./convert.nix { inherit lib pkgs; };
  merge = import ./merge.nix { inherit lib pkgs mcp-servers-nix; };
  config = import ./config.nix { inherit lib pkgs mcp-servers-nix; };
}
