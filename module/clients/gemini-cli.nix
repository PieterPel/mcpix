{ config
, lib
, pkgs
, mcp-servers-nix
, ...
}:
let
  clib = import ../../lib { inherit lib; };
  globalCfg = config.programs.mcpix;
  cfg = config.programs.mcpix.targets.gemini-cli;
  mainCfg = config.programs.gemini-cli;

  defaultContextFile = "GEMINI.md";
  contextFile =
    if mainCfg.settings ? contextFileName then
      if builtins.isList mainCfg.settings.contextFileName then
        builtins.head mainCfg.settings.contextFileName
      else
        mainCfg.settings.contextFileName
    else
      defaultContextFile;
in
{
  config = lib.mkIf (cfg.enable && globalCfg.enable) {
    programs.gemini-cli.settings = clib.merge.mkMergedServers {
      inherit
        globalCfg
        cfg
        pkgs
        mcp-servers-nix
        ;
    };

    home.file.".gemini/${contextFile}" = clib.merge.mkMergedRules {
      inherit globalCfg cfg;
    };
  };
}
