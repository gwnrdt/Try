local a={}
local b={}
if game.CoreGui and game.CoreGui:FindFirstChild"NightUI"then
game.CoreGui.NightUI:Destroy()
end
function a.Log(c,...)
print("LOG:",...)
end
function a.AutoUpdateScrolling(c,d,e)
d:GetPropertyChangedSignal"AbsoluteContentSize":Connect(function()
e.CanvasSize=UDim2.new(0,0,0,d.AbsoluteContentSize.Y+20)
end)
end
function a.CheckAndRemoveOldUI(c)
if game.CoreGui:FindFirstChild"NightUI"then
game.CoreGui.NightUI:Destroy()
end
end
a:CheckAndRemoveOldUI()
function a.MakeConfig(c,d,e)
for f,g in next,d do
if not e[f]then
e[f]=g
end
end
return e
end
function a.SafeCallback(c,d)
local e,f=pcall(d)
if not e then
print"Safe Callback"
c:Log(f)
end
end
function a.AutoUpdateContent(c,d)
local e,f,g=d[1],d[2],d[3]
if#d>3 then warn"Max Is 3"return end
e.Size=UDim2.new(1,0,0,45)
f.Position=UDim2.new(0,42,0,0)
f.Size=UDim2.new(1,-100,1,0)
if g and g.Text~=""then
f.Position=UDim2.new(0,42,0,14)
f.Size=UDim2.new(1,-100,0,8)
local h=math.max(g.TextBounds.Y+18,55)
e.Size=UDim2.new(1,0,0,h)
end
end
function a.TweenObject(c,d,e,f,g,h)
local i=game:GetService'TweenService':Create(d,TweenInfo.new(e,Enum.EasingStyle[f or"Quad"]),{[g]=h})
i:Play()
return i
end
function a.MixFunction(c,d,e)
local function MakeDraggable(f,g)
local h=false
local i
local j
local k
g.InputBegan:Connect(function(l)
if l.UserInputType==Enum.UserInputType.MouseButton1 or l.UserInputType==Enum.UserInputType.Touch then
h=true
j=l.Position
k=f.Position

l.Changed:Connect(function()
if l.UserInputState==Enum.UserInputState.End then
h=false
end
end)
end
end)
g.InputChanged:Connect(function(l)
if l.UserInputType==Enum.UserInputType.MouseMovement or l.UserInputType==Enum.UserInputType.Touch then
i=l
end
end)
game:GetService"UserInputService".InputChanged:Connect(function(l)
if l==i and h then
local m=l.Position-j
local n=UDim2.new(
k.X.Scale,
k.X.Offset+m.X,
k.Y.Scale,
k.Y.Offset+m.Y
)
c:TweenObject(f,0.1,"Quad","Position",n)
end
end)
end
MakeDraggable(d,e)
end
function b.Notify(c,d)
d=a:MakeConfig({
Title="Notification",
Content="",
Duration=5
},d or{})
spawn(function()
if not game.CoreGui:FindFirstChild"NightUI_Notify"then
local e=Instance.new"ScreenGui"
e.Name="NightUI_Notify"
e.Parent=game.CoreGui
e.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
end
if not game.CoreGui:WaitForChild"NightUI_Notify":FindFirstChild"NotifyLayout"then
local e=Instance.new"Frame"
e.Name="NotifyLayout"
e.Parent=game.CoreGui:WaitForChild"NightUI_Notify"
e.AnchorPoint=Vector2.new(1,1)
e.Position=UDim2.new(1,-30,1,-30)
e.Size=UDim2.new(0,230,0,700)
e.BackgroundColor3=Color3.new(1,1,1)
e.BackgroundTransparency=1
e.BorderColor3=Color3.new(0,0,0)
e.BorderSizePixel=0
local f=0
e.ChildRemoved:Connect(function()
f=0
for g,h in pairs(game.CoreGui.NightUI_Notify.NotifyLayout:GetChildren())do
a:TweenObject(h,0.5,"Quad","Position",UDim2.new(0,0,1,-((h.Size.Y.Offset+15)*f)))
f=f+1
end
end)
end
local e
for f,g in next,game.CoreGui.NightUI_Notify.NotifyLayout:GetChildren()do
e=-(g.Position.Y.Offset)+g.Size.Y.Offset+15
end
local f=Instance.new"Frame"
local g=Instance.new"Frame"
local h=Instance.new"UICorner"
local i=Instance.new"UIStroke"
local j=Instance.new"Frame"
local k=Instance.new"ImageLabel"
local l=Instance.new"TextButton"
local m=Instance.new"ImageLabel"
local n=Instance.new"TextLabel"
local o=Instance.new"TextLabel"
local p=Instance.new"ImageLabel"
f.Name="NotifyFrame"
f.Parent=game.CoreGui.NightUI_Notify.NotifyLayout
f.BackgroundColor3=Color3.new(1,1,1)
f.BackgroundTransparency=1
f.BorderColor3=Color3.new(0,0,0)
f.BorderSizePixel=0
f.Position=UDim2.new(0,0,1,-(e))
f.Size=UDim2.new(1,0,0,70)

g.Name="RealNotify"
g.Parent=f
g.BackgroundColor3=Color3.new(0.0627451,0.0627451,0.0627451)
g.BackgroundTransparency=0.019999999552965164
g.BorderColor3=Color3.new(0,0,0)
g.BorderSizePixel=0
g.Position=UDim2.new(0,300,0,0)
g.Size=UDim2.new(1,0,1,0)

h.Parent=g

i.Parent=g
i.Color=Color3.new(1,1,1)
i.Transparency=0.8999999761581421

j.Name="LogoFrame"
j.Parent=g
j.BackgroundColor3=Color3.new(1,1,1)
j.BackgroundTransparency=1
j.BorderColor3=Color3.new(0,0,0)
j.BorderSizePixel=0
j.Position=UDim2.new(0,10,0,10)
j.Size=UDim2.new(0,20,0,20)

k.Name="LogoNotification"
k.Parent=j
k.AnchorPoint=Vector2.new(0.5,0.5)
k.BackgroundColor3=Color3.new(1,1,1)
k.BackgroundTransparency=1
k.BorderColor3=Color3.new(0,0,0)
k.BorderSizePixel=0
k.Position=UDim2.new(0.5,0,0.5,0)
k.Size=UDim2.new(1,5,1,5)
k.Image="rbxassetid://117874257607161"

l.Name="Click"
l.Parent=g
l.BackgroundColor3=Color3.new(1,1,1)
l.BackgroundTransparency=1
l.BorderColor3=Color3.new(0,0,0)
l.BorderSizePixel=0
l.Position=UDim2.new(1,-25,0,5)
l.Size=UDim2.new(0,20,0,20)
l.Font=Enum.Font.SourceSans
l.Text=""
l.TextColor3=Color3.new(0,0,0)
l.TextSize=14

m.Name="MaxSize_Icon"
m.Parent=l
m.AnchorPoint=Vector2.new(0.5,0.5)
m.BackgroundColor3=Color3.new(1,1,1)
m.BackgroundTransparency=1
m.BorderColor3=Color3.new(0,0,0)
m.BorderSizePixel=0
m.Position=UDim2.new(0.5,0,0.5,0)
m.Size=UDim2.new(1,-5,1,-5)
m.Image="rbxassetid://105957381820378"
m.ImageRectOffset=Vector2.new(480,0)
m.ImageRectSize=Vector2.new(96,96)

n.Name="Title"
n.Parent=g
n.BackgroundColor3=Color3.new(1,1,1)
n.BackgroundTransparency=1
n.BorderColor3=Color3.new(0,0,0)
n.BorderSizePixel=0
n.Position=UDim2.new(0,34,0,12)
n.Size=UDim2.new(1,-80,0,14)
n.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
n.Text=d.Title
n.TextColor3=Color3.new(1,1,1)
n.TextSize=13
n.TextXAlignment=Enum.TextXAlignment.Left

o.Name="Title"
o.Parent=g
o.BackgroundColor3=Color3.new(1,1,1)
o.BackgroundTransparency=1
o.BorderColor3=Color3.new(0,0,0)
o.BorderSizePixel=0
o.Position=UDim2.new(0,15,0,30)
o.Size=UDim2.new(1,-40,1,-35)
o.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
o.Text=d.Content
o.TextColor3=Color3.new(0.521569,0.521569,0.521569)
o.TextSize=12
o.TextXAlignment=Enum.TextXAlignment.Left
o.TextYAlignment=Enum.TextYAlignment.Top
o.TextWrapped=true

p.Name="Blur"
p.Parent=g
p.AnchorPoint=Vector2.new(0.5,0.5)
p.BackgroundColor3=Color3.new(1,1,1)
p.BackgroundTransparency=1
p.BorderColor3=Color3.new(0,0,0)
p.BorderSizePixel=0
p.Position=UDim2.new(0.5,0,0.528888881,0)
p.Size=UDim2.new(1,120,1,120)
p.ZIndex=-1
p.Image="rbxassetid://8992230677"
p.ImageColor3=Color3.new(0,0,0)
p.ImageTransparency=0.30000001192092896
p.ScaleType=Enum.ScaleType.Slice
p.SliceCenter=Rect.new(99,99,99,99)
function Close()
a:TweenObject(g,0.5,"Quad","Position",UDim2.new(0,300,0,0))
wait(1.2)
f:Destroy()
end
l.Activated:Connect(Close)
a:TweenObject(g,0.5,"Quad","Position",UDim2.new(0,0,0,0))
wait(d.Duration)
Close()
end)
end
function b.MakeWindow(c,d)
d=a:MakeConfig({
Title="Night Hub",
SubTitle="By ! _nightX [Comeback]",
Logo="rbxassetid://117874257607161",
Scale=UDim2.fromOffset(650,450)
},d or{})
local e=Instance.new"ScreenGui"
local f=Instance.new"Frame"
local g=Instance.new"ImageLabel"
local h=Instance.new"Frame"
local i=Instance.new"UICorner"
local j=Instance.new"UIStroke"
local k=Instance.new"Frame"
local l=Instance.new"Frame"
local m=Instance.new"Folder"
local n=Instance.new"Frame"
local o=Instance.new"ImageLabel"
local p=Instance.new"TextLabel"
local q=Instance.new"TextLabel"
local r=Instance.new"Frame"
local s=Instance.new"TextButton"
local t=Instance.new"UICorner"
local u=Instance.new"ImageLabel"
local v=Instance.new"UIListLayout"
local w=Instance.new"TextButton"
local x=Instance.new"UICorner"
local y=Instance.new"ImageLabel"
local z=Instance.new"TextButton"
local A=Instance.new"UICorner"
local B=Instance.new"ImageLabel"
local C=Instance.new"TextButton"
local D=Instance.new"UICorner"
local E=Instance.new"Frame"
local F=Instance.new"ScrollingFrame"
local G=Instance.new"UIListLayout"
local H=Instance.new"UIPadding"
local I=Instance.new"Frame"
local J=Instance.new"UICorner"
local K=Instance.new"UIStroke"
local L=Instance.new"ImageLabel"
local M=Instance.new"TextBox"
local N=Instance.new"Frame"
local O=Instance.new"TextLabel"
e.Name="NightUI"
e.Parent=game.CoreGui
e.ZIndexBehavior=Enum.ZIndexBehavior.Sibling

