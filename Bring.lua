local BringTabSystem = {}

function BringTabSystem:Init(menu, Tabs)
    -- Store references
    self.menu = menu
    self.Tabs = Tabs or {}
    
    -- Create PlayerTab if not provided
    if not self.Tabs.BringTab then
        self.Tabs.BringTab = menu:CreateTab("Bring Stuff")
    end
    
    
-- Services (optimized - combined declarations)
local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    UserInputService = game:GetService("UserInputService"),
    Lighting = game:GetService("Lighting"),
    VirtualInputManager = game:GetService("VirtualInputManager"),
    ReplicatedStorage = game:GetService("ReplicatedStorage")
}

-- Player references
local Player, LocalPlayer = Services.Players.LocalPlayer, Services.Players.LocalPlayer
local Camera = Services.Workspace.CurrentCamera

    
    
--BringTab Start

-- Bring system configuration (optimized)
local BringConfig = {
    Destination = "Player",
    Speed = "Super Fast",
    MaxItems = 200,
    Arrangement = "Single",
    BringHeight = 3,
    SpeedSettings = {
        ["Super Fast"] = {delay = 0.0, batchSize = 100},
        ["Fast"] = {delay = 0.02, batchSize = 10},
        ["Slow"] = {delay = 0.1, batchSize = 2}
    },
    ArrangementSettings = {
        ["Single"] = {spacing = 0, randomOffset = false},
        ["Grid"] = {spacing = 3, randomOffset = false},
        ["Circle"] = {spacing = 4, randomOffset = false}
    }
}

-- Item categories (reduced duplication)
local ItemCategories = {
    Fuel = {"Log", "Frostling", "Coal", "Ashwood", "Gas Can", "Hot Core", "Bio Barrel", "Banana Log"},
    Food = {"Cooked Steak","Cooked Meat", "Raw Meat", "Raw Steak", "Bandage", "Snowberry", "Goldberry", "Camp Soup", "First Aid", "Vaccine", "Raw Giant Meat", "Cooked Giant Meat","Frostshroom"},
    Weapon = {"Iron Axe", "Chainsaw", "Sniper Ammo", "Boomerang", "Wooden Club", "Pistol", "Spear", "Heavy Ammo", "LMG", "Rocket Launcher", "Rocket Ammo", "Frost Axe", "Sniper", "Bow", "Crossbow","Katana","Bone Reaper","Bone Saber","Bone Ravager"},
    Item = {"Rabbit Pelt", "Side Bag", "Wolf Pelt", "Good Sack", "Better Flashlight", "Frostcore", "Old Flashlight", "Old Bag", "Dark Gem", "Mega Flashlight", "Money", "Penguin Backpack", "Penguin Pelt", "Blizzard Piece", "Wood Rod","Mammoth Backpack","Polar Bear Backpack"},
    Gear = {"Rusty Nail", "Scrap Bundle", "Beast Den Item", "Rusty Pipe", "Metal Beam", "Rusty Sheet", "Metal Crate", "Old Gear", "Satellite Dish", "Metal Door", "Wreck Part", "Rusty Generator"},
    Armor = {"Wood Armor", "Iron Armor","Frost Armor"},
    Enemy = {"Zombie", "Ice Goblin Slingshot", "Ice Goblin Tier 1", "Ice Goblin Tier 2", "Ice Goblin Long Range", "Ice Goblin Tier 3"}
}

-- Items to exclude from default selection
local ExcludeItems = {
    Fuel = {"Frostling", "Ashwood", "Log"},
    Food = {"Frostshroom","Cooked Meat","Cooked Steak","Camp Soup"},
    Weapon = {},
    Item = {"Old Flashlight", "Wood Rod", "Better Flashlight","Wolf Pelt"},
    Gear = {},
    Armor = {},
    Enemy = {}
}

