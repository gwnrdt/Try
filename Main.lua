
local MainTabSystem = {}

function MainTabSystem:Init(menu, Tabs)
    -- Store references
    self.menu = menu
    self.Tabs = Tabs or {}
    
    -- Create tabs if not provided
    if not self.Tabs.MainTab then
        self.Tabs.MainTab = menu:CreateTab("Main")
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
    
    
--// 🧱 Safe Height (optimized)
local SafeHeight = {Enabled = false, Value = 50, OriginalHeight = 0}

local safeheightGroup = self.menu:CreateCollapsibleGroup(self.Tabs.MainTab,"🌪️ SAFE HEIGHT ",true,150)
self.menu:MarkAsNew(safeheightGroup:GetInstance(),"V2")

safeheightGroup:AddToggle("Safty Height:", false, function(state)
    SafeHeight.Enabled = state
    if Humanoid then
        if state then
            SafeHeight.OriginalHeight = Humanoid.HipHeight
            Humanoid.HipHeight = SafeHeight.Value
        else
            Humanoid.HipHeight = SafeHeight.OriginalHeight
        end
    end
end)

safeheightGroup:AddSlider("Height Settings", 0, 100, SafeHeight.Value, function(value)
    SafeHeight.Value = value
    if SafeHeight.Enabled and Humanoid then
        Humanoid.HipHeight = value
    end
end)


-- Instant Open System (for all ProximityPrompts)
local InstantOpen = {
    Enabled = false,
    OriginalDurations = {}, -- Store original durations to restore later
    Connection = nil
}

-- Function to modify all ProximityPrompts in the game
local function modifyAllProximityPrompts(instantOpen)
    if instantOpen then
        -- Enable instant open - set all HoldDuration to 0
        InstantOpen.OriginalDurations = {}
        
        local function processModel(model)
            for _, descendant in pairs(model:GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    -- Store original duration
                    InstantOpen.OriginalDurations[descendant] = descendant.HoldDuration
                    -- Set to 0 for instant open
                    descendant.HoldDuration = 0
                end
            end
        end
        
        -- Process existing objects
        for _, obj in pairs(Services.Workspace:GetDescendants()) do
            if obj:IsA("Model") then
                processModel(obj)
            end
        end
        
        -- Process new objects as they're added
        if not InstantOpen.Connection then
            InstantOpen.Connection = Services.Workspace.DescendantAdded:Connect(function(descendant)
                if descendant:IsA("Model") then
                    processModel(descendant)
                elseif descendant:IsA("ProximityPrompt") then
                    InstantOpen.OriginalDurations[descendant] = descendant.HoldDuration
                    descendant.HoldDuration = 0
                end
            end)
        end
        
        print("⚡ Instant Open: ENABLED - All interactions are instant!")
        
    else
        -- Disable instant open - restore original durations
        for prompt, originalDuration in pairs(InstantOpen.OriginalDurations) do
            if prompt and prompt.Parent then
                pcall(function()
                    prompt.HoldDuration = originalDuration
                end)
            end
        end
        
        -- Clear stored durations
        InstantOpen.OriginalDurations = {}
        
        -- Disconnect the connection
        if InstantOpen.Connection then
            InstantOpen.Connection:Disconnect()
            InstantOpen.Connection = nil
        end
        
        print("⚡ Instant Open: DISABLED - Interactions restored to normal")
    end
end

-- Function to toggle instant open
local function toggleInstantOpen(state)
    InstantOpen.Enabled = state
    modifyAllProximityPrompts(state)
end

-- Add Instant Open to Auto Loot Chest tab (or you can create a separate tab)

local instantopenGroup = self.menu:CreateGroup(self.Tabs.MainTab,"⚡ INSTANT OPEN SYSTEM",130)
self.menu:MarkAsNew(instantopenGroup:GetInstance(),"V2")

-- Instant Open Toggle
instantopenGroup:AddToggle("⚡ Instant Open All", false, function(state)
    toggleInstantOpen(state)
end)

-- Info label
instantopenGroup:AddLabel("Makes ALL E interactions instant (chests, workbenches, etc.)")

-- Manual refresh button (in case some prompts are missed)
instantopenGroup:AddButton("🔄 Refresh Instant Open", function()
    if InstantOpen.Enabled then
        print("🔄 Refreshing Instant Open...")
        modifyAllProximityPrompts(true)
    else
        print("❌ Enable Instant Open first!")
    end
end)

-- Cleanup when script stops
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == Player then
        if InstantOpen.Enabled then
            toggleInstantOpen(false)
        end
    end
end)

--Maintab End



end

-- RETURN the module so main script can use it
return MainTabSystem
