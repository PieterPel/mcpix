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
      mcpConfigDrv = mcp-servers-nix.lib.mkConfig pkgs mergedServers;
      # Read the JSON file from the derivation and parse it
      mcpConfigAttrs =
        if mergedServers == { } then
          { servers = { }; }
        else
          builtins.fromJSON (builtins.readFile mcpConfigDrv);

      # Now clean up the store paths in the parsed attributes
      result = lib.mapAttrsRecursive (
        path: value:
        # Force conversion of store paths to plain strings
        if builtins.isString value && lib.hasInfix "/nix/store" value then
          builtins.unsafeDiscardStringContext value
        else
          value
      ) mcpConfigAttrs;
    in
    result;
}
