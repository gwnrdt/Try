local TeleportTabSystem= {}
 
function TeleportTabSystem:Init(menu, Tabs)
    -- Store references
    self.menu = menu
    self.Tabs = Tabs or {}
 
    -- Create tabs if not provided
    if not self.Tabs.TeleportTab then
        self.Tabs.TeleportTab = menu:CreateTab("Main")
    end
 
    -- ADD MISSING SERVICES AND REFERENCES
    local Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Lighting = game:GetService("Lighting"),
        ReplicatedStorage = game:GetService("ReplicatedStorage"),
        VirtualInputManager = game:GetService("VirtualInputManager")
    }
 
    local Player = Services.Players.LocalPlayer
    local Camera = Services.Workspace.CurrentCamera
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
 

	
--TeleportTab Start
local quickTpGroup = self.menu:CreateCollapsibleGroup(self.Tabs.TeleportTab,"QUICK TP",true,150)
local selectLocationTPGroup = self.menu:CreateCollapsibleGroup(self.Tabs.TeleportTab,"TELEPORTER LOCATION",false,250)
local placeQuickTpGroup = self.menu:CreateCollapsibleGroup(self.Tabs.TeleportTab,"QUICK TP LOCATION",false,200)
self.menu:MarkAsNew(quickTpGroup:GetInstance(),"V2")
self.menu:MarkAsNew(selectLocationTPGroup:GetInstance(),"V2")
self.menu:MarkAsNew(placeQuickTpGroup:GetInstance(),"V2")


local QuickTeleports = {
    {
        Name = "🔥 TP to Camp (Exact)",
        Position = function() 
            return Services.Workspace.Map.BaseCampfire.BaseCampfire.Center.CFrame + Vector3.new(15, 15, 0)
        end
    },
    {
        Name = "⚒️ TP to Craft (Exact)", 
        Position = function()
            return Services.Workspace.Map.Crafting.CraftingRadius.CFrame + Vector3.new(0, 10, 0)
        end
    },
    {
        Name = "🧵 TP to Saddle (Exact)",
        Position = function()
            return Services.Workspace.Map.Events["Saddle Workshop"].Center.CFrame + Vector3.new(0, 5, 0)
        end
    }
}

for _, teleport in ipairs(QuickTeleports) do
    quickTpGroup:AddButton(teleport.Name, function()
        local character = Player.Character or Player.CharacterAdded:Wait()
        local hrp = character:WaitForChild("HumanoidRootPart")
        hrp.CFrame = teleport.Position()
    end)
end

--/////////////////////////////// #Location Teleport System /////////////////////////
local LocationTeleport = {
    SelectedLocation = nil,
    Locations = {
        "Abandoned Clinic",
        "Beast Den",
        "Big Log",
        "Black Skeleton Castle",
        "Cabin",
        "Cabin House",
        "Cabin House2",
        "Cave1",
        "Cave2",
        "Chest Spawn 2",
        "Chest Spawn1",
        "Coal Factory",
        "Control Station",
        "Farm",
        "Fisher House",
        "Goblin Village",
        "Halloween Giant Tree",
        "Helipad",
        "Hunting Tower",
        "Ice Cave",
        "Igloo",
        "Iskarn's Tower",
        "Lab Z",
        "Large Ice Pool",
        "Machine Site",
        "Modern Tent",
        "Plane Crash",
        "Radio Tower",
        "Ruined Green House",
        "Saddle Workshop",
        "Skeleton Base",
        "Skeleton Castle",
        "Small Cave",
        "Small Ice Pool 1",
        "Small Ice Pool 2",
        "SurvivorCave 1",
        "SurvivorCave 2",
        "Tent",
        "Tent 1",
        "Tent 2",
        "Tomb",
        "Watch Tower",
        "Witch House",
        "Zombie Area"
    }
}

-- Function to safely find location part (no errors)
local function findLocationPart(locationName)
    local success, result = pcall(function()
        -- Try direct path first
        local eventsFolder = Services.Workspace:FindFirstChild("Map") and Services.Workspace.Map:FindFirstChild("Events")
        if not eventsFolder then
            return nil
        end
        
        local location = eventsFolder:FindFirstChild(locationName)
        if location then
            -- Look for common part names
            local possibleParts = {"Center", "Part", "BasePart", "HumanoidRootPart", "PrimaryPart"}
            for _, partName in ipairs(possibleParts) do
                local part = location:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    return part
                end
            end
            
            -- If no common part found, look for any BasePart
            for _, obj in ipairs(location:GetDescendants()) do
                if obj:IsA("BasePart") then
                    return obj
                end
            end
        end
        
        return nil
    end)
    
    if success then
        return result
    else
        -- Silently ignore errors and return nil
        return nil
    end
end

-- Function to get available locations (no errors)
local function getAvailableLocations()
    local availableLocations = {}
    local success, result = pcall(function()
        local eventsFolder = Services.Workspace:FindFirstChild("Map") and Services.Workspace.Map:FindFirstChild("Events")
        if not eventsFolder then
            return availableLocations
        end
        
        for _, locationName in ipairs(LocationTeleport.Locations) do
            local location = eventsFolder:FindFirstChild(locationName)
            if location then
                table.insert(availableLocations, locationName)
            end
        end
        
        return availableLocations
    end)
    
    if success then
        return availableLocations
    else
        return {} -- Return empty table on error
    end
