local M = {}
local money = {}
local config = {}
local folderOfThisFile = "Resources\\Server\\kaj_eco_lib_server\\"
local json = require('Resources.Server.kaj_eco_lib_server.json')


local function clientRequestMoney(client)
    TriggerClientEvent(client, "recieveMoneyValue", getPlayerMoney(client))
end

local function getPlayerMoney(player)
    local discordID = GetPlayerDiscordID(player)
    if money[discordID] == nil then
        money[discordID] = config.startingBalance
    end
    return money[discordID]
end

local function loadMoney()
    local file = io.open(folderOfThisFile.."data.json", "r")
    money = json.decode(file:read("*a"))
    file:close()
end

local function saveMoney()
    local file = assert(io.open(folderOfThisFile.."data.json", "w"))
    file:write(json.encode(result))
    file:close()
    updateMoneyForPlayers()
end

local function changeMoney(user, amount)
    local discordID = GetPlayerDiscordID(user)
    if money[discordID] == nil then
        money[discordID] = 0
    end
    money[discordID] = money[discordID] + amount
    if money[discordID] < 0 and config.balanceCanBeNegative == false then
        money[discordID] = 0
    end
end

local function loadConfig()
    local file = io.open(folderOfThisFile.."config.json", "rb")
    content = file:read("*a")
    config = json.decode(content)
    file:close()
end

local function updateMoneyForAllPlayers()
    if config.clientModInstalled == true then
        for id, name in GetPlayers() do
            TriggerClientEvent(id, "recieveMoneyValue", getPlayerMoney(id))
        end
    end
end

local function giveMoneyThread()
    for id, name in GetPlayers() do
        changeMoney(id, config.moneyPerMinute)
    end
    saveMoney()
end

local function onChat(id, name, message)
    if message == '/balance' then
        SendChatMessage(id, "Balance: "..config.currencySymbol..tostring(getPlayerMoney(id)))
    end
end

function onInit()
    RegisterEvent("clientRequestMoney", "clientRequestMoney") -- used by the client to request their money value
    RegisterEvent("onChatMessage", "onChat") -- used buy the server to register commands
    RegisterEvent("changeMoney", "changeMoney") -- used by other plugins to change money of players. Pass in a server ID and amount (can be negative)
    RegisterEvent("loadMoney", "loadMoney") -- trigger to load money from disk
    RegisterEvent("saveMoney", "saveMoney") -- trigger to save money to disk (will send to players if using client sided mod)
    loadMoney()
    loadConfig()
    if config.moneyPerMinute > 0 then
        CreateThread("giveMoneyThread", 60)
    end
    print("-----------------------------------------")
    print("loaded kaj eco library v"..config.version)
    print("-----------------------------------------")
end

return M