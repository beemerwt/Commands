# Commands
Server commands mod library for Project Zomboid

## For Developers
If you wish to use this library in your mod, you can do so by adding it to your requirements inside your mod.info file and then creating commands like so:

```lua
-- Example function handler for when someone types in "/tp x y"
local function Teleport(sender, args)
  if args.length < 2 then
    return "Usage: teleport <x> <y>";
  end

  local x = args[1];
  local y = args[2];
  
  sender:setX(x);
  sender:setY(y);
  sender:setZ(0);
  
  return "Teleported to " .. x .. ", " .. y .. ".";
end

Commands.Add("tp", Teleport);
```