local ItemParts = {
    -- Fuel
    ["Log"] = "PrimaryPart", ["Frostling"] = "Hitbox", ["Coal"] = "PrimaryPart", ["Ashwood"] = "PrimaryPart", 
    ["Gas Can"] = "PrimaryPart", ["Hot Core"] = "PrimaryPart", ["Bio Barrel"] = "PrimaryPart", ["Banana Log"] = "PrimaryPart",
    -- Food  
    ["Cooked Steak"] = "Hitbox", ["Cooked Meat"] = "Hitbox", ["Raw Meat"] = "Hitbox", ["Raw Steak"] = "PrimaryPart", ["Bandage"] = "meds", ["Frostshroom"] = "Part",
    ["Snowberry"] = "PrimaryPart", ["Goldberry"] = "PrimaryPart", ["Camp Soup"] = "Part", ["First Aid"] = "Handle",
    ["Vaccine"] = "Handle", ["Raw Giant Meat"] = "Part", ["Cooked Giant Meat"] = "Part",
    -- Weapons
    ["Iron Axe"] = "Iron Axe.001", ["Chainsaw"] = "Circle.007", ["Sniper"] = "PrimaryPart", ["Sniper Ammo"] = "PrimaryPart",
    ["Boomerang"] = "Handle", ["Wooden Club"] = "Handle", ["Pistol"] = "Handle", ["Spear"] = "Circle.003",
    ["Heavy Ammo"] = "PrimaryPart", ["LMG"] = "LMG.002", ["Rocket Launcher"] = "Cube.002", ["Rocket Ammo"] = "Top",
    ["Frost Axe"] = "Handle", ["Crossbow"] = "Handle", ["Bow"] = "Handle", ["Katana"] = "Handle",
    ["Bone Ravager"] = "Handle", ["Bone Saber"] = "Handle", ["Bone Reaper"] = "Handle",["Bone Reaper"] = "Handle",["Bone Ravager"] = "Handle",["Bone Saber"] = "Handle",
    -- Items
    ["Rabbit Pelt"] = "Part", ["Side Bag"] = "Handle", ["Wolf Pelt"] = "Part", ["Good Sack"] = "Handle",
    ["Better Flashlight"] = "Part", ["Frostcore"] = "PrimaryPart", ["Old Flashlight"] = "Circle.003", ["Old Bag"] = "Handle",
    ["Dark Gem"] = "PrimaryPart", ["Mega Flashlight"] = "Handle", ["Money"] = "Part", ["Penguin Backpack"] = "Handle",
    ["Penguin Pelt"] = "PrimaryPart", ["Blizzard Piece"] = "PrimaryPart", ["Wood Rod"] = "Handle", ["Mammoth Backpack"] = "Handle",["Polar Bear Backpack"] = "Handle",
    -- Gear
    ["Rusty Nail"] = "Hitbox", ["Scrap Bundle"] = "PrimaryPart", ["Beast Den Item"] = "ItemSpawnPoint", 
    ["Rusty Pipe"] = "Hitbox", ["Metal Beam"] = "PrimaryPart", ["Rusty Sheet"] = "PrimaryPart", 
    ["Metal Crate"] = "PrimaryPart", ["Old Gear"] = "PrimaryPart", ["Satellite Dish"] = "PrimaryPart",
    ["Metal Door"] = "PrimaryPart", ["Wreck Part"] = "PrimaryPart", ["Rusty Generator"] = "Part",
    -- Armor
    ["Wood Armor"] = "Part", ["Iron Armor"] = "PrimaryPart",["Frost Armor"] = "PrimaryPart",
    -- Enemy
    ["Zombie"] = "Part", ["Ice Goblin Slingshot"] = "Part", ["Ice Goblin Tier 1"] = "Part", 
    ["Ice Goblin Tier 2"] = "Part", ["Ice Goblin Long Range"] = "Part", ["Ice Goblin Tier 3"] = "Part"
}

-- Bring system variables
local BringSystem = {
    IsActive = false,
    CurrentProcess = nil
}

-- Custom Location System for Each Category
local CustomLocations = {
    Fuel = nil,
    Food = nil,
    Weapon = nil,
    Item = nil,
    Gear = nil,
    Armor = nil,
    Enemy = nil
}

-- Location Markers Storage
local LocationMarkers = {}

-- Store combo references for external access
local CategoryCombos = {}

