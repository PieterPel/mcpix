{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.zed;
  contextFile = "AGENT.md";
  makeContextFile = globalCfg.rules != "" || cfg.rules != "";
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.zed = {
      userSettings = clib.convert.geminiToZed (
        clib.merge.mkMergedServerConfig {
          inherit
            globalCfg
            cfg
            pkgs
            mcp-servers-nix
            ;
        }
      );

      # WARNING: zed has no support for global rules it seems
      xdg.configFile.".zed/${contextFile}" = lib.mkIf (makeContextFile) {
        text = clib.merge.mkMergedRules {
          inherit globalCfg cfg;
        };
      };
    };
  };
}
