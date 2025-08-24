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

      result =
        if mergedServers == { } then
          { servers = { }; }
        else
          let
            # Read the JSON and strip ALL store path contexts from the string
            jsonString = builtins.unsafeDiscardStringContext (builtins.readFile mcpConfigDrv);
            # Now parse the context-free JSON
            mcpConfigAttrs = builtins.fromJSON jsonString;
          in
          mcpConfigAttrs;
    in
    result;
}
