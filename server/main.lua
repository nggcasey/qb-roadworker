local QBCore = exports['qb-core']:GetCoreObject()

local CurrentRoadWorkArea = math.random(1, #Config.RoadWorkLocations)
print('Debug: qb-roadworker: CurrentRoadWorkArea: '..CurrentRoadWorkArea)

QBCore.Functions.CreateCallback('qb-roadworker:server:GetRoadWorkConfig', function(source, cb)
    cb(Config.RoadWorkLocations, CurrentRoadWorkArea)
end)

RegisterNetEvent('qb-roadworker:server:CompleteWork', function(Area, Work, Bool)
    print('Work Completed')
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local Reward = math.random(1, #Config.Rewards)
    local Amount = math.random(1, Config.Rewards[Reward].maxAmount)
    local ItemData = QBCore.Shared.Items[Config.Rewards[Reward].item]

    if Amount > 1 then
        for i = 1, Amount, 1 do
            Player.Functions.AddItem(ItemData["name"], 1)
            TriggerClientEvent('inventory:client:ItemBox', src, ItemData, "add")
            Wait(250)
        end
    else
        Player.Functions.AddItem(ItemData["name"], Amount)
        TriggerClientEvent('inventory:client:ItemBox', src, ItemData,"add")
    end

    if (Config.RoadWorkLocations[Area].TotalWork - 1) == 0 then
        for k, v in pairs(Config.RoadWorkLocations[CurrentRoadWorkArea].coords.Work) do
            v.Completed = false
        end
    
    Config.RoadWorkLocations[CurrentRoadWorkArea].TotalWork = Config.RoadWorkLocations[CurrentRoadWorkArea].DefaultWork

        local newLocation = math.random(1, #Config.RoadWorkLocations)
        print(newLocation)
        while (newLocation == CurrentRoadWorkArea) do
            Wait(3)
            newLocation = math.random(1, #Config.RoadWorkLocations)
        end
        CurrentRoadWorkArea = newLocation

        TriggerClientEvent('qb-roadworker:client:NewLocations', -1)
    else
        Config.RoadWorkLocations[Area].coords.Work[Work].Completed = Bool
        Config.RoadWorkLocations[Area].TotalWork = Config.RoadWorkLocations[Area].TotalWork - 1
    end

    TriggerClientEvent('qb-roadworker:server:UpdateWork', -1, Area, Work, Bool)
end)