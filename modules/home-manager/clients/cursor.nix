{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.cursor;
  contextFile = "AGENTS.md";
  makeContextFile = globalCfg.rules != "" || cfg.rules != "";
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    home.file = {
      ".cursor/mcp.json" = clib.merge.mkMergedServers {
        inherit
          globalCfg
          cfg
          pkgs
          mcp-servers-nix
          ;
      };
    };

    # WARNING: This isn't supported yet it seems (https://docs.cursor.com/en/context/rules)
    ".cursor/${contextFile}" = lib.mkIf (makeContextFile) {
      text = clib.merge.mkMergedRules {
        inherit globalCfg cfg;
      };
    };
  };
}
