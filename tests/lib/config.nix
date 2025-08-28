{ lib
, pkgs
, mcp-servers-nix
, ...
}:

let
  # mkConfig = mcp-servers-nix.lib.mkConfig;
  mkConfig = lib.merge.mkConfigNoDrv;
  stub = input: input != null; # NOTE: just test if the evaluation goes through
in
{
  testMcpServersNixEmpty = {
    expr = stub (
      mkConfig mcp-servers-nix pkgs {
        programs = { };
        # NOTE: without this, there is an error
        settings.servers = { };
      }
    );
    expected = true;
  };

  testMcpServersNixFetch = {
    expr = stub (
      mkConfig mcp-servers-nix pkgs {
        programs = {
          git.enable = true;
        };
      }
    );
    expected = true;
  };

  testMcpServersNixCustom = {
    expr = stub (
      mkConfig mcp-servers-nix pkgs {
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
