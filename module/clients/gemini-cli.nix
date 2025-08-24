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
  cfg = config.programs.mcpix.targets.gemini-cli;
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.gemini-cli.settings = clib.mkMergedConfig {
      inherit globalCfg cfg pkgs mcp-servers-nix;
    };
  };
}
