{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.mcpix.settings;
  cfg = config.mcpix.settings.targets.gemini-cli;
  serverSettings = clib.merge.mkMergedServerConfig {
    inherit
      globalCfg
      cfg
      pkgs
      mcp-servers-nix
      ;
  };
  finalSettings = lib.recursiveUpdate serverSettings cfg.extraSettings;
  settingsFile = pkgs.writeText "gemini-cli-settings.json" (builtins.toJSON finalSettings);

in
{
  config.mcpix.settings.targets.gemini-cli.settingsFile = lib.mkIf (cfg.enable) settingsFile;
}
