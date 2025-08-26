{ lib, ... }:

{
  testGeminiToOpenCodeLocal = {
    expr = lib.convert.geminiToOpenCode {
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
          command = [
            "echo"
            "hello"
          ];
          enabled = true;
        };
      };
    };
  };
}
