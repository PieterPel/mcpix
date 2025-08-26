{ config, lib, pkgs, ... }:
let
  makeRules = config.mcpix.settings.rules != "";
  rulesFile = pkgs.writeText "rules.md" config.mcpix.settings.rules;
in
{
  config.mcpix = lib.mkIf (makeRules) {
    inherit rulesFile;
  };
}
