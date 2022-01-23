--print('config file loaded')

Config = {}

--Set your Roadworker job label
Config.JobLabel = "VicRoads"

--Set Blip Text
Config.BlipLabel = "Roadworks Area"

Config.Locations = {
    --TODO: ["duty"] = 
    ["blip"] = vector3(387.45, -1621.26, 29.29),
    ["vehicle"] = vector4(387.45, -1621.26, 29.29, 320.27)
}

Config.RoadWorkLocations = {
    [1] = {
        label = "This is Location 1",
        coords = {
            Area = vector3(736.64, -1213.53, 44.84),
            Work = {
                [1] = {
                    coords = vector3(750.63, -1212.7, 44.97),
                    Completed = false
                },
                [2] = {
                    coords = vector3(758.23, -1209.32, 45.09),
                    Completed = false
                },
                [3] = {
                    coords = vector3(779.6, -1203.96, 45.39),
                    Completed = false
                },
                [4] = {
                    coords = vector3(756.7, -1173.72, 45.17),
                    Completed = false
                },
            }
        },
        DefaultWork = 4,
        TotalWork = 4,
    },
    [2] = {
        label = "LS Freeway North of Pumping Station",
        coords = {
            Area = vector3(1583.52, 1004.18, 78.96),
            Work = {
                [1] = {
                    coords = vector3(1602.08, 1027.47, 79.68),
                    Completed = false
                },
                [2] = {
                    coords = vector3(1612.98, 1063.83, 80.83),
                    Completed = false
                },
                [3] = {
                    coords = vector3(1582.72, 994.0, 78.89),
                    Completed = false
                },
                [4] = {
                    coords = vector3(1581.82, 973.67, 78.53),
                    Completed = false
                },
            }
        },
        DefaultWork = 4,
        TotalWork = 4,
    },
    [3] = {
        label = "This is Location 3",
        coords = {
            Area = vector3(1039.95, -939.36, 30.31),
            Work = {
                [1] = {
                    coords = vector3(1024.07, -902.21, 30.45),
                    Completed = false
                },
                [2] = {
                    coords = vector3(1016.66, -920.11, 30.32),
                    Completed = false
                },
                [3] = {
                    coords = vector3(1024.29, -935.74, 30.24),
                    Completed = false
                },
                [4] = {
                    coords = vector3(1041.99, -970.84, 30.47),
                    Completed = false
                },
            }
        },
        DefaultWork = 4,
        TotalWork = 4,
    },
}

Config.Vehicles = {
    ["flatbed"] = "Flatbed",
    ["adder"] = "Managers Adder"
}

Config.Rewards = {
    [1] = {
        item = 'iron',
        maxAmount = math.random(1, 5),
        price = math.random(70, 100)
    },
    [2] = {
        item = 'copper',
        maxAmount = math.random(2, 7),
        price = math.random(50, 70)
    }
}