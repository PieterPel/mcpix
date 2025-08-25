{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.claude-code;
  contextFile = "CLAUDE.md";
  makeContextFile = globalCfg.rules != "" || cfg.rules != "";
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.claude-code.settings = clib.convert.geminiToClaudeCode (
      clib.merge.mkMergedServers {
        inherit
          globalCfg
          cfg
          pkgs
          mcp-servers-nix
          ;
      }
    );

    home.file.".claude/${contextFile}" = lib.mkIf (makeContextFile) {
      text = clib.merge.mkMergedRules {
        inherit globalCfg cfg;
      };
    };
  };
}
