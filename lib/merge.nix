{ lib }:
let
  mkMergedServers =
    { globalCfg
    , cfg
    ,
    }:

    lib.recursiveUpdate globalCfg.servers (cfg.servers or { });

  mkMergedServerConfig =
    { globalCfg
    , cfg
    , pkgs
    , mcp-servers-nix
    ,
    }:
    let
      mergedServers = mkMergedServers globalCfg cfg;
      mcpConfigDrv = mcp-servers-nix.lib.mkConfig pkgs mergedServers;

      mergedServerConfig =
        if mergedServers == { } then
          { }
        else
          let
            # Read the JSON and strip store path contexts from the string
            # NOTE: this is due to a mistake in upstream
            jsonString = builtins.unsafeDiscardStringContext (builtins.readFile mcpConfigDrv);
            # Now parse the context-free JSON
            mcpConfigAttrs = builtins.fromJSON jsonString;
          in
          mcpConfigAttrs;
    in
    mergedServerConfig;

  # TODO: is this the merge we want?
  mkMergedRules =
    { globalCfg
    , cfg
    ,
    }:
    ''
      ${globalCfg.rules}

      ${cfg.rules}
    '';
in
{
  inherit mkMergedServers mkMergedServerConfig mkMergedRules;
}
