{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.gemini;
  mergedServers = lib.mkMerge globalCfg.globalServers cfg.servers;
  mcpConfig = inputs.mcp-servers-nix.lib.mkConfig pkgs mergedServers;
in
{
  config = lib.mkIf cfg.enable {
    programs.gemini.settings = mcpConfig;
  };
}
