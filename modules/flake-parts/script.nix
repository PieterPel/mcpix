{ lib
, pkgs
, config
, ...
}:
let
  clib = import ../../lib { inherit lib; };

  # TODO: integrate better with options?
  settingsLocations = {
    gemini-cli = ".gemini/settings.json";
  };
  rulesLocations = {
    gemini-cli = "GEMINI.md";
  };

  makeSymlinks =
    client:
    let
      settingsLocation = settingsLocations.${client};
      settingsDir = builtins.dirOf settingsLocation;
      rulesLocation = rulesLocations.${client};
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

  enabledTargets = lib.filter
    (
      client: config.mcpix.settings.targets.${client}.enable
    )
    clib.types.targets;

  # installationScript = lib.concatMapStringsSep "\n" makeSymlinks enabledTargets;
  installationScript = "";
in
{
  config.mcpix = {
    devShell = pkgs.mkShell {
      shellHook = installationScript;
    };
  };
}
