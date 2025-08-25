{
  config,
  lib,
  pkgs,
  mcp-servers-nix,
  ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.claude-code;
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.claude-code.settings = clib.convert.geminiToClaudeCode (
      clib.mkMergedConfig {
        inherit
          globalCfg
          cfg
          pkgs
          mcp-servers-nix
          ;
      }
    );
  };
}
