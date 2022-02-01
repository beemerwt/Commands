# Permissions
Permissions mod for Project Zomboid

Unfortunately, there are too many permissions to list on this page.

Please refer to [this file](https://github.com/beemerwt/Permissions/blob/master/media/lua/client/Permissions.lua) to see all "PermissiveActions."
Each permissive action has a string (text surrounded with double-quotation marks (")) that determines the permission required to perform that action. For example,

```lua
PermissiveAction(ISWorldObjectContextMenu, "emptyRainCollector", 2);
```
  
This registers "emptyRainCollector" as a permission to empty a rain collector. If the player has this permission then they will be allowed to empty a rain collector.
