
if isServer() then return end

Commands = _G['Commands'] or {}
Commands.commands = {};

local lastTabId = 0;
local UCLEN = 17;
local clone = nil;

local function splitstr(inputstr, sep)
  if sep == nil then sep = "%s" end
  local t={}

  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end

  return t
end

function Commands.IsCommand(command)
  for _,v in ipairs(Commands.commands) do
    if v:lower() == command:lower() then
      return true
    end
  end

  return false
end

-- Called when the chat receives a "message"
function Commands.OnAddMessage(message, tabId)
  lastTabId = tabId;
  clone = message:clone();

  local messageText = clone:getText():sub(UCLEN);
  print(messageText);

  -- split message
  local commandArgs = splitstr(messageText);
  local command = commandArgs[1];
  table.remove(commandArgs, 1);

  if Commands.IsCommand(command) then
    sendClientCommand(getPlayer(), "commands", command, commandArgs);
  else
    ISChat.addLineInChat(message, tabId);
  end
end

function Commands.Register(args)
  -- "args" could be "numTicks" from "OnTick"
  if type(args) ~= "table" then
    print("Retrieving Commands from Server");
    sendClientCommand(getPlayer(), "commands", "register", {});
  else
    for _,command in ipairs(args) do
      print("Registering command " .. command .. " from server");
      table.insert(Commands.commands, command);
    end

    Events.OnTick.Remove(Commands.Register);
  end
end

function Commands.OnServerCommand(module, command, args)
  if module ~= "commands" then return end
  if args == nil then args = {} end

  if command == "register" then
    Commands.Register(args);
  else
    if args.response then
      clone:setText(args.response);
      ISChat.addLineInChat(clone, lastTabId);
    end
  end
end

ISChat.createChat = function()
  if not isClient() then return; end
  ISChat.chat = ISChat:new(15, getCore():getScreenHeight() - 400, 500, 200);
  ISChat.chat:initialise();
  ISChat.chat:addToUIManager();
  ISChat.chat:setVisible(true);
  ISChat.chat:bringToTop()
  ISLayoutManager.RegisterWindow('chat', ISChat, ISChat.chat)

  ISChat.instance:setVisible(true);

  -- replace old handler with our new handler
  Events.OnAddMessage.Add(Commands.OnAddMessage);
  Events.OnMouseDown.Add(ISChat.unfocusEvent);
  Events.OnKeyPressed.Add(ISChat.onToggleChatBox);
  Events.OnKeyKeepPressed.Add(ISChat.onKeyKeepPressed);
  Events.OnTabAdded.Add(ISChat.onTabAdded);
  Events.OnSetDefaultTab.Add(ISChat.onSetDefaultTab);
  Events.OnTabRemoved.Add(ISChat.onTabRemoved);
  Events.SwitchChatStream.Add(ISChat.onSwitchStream)
end

Commands.Register();

Events.OnServerCommand.Add(Commands.OnServerCommand);
Events.OnTick.Add(Commands.Register);