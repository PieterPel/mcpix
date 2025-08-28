{ lib, ... }:
let
  clib = import ../lib { inherit lib; };
in
{
  options.programs.mcpix = {
    enable = lib.mkEnableOption "mcpix";

    targets = lib.mkOption {
      type = lib.types.submodule {
        options = clib.homeManagerTargetOptions;
      };
      default = { };
      description = "Configuration per target";
    };

    rules = clib.rules;

    servers = clib.servers;
  };
}
