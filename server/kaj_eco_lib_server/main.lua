local M = {}
local money = {}
local config

require("json")

local function clientRequestMoney(client)
    TriggerClientEvent(client, "recieveMoneyValue", getPlayerMoney(client))
end

local function getPlayerMoney(player)
    local discordID = GetPlayerDiscordID(player)
    return money[discordID]
end

local function loadMoney()
    local file = io.open("data.json", "r")
    money = json.decode(file:read("*a"))
    file:close()
end

local function saveMoney()
    local file = assert(io.open("data.json", "w"))
    file:write(json.encode(result))
    file:close()
    updateMoneyForPlayers()
end

local funtion changeMoney(user, amount)
    money[user] = money[user] + amount
end

local function loadConfig()
    local file = io.open("config.json", "r")
    config = json.decode(file:read("*a"))
    file:close()
end

local function updateMoneyForAllPlayers()
    if config.clientModInstalled == true do
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
    if message == '/balance' do
        SendChatMessage(id, "Balance: "..config.currencySymbol..tostring(getPlayerMoney(id)))
    end
end

local function onInit()
    RegisterEvent("clientRequestMoney", "clientRequestMoney")
    RegisterEvent("onChatMessage", "onChat")
    money = loadMoney()
    config = loadConfig()
    CreateThread("giveMoneyThread", 60)
    print("-----------------------------------------")
    print("loaded kaj eco library v"..config.version)
    print("-----------------------------------------")
end

return M