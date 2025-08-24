{ lib, ... }:
let
  targets = [ "gemini-cli" ];
  clib = import ../lib { inherit lib; };

  targetOptions = lib.genAttrs targets (
    targetName:
    lib.mkOption {
      type = clib.types.target;
      default = { };
      description = "MCP config for target ${targetName}";
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
      description = "MCP configuration per target";
    };

    globalServers = lib.mkOption {
      type = lib.types.attrs;
      default = { };
      description = "Global MCP servers applied to all enabled targets";
    };
  };
}
