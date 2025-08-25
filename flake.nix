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
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.nix-unit.modules.flake.default
        inputs.git-hooks-nix.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { config, ... }:
        {
          nix-unit.inputs = {
            # NOTE: a `nixpkgs-lib` follows rule is currently required
            # https://nix-community.github.io/nix-unit/examples/flake-parts.html
            inherit (inputs) nixpkgs flake-parts nix-unit;
          };

          devShells.default = config.pre-commit.devShell;

          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                nixpkgs-fmt.enable = true;
                markdownlint.enable = true;
                mdformat.enable = true;
              };
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
        in
        {
          homeManagerModules.default = homeManagerModule;
          homeManagerModules.mcpix = homeManagerModule;

          flakeModules.default = { };
          flakeModules.mcpix = { };
        };
    };
}
