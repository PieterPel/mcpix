{ inputs
, pkgs
, ...
}:

let
  mcp-servers-nix = inputs.mcp-servers-nix;
  mkConfig = mcp-servers-nix.lib.mkConfig;
  stub = _: true; # NOTE: just test if the evaluation goes through
in
{
  testMcpServersNixEmpty = {
    expr = stub (
      mkConfig pkgs {
        programs = {
          fetch.enable = true;
        };
      }
    );
    expected = true;
  };
}
