local Library = {}
Library.__index = Library

local Theme = {
    Primary = Color3.fromRGB(0, 170, 255),
    Background = Color3.fromRGB(20, 20, 30),
    Secondary = Color3.fromRGB(40, 40, 60),
    Text = Color3.fromRGB(240, 240, 240),
    Stroke = Color3.fromRGB(60, 60, 80),
    Success = Color3.fromRGB(0, 200, 100),
    Warning = Color3.fromRGB(255, 170, 0),
    Error = Color3.fromRGB(220, 60, 60),
    Purple = Color3.fromRGB(180, 120, 220)
}

function Library:CreateWindow(Title)
    local UserInputService = game:GetService("UserInputService")
    local TweenService = game:GetService("TweenService")
    local RunService = game:GetService("RunService")
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UILibrary"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui")
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 550)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -275)
    MainFrame.BackgroundColor3 = Theme.Background
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    
    local strokes = {
        {Thickness = 4, Color = Theme.Primary, Transparency = 0.2},
        {Thickness = 3, Color = Theme.Stroke, Transparency = 0.1},
        {Thickness = 2, Color = Theme.Secondary, Transparency = 0},
    }
    
    for _, strokeConfig in ipairs(strokes) do
        local stroke = Instance.new("UIStroke")
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Color = strokeConfig.Color
        stroke.Thickness = strokeConfig.Thickness
        stroke.Transparency = strokeConfig.Transparency
        stroke.Parent = MainFrame
    end
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = MainFrame
    
    local TopBar = Instance.new("Frame")
    TopBar.Name = "TopBar"
    TopBar.Size = UDim2.new(1, 0, 0, 36)
    TopBar.BackgroundColor3 = Theme.Secondary
    TopBar.BorderSizePixel = 0
    
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(0, 8)
    barCorner.Parent = TopBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Text = Title or "UI Library"
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 18
    TitleLabel.TextColor3 = Theme.Text
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(0.5, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0.025, 0, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    local IconsFrame = Instance.new("Frame")
    IconsFrame.Name = "Icons"
    IconsFrame.BackgroundTransparency = 1
    IconsFrame.Size = UDim2.new(0, 60, 1, 0)
    IconsFrame.Position = UDim2.new(1, -70, 0, 0)
    
    local MinimizeButton = Instance.new("ImageButton")
MinimizeButton.Name = "Minimize"
MinimizeButton.Image = "rbxassetid://3926305904"
MinimizeButton.ImageRectOffset = Vector2.new(564, 364) -- иконка "свернуть"
MinimizeButton.ImageRectSize = Vector2.new(36, 36)
MinimizeButton.BackgroundTransparency = 1
MinimizeButton.Size = UDim2.new(0, 25, 0, 25)
MinimizeButton.Position = UDim2.new(0, 0, 0.5, -12.5)

local CloseButton = Instance.new("ImageButton")
CloseButton.Name = "Close"
CloseButton.Image = "rbxassetid://3926305904"
CloseButton.ImageRectOffset = Vector2.new(924, 724) -- иконка "закрыть"
CloseButton.ImageRectSize = Vector2.new(36, 36)
CloseButton.BackgroundTransparency = 1
CloseButton.Size = UDim2.new(0, 25, 0, 25)
CloseButton.Position = UDim2.new(0, 35, 0.5, -12.5)


    
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.BackgroundTransparency = 1
    TabContainer.Size = UDim2.new(1, -20, 0, 40)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    
    local TabListLayout = Instance.new("UIListLayout")
TabListLayout.FillDirection = Enum.FillDirection.Horizontal
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabListLayout.Parent = TabContainer
    
    local ContentFrame = Instance.new("ScrollingFrame")
    ContentFrame.Name = "Content"
    ContentFrame.Size = UDim2.new(1, -20, 1, -110)
    ContentFrame.Position = UDim2.new(0, 10, 0, 95)
    ContentFrame.BackgroundTransparency = 1
    ContentFrame.ScrollBarThickness = 6
    ContentFrame.AutomaticCanvasSize = Enum.AutomaticSize.None
    ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    ContentFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 15)
ContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.VerticalAlignment = Enum.VerticalAlignment.Top
ContentLayout.Parent = ContentFrame
    
    local function updateCanvasSize()
        ContentFrame.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
    end
    updateCanvasSize()
    ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvasSize)
    
    MinimizeButton.Parent = IconsFrame
    CloseButton.Parent = IconsFrame
    IconsFrame.Parent = TopBar
    TitleLabel.Parent = TopBar
    TopBar.Parent = MainFrame
    TabContainer.Parent = MainFrame
    ContentFrame.Parent = MainFrame
    MainFrame.Parent = ScreenGui
    
    local dragging
    local dragInput
    local dragStart
    local startPos
    
    local function UpdateInput(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TopBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            UpdateInput(input)
        end
    end)
    
    local minimized = false
    local originalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad)
        
        if minimized then
            TweenService:Create(MainFrame, tweenInfo, {Size = UDim2.new(0, 500, 0, 40)}):Play()
            TweenService:Create(MinimizeButton, tweenInfo, {Rotation = 180}):Play()
            TabContainer.Visible = false
        else
            TweenService:Create(MainFrame, tweenInfo, {Size = originalSize}):Play()
            TweenService:Create(MinimizeButton, tweenInfo, {Rotation = 0}):Play()
            TabContainer.Visible = true
        end
    end)
    
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)
    
    if UserInputService.TouchEnabled then
        MainFrame.Size = UDim2.new(0.9, 0, 0.8, 0)
        MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
        ContentFrame.ScrollBarImageColor3 = Theme.Primary
    end
    
    local Window = {
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Tabs = {},
        CurrentTab = nil
    }
    
    function Window:AddTab(TabName)
    local tabIndex = #Window.Tabs + 1
    
    local TabButton = Instance.new("TextButton")
    TabButton.Name = TabName
    TabButton.Text = TabName
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextSize = 14
    TabButton.TextColor3 = Theme.Text
    TabButton.BackgroundColor3 = Theme.Secondary
    TabButton.AutoButtonColor = false
    TabButton.Size = UDim2.new(0, 100, 0.8, 0)
    TabButton.LayoutOrder = tabIndex
    TabButton.Name = "Tab_" .. tabIndex .. "_" .. TabName
        
        local tabCorner = Instance.new("UICorner")
        tabCorner.CornerRadius = UDim.new(0, 6)
        tabCorner.Parent = TabButton
        
        local tabStroke = Instance.new("UIStroke")
        tabStroke.Color = Theme.Stroke
        tabStroke.Thickness = 2
        tabStroke.Parent = TabButton
        
        local TabContent = Instance.new("Frame")
        TabContent.Name = TabName
        TabContent.BackgroundTransparency = 1
        TabContent.Size = UDim2.new(1, 0, 0, 0) 
        TabContent.AutomaticSize = Enum.AutomaticSize.Y
        TabContent.Visible = false
        
        local tabContentLayout = Instance.new("UIListLayout")
        tabContentLayout.Padding = UDim.new(0, 15)
        tabContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        tabContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        tabContentLayout.Parent = TabContent
        
        tabContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    TabContent.Size = UDim2.new(1, 0, 0, tabContentLayout.AbsoluteContentSize.Y)
