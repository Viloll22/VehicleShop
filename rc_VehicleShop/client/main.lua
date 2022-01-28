ESX              = nil
local PlayerData = {}


RegisterCommand("veh", function()
    SetDisplay(not display)
end)

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)



local isMenuOpen = false

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(4)
	local coords = GetEntityCoords(PlayerPedId())
	local distance = GetDistanceBetweenCoords(coords, 0, 0, 0, true) -- Die Nullen durch die Cords des Markers oder so ersetzten. Alsi da wo der Spieler E drücken kann

	if distance <= 3 then
			if isMenuOpen == false then
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to access the menu", thisFrame, beep, duration)
                    if IsControlJustReleased(0, 38) then
                        SetDisplay(not display) -- Aktiviert die UI
						isMenuOpen = true
					end
				else

				end

			end

	end
end)


RegisterNUICallback("exit", function(data) -- index.js ruft diesen Callback auf und dan passiert das was dadrin passiert
    print("UI Closed")
    SetDisplay(false) -- Deaktviert die UI
    isMenuOpen = false
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)
















local lastNPCnearPlayer = 0
--Check who Player

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(4)
	local coords = GetEntityCoords(PlayerPedId())
	for i=1, #Config.Locations do
		local npc = Config.Locations[i]["npc"]
		
			local distance = GetDistanceBetweenCoords(coords, npc["x"], npc["y"], npc["z"], true)
            
			if distance <= 3 then
                lastNPCnearPlayer = npc["slot"]
                

				if isMenuOpen == false then
					ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to access the menu", thisFrame, beep, duration)

					if IsControlJustReleased(0, 38) then
                        isMenuOpen = true
                        SetDisplay(not display)
					end
				else

				end

			end

	end

	end
end)




-- CREATE BLIPS


Citizen.CreateThread(function()
    for i=1, #Config.Locations do
        local blip = Config.Locations[i]["marker"]

        if blip then
            if not DoesBlipExist(blip["id"]) then
                blip["id"] = AddBlipForCoord(blip["x"], blip["y"], blip["z"])
                SetBlipSprite(blip["id"], 225)
                SetBlipDisplay(blip["id"], 4)
                SetBlipScale(blip["id"], 1.0)
                SetBlipColour(blip["id"], 46)
                SetBlipAsShortRange(blip["id"], true)

                BeginTextCommandSetBlipName("vehShopBlip")
                AddTextEntry("vehShopBlip", "Vehicle Shop")
                EndTextCommandSetBlipName(blip["id"])
            end
        end
    end
end)



-- SPAWN PEDS 


_RequestModel = function(hash)
    if type(hash) == "string" then hash = GetHashKey(hash) end
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(0)
    end
end

Citizen.CreateThread(function()
    for i=1, #Config.Locations do
		local npc = Config.Locations[i]["npc"]
		if npc then
			
            npc["hash"] = npc["hash"]
            _RequestModel(npc["hash"])
            if not DoesEntityExist(npc["entity"]) then
                npc["entity"] = CreatePed(4, npc["hash"], npc["x"], npc["y"], npc["z"], npc["h"])
                SetEntityAsMissionEntity(npc["entity"])
                SetBlockingOfNonTemporaryEvents(npc["entity"], true)
                FreezeEntityPosition(npc["entity"], true)
                SetEntityInvincible(npc["entity"], true)
            end
            SetModelAsNoLongerNeeded(npc["hash"])
        end
    end
end)





-- Test Drive System

RegisterNUICallback(
    "testDrive",
    function(data)

		Citizen.Wait(500)
	

		TriggerServerEvent("rc_VehicleShop:testDriveServer", data.idCar , lastNPCnearPlayer)
    end
)