f.Name="Main"
f.Parent=e
f.BackgroundColor3=Color3.new(0.0627451,0.0627451,0.0627451)
f.BackgroundTransparency=1
f.BorderColor3=Color3.new(0,0,0)
f.BorderSizePixel=0
f.Size=d.Scale
f.Position=UDim2.fromOffset(game.Workspace.Camera.ViewportSize.X/2-f.Size.X.Offset/2,
game.Workspace.Camera.ViewportSize.Y/2-f.Size.Y.Offset/2)

g.Name="Blur"
g.Parent=f
g.AnchorPoint=Vector2.new(0.5,0.5)
g.BackgroundColor3=Color3.new(1,1,1)
g.BackgroundTransparency=1
g.BorderColor3=Color3.new(0,0,0)
g.BorderSizePixel=0
g.Position=UDim2.new(0.518461525,0,0.533333361,0)
g.Size=UDim2.new(1,120,1,120)
g.Image="rbxassetid://8992230677"
g.ImageColor3=Color3.new(0,0,0)
g.ImageTransparency=0.30000001192092896
g.ScaleType=Enum.ScaleType.Slice
g.SliceCenter=Rect.new(99,99,99,99)

h.Name="MainFrame"
h.Parent=f
h.BackgroundColor3=Color3.new(0.054902,0.054902,0.054902)
h.BackgroundTransparency=0.03999999910593033
h.BorderColor3=Color3.new(0,0,0)
h.BorderSizePixel=0
h.Size=UDim2.new(1,0,1,0)

i.Parent=h
i.CornerRadius=UDim.new(0,24)

j.Parent=h
j.Color=Color3.new(1,1,1)
j.Transparency=0.949999988079071

k.Name="LayerFrame"
k.Parent=h
k.BackgroundColor3=Color3.new(1,1,1)
k.BackgroundTransparency=1
k.BorderColor3=Color3.new(0,0,0)
k.BorderSizePixel=0
k.Position=UDim2.new(0,220,0,70)
k.Size=UDim2.new(1,-225,1,-80)

l.Name="RealLayer"
l.Parent=k
l.BackgroundColor3=Color3.new(1,1,1)
l.BackgroundTransparency=1
l.BorderColor3=Color3.new(0,0,0)
l.BorderSizePixel=0
l.Size=UDim2.new(1,0,1,0)

m.Name="AllLayers"
m.Parent=l

E.Name="TabFrame"
E.Parent=h
E.BackgroundColor3=Color3.new(1,1,1)
E.BackgroundTransparency=1
E.BorderColor3=Color3.new(0,0,0)
E.BorderSizePixel=0
E.Position=UDim2.new(0,20,0,70)
E.Size=UDim2.new(0,200,1,-80)

F.Name="TabScrolling"
F.Parent=E
F.BackgroundColor3=Color3.new(1,1,1)
F.BackgroundTransparency=1
F.BorderColor3=Color3.new(0,0,0)
F.BorderSizePixel=0
F.Position=UDim2.new(0,0,0,50)
F.Selectable=false
F.Size=UDim2.new(1,0,1,-50)
F.CanvasSize=UDim2.new(0,0,1,0)
F.ScrollBarThickness=0

G.Parent=F
G.SortOrder=Enum.SortOrder.LayoutOrder
G.Padding=UDim.new(0,7)
a:AutoUpdateScrolling(G,F)

H.Parent=F
H.PaddingBottom=UDim.new(0,2)
H.PaddingLeft=UDim.new(0,2)
H.PaddingRight=UDim.new(0,2)
H.PaddingTop=UDim.new(0,2)
n.Name="Topbar"
n.Parent=h
n.BackgroundColor3=Color3.new(1,1,1)
n.BackgroundTransparency=1
n.BorderColor3=Color3.new(0,0,0)
n.BorderSizePixel=0
n.Size=UDim2.new(1,0,0,70)

o.Name="LogoScript"
o.Parent=n
o.BackgroundColor3=Color3.new(1,1,1)
o.BackgroundTransparency=1
o.BorderColor3=Color3.new(0,0,0)
o.BorderSizePixel=0
o.Position=UDim2.new(0,20,0,15)
o.Size=UDim2.new(0,50,0,50)
o.Image=d.Logo

p.Name="NameScript"
p.Parent=n
p.BackgroundColor3=Color3.new(1,1,1)
p.BackgroundTransparency=1
p.BorderColor3=Color3.new(0,0,0)
p.BorderSizePixel=0
p.Position=UDim2.new(0,70,0,23)
p.Size=UDim2.new(0,300,0,16)
p.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
p.Text=d.Title
p.TextColor3=Color3.new(1,1,1)
p.TextSize=14
p.TextXAlignment=Enum.TextXAlignment.Left

