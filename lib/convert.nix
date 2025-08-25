{ ... }:
let
  isLocal = geminiConfig: geminiConfig ? command;

  geminiToOpenCode =
    geminiAttrs:
    let
      convertServer =
        serverName: serverConfig:
        (
          if isLocal serverConfig then
            {
              type = "local";
              command =
                if serverConfig ? args && serverConfig.args != [ ] then
                  [ serverConfig.command ] ++ serverConfig.args
                else
                  [ serverConfig.command ];
            }
          else
            {
              type = "remote";
              url = serverConfig.url;
              # TODO: add header support?
            }
        )
        // (if serverConfig ? env then { environment = serverConfig.env; } else { })
        // {
          enabled = true;
        };

    in
    {
      mcp = builtins.mapAttrs convertServer geminiAttrs.mcpServers;
    };

  geminiToClaudeCode =
    geminiAttrs:
    let
      convertServer =
        serverName: serverConfig:
        (
          if isLocal serverConfig then
            {
              type = "stdio";
              command = serverConfig.command;
            }
            // (if serverConfig ? args && serverConfig.args != [ ] then { args = serverConfig.args; } else { })
          else
            {
              type = "sse";
              url = serverConfig.url;
              # TODO: add header support?
            }
        )
        // (if serverConfig ? env then { env = serverConfig.env; } else { });

    in
    {
      mcpServers = builtins.mapAttrs convertServer geminiAttrs.mcpServers;
    };
in
{
  inherit geminiToOpenCode geminiToClaudeCode;
}
