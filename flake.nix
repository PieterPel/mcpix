{
  description = "Home-manager module to configure MCP servers for all clients";

  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs?ref=nixos-unstable";
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
    in
    {
      # TODO: also nixos and nix-darwin?
      homeModules.default = import ./module;
      homeModules.mcp-config-nix = self.homeModules.default;
    };
}