q.Name="SubTitle"
q.Parent=n
q.BackgroundColor3=Color3.new(1,1,1)
q.BackgroundTransparency=1
q.BorderColor3=Color3.new(0,0,0)
q.BorderSizePixel=0
q.Position=UDim2.new(0,70,0,37)
q.Size=UDim2.new(0,300,0,16)
q.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
q.Text=d.SubTitle
q.TextColor3=Color3.new(0.392157,0.392157,0.392157)
q.TextSize=12
q.TextXAlignment=Enum.TextXAlignment.Left

r.Name="UIController"
r.Parent=n
r.BackgroundColor3=Color3.new(1,1,1)
r.BackgroundTransparency=1
r.BorderColor3=Color3.new(0,0,0)
r.BorderSizePixel=0
r.Position=UDim2.new(1,-145,0,16)
r.Size=UDim2.new(0,140,0,40)

s.Name="Minimize"
s.Parent=r
s.BackgroundColor3=Color3.new(1,1,1)
s.BackgroundTransparency=1
s.BorderColor3=Color3.new(0,0,0)
s.BorderSizePixel=0
s.Size=UDim2.new(0,40,0,40)
s.AutoButtonColor=false
s.Font=Enum.Font.SourceSans
s.Text=""
s.TextColor3=Color3.new(0,0,0)
s.TextSize=14
s.MouseEnter:Connect(function()
s.BackgroundTransparency=0.9
end)
s.MouseLeave:Connect(function()
s.BackgroundTransparency=1
end)
s.Activated:Connect(function()
h.Visible=false
a:TweenObject(g,0.5,"Quad","ImageTransparency",1)
end)

t.Parent=s

u.Name="Minize_Icon"
u.Parent=s
u.AnchorPoint=Vector2.new(0.5,0.5)
u.BackgroundColor3=Color3.new(1,1,1)
u.BackgroundTransparency=1
u.BorderColor3=Color3.new(0,0,0)
u.BorderSizePixel=0
u.Position=UDim2.new(0.5,0,0.5,0)
u.Size=UDim2.new(1,-15,1,-15)
u.Image="rbxassetid://136452605242985"
u.ImageRectOffset=Vector2.new(288,672)
u.ImageRectSize=Vector2.new(96,96)
u.ImageTransparency=0.5

v.Parent=r
v.FillDirection=Enum.FillDirection.Horizontal
v.SortOrder=Enum.SortOrder.LayoutOrder
v.Padding=UDim.new(0,6)

w.Name="MaxSize"
w.Parent=r
w.BackgroundColor3=Color3.new(1,1,1)
w.BackgroundTransparency=1
w.BorderColor3=Color3.new(0,0,0)
w.BorderSizePixel=0
w.Size=UDim2.new(0,40,0,40)
w.AutoButtonColor=false
w.Font=Enum.Font.SourceSans
w.Text=""
w.TextColor3=Color3.new(0,0,0)
w.TextSize=14
w.MouseEnter:Connect(function()
w.BackgroundTransparency=0.9
end)
w.MouseLeave:Connect(function()
w.BackgroundTransparency=1
end)
w.Activated:Connect(function()
if f.Size.X.Scale<1 or f.Size.Y.Scale<1 then
OldPos,OldSize=f.Position,f.Size
a:TweenObject(f,0.45,"Quad","Size",UDim2.fromScale(1,1))
a:TweenObject(f,0.45,"Quad","Position",UDim2.new(0,0,0,0))
else
a:TweenObject(f,0.45,"Quad","Size",OldSize)
a:TweenObject(f,0.45,"Quad","Position",OldPos)
end
end)

x.Parent=w

y.Name="MaxSize_Icon"
y.Parent=w
y.AnchorPoint=Vector2.new(0.5,0.5)
y.BackgroundColor3=Color3.new(1,1,1)
y.BackgroundTransparency=1
y.BorderColor3=Color3.new(0,0,0)
y.BorderSizePixel=0
y.Position=UDim2.new(0.5,0,0.5,0)
y.Size=UDim2.new(1,-20,1,-20)
y.Image="rbxassetid://136452605242985"
y.ImageRectOffset=Vector2.new(580,194)
y.ImageRectSize=Vector2.new(96,96)
y.ImageTransparency=0.5

z.Name="Close"
z.Parent=r
z.BackgroundColor3=Color3.new(1,1,1)
z.BackgroundTransparency=1
z.BorderColor3=Color3.new(0,0,0)
z.BorderSizePixel=0
z.Size=UDim2.new(0,40,0,40)
z.AutoButtonColor=false
z.Font=Enum.Font.SourceSans
z.Text=""
z.TextColor3=Color3.new(0,0,0)
z.TextSize=14
z.MouseEnter:Connect(function()
z.BackgroundTransparency=0.9
end)
z.MouseLeave:Connect(function()
z.BackgroundTransparency=1
end)
z.Activated:Connect(function()
h.Visible=false
a:TweenObject(g,0.5,"Quad","ImageTransparency",1)
wait(.1)
e:Destroy()
end)
A.Parent=z

B.Name="MaxSize_Icon"
B.Parent=z
B.AnchorPoint=Vector2.new(0.5,0.5)
B.BackgroundColor3=Color3.new(1,1,1)
B.BackgroundTransparency=1
B.BorderColor3=Color3.new(0,0,0)
B.BorderSizePixel=0
B.Position=UDim2.new(0.5,0,0.5,0)
B.Size=UDim2.new(1,-15,1,-15)
B.Image="rbxassetid://105957381820378"
B.ImageRectOffset=Vector2.new(480,0)
B.ImageRectSize=Vector2.new(96,96)
B.ImageTransparency=0.5

C.Name="DropdownHolder"
C.Parent=h
C.BackgroundColor3=Color3.new(0,0,0)
C.BackgroundTransparency=1
C.BorderColor3=Color3.new(0,0,0)
C.BorderSizePixel=0
C.Size=UDim2.new(1,0,1,0)
C.AutoButtonColor=false
C.Font=Enum.Font.SourceSans
C.Text=""
C.TextColor3=Color3.new(0,0,0)
C.TextSize=14
C.Visible=false

D.Parent=C
D.CornerRadius=UDim.new(0,24)

I.Name="SearchBar"
I.Parent=E
I.BackgroundColor3=Color3.new(0.0392157,0.0392157,0.0392157)
I.BorderColor3=Color3.new(0,0,0)
I.BorderSizePixel=0
I.Size=UDim2.new(0,200,0,40)

J.Parent=I
J.CornerRadius=UDim.new(0,24)

K.Parent=I
K.Color=Color3.new(1,1,1)
K.Transparency=0.9300000071525574

L.Name="SearchIcon"
L.Parent=I
L.AnchorPoint=Vector2.new(0,0.5)
L.BackgroundColor3=Color3.new(1,1,1)
L.BackgroundTransparency=1
L.BorderColor3=Color3.new(0,0,0)
L.BorderSizePixel=0
L.Position=UDim2.new(0,15,0.5,0)
L.Size=UDim2.new(0,15,0,15)
L.Image="rbxassetid://116187338954836"

M.Name="RealSearchBox"
M.Parent=I
M.BackgroundColor3=Color3.new(1,1,1)
M.BackgroundTransparency=1
M.BorderColor3=Color3.new(0,0,0)
M.BorderSizePixel=0
M.ClipsDescendants=true
M.Position=UDim2.new(0,35,0,0)
M.Size=UDim2.new(1,-35,1,0)
M.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
M.PlaceholderColor3=Color3.new(0.698039,0.698039,0.698039)
M.PlaceholderText="Search Any Function Here..."
M.Text=""
M.TextColor3=Color3.new(1,1,1)
M.TextSize=12
M.TextXAlignment=Enum.TextXAlignment.Left

