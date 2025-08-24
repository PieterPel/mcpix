{
  description = "Home-manager module and per-project config to configure MCP servers for all clients";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
    };
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
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
        extraSpecialArgs = { inherit inputs; };
      };
    in
    {
      # TODO: also nixos and nix-darwin?
      homeManagerModules.default = mcpixModule;
      homeManagerModules.mcpix = mcpixModule;
    };
}