RegisterNetEvent("rc_VehicleShop:testDriveSpawn")
AddEventHandler("rc_VehicleShop:testDriveSpawn", function(lastNPC, carModel)

    local vehSpawn = Config.Locations[lastNPC]["vehicleSpawn"]
    local markerNPC = Config.Locations[lastNPC]["marker"]
    local coords = { x = markerNPC['x'], y = markerNPC['y'], z = markerNPC['z']}

    

    ESX.Game.SpawnVehicle(carModel, {x = vehSpawn['x'], y = vehSpawn['y'], z = vehSpawn['z']} , vehSpawn['h'] , function(vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)

        Citizen.Wait(Config.TestDriveTime*60*1000)
        SetDisplay(not display)
        ESX.Game.Teleport(PlayerPedId(), coords ,function()
        end)
        ESX.Game.DeleteVehicle(vehicle)
        
    end)
end)












RegisterNUICallback(
    "buyVehicle",
    function(data)

		Citizen.Wait(500)
	
		
     

        TriggerServerEvent("rc_VehicleShop:getPlayerCash", data.idCar, lastNPCnearPlayer, data.inputCoupon)
    end
)

RegisterNetEvent("rc_VehicleShop:buyVehicleCheck")
AddEventHandler("rc_VehicleShop:buyVehicleCheck", function(carModel, carPrice, lastNPC, couponCode)

    print(carModel)
    print(carPrice)
    local generatedPlate = GeneratePlate()

    print(generatedPlate)

    TriggerServerEvent("rc_VehicleShop:buyVehicle", carModel, carPrice, generatedPlate, lastNPC, couponCode)
end)


RegisterNetEvent("rc_VehicleShop:spawnBoughtVeh")
AddEventHandler("rc_VehicleShop:spawnBoughtVeh", function(carModel,plate,lastNPC)

    local vehSpawn = Config.Locations[lastNPC]["vehicleSpawn"]
    local markerNPC = Config.Locations[lastNPC]["marker"]
    local coords = { x = markerNPC['x'], y = markerNPC['y'], z = markerNPC['z']}

    

    ESX.Game.SpawnVehicle(carModel, {x = vehSpawn['x'], y = vehSpawn['y'], z = vehSpawn['z']} , vehSpawn['h'] , function(vehicle)
        TaskWarpPedIntoVehicle(GetPlayerPed(source), vehicle, -1)
        SetVehicleNumberPlateText(vehicle, plate)
        
    end)
end)














  
local NumberCharset = {}
local Charset = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end




function GeneratePlate()
    local generatedPlate
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		if Config.PlateUseSpace then
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. ' ' .. GetRandomNumber(Config.PlateNumbers))
		else
			generatedPlate = string.upper(GetRandomLetter(Config.PlateLetters) .. GetRandomNumber(Config.PlateNumbers))
		end

		ESX.TriggerServerCallback('rc_VehicleShop:isPlateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end



function IsPlateTaken(plate)
	local callback = 'waiting'

	ESX.TriggerServerCallback('rc_VehicleShop:isPlateTaken', function(isPlateTaken)
		callback = isPlateTaken
	end, plate)

	while type(callback) == 'string' do
		Citizen.Wait(0)
	end

	return callback
end




function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end



function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end
















RegisterNUICallback(
    "carList",
    function(data)

		Citizen.Wait(500)
	
		
		ESX.TriggerServerCallback('rc_vehicle:getCarList', function(carToSell) 
			
			
			
            
			SendNUIMessage({carListCheck= true, carToSell = carToSell})
					
				

		end)
    end
)


RegisterNUICallback(
    "bikeList",
    function(data)
        print("BIKE")

		Citizen.Wait(500)
	
		
		ESX.TriggerServerCallback('rc_vehicle:getBikeList', function(bikeToSell) 
			
			
			
            
			SendNUIMessage({bikeListCheck= true, bikeToSell = bikeToSell})
					
				

		end)
    end
)


RegisterNUICallback(
    "truckList",
    function(data)
        print("Truck")
		Citizen.Wait(500)
	
		
		ESX.TriggerServerCallback('rc_vehicle:getTruckList', function(truckToSell) 
			
			
			
            
			SendNUIMessage({truckListCheck= true, truckToSell = truckToSell})
					
				

		end)
    end
)














