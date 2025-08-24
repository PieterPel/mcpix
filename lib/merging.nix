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
      # Convert any remaining store path references to strings
      result =
        if mergedServers == { } then
          { servers = { }; }
        else
          lib.mapAttrsRecursive (
            path: value:
            # Force conversion of store paths to plain strings
            if builtins.isString value && lib.hasInfix "/nix/store" value then
              builtins.unsafeDiscardStringContext value
            else
              value
          ) mcpConfig;
    in
    result;
}
