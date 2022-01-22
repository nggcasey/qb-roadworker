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
    [1] = {
        label = "This is Location 1",
        coords = {
            Area = vector3(-2838.8, -376.1, 3.55),
            Coral = {
                [1] = {
                    coords = vector3(-2849.25, -377.58, -40.23),
                    PickedUp = false
                },
                [2] = {
                    coords = vector3(-2838.43, -363.63, -39.45),
                    PickedUp = false
                },
                [3] = {
                    coords = vector3(-2887.04, -394.87, -40.91),
                    PickedUp = false
                },
                [4] = {
                    coords = vector3(-2808.99, -385.56, -39.32),
                    PickedUp = false
                },
            }
        },
        DefaultDebris = 4,
        TotalDebris = 4,
    },
}

Config.Vehicles = {
    ["flatbed"] = "Flatbed",
    ["adder"] = "Managers Adder"
}