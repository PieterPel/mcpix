{ lib
, pkgs
, mcp-servers-nix
, ...
}:

let
  inherit (lib.merge) mkMergedRules mkMergedServers mkMergedServerConfig;
  mcpServerGit = mcp-servers-nix.packages.${pkgs.system}.mcp-server-git;
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
          programs.git.enable = true;
        };
      };
      cfg = {
        servers = { };
      };
    };
    expected = {
      programs = {
        git.enable = true;
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
          programs.git.enable = true;
        };
      };
    };
    expected = {
      programs = {
        git.enable = true;
      };
    };
  };

  testMkMergedServerConfig = {
    expr = mkMergedServerConfig {
      globalCfg = {
        servers = {
          programs.git.enable = true;
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
        git = {
          command = pkgs.lib.getExe mcpServerGit;
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
