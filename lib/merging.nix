{ lib }:
{
  mkMergedConfig =
    {
      globalCfg,
      cfg,
      pkgs,
      mcp-servers-nix,
    }:
    let
      mergedServers = lib.recursiveUpdate globalCfg.servers (cfg.servers or { });
      mcpConfig = mcp-servers-nix.lib.mkConfig pkgs mergedServers;
      result = if mergedServers == { } then { mcpServers = { }; } else mcpConfig;
    in
    result.mcpServers;
}
