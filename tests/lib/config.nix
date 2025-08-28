{ pkgs
, mcp-servers-nix
, ...
}:

let
  mkConfig = mcp-servers-nix.lib.mkConfig;
  stub = input: input != null; # NOTE: just test if the evaluation goes through
in
{
  testMcpServersNixEmpty = {
    expr = stub (
      mkConfig pkgs {
        programs = { };
        # NOTE: without this, there is an error
        settings.servers = { };
      }
    );
    expected = true;
  };

  testMcpServersNixFetch = {
    expr = stub (
      mkConfig pkgs {
        programs = {
          git.enable = true;
        };
      }
    );
    expected = true;
  };

  testMcpServersNixCustom = {
    expr = stub (
      mkConfig pkgs {
        settings = {
          servers = {
            mockServer = {
              command = "echo";
              args = [ "hello" ];
            };
          };
        };
      }
    );
    expected = true;
  };
}
