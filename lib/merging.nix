{ lib }:
{
  mkMergedConfig = { globalCfg, cfg, pkgs, mcp-servers-nix }:
    let
      mergedServers = lib.recursiveUpdate globalCfg.servers (cfg.servers or {});
      mcpConfig = mcp-servers-nix.lib.mkConfig pkgs mergedServers;
    in
    if mergedServers == {} then
      { servers = {}; }
    else
      mcpConfig;
}
