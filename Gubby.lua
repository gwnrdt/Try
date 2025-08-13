--[[
    Instant Gubby
]]
for i, v in ipairs(workspace:FindFirstChild("ToFind"):GetChildren()) do
    v:IsA("BasePart")
    v.Position = game:GetService("Players").LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position + Vector3.new(5, 0, 0)
end
