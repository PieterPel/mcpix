{ lib }:
let
  mkMergedServers =
    { globalCfg
    , cfg
    ,
    }:

    lib.recursiveUpdate globalCfg.servers (cfg.servers or { });

  mkConfigNoDrv =
    mcp-servers-nix: pkgs: config:
    (mcp-servers-nix.lib.evalModule pkgs config).config.settings.servers;

  mkMergedServerConfig =
    { globalCfg
    , cfg
    , pkgs
    , mcp-servers-nix
    ,
    }:
    let
      mergedServers = mkMergedServers { inherit globalCfg cfg; };
      mergedServerConfig =
        if mergedServers == { } then { } else mkConfigNoDrv mcp-servers-nix pkgs mergedServers;
    in
    {
      mcpServers = mergedServerConfig;
    };

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
  inherit
    mkMergedServers
    mkMergedServerConfig
    mkMergedRules
    mkConfigNoDrv
    ;
}