-- Function to create location marker
local function createLocationMarker(category, position)
    -- Remove existing marker for this category
    if LocationMarkers[category] then
        LocationMarkers[category]:Destroy()
        LocationMarkers[category] = nil
    end
    
    -- Create new marker
    local marker = Instance.new("Part")
    marker.Name = category .. "_LocationMarker"
    marker.Size = Vector3.new(4, 0.2, 4)
    marker.Position = position + Vector3.new(0, -3, 0)
    marker.Anchored = true
    marker.CanCollide = false
    marker.Material = Enum.Material.Neon
    
    -- Set color based on category
    local categoryColors = {
        Fuel = Color3.fromRGB(255, 0, 0),      -- Red
        Food = Color3.fromRGB(0, 255, 0),      -- Green
        Weapon = Color3.fromRGB(0, 0, 255),    -- Blue
        Item = Color3.fromRGB(255, 255, 0),    -- Yellow
        Gear = Color3.fromRGB(255, 165, 0),    -- Orange
        Armor = Color3.fromRGB(128, 0, 128),   -- Purple
        Enemy = Color3.fromRGB(255, 0, 255)    -- Pink
    }
    
    marker.BrickColor = BrickColor.new(categoryColors[category] or Color3.fromRGB(255, 255, 255))
    marker.Transparency = 0.3
    
    -- Add surface GUI with category name
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "CategoryLabel"
    billboard.Size = UDim2.new(0, 200, 0, 50)
    billboard.StudsOffset = Vector3.new(0, 4, 0)
    billboard.Adornee = marker
    billboard.AlwaysOnTop = false
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = category .. " Location"
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
    
    billboard.Parent = marker
    marker.Parent = Services.Workspace
    
    LocationMarkers[category] = marker
    CustomLocations[category] = position
    
    print("📍 " .. category .. " location set at: " .. tostring(position))
end

-- Function to remove location marker
local function removeLocationMarker(category)
    if LocationMarkers[category] then
        LocationMarkers[category]:Destroy()
        LocationMarkers[category] = nil
    end
    CustomLocations[category] = nil
    print("🗑️ " .. category .. " location removed")
end

-- Function to set current position as custom location
local function setCurrentLocation(category)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        print("❌ No character found!")
        return false
    end
    
    local position = character.HumanoidRootPart.Position
    createLocationMarker(category, position)
    return true
end

-- Function to teleport to custom location
local function teleportToCustomLocation(category)
    if not CustomLocations[category] then
        print("❌ No " .. category .. " location set!")
        return false
    end
    
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        print("❌ No character found!")
        return false
    end
    
    character.HumanoidRootPart.CFrame = CFrame.new(CustomLocations[category] + Vector3.new(0, 3, 0))
    print("🚀 Teleported to " .. category .. " location")
    return true
end

local function stopAllBringing()
    if BringSystem.IsActive then
        BringSystem.IsActive = false
        BringSystem.CurrentProcess = nil
        print("🛑 All teleportation stopped")
    end
end

local function getTeleportPosition()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local hrp = character.HumanoidRootPart
    
    if BringConfig.Destination == "Player" then
        return hrp.CFrame + Vector3.new(0, BringConfig.BringHeight, 0)
    elseif BringConfig.Destination == "Campfire" then
        local campfire = Services.Workspace.Map.BaseCampfire.BaseCampfire.Center
        return campfire and (campfire.CFrame + Vector3.new(0, BringConfig.BringHeight, 0)) or hrp.CFrame
    elseif BringConfig.Destination == "Crafting" then
        local craft = Services.Workspace.Map.Crafting.CraftingRadius
        return craft and (craft.CFrame + Vector3.new(0, BringConfig.BringHeight, 0)) or hrp.CFrame
    end
    
    return hrp.CFrame + Vector3.new(0, BringConfig.BringHeight, 0)
end

local DraggingRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Dragging")

local function useDraggingRemote(itemObject, state)
    local success = pcall(function()
        local args = {
            "RequestDragging",
            {
                Object = itemObject,
                State = state
            }
        }
        DraggingRemote:InvokeServer(unpack(args))
        return true
    end)
    return success
end

local function calculateItemPositions(totalItems, basePosition)
    local positions = {}
    local config = BringConfig.ArrangementSettings[BringConfig.Arrangement]
    
    if BringConfig.Arrangement == "Single" then
        for i = 1, math.min(totalItems, BringConfig.MaxItems) do
            local offset = Vector3.new(
                config.randomOffset and math.random(-config.spacing, config.spacing) or 0,
                BringConfig.BringHeight + (i * 0.1),
                config.randomOffset and math.random(-config.spacing, config.spacing) or 0
            )
            table.insert(positions, basePosition + offset)
        end
    elseif BringConfig.Arrangement == "Grid" then
        local itemsPerRow = math.ceil(math.sqrt(math.min(totalItems, BringConfig.MaxItems)))
        for i = 1, math.min(totalItems, BringConfig.MaxItems) do
            local row = math.floor((i - 1) / itemsPerRow)
            local col = (i - 1) % itemsPerRow
            local offset = Vector3.new(
                (col - (itemsPerRow - 1) / 2) * config.spacing,
                BringConfig.BringHeight,
                row * config.spacing
            )
            table.insert(positions, basePosition + offset)
        end
    elseif BringConfig.Arrangement == "Circle" then
        for i = 1, math.min(totalItems, BringConfig.MaxItems) do
            local angle = (i / math.min(totalItems, BringConfig.MaxItems)) * math.pi * 2
            local offset = Vector3.new(
                math.cos(angle) * config.spacing,
                BringConfig.BringHeight,
                math.sin(angle) * config.spacing
            )
            table.insert(positions, basePosition + offset)
        end
    end
    
    return positions
