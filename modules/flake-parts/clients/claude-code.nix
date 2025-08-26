{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.mcpix.settings;
  cfg = config.mcpix.settings.targets.claude-code;
  serverSettings = clib.merge.mkMergedServerConfig {
    inherit
      globalCfg
      cfg
      pkgs
      mcp-servers-nix
      ;
  };
  finalSettings = lib.recursiveUpdate serverSettings cfg.extraSettings;
  convertedSettings = clib.convert.geminiToClaudeCode finalSettings;
  settingsFile = pkgs.writeText "claude-code-settings.json" (builtins.toJSON convertedSettings);
in
{
  config.mcpix.settings.targets.claude-code.settingsFile =
    lib.mkIf (cfg.enable) settingsFile;
}

