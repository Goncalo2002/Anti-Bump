local prevSpeed = 0
local vehicle = nil
local isCompressing = false
local bumpThreshold = 0
local normalCompression = {}
--local messageCooldown = 100
--local lastMessageTime = 0
--local messagecount = 0

function GetVehicleSpeed(vehicle)
    return GetEntitySpeed(vehicle)
end

--[[function SendCompressionMessage()
    local currentTime = GetGameTimer()
    if currentTime - lastMessageTime >= messageCooldown then
        messagecount = messagecount + 1
        TriggerEvent('chat:addMessage', {
            args = { "AntiBump", "Bump detected " .. messagecount }
        })
        lastMessageTime = currentTime
    end
end]]

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(50)
        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        if vehicle and vehicle ~= 0 then
            local vehicleClass = GetVehicleClass(vehicle)
            local wheelType = GetVehicleWheelType(vehicle)

            if wheelType == 4 then -- OffRoad Vehicles
                bumpThreshold = 0.1
            else
                bumpThreshold = 0.05
            end

            local currentSpeed = GetVehicleSpeed(vehicle)
            local isBumpDetected = false

            if not normalCompression[vehicle] then
                normalCompression[vehicle] = {}
                for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                    normalCompression[vehicle][i] = GetVehicleWheelSuspensionCompression(vehicle, i)
                end
            end

            for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                local suspensionCompression = GetVehicleWheelSuspensionCompression(vehicle, i)
                local normal = normalCompression[vehicle][i]
                
                if math.abs(suspensionCompression - normal) > bumpThreshold then
                    isBumpDetected = true
                end
            end

            if isBumpDetected then
                -- SendCompressionMessage()

                if currentSpeed > prevSpeed then
                    SetVehicleMaxSpeed(vehicle, prevSpeed)
                end
                isCompressing = true
            else
                SetVehicleMaxSpeed(vehicle, 999.0)
                isCompressing = false
            end

            if not isCompressing then
                prevSpeed = currentSpeed
            end
        end
    end
end)
