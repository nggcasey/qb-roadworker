local QBCore = exports['qb-core']:GetCoreObject()

local CurrentDebrisArea = math.random(1, #Config.DebrisLocations)
--print('Debug: qb-roadworker: CurrentDebrisArea: '..CurrentDebrisArea)

QBCore.Functions.CreateCallback('qb-roadworker:server:GetDebrisConfig', function(source, cb)
    cb(Config.DebrisLocations, CurrentDebrisArea)
end)