N.Name="Layer Name"
N.Parent=l
N.BackgroundColor3=Color3.new(1,1,1)
N.BackgroundTransparency=1
N.BorderColor3=Color3.new(0,0,0)
N.BorderSizePixel=0
N.Position=UDim2.new(0,24,0,0)
N.Size=UDim2.new(1,-25,0,25)

O.Name="Title"
O.Parent=N
O.BackgroundColor3=Color3.new(1,1,1)
O.BackgroundTransparency=1
O.BorderColor3=Color3.new(0,0,0)
O.BorderSizePixel=0
O.Size=UDim2.new(1,0,1,0)
O.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
O.Text=""
O.TextColor3=Color3.new(1,1,1)
O.TextSize=23
O.TextXAlignment=Enum.TextXAlignment.Left
O.TextYAlignment=Enum.TextYAlignment.Top


a:MixFunction(f,n)

local P
local function ChangePage(Q)
for R,S in next,m:GetChildren()do
a:TweenObject(S,0.15,"Quad","Position",UDim2.new(0,0,0,55))
task.delay(0.1,function()
S.Visible=false
end)
end
task.wait(0.1)
P=Q
Q.Visible=true
a:TweenObject(Q,0.15,"Quad","Position",UDim2.new(0,0,0,35))
end
local Q={}
local R=0
function Q.AddTab(S,T)
T=a:MakeConfig({
Name="Tab <Missing Title>",
Icon="rbxassetid://111715807090579"
},T or{})
local U=Instance.new"TextButton"
local V=Instance.new"UICorner"
local W=Instance.new"UIStroke"
local X=Instance.new"Frame"
local Y=Instance.new"TextLabel"
local Z=Instance.new"ImageLabel"
local _=Instance.new"ScrollingFrame"
local aa=Instance.new"UIListLayout"
local ab=Instance.new"UIPadding"
U.Name="TabDisable"
U.Parent=F
U.BackgroundColor3=Color3.new(1,1,1)
U.BackgroundTransparency=1
U.BorderColor3=Color3.new(0,0,0)
U.BorderSizePixel=0
U.Size=UDim2.new(1,0,0,35)
U.AutoButtonColor=false
U.Font=Enum.Font.SourceSans
U.Text=""
U.TextColor3=Color3.new(0,0,0)
U.TextSize=14

V.Parent=U
V.CornerRadius=UDim.new(0,12)

W.Parent=U
W.Color=Color3.new(1,1,1)
W.Transparency=1
W.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

X.Name="TabDisableFrame"
X.Parent=U
X.BackgroundColor3=Color3.new(1,1,1)
X.BackgroundTransparency=1
X.BorderColor3=Color3.new(0,0,0)
X.BorderSizePixel=0
X.Size=UDim2.new(1,0,1,0)

Y.Name="TitleTab"
Y.Parent=X
Y.BackgroundColor3=Color3.new(1,1,1)
Y.BackgroundTransparency=1
Y.BorderColor3=Color3.new(0,0,0)
Y.BorderSizePixel=0
Y.Position=UDim2.new(0,30,0,0)
Y.Size=UDim2.new(1,-45,1,0)
Y.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
Y.Text=T.Name
Y.TextColor3=Color3.new(1,1,1)
Y.TextSize=13
Y.TextTransparency=0.5
Y.TextXAlignment=Enum.TextXAlignment.Left

Z.Name="IconTab"
Z.Parent=X
Z.AnchorPoint=Vector2.new(0,0.5)
Z.BackgroundColor3=Color3.new(1,1,1)
Z.BackgroundTransparency=1
Z.BorderColor3=Color3.new(0,0,0)
Z.BorderSizePixel=0
Z.Position=UDim2.new(0,5,0.5,0)
Z.Size=UDim2.new(0,16,0,16)
Z.Image=T.Icon
Z.ImageTransparency=0.5

_.Name="Layers 1"
_.Parent=m
_.BackgroundColor3=Color3.new(1,1,1)
_.BackgroundTransparency=1
_.BorderColor3=Color3.new(0,0,0)
_.BorderSizePixel=0
_.Position=UDim2.new(0,0,0,35)
_.Selectable=false
_.ScrollBarImageColor3=Color3.fromRGB(60,60,60)
_.Size=UDim2.new(1,0,1,-25)
_.ScrollBarThickness=4
_.Visible=false
aa.Parent=_
aa.SortOrder=Enum.SortOrder.LayoutOrder
aa.Padding=UDim.new(0,6)
a:AutoUpdateScrolling(aa,_)
ab.Parent=_
ab.PaddingBottom=UDim.new(0,12)
ab.PaddingLeft=UDim.new(0,24)
ab.PaddingRight=UDim.new(0,12)
if R==0 then
U.BackgroundTransparency=0.949999988079071
Z.ImageTransparency=0
Y.TextTransparency=0
Y.Position=UDim2.new(0,45,0,0)
Z.Position=UDim2.new(0,16,0.5,0)
O.Text=Y.Text
W.Transparency=0.85
_.Visible=true
end
U.Activated:Connect(function()
if P~=_ then
for ac,ad in next,F:GetChildren()do
if ad:IsA"TextButton"then
a:TweenObject(ad,0.25,"Quad","BackgroundTransparency",1)
a:TweenObject(ad.TabDisableFrame.IconTab,0.25,"Quad","ImageTransparency",0.5)
a:TweenObject(ad.TabDisableFrame.TitleTab,0.25,"Quad","TextTransparency",0.5)
a:TweenObject(ad.UIStroke,0.25,"Quad","Transparency",1)
a:TweenObject(ad.TabDisableFrame.IconTab,0.25,"Quad","Position",UDim2.new(0,5,0.5,0))
a:TweenObject(ad.TabDisableFrame.TitleTab,0.25,"Quad","Position",UDim2.new(0,30,0,0))
end
end
a:TweenObject(U,0.25,"Quad","BackgroundTransparency",0.949999988079071)
a:TweenObject(Z,0.25,"Quad","ImageTransparency",0)
a:TweenObject(Y,0.25,"Quad","TextTransparency",0)
a:TweenObject(W,0.25,"Quad","Transparency",0.85)
a:TweenObject(Z,0.25,"Quad","Position",UDim2.new(0,16,0.5,0))
a:TweenObject(Y,0.25,"Quad","Position",UDim2.new(0,45,0,0))
ChangePage(_)
O.Text=Y.Text
end
end)
R=R+1
M:GetPropertyChangedSignal"Text":Connect(function()
for ac,ad in next,m:GetChildren()do
for ae,af in next,ad:GetChildren()do
if af:IsA"Frame"or af:IsA"TextButton"then
if af.Name~="Seperator"and M.Text~=""then
if string.find(af.Feature.Title.Text:lower(),M.Text:lower())then
af.Visible=true
else
af.Visible=false
end
elseif af.Name~="Seperator"and M.Text==""then
af.Visible=true
end
end
end
end
end)
local ac={}
function ac.AddButton(ad,ae)
ae=a:MakeConfig({
Title="Button < Missing Title >",
Description="",
Callback=function()end
},ae or{})
local af=Instance.new"TextButton"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"TextLabel"
local am=Instance.new"TextButton"
local an=Instance.new"UICorner"
af.Name="Button"
af.Parent=_
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Size=UDim2.new(1,0,0,55)
af.AutoButtonColor=false
af.Font=Enum.Font.SourceSans
af.Text=""
af.TextColor3=Color3.new(0,0,0)
af.TextSize=14

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75
ah.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="Content"
al.Parent=ai
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(0,42,0,26)
al.Size=UDim2.new(1,-185,1,-28)
al.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
al.Text=ae.Description
al.TextColor3=Color3.new(0.521569,0.521569,0.521569)
al.TextSize=12
al.TextWrapped=true
al.TextXAlignment=Enum.TextXAlignment.Left
al.TextYAlignment=Enum.TextYAlignment.Top

