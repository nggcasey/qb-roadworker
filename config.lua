--print('config file loaded')

Config = {}

--Set your job label
Config.joblabel = "VicRoads"

Config.Locations = {
    --TODO: ["duty"] = 
    ["blip"] = vector4(387.45, -1621.26, 29.29, 320.27),
    ["vehicle"] = vector4(387.45, -1621.26, 29.29, 320.27)
}

Config.DebrisLocations = {

    [1] = vector4(371.6, -1612.57, 29.29, 92.69),
    [2] = vector4(1015.63, -900.98, 30.5, 20.05)
}

Config.Vehicles = {
    ["flatbed"] = "Flatbed",
    ["adder"] = "Managers Adder"
}