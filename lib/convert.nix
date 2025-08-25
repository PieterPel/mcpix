{ ... }:
let
  # TODO: support sse connection type
  geminiToOpenCode =
    geminiAttrs:
    let
      convertServer =
        serverName: serverConfig:
        {
          type = "local";
          enabled = true;
          command =
            if serverConfig ? args && serverConfig.args != [ ] then
              [ serverConfig.command ] ++ serverConfig.args
            else
              [ serverConfig.command ];
        }
        // (if serverConfig ? env then { environment = serverConfig.env; } else { });

    in
    # builtins.mapAttrs convertServer geminiAttrs;
    {
      mcp = builtins.mapAttrs convertServer geminiAttrs.mcpServers;
    };

  geminiToClaudeCode =
    geminiAttrs:
    let
      convertServer =
        serverName: serverConfig:
        {
          type = "stdio";
          command = serverConfig.command;
        }
        // (if serverConfig ? args && serverConfig.args != [ ] then { args = serverConfig.args; } else { })
        // (if serverConfig ? env then { env = serverConfig.env; } else { });

    in
    {
      mcpServers = builtins.mapAttrs convertServer geminiAttrs.mcpServers;
    };
in
{
  inherit geminiToOpenCode geminiToClaudeCode;
}
