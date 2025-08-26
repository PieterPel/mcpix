{ lib
, ...
}:
let
  t = lib.types;

  rules = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "AI rules for this target";

  };

  servers = lib.mkOption {
    type = t.attrs;
    default = { };
    description = "MCP servers configuration for this target (same format as mcp-servers-nix)";
    example = {
      programs = {
        filesystem = {
          enable = true;
          args = [ "." ];
        };
        fetch.enable = true;
      };
    };
  };

  enable = lib.mkOption {
    type = t.bool;
    default = true;
    description = "Whether to enable configuration for this target";
  };

  target = t.submodule {
    options = {
      inherit enable rules servers;
    };
  };
in
{
  inherit target;
}
