{
  description = "mcpix integration test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mcpix.url = "path:../..";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      flake = {
        homeConfigurations = inputs.nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ] (system:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          in
          {
            "test-user" = inputs.home-manager.lib.homeManagerConfiguration {
              inherit pkgs;
              modules = [
                inputs.mcpix.homeManagerModules.mcpix
                ({
                  home.stateVersion = "23.11";
                  home.username = "test-user";
                  home.homeDirectory = "/home/test-user";
                  nixpkgs.config.allowUnfree = true;
                  programs.mcpix = {
                    enable = true;
                    rules = "You are a helpful assistant.";
                    servers = {
                      programs.git.enable = true;
                    };
                    targets = {
                      gemini-cli.enable = true;
                      claude-code.enable = true;
                      opencode.enable = true;
                      zed.enable = true;
                    };
                  };

                  # Enable the programs for your editors
                  programs.gemini-cli.enable = true;
                  programs.claude-code.enable = true;
                  programs.opencode.enable = true;
                  programs.zed-editor.enable = true;
                })
              ];
            };
          }
        );
      };
    };
}
