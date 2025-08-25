{ lib, ... }:

let
  inherit (lib.mcpix) convert;
in
{
  "geminiToOpenCode-local" = {
    expr = convert.geminiToOpenCode {
      mcpServers = {
        testServer = {
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
    expected = {
      mcp = {
        testServer = {
          type = "local";
          command = [ "echo" "hello" ];
          enabled = true;
        };
      };
    };
  };
}
