
if isClient() then return end
local log = noise or print

Commands = _G['Commands'] or {}
Commands.commands = {};

-- Server creates the commands, handles when a client sends one.
-- Client receives that there are commands, registers them, and sends if a player invokes them.
function Commands.Add(commandName, handler)
  Commands.commands[commandName:lower()] = handler;
end

function Commands.GetCommandList()
  local list = {}
  for k, v in pairs(Commands.commands) do
    table.insert(list, k)
  end

  return list
end

function Commands.Invoke(command, sender, args)
  if not Commands.commands[command] then
    return "Invalid command: " .. command;
  end

  local arglen = 0;
  local commandArgs = {}

  for _,v in pairs(args) do
    arglen = arglen + 1;
    table.insert(commandArgs, v);
  end

  commandArgs.length = arglen;
  return Commands.commands[command](sender, commandArgs);
end

-- Invoking command sent from client
function Commands.OnClientCommand(module, command, player, args)
  if module ~= "commands" then return end
  if args == nil then args = {} end
  command = command:lower() -- ensure it's lowercase
  
  local argStr = '';
  for k,v in pairs(args) do argStr = argStr .. k .. "=" .. v .. "," end

  log("Commands received ClientCommand " .. command .. ", " .. argStr)

  if command == "register" then
    sendServerCommand(player, "commands", "register", Commands.GetCommandList());
  else
    local response = Commands.Invoke(command, player, args);
    sendServerCommand(player, "commands", command, { response = response });
  end
end

Events.OnClientCommand.Add(Commands.OnClientCommand);