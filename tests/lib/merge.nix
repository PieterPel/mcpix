{ lib
, pkgs
, inputs
, ...
}:

let
  inherit (lib.merge) mkMergedRules mkMergedServers mkMergedServerConfig;
  mcp-servers-nix = inputs.mcp-servers-nix;
  mcpServerFetch = inputs.mcp-servers-nix.packages.${pkgs.system}.mcp-server-fetch;
in
{
  testMkMergedRulesSimple = {
    expr = mkMergedRules {
      globalCfg = {
        rules = "global rules";
      };
      cfg = {
        rules = "local rules";
      };
    };
    expected = ''
      global rules

      local rules
    '';
  };

  testMkMergedServersEmpty = {
    expr = mkMergedServers {
      globalCfg = {
        servers = { };
      };
      cfg = {
        servers = { };
      };
    };
    expected = { };
  };

  testMkMergedServersOnlyGlobal = {
    expr = mkMergedServers {
      globalCfg = {
        servers = {
          programs.fetch.enable = true;
        };
      };
      cfg = {
        servers = { };
      };
    };
    expected = {
      programs = {
        fetch.enable = true;
      };
    };
  };

  testMkMergedServersOnlyLocal = {
    expr = mkMergedServers {
      globalCfg = {
        servers = { };
      };
      cfg = {
        servers = {
          programs.fetch.enable = true;
        };
      };
    };
    expected = {
      programs = {
        fetch.enable = true;
      };
    };
  };

  testMkMergedServerConfig = {
    expr = mkMergedServerConfig {
      globalCfg = {
        servers = {
          programs.fetch.enable = true;
        };
      };
      cfg = {
        servers = {
          settings.servers.mock = {
            command = "echo";
            args = [ "hello" ];
          };
        };
      };
      inherit pkgs mcp-servers-nix;
    };
    expected = {
      mcpServers = {
        fetch = {
          command = inputs.nixpkgs.lib.getExe mcpServerFetch;
          args = [ ];
          env = { };
        };
        mock = {
          command = "echo";
          args = [ "hello" ];
        };
      };
    };
  };
}
