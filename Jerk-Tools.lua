--[[
    Jerk Tools
]]
_OgPfGznCLYMi = "This file was protected with MoonSec V3"
MoonSec_StringsHiddenAttr = true
game:GetService("UserInputService")
game:GetService("ReplicatedStorage")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Connection = LocalPlayer.CharacterAdded:Connect(function(...)
    LocalPlayer.Backpack:FindFirstChild("Jerk Off")
    LocalPlayer.Backpack["Jerk Off"]:Destroy()
    local Tool = Instance.new("Tool")
    Tool.Name = "Jerk Off"
    Tool.RequiresHandle = false
    Tool.Parent = LocalPlayer.Backpack
    local Connection_1 = Tool.Equipped:Connect(function(...)
        local Animation = Instance.new("Animation")
        Animation.AnimationId = "rbxassetid://72042024"
        local Humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Animation)
        local RenderStepped = game:GetService("RunService").RenderStepped:Connect(function(...)
            Humanoid:Stop()
        end)
        Humanoid:Play()
        Humanoid.TimePosition = 0.5
        local Animation_1 = Instance.new("Animation")
        Animation_1.AnimationId = "rbxassetid://168268306"
        local Humanoid_1 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Animation_1)
        local RenderStepped_1 = game:GetService("RunService").RenderStepped:Connect(function(...)
            Humanoid_1:Stop()
        end)
        Humanoid_1:Play()
        Humanoid_1.TimePosition = 1
    end)
    local Connection_2 = Tool.Unequipped:Connect(function(...)
        RenderStepped:Disconnect()
        RenderStepped_1:Disconnect()
    end)
end)
local Tool_1 = Instance.new("Tool")
Tool_1.Name = "Jerk Off"
Tool_1.RequiresHandle = false
Tool_1.Parent = LocalPlayer.Backpack
local Connection_3 = Tool_1.Equipped:Connect(function(...)
    local Animation_2 = Instance.new("Animation")
    Animation_2.AnimationId = "rbxassetid://72042024"
    local Humanoid_2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Animation_2)
    local RenderStepped_2 = game:GetService("RunService").RenderStepped:Connect(function(...)
        Humanoid_2:Stop()
    end)
    Humanoid_2:Play()
    Humanoid_2.TimePosition = 0.5
    local Animation_3 = Instance.new("Animation")
    Animation_3.AnimationId = "rbxassetid://168268306"
    local Humanoid_3 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):LoadAnimation(Animation_3)
    local RenderStepped_3 = game:GetService("RunService").RenderStepped:Connect(function(...)
        Humanoid_3:Stop()
    end)
    Humanoid_3:Play()
    Humanoid_3.TimePosition = 1
end)
local Connection_4 = Tool_1.Unequipped:Connect(function(...)
    RenderStepped_2:Disconnect()
    RenderStepped_3:Disconnect()
end)
