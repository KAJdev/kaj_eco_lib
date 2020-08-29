## Kaj's Economy library.
- provides rudimentary balances for players
- stores associated monetary values on the server, safe from cheating.
- easy way to set/add/remove money from each player.
- automatically sends new money value to client, and saves it on the server.

## Installation
- download the client side mod from the releases page, as well as the server side mod.
- put the server side mod into Resources/Server/ Directory on your Server. (edit config if needed)
- put the client side mod zip archive into Resources/Client/ Directory on your Server. (if you are OK with only being able to use commands you can skip the client side mod)
- restart your server.

## Plugin events
### changeMoney (\<serverID>, \<amount>)
> usage: TriggerGlobalEvent("changeMoney", \<serverID>, \<amount>)

trigger this event to change the value of money for a specific player. This will not save. You must trigger saveMoney in order to save to disk and send to clients

### loadMoney ()
> usage: TriggerGlobalEvent("loadMoney")

trigger to load money from disk

### saveMoney ()
> usage: TriggerGlobalEvent("saveMoney")

trigger to save money to disk. If the clientModInstalled value of the config is set to true it will update all clients. Be careful as this could crash players that don't have the lastest version or do not have th mod loaded. A system to prevent this, and only send to clients who have the mod, is in the works.
