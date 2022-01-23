-- Variables
local QBCore = exports['qb-core']:GetCoreObject()
local CurrentRoadWorkLocation = {
    Area = 0,
    Blip = {
        Radius = nil,
        Label = nil
    }
}

--Functions

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
AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    print('The resource ' .. resourceName .. ' has been started.')

    QBCore.Functions.TriggerCallback('qb-roadworker:server:GetRoadWorkConfig', function(Config, Area)
        TriggerEvent('qb-roadworker:client:SetRoadWorkLocation', Area)
    end)

  end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('qb-roadworker:server:GetRoadWorkConfig', function(Config, Area)
        TriggerEvent('qb-roadworker:client:SetRoadWorkLocation', Area)
    end)
end)


RegisterNetEvent('qb-roadworker:client:SetRoadWorkLocation', function(RoadWorkLocation)

    CurrentRoadWorkLocation.Area = RoadWorkLocation

    blipRadius = AddBlipForRadius(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z, 75.0)
    blipLabel = AddBlipForCoord(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z)
    -- blipText = 'Road Hazard Area'

    SetBlipSprite(blipLabel, 650)
    SetBlipColour(blipLabel, 5)
    SetBlipDisplay(blipLabel, 4)
    SetBlipScale(blipLabel, 0.7)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.BlipLabel)
    EndTextCommandSetBlipName(blipLabel)

    SetBlipRotation(blipRadius, 0)
    SetBlipColour(blipRadius, 47)
    SetBlipAlpha(blipRadius, 125)



    -- RadiusBlip = AddBlipForRadius(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z, 100.0)
    -- --print('RadiusBlip: '..RadiusBlip)

    -- SetBlipRotation(RadiusBlip, 0)
    -- SetBlipColour(RadiusBlip, 47)
    -- SetBlipAlpha(RadiusBlip, 125)

    
    -- BeginTextCommandSetBlipName("RoadWork")
    -- EndTextCommandSetBlipName(RadiusBlip)
    -- SetBlipCategory(RadiusBlip, 1)




end)


RegisterNetEvent("qb-roadworker:client:SpawnVehicle",function(data)
    local vehicleSpawnName=data.spawnName
    SpawnListVehicle(vehicleSpawnName)
end)

--Threads

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