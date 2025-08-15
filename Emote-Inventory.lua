local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local Backpack = LocalPlayer.Backpack

-- Example ScrollingFrame reference
local ScrollingFrame = script:WaitForChild("ScrollingFrame")  

-- Function to create tools in backpack
local function addTool(toolData)
    local Tool = Instance.new("Tool")
    Tool.Name = toolData.name
    Tool.RequiresHandle = false

    Tool.Equipped:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                -- Add any equipped logic here
            end
        end
    end)

    Tool.Unequipped:Connect(function()
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local animation = Instance.new("Animation")
                animation.AnimationId = "rbxassetid://0"
                local loadAnim = humanoid:LoadAnimation(animation)
                loadAnim.Priority = Enum.AnimationPriority.Action4
                loadAnim:Play()
                task.spawn(function()
                    wait(0.1)
                    loadAnim:Stop()
                end)
            end
        end
    end)

    Tool.Parent = Backpack
end

-- Function to save tools to file
local function saveTools(tools)
    if type(writefile) == "function" and type(tools) == "table" then
        local content = "_G.tools = {\n"
        for _, v in ipairs(tools) do
            if type(v) == "table" and v.name and v.Id then
                content = content .. string.format('    {name = "%s", Id = %s},\n', string.gsub(v.name, '"', '\\"'), tostring(v.Id))
            end
        end
        content = content .. "}\n"
        writefile("Ugc.luau", content)
    end
end

-- Function to create UI buttons for each tool
local function createToolUI(toolData)
    local Frame = Instance.new("Frame")
    Frame.Name = "ToolFrame_" .. toolData.name
    Frame.Size = UDim2.new(1, -20, 0, 45)
    Frame.Position = UDim2.new(0, 10, 0, 10)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Frame.BorderSizePixel = 0
    Frame.Parent = ScrollingFrame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(0.55, 0, 1, 0)
    TextLabel.Position = UDim2.new(0, 5, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = toolData.name
    TextLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    TextLabel.TextWrapped = false
    TextLabel.Font = Enum.Font.SourceSans
    TextLabel.TextSize = 14
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextTruncate = Enum.TextTruncate.AtEnd
    TextLabel.Parent = Frame

    -- Add button
    local AddButton = Instance.new("TextButton")
    AddButton.Name = "AddButton"
    AddButton.Size = UDim2.new(0.18, 0, 1, -12)
    AddButton.Position = UDim2.new(0.58, 0, 0, 6)
    AddButton.Text = "+"
    AddButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    AddButton.BackgroundColor3 = Color3.fromRGB(60, 120, 60)
    AddButton.BorderColor3 = Color3.fromRGB(40, 80, 40)
    AddButton.Font = Enum.Font.SourceSansBold
    AddButton.TextSize = 18
    AddButton.AutoButtonColor = true
    AddButton.Parent = Frame

    -- Remove button
    local RemoveButton = Instance.new("TextButton")
    RemoveButton.Name = "RemoveButton"
    RemoveButton.Size = UDim2.new(0.18, 0, 1, -12)
    RemoveButton.Position = UDim2.new(0.8, 0, 0, 6)
    RemoveButton.Text = "-"
    RemoveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    RemoveButton.BackgroundColor3 = Color3.fromRGB(150, 60, 60)
    RemoveButton.BorderColor3 = Color3.fromRGB(100, 40, 40)
    RemoveButton.Font = Enum.Font.SourceSansBold
    RemoveButton.TextSize = 18
    RemoveButton.AutoButtonColor = true
    RemoveButton.Parent = Frame

    -- Tween effects
    local function addTween(button, startColor, endColor)
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = endColor}):Play()
            end
        end)
        button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = startColor}):Play()
            end
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.1), {BackgroundColor3 = startColor}):Play()
        end)
    end
    addTween(AddButton, AddButton.BackgroundColor3, Color3.fromRGB(80, 160, 80))
    addTween(RemoveButton, RemoveButton.BackgroundColor3, Color3.fromRGB(200, 80, 80))

    -- Button click logic
    AddButton.MouseButton1Click:Connect(function()
        addTool(toolData)
        table.insert(_G.tools, toolData)
        saveTools(_G.tools)
    end)

    AddButton.TouchTap:Connect(function()
        addTool(toolData)
        table.insert(_G.tools, toolData)
        saveTools(_G.tools)
    end)

    RemoveButton.MouseButton1Click:Connect(function()
        for i, v in ipairs(Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == toolData.name then
                v:Destroy()
            end
        end
    end)

    RemoveButton.TouchTap:Connect(function()
        for i, v in ipairs(Backpack:GetChildren()) do
            if v:IsA("Tool") and v.Name == toolData.name then
                v:Destroy()
            end
        end
    end)
end

-- Main UI loop
if type(_G.tools) == "table" then
    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #_G.tools * 50)
    for _, toolData in ipairs(_G.tools) do
        createToolUI(toolData)
    end
end
