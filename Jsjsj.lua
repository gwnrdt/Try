local Env = {}

local TweenService: TweenService = game:GetService("TweenService")
local UserInputService: UserInputService = game:GetService("UserInputService")

GetIcon = function(i)
	if type(i) == 'string' and not i:find('rbxassetid://') then
		return "rbxassetid://".. i
	elseif type(i) == 'number' then
		return "rbxassetid://".. i
	else
		return i
	end
end

tw = function(info)
	return TweenService:Create(info.v, TweenInfo.new(info.t, Enum.EasingStyle[info.s], Enum.EasingDirection[info.d]), info.g)
end

lak = function(a)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
		local Tween = game:GetService("TweenService"):Create(a, TweenInfo.new(0.3), {Position = pos})
		Tween:Play()
	end

	a.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = a.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	a.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

click = function(p)
	local Click = Instance.new("TextButton")

	Click.Name = "Click"
	Click.Parent = p
	Click.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Click.BackgroundTransparency = 1.000
	Click.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Click.BorderSizePixel = 0
	Click.Size = UDim2.new(1, 0, 1, 0)
	Click.Font = Enum.Font.SourceSans
	Click.Text = ""
	Click.TextColor3 = Color3.fromRGB(0, 0, 0)
	Click.TextSize = 14.000
	Click.ZIndex = p.ZIndex + 2

	return Click
end

EffectClick = function(c, p)
	local Mouse = game.Players.LocalPlayer:GetMouse()

	local relativeX = Mouse.X - c.AbsolutePosition.X
	local relativeY = Mouse.Y - c.AbsolutePosition.Y

	if relativeX < 0 or relativeY < 0 or relativeX > c.AbsoluteSize.X or relativeY > c.AbsoluteSize.Y then
		return
	end

	local ClickButtonCircle = Instance.new("Frame")
	ClickButtonCircle.Parent = p
	ClickButtonCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ClickButtonCircle.BackgroundTransparency = 0.5
	ClickButtonCircle.BorderSizePixel = 0
	ClickButtonCircle.AnchorPoint = Vector2.new(0.5, 0.5)
	ClickButtonCircle.Position = UDim2.new(0, relativeX, 0, relativeY)
	ClickButtonCircle.Size = UDim2.new(0, 0, 0, 0)
	ClickButtonCircle.ZIndex = p.ZIndex

	local UICorner = Instance.new("UICorner")
	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = ClickButtonCircle

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	local goal = {
		Size = UDim2.new(0, c.AbsoluteSize.X * 1.5, 0, c.AbsoluteSize.X * 1.5),
		BackgroundTransparency = 1
	}

	local expandTween = TweenService:Create(ClickButtonCircle, tweenInfo, goal)

	expandTween.Completed:Connect(function()
		ClickButtonCircle:Destroy()
	end)

	expandTween:Play()
end

local Unique = Instance.new("ScreenGui")
Unique.Name = "Unique"
Unique.Parent = not game:GetService("RunService"):IsStudio() and game:GetService("CoreGui") or game:GetService("Players").LocalPlayer.PlayerGui
Unique.ZIndexBehavior = Enum.ZIndexBehavior.Global
Unique.IgnoreGuiInset = true