end

local function bringSelectedItems(selectedItems, customLocation)
    if BringSystem.IsActive then
        print("❌ A bring operation is already in progress")
        return 0
    end
    
    BringSystem.IsActive = true
    BringSystem.CurrentProcess = "selected_items"
    
    local itemsFolder = Services.Workspace:FindFirstChild("Items") or Services.Workspace:FindFirstChild("Map")
    if not itemsFolder then 
        print("❌ Items folder not found!")
        BringSystem.IsActive = false
        return 0
    end

    local teleportCFrame = customLocation or getTeleportPosition()
    if not teleportCFrame then
        print("❌ Cannot get teleport position!")
        BringSystem.IsActive = false
        return 0
    end

    -- Get all items in the map
    local allItems = {}
    for _, obj in ipairs(itemsFolder:GetDescendants()) do
        if obj:IsA("BasePart") then
            local itemName = obj.Parent.Name
            local partName = ItemParts[itemName]
            
            if partName and obj.Name == partName and selectedItems[itemName] then
                table.insert(allItems, {
                    Model = obj.Parent,
                    Part = obj,
                    Name = itemName
                })
            end
        end
    end

    -- Apply max items limit
    local itemsToMove = {}
    for i = 1, math.min(#allItems, BringConfig.MaxItems) do
        table.insert(itemsToMove, allItems[i])
    end

    local totalToMove = #itemsToMove
    print("🔍 Found " .. #allItems .. " items, moving " .. totalToMove .. " (Max: " .. BringConfig.MaxItems .. ")")

    -- Calculate positions based on arrangement
    local positions = calculateItemPositions(totalToMove, teleportCFrame)
    local speedConfig = BringConfig.SpeedSettings[BringConfig.Speed]
    local moved = 0

    if totalToMove > 0 then
        print("🚀 Starting teleportation of " .. totalToMove .. " items...")
    end

    -- Teleport items in batches based on speed setting
    for batchStart = 1, totalToMove, speedConfig.batchSize do
        if not BringSystem.IsActive then break end
        
        local batchEnd = math.min(batchStart + speedConfig.batchSize - 1, totalToMove)
        
        -- Process current batch
        for i = batchStart, batchEnd do
            if not BringSystem.IsActive then break end
            
            local itemData = itemsToMove[i]
            local targetPosition = positions[i]
            local itemsRemaining = totalToMove - moved
            
            -- Send countdown notification
            if itemsRemaining <= 10 then
                print("⏰ " .. itemsRemaining .. " items remaining...")
            end
            
            -- Use dragging mechanics to move the item
            local dragEnabled = useDraggingRemote(itemData.Model, true)
            
            if speedConfig.delay > 0 then
                task.wait(speedConfig.delay / 2)
            end
            
            -- Move the item while dragging is active
            if itemData.Part and itemData.Part.Parent then
                itemData.Part.CFrame = targetPosition
            end
            
            if speedConfig.delay > 0 then
                task.wait(speedConfig.delay / 2)
            end
            
            -- Disable dragging if it was enabled
            if dragEnabled then
                useDraggingRemote(itemData.Model, false)
            end
            
            moved = moved + 1
        end
        
        -- Wait between batches (except for super fast)
        if batchEnd < totalToMove and speedConfig.delay > 0 and BringSystem.IsActive then
            task.wait(speedConfig.delay * 2)
        end
    end
    
    BringSystem.IsActive = false
    BringSystem.CurrentProcess = nil
    
    if moved > 0 then
        local locationType = customLocation and "Custom " or BringConfig.Destination
        print("✅ Successfully teleported " .. moved .. " items to " .. locationType)
    end
    
    return moved
end

local function bringAllLogsAndAshwoodFast(customLocation)
    if BringSystem.IsActive then
        print("❌ A bring operation is already in progress")
        return 0
    end
    
    BringSystem.IsActive = true
    BringSystem.CurrentProcess = "logs_and_ashwood_fast"
    
    local itemsFolder = Services.Workspace:FindFirstChild("Items") or Services.Workspace:FindFirstChild("Map")
    if not itemsFolder then 
        print("❌ Items folder not found!")
        BringSystem.IsActive = false
        return 0
    end

    local teleportCFrame = customLocation or getTeleportPosition()
    if not teleportCFrame then
        print("❌ Cannot get teleport position!")
        BringSystem.IsActive = false
        return 0
    end

    -- Find all Log and Ashwood items
    local foundItems = {}
    for _, obj in ipairs(itemsFolder:GetDescendants()) do
        if obj:IsA("BasePart") then
            local itemName = obj.Parent.Name
            if (itemName == "Log" and obj.Name == "PrimaryPart") or 
               (itemName == "Ashwood" and obj.Name == "PrimaryPart") then
                table.insert(foundItems, {
                    Model = obj.Parent,
                    Part = obj,
                    Name = itemName
                })
            end
        end
    end

    -- Apply max items limit
    local itemsToMove = {}
    for i = 1, math.min(#foundItems, BringConfig.MaxItems) do
        table.insert(itemsToMove, foundItems[i])
    end

    local totalToMove = #itemsToMove
    print("🪵 Found " .. #foundItems .. " Log/Ashwood items, moving " .. totalToMove)

    -- Calculate positions
    local positions = calculateItemPositions(totalToMove, teleportCFrame)
    local moved = 0

    if totalToMove > 0 then
        print("⚡ ULTRA FAST: Teleporting " .. totalToMove .. " Logs & Ashwood...")
    end

    -- SUPER FAST: No delays, process all at once
    for i, itemData in ipairs(itemsToMove) do
        if not BringSystem.IsActive then break end
        
        local targetPosition = positions[i]
        local itemsRemaining = totalToMove - moved
        
        if itemsRemaining <= 10 then
            print("⏰ " .. itemsRemaining .. " Wood items remaining...")
        end
        
        -- Enable dragging
        local dragEnabled = useDraggingRemote(itemData.Model, true)
        
        -- Move immediately
        if itemData.Part and itemData.Part.Parent then
            itemData.Part.CFrame = targetPosition
        end
        
        -- Disable dragging immediately
        if dragEnabled then
            useDraggingRemote(itemData.Model, false)
        end
        
        moved = moved + 1
    end
    
    BringSystem.IsActive = false
    BringSystem.CurrentProcess = nil
    
    if moved > 0 then
        local locationType = customLocation and "Custom " or BringConfig.Destination
        print("✅ ULTRA FAST: Teleported " .. moved .. " Logs & Ashwood to " .. locationType)
    end
    
    return moved
end

-- Setup Bring Item System with New Combo Function
local function setupBringItemSystem(parentTab)
    -- Initialize selections with excluded items
    local Selections = {}
    local DefaultSelections = {}
    
    for categoryName, items in pairs(ItemCategories) do
        Selections[categoryName] = {}
        DefaultSelections[categoryName] = {}
        
        for _, item in ipairs(items) do
            -- Set to true by default, false if in exclude list
            local isExcluded = table.find(ExcludeItems[categoryName] or {}, item)
            Selections[categoryName][item] = not isExcluded
            DefaultSelections[categoryName][item] = not isExcluded
        end
    end

    -- Configuration Section
    local bringstuffSettingsGroup = self.menu:CreateCollapsibleGroup(self.Tabs.BringTab,"BRING STUFF SETTINGS",false,150)
    self.menu:MarkAsNew(bringstuffSettingsGroup:GetInstance(),"V2")
    bringstuffSettingsGroup:AddDropdown("📍 Teleport Destination", {"Player", "Campfire", "Crafting"}, BringConfig.Destination, function(selected)
        BringConfig.Destination = selected
        print("📌 Item destination set to: " .. selected)
    end)

    bringstuffSettingsGroup:AddDropdown("⚡ Teleport Speed", {"Super Fast", "Fast", "Slow"}, BringConfig.Speed, function(selected)
        BringConfig.Speed = selected
        print("⚡ Teleport speed set to: " .. selected)
    end)

    bringstuffSettingsGroup:AddDropdown("📐 Item Arrangement", {"Single", "Grid", "Circle"}, BringConfig.Arrangement, function(selected)
        BringConfig.Arrangement = selected
        print("📐 Item arrangement set to: " .. selected)
    end)

    bringstuffSettingsGroup:AddSlider("🔢 Max Items to Teleport", 1, 500, BringConfig.MaxItems, function(value)
        BringConfig.MaxItems = value
        print("🔢 Max items set to: " .. value)
    end)

    bringstuffSettingsGroup:AddSlider("📏 Bring Height", 0, 20, BringConfig.BringHeight, function(value)
        BringConfig.BringHeight = value
        print("📏 Bring height set to: " .. value)
    end)

    
    --local bringstuffStopGroup = self.menu:CreateCollapsibleGroup(self.Tabs.BringTab,"🛑 STOP BRING STUFF(P)",true,100)
    self.menu:CreateButton(parentTab,"🛑 STOP ALL TELEPORT (P KEY)", function()
        stopAllBringing()
    end)

    local bringstuffGroup = self.menu:CreateCollapsibleGroup(self.Tabs.BringTab,"BRING STUFF v2",true,300)
    self.menu:MarkAsNew(bringstuffGroup:GetInstance(),"V2")
    -- Create category combos with location setting functionality
    for categoryName, items in pairs(ItemCategories) do
        local emoji = categoryName == "Fuel" and "⛽" or 
                     categoryName == "Food" and "🍔" or 
                     categoryName == "Weapon" and "⚔️" or 
                     categoryName == "Item" and "🛠️" or 
                     categoryName == "Gear" and "⚙️" or 
                     categoryName == "Armor" and "🛡️" or "🧟‍♂️"
        
        -- Create the combo for this category
        local combo = bringstuffGroup:AddCombo(
            emoji .. " " .. categoryName,
            function(toggleState)
                -- Toggle callback: Set location when toggled ON, remove when toggled OFF
                if toggleState then
                    print("📍 Setting " .. categoryName .. " location...")
                    local success = setCurrentLocation(categoryName)
                    if not success then
                        -- If failed to set location, turn toggle back off
                        combo:SetToggle(false)
                        print("❌ Failed to set " .. categoryName .. " location")
                    else
                        print("✅ " .. categoryName .. " location set successfully")
                    end
                else
                    -- When toggled OFF, remove the location marker
                    print("🔄 Removing " .. categoryName .. " location...")
                    removeLocationMarker(categoryName)
                    print("🗑️ " .. categoryName .. " location removed (toggle turned off)")
                end
            end,
            function()
                -- Action 1: Bring items to custom location or default
                local customLocation = CustomLocations[categoryName]
                local locationCFrame = nil
                
                if customLocation then
                    locationCFrame = CFrame.new(customLocation + Vector3.new(0, BringConfig.BringHeight, 0))
                    print("🚀 Bringing " .. categoryName .. " items to custom location...")
                else
                    print("🚀 Bringing " .. categoryName .. " items to " .. BringConfig.Destination .. "...")
                end
                
                local count = bringSelectedItems(Selections[categoryName], locationCFrame)
                print("✅ Teleported " .. count .. " " .. categoryName .. " items using " .. BringConfig.Speed .. " speed")
            end,
            function()
                -- Action 2: Reset/Remove location marker and turn off toggle
                print("🔄 Resetting " .. categoryName .. " location...")
                removeLocationMarker(categoryName)
                -- Turn off the toggle
                combo:SetToggle(false)
                print("🗑️ " .. categoryName .. " location reset and toggle turned off")
            end,
            false -- isPremium
        )
        
        -- Store combo reference
        CategoryCombos[categoryName] = combo
        
        -- Add item selection dropdown below the combo
        bringstuffGroup:AddMultiDropdown("⏩ Select " .. categoryName .. " Items ", items, DefaultSelections[categoryName], function(selectionsArray)
            for itemName, _ in pairs(Selections[categoryName]) do
                Selections[categoryName][itemName] = false
            end
            for _, itemName in ipairs(selectionsArray) do
                Selections[categoryName][itemName] = true
            end
            print("Updated " .. categoryName .. " selection: " .. table.concat(selectionsArray, ", "))
        end)
    end
    
    local woodCombo = bringstuffGroup:AddCombo(
        "🪓 Logs & Ashwood Only",
        function(toggleState)
            -- Toggle callback: Set location when toggled ON, remove when toggled OFF
            if toggleState then
                print("📍 Setting wood location...")
                local success = setCurrentLocation("Fuel") -- Use Fuel category for wood
                if not success then
                    woodCombo:SetToggle(false)
                    print("❌ Failed to set wood location")
                else
                    print("✅ Wood location set successfully")
                end
            else
                -- When toggled OFF, remove the location marker
                print("🔄 Removing wood location...")
                removeLocationMarker("Fuel")
                print("🗑️ Wood location removed (toggle turned off)")
            end
        end,
        function()
            -- Action 1: Bring wood to custom location or default
            local customLocation = CustomLocations["Fuel"]
            local locationCFrame = nil
            
            if customLocation then
                locationCFrame = CFrame.new(customLocation + Vector3.new(0, BringConfig.BringHeight, 0))
                print("🚀 Bringing wood to custom location...")
            else
                print("🚀 Bringing wood to " .. BringConfig.Destination .. "...")
            end
            
            local count = bringAllLogsAndAshwoodFast(locationCFrame)
            print("🪓 ULTRA FAST: Teleported " .. count .. " Logs & Ashwood")
        end,
        function()
            -- Action 2: Reset/Remove location marker and turn off toggle
            print("🔄 Resetting wood location...")
            removeLocationMarker("Fuel")
            woodCombo:SetToggle(false)
            print("🗑️ Wood location reset and toggle turned off")
        end,
        false
    )

    -- Store wood combo reference
    CategoryCombos["Wood"] = woodCombo

    bringstuffGroup:AddButton("🌍 BRING ALL SELECTED ITEMS", function()
        local allSelections = {}
        for categoryName, categorySelections in pairs(Selections) do
            for itemName, isSelected in pairs(categorySelections) do
                if isSelected then
                    allSelections[itemName] = true
                end
            end
        end
        
        local count = bringSelectedItems(allSelections)
        print("🌍 Teleported " .. count .. " TOTAL items using " .. BringConfig.Speed .. " speed to " .. BringConfig.Destination)
    end)

    bringstuffGroup:AddButton("🗑️ CLEAR ALL LOCATIONS", function()
        for categoryName, combo in pairs(CategoryCombos) do
            removeLocationMarker(categoryName == "Wood" and "Fuel" or categoryName)
            combo:SetToggle(false)
        end
        print("🗑️ All custom locations cleared and toggles reset")
    end)
    
    bringstuffGroup:AddButton("📋 SHOW ACTIVE LOCATIONS", function()
        local activeLocations = {}
        for categoryName in pairs(ItemCategories) do
            if CustomLocations[categoryName] then
                table.insert(activeLocations, categoryName)
            end
        end
        
        if #activeLocations > 0 then
            print("📍 Active Locations: " .. table.concat(activeLocations, ", "))
            
            -- Also update toggle states to reflect actual state
            for categoryName, combo in pairs(CategoryCombos) do
                local actualCategory = categoryName == "Wood" and "Fuel" or categoryName
                if CustomLocations[actualCategory] then
                    combo:SetToggle(true)
                else
                    combo:SetToggle(false)
                end
            end
        else
            print("📍 No active locations set")
            
            -- Ensure all toggles are off
            for categoryName, combo in pairs(CategoryCombos) do
                combo:SetToggle(false)
            end
        end
    end)

    -- Auto-sync toggle states when locations exist on script start
    task.spawn(function()
        task.wait(2) -- Wait a bit for everything to load
        for categoryName, combo in pairs(CategoryCombos) do
            local actualCategory = categoryName == "Wood" and "Fuel" or categoryName
            if CustomLocations[actualCategory] then
                combo:SetToggle(true)
                print("🔄 Auto-synced " .. actualCategory .. " toggle to ON (location exists)")
            else
                combo:SetToggle(false)
            end
        end
    end)
end

-- Initialize Bring System
setupBringItemSystem(self.Tabs.BringTab)

-- Keybind for stop
Services.UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.P then
        stopAllBringing()
    end
end)

-- Clean up markers when script stops
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        for categoryName in pairs(LocationMarkers) do
            removeLocationMarker(categoryName)
        end
    end
end)


end

return BringTabSystem
