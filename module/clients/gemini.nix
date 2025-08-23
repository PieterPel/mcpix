{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.mcpix.targets.gemini;
in
{
  config = lib.mkIf cfg.enable {
    programs.gemini.settings = {
      # TODO: fill in
    };
  };
}
