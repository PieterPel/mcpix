{
  config,
  lib,
  pkgs,
  mcp-servers-nix,
  ...
}:
let
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.gemini-cli;
  mergedServers = lib.mkMerge [
    globalCfg.globalServers
    cfg.servers
  ];
  mcpConfig = mcp-servers-nix.lib.mkConfig pkgs mergedServers;
in
{
  config = lib.mkIf cfg.enable {
    programs.gemini-cli.settings = mcpConfig;
  };
}
