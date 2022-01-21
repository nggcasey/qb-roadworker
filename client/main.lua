
-- Variables

local QBCore = exports['qb-core']:GetCoreObject()

--Functions

local function GetDebrisLocation()
currentJob = math.random(1, #Config.DebrisLocations)
end

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function RoadWorkerGarage()
    local vehicleMenu = {
        {
            header = "Vehicle List",
            isMenuHeader = true
        }
    }
    for k,v in pairs(Config.Vehicles) do
        vehicleMenu[#vehicleMenu+1] = {
            header = v,
            txt = "Vehicle: "..v.."",
            params = {
                event = "qb-roadworker:client:SpawnVehicle",
                args = {
                    headername = v,
                    spawnName = k
                }
            }
        }                              
    end
    vehicleMenu[#vehicleMenu+1] = {
        header = "⬅ Close Menu",
        txt = "",
        params = {
            event = "qb-menu:client:closeMenu"
        }

    }
    exports['qb-menu']:openMenu(vehicleMenu)
end

local function SpawnListVehicle(model)
    local coords = {
        x = Config.Locations["vehicle"].x,
        y = Config.Locations["vehicle"].y,
        z = Config.Locations["vehicle"].z,
        w = Config.Locations["vehicle"].w,
    }

    QBCore.Functions.SpawnVehicle(model, function(veh)
        SetVehicleNumberPlateText(veh, "1VR "..tostring(math.random(100, 999)))
        SetEntityHeading(veh, coords.w)
        exports['LegacyFuel']:SetFuel(veh, 100.0)
        TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
        SetVehicleEngineOn(veh, true, true)
    end, coords, true)
end

--Events

RegisterNetEvent("qb-roadworker:client:SpawnVehicle",function(data)
    local vehicleSpawnName=data.spawnName
    SpawnListVehicle(vehicleSpawnName)
end)

--Threads
CreateThread(function() -- Map Blip
    RoadworkerBlip = AddBlipForCoord(Config.Locations["blip"])
    SetBlipSprite (RoadworkerBlip, 67)
    SetBlipDisplay(RoadworkerBlip, 4)
    SetBlipScale  (RoadworkerBlip, 0.6)
    SetBlipAsShortRange(RoadworkerBlip, true)
    SetBlipColour(RoadworkerBlip, 2)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.joblabel)
    EndTextCommandSetBlipName(RoadworkerBlip)
end)

CreateThread(function() --Job Garage
    while true do
        inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = #(pos - vector3(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z))
        if dist < 20 then
            inRange = true
            DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "[E] "..Config.joblabel.. " Garage")
        
            if dist < 1.5 then
                if IsControlJustReleased(0,38) then
                    if IsPedInAnyVehicle(ped, false) then
                        DeleteVehicle(GetVehiclePedIsIn(ped))
                    else
                        RoadWorkerGarage()
                    end
                end
            end
        end

        if not inRange then
            Wait(3000)
        end
        
        Wait(3)
    end
end)