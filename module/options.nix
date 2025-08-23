{ lib, ... }:
let
  targets = [ "gemini" ];
  clib = import ../lib { inherit lib; };

  targetOptions = lib.genAttrs targets (targetName: {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable MCP configuration for ${targetName}";
    };

    servers = lib.mkOption {
      type = lib.types.attrsOf clib.types.mcp;
      default = { };
      description = "MCP servers to configure for ${targetName}";
      example = {
        my-server = {
          command = "python";
          args = [
            "-m"
            "my_mcp_server"
          ];
          env = {
            DEBUG = "1";
          };
        };
      };
    };
  });
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
      type = lib.types.attrsOf clib.types.mcp;
      default = { };
      description = "Global MCP servers applied to all enabled targets";
    };
  };
}
