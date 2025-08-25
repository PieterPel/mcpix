{ lib, ... }:
let
  targets = [
    "gemini-cli"
    "opencode"
    "claude-code"
  ];
  clib = import ../lib { inherit lib; };

  targetOptions = lib.genAttrs targets (
    targetName:
    lib.mkOption {
      type = clib.types.target;
      default = { };
      description = "Configuration for target ${targetName}";
    }
  );
in
{
  options.programs.mcpix = {
    enable = lib.mkEnableOption "mcpix";

    targets = lib.mkOption {
      type = lib.types.submodule {
        options = targetOptions;
      };
      default = { };
      description = "Configuration per target";
    };

    rules = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "Global AI rules applied to all enabled targets";
    };

    servers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Global MCP servers applied to all enabled targets";
    };
  };
}
