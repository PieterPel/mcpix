# mcpix: Nix configuration of Model Context Protocol servers and .md files

Home-manager and flake-parts modules to universally configure AI-integrated editors

______________________________________________________________________

## Reasons you might want to use mcpix

- You are part of a developing team that uses different editors,
  but want to use the same tools.
- You use multiple editors yourself and don't want to duplicate AI configuration.
- You are tired of symlinking your .md files.
- You love nix and want to configure as much as possible with it.
- You are on NixOS and don't want to manually package MCP servers (uses `mcp-servers-nix`).
- Supported editors: gemini-cli, claude-code, opencode, zed, cursor.

## How to use mcpix

- Home-manager

If you want to configure your own editors at a user level,
you can use the home-manager module.
Since some editor home-manager programs are only on unstable,
you have to be on unstable too or use an overlay.
Zed and cursor currently do not have user-level .md file support.

Add mcpix to your flake inputs as follows:

```nix
# flake.nix
{
    inputs =  {
        nixpkgs = {
            url = "github:nixos/nixpkgs?ref=nixos-unstable";
        };

        home-manager = {
          url = "github:nix-community/home-manager";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        mcpix = {
          url = "github:PieterPel/mcpix/main";
          inputs.nixpkgs.follows = "nixpkgs";
        };
    };

}

```

Now somewhere in home-manager modules, e.g. `home.nix`:

```nix
{
    mcpix, # Or use `inputs`, you know how this works
    ...
}
:
{
    imports = [
        mcpix.homeManagerModules.mcpix
    ];

    programs = {
        mcpix = {
            enable = true;

            # Configure rules for all your editors
            rules = "I can be a very long .md file here";

            # Configure mcp servers for all your editors
            servers = {
                programs.git.enable = true;
            };

            # And configuration per target 
            targets.gemini-cli = {
                rules = "Never mention google in your output";
                servers = {
                    programs.filesystem.enable = true;
                };
            };
        };

        # You still need to enable the programs for your editors
        # (Except for cursor as it does not have a home-manager module)
        gemini-cli.enable = true;
    };
}

```

NOTE: for more elaborate documentation on the server configugration,
I refer you to the upstream
[mcp-servers-nix](https://github.com/natsukium/mcp-servers-nix) repo.
You can make custom servers and use pre-defined ones.

- Flake-parts

If you want to configure the editors for a project,
you can use the flake-part module for your dev flake.

```nix
# flake.nix
{
    inputs =  {
        nixpkgs = {
            url = "github:nixos/nixpkgs?ref=nixos-unstable";
        };

        mcpix = {
          url = "github:PieterPel/mcpix/main";
          inputs.nixpkgs.follows = "nixpkgs";
        };

        flake-parts = {
          url = "github:hercules-ci/flake-parts";
        };
    };

    outputs = {
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.mcpix.flakeModules.mcpix
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          config,
          ...
        }:
        {
          mcpix.settings = {
            # Here are the global MCP servers
            servers = {
              programs = {
                git.enable = true;
              };
            };
            targets = {
              gemini-cli.enable = true;
              zed = {
                enable = true;
                # You also have per client server cofiguration here
                servers = {
                  programs.filesystem.enable = true;
                }
                extraSettings = {
                  # Here you can pass extra JSON settings 
                };
              };
              opencode.enable = true;
              cursor.enable = false;
              claude-code.enable = true;
            };
            # But rules are only global
            rules = ''
              You are an expert on nix programming.
            '';
          };

          # This devshell automatically symlinks the configuration files 
          # to the correct place
          devShells.mcpix = config.mcpix.devShell;

          devShells.default = config.mcpix.devShell
        };
}

```

## Contributing

Contributions are very welcome!

- Want a new feature? Open an issue
- Found a bug? Open an issue
- Want to fix something? Open an issue and/or Open a pull request

More info can be found in CONTRIBUTING.md

## License

Please see the LICENSE file (BSD-3 clause)

______________________________________________________________________

<!-- markdownlint-disable MD033 -->

<picture>
  <source
    media="(prefers-color-scheme: dark)"
    srcset="
      https://api.star-history.com/svg?repos=PieterPel/mcpix&type=Date&theme=dark
    "
  />
  <source
    media="(prefers-color-scheme: light)"
    srcset="
      https://api.star-history.com/svg?repos=PieterPel/mcpix&type=Date
    "
  />
  <img
    alt="Star History Chart"
    src="https://api.star-history.com/svg?repos=PieterPel/mcpix&type=Date"
  />
</picture>
