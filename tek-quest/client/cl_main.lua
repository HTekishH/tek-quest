ESX = nil
cachedD = { 
	VehicleHash = "pounder2",  
	VehicleCoords = Config.Locations["VehiclePos"], 
	VehicleHeading = 70.65
}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)

		Citizen.Wait(0)
    end
end)

RegisterNetEvent("esx:setJob")
AddEventHandler("esx:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

Citizen.CreateThread(function()
	if not DoesEntityExist(cachedD.ped) then
        local model = GetHashKey(Config.Ped['model'])

        LoadModel(model)
        
        cachedD.ped = CreatePed(4, model, Config.Locations['Ped'] - vector4(0.0, 0.0, 0.98, 0.0), true, false)

        while not DoesEntityExist(cachedD.ped) do
            Citizen.Wait(10)
        end

		FreezeEntityPosition(cachedD.ped, true)
		SetEntityInvincible(cachedD.ped, true)
		SetBlockingOfNonTemporaryEvents(cachedD.ped, true)
		SetPedDefaultComponentVariation(cachedD.ped)

		TaskStartScenarioInPlace(cachedD.ped, 'WORLD_HUMAN_SMOKING')

        SetModelAsNoLongerNeeded(model)
	end
	
	while true do

		local sleepThread, player = 750, PlayerPedId()
		local dst = #(GetEntityCoords(player) - GetEntityCoords(cachedD.ped))

		if dst <= 2.0 then
			sleepThread = 5;

			ESX.Game.Utils.DrawText3D(Config.Locations["Ped"], "~w~[~s~~y~E~s~~w~]~s~ ~w~" .. Config.Ped["name"] .. "~s~", 0.7, 5)

			if dst <= 2.0 then

				DrawScriptMarker({
					type = -1, r = 0, g = 250, b = 0,
					sizeX = 1.5, sizeY = 1.5, sizeZ = 1.5, rotate = true,
					pos = Config.Locations["PedMenu"] - vector3(0.0, 0.0, 0.985)
				})   


				if IsControlJustReleased(0, 38) then
					PedNotification(Strings.Info)  
					OpenMenu()
				end 
			end 
		end
		Citizen.Wait(sleepThread)
	end
end)

AcceptedOpen = function() 

	cachedD.state = 1    

	ESX.Game.SpawnVehicle(cachedD.VehicleHash, cachedD.VehicleCoords, cachedD.VehicleHeading) 

	SetNewWaypoint(1716.23, -1638.52) 

    PedNotification(Strings.Deliver)
end

DrawScriptMarker = function(markerData)
    DrawMarker(markerData["type"] or 1, markerData["pos"] or vector3(0.0, 0.0, 0.0), 0.0, 0.0, 0.0, (markerData["type"] == 6 and -90.0 or markerData["rotate"] and -180.0) or 0.0, 0.0, 0.0, markerData["sizeX"] or 1.0, markerData["sizeY"] or 1.0, markerData["sizeZ"] or 1.0, markerData["r"] or 1.0, markerData["g"] or 1.0, markerData["b"] or 1.0, 100, false, true, 2, false, false, false, false)
end

OpenMenu = function()
    local elements = {
        {label = "Ja", yes = "yes"}, 
        {label = "Nej", no = "no"},
    }

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), "start_menu",
        {
            ["title"] = Strings.title,
            ["align"] = Config.align,
            ["elements"] = elements
        },
    function(data, menu)
        local yes = data["current"]["yes"] 
        local no = data["current"]["no"] 

        if yes then  
            menu.close() 
            AcceptedOpen()
        elseif no then   
            PedNotification(Strings.notwantto)
            menu.close()           
        end
    end, function(data, menu)
        menu.close() 
    end)  
end   

Citizen.CreateThread(function() 
    while true do 
        Citizen.Wait(0)
        if cachedD.state == 1 then
            local coords = GetEntityCoords(PlayerPedId())
            local dzt = GetDistanceBetweenCoords(coords, Config.Locations["GotoPos"], true)

            if dzt <= 8.0 then
                cachedD.state = 0
                PedNotification(Strings.Thanks)
                TriggerServerEvent('tek-quest:complete')
            end
        end
    end
end)