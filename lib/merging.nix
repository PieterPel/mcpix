{ lib }:
{
  mkMergedConfig =
    {
      globalCfg,
      cfg,
      pkgs,
      mcp-servers-nix,
      existingConfig ? { },
    }:
    let
      mergedServers = lib.recursiveUpdate globalCfg.servers (cfg.servers or { });
      mcpConfig = mcp-servers-nix.lib.mkConfig pkgs mergedServers;
      result = if mergedServers == { } then { servers = { }; } else mcpConfig;
    in
    lib.recursiveUpdate result existingConfig;
}
