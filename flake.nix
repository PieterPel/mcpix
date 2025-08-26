{
  description = "Home-manager module to configure MCP servers for all clients";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-unit = {
      url = "github:nix-community/nix-unit";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-unit.modules.flake.default
        inputs.git-hooks-nix.flakeModule
        ./modules/flake-parts
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs
        , config
        , ...
        }:
        {
          nix-unit.inputs = {
            # NOTE: a `nixpkgs-lib` follows rule is currently required
            # https://nix-community.github.io/nix-unit/examples/flake-parts.html
            inherit (inputs)
              nixpkgs
              flake-parts
              nix-unit
              git-hooks-nix
              mcp-servers-nix
              ;
          };

          _module.args.mcp-servers-nix = inputs.mcp-servers-nix;

          mcpix.settings = {
            servers = {
              programs = {
                fetch.enable = true;
              };
            };
            targets = {
              gemini-cli.enable = true;
            };
            rules = ''
              You are an expert on nix programming.
            '';
          };

          devShells.pre-commit = pkgs.mkShell {
            packages = [ pkgs.nix-unit ];
            inputsFrom = [ config.pre-commit.devShell ];
          };

          devShells.mcpix = config.mcpix.devShell;

          devShells.default = config.mcpix.devShell;

          pre-commit = {
            check.enable = false;
            settings = {
              hooks = {
                nixpkgs-fmt.enable = true;
                markdownlint.enable = true;
                mdformat.enable = true;
              };
            };
          };

          nix-unit = {
            tests = import ./tests { inherit pkgs inputs; };
            # NOTE: for some reason nix-unit is still fetching some stuff
            allowNetwork = true;

            # NOTE: very hacky workaround to get nix available in testing env
            package = pkgs.symlinkJoin {
              name = "nix-unit-with-nix";
              paths = [
                inputs.nix-unit.packages.${pkgs.system}.default
                pkgs.nix
              ];
            };
          };
        };

      flake =
        let
          # TODO: also allow for per-project settings using flake as input for dev flake/flake-part
          homeManagerModule = {
            imports = [ ./modules/home-manager ];
            _module.args.mcp-servers-nix = inputs.mcp-servers-nix;
          };

          flakeModule = ./modules/flake-parts;
        in
        {
          homeManagerModules.default = homeManagerModule;
          homeManagerModules.mcpix = homeManagerModule;

          flakeModules.default = flakeModule;
          flakeModules.mcpix = flakeModule;
        };
    };
}
