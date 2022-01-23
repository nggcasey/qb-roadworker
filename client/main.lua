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

local function AddJobBlip()
    local jobBlip = AddBlipForCoord(Config.Locations["blip"])
    SetBlipSprite(jobBlip, 487)
    SetBlipColour(jobBlip, 2)
    SetBlipDisplay(jobBlip, 4)
    SetBlipScale(jobBlip, 1.0)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(Config.JobLabel..' HQ')
    EndTextCommandSetBlipName(jobBlip)
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

local function CompleteWork(work)
    Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Work[work].Completed = true
    TriggerServerEvent('qb-roadworker:server:CompleteWork', CurrentRoadWorkLocation.Area, work, true)
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

    AddJobBlip()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
        QBCore.Functions.TriggerCallback('qb-roadworker:server:GetRoadWorkConfig', function(Config, Area)
        TriggerEvent('qb-roadworker:client:SetRoadWorkLocation', Area)
    end)

    AddJobBlip()

end)


RegisterNetEvent('qb-roadworker:client:SetRoadWorkLocation', function(RoadWorkLocation)

    CurrentRoadWorkLocation.Area = RoadWorkLocation

    -- for _,Blip in pairs(CurrentRoadWorkLocation.Blip) do
    --     if Blip ~= nil then
    --         RemoveBlip(Blip)
    --     end
    -- end

    RemoveBlip(blipRadius)
    RemoveBlip(blipLabel)

    CreateThread(function()
        blipRadius = AddBlipForRadius(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z, 75.0)
        blipLabel = AddBlipForCoord(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z)

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

        CurrentRoadWorkLocation.Blip.Label = blipLabel
    end)
end)

RegisterNetEvent('qb-roadworker:client:NewLocations', function()
        QBCore.Functions.TriggerCallback('qb-roadworker:server:GetRoadWorkConfig', function(Config, Area)
            Config.RoadWorkLocations = Config
            TriggerEvent('qb-roadworker:client:SetRoadWorkLocation', Area)
        end)
end)

RegisterNetEvent('qb-roadworker:server:UpdateWork', function(Area, Work, Bool)
    Config.RoadWorkLocations[Area].coords.Work[Work].Completed = Bool
end)

RegisterNetEvent("qb-roadworker:client:SpawnVehicle",function(data)
    local vehicleSpawnName=data.spawnName
    SpawnListVehicle(vehicleSpawnName)
end)

--Threads

CreateThread(function()
    while true do
        local inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        if CurrentRoadWorkLocation.Area ~=0 then
            local AreaDistance = #(pos - vector3(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.x, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.y, Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Area.z))
            local WorkDistance = nil

            if AreaDistance < 75 then
                inRange = true
            end

            if inRange then
                --print('in range')
                for cur, WorkLocation in pairs(Config.RoadWorkLocations[CurrentRoadWorkLocation.Area].coords.Work) do
                    --print(WorkLocation.coords.x)
                    WorkDistance = #(pos - vector3(WorkLocation.coords.x, WorkLocation.coords.y, WorkLocation.coords.z))
                    --print(WorkDistance)
                    if WorkDistance ~= nil then
                        if WorkDistance <= 75 then
                            if not WorkLocation.Completed then
                                DrawMarker(32, WorkLocation.coords.x, WorkLocation.coords.y, WorkLocation.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 1.0, 0.4, 255, 223, 0, 255, true, false, false, false, false, false, false )
                                if WorkDistance <= 1.5 then
                                    --print(WorkDistance)
                                    DrawText3D(WorkLocation.coords.x, WorkLocation.coords.y, WorkLocation.coords.z, '[E] Start Roadwork')
                                    if IsControlJustReleased(0, 38) then
                                        local DrillObject = CreateObject(1360563376, pos.x, pos.y, pos.z, true, true, true)
                                        AttachEntityToEntity(DrillObject, ped, GetPedBoneIndex(ped), 57005, 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)
                                        --IsDrilling = true
                                        --local times = math.random(2, 5)
                                        QBCore.Functions.Progressbar("complete_work", "Completing Roadwork", 15000, false, true, {
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            --animDict = "weapons@first_person@aim_rng@generic@projectile@thermal_charge@",
                                            animDict = "amb@world_human_const_drill@male@drill@base",
                                            anim = "base",
                                            --anim = "plant_floor",
                                            flags = 1,
                                        }, {}, {}, function() --Done
                                            CompleteWork(cur)
                                            StopAnimTask(PlayerPedId(),"amb@world_human_const_drill@male@drill@base", "base", 1.0 )
                                            DetachEntity(DrillObject, true, true)
                                            DeleteObject(DrillObject)
                                            FreezeEntityPosition(ped, false)
                                        end, function() --Cancel
                                            ClearPedTasks(ped)
                                            StopAnimTask(PlayerPedId(),"amb@world_human_const_drill@male@drill@base", "base", 1.0 )
                                            DetachEntity(DrillObject, true, true)
                                            DeleteObject(DrillObject)
                                            FreezeEntityPosition(ped, false)
                                        end)
                                    
                                    end
                                end
                            end
                        end
                    end
                end
            end
            if not inRange then
                Wait(2500)
            end
        end
            Wait(3)
    end
end)

CreateThread(function() --Job Garage
    while true do
        inRange = false
        local ped = PlayerPedId()
        local pos = GetEntityCoords(ped)

        local dist = #(pos - vector3(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z))
        if dist < 20 then
            inRange = true
            DrawText3D(Config.Locations["vehicle"].x, Config.Locations["vehicle"].y, Config.Locations["vehicle"].z, "[E] "..Config.JobLabel.. " Garage")
        
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