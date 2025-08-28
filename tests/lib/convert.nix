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

  testGeminiToClaudeCodeLocal = {
    expr = lib.convert.geminiToClaudeCode {
      mcpServers = {
        testServer = {
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
    expected = {
      mcpServers = {
        testServer = {
          type = "stdio";
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
  };

  testGeminiToZed = {
    expr = lib.convert.geminiToZed {
      mcpServers = {
        testServer = {
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
    expected = {
      context_servers = {
        testServer = {
          source = "custom";
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
  };

  testGeminiToOpenCodeRemote = {
    expr = lib.convert.geminiToOpenCode {
      mcpServers = {
        testServer = {
          url = "https://example.com";
        };
      };
    };
    expected = {
      mcp = {
        testServer = {
          type = "remote";
          url = "https://example.com";
          enabled = true;
        };
      };
    };
  };

  testGeminiToClaudeCodeRemote = {
    expr = lib.convert.geminiToClaudeCode {
      mcpServers = {
        testServer = {
          url = "https://example.com";
        };
      };
    };
    expected = {
      mcpServers = {
        testServer = {
          type = "sse";
          url = "https://example.com";
        };
      };
    };
  };
}
