local PlayerTabSystems= {}

function PlayerTabSystems:Init(menu, Tabs)
    -- Store references
    self.menu = menu
    self.Tabs = Tabs or {}
    
    -- Create PlayerTab if not provided
    if not self.Tabs.PlayerTab then
        self.Tabs.PlayerTab = menu:CreateTab("Local Player")
    end
    
    -- Get services (add these at the top of the Init function)
    local Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService"),
        UserInputService = game:GetService("UserInputService"),
        Lighting = game:GetService("Lighting")
    }
    
    local Player = Services.Players.LocalPlayer
    local Camera = Services.Workspace.CurrentCamera
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    
    
--PlayerTab Start

--// 🧍 Player Settings (optimized)
local PlayerSettings = {
    Noclip = false,
    InfiniteJump = false,
    TpWalk = {Enabled = false, Speed = 50, Connection = nil},
    FOV = {Enabled = false, Value = Camera.FieldOfView},
    FullBright = false,
    Fly = {Enabled = false, Speed = 16, BodyVelocity = nil, Connection = nil},
    SpeedHack = {Enabled = false, Speed = 90, WSLoop = nil, WSCA = nil}
}

local playerVisualGroup = self.menu:CreateCollapsibleGroup(self.Tabs.PlayerTab,"LOCAL PLAYER VISUAL SETTINGS",false,250)
self.menu:MarkAsNew(playerVisualGroup:GetInstance(),"V2")

local playerSpeedGroup = self.menu:CreateCollapsibleGroup(self.Tabs.PlayerTab,"LOCAL PLAYER SPEED HACK",true,240)
self.menu:MarkAsNew(playerSpeedGroup:GetInstance(),"V2")

local playerCharacterGroup = self.menu:CreateCollapsibleGroup(self.Tabs.PlayerTab,"LOCAL PLAYER CHARACTER MODS",false,240)
self.menu:MarkAsNew(playerCharacterGroup:GetInstance(),"V2")


-- FOV
playerVisualGroup:AddToggle("Player FOV:", false, function(state)
    PlayerSettings.FOV.Enabled = state
    Camera.FieldOfView = state and PlayerSettings.FOV.Value or 70
end)

playerVisualGroup:AddSlider("FOV Value", 50, 120, PlayerSettings.FOV.Value, function(value)
    PlayerSettings.FOV.Value = value
    if PlayerSettings.FOV.Enabled then Camera.FieldOfView = value end
end)


local function applyLoopspeed(speaker, speed)
    local Char = speaker.Character or Services.Workspace:FindFirstChild(speaker.Name)
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if not Human then return end
    
    local function WalkSpeedChange()
        if Char and Human and Human.Parent then
            Human.WalkSpeed = speed
        end
    end
    
    WalkSpeedChange()
    
    if PlayerSettings.SpeedHack.WSLoop then
        PlayerSettings.SpeedHack.WSLoop:Disconnect()
    end
    PlayerSettings.SpeedHack.WSLoop = Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
    
    if PlayerSettings.SpeedHack.WSCA then
        PlayerSettings.SpeedHack.WSCA:Disconnect()
    end
    PlayerSettings.SpeedHack.WSCA = speaker.CharacterAdded:Connect(function(nChar)
        repeat task.wait(0.1)
            Human = nChar:FindFirstChildWhichIsA("Humanoid")
        until Human
        Char = nChar
        WalkSpeedChange()
        if PlayerSettings.SpeedHack.WSLoop then
            PlayerSettings.SpeedHack.WSLoop:Disconnect()
        end
        PlayerSettings.SpeedHack.WSLoop = Human:GetPropertyChangedSignal("WalkSpeed"):Connect(WalkSpeedChange)
    end)
end

local function disableLoopspeed()
    if PlayerSettings.SpeedHack.WSLoop then
        PlayerSettings.SpeedHack.WSLoop:Disconnect()
        PlayerSettings.SpeedHack.WSLoop = nil
    end
    if PlayerSettings.SpeedHack.WSCA then
        PlayerSettings.SpeedHack.WSCA:Disconnect()
        PlayerSettings.SpeedHack.WSCA = nil
    end
    PlayerSettings.SpeedHack.Enabled = false
    
    local Char = Player.Character or Services.Workspace:FindFirstChild(Player.Name)
    local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
    if Human then Human.WalkSpeed = 16 end
end

playerSpeedGroup:AddToggle("SPEED HACK", false, function(state)
    PlayerSettings.SpeedHack.Enabled = state
    if state then
        applyLoopspeed(Player, PlayerSettings.SpeedHack.Speed)
    else
        disableLoopspeed()
    end
end)

playerSpeedGroup:AddSlider("Speed:", 16, 500, 90, function(value)
    PlayerSettings.SpeedHack.Speed = value
    if PlayerSettings.SpeedHack.Enabled then
        local Char = Player.Character or Services.Workspace:FindFirstChild(Player.Name)
        local Human = Char and Char:FindFirstChildWhichIsA("Humanoid")
        if Human then Human.WalkSpeed = value end
    end
end)


