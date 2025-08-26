{ lib
, ...
}:

let
  inherit (lib.merge) mkMergedRules mkMergedServers;
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
}
