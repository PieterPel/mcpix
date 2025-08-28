{ lib
, pkgs
, config
, ...
}:
let
  clib = import ../lib { inherit lib; };

  makeSymlinks =
    client:
    let
      settingsLocation = config.mcpix.settings.targets.${client}.mcpSettingsLocation;
      settingsDir = builtins.dirOf settingsLocation;
      rulesLocation = config.mcpix.settings.targets.${client}.rulesLocation;
      rulesDir = builtins.dirOf rulesLocation;
      makeRules = config.mcpix.rulesFile != null;
    in
    ''
      echo "Creating symlink for ${client} settings"
      mkdir -p ${settingsDir}

      rm -f ${settingsLocation}

      ln -s ${config.mcpix.settings.targets.${client}.settingsFile} ${settingsLocation}

      ${lib.optionalString makeRules ''
        echo "Creating symlink for ${client} rules"
        mkdir -p ${rulesDir}
        rm -f ${rulesLocation}
        ln -s ${config.mcpix.rulesFile} ${rulesLocation}
      ''}
    '';

in
{
  config.mcpix =

    let
      enabledTargets = lib.filter
        (
          client: config.mcpix.settings.targets.${client}.enable
        )
        clib.types.targets;

      installationScript = lib.concatMapStringsSep "\n" makeSymlinks enabledTargets;
    in
    {
      devShell = pkgs.mkShell {
        shellHook = installationScript;
      };
    };
}
