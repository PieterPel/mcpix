# In this module we define the json-like derivations for all clients
{ ... }:
{
  imports = [
    ./gemini-cli.nix
    ./opencode.nix
    ./zed.nix
    ./cursor.nix
    ./claude-code.nix
  ];
}