am.Name="Click"
am.Parent=ai
am.AnchorPoint=Vector2.new(0,0.5)
am.BackgroundColor3=Color3.new(1,1,1)
am.BackgroundTransparency=0.9200000166893005
am.BorderColor3=Color3.new(0,0,0)
am.BorderSizePixel=0
am.Position=UDim2.new(1,-130,0.5,0)
am.Size=UDim2.new(0,120,0,30)
am.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
am.Text="Click here!"
am.TextColor3=Color3.new(1,1,1)
am.TextSize=13

an.Parent=am
an.CornerRadius=UDim.new(0,4)
a:AutoUpdateContent{af,aj,al}
am.Activated:Connect(function()
a:SafeCallback(ae.Callback)
end)
end
function ac.AddToggle(ad,ae)
ae=a:MakeConfig({
Title="Toggle < Missing Title >",
Description="",
Default=false,
Callback=function()end
},ae or{})
local af=Instance.new"TextButton"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"Frame"
local am=Instance.new"UIStroke"
local an=Instance.new"UICorner"
local ao=Instance.new"Frame"
local ap=Instance.new"UICorner"
local aq=Instance.new"TextLabel"
local ar={Value=ae.Default}
af.Name="Toggle_Active"
af.Parent=_
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Size=UDim2.new(1,0,0,55)
af.Font=Enum.Font.SourceSans
af.Text=""
af.TextColor3=Color3.new(0,0,0)
af.TextSize=14

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75
ah.ApplyStrokeMode=Enum.ApplyStrokeMode.Border

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="CheckFrame"
al.Parent=ai
al.AnchorPoint=Vector2.new(0,0.5)
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(1,-65,0.5,0)
al.Size=UDim2.new(0,45,0,20)

am.Parent=al
am.Color=Color3.new(1,1,1)
am.Thickness=1.5
am.Transparency=1

an.Parent=al
an.CornerRadius=UDim.new(1,0)

ao.Name="Circle"
ao.Parent=al
ao.AnchorPoint=Vector2.new(0,0.5)
ao.BackgroundColor3=Color3.new(1,1,1)
ao.BackgroundTransparency=0.5
ao.BorderColor3=Color3.new(0,0,0)
ao.BorderSizePixel=0
ao.Position=UDim2.new(0,3,0.5,0)
ao.Size=UDim2.new(0,16,0,16)

ap.Parent=ao
ap.CornerRadius=UDim.new(1,0)

aq.Name="Content"
aq.Parent=ai
aq.BackgroundColor3=Color3.new(1,1,1)
aq.BackgroundTransparency=1
aq.BorderColor3=Color3.new(0,0,0)
aq.BorderSizePixel=0
aq.Position=UDim2.new(0,42,0,26)
aq.Size=UDim2.new(1,-125,1,-28)
aq.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aq.Text=ae.Description
aq.TextColor3=Color3.new(0.521569,0.521569,0.521569)
aq.TextSize=12
aq.TextWrapped=true
aq.TextXAlignment=Enum.TextXAlignment.Left
aq.TextYAlignment=Enum.TextYAlignment.Top
a:AutoUpdateContent{af,aj,aq}
function ar.Set(as,at)
if at then
a:TweenObject(al,0.3,"Quad","BackgroundTransparency",0)
a:TweenObject(ao,0.3,"Quad","BackgroundTransparency",0)
a:TweenObject(ao,0.3,"Quad","Position",UDim2.new(0,27,0.5,0))
a:TweenObject(ao,0.3,"Quad","BackgroundColor3",Color3.fromRGB(0,0,0))
a:TweenObject(am,0.3,"Quad","Transparency",0)
else
a:TweenObject(al,0.3,"Quad","BackgroundTransparency",1)
a:TweenObject(ao,0.3,"Quad","Position",UDim2.new(0,3,0.5,0))
a:TweenObject(ao,0.3,"Quad","BackgroundTransparency",0.5)
a:TweenObject(ao,0.3,"Quad","BackgroundColor3",Color3.fromRGB(255,255,255))
a:TweenObject(am,0.3,"Quad","Transparency",0.6499999761581421)
end
as.Value=at
ae.Callback(at)
end
ar:Set(ar.Value)
af.Activated:Connect(function()
ar:Set(not ar.Value)
end)
return ar
end
function ac.AddDropdown(ad,ae)
ae=a:MakeConfig({
Title="Dropdown < Missing Title >",
Description="",
Values={},
Default="",
Multi=false,
Callback=function()end
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"TextLabel"
local am=Instance.new"Frame"
local an=Instance.new"TextButton"
local ao=Instance.new"UITextSizeConstraint"
local ap=Instance.new"UIPadding"
local aq=Instance.new"UICorner"
local ar=Instance.new"ImageLabel"
local as=Instance.new"Frame"
local at=Instance.new"UICorner"
local au=Instance.new"UIStroke"
local av=Instance.new"Frame"
local aw=Instance.new"TextLabel"
local ax=Instance.new"Frame"
local ay=Instance.new"UICorner"
local az=Instance.new"UIStroke"
local aA=Instance.new"TextBox"
local aB=Instance.new"ImageLabel"
local aC=Instance.new"Frame"
local aD=Instance.new"UICorner"
local aE=Instance.new"UIStroke"
local aF=Instance.new"ScrollingFrame"
local aG=Instance.new"UIListLayout"
local aH=Instance.new"UIPadding"
local aI={
Value=ae.Default,
Lists=ae.Values
}
af.Name="Dropdown"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,55)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="Content"
al.Parent=ai
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(0,42,0,26)
al.Size=UDim2.new(1,-185,1,-28)
al.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
al.Text=ae.Description
al.TextColor3=Color3.new(0.521569,0.521569,0.521569)
al.TextSize=12
al.TextWrapped=true
al.TextXAlignment=Enum.TextXAlignment.Left
al.TextYAlignment=Enum.TextYAlignment.Top

am.Name="DropdownButton"
am.Parent=ai
am.AnchorPoint=Vector2.new(0,0.5)
am.BackgroundColor3=Color3.new(1,1,1)
am.BackgroundTransparency=0.9200000166893005
am.BorderColor3=Color3.new(0,0,0)
am.BorderSizePixel=0
am.Position=UDim2.new(1,-130,0.5,0)
am.Size=UDim2.new(0,120,0,30)

an.Name="Click_Dropdown"
an.AutoButtonColor=true
an.Parent=am
an.BackgroundColor3=Color3.new(1,1,1)
an.BackgroundTransparency=1
an.BorderColor3=Color3.new(0,0,0)
an.BorderSizePixel=0
an.Size=UDim2.new(0,90,0,30)
an.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
an.Text=""
an.TextColor3=Color3.new(1,1,1)
an.TextScaled=true
an.TextSize=13
an.TextWrapped=true
an.TextXAlignment=Enum.TextXAlignment.Left

ao.Parent=an
ao.MaxTextSize=13
ap.Parent=an
ap.PaddingLeft=UDim.new(0,12)
aq.Parent=am
aq.CornerRadius=UDim.new(0,4)
ar.Name="Drop_Icon"
ar.Parent=am
ar.AnchorPoint=Vector2.new(0,0.5)
ar.BackgroundColor3=Color3.new(1,1,1)
ar.BackgroundTransparency=1
ar.BorderColor3=Color3.new(0,0,0)
ar.BorderSizePixel=0
ar.Position=UDim2.new(1,-25,0.5,0)
ar.Size=UDim2.new(0,20,0,20)
ar.Image="rbxassetid://138774556132856"

as.Name="MainDropdown"
as.Parent=C
as.AnchorPoint=Vector2.new(0.5,0.5)
as.BackgroundColor3=Color3.new(0.0627451,0.0627451,0.0627451)
as.BorderColor3=Color3.new(0,0,0)
as.BorderSizePixel=0
as.Position=UDim2.new(0.5,0,0.5,0)
as.Size=UDim2.new(0.800000012,0,0.800000012,0)
as.Visible=false

at.Parent=as
at.CornerRadius=UDim.new(0,24)

au.Parent=as
au.Color=Color3.new(1,1,1)
au.Transparency=0.949999988079071

av.Name="TopDrop"
av.Parent=as
av.BackgroundColor3=Color3.new(1,1,1)
av.BackgroundTransparency=1
av.BorderColor3=Color3.new(0,0,0)
av.BorderSizePixel=0
av.Size=UDim2.new(1,0,0,70)

aw.Parent=av
aw.AnchorPoint=Vector2.new(0,0.5)
aw.BackgroundColor3=Color3.new(1,1,1)
aw.BackgroundTransparency=1
aw.BorderColor3=Color3.new(0,0,0)
aw.BorderSizePixel=0
aw.Position=UDim2.new(0,40,0.5,0)
aw.Size=UDim2.new(0,200,0,50)
aw.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aw.Text=ae.Title
aw.TextColor3=Color3.new(1,1,1)
aw.TextSize=16
aw.TextXAlignment=Enum.TextXAlignment.Left

ax.Parent=av
ax.BackgroundColor3=Color3.new(0.0392157,0.0392157,0.0392157)
ax.BorderColor3=Color3.new(0,0,0)
ax.BorderSizePixel=0
ax.Position=UDim2.new(0,130,0,15)
ax.Size=UDim2.new(0,300,0,40)

ay.Parent=ax
ay.CornerRadius=UDim.new(0,12)

az.Parent=ax
az.Color=Color3.new(1,1,1)
az.Transparency=0.949999988079071

aA.Name="RealSearchBox"
aA.Parent=ax
aA.BackgroundColor3=Color3.new(1,1,1)
aA.BackgroundTransparency=1
aA.BorderColor3=Color3.new(0,0,0)
aA.BorderSizePixel=0
aA.ClipsDescendants=true
aA.Position=UDim2.new(0,35,0,0)
aA.Size=UDim2.new(1,-35,1,0)
aA.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle
.Normal)
aA.PlaceholderColor3=Color3.new(0.698039,0.698039,0.698039)
aA.PlaceholderText="Search Any Options here."
aA.Text=""
aA.TextColor3=Color3.new(1,1,1)
aA.TextSize=12
aA.TextXAlignment=Enum.TextXAlignment.Left