end)
        
        TabButton.MouseButton1Click:Connect(function()
            if Window.CurrentTab then
                Window.CurrentTab.Button.BackgroundColor3 = Theme.Secondary
                Window.CurrentTab.Content.Visible = false
            end
            
            TabButton.BackgroundColor3 = Theme.Primary
            TabContent.Visible = true
            Window.CurrentTab = {
                Button = TabButton,
                Content = TabContent
            }
        end)
        
        TabButton.Parent = TabContainer
        TabContent.Parent = ContentFrame
        
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Theme.Primary
            TabContent.Visible = true
            Window.CurrentTab = {
                Button = TabButton,
                Content = TabContent
            }
        end
        
        table.insert(Window.Tabs, {
        Name = TabName,
        Button = TabButton,
        Content = TabContent,
        Index = tabIndex
    })
        
        local TabMethods = {}
    local elementLayoutCounter = 0
        
        -- Search function
        function TabMethods:AddSearchBox(SearchConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local SearchFrame = Instance.new("Frame")
            SearchFrame.Name = "SearchBox"
            SearchFrame.BackgroundTransparency = 1
            SearchFrame.Size = UDim2.new(0.9, 0, 0, 40)
            SearchFrame.LayoutOrder = 0
            SearchFrame.LayoutOrder = elementLayoutCounter
            
            local SearchBox = Instance.new("TextBox")
            SearchBox.Name = "SearchBox"
            SearchBox.PlaceholderText = SearchConfig.Placeholder or "Search..."
            SearchBox.Text = ""
            SearchBox.Font = Enum.Font.Gotham
            SearchBox.TextSize = 14
            SearchBox.TextColor3 = Theme.Text
            SearchBox.BackgroundColor3 = Theme.Secondary
            SearchBox.Size = UDim2.new(1, 0, 0, 35)
            SearchBox.Position = UDim2.new(0, 0, 0, 0)
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = SearchBox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Theme.Stroke
            boxStroke.Thickness = 2
            boxStroke.Parent = SearchBox
            
            local searchIcon = Instance.new("ImageLabel")
            searchIcon.Name = "SearchIcon"
            searchIcon.Image = "rbxassetid://3926305904"
            searchIcon.ImageRectOffset = Vector2.new(964, 324)
            searchIcon.ImageRectSize = Vector2.new(36, 36)
            searchIcon.BackgroundTransparency = 1
            searchIcon.Size = UDim2.new(0, 20, 0, 20)
            searchIcon.Position = UDim2.new(1, -30, 0.5, -10)
            searchIcon.Parent = SearchBox
            
            local function filterElements(searchText)
                searchText = string.lower(searchText)
                for _, element in ipairs(TabContent:GetChildren()) do
                    if element:IsA("GuiObject") and element.Name ~= "SearchBox" then
                        local elementName = string.lower(element.Name)
                        local elementText = element:FindFirstChild("Text") 
                            and string.lower(element.Text) or ""
                        local elementLabel = element:FindFirstChildWhichIsA("TextLabel")
                        local labelText = elementLabel and string.lower(elementLabel.Text) or ""
                        
                        if searchText == "" or 
                           string.find(elementName, searchText) or 
                           string.find(elementText, searchText) or
                           string.find(labelText, searchText) then
                            element.Visible = true
                        else
                            element.Visible = false
                        end
                    end
                end
            end
            
            SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
                filterElements(SearchBox.Text)
            end)
            
            SearchFrame.Parent = TabContent
            SearchBox.Parent = SearchFrame
            
            return SearchFrame
        end
        
        -- Multi Dropdown
        function TabMethods:AddMultiDropdown(DropdownConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = DropdownConfig.Text or "MultiDropdown"
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Size = UDim2.new(0.9, 0, 0, 40)
            DropdownFrame.LayoutOrder = elementLayoutCounter
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Text = DropdownConfig.Text or "Multi Dropdown"
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 14
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Text = DropdownConfig.Default or "Select"
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 14
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.BackgroundColor3 = Theme.Secondary
            DropdownButton.AutoButtonColor = false
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.Position = UDim2.new(0, 0, 0, 20)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Theme.Stroke
            btnStroke.Thickness = 2
            btnStroke.Parent = DropdownButton
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Image = "rbxassetid://3926305904"
            Arrow.ImageRectOffset = Vector2.new(884, 284)
            Arrow.ImageRectSize = Vector2.new(36, 36)
            Arrow.BackgroundTransparency = 1
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.Parent = DropdownButton
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.BackgroundColor3 = Theme.Secondary
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 0, 0, 60)
            OptionsFrame.Visible = false
            OptionsFrame.ZIndex = 10
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 6)
            optionsCorner.Parent = OptionsFrame
            
            local optionsStroke = Instance.new("UIStroke")
            optionsStroke.Color = Theme.Stroke
            optionsStroke.Thickness = 2
            optionsStroke.Parent = OptionsFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsFrame
            
            local open = false
            local selected = {}
            local options = DropdownConfig.Options or {}
            
            local function updateButtonText()
                local count = 0
                for _ in pairs(selected) do count += 1 end
                if count == 0 then
                    DropdownButton.Text = "Select"
                elseif count == 1 then
                    for k in pairs(selected) do
                        DropdownButton.Text = k
                    end
                else
                    DropdownButton.Text = string.format("%d selected", count)
                end
            end
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Text = option
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 14
                OptionButton.TextColor3 = Theme.Text
                OptionButton.BackgroundColor3 = Theme.Secondary
                OptionButton.AutoButtonColor = false
                OptionButton.Size = UDim2.new(1, 0, 0, 35)
                OptionButton.LayoutOrder = i
                OptionButton.ZIndex = 11
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = OptionButton
                
                local OptionCheck = Instance.new("ImageLabel")
                OptionCheck.Name = "Check"
                OptionCheck.Image = "rbxassetid://3926305904"
                OptionCheck.ImageRectOffset = Vector2.new(312, 4)
                OptionCheck.ImageRectSize = Vector2.new(24, 24)
                OptionCheck.BackgroundTransparency = 1
                OptionCheck.Size = UDim2.new(0, 20, 0, 20)
                OptionCheck.Position = UDim2.new(1, -30, 0.5, -10)
                OptionCheck.Visible = false
                OptionCheck.ZIndex = 12
                OptionCheck.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected[option] = not selected[option]
                    OptionCheck.Visible = selected[option]
                    
                    if DropdownConfig.Callback then
                        local selectedList = {}
                        for k, v in pairs(selected) do
                            if v then table.insert(selectedList, k) end
                        end
                        DropdownConfig.Callback(selectedList)
                    end
                    updateButtonText()
                end)
                
                OptionButton.Parent = OptionsFrame
            end
            
            local function ToggleDropdown()
                open = not open
                OptionsFrame.Visible = open
                
                if open then
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, #options * 35)}):Play()
                else
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                end
            end
            
            DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
            DropdownButton.Parent = DropdownFrame
            OptionsFrame.Parent = DropdownFrame
            DropdownFrame.Parent = TabContent
            
            updateButtonText()
            
            return {
                Frame = DropdownFrame,
                SetValues = function(values)
                    selected = {}
                    for _, value in ipairs(values) do
                        selected[value] = true
                    end
                    
                    for _, option in ipairs(OptionsFrame:GetChildren()) do
                        if option:IsA("TextButton") then
                            local check = option:FindFirstChild("Check")
                            if check then
                                check.Visible = selected[option.Name] or false
                            end
                        end
                    end
                    
                    updateButtonText()
                end,
                GetValues = function()
                    local values = {}
                    for k, v in pairs(selected) do
                        if v then table.insert(values, k) end
                    end
                    return values
                end
            }
        end
        
        -- Toggle with Keybind
        function TabMethods:AddToggleWithKeybind(ToggleKeybindConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = ToggleKeybindConfig.Text or "ToggleWithKeybind"
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
            ToggleFrame.LayoutOrder = elementLayoutCounter
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Text = ""
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Text = ToggleKeybindConfig.Text or "Toggle"
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleBack = Instance.new("Frame")
            ToggleBack.Name = "ToggleBack"
            ToggleBack.BackgroundColor3 = Theme.Secondary
            ToggleBack.Size = UDim2.new(0, 50, 0, 25)
            ToggleBack.Position = UDim2.new(0.7, 0, 0.5, -12.5)
            
            local backCorner = Instance.new("UICorner")
            backCorner.CornerRadius = UDim.new(1, 0)
            backCorner.Parent = ToggleBack
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
            ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
            ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local backStroke = Instance.new("UIStroke")
            backStroke.Color = Theme.Stroke
            backStroke.Thickness = 2
            backStroke.Parent = ToggleBack
            
            local circleStroke = Instance.new("UIStroke")
            circleStroke.Color = Theme.Stroke
            circleStroke.Thickness = 1
            circleStroke.Parent = ToggleCircle
            
            ToggleBack.Parent = ToggleFrame
            ToggleCircle.Parent = ToggleBack
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Text = ToggleKeybindConfig.Keybind and ToggleKeybindConfig.Keybind.Name or "NONE"
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.TextSize = 12
            KeybindButton.TextColor3 = Theme.Text
            KeybindButton.BackgroundColor3 = Theme.Secondary
            KeybindButton.AutoButtonColor = false
            KeybindButton.Size = UDim2.new(0, 80, 0.7, 0)
            KeybindButton.Position = UDim2.new(0.85, 5, 0.15, 0)
            
            local keybindCorner = Instance.new("UICorner")
            keybindCorner.CornerRadius = UDim.new(0, 6)
            keybindCorner.Parent = KeybindButton
            
            local keybindStroke = Instance.new("UIStroke")
            keybindStroke.Color = Theme.Stroke
            keybindStroke.Thickness = 1
            keybindStroke.Parent = KeybindButton
            
            KeybindButton.Parent = ToggleFrame
            
            local state = ToggleKeybindConfig.Default or false
            local keybind = ToggleKeybindConfig.Keybind
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
            
            local function UpdateToggle()
                if state then
                    TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -9.5)}):Play()
                    TweenService:Create(ToggleBack, tweenInfo, {BackgroundColor3 = Theme.Primary}):Play()
                else
                    TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
                    TweenService:Create(ToggleBack, tweenInfo, {BackgroundColor3 = Theme.Secondary}):Play()
                end
                
                if ToggleKeybindConfig.Callback then
                    ToggleKeybindConfig.Callback(state)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                UpdateToggle()
            end)
            
            local listening = false
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Theme.Primary
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        keybind = input.KeyCode
                    end
                    KeybindButton.Text = tostring(keybind):gsub("Enum.KeyCode.", "")
                    KeybindButton.BackgroundColor3 = Theme.Secondary
                    listening = false
                elseif keybind and input.KeyCode == keybind then
                    state = not state
                    UpdateToggle()
                end
            end)
            
            UpdateToggle()
            ToggleFrame.Parent = TabContent
            
            return {
                Frame = ToggleFrame,
                SetState = function(value)
                    state = value
                    UpdateToggle()
                end,
                GetState = function()
                    return state
                end,
                SetKeybind = function(newKey)
                    keybind = newKey
                    KeybindButton.Text = tostring(newKey):gsub("Enum.KeyCode.", "")
                end,
                GetKeybind = function()
                    return keybind
                end
            }
        end
        
        function TabMethods:AddButton(ButtonConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local Button = Instance.new("TextButton")
            Button.Name = ButtonConfig.Text or "Button"
            Button.Text = ButtonConfig.Text or "Button"
            Button.Font = Enum.Font.GothamBold
            Button.TextSize = 14
            Button.TextColor3 = Theme.Text
            Button.BackgroundColor3 = Theme.Secondary
            Button.AutoButtonColor = false
            Button.Size = UDim2.new(0.9, 0, 0, 40)
            Button.LayoutOrder = elementLayoutCounter 
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = Button
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Theme.Stroke
            btnStroke.Thickness = 2
            btnStroke.Parent = Button
            
            local hoverTween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Primary})
            local leaveTween = TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Secondary})
            
            Button.MouseEnter:Connect(function()
                hoverTween:Play()
            end)
            
            Button.MouseLeave:Connect(function()
                leaveTween:Play()
            end)
            
            Button.MouseButton1Click:Connect(function()
                if ButtonConfig.Callback then
                    ButtonConfig.Callback()
                end
                
                local clickTween = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.85, 0, 0, 36)})
                local releaseTween = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.9, 0, 0, 40)})
                
                clickTween:Play()
                clickTween.Completed:Wait()
                releaseTween:Play()
            end)
            
            Button.Parent = TabContent
            return Button
        end
        
        function TabMethods:AddToggle(ToggleConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = ToggleConfig.Text or "Toggle"
            ToggleFrame.BackgroundTransparency = 1
            ToggleFrame.Size = UDim2.new(0.9, 0, 0, 35)
            ToggleFrame.LayoutOrder = elementLayoutCounter
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Text = ""
            ToggleButton.BackgroundTransparency = 1
            ToggleButton.Size = UDim2.new(1, 0, 1, 0)
            ToggleButton.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Text = ToggleConfig.Text or "Toggle"
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextSize = 14
            ToggleLabel.TextColor3 = Theme.Text
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleBack = Instance.new("Frame")
            ToggleBack.Name = "ToggleBack"
            ToggleBack.BackgroundColor3 = Theme.Secondary
            ToggleBack.Size = UDim2.new(0, 50, 0, 25)
            ToggleBack.Position = UDim2.new(1, -55, 0.5, -12.5)
            
            local backCorner = Instance.new("UICorner")
            backCorner.CornerRadius = UDim.new(1, 0)
            backCorner.Parent = ToggleBack
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Name = "ToggleCircle"
            ToggleCircle.BackgroundColor3 = Color3.new(1, 1, 1)
            ToggleCircle.Size = UDim2.new(0, 19, 0, 19)
            ToggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
            
            local circleCorner = Instance.new("UICorner")
            circleCorner.CornerRadius = UDim.new(1, 0)
            circleCorner.Parent = ToggleCircle
            
            local backStroke = Instance.new("UIStroke")
            backStroke.Color = Theme.Stroke
            backStroke.Thickness = 2
            backStroke.Parent = ToggleBack
            
            local circleStroke = Instance.new("UIStroke")
            circleStroke.Color = Theme.Stroke
            circleStroke.Thickness = 1
            circleStroke.Parent = ToggleCircle
            
            ToggleBack.Parent = ToggleFrame
            ToggleCircle.Parent = ToggleBack
            
            local state = ToggleConfig.Default or false
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
            
            local function UpdateToggle()
                if state then
                    TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(1, -22, 0.5, -9.5)}):Play()
                    TweenService:Create(ToggleBack, tweenInfo, {BackgroundColor3 = Theme.Primary}):Play()
                else
                    TweenService:Create(ToggleCircle, tweenInfo, {Position = UDim2.new(0, 3, 0.5, -9.5)}):Play()
                    TweenService:Create(ToggleBack, tweenInfo, {BackgroundColor3 = Theme.Secondary}):Play()
                end
                
                if ToggleConfig.Callback then
                    ToggleConfig.Callback(state)
                end
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                state = not state
                UpdateToggle()
            end)
            
            UpdateToggle()
            
            ToggleFrame.Parent = TabContent
            
            return {
                Frame = ToggleFrame,
                SetState = function(value)
                    state = value
                    UpdateToggle()
                end,
                GetState = function() return state end
            }
        end
        
        function TabMethods:AddSlider(SliderConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Name = SliderConfig.Text or "Slider"
            SliderFrame.BackgroundTransparency = 1
            SliderFrame.Size = UDim2.new(0.9, 0, 0, 60)
            SliderFrame.LayoutOrder = elementLayoutCounter
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Text = SliderConfig.Text or "Slider"
            SliderLabel.Font = Enum.Font.Gotham
            SliderLabel.TextSize = 14
            SliderLabel.TextColor3 = Theme.Text
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Size = UDim2.new(1, 0, 0, 20)
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Name = "ValueLabel"
            ValueLabel.Text = tostring(SliderConfig.Default or SliderConfig.Min or 0)
            ValueLabel.Font = Enum.Font.GothamBold
            ValueLabel.TextSize = 14
            ValueLabel.TextColor3 = Theme.Primary
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Size = UDim2.new(0.2, 0, 0, 20)
            ValueLabel.Position = UDim2.new(0.8, 0, 0, 0)
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.Parent = SliderFrame
            
            local Track = Instance.new("Frame")
            Track.Name = "Track"
            Track.BackgroundColor3 = Theme.Secondary
            Track.Size = UDim2.new(1, 0, 0, 5)
            Track.Position = UDim2.new(0, 0, 0, 35)
            
            local trackCorner = Instance.new("UICorner")
            trackCorner.CornerRadius = UDim.new(1, 0)
            trackCorner.Parent = Track
            
            local Fill = Instance.new("Frame")
            Fill.Name = "Fill"
            Fill.BackgroundColor3 = Theme.Primary
            Fill.Size = UDim2.new(0, 0, 1, 0)
            
            local fillCorner = Instance.new("UICorner")
            fillCorner.CornerRadius = UDim.new(1, 0)
            fillCorner.Parent = Fill
            
            local Handle = Instance.new("Frame")
            Handle.Name = "Handle"
            Handle.BackgroundColor3 = Color3.new(1, 1, 1)
            Handle.Size = UDim2.new(0, 15, 0, 15)
            Handle.Position = UDim2.new(0, -7.5, 0.5, -7.5)
            
            local handleCorner = Instance.new("UICorner")
            handleCorner.CornerRadius = UDim.new(1, 0)
            handleCorner.Parent = Handle
            
            local trackStroke = Instance.new("UIStroke")
            trackStroke.Color = Theme.Stroke
            trackStroke.Thickness = 1
            trackStroke.Parent = Track
            
            local handleStroke = Instance.new("UIStroke")
            handleStroke.Color = Theme.Stroke
            handleStroke.Thickness = 2
            handleStroke.Parent = Handle
            
            Fill.Parent = Track
            Handle.Parent = Track
            Track.Parent = SliderFrame
            
            local min = SliderConfig.Min or 0
            local max = SliderConfig.Max or 100
            local default = SliderConfig.Default or min
            local value = default
            local sliding = false
            
            local function UpdateSlider(newValue)
                value = math.clamp(newValue, min, max)
                local ratio = (value - min) / (max - min)
                
                Fill.Size = UDim2.new(ratio, 0, 1, 0)
                Handle.Position = UDim2.new(ratio, -7.5, 0.5, -7.5)
                ValueLabel.Text = string.format("%.1f", value)
                
                if SliderConfig.Callback then
                    SliderConfig.Callback(value)
                end
            end
            
            local function UpdateFromInput(input)
                local pos = input.Position.X - Track.AbsolutePosition.X
                local ratio = math.clamp(pos / Track.AbsoluteSize.X, 0, 1)
                UpdateSlider(min + ratio * (max - min))
            end
            
            Track.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = true
                    UpdateFromInput(input)
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                    UpdateFromInput(input)
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                    sliding = false
                end
            end)
            
            UpdateSlider(default)
            
            SliderFrame.Parent = TabContent
            
            return {
                Frame = SliderFrame,
                SetValue = function(newValue)
                    UpdateSlider(newValue)
                end,
                GetValue = function() return value end
            }
        end
        
        function TabMethods:AddCheckbox(CheckboxConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local CheckboxFrame = Instance.new("Frame")
            CheckboxFrame.Name = CheckboxConfig.Text or "Checkbox"
            CheckboxFrame.BackgroundTransparency = 1
            CheckboxFrame.Size = UDim2.new(0.9, 0, 0, 35)
            CheckboxFrame.LayoutOrder = elementLayoutCounter
            
            local CheckboxButton = Instance.new("TextButton")
            CheckboxButton.Text = ""
            CheckboxButton.BackgroundTransparency = 1
            CheckboxButton.Size = UDim2.new(1, 0, 1, 0)
            CheckboxButton.Parent = CheckboxFrame
            
            local CheckboxLabel = Instance.new("TextLabel")
            CheckboxLabel.Text = CheckboxConfig.Text or "Checkbox"
            CheckboxLabel.Font = Enum.Font.Gotham
            CheckboxLabel.TextSize = 14
            CheckboxLabel.TextColor3 = Theme.Text
            CheckboxLabel.BackgroundTransparency = 1
            CheckboxLabel.Size = UDim2.new(0.7, 0, 1, 0)
            CheckboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            CheckboxLabel.Parent = CheckboxFrame
            
            local CheckboxBack = Instance.new("Frame")
            CheckboxBack.Name = "CheckboxBack"
            CheckboxBack.BackgroundColor3 = Theme.Secondary
            CheckboxBack.Size = UDim2.new(0, 25, 0, 25)
            CheckboxBack.Position = UDim2.new(1, -30, 0.5, -12.5)
            
            local backCorner = Instance.new("UICorner")
            backCorner.CornerRadius = UDim.new(0, 5)
            backCorner.Parent = CheckboxBack
            
            local CheckIcon = Instance.new("ImageLabel")
            CheckIcon.Name = "CheckIcon"
            CheckIcon.Image = "rbxassetid://3926305904"
            CheckIcon.ImageRectOffset = Vector2.new(312, 4)
            CheckIcon.ImageRectSize = Vector2.new(24, 24)
            CheckIcon.BackgroundTransparency = 1
            CheckIcon.Size = UDim2.new(0.8, 0, 0.8, 0)
            CheckIcon.Position = UDim2.new(0.1, 0, 0.1, 0)
            CheckIcon.Visible = false
            
            local backStroke = Instance.new("UIStroke")
            backStroke.Color = Theme.Stroke
            backStroke.Thickness = 2
            backStroke.Parent = CheckboxBack
            
            CheckboxBack.Parent = CheckboxFrame
            CheckIcon.Parent = CheckboxBack
            
            local state = CheckboxConfig.Default or false
            local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
            
            local function UpdateCheckbox()
                if state then
                    CheckIcon.Visible = true
                    TweenService:Create(CheckboxBack, tweenInfo, {BackgroundColor3 = Theme.Primary}):Play()
                else
                    CheckIcon.Visible = false
                    TweenService:Create(CheckboxBack, tweenInfo, {BackgroundColor3 = Theme.Secondary}):Play()
                end
                
                if CheckboxConfig.Callback then
                    CheckboxConfig.Callback(state)
                end
            end
            
            CheckboxButton.MouseButton1Click:Connect(function()
                state = not state
                UpdateCheckbox()
            end)
            
            UpdateCheckbox()
            
            CheckboxFrame.Parent = TabContent
            
            return {
                Frame = CheckboxFrame,
                SetState = function(value)
                    state = value
                    UpdateCheckbox()
                end,
                GetState = function() return state end
            }
        end
        
        function TabMethods:AddDropdown(DropdownConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Name = DropdownConfig.Text or "Dropdown"
            DropdownFrame.BackgroundTransparency = 1
            DropdownFrame.Size = UDim2.new(0.9, 0, 0, 40)
            DropdownFrame.LayoutOrder = elementLayoutCounter
            
            local DropdownLabel = Instance.new("TextLabel")
            DropdownLabel.Text = DropdownConfig.Text or "Dropdown"
            DropdownLabel.Font = Enum.Font.Gotham
            DropdownLabel.TextSize = 14
            DropdownLabel.TextColor3 = Theme.Text
            DropdownLabel.BackgroundTransparency = 1
            DropdownLabel.Size = UDim2.new(1, 0, 0, 20)
            DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
            DropdownLabel.Parent = DropdownFrame
            
            local DropdownButton = Instance.new("TextButton")
            DropdownButton.Name = "DropdownButton"
            DropdownButton.Text = DropdownConfig.Default or "Select"
            DropdownButton.Font = Enum.Font.Gotham
            DropdownButton.TextSize = 14
            DropdownButton.TextColor3 = Theme.Text
            DropdownButton.BackgroundColor3 = Theme.Secondary
            DropdownButton.AutoButtonColor = false
            DropdownButton.Size = UDim2.new(1, 0, 0, 35)
            DropdownButton.Position = UDim2.new(0, 0, 0, 20)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = DropdownButton
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Theme.Stroke
            btnStroke.Thickness = 2
            btnStroke.Parent = DropdownButton
            
            local Arrow = Instance.new("ImageLabel")
            Arrow.Name = "Arrow"
            Arrow.Image = "rbxassetid://3926305904"
            Arrow.ImageRectOffset = Vector2.new(884, 284)
            Arrow.ImageRectSize = Vector2.new(36, 36)
            Arrow.BackgroundTransparency = 1
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -25, 0.5, -10)
            Arrow.Parent = DropdownButton
            
            local OptionsFrame = Instance.new("Frame")
            OptionsFrame.Name = "Options"
            OptionsFrame.BackgroundColor3 = Theme.Secondary
            OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
            OptionsFrame.Position = UDim2.new(0, 0, 0, 60)
            OptionsFrame.Visible = false
            OptionsFrame.ZIndex = 10
            
            local optionsCorner = Instance.new("UICorner")
            optionsCorner.CornerRadius = UDim.new(0, 6)
            optionsCorner.Parent = OptionsFrame
            
            local optionsStroke = Instance.new("UIStroke")
            optionsStroke.Color = Theme.Stroke
            optionsStroke.Thickness = 2
            optionsStroke.Parent = OptionsFrame
            
            local OptionsLayout = Instance.new("UIListLayout")
            OptionsLayout.SortOrder = Enum.SortOrder.LayoutOrder
            OptionsLayout.Parent = OptionsFrame
            
            local open = false
            local selected = DropdownConfig.Default
            local options = DropdownConfig.Options or {}
            
            local function ToggleDropdown()
                open = not open
                OptionsFrame.Visible = open
                
                if open then
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 180}):Play()
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, #options * 35)}):Play()
                else
                    TweenService:Create(Arrow, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    TweenService:Create(OptionsFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, 0)}):Play()
                end
            end
            
            for i, option in ipairs(options) do
                local OptionButton = Instance.new("TextButton")
                OptionButton.Name = option
                OptionButton.Text = option
                OptionButton.Font = Enum.Font.Gotham
                OptionButton.TextSize = 14
                OptionButton.TextColor3 = Theme.Text
                OptionButton.BackgroundColor3 = Theme.Secondary
                OptionButton.AutoButtonColor = false
                OptionButton.Size = UDim2.new(1, 0, 0, 35)
                OptionButton.LayoutOrder = i
                OptionButton.ZIndex = 11
                
                local optionCorner = Instance.new("UICorner")
                optionCorner.CornerRadius = UDim.new(0, 6)
                optionCorner.Parent = OptionButton
                
                OptionButton.MouseButton1Click:Connect(function()
                    selected = option
                    DropdownButton.Text = option
                    ToggleDropdown()
                    
                    if DropdownConfig.Callback then
                        DropdownConfig.Callback(option)
                    end
                end)
                
                OptionButton.Parent = OptionsFrame
            end
            
            DropdownButton.MouseButton1Click:Connect(ToggleDropdown)
            
            DropdownButton.Parent = DropdownFrame
            OptionsFrame.Parent = DropdownFrame
            DropdownFrame.Parent = TabContent
            
            return {
                Frame = DropdownFrame,
                SetValue = function(value)
                    selected = value
                    DropdownButton.Text = value
                end,
                GetValue = function() return selected end
            }
        end
        
        function TabMethods:AddTextbox(TextboxConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local TextboxFrame = Instance.new("Frame")
            TextboxFrame.Name = TextboxConfig.Text or "Textbox"
            TextboxFrame.BackgroundTransparency = 1
            TextboxFrame.Size = UDim2.new(0.9, 0, 0, 60)
            TextboxFrame.LayoutOrder = elementLayoutCounter
            
            local TextboxLabel = Instance.new("TextLabel")
            TextboxLabel.Text = TextboxConfig.Text or "Textbox"
            TextboxLabel.Font = Enum.Font.Gotham
            TextboxLabel.TextSize = 14
            TextboxLabel.TextColor3 = Theme.Text
            TextboxLabel.BackgroundTransparency = 1
            TextboxLabel.Size = UDim2.new(1, 0, 0, 20)
            TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
            TextboxLabel.Parent = TextboxFrame
            
            local Textbox = Instance.new("TextBox")
            Textbox.Name = "Textbox"
            Textbox.PlaceholderText = TextboxConfig.Placeholder or "Enter text..."
            Textbox.Text = TextboxConfig.Default or ""
            Textbox.Font = Enum.Font.Gotham
            Textbox.TextSize = 14
            Textbox.TextColor3 = Theme.Text
            Textbox.BackgroundColor3 = Theme.Secondary
            Textbox.Size = UDim2.new(1, 0, 0, 35)
            Textbox.Position = UDim2.new(0, 0, 0, 20)
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 6)
            boxCorner.Parent = Textbox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Theme.Stroke
            boxStroke.Thickness = 2
            boxStroke.Parent = Textbox
            
            Textbox.FocusLost:Connect(function()
                if TextboxConfig.Callback then
                    TextboxConfig.Callback(Textbox.Text)
                end
            end)
            
            Textbox.Parent = TextboxFrame
            TextboxFrame.Parent = TabContent
            
            return {
                Frame = TextboxFrame,
                SetText = function(text)
                    Textbox.Text = text
                end,
                GetText = function() return Textbox.Text end
            }
        end
        
        function TabMethods:AddKeybind(KeybindConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local KeybindFrame = Instance.new("Frame")
            KeybindFrame.Name = KeybindConfig.Text or "Keybind"
            KeybindFrame.BackgroundTransparency = 1
            KeybindFrame.Size = UDim2.new(0.9, 0, 0, 35)
            KeybindFrame.LayoutOrder = elementLayoutCounter
            
            local KeybindLabel = Instance.new("TextLabel")
            KeybindLabel.Text = KeybindConfig.Text or "Keybind"
            KeybindLabel.Font = Enum.Font.Gotham
            KeybindLabel.TextSize = 14
            KeybindLabel.TextColor3 = Theme.Text
            KeybindLabel.BackgroundTransparency = 1
            KeybindLabel.Size = UDim2.new(0.7, 0, 1, 0)
            KeybindLabel.TextXAlignment = Enum.TextXAlignment.Left
            KeybindLabel.Parent = KeybindFrame
            
            local KeybindButton = Instance.new("TextButton")
            KeybindButton.Name = "KeybindButton"
            KeybindButton.Text = KeybindConfig.Default and KeybindConfig.Default.Name or "NONE"
            KeybindButton.Font = Enum.Font.GothamBold
            KeybindButton.TextSize = 14
            KeybindButton.TextColor3 = Theme.Text
            KeybindButton.BackgroundColor3 = Theme.Secondary
            KeybindButton.AutoButtonColor = false
            KeybindButton.Size = UDim2.new(0, 100, 0.8, 0)
            KeybindButton.Position = UDim2.new(1, -105, 0.1, 0)
            
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 6)
            btnCorner.Parent = KeybindButton
            
            local btnStroke = Instance.new("UIStroke")
            btnStroke.Color = Theme.Stroke
            btnStroke.Thickness = 2
            btnStroke.Parent = KeybindButton
            
            local listening = false
            local currentKey = KeybindConfig.Default
            
            KeybindButton.MouseButton1Click:Connect(function()
                listening = true
                KeybindButton.Text = "..."
                KeybindButton.BackgroundColor3 = Theme.Primary
            end)
            
            UserInputService.InputBegan:Connect(function(input)
                if listening then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        currentKey = input.KeyCode
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        currentKey = Enum.UserInputType.MouseButton1
                    end
                    
                    KeybindButton.Text = tostring(currentKey):gsub("Enum.KeyCode.", "")
                    KeybindButton.BackgroundColor3 = Theme.Secondary
                    listening = false
                    
                    if KeybindConfig.Callback then
                        KeybindConfig.Callback(currentKey)
                    end
                end
            end)
            
            KeybindButton.Parent = KeybindFrame
            KeybindFrame.Parent = TabContent
            
            return {
                Frame = KeybindFrame,
                SetKey = function(key)
                    currentKey = key
                    KeybindButton.Text = tostring(key):gsub("Enum.KeyCode.", "")
                end,
                GetKey = function() return currentKey end
            }
        end
        
        function TabMethods:AddLabel(LabelConfig)
        elementLayoutCounter = elementLayoutCounter + 1
        
            local LabelFrame = Instance.new("Frame")
            LabelFrame.Name = "Label"
            LabelFrame.BackgroundTransparency = 1
            LabelFrame.Size = UDim2.new(0.9, 0, 0, 25)
            LabelFrame.LayoutOrder = elementLayoutCounter
            
            local Label = Instance.new("TextLabel")
            Label.Text = LabelConfig.Text or "Label"
            Label.Font = Enum.Font.Gotham
            Label.TextSize = LabelConfig.Size or 14
            Label.TextColor3 = LabelConfig.Color or Theme.Text
            Label.TextTransparency = LabelConfig.Transparency or 0
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, 0, 1, 0)
            Label.TextXAlignment = LabelConfig.Alignment or Enum.TextXAlignment.Left
            
            if LabelConfig.Center then
                Label.TextXAlignment = Enum.TextXAlignment.Center
            end
            
            if LabelConfig.Stroke then
                local stroke = Instance.new("UIStroke")
                stroke.Color = Theme.Stroke
                stroke.Thickness = 1
                stroke.Parent = Label
            end
            
            Label.Parent = LabelFrame
            LabelFrame.Parent = TabContent
            
            return LabelFrame
        end
        
        return TabMethods
    end
    
    return Window
end

return Library
