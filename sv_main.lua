ESX = {}

TriggerEvent("esx:getSharedObject", function(library) 
	ESX = library 
end)

RegisterNetEvent("tek-quest:complete")
AddEventHandler('tek-quest:complete', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.addAccountMoney('black_money', Payment.Reward)
end)