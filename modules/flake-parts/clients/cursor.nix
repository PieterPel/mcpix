{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.mcpix.settings;
  cfg = config.mcpix.settings.targets.cursor;
  serverSettings = clib.merge.mkMergedServerConfig {
    inherit
      globalCfg
      cfg
      pkgs
      mcp-servers-nix
      ;
  };
  finalSettings = lib.recursiveUpdate serverSettings cfg.extraSettings;
  settingsFile = pkgs.writeText "cursor-settings.json" (builtins.toJSON finalSettings);
in
{
  config.mcpix.settings.targets.cursor.settingsFile =
    lib.mkIf (cfg.enable) settingsFile;
}
