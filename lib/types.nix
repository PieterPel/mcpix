{
  lib,
  ...
}:
let
  t = lib.types;
in
{
  mcp = t.submodule {
    options = {
      command = lib.mkOption {
        type = t.str;
        description = "The command to execute for the MCP server";
        example = "python";
      };

      args = lib.mkOption {
        type = t.listOf t.str;
        default = [];
        description = "Arguments to pass to the MCP server command";
        example = [ "-m" "my_mcp_server" "--port" "8080" ];
      };

      env = lib.mkOption {
        type = t.attrsOf t.str;
        default = {};
        description = "Environment variables for the MCP server";
        example = {
          PYTHONPATH = "/path/to/modules";
          DEBUG = "1";
        };
      };
    };
  };
}
