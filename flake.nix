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
  };

  outputs =
    { self, ... }@inputs:

    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
      # TODO: also allow for per-project settings using flake as input for dev flake

      mcpixModule = {
        imports = [ ./module ];
        _module.args.mcp-servers-nix = inputs.mcp-servers-nix;
      };
    in
    {
      # TODO: also nixos and nix-darwin?
      homeManagerModules.default = mcpixModule;
      homeManagerModules.mcpix = mcpixModule;
    };
}