function Env:Window(meta)
	local Logo  = meta.Logo
	local Bind = meta.Bind or Enum.KeyCode.Q
	
	local Background_1 = Instance.new("Frame")
	local DropShadow_1 = Instance.new("ImageLabel")
	local Logo_1 = Instance.new("ImageLabel")
	local UIGradient_1 = Instance.new("UIGradient")
	local UICorner_1 = Instance.new("UICorner")
	local Header_1 = Instance.new("Frame")
	local LogoHead_1 = Instance.new("Frame")
	local RealLogo_1 = Instance.new("ImageLabel")
	local UIListLayout_1 = Instance.new("UIListLayout")
	local Tabs_1 = Instance.new("Frame")
	local Tablist_1 = Instance.new("ScrollingFrame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	
	Background_1.Name = "Background"
	Background_1.Parent = Unique
	Background_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Background_1.BackgroundColor3 = Color3.fromRGB(20,20,20)
	Background_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Background_1.BorderSizePixel = 0
	Background_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Background_1.Size = UDim2.new(0, 500,0, 375)
	
	lak(Background_1)

	DropShadow_1.Name = "DropShadow"
	DropShadow_1.Parent = Background_1
	DropShadow_1.AnchorPoint = Vector2.new(0.5, 0.5)
	DropShadow_1.BackgroundColor3 = Color3.fromRGB(28,28,30)
	DropShadow_1.BackgroundTransparency = 1
	DropShadow_1.BorderColor3 = Color3.fromRGB(0,0,0)
	DropShadow_1.BorderSizePixel = 0
	DropShadow_1.Position = UDim2.new(0.5, 0,0.5, 0)
	DropShadow_1.Size = UDim2.new(1, 120,1, 120)
	DropShadow_1.ZIndex = 0
	DropShadow_1.Image = "rbxassetid://8992230677"
	DropShadow_1.ImageColor3 = Color3.fromRGB(0,0,0)
	DropShadow_1.ScaleType = Enum.ScaleType.Slice
	DropShadow_1.SliceCenter = Rect.new(100, 100, 100, 100)
	
	local CloseUI = Instance.new("TextButton")
	local UICorner_1z = Instance.new("UICorner")
	local Icon_1 = Instance.new("Frame")
	local ImageLabel = Instance.new("ImageLabel")


	CloseUI.Name = "CloseUI"
	CloseUI.Parent = Unique
	CloseUI.AnchorPoint = Vector2.new(0, 1)
	CloseUI.BackgroundColor3 = Color3.fromRGB(0,0,0)
	CloseUI.BorderColor3 = Color3.fromRGB(0,0,0)
	CloseUI.BorderSizePixel = 0
	CloseUI.Position = UDim2.new(0.5, 0,0.1, 0)
	CloseUI.Size = UDim2.new(0, 50,0, 50)
	CloseUI.BackgroundTransparency = 0.35
	CloseUI.Text = ""

	lak(CloseUI)

	UICorner_1z.Parent = CloseUI
	UICorner_1z.CornerRadius = UDim.new(0,5)

	Icon_1.Name = "Icon"
	Icon_1.Parent = CloseUI
	Icon_1.BackgroundColor3 = Color3.fromRGB(22,22,22)
	Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Icon_1.BorderSizePixel = 0
	Icon_1.Size = UDim2.new(0, 50,0, 50)
	Icon_1.BackgroundTransparency = 1

	ImageLabel.Parent = Icon_1
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	ImageLabel.BackgroundColor3 = Color3.fromRGB(255,255,255)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.BorderColor3 = Color3.fromRGB(0,0,0)
	ImageLabel.BorderSizePixel = 0
	ImageLabel.Position = UDim2.new(0.5, 0,0.5, 0)
	ImageLabel.Size = UDim2.new(0, 45,0, 45)
	ImageLabel.Image = GetIcon(Logo)
	ImageLabel.ImageTransparency = 0

	local function closeopenui()
		task.spawn(function()
			tw({
				v = ImageLabel,
				t = 0.2,
				s = "Back",
				d = "Out",
				g = {Size = UDim2.new(0, 35, 0, 35)}
			}):Play()
			task.wait(0.016) 
			tw({
				v = ImageLabel,
				t = 0.2,
				s = "Back",
				d = "Out",
				g = {Size = UDim2.new(0, 45, 0, 45)}
			}):Play()
		end)
		Background_1.Visible = not Background_1.Visible
	end

	local On = true

	CloseUI.MouseButton1Click:Connect(function()
		closeopenui()
		On = not On
	end)

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed and input.KeyCode == Bind then
			closeopenui()
			On = not On
		end
	end)

	Logo_1.Name = "Logo"
	Logo_1.Parent = Background_1
	Logo_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Logo_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Logo_1.BackgroundTransparency = 1
	Logo_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Logo_1.BorderSizePixel = 0
	Logo_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Logo_1.Size = UDim2.new(0, 250,0, 250)
	Logo_1.Image = GetIcon(Logo)
	Logo_1.ImageTransparency = 0.6000000238418579

	UIGradient_1.Parent = Logo_1
	UIGradient_1.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0.28125), NumberSequenceKeypoint.new(0.998753,1), NumberSequenceKeypoint.new(1,0)}

	UICorner_1.Parent = Background_1
	UICorner_1.CornerRadius = UDim.new(0,10)

	Header_1.Name = "Header"
	Header_1.Parent = Background_1
	Header_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Header_1.BackgroundTransparency = 1
	Header_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Header_1.BorderSizePixel = 0
	Header_1.Size = UDim2.new(0, 70,0, 375)

	LogoHead_1.Name = "LogoHead"
	LogoHead_1.Parent = Header_1
	LogoHead_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	LogoHead_1.BackgroundTransparency = 1
	LogoHead_1.BorderColor3 = Color3.fromRGB(0,0,0)
	LogoHead_1.BorderSizePixel = 0
	LogoHead_1.Size = UDim2.new(0, 50,0, 50)

	RealLogo_1.Name = "RealLogo"
	RealLogo_1.Parent = LogoHead_1
	RealLogo_1.AnchorPoint = Vector2.new(0.5, 0.5)
	RealLogo_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	RealLogo_1.BackgroundTransparency = 1
	RealLogo_1.BorderColor3 = Color3.fromRGB(0,0,0)
	RealLogo_1.BorderSizePixel = 0
	RealLogo_1.Position = UDim2.new(0.5, 0,0.5, 0)
	RealLogo_1.Size = UDim2.new(0.899999976, 0,0.899999976, 0)
	RealLogo_1.Image = "rbxassetid://91627984695209"
	RealLogo_1.ScaleType = Enum.ScaleType.Crop

	UIListLayout_1.Parent = Header_1
	UIListLayout_1.Padding = UDim.new(0,5)
	UIListLayout_1.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_1.VerticalAlignment = Enum.VerticalAlignment.Center

	Tabs_1.Name = "Tabs"
	Tabs_1.Parent = Header_1
	Tabs_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Tabs_1.BackgroundTransparency = 1
	Tabs_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Tabs_1.BorderSizePixel = 0
	Tabs_1.Position = UDim2.new(0, 0,0.184, 0)
	Tabs_1.Size = UDim2.new(0, 60,0, 300)

	Tablist_1.Name = "Tablist"
	Tablist_1.Parent = Tabs_1
	Tablist_1.Active = true
	Tablist_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Tablist_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Tablist_1.BackgroundTransparency = 1
	Tablist_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Tablist_1.BorderSizePixel = 0
	Tablist_1.Position = UDim2.new(0.5, 0,0.5, 0)
	Tablist_1.Size = UDim2.new(0.949999988, 0,1, 0)
	Tablist_1.ClipsDescendants = true
	Tablist_1.AutomaticCanvasSize = Enum.AutomaticSize.None
	Tablist_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
	Tablist_1.CanvasPosition = Vector2.new(0, 0)
	Tablist_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
	Tablist_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
	Tablist_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
	Tablist_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
	Tablist_1.ScrollBarImageTransparency = 1
	Tablist_1.ScrollBarThickness = 0
	Tablist_1.ScrollingDirection = Enum.ScrollingDirection.XY
	Tablist_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
	Tablist_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
	Tablist_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

	UIListLayout_2.Parent = Tablist_1
	UIListLayout_2.Padding = UDim.new(0,10)
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	
	local Line_1 = Instance.new("Frame")
	
	Line_1.Name = "Line"
	Line_1.Parent = Background_1
	Line_1.AnchorPoint = Vector2.new(0.5, 0.5)
	Line_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Line_1.BackgroundTransparency = 0.8999999761581421
	Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
	Line_1.BorderSizePixel = 0
	Line_1.Position = UDim2.new(0.136000007, 0,0.5, 0)
	Line_1.Size = UDim2.new(0, 1,1, 0)
	
	Env.Tab = {
		Value = false
	}
	
	function Env.Tab:Tab(icon)
		local AddList_1 = Instance.new("Frame")
		local Clicktab = click(AddList_1)
		local UICorner_2 = Instance.new("UICorner")
		local UIGradient_2 = Instance.new("UIGradient")
		local Icon_1 = Instance.new("ImageLabel")
		local UIPadding_1 = Instance.new("UIPadding")
		local Page_1 = Instance.new("Frame")
		local UIListLayout_3 = Instance.new("UIListLayout")
		local Left_1 = Instance.new("ScrollingFrame")
		local UIListLayout_4 = Instance.new("UIListLayout")
		local UIPadding_2 = Instance.new("UIPadding")
		
		
		AddList_1.Name = "AddList"
		AddList_1.Parent = Tablist_1
		AddList_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		AddList_1.BorderColor3 = Color3.fromRGB(0,0,0)
		AddList_1.BorderSizePixel = 0
		AddList_1.Size = UDim2.new(0, 40,0, 40)
		AddList_1.BackgroundTransparency = 1

		UICorner_2.Parent = AddList_1
		UICorner_2.CornerRadius = UDim.new(0,13)

		UIGradient_2.Parent = AddList_1
		UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 113, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(66, 156, 255))}
		UIGradient_2.Rotation = -159

		Icon_1.Name = "Icon"
		Icon_1.Parent = AddList_1
		Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Icon_1.BackgroundTransparency = 1
		Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Icon_1.BorderSizePixel = 0
		Icon_1.Position = UDim2.new(0.5, 0,0.5, 0)
		Icon_1.Size = UDim2.new(0.5, 0,0.5, 0)
		Icon_1.Image = GetIcon(icon)
		Icon_1.ImageTransparency = 0.8

		UIPadding_1.Parent = Tablist_1
		UIPadding_1.PaddingTop = UDim.new(0,5)

		Page_1.Name = "Page"
		Page_1.Parent = Background_1
		Page_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Page_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Page_1.BackgroundTransparency = 1
		Page_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Page_1.BorderSizePixel = 0
		Page_1.Position = UDim2.new(0.568499982, 0,0.5, 0)
		Page_1.Size = UDim2.new(0.860999942, 1,1, 0)
		Page_1.Visible = false

		UIListLayout_3.Parent = Page_1
		UIListLayout_3.Padding = UDim.new(0,3)
		UIListLayout_3.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_3.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_3.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_3.VerticalAlignment = Enum.VerticalAlignment.Center

		Left_1.Name = "Left"
		Left_1.Parent = Page_1
		Left_1.Active = true
		Left_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Left_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Left_1.BackgroundTransparency = 1
		Left_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Left_1.BorderSizePixel = 0
		Left_1.Size = UDim2.new(0, 210,0.949999988, 0)
		Left_1.ClipsDescendants = true
		Left_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		Left_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		Left_1.CanvasPosition = Vector2.new(0, 0)
		Left_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		Left_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		Left_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		Left_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
		Left_1.ScrollBarImageTransparency = 1
		Left_1.ScrollBarThickness = 0
		Left_1.ScrollingDirection = Enum.ScrollingDirection.XY
		Left_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		Left_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		Left_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_4.Parent = Left_1
		UIListLayout_4.Padding = UDim.new(0,10)
		UIListLayout_4.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_4.SortOrder = Enum.SortOrder.LayoutOrder
		
		local Right_1 = Instance.new("ScrollingFrame")
		local UIListLayout_6 = Instance.new("UIListLayout")
		local UIPadding_3 = Instance.new("UIPadding")
		
		Right_1.Name = "Right"
		Right_1.Parent = Page_1
		Right_1.Active = true
		Right_1.AnchorPoint = Vector2.new(0.5, 0.5)
		Right_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
		Right_1.BackgroundTransparency = 1
		Right_1.BorderColor3 = Color3.fromRGB(0,0,0)
		Right_1.BorderSizePixel = 0
		Right_1.Size = UDim2.new(0, 210,0.949999988, 0)
		Right_1.ClipsDescendants = true
		Right_1.AutomaticCanvasSize = Enum.AutomaticSize.None
		Right_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
		Right_1.CanvasPosition = Vector2.new(0, 0)
		Right_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
		Right_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
		Right_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
		Right_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
		Right_1.ScrollBarImageTransparency = 1
		Right_1.ScrollBarThickness = 0
		Right_1.ScrollingDirection = Enum.ScrollingDirection.XY
		Right_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
		Right_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
		Right_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

		UIListLayout_6.Parent = Right_1
		UIListLayout_6.Padding = UDim.new(0,10)
		UIListLayout_6.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_6.SortOrder = Enum.SortOrder.LayoutOrder

		UIPadding_3.Parent = Right_1
		UIPadding_3.PaddingTop = UDim.new(0,1)
		
		UIPadding_2.Parent = Left_1
		UIPadding_2.PaddingTop = UDim.new(0,1)
		
		Clicktab.MouseButton1Click:Connect(function()
			for i, v in pairs(Background_1:GetChildren()) do
				if v.Name == "Page" then
					v.Visible = false
				end
			end
			for i, v in pairs(Tablist_1:GetChildren()) do
				if v:IsA("Frame") then
					tw({
						v = v,
						t = 0.2,
						s = "Linear",
						d = "Out",
						g = {BackgroundTransparency = 1}
					}):Play()
					tw({
						v = v.Icon,
						t = 0.2,
						s = "Linear",
						d = "Out",
						g = {ImageTransparency = 0.8}
					}):Play()
				end
			end
			Page_1.Visible = true
			Page_1.Size = UDim2.new(0, 0,0, 0)
			tw({
				v = Page_1,
				t = 0.1,
				s = "Linear",
				d = "Out",
				g = {Size = UDim2.new(0.860999942, 1,1, 0)}
			}):Play()
			tw({
				v = AddList_1,
				t = 0.2,
				s = "Linear",
				d = "Out",
				g = {BackgroundTransparency = 0}
			}):Play()
			tw({
				v = Icon_1,
				t = 0.2,
				s = "Linear",
				d = "Out",
				g = {ImageTransparency = 0}
			}):Play()
		end)

		delay(0.2,function()
			if not Env.Tab.Value then
				tw({
					v = AddList_1,
					t = 0.2,
					s = "Linear",
					d = "Out",
					g = {BackgroundTransparency = 0}
				}):Play()
				tw({
					v = Icon_1,
					t = 0.2,
					s = "Linear",
					d = "Out",
					g = {ImageTransparency = 0}
				}):Play()
				Page_1.Visible = true
				Page_1.Size = UDim2.new(0, 0,0, 0)
				tw({
					v = Page_1,
					t = 0.1,
					s = "Linear",
					d = "Out",
					g = {Size = UDim2.new(0.860999942, 1,1, 0)}
				}):Play()
				Env.Tab.Value = true
			end
		end)

		UIListLayout_6:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Right_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_6.AbsoluteContentSize.Y + 20)
		end)

		UIListLayout_4:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			Left_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_4.AbsoluteContentSize.Y + 20)
		end)

		local function GetSide(side)
			if not side then
				return Left_1
			end
			local sideLower = string.lower(tostring(side))
			if sideLower == "r" or sideLower == "right" or side == 2 then
				return Right_1
			elseif sideLower == "l" or sideLower == "left" or side == 1 then
				return Left_1
			else
				return Left_1
			end
		end
		
		Env.Section = {}
		
		function Env.Section:Section(meta)
			
			local Title = meta.Title
			local Side = meta.Side
			
			local Section_1 = Instance.new("Frame")
			local UICorner_3 = Instance.new("UICorner")
			local UIListLayout_5 = Instance.new("UIListLayout")
			local Head_1 = Instance.new("Frame")
			local Title_1 = Instance.new("TextLabel")
			local Line_2 = Instance.new("Frame")

			Section_1.Name = "Section"
			Section_1.Parent = GetSide(Side)
			Section_1.BackgroundColor3 = Color3.fromRGB(0,0,0)
			Section_1.BackgroundTransparency = 0.5
			Section_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Section_1.BorderSizePixel = 0
			Section_1.Size = UDim2.new(0.98, 0,0, 100)

			UICorner_3.Parent = Section_1
			UICorner_3.CornerRadius = UDim.new(0,3)

			UIListLayout_5.Parent = Section_1
			UIListLayout_5.Padding = UDim.new(0,5)
			UIListLayout_5.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout_5.SortOrder = Enum.SortOrder.LayoutOrder

			Head_1.Name = "Head"
			Head_1.Parent = Section_1
			Head_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Head_1.BackgroundTransparency = 1
			Head_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Head_1.BorderSizePixel = 0
			Head_1.Size = UDim2.new(1, 0,0, 30)
			Head_1.LayoutOrder = -5

			Title_1.Name = "Title"
			Title_1.Parent = Head_1
			Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
			Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Title_1.BackgroundTransparency = 1
			Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
			Title_1.BorderSizePixel = 0
			Title_1.Position = UDim2.new(0.5, 0,0.5, 0)
			Title_1.Size = UDim2.new(1, 0,0, 10)
			Title_1.Font = Enum.Font.GothamBold
			Title_1.Text = Title
			Title_1.TextColor3 = Color3.fromRGB(255,255,255)
			Title_1.TextSize = 13

			Line_2.Name = "Line"
			Line_2.Parent = Head_1
			Line_2.AnchorPoint = Vector2.new(0.5, 0.5)
			Line_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
			Line_2.BackgroundTransparency = 0.8999999761581421
			Line_2.BorderColor3 = Color3.fromRGB(0,0,0)
			Line_2.BorderSizePixel = 0
			Line_2.Position = UDim2.new(0.5, 0,1, 0)
			Line_2.Size = UDim2.new(1, 0,0, 1)
			
			UIListLayout_5:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				Section_1.Size = UDim2.new(0.98, 0, 0, UIListLayout_5.AbsoluteContentSize.Y + 10)
			end)
			
			Env.Class = {}
			
			function Env.Class:Line()
				
				local Line_2 = Instance.new("Frame")
				Line_2.Name = "Line"
				Line_2.Parent = Section_1
				Line_2.AnchorPoint = Vector2.new(0.5, 0.5)
				Line_2.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Line_2.BackgroundTransparency = 0.8999999761581421
				Line_2.BorderColor3 = Color3.fromRGB(0,0,0)
				Line_2.BorderSizePixel = 0
				Line_2.Position = UDim2.new(0.5, 0,1, 0)
				Line_2.Size = UDim2.new(1, 0,0, 1)
				
				local i = {}
				
				function i:Visible(a)
					Line_2.Visible = a
				end
				
				return i
			end
			
			function Env.Class:Button(a)
				
				local Title = a.Title
				local Callback = a.Callback

				local Button = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local Title_1 = Instance.new("TextLabel")
				local Click = click(Button)

				Button.Name = "Button"
				Button.Parent = Section_1
				Button.BackgroundColor3 = Color3.fromRGB(120,120,120)
				Button.BorderColor3 = Color3.fromRGB(0,0,0)
				Button.BorderSizePixel = 0
				Button.Size = UDim2.new(0.949999988, 0,0, 25)
				Button.ClipsDescendants = true

				UICorner_1.Parent = Button
				UICorner_1.CornerRadius = UDim.new(0,3)

				Title_1.Name = "Title"
				Title_1.Parent = Button
				Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Position = UDim2.new(0.5, 0,0.5, 0)
				Title_1.Size = UDim2.new(1, 0,0, 10)
				Title_1.Font = Enum.Font.GothamMedium
				Title_1.Text = Title
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 11
				Title_1.TextYAlignment = Enum.TextYAlignment.Top
				
				Click.MouseButton1Click:Connect(function()
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					Callback()
					EffectClick(Click, Button)
				end)
			end
			
			function Env.Class:Toggle(meta)
				
				local Title = meta.Title
				local Value = meta.Value
				local Callback = meta.Callback
				
				local Togglec = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local Title_1 = Instance.new("TextLabel")
				local Novalue_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Color_1 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local UIGradient_1 = Instance.new("UIGradient")
				local Icon_1 = Instance.new("ImageLabel")
				local ClickToggle = click(Togglec)

				Togglec.Name = "Toggle"
				Togglec.Parent = Section_1
				Togglec.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Togglec.BackgroundTransparency = 0.8999999761581421
				Togglec.BorderColor3 = Color3.fromRGB(0,0,0)
				Togglec.BorderSizePixel = 0
				Togglec.Size = UDim2.new(0.949999988, 0,0, 40)
				Togglec.ClipsDescendants = true

				UICorner_1.Parent = Togglec
				UICorner_1.CornerRadius = UDim.new(0,3)

				Title_1.Name = "Title"
				Title_1.Parent = Togglec
				Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Position = UDim2.new(0.402818292, 0,0.5, 0)
				Title_1.Size = UDim2.new(0.703340054, 0,0, 10)
				Title_1.Font = Enum.Font.GothamMedium
				Title_1.Text = Title
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 11
				Title_1.TextXAlignment = Enum.TextXAlignment.Left

				Novalue_1.Name = "Novalue"
				Novalue_1.Parent = Togglec
				Novalue_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Novalue_1.BackgroundColor3 = Color3.fromRGB(65,65,65)
				Novalue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Novalue_1.BorderSizePixel = 0
				Novalue_1.Position = UDim2.new(0.899999976, 0,0.5, 0)
				Novalue_1.Size = UDim2.new(0, 22,0, 22)

				UICorner_2.Parent = Novalue_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				Color_1.Name = "Color"
				Color_1.Parent = Novalue_1
				Color_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Color_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Color_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Color_1.BorderSizePixel = 0
				Color_1.BackgroundTransparency = 1
				Color_1.Position = UDim2.new(0.5, 0,0.5, 0)
				Color_1.Size = UDim2.new(1, 0,1, 0)

				UICorner_3.Parent = Color_1
				UICorner_3.CornerRadius = UDim.new(1,0)

				UIGradient_1.Parent = Color_1
				UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 113, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(66, 156, 255))}
				UIGradient_1.Rotation = -159

				Icon_1.Name = "Icon"
				Icon_1.Parent = Color_1
				Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Icon_1.BackgroundTransparency = 1
				Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Icon_1.BorderSizePixel = 0
				Icon_1.Position = UDim2.new(0.5, 0,0.5, 0)
				Icon_1.Size = UDim2.new(0, 0,0, 0)
				Icon_1.Image = "rbxassetid://99035215947422"
				
				local function Togglex(Value)
					if not Value then 
						Callback(Value)
						tw({
							v = Color_1,
							t = 0.5,
							s = "Back",
							d = "Out",
							g = {BackgroundTransparency = 1}
						}):Play()
						tw({
							v = Icon_1,
							t = 0.2,
							s = "Back",
							d = "Out",
							g = {Size = UDim2.new(0, 0,0, 0)}
						}):Play()
					elseif Value then 
						Callback(Value)
						tw({
							v = Color_1,
							t = 0.5,
							s = "Back",
							d = "Out",
							g = {BackgroundTransparency = 0}
						}):Play()
						tw({
							v = Icon_1,
							t = 0.1,
							s = "Bounce",
							d = "Out",
							g = {Size = UDim2.new(0.8, 0,0.8, 0)}
						}):Play()
						delay(0.05, function()
							tw({
								v = Icon_1,
								t = 0.2,
								s = "Bounce",
								d = "Out",
								g = {Size = UDim2.new(0.5, 0,0.5, 0)}
							}):Play()
						end)
					end
				end

				ClickToggle.MouseButton1Click:Connect(function()
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					EffectClick(ClickToggle, Togglec)
					Value = not Value
					Togglex(Value)
				end)

				Togglex(Value)

				local i = {}

				function i:Value(v)
					Value = v
					Togglex(Value)
				end

				function i:Visible(v)
					Togglec.Visible = v
				end

				return i
			end
			
			function Env.Class:Dropdown(info)
				local Title = info.Title
				local List = info.List or {}
				local Value = info.Value
				local Multi = info.Multi or false
				local Callback = info.Callback
				

				local Dropdownz = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local Title_1 = Instance.new("TextLabel")
				local Icon_1 = Instance.new("ImageLabel")
				local Desc_1 = Instance.new("TextLabel")
				local ClickDropdown = click(Dropdownz)
				
				Dropdownz.Name = "Dropdown"
				Dropdownz.Parent = Section_1
				Dropdownz.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Dropdownz.BackgroundTransparency = 0.8999999761581421
				Dropdownz.BorderColor3 = Color3.fromRGB(0,0,0)
				Dropdownz.BorderSizePixel = 0
				Dropdownz.Size = UDim2.new(0.949999988, 0,0, 40)
				Dropdownz.ClipsDescendants = true

				UICorner_1.Parent = Dropdownz
				UICorner_1.CornerRadius = UDim.new(0,3)

				Title_1.Name = "Title"
				Title_1.Parent = Dropdownz
				Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Position = UDim2.new(0.402999997, 0,0.349999994, 0)
				Title_1.Size = UDim2.new(0.703340054, 0,0, 10)
				Title_1.Font = Enum.Font.GothamMedium
				Title_1.Text = Title
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 11
				Title_1.TextXAlignment = Enum.TextXAlignment.Left

				Icon_1.Name = "Icon"
				Icon_1.Parent = Dropdownz
				Icon_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Icon_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Icon_1.BackgroundTransparency = 1
				Icon_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Icon_1.BorderSizePixel = 0
				Icon_1.Position = UDim2.new(0.899999976, 0,0.5, 0)
				Icon_1.Size = UDim2.new(0, 20,0, 20)
				Icon_1.Image = "rbxassetid://129573215183311"

				Desc_1.Name = "Desc"
				Desc_1.Parent = Dropdownz
				Desc_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Desc_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Desc_1.BackgroundTransparency = 1
				Desc_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Desc_1.BorderSizePixel = 0
				Desc_1.Position = UDim2.new(0.402999997, 0,0.649999976, 0)
				Desc_1.Size = UDim2.new(0.703340054, 0,0, 10)
				Desc_1.Font = Enum.Font.GothamMedium
				if type(Value) == "table" then
					Desc_1.Text = "( . . . . . . )"
				else
					Desc_1.Text = Value
				end
				Desc_1.TextColor3 = Color3.fromRGB(255,255,255)
				Desc_1.TextSize = 10
				Desc_1.TextTransparency = 0.5
				Desc_1.TextXAlignment = Enum.TextXAlignment.Left
				
				local function Update()
					if type(Value) == "table" then
						Desc_1.Text = "( . . . . . . )"
					else
						Desc_1.Text = Value
					end
				end
				
				local Dropdown = Instance.new("Frame")
				local Search_1 = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local TextBox_1 = Instance.new("TextBox")
				local UIStroke_1 = Instance.new("UIStroke")
				local ScrollingFrame_1 = Instance.new("ScrollingFrame")
				local UIListLayout_1 = Instance.new("UIListLayout")
				local UICorner_3 = Instance.new("UICorner")
				local UIStroke_2 = Instance.new("UIStroke")
				
				Dropdown.Name = "Dropdown"
				Dropdown.Parent = Background_1
				Dropdown.AnchorPoint = Vector2.new(1, 0.5)
				Dropdown.BackgroundColor3 = Color3.fromRGB(15,15,15)
				Dropdown.BorderColor3 = Color3.fromRGB(0,0,0)
				Dropdown.BorderSizePixel = 0
				Dropdown.Position = UDim2.new(1, 0,0.500443041, 0)
				Dropdown.Size = UDim2.new(0, 222,0, 374)
				Dropdown.ZIndex = 3
				Dropdown.Visible = false
				
				UICorner_3.Parent = Dropdown

				UIStroke_2.Parent = Dropdown
				UIStroke_2.Color = Color3.fromRGB(25,25,25)
				UIStroke_2.Thickness = 1
				

				Search_1.Name = "Search"
				Search_1.Parent = Dropdown
				Search_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Search_1.BackgroundColor3 = Color3.fromRGB(45,45,45)
				Search_1.BackgroundTransparency = 0.5
				Search_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Search_1.BorderSizePixel = 0
				Search_1.Position = UDim2.new(0.5, 0,0.0787144601, 0)
				Search_1.Size = UDim2.new(0.919999957, 0,-0.00925319083, 25)
				Search_1.ZIndex = 3

				UICorner_1.Parent = Search_1
				UICorner_1.CornerRadius = UDim.new(1,0)

				TextBox_1.Parent = Search_1
				TextBox_1.Active = true
				TextBox_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.CursorPosition = -1
				TextBox_1.Position = UDim2.new(0.5, 0,0.5, 0)
				TextBox_1.Size = UDim2.new(1, 0,1, 0)
				TextBox_1.ZIndex = 3
				TextBox_1.Font = Enum.Font.GothamMedium
				TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.PlaceholderText = "Search"
				TextBox_1.Text = ""
				TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.TextSize = 14

				UIStroke_1.Parent = Search_1
				UIStroke_1.Color = Color3.fromRGB(255,255,255)
				UIStroke_1.Thickness = 1
				UIStroke_1.Transparency = 0.8

				ScrollingFrame_1.Name = "ScrollingFrame"
				ScrollingFrame_1.Parent = Dropdown
				ScrollingFrame_1.Active = true
				ScrollingFrame_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				ScrollingFrame_1.BackgroundTransparency = 1
				ScrollingFrame_1.BorderColor3 = Color3.fromRGB(0,0,0)
				ScrollingFrame_1.BorderSizePixel = 0
				ScrollingFrame_1.Position = UDim2.new(0.0499996133, 0,0.127563804, 0)
				ScrollingFrame_1.Size = UDim2.new(0.899999917, 0,0.832358301, 0)
				ScrollingFrame_1.ZIndex = 3
				ScrollingFrame_1.ClipsDescendants = true
				ScrollingFrame_1.AutomaticCanvasSize = Enum.AutomaticSize.None
				ScrollingFrame_1.BottomImage = "rbxasset://textures/ui/Scroll/scroll-bottom.png"
				ScrollingFrame_1.CanvasPosition = Vector2.new(0, 0)
				ScrollingFrame_1.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
				ScrollingFrame_1.HorizontalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.MidImage = "rbxasset://textures/ui/Scroll/scroll-middle.png"
				ScrollingFrame_1.ScrollBarImageColor3 = Color3.fromRGB(0,0,0)
				ScrollingFrame_1.ScrollBarImageTransparency = 1
				ScrollingFrame_1.ScrollBarThickness = 0
				ScrollingFrame_1.ScrollingDirection = Enum.ScrollingDirection.XY
				ScrollingFrame_1.TopImage = "rbxasset://textures/ui/Scroll/scroll-top.png"
				ScrollingFrame_1.VerticalScrollBarInset = Enum.ScrollBarInset.None
				ScrollingFrame_1.VerticalScrollBarPosition = Enum.VerticalScrollBarPosition.Right

				UIListLayout_1.Parent = ScrollingFrame_1
				UIListLayout_1.Padding = UDim.new(0,5)
				UIListLayout_1.SortOrder = Enum.SortOrder.LayoutOrder
				
				local isOpen = false
				UserInputService.InputBegan:Connect(function(A)
					if A.UserInputType == Enum.UserInputType.MouseButton1 or A.UserInputType == Enum.UserInputType.Touch then
						local mouse = game:GetService("Players").LocalPlayer:GetMouse()
						local mx, my = mouse.X, mouse.Y

						local DBP, DBS = Dropdown.AbsolutePosition, Dropdown.AbsoluteSize
						local TBP, TBS = TextBox_1.AbsolutePosition, TextBox_1.AbsoluteSize
						local SBP, SBS = Search_1.AbsolutePosition, Search_1.AbsoluteSize

						local function inside(pos, size)
							return mx >= pos.X and mx <= pos.X + size.X and my >= pos.Y and my <= pos.Y + size.Y
						end

						if not inside(DBP, DBS)
							and not inside(TBP, TBS)
							and not inside(SBP, SBS) then
							isOpen = false
							Dropdown.Size = UDim2.new(0, 0, 0, 374)
							Dropdown.Visible = false
						end
					end
				end)

				ClickDropdown.MouseButton1Click:Connect(function()
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					isOpen = not isOpen
					if isOpen then
						Dropdown.Visible = true
						
						tw({
							v = Dropdown,
							t = 0.3,
							s = "Back",
							d = "Out",
							g = {Size = UDim2.new(0, 222,0, 374)}
						}):Play()
					else
						tw({
							v = Dropdown,
							t = 0.3,
							s = "Bounce",
							d = "Out",
							g = {Size = UDim2.new(0, 0,0, 374)}
						}):Play()
						Dropdown.Visible = false
					end
					EffectClick(ClickDropdown, Dropdownz)
					tw({
						v = Icon_1,
						t = 0.15,
						s = "Bounce",
						d = "Out",
						g = {Size = UDim2.new(0, 40,0, 40)}
					}):Play()
					delay(0.06, function()
						tw({
							v = Icon_1,
							t = 0.15,
							s = "Bounce",
							d = "Out",
							g = {Size = UDim2.new(0, 20,0, 20)}
						}):Play()
					end)
				end)

				TextBox_1.Changed:Connect(function()
					local SearchT = string.lower(TextBox_1.Text)
					for i, v in pairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") then
							local labelText = string.lower(v.Real.Title.Text)
							if string.find(labelText, SearchT, 1, true) then
								v.Visible = true
							else
								v.Visible = false
							end
						end
					end
				end)
				
				local itemslist = {}
				local selectedItem

				function itemslist:Clear(a)
					local function shouldClear(v)
						if a == nil then
							return true
						elseif type(a) == "string" then
							return v.Real:FindFirstChild("Title") and v.Real.Title.Text == a
						elseif type(a) == "table" then
							for _, name in ipairs(a) do
								if v.Real:FindFirstChild("Title") and v.Real.Title.Text == name then
									return true
								end
							end
						end
						return false
					end

					for _, v in ipairs(ScrollingFrame_1:GetChildren()) do
						if v:IsA("Frame") and shouldClear(v) then
							if selectedItem and v.Real:FindFirstChild("Title") and v.Real.Title.Text == selectedItem then
								selectedItem = nil
								Desc_1.Text = ""
							end
							v:Destroy()
						end
					end

					if selectedItem == a or Desc_1.Text == a then
						selectedItem = nil
						Desc_1.Text = ""
					end

					if a == nil then
						selectedItem = nil
						Desc_1.Text = ""
					end
				end

				local selectedValues = {}

				local function isValueInTable(val, tbl)
					if type(tbl) ~= "table" then
						return false
					end

					for _, v in pairs(tbl) do
						if v == val then
							return true
						end
					end
					return false
				end
				
				function itemslist:AddList(text)
					local Items_1 = Instance.new("Frame")
					local ClickList = click(Items_1)
					local Real_1 = Instance.new("Frame")
					local Title_1 = Instance.new("TextLabel")
					local Line_1 = Instance.new("Frame")
					local UICorner_2 = Instance.new("UICorner")
					local UIListLayout_2 = Instance.new("UIListLayout")

					Items_1.Name = "Items"
					Items_1.Parent = ScrollingFrame_1
					Items_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Items_1.BackgroundTransparency = 1
					Items_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Items_1.BorderSizePixel = 0
					Items_1.Size = UDim2.new(1, 0,0, 30)
					Items_1.ZIndex = 3

					Real_1.Name = "Real"
					Real_1.Parent = Items_1
					Real_1.AnchorPoint = Vector2.new(0.5, 0.5)
					Real_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Real_1.BackgroundTransparency = 1
					Real_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Real_1.BorderSizePixel = 0
					Real_1.Position = UDim2.new(0.5, 0,0.5, 0)
					Real_1.Size = UDim2.new(1, 0,1, 0)
					Real_1.ZIndex = 3

					Title_1.Name = "Title"
					Title_1.Parent = Real_1
					Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
					Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
					Title_1.BackgroundTransparency = 1
					Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Title_1.BorderSizePixel = 0
					Title_1.LayoutOrder = -1
					Title_1.Position = UDim2.new(0.57476455, 0,0.5, 0)
					Title_1.Size = UDim2.new(0.660639942, 0,1, 0)
					Title_1.ZIndex = 3
					Title_1.Font = Enum.Font.GothamMedium
					Title_1.Text = text
					Title_1.TextColor3 = Color3.fromRGB(255,255,255)
					Title_1.TextSize = 14
					Title_1.TextXAlignment = Enum.TextXAlignment.Left
					Title_1.TextTransparency = 0.5

					Line_1.Name = "Line"
					Line_1.Parent = Real_1
					Line_1.AnchorPoint = Vector2.new(0, 0.5)
					Line_1.BackgroundColor3 = Color3.fromRGB(0,170,255)
					Line_1.BorderColor3 = Color3.fromRGB(0,0,0)
					Line_1.BorderSizePixel = 0
					Line_1.LayoutOrder = -3
					Line_1.Position = UDim2.new(0, 0,0.5, 0)
					Line_1.Size = UDim2.new(0, 5,1, 0)
					Line_1.ZIndex = 3
					Line_1.BackgroundTransparency = 1

					UICorner_2.Parent = Line_1
					UICorner_2.CornerRadius = UDim.new(1,0)

					UIListLayout_2.Parent = Real_1
					UIListLayout_2.Padding = UDim.new(0,10)
					UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
					UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
					UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

					ClickList.MouseButton1Click:Connect(function()
						Update()
						if Multi then
							if selectedValues[text] then
								selectedValues[text] = nil
								tw({
									v = Title_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {TextTransparency = 0.5}
								}):Play()
								tw({
									v = Line_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 1}
								}):Play()
								tw({
									v = Items_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 1}
								}):Play()
							else
								selectedValues[text] = true
								tw({
									v = Title_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {TextTransparency = 0}
								}):Play()
								tw({
									v = Line_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0}
								}):Play()
								tw({
									v = Items_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0.85}
								}):Play()
							end
							local selectedList = {}
							for i, v in pairs(selectedValues) do
								table.insert(selectedList, i)
							end
							if #selectedList > 0 then
								Update()
							else
								Desc_1.Text = ""
							end
							pcall(Callback, selectedList)
						else
							for i,v in pairs(ScrollingFrame_1:GetChildren()) do
								if v:IsA("Frame") then
									tw({
										v = v.Real.Title,
										t = 0.15,
										s = "Exponential",
										d = "Out",
										g = {TextTransparency = 0.5}
									}):Play()
									tw({
										v = v.Real.Line,
										t = 0.15,
										s = "Exponential",
										d = "Out",
										g = {BackgroundTransparency = 1}
									}):Play()
									tw({
										v = v,
										t = 0.15,
										s = "Exponential",
										d = "Out",
										g = {BackgroundTransparency = 1}
									}):Play()
								end
							end

							tw({
								v = Title_1,
								t = 0.15,
								s = "Exponential",
								d = "Out",
								g = {TextTransparency = 0}
							}):Play()
							tw({
								v = Line_1,
								t = 0.15,
								s = "Exponential",
								d = "Out",
								g = {BackgroundTransparency = 0}
							}):Play()
							tw({
								v = Items_1,
								t = 0.15,
								s = "Exponential",
								d = "Out",
								g = {BackgroundTransparency = 0.85}
							}):Play()
							tw({
								v = Dropdown,
								t = 0.3,
								s = "Bounce",
								d = "Out",
								g = {Size = UDim2.new(0, 0,0, 374)}
							}):Play()
							isOpen = false
							Value = text
							Desc_1.Text = text
							pcall(function()
								Callback(Desc_1.Text)
							end)
							task.wait(0.05)
							Dropdown.Visible = false
						end
					end)

					delay(0,function()
						if Multi then
							if isValueInTable(text, Value) then
								tw({
									v = Title_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {TextTransparency = 0}
								}):Play()
								tw({
									v = Line_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0}
								}):Play()
								tw({
									v = Items_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0.85}
								}):Play()
								selectedValues[text] = true
								local selectedList = {}
								for i, v in pairs(selectedValues) do
									table.insert(selectedList, i)
								end
								if #selectedList > 0 then
									Update()
								else
									Desc_1.Text = ""
								end
								pcall(Callback, selectedList)
							end
						else
							if text == Value then
								tw({
									v = Title_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {TextTransparency = 0}
								}):Play()
								tw({
									v = Line_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0}
								}):Play()
								tw({
									v = Items_1,
									t = 0.15,
									s = "Exponential",
									d = "Out",
									g = {BackgroundTransparency = 0.85}
								}):Play()
								Value = text
								Desc_1.Text = text
								Callback(Desc_1.Text)
							end
						end
					end)

				end
				
				for _, name in ipairs(List) do
					itemslist:AddList(name)
				end

				UIListLayout_1:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					ScrollingFrame_1.CanvasSize = UDim2.new(0, 0, 0, UIListLayout_1.AbsoluteContentSize.Y + 5)
				end)

				return itemslist
				
			end
			
			function Env.Class:Slider(info)
				local Title = info.Title
				local Min = info.Min or 0
				local Max = info.Max or 100
				local Rounding = info.Rounding or 0
				local Value = info.Value or Min
				local Callback = info.CallBack or function() end

				local Slider = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local Title_1 = Instance.new("TextLabel")
				local Novalue_1 = Instance.new("Frame")
				local UICorner_2 = Instance.new("UICorner")
				local Color_1 = Instance.new("Frame")
				local UICorner_3 = Instance.new("UICorner")
				local UIGradient_1 = Instance.new("UIGradient")
				local textvalue_1 = Instance.new("TextBox")
				local Slide = click(Slider)

				Slider.Name = "Slider"
				Slider.Parent = Section_1
				Slider.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Slider.BackgroundTransparency = 0.8999999761581421
				Slider.BorderColor3 = Color3.fromRGB(0,0,0)
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(0.949999988, 0,0, 50)

				UICorner_1.Parent = Slider
				UICorner_1.CornerRadius = UDim.new(0,3)

				Title_1.Name = "Title"
				Title_1.Parent = Slider
				Title_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Title_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Title_1.BackgroundTransparency = 1
				Title_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Title_1.BorderSizePixel = 0
				Title_1.Position = UDim2.new(0.402999997, 0,0.300000012, 0)
				Title_1.Size = UDim2.new(0.703340054, 0,0, 10)
				Title_1.Font = Enum.Font.GothamMedium
				Title_1.Text = Title
				Title_1.TextColor3 = Color3.fromRGB(255,255,255)
				Title_1.TextSize = 12
				Title_1.TextXAlignment = Enum.TextXAlignment.Left

				Novalue_1.Name = "Novalue"
				Novalue_1.Parent = Slider
				Novalue_1.AnchorPoint = Vector2.new(0.5, 0.5)
				Novalue_1.BackgroundColor3 = Color3.fromRGB(12,12,12)
				Novalue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Novalue_1.BorderSizePixel = 0
				Novalue_1.Position = UDim2.new(0.5, 0,0.699999988, 0)
				Novalue_1.Size = UDim2.new(0.920000017, 0,0, 15)
				Novalue_1.ClipsDescendants = true

				UICorner_2.Parent = Novalue_1
				UICorner_2.CornerRadius = UDim.new(1,0)

				Color_1.Name = "Color"
				Color_1.Parent = Novalue_1
				Color_1.AnchorPoint = Vector2.new(0, 0.5)
				Color_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Color_1.BorderColor3 = Color3.fromRGB(0,0,0)
				Color_1.BorderSizePixel = 0
				Color_1.Position = UDim2.new(0, 0,0.5, 0)
				Color_1.Size = UDim2.new(1, 0,1, 0)

				UICorner_3.Parent = Color_1
				UICorner_3.CornerRadius = UDim.new(1,0)

				UIGradient_1.Parent = Color_1
				UIGradient_1.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(82, 113, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(66, 156, 255))}

				textvalue_1.Name = "textvalue"
				textvalue_1.Parent = Slider
				textvalue_1.Active = true
				textvalue_1.AnchorPoint = Vector2.new(0.5, 0.5)
				textvalue_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				textvalue_1.BackgroundTransparency = 1
				textvalue_1.BorderColor3 = Color3.fromRGB(0,0,0)
				textvalue_1.BorderSizePixel = 0
				textvalue_1.CursorPosition = -1
				textvalue_1.Position = UDim2.new(0.730000019, 0,0.316249996, 0)
				textvalue_1.Size = UDim2.new(0, 81,0, 11)
				textvalue_1.Font = Enum.Font.GothamMedium
				textvalue_1.PlaceholderColor3 = Color3.fromRGB(255,255,255)
				textvalue_1.PlaceholderText = "..."
				textvalue_1.Text = tostring(Value)
				textvalue_1.TextColor3 = Color3.fromRGB(255,255,255)
				textvalue_1.TextSize = 10
				textvalue_1.TextXAlignment = Enum.TextXAlignment.Right
				
				local function roundToDecimal(value, decimals)
					local factor = 10 ^ decimals
					return math.floor(value * factor + 0.5) / factor
				end

				local function updateSlider(value)
					value = math.clamp(value, Min, Max)
					value = roundToDecimal(value, Rounding)
					tw({
						v = Color_1,
						t = 0.15,
						s = "Exponential",
						d = "Out",
						g = {Size = UDim2.new((value - Min) / (Max - Min), 0, 1, 0)}
					}):Play()
					local startValue = tonumber(textvalue_1.Text) or 0
					local targetValue = value

					local steps = 5
					local currentValue = startValue
					for i = 1, steps do
						task.wait(0.01 / steps)
						currentValue = currentValue + (targetValue - startValue) / steps
						textvalue_1.Text = tostring(roundToDecimal(currentValue, Rounding))
					end

					textvalue_1.Text = tostring(roundToDecimal(targetValue, Rounding))

					Callback(value)
				end

				updateSlider(Value or 0)

				local function move(input)
					local sliderBar = Novalue_1
					local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
					local value = relativeX * (Max - Min) + Min
					updateSlider(value)
				end
				
				textvalue_1.FocusLost:Connect(function()
					local value = tonumber(textvalue_1.Text) or Min
					updateSlider(value)
				end)

				local dragging = false

				Slide.InputBegan:Connect(function(input)
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
						move(input)
					end
				end)

				Slide.InputEnded:Connect(function(input)
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					for _, v in pairs(Background_1:GetChildren()) do
						if v.Name == "Dropdown" and v.Visible then
							return
						end
					end
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						move(input)
					end
				end)

				local NewValue = {}

				function NewValue:Value(a)
					Value = a
					updateSlider(Value)
				end

				function NewValue:Visible(a)
					Slider.Visible = a
				end

				function NewValue:Title(b)
					Title_1.Text = b
				end

				return NewValue
			end
			
			function Env.Class:Textbox(meta)
				
				local Value = meta.Value or "Example"
				local ClearOnFocus = meta.ClearOnFocus or false
				local Callback = meta.Callback
				
				local Textbox = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local TextBox_1 = Instance.new("TextBox")

				Textbox.Name = "Textbox"
				Textbox.Parent = Section_1
				Textbox.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Textbox.BackgroundTransparency = 0.8999999761581421
				Textbox.BorderColor3 = Color3.fromRGB(0,0,0)
				Textbox.BorderSizePixel = 0
				Textbox.Size = UDim2.new(0.949999988, 0,0, 25)

				UICorner_1.Parent = Textbox
				UICorner_1.CornerRadius = UDim.new(0,3)

				TextBox_1.Parent = Textbox
				TextBox_1.Active = true
				TextBox_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextBox_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.BackgroundTransparency = 1
				TextBox_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextBox_1.BorderSizePixel = 0
				TextBox_1.Position = UDim2.new(0.5, 0,0.5, 0)
				TextBox_1.Size = UDim2.new(1, 0,1, 0)
				TextBox_1.Font = Enum.Font.GothamMedium
				TextBox_1.PlaceholderColor3 = Color3.fromRGB(178,178,178)
				TextBox_1.PlaceholderText = "..."
				TextBox_1.Text = tostring(Value)
				TextBox_1.TextColor3 = Color3.fromRGB(255,255,255)
				TextBox_1.TextSize = 11
				TextBox_1.ClearTextOnFocus = ClearOnFocus
				
				TextBox_1.FocusLost:Connect(function()
					if #TextBox_1.Text > 0 then
						pcall(Callback, TextBox_1.Text)
					end
				end)

				local Index = {}

				function Index:Value(v)
					Value = v
					Title_1.Text = v
				end

				function Index:Visible(v)
					Textbox.Visible = v
				end

				return Index
			end
			
			function Env.Class:Label(text)
				local Label = Instance.new("Frame")
				local UICorner_1 = Instance.new("UICorner")
				local TextLabel_1 = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.Parent = Section_1
				Label.BackgroundColor3 = Color3.fromRGB(255,255,255)
				Label.BackgroundTransparency = 1
				Label.BorderColor3 = Color3.fromRGB(0,0,0)
				Label.BorderSizePixel = 0
				Label.Size = UDim2.new(0.949999988, 0,0, 15)

				UICorner_1.Parent = Label
				UICorner_1.CornerRadius = UDim.new(0,3)

				TextLabel_1.Parent = Label
				TextLabel_1.AnchorPoint = Vector2.new(0.5, 0.5)
				TextLabel_1.BackgroundColor3 = Color3.fromRGB(255,255,255)
				TextLabel_1.BackgroundTransparency = 1
				TextLabel_1.BorderColor3 = Color3.fromRGB(0,0,0)
				TextLabel_1.BorderSizePixel = 0
				TextLabel_1.Position = UDim2.new(0.5, 0,0.5, 0)
				TextLabel_1.Size = UDim2.new(1, 0,1, 0)
				TextLabel_1.Font = Enum.Font.GothamMedium
				TextLabel_1.RichText = true
				TextLabel_1.Text = tostring(text)
				TextLabel_1.TextColor3 = Color3.fromRGB(255,255,255)
				TextLabel_1.TextSize = 12
				TextLabel_1.TextWrapped = true
				Label.Size = UDim2.new(0.949999988, 0, 0, Title_1.TextBounds.Y + 5)
				
				local i = {}
				
				function i:Title(a)
					Title_1.Text = a
					Label.Size = UDim2.new(0.949999988, 0, 0, Title_1.TextBounds.Y + 5)
				end

				function i:Visible(a)
					Label.Visible = a
				end

				return i
			end
			
			return Env.Class
		end
		
		return Env.Section
		
	end
	
	return Env.Tab
end