end

-- Function to teleport to selected location (no errors)
local function teleportToLocation()
    if not LocationTeleport.SelectedLocation then
        print("❌ Please select a location first!")
        return
    end
    
    local character = Player.Character
    if not character then
        print("❌ Character not found!")
        return
    end
    
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        print("❌ HumanoidRootPart not found!")
        return
    end
    
    print("📍 Searching for location: " .. LocationTeleport.SelectedLocation)
    
    local success, locationPart = pcall(function()
        return findLocationPart(LocationTeleport.SelectedLocation)
    end)
    
    if success and locationPart then
        -- Save original position for return
        TeleportSystems.Rescue.OriginalPosition = hrp.CFrame
        
        -- Teleport to location with a safe offset
        local teleportCFrame = locationPart.CFrame + Vector3.new(0, 5, 0)
        hrp.CFrame = teleportCFrame
        
        print("✅ Teleported to " .. LocationTeleport.SelectedLocation)
        print("📌 Coordinates: " .. tostring(locationPart.Position))
    else
        print("❌ Location '" .. LocationTeleport.SelectedLocation .. "' is not available in this session")
        print("💡 Try a different location or check if the event is active")
    end
end

-- Function to check if location exists (no errors)
local function checkLocationExists(locationName)
    local success, exists = pcall(function()
        local eventsFolder = Services.Workspace:FindFirstChild("Map") and Services.Workspace.Map:FindFirstChild("Events")
        if not eventsFolder then
            return false
        end
        
        local location = eventsFolder:FindFirstChild(locationName)
        return location ~= nil
    end)
    
    return success and exists
end


-- Location dropdown
selectLocationTPGroup:AddDropdown("Select Location to TP", LocationTeleport.Locations, "Select", function(selected)
    LocationTeleport.SelectedLocation = selected
    
    -- Check if location exists without errors
    local exists = checkLocationExists(selected)
    if exists then
        print("📍 Selected location: " .. selected .. " ✅")
    else
        print("📍 Selected location: " .. selected .. " ❌ (Not available)")
    end
end)

-- Teleport button
selectLocationTPGroup:AddButton("🚀 TP to Selected Location", function()
    teleportToLocation()
end)

-- Location information
local availableCount = #getAvailableLocations()
selectLocationTPGroup:AddLabel("📋 Available Locations: " .. availableCount .. "/" .. #LocationTeleport.Locations)


local QuickLocations = {
    {"🏰 Skeleton Castle", "Skeleton Castle"},
    {"⚔️ Goblin Village", "Goblin Village"},
    {"🏕️ Cabin", "Cabin"},
    {"🛩️ Plane Crash", "Plane Crash"},
    {"🧊 Ice Cave", "Ice Cave"},
    {"🔬 Lab Z", "Lab Z"},
    {"🏔️ Beast Den", "Beast Den"},
    {"⚒️ Coal Factory", "Coal Factory"}
}

for _, quickLoc in ipairs(QuickLocations) do
    local locationName = quickLoc[2]
    local exists = checkLocationExists(locationName)
    
    if exists then
        placeQuickTpGroup:AddButton(quickLoc[1], function()
            LocationTeleport.SelectedLocation = locationName
            teleportToLocation()
        end)
    else
        -- Optionally show unavailable locations as disabled (commented out to avoid errors)
        -- self.Tabs.TeleportTabCreateLabel(self.Tabs.TeleportTab, quickLoc[1] .. " ❌ (Unavailable)")
    end
end

-- Manual location refresh button (no errors)
placeQuickTpGroup:AddButton("🔄 Refresh Locations", function()
    print("🔍 Refreshing available locations...")
    
    local success, availableLocations = pcall(getAvailableLocations)
    
    if success then
        print("📋 Found " .. #availableLocations .. " available locations")
        
        if #availableLocations > 0 then
            -- Show available locations
            local availableText = "Available: "
            for i = 1, math.min(8, #availableLocations) do
                availableText = availableText .. availableLocations[i] .. ", "
            end
            if #availableLocations > 8 then
                availableText = availableText .. "..."
            end
            print("📍 " .. availableText)
        else
            print("❌ No locations available in current session")
        end
    else
        print("❌ Failed to refresh locations")
    end
end)

-- Location status display (no errors)
task.spawn(function()
    while true do
        task.wait(15) -- Check less frequently to reduce spam
        if LocationTeleport.SelectedLocation then
            local success, exists = pcall(function()
                return checkLocationExists(LocationTeleport.SelectedLocation)
            end)
            
            if success then
                if exists then
                    print("📍 " .. LocationTeleport.SelectedLocation .. " - Available ✅")
                else
                    print("📍 " .. LocationTeleport.SelectedLocation .. " - Not available ❌")
                end
            end
            -- Silently ignore errors
        end
    end
end)

-- Auto-refresh available locations on game load
task.spawn(function()
    task.wait(5) -- Wait for game to load
    local availableLocations = getAvailableLocations()
    print("📍 Location Teleport System Ready")
    print("📋 " .. #availableLocations .. " locations available in this session")
end)

--TeleportTab end



end

return TeleportTabSystem 
