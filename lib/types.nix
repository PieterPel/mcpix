{ lib
, ...
}:
let
  traceLib = builtins.trace "lib: ${builtins.toJSON (builtins.attrNames lib)}" lib;
  traceBoolType = builtins.trace "lib.types.bool.deprecationMessage: ${builtins.toJSON (lib.types.bool.deprecationMessage or null)}" lib.types.bool;
  t = lib.types;

  rules = lib.mkOption {
    type = t.lines;
    default = "";
    description = "AI rules in .md format";

  };

  servers = lib.mkOption {
    type = t.attrs;
    default = { };
    description = "MCP servers configuration (same format as mcp-servers-nix)";
    example = {
      programs = {
        filesystem = {
          enable = true;
          args = [ "." ];
        };
        fetch.enable = true;
      };
    };
  };

  extraSettings = lib.mkOption {
    type = t.attrs;
    default = { };
    description = "Extra json settings for client";
  };

  settingsFile = lib.mkOption {
    type = t.nullOr lib.types.package;
    default = null;
    readOnly = true;
  };

  homeManagerTargetEnable = lib.mkOption {
    type = t.bool;
    default = true;
    description = "Whether to enable configuration for this target";
  };

  flakePartsTargetEnable = lib.mkOption {
    type = t.bool;
    default = false; # NOTE: don't clutter workspace by default
    description = "Whether to enable configuration for this target";
  };

  homeManagerTarget = t.submodule {
    options = {
      inherit homeManagerTargetEnable rules servers;
    };
  };

  flakePartsTarget = t.submodule {
    options = {
      # NOTE: per-target rules would get very unergonomical since clients share .md files
      inherit
        flakePartsTargetEnable
        servers
        extraSettings
        settingsFile
        ;
    };
  };

  targets = [
    "gemini-cli"
    "opencode"
    "claude-code"
    "cursor"
    "zed"
  ];

  mkTargetOptions =
    type:
    lib.genAttrs targets (
      targetName:
      lib.mkOption {
        inherit type;
        default = { };
        description = "Configuration for target ${targetName}";
      }
    );

  homeManagerTargetOptions = mkTargetOptions homeManagerTarget;
  flakePartsTargetOptions = mkTargetOptions flakePartsTarget;
in
{
  inherit
    homeManagerTargetOptions
    flakePartsTargetOptions
    homeManagerTarget
    flakePartsTarget
    rules
    servers
    targets
    ;
}
