Config = {}

-- Define bump thresholds for each vehicle class
Config.BumpThresholds = {
    [0] = 0.055,  -- Compacts
    [1] = 0.06,  -- Sedans
    [2] = 0.08,  -- SUVs
    [3] = 0.06,  -- Coupes
    [4] = 0.07,  -- Muscle
    [5] = 0.055,  -- Sports Classics
    [6] = 0.055,  -- Sports
    [7] = 0.055,  -- Super
    [8] = 1.0,  -- Motorcycles
    [9] = 0.1,   -- Off-road
    
    -- Default value for other or undefined classes
    Default = 1000
}