aB.Name="SearchIcon"
aB.Parent=ax
aB.AnchorPoint=Vector2.new(0,0.5)
aB.BackgroundColor3=Color3.new(1,1,1)
aB.BackgroundTransparency=1
aB.BorderColor3=Color3.new(0,0,0)
aB.BorderSizePixel=0
aB.Position=UDim2.new(0,15,0.5,0)
aB.Size=UDim2.new(0,15,0,15)
aB.Image="rbxassetid://116187338954836"

aC.Name="DropFrame"
aC.Parent=as
aC.AnchorPoint=Vector2.new(0.5,0.5)
aC.BackgroundColor3=Color3.new(0.0392157,0.0392157,0.0392157)
aC.BorderColor3=Color3.new(0,0,0)
aC.BorderSizePixel=0
aC.Position=UDim2.new(0.5,0,0.550000012,0)
aC.Size=UDim2.new(0.850000024,0,0.699999988,0)

aD.Parent=aC
aD.CornerRadius=UDim.new(0,12)

aE.Parent=aC
aE.Color=Color3.new(1,1,1)
aE.Transparency=0.949999988079071

aF.Name="RealDrop"
aF.Parent=aC
aF.AnchorPoint=Vector2.new(0.5,0.5)
aF.BackgroundColor3=Color3.new(0.0627451,0.0627451,0.0627451)
aF.BackgroundTransparency=1
aF.BorderColor3=Color3.new(0,0,0)
aF.BorderSizePixel=0
aF.Position=UDim2.new(0.5,0,0.5,0)
aF.Selectable=false
aF.Size=UDim2.new(1,-10,1,-10)
aF.ScrollBarImageColor3=Color3.fromRGB(60,60,60)
aF.CanvasSize=UDim2.new(0,0,1.10000002,0)
aF.ScrollBarThickness=3

aG.Parent=aF
aG.SortOrder=Enum.SortOrder.LayoutOrder
aG.Padding=UDim.new(0,4)
a:AutoUpdateScrolling(aG,aF)

aH.Parent=aF
aH.PaddingLeft=UDim.new(0,7)
aH.PaddingRight=UDim.new(0,7)

