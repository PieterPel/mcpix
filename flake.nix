{
  description = "Home-manager module and per-project config to configure MCP servers for all clients";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs =
    { self, ... }@inputs:
    inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      # TODO: also allow for per-project settings using flake as input for dev flake
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      mcpixModule = {
        imports = [ ./module ];
      };
    in
    {
      # TODO: also nixos and nix-darwin?
      homeManagerModules.default = mcpixModule;
      homeManagerModules.mcpix = mcpixModule;

      checks = import ./tests {
        inherit pkgs inputs;
        home-manager = inputs.home-manager;
      };
    });
}
