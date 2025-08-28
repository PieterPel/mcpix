{ lib
, pkgs
, mcp-servers-nix
, ...
}:

{
  convert = import ./convert.nix { inherit lib; };
  merge = import ./merge.nix { inherit lib pkgs mcp-servers-nix; };

  # WARNING: this doesnt work in CI for some unknown reason
  # config = import ./config.nix { inherit lib pkgs mcp-servers-nix; };
}
