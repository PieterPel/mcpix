{
  lib,
  ...
}:
let
  t = lib.types;

  target = t.submodule {
    options = {
      enable = lib.mkOption {
        type = t.bool;
        default = true;
        description = "Whether to enable configuration for this target";
      };

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
    };
  };
in
{
  inherit target;
}
