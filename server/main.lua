local QBCore = exports['qb-core']:GetCoreObject()

local CurrentRoadWorkArea = math.random(1, #Config.RoadWorkLocations)
--print('Debug: qb-roadworker: CurrentRoadWorkArea: '..CurrentRoadWorkArea)

QBCore.Functions.CreateCallback('qb-roadworker:server:GetRoadWorkConfig', function(source, cb)
    cb(Config.RoadWorkLocations, CurrentRoadWorkArea)
end)