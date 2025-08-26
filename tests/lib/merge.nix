{ inputs
, lib
, pkgs
, ...
}:

let
  inherit (lib.merge) mkMergedRules mkMergedServers;
  mcp-servers-nix = inputs.mcp-servers-nix;
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
      pkgs = pkgs;
      mcp-servers-nix = mcp-servers-nix;
    };
    expected = {
      servers = { };
    };
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
      pkgs = pkgs;
      mcp-servers-nix = mcp-servers-nix;
    };
    expected = {
      servers = {
        programs = {
          fetch.enable = true;
        };
      };
    };
  };
}
