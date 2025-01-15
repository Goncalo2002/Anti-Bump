local prevSpeed = 0
local vehicle = nil
local lastVehicle = nil 
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

        if vehicle and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, -1) == GetPlayerPed(-1) then
            if vehicle ~= lastVehicle then
                normalCompression = {}
                for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                    normalCompression[i] = GetVehicleWheelSuspensionCompression(vehicle, i)
                end
                lastVehicle = vehicle
                prevSpeed = 0
            end

            local wheelType = GetVehicleWheelType(vehicle)
            bumpThreshold = (wheelType == 4) and 0.1 or 0.055 -- OffRoad Vehicles vs Others

            local currentSpeed = GetVehicleSpeed(vehicle)
            local isBumpDetected = false

            for i = 0, GetVehicleNumberOfWheels(vehicle) - 1 do
                local suspensionCompression = GetVehicleWheelSuspensionCompression(vehicle, i)
                local normal = normalCompression[i]

                if math.abs(suspensionCompression - normal) > bumpThreshold then
                    isBumpDetected = true
                end
            end

            if isBumpDetected then
                --SendCompressionMessage()

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
        else
            vehicle = nil
            lastVehicle = nil
            normalCompression = {}
        end
    end
end)
