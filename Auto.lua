local AutoTabSystem= {}

function AutoTabSystem:Init(menu, Tabs)
    -- Store references
    self.menu = menu
    self.Tabs = Tabs or {}
    
    -- Create tabs if not provided
    if not self.Tabs.AutoTab then
        self.Tabs.AutoTab = menu:CreateTab("Auto")
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
    
    -- ADD MISSING FUNCTION DECLARATIONS
    local function getCirclePositions(center, radius, count)
        local positions = {}
        for i = 1, count do
            local angle = (i / count) * math.pi * 2
            local x = center.X + math.cos(angle) * radius
            local z = center.Z + math.sin(angle) * radius
            local position = Vector3.new(x, center.Y, z)
            table.insert(positions, position)
        end
        return positions
    end

    local function getGridPositions(center, size, spacing)
        local positions = {}
        local halfSize = math.floor(size / 2)
        
        for x = -halfSize, halfSize do
            for z = -halfSize, halfSize do
                local position = Vector3.new(
                    center.X + (x * spacing),
                    center.Y,
                    center.Z + (z * spacing)
                )
                table.insert(positions, position)
            end
        end
        return positions
    end

    -- Map Reveal System (optimized)
    local MapReveal = {
        Active = false, 
        Player = Player,
        CurrentRadius = 0,
        CurrentAngle = 0
    }
    local CameraFreeView = {Enabled = false, OriginalCameraType = nil}
    local mapCenter, mapRadius, height = Vector3.new(0, 386.61, 0), 2000, 100

    function MapReveal:StartReveal()
        if self.Active then return end
        self.Active = true
        
        local character = self.Player.Character or self.Player.CharacterAdded:Wait()
        local rootPart = character:WaitForChild("HumanoidRootPart")
        
        spawn(function()
            local currentRadius = self.CurrentRadius
            local currentAngle = self.CurrentAngle
            local radiusStep, angleStep = 50, math.rad(10)
            
            while self.Active and currentRadius <= mapRadius do
                -- Start from the last angle for the current radius
                for angle = currentAngle, math.pi * 2, angleStep do
                    if not self.Active then 
                        -- Save progress before breaking
                        self.CurrentRadius = currentRadius
                        self.CurrentAngle = angle
                        break 
                    end
                    
                    local position = Vector3.new(
                        mapCenter.X + currentRadius * math.cos(angle),
                        mapCenter.Y + height,
                        mapCenter.Z + currentRadius * math.sin(angle)
                    )
                    rootPart.CFrame = CFrame.new(position)
                    task.wait(0.02)
                end
                
                if not self.Active then break end
                
                -- Move to next radius and reset angle
                currentRadius = currentRadius + radiusStep
                currentAngle = 0
                self.CurrentRadius = currentRadius
                self.CurrentAngle = 0
            end
            
            if self.Active then
                -- Completion logic
                rootPart.CFrame = CFrame.new(mapCenter.X, mapCenter.Y + height, mapCenter.Z)
                self:ResetProgress() -- Reset when fully completed
                self.Active = false
            end
        end)
    end

    function MapReveal:StopReveal()
        self.Active = false
    end

    function MapReveal:ResetProgress()
        self.CurrentRadius = 0
        self.CurrentAngle = 0
    end

    local revealMapGroup = self.menu:CreateCollapsibleGroup(self.Tabs.AutoTab,"🗺️ REVEAL FULL MAP 🗺️",true,150)
    self.menu:MarkAsNew(revealMapGroup:GetInstance(), "V2")
    revealMapGroup:AddButton("START Complete Map Coverage", function()
        if not MapReveal.Active then 
            MapReveal:StartReveal() 
        end
    end)

    revealMapGroup:AddButton("STOP Coverage", function()
        if MapReveal.Active then 
            MapReveal:StopReveal() 
        end
    end)
    revealMapGroup:AddToggle("Camera Free View", false, function(state)
        CameraFreeView.Enabled = state
        Camera.CameraType = state and Enum.CameraType.Scriptable or (CameraFreeView.OriginalCameraType or Enum.CameraType.Custom)
    end)
    -- Optional: Add a reset button to start from beginning
    revealMapGroup:AddButton("RESET Progress", function()
        MapReveal:StopReveal()
        MapReveal:ResetProgress()
    end)

    -- Auto Plant System
    local AutoPlant = {
        Enabled = false,
        PlantingMode = "Single", -- "Single", "Circle", "Grid"
        CenterLocation = nil,
        SingleLocation = nil,
        CircleRadius = 60,
        GridSize = 5,
        GridSpacing = 5,
        Connection = nil,
        Status = "Ready",
        ScanCooldown = 5, -- Seconds between scans
        LastScanTime = 0,
        IsPlanting = false,
        VisualMarkers = {}, -- Store visual markers
        ComboRef = nil -- Store combo reference
    }

    -- Get the remote events
    local DraggingRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Dragging")
    local InventoryRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Inventory")

    -- Function to calculate optimal number of plants for circle based on radius
    local function calculateCirclePlantCount(radius)
        -- Calculate circumference
        local circumference = 2 * math.pi * radius
        
        -- Optimal spacing between plants (adjust this value as needed)
        local optimalSpacing = 2 -- studs between plants
        
        -- Calculate number of plants needed
        local plantCount = math.max(8, math.floor(circumference / optimalSpacing))
        
        -- Limit to reasonable maximum
        plantCount = math.min(plantCount, 36)
        
        print("📐 Circle: Radius " .. radius .. " -> " .. plantCount .. " plants (spacing: " .. math.floor(circumference / plantCount) .. " studs)")
        return plantCount
    end

    -- Function to create visual markers
    local function createVisualMarker(position, markerType, index)
        -- Remove existing marker if it exists
        if AutoPlant.VisualMarkers[markerType .. (index or "")] then
            AutoPlant.VisualMarkers[markerType .. (index or "")]:Destroy()
        end
        
        -- Create marker part
        local marker = Instance.new("Part")
        marker.Name = "PlantMarker_" .. markerType .. (index or "")
        marker.Size = Vector3.new(4, 0.2, 4)
        marker.Position = position + Vector3.new(0, -3, 0)
        marker.Anchored = true
        marker.CanCollide = false
        marker.Material = Enum.Material.Neon
        
        -- Set color based on marker type
        if markerType == "Center" then
            marker.BrickColor = BrickColor.new("Bright blue")
        elseif markerType == "Single" then
            marker.BrickColor = BrickColor.new("Bright green")
        elseif markerType == "Circle" then
            marker.BrickColor = BrickColor.new("Bright yellow")
        elseif markerType == "Grid" then
            marker.BrickColor = BrickColor.new("Bright orange")
        else
            marker.BrickColor = BrickColor.new("White")
        end
        
        marker.Transparency = 0.8
        
        -- Create billboard GUI with name
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "MarkerLabel"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Adornee = marker
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = markerType .. (index and " " .. index or "")
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0
        label.TextSize = 14
        label.Font = Enum.Font.GothamBold
        label.Parent = billboard
        
        billboard.Parent = marker
        marker.Parent = Services.Workspace
        
        -- Store marker reference
        AutoPlant.VisualMarkers[markerType .. (index or "")] = marker
        
        return marker
    end

    -- Function to clear all visual markers
    local function clearAllMarkers()
        for markerName, marker in pairs(AutoPlant.VisualMarkers) do
            if marker and marker.Parent then
                marker:Destroy()
            end
        end
        AutoPlant.VisualMarkers = {}
        print("🗑️ Cleared all planting markers")
    end

    -- Function to update circle markers
    local function updateCircleMarkers()
        if AutoPlant.PlantingMode ~= "Circle" or not AutoPlant.CenterLocation then return end
        
        -- Clear existing circle markers
        for markerName, marker in pairs(AutoPlant.VisualMarkers) do
            if markerName:find("Circle") then
                marker:Destroy()
                AutoPlant.VisualMarkers[markerName] = nil
            end
        end
        
        -- Create center marker
        createVisualMarker(AutoPlant.CenterLocation, "Center")
        
        -- Calculate optimal plant count based on radius
        local plantCount = calculateCirclePlantCount(AutoPlant.CircleRadius)
        
        -- Create circle position markers
        local positions = getCirclePositions(AutoPlant.CenterLocation, AutoPlant.CircleRadius, plantCount)
        for i, position in ipairs(positions) do
            createVisualMarker(position, "Circle", i)
        end
        
        print("🎯 Circle markers updated: " .. plantCount .. " positions")
    end

    -- Function to update grid markers
    local function updateGridMarkers()
        if AutoPlant.PlantingMode ~= "Grid" or not AutoPlant.CenterLocation then return end
        
        -- Clear existing grid markers
        for markerName, marker in pairs(AutoPlant.VisualMarkers) do
            if markerName:find("Grid") then
                marker:Destroy()
                AutoPlant.VisualMarkers[markerName] = nil
            end
        end
        
        -- Create center marker
        createVisualMarker(AutoPlant.CenterLocation, "Center")
        
        -- Create grid position markers
        local positions = getGridPositions(AutoPlant.CenterLocation, AutoPlant.GridSize, AutoPlant.GridSpacing)
        for i, position in ipairs(positions) do
            createVisualMarker(position, "Grid", i)
        end
    end

    -- Function to update single marker
    local function updateSingleMarker()
        if AutoPlant.PlantingMode ~= "Single" or not AutoPlant.SingleLocation then return end
        
        -- Clear existing single marker
        if AutoPlant.VisualMarkers["Single"] then
            AutoPlant.VisualMarkers["Single"]:Destroy()
            AutoPlant.VisualMarkers["Single"] = nil
        end
        
        -- Create single marker
        createVisualMarker(AutoPlant.SingleLocation, "Single")
    end

    -- Function to find ALL Frostling items on the map
    local function findAllFrostlings()
        local frostlings = {}
        local itemsFolder = Services.Workspace:FindFirstChild("Items")
        
        if not itemsFolder then 
            print("❌ Items folder not found!")
            return frostlings
        end

        -- Scan all Frostlings in the Items folder
        for _, item in ipairs(itemsFolder:GetChildren()) do
            if item.Name == "Frostling" then
                local hitbox = item:FindFirstChild("Hitbox") or item:FindFirstChild("PrimaryPart") or item:FindFirstChild("Part")
                if hitbox then
                    table.insert(frostlings, {
                        Model = item,
                        Part = hitbox,
                        Position = hitbox.Position
                    })
                end
            end
        end
        
        return frostlings
    end

    -- Function to plant Frostling at target position
    local function plantFrostling(frostlingData, targetPosition)
        if not frostlingData or not frostlingData.Model or not frostlingData.Model.Parent then
            return false
        end

        -- First teleport the Frostling to the target position using dragging
        local dragSuccess = pcall(function()
            -- Enable dragging
            local args = {
                "RequestDragging",
                {
                    Object = frostlingData.Model,
                    State = true
                }
            }
            DraggingRemote:InvokeServer(unpack(args))
            
            task.wait(0.05)
            
            -- Move to target position
            if frostlingData.Part and frostlingData.Part.Parent then
                frostlingData.Part.CFrame = CFrame.new(targetPosition)
            end
            
            task.wait(0.05)
            
            -- Disable dragging
            local args = {
                "RequestDragging",
                {
                    Object = frostlingData.Model,
                    State = false
                }
            }
            DraggingRemote:InvokeServer(unpack(args))
            
            return true
        end)
        
        if not dragSuccess then
            print("❌ Failed to position Frostling")
            return false
        end
        
        -- Wait a bit for the item to settle
        task.wait(0.3)
        
        -- Now use the plant remote event
        local plantSuccess = pcall(function()
            local args = {
                "Plant",
                {
                    Object = frostlingData.Model
                }
            }
            InventoryRemote:InvokeServer(unpack(args))
            return true
        end)
        
        if plantSuccess then
            print("✅ Planted Frostling")
            return true
        else
            print("❌ Failed to plant Frostling")
            return false
        end
    end

    -- Function to set current position as center
    local function setCenterLocation()
        local character = Player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            print("❌ No character found!")
            return false
        end
        
        AutoPlant.CenterLocation = character.HumanoidRootPart.Position
        print("📍 Center location set: " .. tostring(AutoPlant.CenterLocation))
        
        -- Update visual markers
        if AutoPlant.PlantingMode == "Circle" then
            updateCircleMarkers()
        elseif AutoPlant.PlantingMode == "Grid" then
            updateGridMarkers()
        else
            createVisualMarker(AutoPlant.CenterLocation, "Center")
        end
        
        return true
    end

    -- Function to set current position as single plant location
    local function setSingleLocation()
        local character = Player.Character
        if not character or not character:FindFirstChild("HumanoidRootPart") then
            print("❌ No character found!")
            return false
        end
        
        AutoPlant.SingleLocation = character.HumanoidRootPart.Position
        print("📍 Single plant location set: " .. tostring(AutoPlant.SingleLocation))
        
        -- Update visual marker
        updateSingleMarker()
        
        return true
    end

    -- Function to get campfire center position
    local function getCampfireCenter()
        local campfire = Services.Workspace:FindFirstChild("Map") and 
                        Services.Workspace.Map:FindFirstChild("BaseCampfire") and
                        Services.Workspace.Map.BaseCampfire:FindFirstChild("BaseCampfire") and
                        Services.Workspace.Map.BaseCampfire.BaseCampfire:FindFirstChild("Center")
        
        if campfire then
            return campfire.Position
        else
            -- Fallback to player position if campfire not found
            local character = Player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                return character.HumanoidRootPart.Position
            end
            return Vector3.new(0, 0, 0)
        end
    end

    -- Function to get next planting position
    local function getNextPlantingPosition(plantedCount)
        if AutoPlant.PlantingMode == "Single" then
            return AutoPlant.SingleLocation or getCampfireCenter()
            
        elseif AutoPlant.PlantingMode == "Circle" then
            local center = AutoPlant.CenterLocation or getCampfireCenter()
            local plantCount = calculateCirclePlantCount(AutoPlant.CircleRadius)
            local positions = getCirclePositions(center, AutoPlant.CircleRadius, plantCount)
            local index = (plantedCount % plantCount) + 1
            return positions[index]
            
        elseif AutoPlant.PlantingMode == "Grid" then
            local center = AutoPlant.CenterLocation or getCampfireCenter()
            local positions = getGridPositions(center, AutoPlant.GridSize, AutoPlant.GridSpacing)
            local index = (plantedCount % #positions) + 1
            return positions[index]
        end
        
        return getCampfireCenter() -- Fallback
    end

    -- Function for instant plant all (one-time session)
    local function instantPlantAll()
        if AutoPlant.IsPlanting then
            print("❌ Already planting, please wait...")
            return
        end
        
        print("🚀 Starting instant plant all session...")
        
        -- Find all Frostlings on the map
        local allFrostlings = findAllFrostlings()
        
        if #allFrostlings == 0 then
            print("❌ No Frostlings found to plant!")
            return
        end
        
        print("🌱 Found " .. #allFrostlings .. " Frostlings - Planting now...")
        
        local plantedCount = 0
        AutoPlant.IsPlanting = true
        
        -- Plant each Frostling found
        for _, frostlingData in ipairs(allFrostlings) do
            -- Check if Frostling still exists
            if frostlingData.Model and frostlingData.Model.Parent then
                local targetPosition = getNextPlantingPosition(plantedCount)
                
                if plantFrostling(frostlingData, targetPosition) then
                    plantedCount = plantedCount + 1
                    print("✅ Planted Frostling #" .. plantedCount)
                end
                
                task.wait(0.5) -- Delay between plants
            end
        end
        
        AutoPlant.IsPlanting = false
        print("🎉 Instant plant session completed! Planted " .. plantedCount .. " Frostlings")
    end

    -- Function to reset locations and markers
    local function resetPlantLocations()
        print("🔄 Resetting plant locations...")
        
        -- Clear locations
        AutoPlant.CenterLocation = nil
        AutoPlant.SingleLocation = nil
        
        -- Clear all markers
        clearAllMarkers()
        
        -- Update combo toggle state
        if AutoPlant.ComboRef then
            AutoPlant.ComboRef:SetToggle(false)
        end
        
        print("🗑️ All plant locations and markers reset")
    end

    -- Toggle callback function
    local function toggleCallback(state)
        if state then
            -- Set location based on current planting mode
            if AutoPlant.PlantingMode == "Single" then
                if setSingleLocation() then
                    print("📍 Single location selected and marked")
                else
                    if AutoPlant.ComboRef then
                        AutoPlant.ComboRef:SetToggle(false)
                    end
                end
            else -- Circle or Grid mode
                if setCenterLocation() then
                    print("📍 Center location selected and marked")
                else
                    if AutoPlant.ComboRef then
                        AutoPlant.ComboRef:SetToggle(false)
                    end
                end
            end
        else
            -- Remove markers but keep locations
            clearAllMarkers()
            print("📍 Location markers removed")
        end
    end

    -- Action 1 callback: Instant plant all
    local function action1Callback()
        print("🚀 Starting instant plant all...")
        instantPlantAll()
    end

    -- Action 2 callback: Reset everything
    local function action2Callback()
        print("🔄 Resetting plant system...")
        resetPlantLocations()
    end

    -- Main auto plant function
    local function startAutoPlant()
        if AutoPlant.Enabled then return end
        
        AutoPlant.Enabled = true
        AutoPlant.Status = "🟢 Auto Plant Started - Scanning for Frostlings..."
        print(AutoPlant.Status)
        
        local plantedCount = 0

        -- Continuous planting loop
        AutoPlant.Connection = Services.RunService.Heartbeat:Connect(function()
            if not AutoPlant.Enabled then
                if AutoPlant.Connection then
                    AutoPlant.Connection:Disconnect()
                    AutoPlant.Connection = nil
                end
                return
            end
            
            -- Check if we can scan again (cooldown)
            local currentTime = tick()
            if currentTime - AutoPlant.LastScanTime < AutoPlant.ScanCooldown then
                return
            end
            
            AutoPlant.LastScanTime = currentTime
            
            -- Don't start new planting if still planting
            if AutoPlant.IsPlanting then
                return
            end
            
            -- Find all Frostlings on the map
            local allFrostlings = findAllFrostlings()
            
            if #allFrostlings > 0 then
                AutoPlant.Status = "🌱 Found " .. #allFrostlings .. " Frostlings - Planting..."
                print(AutoPlant.Status)
                
                -- Plant each Frostling found
                for _, frostlingData in ipairs(allFrostlings) do
                    if not AutoPlant.Enabled then break end
                    
                    -- Check if Frostling still exists
                    if frostlingData.Model and frostlingData.Model.Parent then
                        AutoPlant.IsPlanting = true
                        
                        local targetPosition = getNextPlantingPosition(plantedCount)
                        
                        if plantFrostling(frostlingData, targetPosition) then
                            plantedCount = plantedCount + 1
                            AutoPlant.Status = "🌱 Planted " .. plantedCount .. " Frostlings"
                            print("✅ Planted Frostling #" .. plantedCount)
                        end
                        
                        AutoPlant.IsPlanting = false
                        task.wait(0.5) -- Delay between plants
                    end
                end
                
                if #allFrostlings > 0 then
                    print("🌱 Finished planting batch of " .. #allFrostlings .. " Frostlings")
                end
                
            else
                AutoPlant.Status = "🔍 Scanning... No Frostlings found"
                -- Don't print this every scan to avoid spam
                if math.random(1, 10) == 1 then -- Only print occasionally
                    print("🔍 Auto Plant: No Frostlings found on map")
                end
            end
        end)
    end

    -- Function to stop auto plant
    local function stopAutoPlant()
        AutoPlant.Enabled = false
        AutoPlant.IsPlanting = false
        
        if AutoPlant.Connection then
            AutoPlant.Connection:Disconnect()
            AutoPlant.Connection = nil
        end
        
        AutoPlant.Status = "🛑 Auto Plant Stopped"
        print(AutoPlant.Status)
    end

    -- Function to toggle auto plant
    local function toggleAutoPlant(state)
        if state then
            startAutoPlant()
        else
            stopAutoPlant()
        end
    end

    -- Create collapsible groups for better organization
    local autoPlantGroup = self.menu:CreateCollapsibleGroup(self.Tabs.AutoTab, "🌱 AUTO PLANT FROSTLING", false, 240)

    -- Add "NEW" badge to the group
    self.menu:MarkAsNew(autoPlantGroup:GetInstance(), "NEW")

    -- Create the main combo for plant location selection
    AutoPlant.ComboRef = self.menu:CreateCombo(
        {Frame = autoPlantGroup:GetInstance().Container.Content}, -- Access the group's content frame
        "🌱 Plant Location",
        toggleCallback,      -- Toggle: Set/Remove location markers
        action1Callback,     -- Action 1: Instant plant all
        action2Callback,     -- Action 2: Reset locations
        false                -- Not premium
    )

    -- Main Auto Plant Toggle (continuous mode)
    autoPlantGroup:AddToggle("🌱 Turn on Auto Plant", false, function(state)
        toggleAutoPlant(state)
    end)

    -- Quick location buttons
    autoPlantGroup:AddButton("🔥 Use Campfire as Center", function()
        AutoPlant.CenterLocation = getCampfireCenter()
        print("📍 Using campfire as center: " .. tostring(AutoPlant.CenterLocation))
        
        -- Update markers if combo is toggled
        if AutoPlant.ComboRef and AutoPlant.ComboRef:GetState().Toggled then
            if AutoPlant.PlantingMode == "Circle" then
                updateCircleMarkers()
            elseif AutoPlant.PlantingMode == "Grid" then
                updateGridMarkers()
            else
                createVisualMarker(AutoPlant.CenterLocation, "Center")
            end
        end
    end)

    -- Emergency Stop Button
    autoPlantGroup:AddButton("🛑 STOP Auto Plant", function()
        if AutoPlant.Enabled then
            toggleAutoPlant(false)
        else
            print("ℹ️ Auto Plant is already stopped")
        end
    end)

    -- Planting Mode Selection
    autoPlantGroup:AddDropdown("Planting Mode", {"Single", "Circle", "Grid"}, "Single", function(selected)
        AutoPlant.PlantingMode = selected
        print("🌱 Planting mode set to: " .. selected)
        
        -- Update markers when mode changes if location is set
        if AutoPlant.ComboRef and AutoPlant.ComboRef:GetState().Toggled then
            if selected == "Circle" and AutoPlant.CenterLocation then
                updateCircleMarkers()
            elseif selected == "Grid" and AutoPlant.CenterLocation then
                updateGridMarkers()
            elseif selected == "Single" and AutoPlant.SingleLocation then
                updateSingleMarker()
            end
        end
    end)

    -- Circle Settings with dynamic spacing info
    autoPlantGroup:AddSlider("Circle Radius", 10, 100, 60, function(value)
        AutoPlant.CircleRadius = value
        local plantCount = calculateCirclePlantCount(value)
        local circumference = 2 * math.pi * value
        local spacing = math.floor(circumference / plantCount)
        print("🌱 Circle radius: " .. value .. " studs -> " .. plantCount .. " plants (" .. spacing .. " studs spacing)")
        
        if AutoPlant.PlantingMode == "Circle" and AutoPlant.CenterLocation and AutoPlant.ComboRef:GetState().Toggled then
            updateCircleMarkers()
        end
    end)

    -- Grid Settings
    autoPlantGroup:AddSlider("Grid Size", 2, 10, 5, function(value)
        AutoPlant.GridSize = value
        print("🌱 Grid size set to: " .. value .. "x" .. value)
        if AutoPlant.PlantingMode == "Grid" and AutoPlant.CenterLocation and AutoPlant.ComboRef:GetState().Toggled then
            updateGridMarkers()
        end
    end)

    autoPlantGroup:AddSlider("Grid Spacing", 2, 10, 5, function(value)
        AutoPlant.GridSpacing = value
        print("🌱 Grid spacing set to: " .. value .. " studs")
        if AutoPlant.PlantingMode == "Grid" and AutoPlant.CenterLocation and AutoPlant.ComboRef:GetState().Toggled then
            updateGridMarkers()
        end
    end)

    -- Scan Cooldown Setting
    autoPlantGroup:AddSlider("Scan Cooldown (seconds)", 1, 30, 5, function(value)
        AutoPlant.ScanCooldown = value
        print("🌱 Scan cooldown set to: " .. value .. " seconds")
    end)

    -- Circle information display
    autoPlantGroup:AddLabel("📐 Circle: Plants adjust automatically based on radius")

    -- Manual Scan Button
    autoPlantGroup:AddButton("🔍 Manual Scan for Frostlings", function()
        local frostlings = findAllFrostlings()
        print("🌱 Found " .. #frostlings .. " Frostling items on the map")
    end)

    -- Status Display
    autoPlantGroup:AddLabel("Status: " .. AutoPlant.Status)

    -- Auto-stop conditions
    task.spawn(function()
        while true do
            task.wait(2)
            if AutoPlant.Enabled then
                local character = Player.Character
                if not character or not character:FindFirstChild("HumanoidRootPart") or 
                   (character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0) then
                    stopAutoPlant()
                end
            end
        end
    end)

    -- Cleanup when player leaves
    Player.CharacterRemoving:Connect(function()
        if AutoPlant.Enabled then
            stopAutoPlant()
        end
        clearAllMarkers()
    end)

    -- Cleanup when script stops
    game:GetService("Players").PlayerRemoving:Connect(function(player)
        if player == Player then
            clearAllMarkers()
        end
    end)

    print("✅ Auto Plant Frostling System with Collapsible Groups Loaded!")
	
	
-- Get the Dragging remote
local DraggingRemote
pcall(function()
    DraggingRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Dragging")
end)

-- Item categories and mappings
local ItemCategories = {
    Fuel = {"Log", "Frostling", "Coal", "Ashwood", "Gas Can", "Hot Core", "Bio Barrel", "Banana Log"},
    Food = {"Cooked Meat", "Raw Meat", "Raw Steak", "Bandage", "Snowberry", "Goldberry", "Camp Soup", "First Aid", "Vaccine", "Raw Giant Meat", "Cooked Giant Meat","Frostshroom"},
    Weapon = {"Iron Axe", "Chainsaw", "Sniper Ammo", "Boomerang", "Wooden Club", "Pistol", "Spear", "Heavy Ammo", "LMG", "Rocket Launcher", "Rocket Ammo", "Frost Axe", "Sniper", "Bow", "Crossbow","Katana","Bone Reaper","Bone Ravager","Bone Saber"},
    Item = {"Rabbit Pelt", "Side Bag", "Wolf Pelt", "Good Sack", "Better Flashlight", "Frostcore", "Old Flashlight", "Old Bag", "Dark Gem", "Mega Flashlight", "Money", "Penguin Backpack", "Penguin Pelt", "Blizzard Piece", "Wood Rod","Mammoth Backpack"},
    Gear = {"Rusty Nail", "Scrap Bundle", "Beast Den Item", "Rusty Pipe", "Metal Beam", "Rusty Sheet", "Metal Crate", "Old Gear", "Satellite Dish", "Metal Door", "Wreck Part", "Rusty Generator"},
    Armor = {"Wood Armor", "Iron Armor","Frost Armor"}
}

-- IMPROVED ITEM DETECTION - More flexible part matching
local ItemParts = {
    -- Fuel
    ["Log"] = {"PrimaryPart", "Wood"},
    ["Frostling"] = {"Hitbox", "PrimaryPart"},
    ["Coal"] = {"PrimaryPart", "CoalPart"},
    ["Ashwood"] = {"PrimaryPart", "Wood"},
    ["Gas Can"] = {"PrimaryPart", "Can"},
    ["Hot Core"] = {"PrimaryPart", "Core"},
    ["Bio Barrel"] = {"PrimaryPart", "Barrel"},
    ["Banana Log"] = {"PrimaryPart", "Wood"},
    -- Food  
    ["Cooked Meat"] = {"Hitbox", "PrimaryPart", "Meat"},
    ["Raw Meat"] = {"Hitbox", "PrimaryPart", "Meat"},
    ["Raw Steak"] = {"PrimaryPart", "Steak"},
    ["Bandage"] = {"meds", "PrimaryPart", "Bandage"},
    ["Frostshroom"] = {"Part", "PrimaryPart", "Mushroom"},
    ["Snowberry"] = {"PrimaryPart", "Berry"},
    ["Goldberry"] = {"PrimaryPart", "Berry"},
    ["Camp Soup"] = {"Part", "PrimaryPart", "Soup"},
    ["First Aid"] = {"Handle", "PrimaryPart"},
    ["Vaccine"] = {"Handle", "PrimaryPart"},
    ["Raw Giant Meat"] = {"Part", "PrimaryPart", "Meat"},
    ["Cooked Giant Meat"] = {"Part", "PrimaryPart", "Meat"},
    -- Weapons
    ["Iron Axe"] = {"Iron Axe.001", "Handle", "PrimaryPart"},
    ["Chainsaw"] = {"Circle.007", "Handle", "PrimaryPart"},
    ["Sniper"] = {"PrimaryPart", "Handle"},
    ["Sniper Ammo"] = {"PrimaryPart", "Ammo"},
    ["Boomerang"] = {"Handle", "PrimaryPart"},
    ["Wooden Club"] = {"Handle", "PrimaryPart"},
    ["Pistol"] = {"Handle", "PrimaryPart"},
    ["Spear"] = {"Circle.003", "Handle", "PrimaryPart"},
    ["Heavy Ammo"] = {"PrimaryPart", "Ammo"},
    ["LMG"] = {"LMG.002", "Handle", "PrimaryPart"},
    ["Rocket Launcher"] = {"Cube.002", "Handle", "PrimaryPart"},
    ["Rocket Ammo"] = {"Top", "PrimaryPart", "Ammo"},
    ["Frost Axe"] = {"Handle", "PrimaryPart"},
    ["Crossbow"] = {"Handle", "PrimaryPart"},
    ["Bow"] = {"Handle", "PrimaryPart"},
    ["Katana"] = {"Handle", "PrimaryPart"},
    ["Bone Ravager"] = {"Handle", "PrimaryPart"},
    ["Bone Reaper"] = {"Handle", "PrimaryPart"},
    ["Bone Saber"] = {"Handle", "PrimaryPart"},
    -- Items
    ["Rabbit Pelt"] = {"Part", "PrimaryPart", "Pelt"},
    ["Side Bag"] = {"Handle", "PrimaryPart", "Bag"},
    ["Wolf Pelt"] = {"Part", "PrimaryPart", "Pelt"},
    ["Good Sack"] = {"Handle", "PrimaryPart", "Bag"},
    ["Better Flashlight"] = {"Part", "PrimaryPart", "Flashlight"},
    ["Frostcore"] = {"PrimaryPart", "Core"},
    ["Old Flashlight"] = {"Circle.003", "Handle", "PrimaryPart"},
    ["Old Bag"] = {"Handle", "PrimaryPart", "Bag"},
    ["Dark Gem"] = {"PrimaryPart", "Gem"},
    ["Mega Flashlight"] = {"Handle", "PrimaryPart", "Flashlight"},
    ["Money"] = {"Part", "PrimaryPart", "Cash"},
    ["Penguin Backpack"] = {"Handle", "PrimaryPart", "Backpack"},
    ["Penguin Pelt"] = {"PrimaryPart", "Pelt"},
    ["Blizzard Piece"] = {"PrimaryPart", "Piece"},
    ["Wood Rod"] = {"Handle", "PrimaryPart", "Rod"},
    ["Mammoth Backpack"] = {"Handle", "PrimaryPart", "Backpack"},
    -- Gear
    ["Rusty Nail"] = {"Hitbox", "PrimaryPart", "Nail"},
    ["Scrap Bundle"] = {"PrimaryPart", "Bundle"},
    ["Beast Den Item"] = {"ItemSpawnPoint", "PrimaryPart"},
    ["Rusty Pipe"] = {"Hitbox", "PrimaryPart", "Pipe"},
    ["Metal Beam"] = {"PrimaryPart", "Beam"},
    ["Rusty Sheet"] = {"PrimaryPart", "Sheet"},
    ["Metal Crate"] = {"PrimaryPart", "Crate"},
    ["Old Gear"] = {"PrimaryPart", "Gear"},
    ["Satellite Dish"] = {"PrimaryPart", "Dish"},
    ["Metal Door"] = {"PrimaryPart", "Door"},
    ["Wreck Part"] = {"PrimaryPart", "Part"},
    ["Rusty Generator"] = {"Part", "PrimaryPart", "Generator"},
    -- Armor
    ["Wood Armor"] = {"Part", "PrimaryPart", "Armor"},
    ["Iron Armor"] = {"PrimaryPart", "Armor"},
    ["Frost Armor"] = {"PrimaryPart", "Armor"}
}

-- ============================= AUTO LOOT CHEST SYSTEM =============================
local AutoLoot = {
    Enabled = false,
    IsLooting = false,
    OriginalPosition = nil,
    ChestTypes = {
        Common = true,
        Uncommon = true,
        Rare = true,
        Epic = true,
        Legendary = true,
        Mythical = true,
        ["Z Common Chest"] = true
    },
    LootRange = 500,
    ItemAuraRange = 10, -- Increased range for better detection
    CurrentChest = nil,
    Connection = nil,
    Status = "Ready",
    ChestsToLoot = {},
    LootedChests = {},
    InstantOpenEnabled = false,
    ItemSelection = {},
    DebugMode = true -- Added debug mode to see what's being detected
}

-- Initialize item selection (all enabled by default)
for categoryName, items in pairs(ItemCategories) do
    for _, itemName in ipairs(items) do
        AutoLoot.ItemSelection[itemName] = true
    end
end

local function updateLootStatus(status)
    AutoLoot.Status = status
    print("🎒 " .. status)
end

-- Enable instant open for all proximity prompts
local function enableInstantOpen()
    for _, obj in pairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") then
            obj.HoldDuration = 0
        end
    end
    
    Services.Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
        end
    end)
    
    AutoLoot.InstantOpenEnabled = true
    print("⚡ Instant Open enabled for all interactions")
end

-- Scan all chests in the game and mark them for looting
local function scanAllChests()
    local chestsFolder = Services.Workspace:FindFirstChild("Map") and Services.Workspace.Map:FindFirstChild("Chests")
    if not chestsFolder then 
        print("❌ Chests folder not found!")
        return {} 
    end

    local foundChests = {}
    
    for _, chestModel in pairs(chestsFolder:GetChildren()) do
        if AutoLoot.ChestTypes[chestModel.Name] and not AutoLoot.LootedChests[chestModel] then
            local promptPart = chestModel:FindFirstChild("PromptPart")
            if promptPart then
                table.insert(foundChests, {
                    Model = chestModel,
                    Type = chestModel.Name,
                    PromptPart = promptPart,
                    Position = promptPart.Position
                })
            end
        end
    end
    
    -- Sort by distance from player
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local playerPos = character.HumanoidRootPart.Position
        table.sort(foundChests, function(a, b) 
            return (a.Position - playerPos).Magnitude < (b.Position - playerPos).Magnitude 
        end)
    end
    
    return foundChests
end

-- IMPROVED: Find any item near position with flexible part detection
local function findItemsInAura(position)
    local itemsFolder = Services.Workspace:FindFirstChild("Items")
    if not itemsFolder then 
        if AutoLoot.DebugMode then
            print("❌ Items folder not found!")
        end
        return {} 
    end

    local foundItems = {}
    local totalScanned = 0
    
    for _, itemModel in pairs(itemsFolder:GetChildren()) do
        local itemName = itemModel.Name
        totalScanned = totalScanned + 1
        
        if AutoLoot.ItemSelection[itemName] then
            local possibleParts = ItemParts[itemName] or {"PrimaryPart", "Handle", "Part"}
            local foundPart = nil
            
            -- Try all possible part names
            for _, partName in ipairs(possibleParts) do
                local part = itemModel:FindFirstChild(partName)
                if part and part:IsA("BasePart") then
                    foundPart = part
                    break
                end
            end
            
            -- If no specific part found, try to find any BasePart
            if not foundPart then
                for _, descendant in pairs(itemModel:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        foundPart = descendant
                        break
                    end
                end
            end
            
            if foundPart then
                local distance = (foundPart.Position - position).Magnitude
                if distance <= AutoLoot.ItemAuraRange then
                    table.insert(foundItems, {
                        Model = itemModel,
                        Part = foundPart,
                        Name = itemName,
                        Distance = distance
                    })
                    if AutoLoot.DebugMode then
                        print("✅ Found: " .. itemName .. " at " .. math.floor(distance) .. " studs")
                    end
                end
            else
                if AutoLoot.DebugMode then
                    print("❌ No valid part found for: " .. itemName)
                end
            end
        end
    end
    
    if AutoLoot.DebugMode then
        print("🔍 Scanned " .. totalScanned .. " items, found " .. #foundItems .. " in aura")
    end
    
    return foundItems
end

-- IMPROVED: Better item teleportation with error handling
local function teleportItemsToBase(position, items)
    local itemsTeleported = 0
    
    for _, itemData in ipairs(items) do
        -- Check if item still exists
        if itemData.Model and itemData.Model.Parent and itemData.Part and itemData.Part.Parent then
            local success, result = pcall(function()
                -- Enable dragging
                local args = {
                    "RequestDragging",
                    {
                        Object = itemData.Model,
                        State = true
                    }
                }
                DraggingRemote:InvokeServer(unpack(args))
                
                task.wait(0.03)
                
                -- Move item to ORIGINAL POSITION with some spread to avoid stacking
                local spread = Vector3.new(
                    math.random(-3, 3),
                    3,
                    math.random(-3, 3)
                )
                itemData.Part.CFrame = CFrame.new(position + spread)
                
                task.wait(0.03)
                
                -- Disable dragging
                local args = {
                    "RequestDragging",
                    {
                        Object = itemData.Model,
                        State = false
                    }
                }
                DraggingRemote:InvokeServer(unpack(args))
                
                return true
            end)
            
            if success then
                itemsTeleported = itemsTeleported + 1
                if AutoLoot.DebugMode then
                    print("🚀 Teleported: " .. itemData.Name)
                end
            else
                if AutoLoot.DebugMode then
                    print("❌ Failed to teleport: " .. itemData.Name .. " - " .. tostring(result))
                end
            end
        else
            if AutoLoot.DebugMode then
                print("❌ Item no longer exists: " .. itemData.Name)
            end
        end
        
        task.wait(0.1) -- Slightly longer delay between items
    end
    
    return itemsTeleported
end

-- Collect items in aura and teleport them to base
local function collectAuraItemsToBase(chestPosition)
    local items = findItemsInAura(chestPosition)
    
    if #items > 0 and AutoLoot.OriginalPosition then
        local itemsTeleported = teleportItemsToBase(AutoLoot.OriginalPosition.Position, items)
        return itemsTeleported, #items
    end
    
    return 0, 0
end

local function savePlayerPosition()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        AutoLoot.OriginalPosition = character.HumanoidRootPart.CFrame
        return true
    end
    return false
end

local function teleportToChest(chestData)
    if not chestData then return false end
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    local teleportPos = chestData.Position + Vector3.new(0, 2, 0)
    character.HumanoidRootPart.CFrame = CFrame.new(teleportPos)
    return true
end

local function returnPlayerToOriginal()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    if AutoLoot.OriginalPosition then
        character.HumanoidRootPart.CFrame = AutoLoot.OriginalPosition
        return true
    end
    return false
end

local function simulateEKeyPress()
    local virtualInput = Services.VirtualInputManager
    pcall(function()
        virtualInput:SendKeyEvent(true, Enum.KeyCode.E, false, nil)
        task.wait(0.05)
        virtualInput:SendKeyEvent(false, Enum.KeyCode.E, false, nil)
    end)
    return true
end

local function markChestAsLooted(chestModel)
    AutoLoot.LootedChests[chestModel] = true
    -- Remove from to-loot list
    for i, chestData in ipairs(AutoLoot.ChestsToLoot) do
        if chestData.Model == chestModel then
            table.remove(AutoLoot.ChestsToLoot, i)
            break
        end
    end
end

local function lootSingleChest(chestData)
    if not chestData then return false end
    
    -- Teleport to chest
    teleportToChest(chestData)
    simulateEKeyPress()
    task.wait(0.5) -- Increased wait for stability
    
    -- Collect items in aura around chest and teleport them to base
    local itemsTeleported, totalFound = collectAuraItemsToBase(chestData.Position)
    if itemsTeleported > 0 then
        updateLootStatus("📦 Sent " .. itemsTeleported .. "/" .. totalFound .. " items to base")
    else
        updateLootStatus("🔍 No items found in aura")
    end
    
    -- Open chest with E
    simulateEKeyPress()
    task.wait(0.3) -- Increased wait for chest opening
    
    -- Mark as looted
    markChestAsLooted(chestData.Model)
    
    return true
end

local function startAutoLoot()
    if AutoLoot.IsLooting then return end
    
    if not savePlayerPosition() then
        updateLootStatus("❌ Failed to save position!")
        return
    end
    
    -- Step 1: Enable instant open for all
    enableInstantOpen()
    
    -- Step 2: Scan all chests and mark for looting
    AutoLoot.ChestsToLoot = scanAllChests()
    
    if #AutoLoot.ChestsToLoot == 0 then
        updateLootStatus("❌ No chests found to loot!")
        return
    end
    
    updateLootStatus("🔍 Found " .. #AutoLoot.ChestsToLoot .. " chests to loot")
    
    AutoLoot.IsLooting = true
    updateLootStatus("🟢 Auto Loot Started!")
    
    AutoLoot.Connection = Services.RunService.Heartbeat:Connect(function()
        if not AutoLoot.Enabled or not AutoLoot.IsLooting then
            if AutoLoot.Connection then
                AutoLoot.Connection:Disconnect()
                AutoLoot.Connection = nil
            end
            return
        end
        
        if #AutoLoot.ChestsToLoot > 0 then
            local chestData = AutoLoot.ChestsToLoot[1] -- Get next chest
            
            -- Step 3: Teleport to chest, collect items to base, and press E
            lootSingleChest(chestData)
            updateLootStatus("✅ " .. chestData.Type)
            
            -- Step 4: Return to original position
            returnPlayerToOriginal()
            task.wait(0.5) -- Increased wait for stability
            
            updateLootStatus("📊 Remaining: " .. (#AutoLoot.ChestsToLoot) .. " chests")
            
        else
            updateLootStatus("🎉 All chests looted!")
            stopAutoLoot()
        end
    end)
end

local function stopAutoLoot()
    AutoLoot.IsLooting = false
    AutoLoot.Enabled = false
    
    if AutoLoot.Connection then
        AutoLoot.Connection:Disconnect()
        AutoLoot.Connection = nil
    end
    
    returnPlayerToOriginal()
    updateLootStatus("🛑 Auto Loot Stopped")
end

local function toggleAutoLoot(state)
    if state then
        AutoLoot.Enabled = true
        startAutoLoot()
    else
        stopAutoLoot()
    end
end

local function clearLootedChests()
    AutoLoot.LootedChests = {}
    AutoLoot.ChestsToLoot = {}
    updateLootStatus("🗑️ Cleared all looted chests")
end

local function rescanChests()
    AutoLoot.ChestsToLoot = scanAllChests()
    updateLootStatus("🔍 Rescanned: " .. #AutoLoot.ChestsToLoot .. " chests to loot")
end

-- Add Auto Loot to GUI
local autolootchestGroup = self.menu:CreateCollapsibleGroup(self.Tabs.AutoTab,"🎁 AUTO LOOT CHEST",false,240)
self.menu:MarkAsNew(autolootchestGroup:GetInstance(),"NEW")

autolootchestGroup:AddToggle("🎁 Turn on Auto loot chest", false, function(state)
    toggleAutoLoot(state)
end)

autolootchestGroup:AddButton("🛑 STOP", function()
    toggleAutoLoot(false)
end)
-- Chest Type Selection
autolootchestGroup:AddMultiDropdown("Select Chest Types", 
    {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Z Common Chest"}, 
    {"Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythical", "Z Common Chest"}, 
    function(selectionsArray)
        AutoLoot.ChestTypes = {}
        for _, chestType in ipairs(selectionsArray) do
            AutoLoot.ChestTypes[chestType] = true
        end
        updateLootStatus("Chests: " .. table.concat(selectionsArray, ", "))
    end
)

-- Item Category Selection
local allItems = {}
for categoryName, items in pairs(ItemCategories) do
    for _, itemName in ipairs(items) do
        table.insert(allItems, itemName)
    end
end

autolootchestGroup:AddMultiDropdown("Select Items to Collect", 
    allItems, 
    allItems,
    function(selectionsArray)
        AutoLoot.ItemSelection = {}
        for _, itemName in ipairs(selectionsArray) do
            AutoLoot.ItemSelection[itemName] = true
        end
        updateLootStatus("Items: " .. #selectionsArray .. " selected")
    end
)

autolootchestGroup:AddSlider("Chest Range", 50, 1000, AutoLoot.LootRange, function(value)
    AutoLoot.LootRange = value
    updateLootStatus("Chest range: " .. value .. " studs")
end)

autolootchestGroup:AddSlider("Item Aura Range", 50, 200, AutoLoot.ItemAuraRange, function(value)
    AutoLoot.ItemAuraRange = value
    updateLootStatus("Aura range: " .. value .. " studs")
end)



autolootchestGroup:AddButton("🔍 RESCAN CHESTS", function()
    rescanChests()
end)

autolootchestGroup:AddButton("🗑️ CLEAR LOOTED", function()
    clearLootedChests()
end)


autolootchestGroup:AddLabel("Status: " .. AutoLoot.Status)

-- Auto-stop
task.spawn(function()
    while true do
        task.wait(2)
        if AutoLoot.Enabled then
            local character = Player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") or (character:FindFirstChild("Humanoid") and character.Humanoid.Health <= 0) then
                stopAutoLoot()
            end
        end
    end
end)

-- Cleanup
Player.CharacterRemoving:Connect(function()
    if AutoLoot.Enabled then
        stopAutoLoot()
    end
end)

print("✅ SFY Ultimate Menu - Improved Base Collector Loaded!")

local autoeatGroup = self.menu:CreateCollapsibleGroup(self.Tabs.AutoTab,"🍗 AUTO EAT (FOOD TO PLAYER)",true,240)

--// 🍗 Auto Eat System (Updated - Food Teleports to Player)
local AutoEat = {
    Enabled = false,
    Threshold = 60,
    SelectedFoods = {},
    HungerPath = nil,
    Connection = nil,
    TeleportRange = 500, -- Range to search for food
    EatCooldown = 0.5, -- Delay between eating attempts
    LastEatTime = 0
}

local FoodItems = {
    "Cooked Meat", "Cooked Steak", "Raw Meat", "Raw Steak", "Snowberry", 
    "Goldberry", "Frostshroom", "Camp Soup", "Banana", "Goblin Stew",
    "Raw Giant Meat", "Cooked Giant Meat"
}
local DefaultFoodList = {
    "Cooked Meat",
    "Cooked Steak",
    "Snowberry",
    "Goldberry",
    "Frostshroom",
    "Camp Soup",
    "Banana",
    "Cooked Giant Meat"
}

-- Initialize selected foods (all enabled by default)
for _, food in ipairs(FoodItems) do
    AutoEat.SelectedFoods[food] = true
end

-- Food Part Mapping (Updated with correct part names)
local FoodParts = {
    ["Cooked Meat"] = "PrimaryPart",
    ["Cooked Steak"] = "PrimaryPart",
    ["Raw Meat"] = "PrimaryPart", 
    ["Raw Steak"] = "PrimaryPart",
    ["Snowberry"] = "PrimaryPart",
    ["Goldberry"] = "PrimaryPart",
    ["Frostshroom"] = "Part",
    ["Camp Soup"] = "Bow",
    ["Banana"] = "PrimaryPart",
    ["Goblin Stew"] = "Bow",
    ["Raw Giant Meat"] = "Part",
    ["Cooked Giant Meat"] = "Part"
}

-- Get the Dragging remote (same as used in Bring Stuff)
local DraggingRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Dragging")
local InventoryRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Inventory")

-- Find hunger path
task.spawn(function()
    repeat
        task.wait(1)
        for _, folder in ipairs(Services.Workspace:GetChildren()) do
            if folder:FindFirstChild(Player.Name) then
                local status = folder[Player.Name]:FindFirstChild("Status")
                if status and status:FindFirstChild("Hunger") then
                    AutoEat.HungerPath = status.Hunger
                    print("[AutoEat] Hunger path found: " .. AutoEat.HungerPath:GetFullName())
                    break
                end
            end
        end
    until AutoEat.HungerPath
end)

-- Helper functions
local function getFoodInRange()
    local items = Services.Workspace:FindFirstChild("Items")
    if not items then 
        print("[AutoEat] Items folder not found")
        return {} 
    end

    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return {}
    end
    
    local playerPos = character.HumanoidRootPart.Position
    local foundFood = {}
    
    for _, item in ipairs(items:GetChildren()) do
        if AutoEat.SelectedFoods[item.Name] then
            local targetPartName = FoodParts[item.Name]
            if targetPartName then
                local part = item:FindFirstChild(targetPartName)
                if not part then
                    -- Fallback: search for any BasePart
                    for _, desc in ipairs(item:GetDescendants()) do
                        if desc:IsA("BasePart") then
                            part = desc
                            break
                        end
                    end
                end
                
                if part and part:IsA("BasePart") then
                    local distance = (part.Position - playerPos).Magnitude
                    if distance <= AutoEat.TeleportRange then
                        table.insert(foundFood, {
                            Model = item,
                            Part = part,
                            Name = item.Name,
                            Distance = distance
                        })
                    end
                end
            end
        end
    end
    
    -- Sort by distance (closest first)
    table.sort(foundFood, function(a, b) return a.Distance < b.Distance end)
    return foundFood
end

local function teleportFoodToPlayer(foodData)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then 
        return false 
    end
    
    local hrp = character.HumanoidRootPart
    local foodPosition = hrp.CFrame + Vector3.new(0, 3, 0) -- Position above player
    
    -- Use dragging mechanics to move the food (same as Bring Stuff system)
    local dragSuccess = pcall(function()
        local args = {
            "RequestDragging",
            {
                Object = foodData.Model,
                State = true
            }
        }
        DraggingRemote:InvokeServer(unpack(args))
        return true
    end)
    
    if not dragSuccess then
        print("[AutoEat] Failed to enable dragging for: " .. foodData.Name)
        return false
    end
    
    -- Wait a tiny bit for dragging to activate
    task.wait(0.05)
    
    -- Move the food to player position
    if foodData.Part and foodData.Part.Parent then
        foodData.Part.CFrame = foodPosition
    end
    
    -- Wait a tiny bit before disabling drag
    task.wait(0.05)
    
    -- Disable dragging
    pcall(function()
        local args = {
            "RequestDragging",
            {
                Object = foodData.Model,
                State = false
            }
        }
        DraggingRemote:InvokeServer(unpack(args))
    end)
    
    print("[AutoEat] Teleported " .. foodData.Name .. " to player")
    return true
end

local function eatFood(foodModel)
    local success, result = pcall(function()
        local args = {
            "Eat",
            {
                Object = foodModel
            }
        }
        InventoryRemote:InvokeServer(unpack(args))
        return true
    end)
    
    if success then
        print("[AutoEat] Successfully ate: " .. (foodModel and foodModel.Name or "Unknown"))
        return true
    else
        print("[AutoEat] Failed to eat: " .. tostring(result))
        return false
    end
end

-- Main Auto Eat loop (Food comes to player)
local function AutoEatLoop()
    while AutoEat.Enabled do
        local hunger = AutoEat.HungerPath and AutoEat.HungerPath.Value or 100
        
        if hunger < AutoEat.Threshold then
            print("[AutoEat] Hunger low: " .. hunger .. " | Threshold: " .. AutoEat.Threshold)
            
            -- Find food in range
            local availableFood = getFoodInRange()
            
            if #availableFood > 0 then
                print("[AutoEat] Found " .. #availableFood .. " food items in range")
                
                -- Try each food item until hunger is satisfied
                for _, foodData in ipairs(availableFood) do
                    if not AutoEat.Enabled then break end
                    if AutoEat.HungerPath and AutoEat.HungerPath.Value >= 100 then break end
                    
                    print("[AutoEat] Processing: " .. foodData.Name .. " (Distance: " .. math.floor(foodData.Distance) .. ")")
                    
                    -- Teleport food to player
                    if teleportFoodToPlayer(foodData) then
                        -- Wait for food to arrive
                        task.wait(0.2)
                        
                        -- Try to eat the food multiple times
                        local eatAttempts = 0
                        local maxAttempts = 3
                        
                        while eatAttempts < maxAttempts and AutoEat.Enabled do
                            if AutoEat.HungerPath and AutoEat.HungerPath.Value >= 100 then
                                break
                            end
                            
                            if eatFood(foodData.Model) then
                                -- Successfully ate, check if we need more
                                task.wait(0.3) -- Wait for hunger update
                                
                                if AutoEat.HungerPath and AutoEat.HungerPath.Value >= 100 then
                                    print("[AutoEat] Hunger satisfied!")
                                    break
                                end
                            end
                            
                            eatAttempts = eatAttempts + 1
                            task.wait(0.2)
                        end
                        
                        -- Cooldown between different food items
                        task.wait(AutoEat.EatCooldown)
                    end
                end
            else
                print("[AutoEat] No selected food items found within " .. AutoEat.TeleportRange .. " studs")
                -- Wait longer if no food found
                task.wait(3)
            end
        else
            print("[AutoEat] Hunger sufficient: " .. hunger .. " | Threshold: " .. AutoEat.Threshold)
        end
        
        task.wait(1) -- Check hunger every second
    end
    print("[AutoEat] Auto Eat loop ended")
end


local AutoEatT = autoeatGroup:AddToggle("Enable Auto Eat", false, function(state)
    AutoEat.Enabled = state
    if state then
        print("[AutoEat] Auto Eat enabled - Food teleports to player")
        print("[AutoEat] Hunger threshold: " .. AutoEat.Threshold)
        print("[AutoEat] Search range: " .. AutoEat.TeleportRange .. " studs")
        if not AutoEat.HungerPath then
            print("[AutoEat] Warning: Hunger path not found yet, still searching...")
        end
        -- Start the auto eat loop
        task.spawn(AutoEatLoop)
    else
        print("[AutoEat] Auto Eat disabled")
        -- The loop will automatically stop due to the while condition
    end
end)

-- Auto Eat MultiDropdown
autoeatGroup:AddMultiDropdown("Select Foods 🍔", FoodItems, DefaultFoodList, function(selectionsArray, selectionsTable)
    -- Clear all selections first
    for foodName in pairs(AutoEat.SelectedFoods) do
        AutoEat.SelectedFoods[foodName] = false
    end
    
    -- Set selected foods based on the returned array
    for _, selectedFood in ipairs(selectionsArray) do
        AutoEat.SelectedFoods[selectedFood] = true
    end
    
    -- Print selected foods for debugging
    local selected = {}
    for food, isSelected in pairs(AutoEat.SelectedFoods) do
        if isSelected then
            table.insert(selected, food)
        end
    end
    print("[AutoEat] Selected foods: " .. table.concat(selected, ", "))
end)

-- Hunger threshold slider
autoeatGroup:AddSlider("Hunger Threshold (%)", 0, 100, AutoEat.Threshold, function(value)
    AutoEat.Threshold = value
    print("[AutoEat] Hunger threshold set to: " .. value)
end)

-- Food search range slider
autoeatGroup:AddSlider("Food Search Range", 50, 1000, AutoEat.TeleportRange, function(value)
    AutoEat.TeleportRange = value
    print("[AutoEat] Food search range set to: " .. value .. " studs")
end)

-- Eat cooldown slider
autoeatGroup:AddSlider("Eat Cooldown", 0.1, 2, AutoEat.EatCooldown, function(value)
    AutoEat.EatCooldown = value
    print("[AutoEat] Eat cooldown set to: " .. value .. " seconds")
end)

-- Manual eat button for testing
autoeatGroup:AddButton("🍽️ MANUAL EAT NEAREST FOOD", function()
    local availableFood = getFoodInRange()
    if #availableFood > 0 then
        local foodData = availableFood[1]
        print("[AutoEat] Manually eating: " .. foodData.Name)
        if teleportFoodToPlayer(foodData) then
            task.wait(0.3)
            eatFood(foodData.Model)
        end
    else
        print("[AutoEat] No food found in range")
    end
end)

-- Hunger status display
task.spawn(function()
    while true do
        task.wait(5)
        if AutoEat.HungerPath then
            local hunger = AutoEat.HungerPath.Value
            if AutoEat.Enabled then
                local status = hunger < AutoEat.Threshold and "ACTIVE - Eating" or "INACTIVE - Full"
                print("[AutoEat] Status - Hunger: " .. hunger .. " | " .. status)
            end
        else
            print("[AutoEat] Still searching for hunger path...")
        end
    end
end)

-- Food availability monitor
task.spawn(function()
    while true do
        task.wait(10)
        if AutoEat.Enabled then
            local availableFood = getFoodInRange()
            print("[AutoEat] Food Monitor - " .. #availableFood .. " items in range")
        end
    end
end)



local autochoptreeGroup = self.menu:CreateCollapsibleGroup(self.Tabs.AutoTab,"AUTO CHOP TREE 🌲",false,250)
self.menu:MarkAsNew(autochoptreeGroup:GetInstance(),"V2")


-- Auto chop tree (Fixed Version with Closer Positioning)
local AutoChop = {
    Enabled = false,
    TreesData = {},
    SelectedTreeType = "Small",
    Connection = nil,
    CurrentTarget = nil,
    Range = 500,
    Delay = 0.1,
    OriginalPosition = nil,
    IsTeleported = false,
    EnemyRange = 50,
    LastEnemyCheck = 0,
    EnemyCheckInterval = 1.0,
    Status = "Ready"
}

local ActionRemote = Services.ReplicatedStorage:WaitForChild("Signals"):WaitForChild("Action")

-- Store the toggle reference for updating
local AutoChopToggleRef = nil

-- Function to update status
local function updateChopStatus(status)
    AutoChop.Status = status
    print("🌲 " .. status)
end

-- Function to update toggle state in GUI
local function updateToggleState(state)
    AutoChop.Enabled = state
    if AutoChopToggleRef then
        -- This is a workaround since the library might not have direct toggle updating
        -- In a real implementation, you'd use the library's update method
        print("🔄 Toggle state updated to: " .. tostring(state))
    end
    
    if state then
        print("🟢 Auto Chop: ENABLED")
    else
        print("🔴 Auto Chop: DISABLED")
    end
end

local function isTreeValid(tree)
    if not tree then return false end
    if not tree.folder or not tree.folder.Parent then return false end
    if not tree.model or not tree.model.Parent then return false end
    if not tree.basePart or not tree.basePart.Parent then return false end
    return true
end

local function checkForNearbyEnemies()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    local playerPos = character.HumanoidRootPart.Position
    local liveFolder = Services.Workspace:FindFirstChild("Live")
    
    if liveFolder then
        -- Check for Yeti first
        local yeti = liveFolder:FindFirstChild("Yeti")
        if yeti then
            local bodyLow = yeti:FindFirstChild("Body_low")
            if bodyLow and bodyLow:IsA("BasePart") then
                local distance = (bodyLow.Position - playerPos).Magnitude
                if distance <= AutoChop.EnemyRange then
                    return true, "Yeti", distance
                end
            end
        end
        
        -- Check for other enemies
        for _, enemy in pairs(liveFolder:GetChildren()) do
            if enemy:IsA("Model") and enemy ~= Player.Character then
                local humanoid = enemy:FindFirstChild("Humanoid")
                local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
                if humanoid and rootPart and humanoid.Health > 0 then
                    local distance = (rootPart.Position - playerPos).Magnitude
                    if distance <= AutoChop.EnemyRange then 
                        return true, enemy.Name, distance 
                    end
                end
            end
        end
    end
    return false
end

local function scanTrees()
    AutoChop.TreesData = {}
    local treesFolder = Services.Workspace:FindFirstChild("Map") and Services.Workspace.Map:FindFirstChild("Trees")
    if not treesFolder then 
        updateChopStatus("❌ Trees folder not found!")
        return false 
    end
    
    for _, sizeFolder in pairs(treesFolder:GetChildren()) do
        if sizeFolder.Name:match("^T%d+$") then
            local treeModel = sizeFolder:FindFirstChild("Tree")
            if treeModel and treeModel:IsA("Model") then
                local basePart, lowestY = nil, math.huge
                for _, part in pairs(treeModel:GetDescendants()) do
                    if part:IsA("BasePart") and part.Position.Y < lowestY then
                        lowestY, basePart = part.Position.Y, part
                    end
                end
                if basePart then
                    table.insert(AutoChop.TreesData, {
                        size = sizeFolder.Name,
                        model = treeModel,
                        basePart = basePart,
                        position = basePart.Position,
                        sizeNumber = tonumber(sizeFolder.Name:sub(2)) or 0,
                        folder = sizeFolder
                    })
                end
            end
        end
    end
    
    updateChopStatus("✅ Scanned " .. #AutoChop.TreesData .. " trees")
    return #AutoChop.TreesData > 0
end

local function getTreesInRange(treeType)
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return {} end
    
    local playerPos = character.HumanoidRootPart.Position
    local filteredTrees = {}
    
    for _, tree in pairs(AutoChop.TreesData) do
        if isTreeValid(tree) then
            local distance = (tree.position - playerPos).Magnitude
            if distance <= AutoChop.Range then
                if treeType == "Small" then
                    if tree.sizeNumber >= 0 and tree.sizeNumber <= 6 then
                        table.insert(filteredTrees, {tree = tree, distance = distance})
                    end
                elseif treeType == "Big" then
                    if tree.sizeNumber >= 7 and tree.sizeNumber <= 8 then
                        table.insert(filteredTrees, {tree = tree, distance = distance})
                    end
                end
            end
        end
    end
    
    table.sort(filteredTrees, function(a, b) return a.distance < b.distance end)
    return filteredTrees
end

local function savePlayerPosition()
    local character = Player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        AutoChop.OriginalPosition = character.HumanoidRootPart.CFrame
        return true
    end
    return false
end

local function teleportPlayerToTree(tree)
    if not tree then return false end
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    if not AutoChop.OriginalPosition then 
        if not savePlayerPosition() then return false end
    end
    
    local treePos = tree.position
    local optimalDistance = 3 -- Much closer distance for better chopping
    local currentPos = character.HumanoidRootPart.Position
    local direction = (treePos - currentPos).Unit
    local teleportPos = treePos - (direction * optimalDistance)
    
    -- Keep the same height as tree base but closer
    teleportPos = Vector3.new(teleportPos.X, treePos.Y + 2, teleportPos.Z)
    
    -- Create CFrame facing the tree directly
    local lookCFrame = CFrame.new(teleportPos, treePos)
    
    character.HumanoidRootPart.CFrame = lookCFrame
    AutoChop.IsTeleported = true
    
    updateChopStatus("📍 Teleported to " .. tree.size .. " tree (Distance: " .. math.floor(optimalDistance) .. " studs)")
    return true
end

local function returnPlayerToNormal()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    if AutoChop.OriginalPosition then
        character.HumanoidRootPart.CFrame = AutoChop.OriginalPosition
        AutoChop.OriginalPosition = nil
        AutoChop.IsTeleported = false
        updateChopStatus("🔙 Returned to original position")
        return true
    end
    return false
end

local function sendChopAction()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return false end
    
    local playerPos = character.HumanoidRootPart.Position
    local lookVector = character.HumanoidRootPart.CFrame.LookVector
    
    local success, result = pcall(function()
        local args = {
            "M1",
            {
                Type = "Down",
                PlacementCF = CFrame.new(playerPos, playerPos + lookVector)
            }
        }
        ActionRemote:InvokeServer(unpack(args))
        return true
    end)
    
    if success then
        return true
    else
        updateChopStatus("❌ Failed to send chop action: " .. tostring(result))
        return false
    end
end

local function findSafeTree(treeType)
    local treesInRange = getTreesInRange(treeType)
    
    for _, treeData in pairs(treesInRange) do
        local tree = treeData.tree
        
        -- Quick enemy check for this specific tree area
        local character = Player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local treePos = tree.position
            local enemyDetected = false
            
            local liveFolder = Services.Workspace:FindFirstChild("Live")
            if liveFolder then
                for _, enemy in pairs(liveFolder:GetChildren()) do
                    if enemy:IsA("Model") and enemy ~= Player.Character then
                        local humanoid = enemy:FindFirstChild("Humanoid")
                        local rootPart = enemy:FindFirstChild("HumanoidRootPart") or enemy:FindFirstChild("Torso") or enemy:FindFirstChild("UpperTorso")
                        
                        if humanoid and rootPart and humanoid.Health > 0 then
                            local enemyDistance = (rootPart.Position - treePos).Magnitude
                            if enemyDistance <= AutoChop.EnemyRange then
                                enemyDetected = true
                                break
                            end
                        end
                    end
                end
            end
            
            if not enemyDetected then
                return tree
            end
        end
    end
    
    return nil
end

local function autoStopAuraChop(reason)
    updateChopStatus("🛑 Auto-stopping: " .. reason)
    
    -- Stop the connection
    if AutoChop.Connection then
        AutoChop.Connection:Disconnect()
        AutoChop.Connection = nil
    end
    
    -- Return player to original position
    if AutoChop.IsTeleported then
        returnPlayerToNormal()
    end
    
    -- Update internal state and toggle
    updateToggleState(false)
    AutoChop.CurrentTarget = nil
end

local function toggleAuraChop(state)
    if state then
        -- Start aura chop
        if #AutoChop.TreesData == 0 then
            if not scanTrees() then
                updateChopStatus("❌ No trees found. Cannot start auto chop")
                updateToggleState(false) -- Ensure toggle matches state
                return
            end
        end
        
        local character = Player.Character
        if not character then
            updateChopStatus("❌ No character found!")
            updateToggleState(false) -- Ensure toggle matches state
            return
        end
        
        -- Save original player position
        if not savePlayerPosition() then
            updateChopStatus("❌ Failed to save player position!")
            updateToggleState(false) -- Ensure toggle matches state
            return
        end
        
        updateToggleState(true)
        updateChopStatus("🟢 Auto Chop started for " .. AutoChop.SelectedTreeType .. " trees")
        
        -- Aura chop loop
        AutoChop.Connection = Services.RunService.Heartbeat:Connect(function()
            if not AutoChop.Enabled then
                if AutoChop.Connection then
                    AutoChop.Connection:Disconnect()
                    AutoChop.Connection = nil
                end
                return
            end
            
            -- Check for enemies first (priority)
            local currentTime = tick()
            if currentTime - AutoChop.LastEnemyCheck >= AutoChop.EnemyCheckInterval then
                local enemyDetected, enemyName, distance = checkForNearbyEnemies()
                AutoChop.LastEnemyCheck = currentTime
                
                if enemyDetected then
                    updateChopStatus("⚠️ " .. enemyName .. " detected! Distance: " .. math.floor(distance) .. " studs")
                    
                    -- Find a safe tree away from enemy
                    local safeTree = findSafeTree(AutoChop.SelectedTreeType)
                    if safeTree then
                        updateChopStatus("🔄 Moving to safer tree...")
                        teleportPlayerToTree(safeTree)
                        AutoChop.CurrentTarget = safeTree
                    else
                        autoStopAuraChop("No safe trees found - enemy nearby")
                        return
                    end
                end
            end
            
            -- If no current target tree or current tree is down, find new one
            if not AutoChop.CurrentTarget or not isTreeValid(AutoChop.CurrentTarget) then
                local treesInRange = getTreesInRange(AutoChop.SelectedTreeType)
                if #treesInRange > 0 then
                    AutoChop.CurrentTarget = treesInRange[1].tree
                    if not teleportPlayerToTree(AutoChop.CurrentTarget) then
                        autoStopAuraChop("Failed to teleport to tree")
                        return
                    end
                else
                    updateChopStatus("⏳ No " .. AutoChop.SelectedTreeType:lower() .. " trees in range. Waiting...")
                    task.wait(2)
                    return
                end
            end
            
            -- Send chop action
            if AutoChop.CurrentTarget and isTreeValid(AutoChop.CurrentTarget) then
                if not sendChopAction() then
                    autoStopAuraChop("Failed to send chop action")
                    return
                end
                updateChopStatus("🪓 Chopping " .. AutoChop.CurrentTarget.size .. " " .. AutoChop.SelectedTreeType:lower() .. " | Range: " .. AutoChop.Range .. " studs")
            else
                -- Tree became invalid, find new one
                AutoChop.CurrentTarget = nil
            end
            
            task.wait(AutoChop.Delay)
        end)
        
    else
        -- Manual stop
        autoStopAuraChop("Manually stopped by user")
    end
end


-- Main Toggle (store the reference)
AutoChopToggleRef = autochoptreeGroup:AddToggle("🌲 Turn on Auto Chop 🌲", false, function(state)
    toggleAuraChop(state)
end)

-- Emergency Stop Button (with toggle update)
autochoptreeGroup:AddButton("🛑 EMERGENCY STOP", function()
    if AutoChop.Enabled then
        toggleAuraChop(false)
        updateChopStatus("🛑 EMERGENCY STOP: Auto Chop disabled")
    else
        updateChopStatus("ℹ️ Auto Chop is already stopped")
    end
end)
-- Tree Type Selection
autochoptreeGroup:AddDropdown("Tree Type", {"Small", "Big"}, "Small", function(selection)
    AutoChop.SelectedTreeType = selection
    updateChopStatus("Selected tree type: " .. selection)
    
    if AutoChop.Enabled then
        -- Restart aura chop with new tree type
        toggleAuraChop(false)
        task.wait(0.5)
        toggleAuraChop(true)
    end
end)

-- Chop Range Slider
autochoptreeGroup:AddSlider("Chop Range", 50, 1000, 100, function(value)
    AutoChop.Range = value
    updateChopStatus("Chop range set to: " .. value .. " studs")
end)

-- Chop Delay Slider
autochoptreeGroup:AddSlider("Chop Delay", 0.05, 2, 0.1, function(value)
    AutoChop.Delay = value
    updateChopStatus("Chop delay set to: " .. value .. " seconds")
end)

-- Enemy Detection Range
autochoptreeGroup:AddSlider("Enemy Detection Range", 10, 100, 50, function(value)
    AutoChop.EnemyRange = value
    updateChopStatus("Enemy detection range set to: " .. value .. " studs")
end)


-- Manual toggle state synchronization
task.spawn(function()
    while true do
        task.wait(1)
        -- This ensures the toggle state stays synchronized
        if AutoChopToggleRef and not AutoChop.Enabled then
            -- If the system is disabled but toggle shows enabled, we can't directly update the GUI
            -- but we can at least log it for debugging
            print("🔄 Auto Chop state check: " .. tostring(AutoChop.Enabled))
        end
    end
end)

-- Auto-rescan trees periodically
task.spawn(function()
    while true do
        task.wait(30) -- Rescan every 30 seconds
        if AutoChop.Enabled then
            scanTrees()
        end
    end
end)

-- Auto-stop conditions monitoring
task.spawn(function()
    while true do
        task.wait(3)
        if AutoChop.Enabled then
            -- Check if player character is valid
            local character = Player.Character
            if not character or not character:FindFirstChild("HumanoidRootPart") then
                autoStopAuraChop("Player character invalid")
            end
            
            -- Check if player is dead
            if character and character:FindFirstChild("Humanoid") then
                local humanoid = character.Humanoid
                if humanoid.Health <= 0 then
                    autoStopAuraChop("Player died")
                end
            end
        end
    end
end)

-- Cleanup when player leaves
Player.CharacterRemoving:Connect(function()
    if AutoChop.Enabled then
        autoStopAuraChop("Character removed")
    end
end)

-- Player added cleanup
Player.CharacterAdded:Connect(function(character)
    -- Reset teleport state when new character spawns
    AutoChop.IsTeleported = false
    AutoChop.OriginalPosition = nil
    
    if AutoChop.Enabled then
        -- Auto-restart auto chop if it was running
        task.wait(3) -- Wait for character to fully load
        updateChopStatus("Character respawned - restarting Auto Chop...")
        toggleAuraChop(true)
    end
end)





end

-- RETURN the module so main script can use it
return AutoTabSystem
