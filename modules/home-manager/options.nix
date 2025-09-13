{ lib, ... }:
let
  clib = import ../lib { inherit lib; };
in
{
  options.programs.mcpix = {
    enable = lib.mkEnableOption "mcpix";

    targets = lib.mkOption {
      type = lib.types.submodule {
        options = clib.types.homeManagerTargetOptions;
      };
      default = { };
      description = "Configuration per target";
    };

    rules = clib.types.rules;

    servers = clib.types.servers;
  };
}
