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
  cfg = config.programs.mcpix.targets.opencode;
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.opencode.settings = clib.convert.geminiToOpenCode (clib.mkMergedConfig {
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