a:AutoUpdateContent{af,aj,al}
as.MouseEnter:Connect(function()
C.Active=false
end)
as.MouseLeave:Connect(function()
C.Active=true
end)
an.Activated:Connect(function()
C.Visible=true
a:TweenObject(C,0.3,"Quad","BackgroundTransparency",0.5)
task.wait(0.05)
as.Visible=true
end)
C.Activated:Connect(function()
as.Visible=false
a:TweenObject(C,0.3,"Quad","BackgroundTransparency",1)
task.wait(0.05)
C.Visible=false
end)
function aI.Select(aJ,aK)
aJ.Value=aK or aJ.Value
for aL,aM in next,aF:GetChildren()do
if aM:IsA"TextButton"and not table.find(aJ.Value,aM.Name)then
a:TweenObject(aM,0.3,"Quad","BackgroundTransparency",1)
a:TweenObject(aM.Title,0.3,"Quad","TextTransparency",0.5)
elseif aM:IsA"TextButton"and table.find(aJ.Value,aM.Name)then
a:TweenObject(aM,0.3,"Quad","BackgroundTransparency",0.949999988079071)
a:TweenObject(aM.Title,0.3,"Quad","TextTransparency",0)
end
end
local aL,aM=table.concat(aJ.Value,","),
(ae.Multi and aJ.Value or table.concat(aJ.Value,","))
if aL==""then
an.Text=""
else
an.Text=aL
end
ae.Callback(aM)
end
function aI.Add(aJ,aK)
local aL=Instance.new"TextButton"
local aM=Instance.new"UICorner"
local aN=Instance.new"TextLabel"
aL.Name=tostring(aK)
aL.Parent=aF
aL.BackgroundColor3=Color3.new(1,1,1)
aL.BackgroundTransparency=1
aL.BorderColor3=Color3.new(0,0,0)
aL.BorderSizePixel=0
aL.Size=UDim2.new(1,0,0,40)
aL.AutoButtonColor=false
aL.Font=Enum.Font.SourceSans
aL.Text=""
aL.TextColor3=Color3.new(0,0,0)
aL.TextSize=14
aM.Parent=aL
aN.Name="Title"
aN.Parent=aL
aN.BackgroundColor3=Color3.new(1,1,1)
aN.BackgroundTransparency=1
aN.BorderColor3=Color3.new(0,0,0)
aN.BorderSizePixel=0
aN.Size=UDim2.new(1,0,1,0)
aN.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aN.Text=tostring(aK)
aN.TextColor3=Color3.new(1,1,1)
aN.TextSize=14
aN.TextTransparency=0.5
aL.Activated:Connect(function()
if ae.Multi then
if aL.BackgroundTransparency<0.96 then
for aO,aP in next,aJ.Value do
if aP==aN.Text then
table.remove(aJ.Value,aO)
break
end
end
aJ:Select(aJ.Value)
else
table.insert(aJ.Value,aN.Text)
aJ:Select(aJ.Value)
end
else
aJ.Value={aN.Text}
aJ:Select(aJ.Value)
end
end)
end
function aI.Clear(aJ)
for aK,aL in next,aF:GetChildren()do
if aL:IsA"TextButton"then
aL:Destroy()
end
end
end
function aI.Refresh(aJ,aK)
aJ:Clear()
for aL,aM in next,(aK or ae.Values)do
aJ:Add(aM)
end
end
aI:Refresh()
aI:Select((typeof(ae.Default)=="string"and{ae.Default}or ae.Default))
return aI
end
function ac.AddSlider(ad,ae)
ae=a:MakeConfig({
Title="Slider < Missing Title >",
Description="",
Max=100,
Min=1,
Rounding=1,
Default=1,
Callback=function()

end
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"TextLabel"
local am=Instance.new"Frame"
local an=Instance.new"UICorner"
local ao=Instance.new"Frame"
local ap=Instance.new"UICorner"
local aq=Instance.new"Frame"
local ar=Instance.new"UICorner"
local as=Instance.new"TextLabel"
local at={Value=ae.Default}
af.Name="Slider"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,55)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="Content"
al.Parent=ai
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(0,42,0,26)
al.Size=UDim2.new(1,-185,1,-28)
al.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
al.Text=ae.Description
al.TextColor3=Color3.new(0.521569,0.521569,0.521569)
al.TextSize=12
al.TextWrapped=true
al.TextXAlignment=Enum.TextXAlignment.Left
al.TextYAlignment=Enum.TextYAlignment.Top

am.Name="MainSlider"
am.Parent=ai
am.AnchorPoint=Vector2.new(0,0.5)
am.BackgroundColor3=Color3.new(1,1,1)
am.BackgroundTransparency=0.949999988079071
am.BorderColor3=Color3.new(0,0,0)
am.BorderSizePixel=0
am.Position=UDim2.new(1,-130,0.5,0)
am.Size=UDim2.new(0,120,0,3)

an.Parent=am
an.CornerRadius=UDim.new(1,0)

ao.Name="DragSlider"
ao.Parent=am
ao.BackgroundColor3=Color3.new(1,1,1)
ao.BorderColor3=Color3.new(0,0,0)
ao.BorderSizePixel=0
ao.Size=UDim2.new(0,100,1,0)

ap.Parent=ao
ap.CornerRadius=UDim.new(1,0)

aq.Name="Mini_Circle"
aq.Parent=ao
aq.AnchorPoint=Vector2.new(0,0.5)
aq.BackgroundColor3=Color3.new(1,1,1)
aq.BorderColor3=Color3.new(0,0,0)
aq.BorderSizePixel=0
aq.Position=UDim2.new(1,-5,0.5,0)
aq.Size=UDim2.new(0,11,0,11)

ar.Parent=aq
ar.CornerRadius=UDim.new(1,0)

as.Name="SliderValue"
as.Parent=ai
as.AnchorPoint=Vector2.new(0,0.5)
as.BackgroundColor3=Color3.new(1,1,1)
as.BackgroundTransparency=1
as.BorderColor3=Color3.new(0,0,0)
as.BorderSizePixel=0
as.Position=UDim2.new(1,-168,0.5,-1)
as.Size=UDim2.new(0,30,0,20)
as.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
as.Text=tostring(ae.Default)
as.TextColor3=Color3.new(1,1,1)
as.TextSize=13
a:AutoUpdateContent{
af,
aj,
al,
}
local au=false
local function Round(av,aw)
local ax=math.floor(av/aw+(math.sign(av)*0.5))*aw
if ax<0 then ax=ax+aw end
return ax
end
function at.Set(av,aw)
aw=math.clamp(Round(aw,ae.Rounding),ae.Min,ae.Max)
at.Value=aw
as.Text=tostring(aw)
a:TweenObject(
ao,
0.2,"Quad",
"Size",UDim2.fromScale((aw-ae.Min)/(ae.Max-ae.Min),1)
)
end
am.InputBegan:Connect(function(av)
if av.UserInputType==Enum.UserInputType.MouseButton1 or av.UserInputType==Enum.UserInputType.Touch then
au=true
end
end)
am.InputEnded:Connect(function(av)
if av.UserInputType==Enum.UserInputType.MouseButton1 or av.UserInputType==Enum.UserInputType.Touch then
au=false
ae.Callback(at.Value)
end
end)
game:GetService"UserInputService".InputChanged:Connect(function(av)
if au and(av.UserInputType==Enum.UserInputType.MouseMovement or av.UserInputType==Enum.UserInputType.Touch)then
local aw=math.clamp(
(av.Position.X-am.AbsolutePosition.X)/am.AbsoluteSize.X,0,1)
at:Set(ae.Min+((ae.Max-ae.Min)*aw))
end
end)
at:Set(ae.Default)
return at
end
function ac.AddParagraph(ad,ae)
ae=a:MakeConfig({
Title="Paragraph < Missing Title >",
Content=""
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"TextLabel"
local am={}
af.Name="Paragraph"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,55)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="Content"
al.Parent=ai
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(0,42,0,26)
al.Size=UDim2.new(1,-54,1,-28)
al.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
al.Text=ae.Content
al.TextColor3=Color3.new(0.521569,0.521569,0.521569)
al.TextSize=12
al.TextWrapped=true
al.TextXAlignment=Enum.TextXAlignment.Left
al.TextYAlignment=Enum.TextYAlignment.Top
a:AutoUpdateContent{
af,
aj,
al
}
function am.SetDesc(an,ao)
aj.Text=ao
end
function am.SetTitle(an,ao)
al.Text=ao
end
return am
end
function ac.AddInput(ad,ae)
ae=a:MakeConfig({
Title="Input < Missing Title >",
Description="",
PlaceHolder="",
Default="",
Callback=function()

end
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al=Instance.new"TextLabel"
local am=Instance.new"Frame"
local an=Instance.new"UICorner"
local ao=Instance.new"TextBox"
local ap=Instance.new"UITextSizeConstraint"
local aq=Instance.new"UIPadding"
local ar={}
af.Name="Textbox"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,55)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text=ae.Title
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon

al.Name="Content"
al.Parent=ai
al.BackgroundColor3=Color3.new(1,1,1)
al.BackgroundTransparency=1
al.BorderColor3=Color3.new(0,0,0)
al.BorderSizePixel=0
al.Position=UDim2.new(0,42,0,26)
al.Size=UDim2.new(1,-185,1,-28)
al.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
al.Text=ae.Description
al.TextColor3=Color3.new(0.521569,0.521569,0.521569)
al.TextSize=12
al.TextWrapped=true
al.TextXAlignment=Enum.TextXAlignment.Left
al.TextYAlignment=Enum.TextYAlignment.Top

am.Name="TextBoxFrame"
am.Parent=ai
am.AnchorPoint=Vector2.new(0,0.5)
am.BackgroundColor3=Color3.new(1,1,1)
am.BackgroundTransparency=0.9200000166893005
am.BorderColor3=Color3.new(0,0,0)
am.BorderSizePixel=0
am.Position=UDim2.new(1,-130,0.5,0)
am.Size=UDim2.new(0,120,0,30)

an.Parent=am
an.CornerRadius=UDim.new(0,4)

ao.Name="RealTextbox"
ao.Parent=am
ao.BackgroundColor3=Color3.new(1,1,1)
ao.BackgroundTransparency=1
ao.BorderColor3=Color3.new(0,0,0)
ao.BorderSizePixel=0
ao.Size=UDim2.new(0,90,0,30)
ao.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ao.PlaceholderText=ae.PlaceHolder
ao.Text=ae.Default
ao.TextColor3=Color3.new(1,1,1)
ao.TextScaled=true
ao.TextSize=13
ao.TextWrapped=true
ao.TextXAlignment=Enum.TextXAlignment.Left

ap.Parent=ao
ap.MaxTextSize=13

aq.Parent=ao
aq.PaddingLeft=UDim.new(0,12)
ao.FocusLost:Connect(function()
ae.Callback(ao.Text)
end)
function ar.SetText(as,at)
ao.Text=at
end
ae.Callback(ao.Text)
return ar
end
function ac.AddSeperator(ad,ae)
local af=Instance.new"Frame"
local ag=Instance.new"TextLabel"
af.Name="Seperator"
af.Parent=_
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=1
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Size=UDim2.new(1,0,0,30)

ag.Name="Title"
ag.Parent=af
ag.BackgroundColor3=Color3.new(1,1,1)
ag.BackgroundTransparency=1
ag.BorderColor3=Color3.new(0,0,0)
ag.BorderSizePixel=0
ag.Size=UDim2.new(1,0,1,0)
ag.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ag.Text=ae
ag.TextColor3=Color3.new(1,1,1)
ag.TextSize=16
ag.TextXAlignment=Enum.TextXAlignment.Left
end
function ac.AddLabel(ad,ae)
ae=a:MakeConfig({
Title="Label < Missing Title >",
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"ImageLabel"
local al={}
af.Name="Label"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,38)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="Title"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,42,0,0)
aj.Size=UDim2.new(1,-100,1,0)
aj.Text=ae.Title
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.TextColor3=Color3.new(1,1,1)
aj.TextSize=14
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="IconTab"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(1,1,1)
ak.BackgroundTransparency=1
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.5,0)
ak.Size=UDim2.new(0,18,0,18)
ak.Image=T.Icon
function al.Set(am,an)
aj.Text=an
end
return al
end
function ac.AddDiscordInvite(ad,ae)
ae=a:MakeConfig({
NameServer="Night Hub | Offical Server",
Icon="rbxassetid://73451662082403",
InviteLink="https://discord.gg/5H3az7n3"
},ae or{})
local af=Instance.new"Frame"
local ag=Instance.new"UICorner"
local ah=Instance.new"UIStroke"
local ai=Instance.new"Frame"
local aj=Instance.new"TextLabel"
local ak=Instance.new"Frame"
local al=Instance.new"UICorner"
local am=Instance.new"ImageLabel"
local an=Instance.new"UICorner"
local ao=Instance.new"TextLabel"
local ap=Instance.new"Frame"
local aq=Instance.new"UICorner"
local ar=Instance.new"TextLabel"
local as=Instance.new"Frame"
local at=Instance.new"UICorner"
local au=Instance.new"TextLabel"
local av=Instance.new"Frame"
local aw=Instance.new"UICorner"
local ax=Instance.new"TextButton"
local ay=Instance.new"TextLabel"
af.Name="InviteDiscord"
af.Parent=_
af.Active=true
af.BackgroundColor3=Color3.new(1,1,1)
af.BackgroundTransparency=0.949999988079071
af.BorderColor3=Color3.new(0,0,0)
af.BorderSizePixel=0
af.Selectable=true
af.Size=UDim2.new(1,0,0,85)

ag.Parent=af

ah.Parent=af
ah.Transparency=0.75

ai.Name="Feature"
ai.Parent=af
ai.BackgroundColor3=Color3.new(1,1,1)
ai.BackgroundTransparency=1
ai.BorderColor3=Color3.new(0,0,0)
ai.BorderSizePixel=0
ai.Size=UDim2.new(1,0,1,0)

aj.Name="TopTitle"
aj.Parent=ai
aj.BackgroundColor3=Color3.new(1,1,1)
aj.BackgroundTransparency=1
aj.BorderColor3=Color3.new(0,0,0)
aj.BorderSizePixel=0
aj.Position=UDim2.new(0,15,0,14)
aj.Size=UDim2.new(1,-100,0,8)
aj.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
aj.Text="YOU'VE BEEN INVINTED TO JOIN A SERVER"
aj.TextColor3=Color3.new(0.737255,0.737255,0.737255)
aj.TextSize=14
aj.TextWrapped=true
aj.TextXAlignment=Enum.TextXAlignment.Left

ak.Name="LogoDis"
ak.Parent=ai
ak.AnchorPoint=Vector2.new(0,0.5)
ak.BackgroundColor3=Color3.new(0.054902,0.054902,0.054902)
ak.BorderColor3=Color3.new(0,0,0)
ak.BorderSizePixel=0
ak.Position=UDim2.new(0,15,0.649999976,0)
ak.Size=UDim2.new(0,40,0,40)

al.Parent=ak

am.Name="LogoDiscord"
am.Parent=ak
am.BackgroundColor3=Color3.new(1,1,1)
am.BackgroundTransparency=1
am.BorderColor3=Color3.new(0,0,0)
am.BorderSizePixel=0
am.Size=UDim2.new(1,0,1,0)
am.Image=ae.Icon

an.Name="PetBp"
an.Parent=am

ao.Name="Title"
ao.Parent=ai
ao.BackgroundColor3=Color3.new(1,1,1)
ao.BackgroundTransparency=1
ao.BorderColor3=Color3.new(0,0,0)
ao.BorderSizePixel=0
ao.Position=UDim2.new(0,65,0,40)
ao.Size=UDim2.new(1,-100,0,8)
ao.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ao.Text=ae.NameServer
ao.TextColor3=Color3.new(0.784314,0.784314,0.784314)
ao.TextSize=14
ao.TextXAlignment=Enum.TextXAlignment.Left

ap.Name="Dot"
ap.Parent=ai
ap.BackgroundColor3=Color3.new(0.027451,1,0.384314)
ap.BorderColor3=Color3.new(0,0,0)
ap.BorderSizePixel=0
ap.Position=UDim2.new(0,65,0,60)
ap.Size=UDim2.new(0,7,0,7)

aq.Parent=ap
aq.CornerRadius=UDim.new(1,0)

ar.Name="Online"
ar.Parent=ap
ar.BackgroundColor3=Color3.new(1,1,1)
ar.BackgroundTransparency=1
ar.BorderColor3=Color3.new(0,0,0)
ar.BorderSizePixel=0
ar.Position=UDim2.new(0,14,0,-1)
ar.Size=UDim2.new(0,70,0,8)
ar.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ar.Text="2000+ Online"
ar.TextColor3=Color3.new(0.521569,0.521569,0.521569)
ar.TextSize=12

as.Name="Dot_2"
as.Parent=ai
as.BackgroundColor3=Color3.new(0.521569,0.521569,0.521569)
as.BorderColor3=Color3.new(0,0,0)
as.BorderSizePixel=0
as.Position=UDim2.new(0,170,0,60)
as.Size=UDim2.new(0,7,0,7)

at.Parent=as
at.CornerRadius=UDim.new(1,0)

au.Name="Online"
au.Parent=as
au.BackgroundColor3=Color3.new(1,1,1)
au.BackgroundTransparency=1
au.BorderColor3=Color3.new(0,0,0)
au.BorderSizePixel=0
au.Position=UDim2.new(0,14,0,-1)
au.Size=UDim2.new(0,70,0,8)
au.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
au.Text="2000+ Offline"
au.TextColor3=Color3.new(0.521569,0.521569,0.521569)
au.TextSize=12

av.Parent=ai
av.AnchorPoint=Vector2.new(0,0.5)
av.BackgroundColor3=Color3.new(0.054902,0.807843,0.0784314)
av.BorderColor3=Color3.new(0,0,0)
av.BorderSizePixel=0
av.Position=UDim2.new(1,-95,0.600000024,0)
av.Size=UDim2.new(0,80,0,30)

aw.Parent=av
aw.CornerRadius=UDim.new(0,3)

ax.Name="Click"
ax.Parent=av
ax.BackgroundColor3=Color3.new(1,1,1)
ax.BackgroundTransparency=1
ax.BorderColor3=Color3.new(0,0,0)
ax.BorderSizePixel=0
ax.Size=UDim2.new(1,0,1,0)
ax.Font=Enum.Font.SourceSans
ax.Text=""
ax.TextColor3=Color3.new(0,0,0)
ax.TextSize=14

ay.Name="Title"
ay.Parent=av
ay.BackgroundColor3=Color3.new(1,1,1)
ay.BackgroundTransparency=1
ay.BorderColor3=Color3.new(0,0,0)
ay.BorderSizePixel=0
ay.Size=UDim2.new(1,0,1,0)
ay.FontFace=Font.new([[rbxassetid://12187365364]],Enum.FontWeight.Bold,Enum.FontStyle.Normal)
ay.Text="Join Server"
ay.TextColor3=Color3.new(1,1,1)
ay.TextSize=13
ax.Activated:Connect(function()
setclipboard(ae.InviteLink)
end)
end
return ac
end
return Q
end








































































return b
