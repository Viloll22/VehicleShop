ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)









-- GET VEHICLES

ESX.RegisterServerCallback('rc_vehicle:getCarList', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	
	MySQL.Async.fetchAll('SELECT * FROM rc_vehicleshop WHERE genre = @car ORDER BY price ASC', { ['@id'] = playerId, ["@car"] = "car" }, function(result)
		cb(json.encode(result))
		
		
	end)
end)






ESX.RegisterServerCallback('rc_vehicle:getBikeList', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	MySQL.Async.fetchAll('SELECT * FROM rc_vehicleshop WHERE genre = @bike ORDER BY price ASC', { ['@id'] = playerId, ["@bike"] = "bike" }, function(result)
		cb(json.encode(result))
		
		
	end)
end)






ESX.RegisterServerCallback('rc_vehicle:getTruckList', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory

	
	MySQL.Async.fetchAll('SELECT * FROM rc_vehicleshop WHERE genre = @truck ORDER BY price ASC', { ['@id'] = playerId, ["@truck"] = "truck" }, function(result)
		cb(json.encode(result))
		
		
	end)
end)















-- Test Drive Server

RegisterNetEvent("rc_VehicleShop:testDriveServer")
AddEventHandler("rc_VehicleShop:testDriveServer",function(idCar, lastNPCnearPlayer)
    local b = source;
    local xPlayer = ESX.GetPlayerFromId(b)

    MySQL.Async.fetchAll('SELECT * FROM rc_vehicleshop WHERE id = @idCar',
		  { ['idCar'] = idCar },
		  function(result)
			
            print(result[1].car)
						
			TriggerClientEvent("esx:showNotification", b, "Successfully rent " .. Config.TestDriveTime .. "min")
			TriggerClientEvent("rc_VehicleShop:testDriveSpawn", b, lastNPCnearPlayer, result[1].car)



	end)
end)








-- Buy Vehicle Server

-- RegisterNetEvent("rc_VehicleShop:buyVehicle")
-- AddEventHandler("rc_VehicleShop:buyVehicle",function(idCar, lastNPCnearPlayer)
--     local b = source;
--     local xPlayer = ESX.GetPlayerFromId(b)

-- 	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
-- 			['@owner']   = xPlayer.identifier,
-- 			['@plate']   = "TST TST",
-- 			['@vehicle'] = json.encode({model = "adder", plate = "TST TST"})
-- 		}, function(rowsChanged)

-- 	end)
-- end)





RegisterNetEvent("rc_VehicleShop:getPlayerCash")
AddEventHandler("rc_VehicleShop:getPlayerCash",function(idCar, lastNPC, couponCode)
	local b = source;
    local xPlayer = ESX.GetPlayerFromId(b)


	

	MySQL.Async.fetchAll('SELECT * FROM rc_vehicleshop WHERE id = @idCar',
		  { ['idCar'] = idCar },
		  function(result)
			

						
			local carModel = result[1].car
			local carPrice = result[1].price

			

			Citizen.Wait(1000)
			TriggerClientEvent("rc_VehicleShop:buyVehicleCheck", b, carModel, carPrice, lastNPC, couponCode)

	end)

	
end)		


RegisterNetEvent("rc_VehicleShop:buyVehicle")
AddEventHandler("rc_VehicleShop:buyVehicle",function(carModel, carPrice, generatedPlate, lastNPC, couponCode)
	local b = source;
    local xPlayer = ESX.GetPlayerFromId(b)

	print(carPrice)

	if couponCode == Config.CouponOne["code"] then
		local reward = Config.CouponOne["reward"]
		carPrice = carPrice-reward
		print(carPrice)
	
	end

	if couponCode == Config.CouponTwo["code"] then
		local reward = Config.CouponTwo["reward"]
		carPrice = carPrice-reward
		print(carPrice)
	
	end

	if couponCode == Config.CouponThree["code"] then
		local reward = Config.CouponThree["reward"]
		carPrice = carPrice-reward
		print(carPrice)
	
	end

	if carPrice and xPlayer.getMoney() >= carPrice then
		xPlayer.removeMoney(carPrice)

		MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)', {
						['@owner']   = xPlayer.identifier,
						['@plate']   = generatedPlate,
						['@vehicle'] = json.encode({model = carModel, plate = generatedPlate})
					}, function(rowsChanged)
			
		end)
		TriggerClientEvent("esx:showNotification", b, "Successfully bought! Vehicle Plate: " .. generatedPlate .. "")
		TriggerClientEvent("rc_VehicleShop:spawnBoughtVeh", b, carModel, generatedPlate,lastNPC)
	else
		TriggerClientEvent("esx:showNotification", b, "Not enough money!")
	end
end)







ESX.RegisterServerCallback('rc_VehicleShop:isPlateTaken', function(source, cb, plate)
	MySQL.Async.fetchAll('SELECT 1 FROM owned_vehicles WHERE plate = @plate', {
		['@plate'] = plate
	}, function(result)
		cb(result[1] ~= nil)
	end)
end)