local function toggleFly(state)
    if state then
        PlayerSettings.Fly.Enabled = true
        local character = Player.Character or Player.CharacterAdded:Wait()
        if not character:FindFirstChild("HumanoidRootPart") then
            character:WaitForChild("HumanoidRootPart")
        end
        
        PlayerSettings.Fly.BodyVelocity = Instance.new("BodyVelocity")
        PlayerSettings.Fly.BodyVelocity.Name = "FlyBodyVelocity"
        PlayerSettings.Fly.BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        PlayerSettings.Fly.BodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        PlayerSettings.Fly.BodyVelocity.Parent = character.HumanoidRootPart
        
        PlayerSettings.Fly.Connection = Services.RunService.Heartbeat:Connect(function()
            if not PlayerSettings.Fly.Enabled or not character or not character:FindFirstChild("HumanoidRootPart") then
                if PlayerSettings.Fly.Connection then
                    PlayerSettings.Fly.Connection:Disconnect()
                end
                return
            end
            
            local root = character.HumanoidRootPart
            local moveDirection = Vector3.new(0, 0, 0)
            
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveDirection = moveDirection + Camera.CFrame.LookVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveDirection = moveDirection - Camera.CFrame.LookVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveDirection = moveDirection - Camera.CFrame.RightVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveDirection = moveDirection + Camera.CFrame.RightVector
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                moveDirection = moveDirection + Vector3.new(0, 1, 0)
            end
            if Services.UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                moveDirection = moveDirection - Vector3.new(0, 1, 0)
            end
            
            if moveDirection.Magnitude > 0 then
                moveDirection = moveDirection.Unit * PlayerSettings.Fly.Speed
            end
            
            if PlayerSettings.Fly.BodyVelocity and PlayerSettings.Fly.BodyVelocity.Parent then
                PlayerSettings.Fly.BodyVelocity.Velocity = moveDirection
            end
        end)
    else
        PlayerSettings.Fly.Enabled = false
        if PlayerSettings.Fly.Connection then
            PlayerSettings.Fly.Connection:Disconnect()
            PlayerSettings.Fly.Connection = nil
        end
        
        if Player and Player.Character then
            local character = Player.Character
            local root = character:FindFirstChild("HumanoidRootPart")
            if root then
                if root:FindFirstChild("FlyBodyVelocity") then
                    root.FlyBodyVelocity:Destroy()
                end
            end
        end
    end
end

playerCharacterGroup:AddToggle("FLY", false, function(state)
    toggleFly(state)
end)

playerCharacterGroup:AddSlider("FLY SPEED", 16, 100, 30, function(value)
    PlayerSettings.Fly.Speed = value
end)

-- TP Walk

playerSpeedGroup:AddToggle("TP Walk Speed:", false, function(state)
    PlayerSettings.TpWalk.Enabled = state
    if state then
        PlayerSettings.TpWalk.Connection = Services.RunService.RenderStepped:Connect(function()
            if PlayerSettings.TpWalk.Enabled and Character and Character:FindFirstChild("HumanoidRootPart") then
                local hrp = Character.HumanoidRootPart
                local humanoid = Character:FindFirstChildOfClass("Humanoid")
                if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                    hrp.CFrame = hrp.CFrame + humanoid.MoveDirection * (PlayerSettings.TpWalk.Speed / 100)
                end
            end
        end)
    elseif PlayerSettings.TpWalk.Connection then
        PlayerSettings.TpWalk.Connection:Disconnect()
        PlayerSettings.TpWalk.Connection = nil
    end
end)

playerSpeedGroup:AddSlider("TP Walk Speed Value", 50, 500, PlayerSettings.TpWalk.Speed, function(value)
    PlayerSettings.TpWalk.Speed = value
end)

-- Other features

playerCharacterGroup:AddToggle("Noclip", false, function(state) 
    PlayerSettings.Noclip = state 
end)

playerCharacterGroup:AddToggle("Infinite Jump", false, function(state) 
    PlayerSettings.InfiniteJump = state 
end)

playerVisualGroup:AddToggle("Full Bright", false, function(state) 
    PlayerSettings.FullBright = state
    if state then
        Services.Lighting.Brightness = 2
        Services.Lighting.ClockTime = 12
        Services.Lighting.FogEnd = 1e10
        Services.Lighting.GlobalShadows = false
    else
        Services.Lighting.Brightness = 1
        Services.Lighting.ClockTime = 14
        Services.Lighting.FogEnd = 100000
        Services.Lighting.GlobalShadows = true
    end
end)

-- Noclip and Infinite Jump handlers
Services.RunService.Stepped:Connect(function()
    if PlayerSettings.Noclip and Character then
        for _, v in pairs(Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

Services.UserInputService.JumpRequest:Connect(function()
    if PlayerSettings.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

--PlayerTab ENd


end

return PlayerTabSystems
