local M = {}

local money = 0

function getMoney()
    TriggerServerEvent("clientRequestMoney")
end

local function recieveMoneyValue(amount)
    money = amount
end

local function onExtensionLoaded()
    AddEventHandler("recieveMoneyValue", "recieveMoneyValue")
    money = getMoney()
    print(money)
end

local function onExtensionUnloaded()
    print("Unloading Kaj eco lib. Goodbye!")
end

M.onExtensionLoaded = onExtensionLoaded
M.onExtensionUnloaded = onExtensionUnloaded

return M
