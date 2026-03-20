--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.6.64  |  2026-03-20  |  Roblox UI Library for scripts
    
    To view the source code, see the `src/` folder on the official GitHub repository.
    
    Author: Footagesus (Footages, .ftgs, oftgs)
    Github: https://github.com/Footagesus/WindUI
    Discord: https://discord.gg/ftgs-development-hub-1300692552005189632
    License: MIT
]]

local a a={cache={}, load=function(b)if not a.cache[b]then a.cache[b]={c=a[b]()}end return a.cache[b].c end}do function a.a()local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"ReplicatedStorage":WaitForChild("GetIcons",99999):InvokeServer())

local function parseIconString(e)
if type(e)=="string"then
local f=e:find":"
if f then
local g=e:sub(1,f-1)
local h=e:sub(f+1)
return g,h
end
end
return nil,e
end

function d.AddIcons(e,f)
if type(e)~="string"or type(f)~="table"then
error"AddIcons: packName must be string, iconsData must be table"
return
end

if not d.Icons[e]then
d.Icons[e]={
Icons={},
Spritesheets={}
}
end

for g,h in pairs(f)do
if type(h)=="number"or(type(h)=="string"and h:match"^rbxassetid://")then
local i=h
if type(h)=="number"then
i="rbxassetid://"..tostring(h)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=Vector2.new(0,0),
ImageRectPosition=Vector2.new(0,0),
Parts=nil
}
d.Icons[e].Spritesheets[i]=i

elseif type(h)=="table"then
if h.Image and h.ImageRectSize and h.ImageRectPosition then
local i=h.Image
if type(i)=="number"then
i="rbxassetid://"..tostring(i)
end

d.Icons[e].Icons[g]={
Image=i,
ImageRectSize=h.ImageRectSize,
ImageRectPosition=h.ImageRectPosition,
Parts=h.Parts
}

if not d.Icons[e].Spritesheets[i]then
d.Icons[e].Spritesheets[i]=i
end
else
warn("AddIcons: Invalid spritesheet data format for icon '"..g.."'")
end
else
warn("AddIcons: Unsupported data type for icon '"..g.."': "..type(h))
end
end
end

function d.SetIconsType(e)
d.IconsType=e
end

local e
function d.Init(f,g)
d.New=f
d.IconThemeTag=g

e=f
return d
end

function d.Icon(f,g,h)
h=h~=false
local i,j=parseIconString(f)

local l=i or g or d.IconsType
local m=j

local p=d.Icons[l]

if p and p.Icons and p.Icons[m]then
return{
p.Spritesheets[tostring(p.Icons[m].Image)],
p.Icons[m],
}
elseif p and p[m]and string.find(p[m],"rbxassetid://")then
return h and{
p[m],
{ImageRectSize=Vector2.new(0,0),ImageRectPosition=Vector2.new(0,0)}
}or p[m]
end
return nil
end

function d.GetIcon(f,g)
return d.Icon(f,g,false)
end


function d.Icon2(f,g,h)
return d.Icon(f,g,true)
end

function d.Image(f)
local g={
Icon=f.Icon or nil,
Type=f.Type,
Colors=f.Colors or{(d.IconThemeTag or Color3.new(1,1,1)),Color3.new(1,1,1)},
Transparency=f.Transparency or{0,0},
Size=f.Size or UDim2.new(0,24,0,24),

IconFrame=nil,
}

local h={}
local i={}

for j,l in next,g.Colors do
h[j]={
ThemeTag=typeof(l)=="string"and l,
Color=typeof(l)=="Color3"and l,
}
end

for j,l in next,g.Transparency do
i[j]={
ThemeTag=typeof(l)=="string"and l,
Value=typeof(l)=="number"and l,
}
end


local j=d.Icon2(g.Icon,g.Type)
local l=typeof(j)=="string"and string.find(j,'rbxassetid://')

if d.New then
local m=e or d.New



local p=m("ImageLabel",{
Size=g.Size,
BackgroundTransparency=1,
ImageColor3=h[1].Color or nil,
ImageTransparency=i[1].Value or nil,
ThemeTag=h[1].ThemeTag and{
ImageColor3=h[1].ThemeTag,
ImageTransparency=i[1].ThemeTag,
},
Image=l and j or j[1],
ImageRectSize=l and nil or j[2].ImageRectSize,
ImageRectOffset=l and nil or j[2].ImageRectPosition,
})


if not l and j[2].Parts then
for r,u in next,j[2].Parts do
local v=d.Icon(u,g.Type)

m("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ImageColor3=h[1+r].Color or nil,
ImageTransparency=i[1+r].Value or nil,
ThemeTag=h[1+r].ThemeTag and{
ImageColor3=h[1+r].ThemeTag,
ImageTransparency=i[1+r].ThemeTag,
},
Image=v[1],
ImageRectSize=v[2].ImageRectSize,
ImageRectOffset=v[2].ImageRectPosition,
Parent=p,
})
end
end

g.IconFrame=p
else
local m=Instance.new"ImageLabel"
m.Size=g.Size
m.BackgroundTransparency=1
m.ImageColor3=h[1].Color
m.ImageTransparency=i[1].Value or nil
m.Image=l and j or j[1]
m.ImageRectSize=l and nil or j[2].ImageRectSize
m.ImageRectOffset=l and nil or j[2].ImageRectPosition


if not l and j[2].Parts then
for p,r in next,j[2].Parts do
local u=d.Icon(r,g.Type)

local v=Instance.New"ImageLabel"
v.Size=UDim2.new(1,0,1,0)
v.BackgroundTransparency=1
v.ImageColor3=h[1+p].Color
v.ImageTransparency=i[1+p].Value or nil
v.Image=u[1]
v.ImageRectSize=u[2].ImageRectSize
v.ImageRectOffset=u[2].ImageRectPosition
v.Parent=m
end
end

g.IconFrame=m
end


return g
end

return d end function a.b()

return{


Primary="Icon",

White=Color3.new(1,1,1),
Black=Color3.new(0,0,0),

Dialog="Accent",

Background="Accent",
BackgroundTransparency=0,
Hover="Text",

PanelBackground="White",
PanelBackgroundTransparency=.95,

WindowBackground="Background",

WindowShadow="Black",


WindowTopbarTitle="Text",
WindowTopbarAuthor="Text",
WindowTopbarIcon="Icon",
WindowTopbarButtonIcon="Icon",

WindowSearchBarBackground="Background",

TabBackground="Hover",
TabBackgroundHover="Hover",
TabBackgroundHoverTransparency=.97,
TabBackgroundActive="Hover",
TabBackgroundActiveTransparency=0.93,
TabText="Text",
TabTextTransparency=0.3,
TabTextTransparencyActive=0,
TabTitle="Text",
TabIcon="Icon",
TabIconTransparency=0.4,
TabIconTransparencyActive=0.1,
TabBorderTransparency=1,
TabBorderTransparencyActive=0.75,
TabBorder="White",


ElementBackground="Text",
ElementTitle="Text",
ElementDesc="Text",
ElementIcon="Icon",

PopupBackground="Background",
PopupBackgroundTransparency="BackgroundTransparency",
PopupTitle="Text",
PopupContent="Text",
PopupIcon="Icon",

DialogBackground="Background",
DialogBackgroundTransparency="BackgroundTransparency",
DialogTitle="Text",
DialogContent="Text",
DialogIcon="Icon",

Toggle="Button",
ToggleBar="White",

Checkbox="Primary",
CheckboxIcon="White",
CheckboxBorder="White",
CheckboxBorderTransparency=.75,

SliderIcon="Icon",

Slider="Primary",
SliderThumb="White",
SliderIconFrom="SliderIcon",
SliderIconTo="SliderIcon",

Tooltip=Color3.fromHex"4C4C4C",
TooltipText="White",
TooltipSecondary="Primary",
TooltipSecondaryText="White",

TabSectionIcon="Icon",

SectionIcon="Icon",

SectionExpandIcon="White",
SectionExpandIconTransparency=.4,
SectionBox="White",
SectionBoxTransparency=.95,
SectionBoxBorder="White",
SectionBoxBorderTransparency=.75,
SectionBoxBackground="White",
SectionBoxBackgroundTransparency=.95,

SearchBarBorder="White",
SearchBarBorderTransparency=.75,

Notification="Background",
NotificationTitle="Text",
NotificationTitleTransparency=0,
NotificationContent="Text",
NotificationContentTransparency=.4,
NotificationDuration="White",
NotificationDurationTransparency=.95,
NotificationBorder="White",
NotificationBorderTransparency=.75,

DropdownTabBorder="White",

LabelBackground="White",
LabelBackgroundTransparency=.95,
}end function a.c()


local b=(cloneref or clonereference or function(b)return b end)

local d=b(game:GetService"RunService")
local e=b(game:GetService"UserInputService")
local f=b(game:GetService"TweenService")
local g=b(game:GetService"LocalizationService")
local h=b(game:GetService"HttpService")local i=

d.Heartbeat

local j="https://raw.githubusercontent.com/Footagesus/Icons/main/Main-v2.lua"

local l
if d:IsStudio()or not writefile then
l=a.load'a'
else
l=loadstring(
game.HttpGetAsync and game:HttpGetAsync(j)
or h:GetAsync(j)
)()
end

l.SetIconsType"lucide"

local m

local p={
Font="rbxassetid://12187365364",
Localization=nil,
CanDraggable=true,
Theme=nil,
Themes=nil,
Icons=l,
Signals={},
Objects={},
LocalizationObjects={},
FontObjects={},
Language=string.match(g.SystemLocaleId,"^[a-z]+"),
Request=http_request or(syn and syn.request)or request,
DefaultProperties={
ScreenGui={
ResetOnSpawn=false,
ZIndexBehavior="Sibling",
},
CanvasGroup={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
Frame={
BorderSizePixel=0,
BackgroundColor3=Color3.new(1,1,1),
},
TextLabel={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
RichText=true,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},TextButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
Text="",
AutoButtonColor=false,
TextColor3=Color3.new(1,1,1),
TextSize=14,
},
TextBox={
BackgroundColor3=Color3.new(1,1,1),
BorderColor3=Color3.new(0,0,0),
ClearTextOnFocus=false,
Text="",
TextColor3=Color3.new(0,0,0),
TextSize=14,
},
ImageLabel={
BackgroundTransparency=1,
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
},
ImageButton={
BackgroundColor3=Color3.new(1,1,1),
BorderSizePixel=0,
AutoButtonColor=false,
},
UIListLayout={
SortOrder="LayoutOrder",
},
ScrollingFrame={
ScrollBarImageTransparency=1,
BorderSizePixel=0,
},
VideoFrame={
BorderSizePixel=0,
}
},
Colors={
Red="#e53935",
Orange="#f57c00",
Green="#43a047",
Blue="#039be5",
White="#ffffff",
Grey="#484848",
},
ThemeFallbacks=a.load'b',
Shapes={Square=
"rbxassetid://82909646051652",
["Square-Outline"]="rbxassetid://72946211851948",Squircle=

"rbxassetid://80999662900595",SquircleOutline=
"rbxassetid://117788349049947",
["Squircle-Outline"]="rbxassetid://117817408534198",SquircleOutline2=

"rbxassetid://117817408534198",

["Shadow-sm"]="rbxassetid://84825982946844",

["Squircle-TL-TR"]="rbxassetid://73569156276236",
["Squircle-BL-BR"]="rbxassetid://93853842912264",
["Squircle-TL-TR-Outline"]="rbxassetid://136702870075563",
["Squircle-BL-BR-Outline"]="rbxassetid://75035847706564",

["Glass-0.7"]="rbxassetid://79047752995006",
["Glass-1"]="rbxassetid://97324581055162",
["Glass-1.4"]="rbxassetid://95071123641270",
}
}

function p.Init(r)
m=r
end

function p.AddSignal(r,u)
local v=r:Connect(u)
table.insert(p.Signals,v)
return v
end

function p.DisconnectAll()
for r,u in next,p.Signals do
local v=table.remove(p.Signals,r)
v:Disconnect()
end
end

function p.SafeCallback(r,...)
if not r then
return
end

local u,v=pcall(r,...)
if not u then
if m and m.Window and m.Window.Debug then local
x, z=v:find":%d+: "

warn("[ WindUI: DEBUG Mode ] "..v)

return m:Notify{
Title="DEBUG Mode: Error",
Content=not z and v or v:sub(z+1),
Duration=8,
}
end
end
end

function p.Gradient(r,u)
if m and m.Gradient then
return m:Gradient(r,u)
end

local v={}
local x={}

for z,A in next,r do
local B=tonumber(z)
if B then
B=math.clamp(B/100,0,1)
table.insert(v,ColorSequenceKeypoint.new(B,A.Color))
table.insert(x,NumberSequenceKeypoint.new(B,A.Transparency or 0))
end
end

table.sort(v,function(z,A)return z.Time<A.Time end)
table.sort(x,function(z,A)return z.Time<A.Time end)

if#v<2 then
error"ColorSequence requires at least 2 keypoints"
end

local z={
Color=ColorSequence.new(v),
Transparency=NumberSequence.new(x),
}

if u then
for A,B in pairs(u)do
z[A]=B
end
end

return z
end

function p.SetTheme(r)
p.Theme=r
p.UpdateTheme(nil,false)
end

function p.AddFontObject(r)
table.insert(p.FontObjects,r)
p.UpdateFont(p.Font)
end

function p.UpdateFont(r)
p.Font=r
for u,v in next,p.FontObjects do
v.FontFace=Font.new(r,v.FontFace.Weight,v.FontFace.Style)
end
end

function p.GetThemeProperty(r,u)
local function getValue(v,x)
local z=x[v]

if z==nil then return nil end

if typeof(z)=="string"and string.sub(z,1,1)=="#"then
return Color3.fromHex(z)
end

if typeof(z)=="Color3"then
return z
end

if typeof(z)=="number"then
return z
end

if typeof(z)=="table"and z.Color and z.Transparency then
return z
end

if typeof(z)=="function"then
return z()
end

return z
end

local v=getValue(r,u)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local x=p.GetThemeProperty(v,u)
if x~=nil then
return x
end
else
return v
end
end

local x=p.ThemeFallbacks[r]
if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,u)
else
return getValue(r,{[r]=x})
end
end

v=getValue(r,p.Themes.Dark)
if v~=nil then
if typeof(v)=="string"and string.sub(v,1,1)~="#"then
local z=p.GetThemeProperty(v,p.Themes.Dark)
if z~=nil then
return z
end
else
return v
end
end

if x~=nil then
if typeof(x)=="string"and string.sub(x,1,1)~="#"then
return p.GetThemeProperty(x,p.Themes.Dark)
else
return getValue(r,{[r]=x})
end
end

return nil
end

function p.AddThemeObject(r,u)
if p.Objects[r]then
for v,x in pairs(u)do
p.Objects[r].Properties[v]=x
end
else
p.Objects[r]={Object=r,Properties=u}
end

p.UpdateTheme(r,false)
return r
end

function p.AddLangObject(r)
local u=p.LocalizationObjects[r]
if not u then return end

local v=u.Object

p.SetLangForObject(r)

return v
end

function p.UpdateTheme(r,u,v,x,z,A)
local function ApplyTheme(B)
for C,F in pairs(B.Properties or{})do
local G=p.GetThemeProperty(F,p.Theme)
if G~=nil then
if typeof(G)=="Color3"then
local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end

if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
elseif typeof(G)=="table"and G.Color and G.Transparency then
B.Object[C]=Color3.new(1,1,1)

local H=B.Object:FindFirstChild"LibraryGradient"
if not H then
H=Instance.new"UIGradient"
H.Name="LibraryGradient"
H.Parent=B.Object
end

H.Color=G.Color
H.Transparency=G.Transparency

for J,L in pairs(G)do
if J~="Color"and J~="Transparency"and H[J]~=nil then
H[J]=L
end
end
elseif typeof(G)=="number"then
if v then
p.Tween(
B.Object,
x or 0.2,
{[C]=G},
z or Enum.EasingStyle.Quint,
A or Enum.EasingDirection.Out
):Play()
elseif u then
p.Tween(B.Object,0.08,{[C]=G}):Play()
else
B.Object[C]=G
end
end
else

local H=B.Object:FindFirstChild"LibraryGradient"
if H then
H:Destroy()
end
end
end
end

if r then
local B=p.Objects[r]
if B then
ApplyTheme(B)
end
else
for B,C in pairs(p.Objects)do
ApplyTheme(C)
end
end
end


function p.SetThemeTag(r,u,v,x,z)
p.AddThemeObject(r,u)
p.UpdateTheme(r,false,true,v,x,z)
end

function p.SetLangForObject(r)
if p.Localization and p.Localization.Enabled then
local u=p.LocalizationObjects[r]
if not u then return end

local v=u.Object
local x=u.TranslationId

local z=p.Localization.Translations[p.Language]
if z and z[x]then
v.Text=z[x]
else
local A=p.Localization and p.Localization.Translations and p.Localization.Translations.en or nil
if A and A[x]then
v.Text=A[x]
else
v.Text="["..x.."]"
end
end
end
end

function p.ChangeTranslationKey(r,u,v)
if p.Localization and p.Localization.Enabled then
local x=string.match(v,"^"..p.Localization.Prefix.."(.+)")
if x then
for z,A in ipairs(p.LocalizationObjects)do
if A.Object==u then
A.TranslationId=x
p.SetLangForObject(z)
return
end
end

table.insert(p.LocalizationObjects,{
TranslationId=x,
Object=u
})
p.SetLangForObject(#p.LocalizationObjects)
end
end
end

function p.UpdateLang(r)
if r then
p.Language=r
end

for u=1,#p.LocalizationObjects do
local v=p.LocalizationObjects[u]
if v.Object and v.Object.Parent~=nil then
p.SetLangForObject(u)
else
p.LocalizationObjects[u]=nil
end
end
end

function p.SetLanguage(r)
p.Language=r
p.UpdateLang()
end

function p.Icon(r,u)
return l.Icon2(r,nil,u~=false)
end

function p.AddIcons(r,u)
return l.AddIcons(r,u)
end

function p.New(r,u,v)
local x=Instance.new(r)

for z,A in next,p.DefaultProperties[r]or{}do
x[z]=A
end

for z,A in next,u or{}do
if z~="ThemeTag"then
x[z]=A
end
if p.Localization and p.Localization.Enabled and z=="Text"then
local B=string.match(A,"^"..p.Localization.Prefix.."(.+)")
if B then
local C=#p.LocalizationObjects+1
p.LocalizationObjects[C]={TranslationId=B,Object=x}

p.SetLangForObject(C)
end
end
end

for z,A in next,v or{}do
A.Parent=x
end

if u and u.ThemeTag then
p.AddThemeObject(x,u.ThemeTag)
end
if u and u.FontFace then
p.AddFontObject(x)
end
return x
end

function p.Tween(r,u,v,...)
return f:Create(r,TweenInfo.new(u,...),v)
end

function p.NewRoundFrame(r,u,v,x,z,A)
local function getImageForType(B)
return p.Shapes[B]
end

local function getSliceCenterForType(B)
return not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},B)and Rect.new(256
,256
,256
,256

)or Rect.new(512,512,512,512)
end

local B=p.New(z and"ImageButton"or"ImageLabel",{
Image=getImageForType(u),
ScaleType="Slice",
SliceCenter=getSliceCenterForType(u),
SliceScale=1,
BackgroundTransparency=1,
ThemeTag=v.ThemeTag and v.ThemeTag
},x)

for C,F in pairs(v or{})do
if C~="ThemeTag"then
B[C]=F
end
end

local function UpdateSliceScale(C)
local F=not table.find({"Shadow-sm","Glass-0.7","Glass-1","Glass-1.4"},u)and(C/(256))or(C/512)
B.SliceScale=math.max(F,0.0001)
end

local C={}

function C.SetRadius(F,G)
UpdateSliceScale(G)
end

function C.SetType(F,G)
u=G
B.Image=getImageForType(G)
B.SliceCenter=getSliceCenterForType(G)
UpdateSliceScale(r)
end

function C.UpdateShape(F,G,H)
if H then
u=H
B.Image=getImageForType(H)
B.SliceCenter=getSliceCenterForType(H)
end
if G then
r=G
end
UpdateSliceScale(r)
end

function C.GetRadius(F)
return r
end

function C.GetType(F)
return u
end

UpdateSliceScale(r)

return B,A and C or nil
end

local r=p.New local u=
p.Tween

function p.SetDraggable(v)
p.CanDraggable=v
end



function p.Drag(v,x,z)
local A
local B,C,F
local G={
CanDraggable=true
}

if not x or typeof(x)~="table"then
x={v}
end

local function update(H)
if not B or not G.CanDraggable then return end

local J=H.Position-C
p.Tween(v,0.02,{Position=UDim2.new(
F.X.Scale,F.X.Offset+J.X,
F.Y.Scale,F.Y.Offset+J.Y
)}):Play()
end

for H,J in pairs(x)do
J.InputBegan:Connect(function(L)
if(L.UserInputType==Enum.UserInputType.MouseButton1 or L.UserInputType==Enum.UserInputType.Touch)and G.CanDraggable then
if A==nil then
A=J
B=true
C=L.Position
F=v.Position

if z and typeof(z)=="function"then
z(true,A)
end

L.Changed:Connect(function()
if L.UserInputState==Enum.UserInputState.End then
B=false
A=nil

if z and typeof(z)=="function"then
z(false,nil)
end
end
end)
end
end
end)

J.InputChanged:Connect(function(L)
if B and A==J then
if L.UserInputType==Enum.UserInputType.MouseMovement or L.UserInputType==Enum.UserInputType.Touch then
update(L)
end
end
end)
end

e.InputChanged:Connect(function(H)
if B and A~=nil then
if H.UserInputType==Enum.UserInputType.MouseMovement or H.UserInputType==Enum.UserInputType.Touch then
update(H)
end
end
end)

function G.Set(H,J)
G.CanDraggable=J
end

return G
end


l.Init(r,"Icon")


function p.SanitizeFilename(v)
local x=v:match"([^/]+)$"or v

x=x:gsub("%.[^%.]+$","")

x=x:gsub("[^%w%-_]","_")

if#x>50 then
x=x:sub(1,50)
end

return x
end

function p.Image(v,x,z,A,B,C,F,G)
A=A or"Temp"
x=p.SanitizeFilename(x)

local H=r("Frame",{
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
},{
r("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
ScaleType="Crop",
ThemeTag=(p.Icon(v)or F)and{
ImageColor3=C and(G or"Icon")or nil
}or nil,
},{
r("UICorner",{
CornerRadius=UDim.new(0,z)
})
})
})
if p.Icon(v)then
H.ImageLabel:Destroy()

local J=l.Image{
Icon=v,
Size=UDim2.new(1,0,1,0),
Colors={
(C and(G or"Icon")or false),
"Button"
}
}.IconFrame
J.Parent=H
elseif string.find(v,"http")then
local J="WindUI/"..A.."/assets/."..B.."-"..x..".png"
local L,M=pcall(function()
task.spawn(function()
local L=p.Request and p.Request{
Url=v,
Method="GET",
}.Body or{}

if not d:IsStudio()and writefile then writefile(J,L)end


local M,N=pcall(getcustomasset,J)
if M then
H.ImageLabel.Image=N
else
warn(string.format("[ WindUI.Creator ] Failed to load custom asset '%s': %s",J,tostring(N)))
H:Destroy()

return
end
end)
end)
if not L then
warn("[ WindUI.Creator ]  '"..identifyexecutor()or"Studio".."' doesnt support the URL Images. Error: "..M)

H:Destroy()
end
elseif v==""then
H.Visible=false
else
H.ImageLabel.Image=v
end

return H
end



function p.Color3ToHSB(v)
local x,z,A=v.R,v.G,v.B
local B=math.max(x,z,A)
local C=math.min(x,z,A)
local F=B-C

local G=0
if F~=0 then
if B==x then
G=(z-A)/F%6
elseif B==z then
G=(A-x)/F+2
else
G=(x-z)/F+4
end
G=G*60
else
G=0
end

local H=(B==0)and 0 or(F/B)
local J=B

return{
h=math.floor(G+0.5),
s=H,
b=J
}
end

function p.GetPerceivedBrightness(v)
local x=v.R
local z=v.G
local A=v.B
return 0.299*x+0.587*z+0.114*A
end

function p.GetTextColorForHSB(v,x)
local z=p.Color3ToHSB(v)local
A, B, C=z.h, z.s, z.b
if p.GetPerceivedBrightness(v)>(x or 0.5)then
return Color3.fromHSV(A/360,0,0.05)
else
return Color3.fromHSV(A/360,0,0.98)
end
end

function p.GetAverageColor(v)
local x,z,A=0,0,0
local B=v.Color.Keypoints
for C,F in ipairs(B)do

x=x+F.Value.R
z=z+F.Value.G
A=A+F.Value.B
end
local C=#B
return Color3.new(x/C,z/C,A/C)
end

function p.GenerateUniqueID(v)
return h:GenerateGUID(false)
end

return p end function a.d()

local b={}







function b.New(d,e,f)
local g={
Enabled=e.Enabled or false,
Translations=e.Translations or{},
Prefix=e.Prefix or"loc:",
DefaultLanguage=e.DefaultLanguage or"en"
}

f.Localization=g

return g
end



return b end function a.e()
local b=(cloneref or clonereference or function(b)
return b
end)

local d=a.load'c'
local e=d.New
local f=d.Tween

local g=b(game:GetService"Players")
local h=g.LocalPlayer
local j=workspace.CurrentCamera

local l={
UICorner=30,
UIPadding=12,
NotificationIndex=0,
Notifications={},
}

local function GetViewportX()
return(j and j.ViewportSize.X)or 800
end

local function GetHolderWidth()
local m=GetViewportX()
return math.clamp(math.floor(m*0.32),260,332)
end

local function GetTopOffset(m)
return m and 52 or 10
end

local function GetUserAvatarByUserId(m)
local p,r=pcall(function()
return g:GetUserThumbnailAsync(
m or 1,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size150x150
)
end)

if p and r then
return r
end

return"rbxasset://textures/ui/GuiImagePlaceholder.png"
end

local function GetDefaultAvatar()
return GetUserAvatarByUserId(h and h.UserId or 1)
end

local function ResolveAvatar(m)
if m==false then
return nil
end

if m==nil or m==true then
return GetDefaultAvatar()
end

if typeof(m)=="Instance"and m:IsA"Player"then
return GetUserAvatarByUserId(m.UserId)
end

if typeof(m)=="number"then
return GetUserAvatarByUserId(m)
end

if typeof(m)=="string"then
local p=tonumber(m)
if p then
return GetUserAvatarByUserId(p)
end

return m
end

return GetDefaultAvatar()
end

local function CreateGlowBlob(m,p,r,u)
return e("ImageLabel",{
BackgroundTransparency=1,
Image="rbxassetid://1316045217",
ImageColor3=r,
ImageTransparency=u,
ScaleType="Fit",
Size=m,
Position=p,
})
end

function l.Init(m)
local p={
Lower=false
}

local function ApplyHolderLayout()
local r=GetTopOffset(p.Lower)

p.Frame.Position=UDim2.new(0.5,0,0,r)
p.Frame.Size=UDim2.new(0,GetHolderWidth(),1,-(r+20))
end

function p.SetLower(r)
p.Lower=r
ApplyHolderLayout()
end

p.Frame=e("Frame",{
Position=UDim2.new(0.5,0,0,GetTopOffset(false)),
AnchorPoint=Vector2.new(0.5,0),
Size=UDim2.new(0,GetHolderWidth(),1,-(GetTopOffset(false)+20)),
Parent=m,
BackgroundTransparency=1,
ClipsDescendants=false,
},{
e("UIListLayout",{
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
VerticalAlignment="Top",
Padding=UDim.new(0,8),
}),
})

if j then
d.AddSignal(j:GetPropertyChangedSignal"ViewportSize",function()
ApplyHolderLayout()
end)
end

return p
end

function l.New(m)
local p={
Title=m.Title or"Notification",
Content=m.Content or nil,
Icon=m.Icon or nil,
IconThemed=m.IconThemed,
Avatar=m.Avatar,
TimeText=m.TimeText or"now",
Background=m.Background,
BackgroundImageTransparency=m.BackgroundImageTransparency or 1,
Duration=m.Duration or 5,
CanClose=m.CanClose~=false,
UIElements={},
Closed=false,
}

l.NotificationIndex=l.NotificationIndex+1
l.Notifications[l.NotificationIndex]=p

GetHolderWidth()
local r=44
local u=14
local v=72

local x=ResolveAvatar(p.Avatar)
local z=x~=nil

local A
if p.Icon then
A=d.Image(
p.Icon,
p.Title..":"..p.Icon,
0,
m.Window,
"NotificationBadge",
true,
p.IconThemed
)
A.Size=UDim2.new(0,u,0,u)
A.AnchorPoint=Vector2.new(0.5,0.5)
A.Position=UDim2.new(0.5,0,0.5,0)
end

local B=d.NewRoundFrame(l.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,v),
AnchorPoint=Vector2.new(0.5,0),
Position=UDim2.new(0.5,0,0,-12),
ImageColor3=Color3.fromRGB(205,210,220),
ImageTransparency=1,
Parent=nil,
},{
d.NewRoundFrame(l.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.fromRGB(255,255,255),
ImageTransparency=0.66,
}),

d.NewRoundFrame(l.UICorner,"Squircle",{
Size=UDim2.new(1,-2,1,-2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="InnerGlass",
ImageColor3=Color3.fromRGB(170,176,188),
ImageTransparency=0.88,
}),

e("Frame",{
Name="TopLine",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.94,
Size=UDim2.new(1,-18,0,1),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
},{
e("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),

e("Frame",{
Name="BottomShade",
BackgroundColor3=Color3.fromRGB(10,10,14),
BackgroundTransparency=0.985,
Size=UDim2.new(1,-8,0,18),
Position=UDim2.new(0.5,0,1,-4),
AnchorPoint=Vector2.new(0.5,1),
},{
e("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),

CreateGlowBlob(
UDim2.new(0,54,0,54),
UDim2.new(1,-74,0,6),
Color3.fromRGB(255,255,255),
0.95
),

CreateGlowBlob(
UDim2.new(0,38,0,38),
UDim2.new(1,-34,0,14),
Color3.fromRGB(240,244,255),
0.965
),

CreateGlowBlob(
UDim2.new(0,80,0,52),
UDim2.new(0.5,-18,0,-18),
Color3.fromRGB(255,255,255),
0.975
),

e("ImageLabel",{
Name="Background",
Image=p.Background,
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
ScaleType="Crop",
ImageTransparency=p.BackgroundImageTransparency,
Visible=p.Background~=nil,
},{
e("UICorner",{
CornerRadius=UDim.new(0,l.UICorner),
}),
}),

e("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
},{
e("UIPadding",{
PaddingTop=UDim.new(0,l.UIPadding),
PaddingLeft=UDim.new(0,l.UIPadding),
PaddingRight=UDim.new(0,l.UIPadding),
PaddingBottom=UDim.new(0,l.UIPadding),
}),

e("Frame",{
Name="AvatarHolder",
BackgroundTransparency=1,
Size=UDim2.new(0,z and r or 0,0,r),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Visible=z,
},{
e("ImageLabel",{
Name="Avatar",
Image=x or"",
BackgroundTransparency=1,
Size=UDim2.new(0,r,0,r),
ScaleType="Crop",
},{
e("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),

e("Frame",{
Name="BadgeBack",
Size=UDim2.new(0,u+4,0,u+4),
Position=UDim2.new(1,2,1,2),
AnchorPoint=Vector2.new(1,1),
BackgroundColor3=Color3.fromRGB(24,24,28),
BackgroundTransparency=0.18,
Visible=A~=nil,
ZIndex=6,
},{
e("UICorner",{
CornerRadius=UDim.new(1,0),
}),
e("UIStroke",{
Color=Color3.new(1,1,1),
Transparency=0.55,
Thickness=1,
}),
A,
}),
}),

e("TextLabel",{
Name="Time",
Text=p.TimeText,
BackgroundTransparency=1,
Size=UDim2.new(0,48,0,18),
Position=UDim2.new(1,0,0,2),
AnchorPoint=Vector2.new(1,0),
TextXAlignment="Right",
TextYAlignment="Top",
TextSize=12,
Font=Enum.Font.BuilderSansMedium,
TextColor3=Color3.fromRGB(245,246,250),
TextTransparency=0.12,
}),

e("Frame",{
Name="TextContainer",
BackgroundTransparency=1,
Size=UDim2.new(1,-((z and(r+10)or 0)+54),0,38),
Position=UDim2.new(0,z and(r+10)or 0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
},{
e("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
}),

e("TextLabel",{
Name="Title",
Text=p.Title,
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,18),
TextWrapped=false,
TextTruncate="AtEnd",
TextXAlignment="Left",
TextYAlignment="Center",
TextSize=15,
Font=Enum.Font.BuilderSansBold,
TextColor3=Color3.fromRGB(248,248,251),
}),

e("TextLabel",{
Name="Content",
Text=p.Content or"",
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,18),
TextWrapped=false,
TextTruncate="AtEnd",
TextXAlignment="Left",
TextYAlignment="Center",
TextSize=14,
Font=Enum.Font.BuilderSansMedium,
TextColor3=Color3.fromRGB(239,240,244),
TextTransparency=0.05,
Visible=p.Content~=nil,
}),
}),
}),
})

local C
if p.CanClose then
C=e("TextButton",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
Parent=B,
})
end

local F=e("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="None",
Parent=m.Holder,
ClipsDescendants=false,
},{
B,
})

p.UIElements.Main=B
p.UIElements.MainContainer=F

function p.Close(G)
if p.Closed then
return
end

p.Closed=true

f(F,0.24,{
Size=UDim2.new(1,0,0,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

f(B,0.24,{
Position=UDim2.new(0.5,0,0,-10),
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.25)
if F then
F:Destroy()
end
end

task.spawn(function()
task.wait()

F.Size=UDim2.new(1,0,0,0)
B.Position=UDim2.new(0.5,0,0,-10)
B.ImageTransparency=1

f(F,0.26,{
Size=UDim2.new(1,0,0,v),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

f(B,0.26,{
Position=UDim2.new(0.5,0,0,0),
ImageTransparency=0.72,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if p.Duration and p.Duration>0 then
task.wait(p.Duration)
p:Close()
end
end)

if C then
d.AddSignal(C.MouseButton1Click,function()
p:Close()
end)
end

return p
end

return l end function a.f()












local b=4294967296;local d=b-1;local function c(e,f)local g,h=0,1;while e~=0 or f~=0 do local j,l=e%2,f%2;local m=(j+l)%2;g=g+m*h;e=math.floor(e/2)f=math.floor(f/2)h=h*2 end;return g%b end;local function k(e,f,g,...)local h;if f then e=e%b;f=f%b;h=c(e,f)if g then h=k(h,g,...)end;return h elseif e then return e%b else return 0 end end;local function n(e,f,g,...)local h;if f then e=e%b;f=f%b;h=(e+f-c(e,f))/2;if g then h=n(h,g,...)end;return h elseif e then return e%b else return d end end;local function o(e)return d-e end;local function q(e,f)if f<0 then return lshift(e,-f)end;return math.floor(e%4294967296/2^f)end;local function s(e,f)if f>31 or f<-31 then return 0 end;return q(e%b,f)end;local function lshift(e,f)if f<0 then return s(e,-f)end;return e*2^f%4294967296 end;local function t(e,f)e=e%b;f=f%32;local g=n(e,2^f-1)return s(e,f)+lshift(g,32-f)end;local e={0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}local function w(f)return string.gsub(f,".",function(g)return string.format("%02x",string.byte(g))end)end;local function y(f,g)local h=""for j=1,g do local l=f%256;h=string.char(l)..h;f=(f-l)/256 end;return h end;local function D(f,g)local h=0;for j=g,g+3 do h=h*256+string.byte(f,j)end;return h end;local function E(f,g)local h=64-(g+9)%64;g=y(8*g,8)f=f.."\128"..string.rep("\0",h)..g;assert(#f%64==0)return f end;local function I(f)f[1]=0x6a09e667;f[2]=0xbb67ae85;f[3]=0x3c6ef372;f[4]=0xa54ff53a;f[5]=0x510e527f;f[6]=0x9b05688c;f[7]=0x1f83d9ab;f[8]=0x5be0cd19;return f end;local function K(f,g,h)local j={}for l=1,16 do j[l]=D(f,g+(l-1)*4)end;for l=17,64 do local m=j[l-15]local p=k(t(m,7),t(m,18),s(m,3))m=j[l-2]j[l]=(j[l-16]+p+j[l-7]+k(t(m,17),t(m,19),s(m,10)))%b end;local l,m,p,r,u,v,x,z=h[1],h[2],h[3],h[4],h[5],h[6],h[7],h[8]for A=1,64 do local B=k(t(l,2),t(l,13),t(l,22))local C=k(n(l,m),n(l,p),n(m,p))local F=(B+C)%b;local G=k(t(u,6),t(u,11),t(u,25))local H=k(n(u,v),n(o(u),x))local J=(z+G+H+e[A]+j[A])%b;z=x;x=v;v=u;u=(r+J)%b;r=p;p=m;m=l;l=(J+F)%b end;h[1]=(h[1]+l)%b;h[2]=(h[2]+m)%b;h[3]=(h[3]+p)%b;h[4]=(h[4]+r)%b;h[5]=(h[5]+u)%b;h[6]=(h[6]+v)%b;h[7]=(h[7]+x)%b;h[8]=(h[8]+z)%b end;local function Z(f)f=E(f,#f)local g=I{}for h=1,#f,64 do K(f,h,g)end;return w(y(g[1],4)..y(g[2],4)..y(g[3],4)..y(g[4],4)..y(g[5],4)..y(g[6],4)..y(g[7],4)..y(g[8],4))end;local f;local g={["\\"]="\\",["\""]="\"",["\b"]="b",["\f"]="f",["\n"]="n",["\r"]="r",["\t"]="t"}local h={["/"]="/"}for j,l in pairs(g)do h[l]=j end;local j=function(j)return"\\"..(g[j]or string.format("u%04x",j:byte()))end;local l=function(l)return"null"end;local m=function(m,p)local r={}p=p or{}if p[m]then error"circular reference"end;p[m]=true;if rawget(m,1)~=nil or next(m)==nil then local u=0;for v in pairs(m)do if type(v)~="number"then error"invalid table: mixed or invalid key types"end;u=u+1 end;if u~=#m then error"invalid table: sparse array"end;for v,x in ipairs(m)do table.insert(r,f(x,p))end;p[m]=nil;return"["..table.concat(r,",").."]"else for u,v in pairs(m)do if type(u)~="string"then error"invalid table: mixed or invalid key types"end;table.insert(r,f(u,p)..":"..f(v,p))end;p[m]=nil;return"{"..table.concat(r,",").."}"end end;local p=function(p)return'"'..p:gsub('[%z\1-\31\\"]',j)..'"'end;local r=function(r)if r~=r or r<=-math.huge or r>=math.huge then error("unexpected number value '"..tostring(r).."'")end;return string.format("%.14g",r)end;local u={["nil"]=l,table=m,string=p,number=r,boolean=tostring}f=function(v,x)local z=type(v)local A=u[z]if A then return A(v,x)end;error("unexpected type '"..z.."'")end;local v=function(v)return f(v)end;local x;local z=function(...)local z={}for A=1,select("#",...)do z[select(A,...)]=true end;return z end;local A=z(" ","\t","\r","\n")local B=z(" ","\t","\r","\n","]","}",",")local C=z("\\","/",'"',"b","f","n","r","t","u")local F=z("true","false","null")local G={["true"]=true,["false"]=false,null=nil}local H=function(H,J,L,M)for N=J,#H do if L[H:sub(N,N)]~=M then return N end end;return#H+1 end;local J=function(J,L,M)local N=1;local O=1;for P=1,L-1 do O=O+1;if J:sub(P,P)=="\n"then N=N+1;O=1 end end;error(string.format("%s at line %d col %d",M,N,O))end;local L=function(L)local M=math.floor;if L<=0x7f then return string.char(L)elseif L<=0x7ff then return string.char(M(L/64)+192,L%64+128)elseif L<=0xffff then return string.char(M(L/4096)+224,M(L%4096/64)+128,L%64+128)elseif L<=0x10ffff then return string.char(M(L/262144)+240,M(L%262144/4096)+128,M(L%4096/64)+128,L%64+128)end;error(string.format("invalid unicode codepoint '%x'",L))end;local M=function(M)local N=tonumber(M:sub(1,4),16)local O=tonumber(M:sub(7,10),16)if O then return L((N-0xd800)*0x400+O-0xdc00+0x10000)else return L(N)end end;local N=function(N,O)local P=""local Q=O+1;local R=Q;while Q<=#N do local S=N:byte(Q)if S<32 then J(N,Q,"control character in string")elseif S==92 then P=P..N:sub(R,Q-1)Q=Q+1;local T=N:sub(Q,Q)if T=="u"then local U=N:match("^[dD][89aAbB]%x%x\\u%x%x%x%x",Q+1)or N:match("^%x%x%x%x",Q+1)or J(N,Q-1,"invalid unicode escape in string")P=P..M(U)Q=Q+#U else if not C[T]then J(N,Q-1,"invalid escape char '"..T.."' in string")end;P=P..h[T]end;R=Q+1 elseif S==34 then P=P..N:sub(R,Q-1)return P,Q+1 end;Q=Q+1 end;J(N,O,"expected closing quote for string")end;local O=function(O,P)local Q=H(O,P,B)local R=O:sub(P,Q-1)local S=tonumber(R)if not S then J(O,P,"invalid number '"..R.."'")end;return S,Q end;local P=function(P,Q)local R=H(P,Q,B)local S=P:sub(Q,R-1)if not F[S]then J(P,Q,"invalid literal '"..S.."'")end;return G[S],R end;local Q=function(Q,R)local S={}local T=1;R=R+1;while 1 do local U;R=H(Q,R,A,true)if Q:sub(R,R)=="]"then R=R+1;break end;U,R=x(Q,R)S[T]=U;T=T+1;R=H(Q,R,A,true)local V=Q:sub(R,R)R=R+1;if V=="]"then break end;if V~=","then J(Q,R,"expected ']' or ','")end end;return S,R end;local R=function(R,S)local T={}S=S+1;while 1 do local U,V;S=H(R,S,A,true)if R:sub(S,S)=="}"then S=S+1;break end;if R:sub(S,S)~='"'then J(R,S,"expected string for key")end;U,S=x(R,S)S=H(R,S,A,true)if R:sub(S,S)~=":"then J(R,S,"expected ':' after key")end;S=H(R,S+1,A,true)V,S=x(R,S)T[U]=V;S=H(R,S,A,true)local W=R:sub(S,S)S=S+1;if W=="}"then break end;if W~=","then J(R,S,"expected '}' or ','")end end;return T,S end;local S={['"']=N,["0"]=O,["1"]=O,["2"]=O,["3"]=O,["4"]=O,["5"]=O,["6"]=O,["7"]=O,["8"]=O,["9"]=O,["-"]=O,t=P,f=P,n=P,["["]=Q,["{"]=R}x=function(T,U)local V=T:sub(U,U)local W=S[V]if W then return W(T,U)end;J(T,U,"unexpected character '"..V.."'")end;local T=function(T)if type(T)~="string"then error("expected argument of type string, got "..type(T))end;local U,V=x(T,H(T,1,A,true))V=H(T,V,A,true)if V<=#T then J(T,V,"trailing garbage")end;return U end;
local U,V,W=v,T,Z;





local X={}

local Y=(cloneref or clonereference or function(Y)return Y end)


function X.New(_,aa)

local ab=_;
local ac=aa;
local ad=true;


local ae=function(ae)end;


repeat task.wait(1)until game:IsLoaded();


local af=false;
local ag,ah,ai,aj,ak,al,am,an,ao=setclipboard or toclipboard,request or http_request or syn_request,string.char,tostring,string.sub,os.time,math.random,math.floor,gethwid or function()return Y(game:GetService"Players").LocalPlayer.UserId end
local ap,aq="",0;


local ar="https://api.platoboost.app";
local as=ah{
Url=ar.."/public/connectivity",
Method="GET"
};
if as.StatusCode~=200 and as.StatusCode~=429 then
ar="https://api.platoboost.net";
end


function cacheLink()
if aq+(600)<al()then
local at=ah{
Url=ar.."/public/start",
Method="POST",
Body=U{
service=ab,
identifier=W(ao())
},
Headers={
["Content-Type"]="application/json",
["User-Agent"]="Roblox/Exploit"
}
};

if at.StatusCode==200 then
local au=V(at.Body);

if au.success==true then
ap=au.data.url;
aq=al();
return true,ap
else
ae(au.message);
return false,au.message
end
elseif at.StatusCode==429 then
local au="you are being rate limited, please wait 20 seconds and try again.";
ae(au);
return false,au
end

local au="Failed to cache link.";
ae(au);
return false,au
else
return true,ap
end
end

cacheLink();


local at=function()
local at=""
for au=1,16 do
at=at..ai(an(am()*(26))+97)
end
return at
end


for au=1,5 do
local av=at();
task.wait(0.2)
if at()==av then
local aw="platoboost nonce error.";
ae(aw);
error(aw);
end
end


local au=function()
local au,av=cacheLink();

if au then
ag(av);
end
end


local av=function(av)
local aw=at();
local ax=ar.."/public/redeem/"..aj(ab);

local ay={
identifier=W(ao()),
key=av
}

if ad then
ay.nonce=aw;
end

local az=ah{
Url=ax,
Method="POST",
Body=U(ay),
Headers={
["Content-Type"]="application/json"
}
};

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..aw.."-"..ac)then
return true
else
ae"failed to verify integrity.";
return false
end
else
return true
end
else
ae"key is invalid.";
return false
end
else
if ak(aA.message,1,27)=="unique constraint violation"then
ae"you already have an active key, please wait for it to expire before redeeming it.";
return false
else
ae(aA.message);
return false
end
end
elseif az.StatusCode==429 then
ae"you are being rate limited, please wait 20 seconds and try again.";
return false
else
ae"server returned an invalid status code, please try again later.";
return false
end
end


local aw=function(aw)
if af==true then
return false,("A request is already being sent, please slow down.")
else
af=true;
end

local ax=at();
local ay=ar.."/public/whitelist/"..aj(ab).."?identifier="..W(ao()).."&key="..aw;

if ad then
ay=ay.."&nonce="..ax;
end

local az=ah{
Url=ay,
Method="GET",
};

af=false;

if az.StatusCode==200 then
local aA=V(az.Body);

if aA.success==true then
if aA.data.valid==true then
if ad then
if aA.data.hash==W("true".."-"..ax.."-"..ac)then
return true,""
else
return false,("failed to verify integrity.")
end
else
return true
end
else
if ak(aw,1,4)=="KEY_"then
return true,av(aw)
else
return false,("Key is invalid.")
end
end
else
return false,(aA.message)
end
elseif az.StatusCode==429 then
return false,("You are being rate limited, please wait 20 seconds and try again.")
else
return false,("Server returned an invalid status code, please try again later.")
end
end


local ax=function(ax)
local ay=at();
local az=ar.."/public/flag/"..aj(ab).."?name="..ax;

if ad then
az=az.."&nonce="..ay;
end

local aA=ah{
Url=az,
Method="GET",
};

if aA.StatusCode==200 then
local aB=V(aA.Body);

if aB.success==true then
if ad then
if aB.data.hash==W(aj(aB.data.value).."-"..ay.."-"..ac)then
return aB.data.value
else
ae"failed to verify integrity.";
return nil
end
else
return aB.data.value
end
else
ae(aB.message);
return nil
end
else
return nil
end
end


return{
Verify=aw,
GetFlag=ax,
Copy=au,
}
end


return X end function a.g()






local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ab=aa(game:GetService"HttpService")
local ac={}

function ac.New(ad)
local ae=gethwid or function()
return aa(game:GetService"Players").LocalPlayer.UserId
end
local af,ag=request or http_request or syn_request,setclipboard or toclipboard

function ValidateKey(ah)
local ai="https://new.pandadevelopment.net/api/v1/keys/validate"

local aj={
ServiceID=ad,
HWID=tostring(ae()),
Key=tostring(ah),
}

local ak=ab:JSONEncode(aj)
local al,am=pcall(function()
return af{
Url=ai,
Method="POST",
Headers={
["User-Agent"]="Roblox/Exploit",
["Content-Type"]="application/json",
},
Body=ak,
}
end)

if al and am then
if am.Success then
local an,ao=pcall(function()
return ab:JSONDecode(am.Body)
end)

if an and ao then
if ao.Authenticated_Status and ao.Authenticated_Status=="Success"then
return true,"Authenticated"
else
local ap=ao.Note or"Unknown reason"
return false,"Authentication failed: "..ap
end
else
return false,"JSON decode error"
end
else
warn(
" HTTP request was not successful. Code: "
..tostring(am.StatusCode)
.." Message: "
..am.StatusMessage
)
return false,"HTTP request failed: "..am.StatusMessage
end
else
return false,"Request pcall error"
end
end

function GetKeyLink()
return"https://new.pandadevelopment.net/getkey/"..tostring(ad).."?hwid="..tostring(ae())
end

function CopyLink()
return ag(GetKeyLink())
end

return{
Verify=ValidateKey,
Copy=CopyLink,
}
end

return ac end function a.h()









local aa={}


function aa.New(ab,ac)
local ad="https://sdkapi-public.luarmor.net/library.lua"

local ae=loadstring(
game.HttpGetAsync and game:HttpGetAsync(ad)
or HttpService:GetAsync(ad)
)()
local af=setclipboard or toclipboard

ae.script_id=ab

function ValidateKey(ag)
local ah=ae.check_key(ag);


if(ah.code=="KEY_VALID")then
return true,"Whitelisted!"

elseif(ah.code=="KEY_HWID_LOCKED")then
return false,"Key linked to a different HWID. Please reset it using our bot"

elseif(ah.code=="KEY_INCORRECT")then
return false,"Key is wrong or deleted!"
else
return false,"Key check failed:"..ah.message.." Code: "..ah.code
end
end

function CopyLink()
af(tostring(ac))
end

return{
Verify=ValidateKey,
Copy=CopyLink
}
end


return aa end function a.i()








local aa={}

function aa.New(ab,ac,ad)
JunkieProtected.API_KEY=ac
JunkieProtected.PROVIDER=ad
JunkieProtected.SERVICE_ID=ab

local function ValidateKey(ae)
if not ae or ae==""then
print"No key provided!"

return false,"No key provided. Please get a key."
end

local af=JunkieProtected.IsKeylessMode()
if af and af.keyless_mode then
print"Keyless mode enabled. Starting script..."
return true,"Keyless mode enabled. Starting script..."
end

local ag=JunkieProtected.ValidateKey{Key=ae}
if ag=="valid"then
print"Key is valid! Starting script..."
load()
if _G.JD_IsPremium then
print"Premium user detected!"
else
print"Standard user"
end

return true,"Key is valid!"
else
local ah=JunkieProtected.GetKeyLink()
print"Invalid key!"

return false,"Invalid key. Get one from:"..ah
end
end

local function copyLink()
local ae=JunkieProtected.GetKeyLink()

if setclipboard then
setclipboard(ae)
end
end
return{
Verify=ValidateKey,
Copy=copyLink
}
end

return aa end function a.j()



return{
platoboost={
Name="Platoboost",
Icon="rbxassetid://75920162824531",
Args={"ServiceId","Secret"},

New=a.load'f'.New
},
pandadevelopment={
Name="Panda Development",
Icon="panda",
Args={"ServiceId"},

New=a.load'g'.New
},
luarmor={
Name="Luarmor",
Icon="rbxassetid://130918283130165",
Args={"ScriptId","Discord"},

New=a.load'h'.New
},
junkiedevelopment={
Name="Junkie Development",
Icon="rbxassetid://106310347705078",
Args={"ServiceId","ApiKey","Provider"},

New=a.load'i'.New
},


}end function a.k()



return[[
{
    "name": "windui",
    "version": "1.6.64",
    "main": "./dist/main.lua",
    "repository": "https://github.com/Footagesus/WindUI",
    "discord": "https://discord.gg/ftgs-development-hub-1300692552005189632",
    "author": "Footagesus",
    "description": "Roblox UI Library for scripts",
    "license": "MIT",
    "scripts": {
        "dev": "bash build/build.sh dev $INPUT_FILE",
        "build": "bash build/build.sh build $INPUT_FILE",
        "live": "python -m http.server 8642",
        "watch": "chokidar . -i 'node_modules' -i 'dist' -i 'build' -c 'npm run dev --'",
        "live-build": "concurrently \"npm run live\" \"npm run watch --\"",
        "example-live-build": "INPUT_FILE=main_example.lua npm run live-build",
        "updater": "python3 updater/main.py"
    },
    "keywords": [
        "ui-library",
        "ui-design",
        "script",
        "script-hub",
        "exploiting"
    ],
    "devDependencies": {
        "chokidar-cli": "^3.0.0",
        "concurrently": "^9.2.0"
    }
}
]]end function a.l()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Primary"
local am=al or(not ak and 10 or 99)
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=ah=="White"and 0.4 or 0,
ThemeTag={
ImageColor3=ah~="White"and"Icon"or nil,
},
})
end

local ao=ac("TextButton",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=ai,
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3=ah~="White"and"Button"or nil,
},
ImageColor3=ah=="White"and Color3.new(1,1,1)or nil,
Size=UDim2.new(1,0,1,0),
Name="Squircle",
ImageTransparency=ah=="Primary"and 0 or ah=="White"and 0 or 1,
}),

ab.NewRoundFrame(am,"Squircle",{



ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(1,0,1,0),
Name="Special",
ImageTransparency=ah=="Secondary"and 0.95 or 1,
}),

ab.NewRoundFrame(am,"Shadow-sm",{



ImageColor3=Color3.new(0,0,0),
Size=UDim2.new(1,3,1,3),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Shadow",

ImageTransparency=1,
Visible=not ak,
}),

ab.NewRoundFrame(am,not ak and"Glass-1"or"Glass-0.7",{
ThemeTag={
ImageColor3="White",
},
Size=UDim2.new(1,0,1,0),

ImageTransparency=0.6,
Name="Outline",
},{













}),

ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3=ah~="White"and"Text"or nil,
},
ImageColor3=ah=="White"and Color3.new(0,0,0)or nil,
ImageTransparency=1,
},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
an,
ac("TextLabel",{
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ae or"Button",
ThemeTag={
TextColor3=(ah~="Primary"and ah~="White")and"Text",
},
TextColor3=ah=="Primary"and Color3.new(1,1,1)
or ah=="White"and Color3.new(0,0,0)
or nil,
AutomaticSize="XY",
TextSize=18,
}),
}),
})

ab.AddSignal(ao.MouseEnter,function()
ad(ao.Frame,0.047,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(ao.MouseLeave,function()
ad(ao.Frame,0.047,{ImageTransparency=1}):Play()
end)
ab.AddSignal(ao.MouseButton1Up,function()
if aj then
aj:Close()()
end
if ag then
ab.SafeCallback(ag)
end
end)

return ao
end

return aa end function a.m()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.New(ae,af,ag,ah,ai,aj,ak,al)
ah=ah or"Input"
local am=ak or 10
local an
if af and af~=""then
an=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
}
})
end

local ao=ah~="Input"

local ap=ac("TextBox",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,an and-29 or 0,1,0),
PlaceholderText=ae,
ClearTextOnFocus=al or false,
ClipsDescendants=true,
TextWrapped=ao,
MultiLine=ao,
TextXAlignment="Left",
TextYAlignment=ah=="Input"and"Center"or"Top",

ThemeTag={
PlaceholderColor3="PlaceholderText",
TextColor3="Text",
},
})

local aq=ac("Frame",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(am,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.97,
}),
ab.NewRoundFrame(am,"Glass-1",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.75,
},{













}),
ab.NewRoundFrame(am,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=.95
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,ah=="Input"and 0 or 12),
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
PaddingBottom=UDim.new(0,ah=="Input"and 0 or 12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment=ah=="Input"and"Center"or"Top",
HorizontalAlignment="Left",
}),
an,
ap,
})
})
})










if aj then
ab.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
else
ab.AddSignal(ap.FocusLost,function()
if ai then
ab.SafeCallback(ai,ap.Text)
end
end)
end

return aq
end


return aa end function a.n()
local aa=a.load'c'
local ab=aa.New
local ac=aa.Tween

local ad
local ae

local af={
Holder=nil,

Parent=nil,
}

function af.Init(ag,ah,ai)
ad=ag
ae=ah
af.Parent=ai
return af
end

function af.Create(ag,ah)
local ai={
UICorner=28,
UIPadding=12,

Window=ad,
WindUI=ae,

UIElements={},
}

if ag then
ai.UIPadding=0
end
if ag then
ai.UICorner=26
end

ah=ah or"Dialog"

if not ag then
ai.UIElements.FullScreen=ab("Frame",{
ZIndex=999,
BackgroundTransparency=1,
BackgroundColor3=Color3.fromHex"#000000",
Size=UDim2.new(1,0,1,0),
Active=false,
Visible=false,
Parent=af.Parent
or(ad and ad.UIElements and ad.UIElements.Main and ad.UIElements.Main.Main),
},{
ab("UICorner",{
CornerRadius=UDim.new(0,ad.UICorner),
}),
})
end

ab("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",

},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

ai.UIElements.Main=ab("Frame",{
Size=UDim2.new(0,280,0,0),
ThemeTag={
BackgroundColor3=ah.."Background",
},
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=false,
ZIndex=99999,
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,ai.UIPadding),
PaddingLeft=UDim.new(0,ai.UIPadding),
PaddingRight=UDim.new(0,ai.UIPadding),
PaddingBottom=UDim.new(0,ai.UIPadding),
}),
})

ai.UIElements.MainContainer=aa.NewRoundFrame(ai.UICorner,"Squircle",{
Visible=false,

ImageTransparency=ag and 0.15 or 0,
Parent=ag and af.Parent or ai.UIElements.FullScreen,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
AutomaticSize="XY",
ThemeTag={
ImageColor3=ah.."Background",
ImageTransparency=ah.."BackgroundTransparency",
},
ZIndex=9999,
},{





ai.UIElements.Main,




















})

function ai.Open(aj)
if not ag then
ai.UIElements.FullScreen.Visible=true
ai.UIElements.FullScreen.Active=true
end

task.spawn(function()
ai.UIElements.MainContainer.Visible=true

if not ag then
ac(ai.UIElements.FullScreen,0.1,{BackgroundTransparency=0.3}):Play()
end
ac(ai.UIElements.MainContainer,0.1,{ImageTransparency=0}):Play()


task.spawn(function()
task.wait(0.05)
ai.UIElements.Main.Visible=true
end)
end)
end
function ai.Close(aj)
if not ag then
ac(ai.UIElements.FullScreen,0.1,{BackgroundTransparency=1}):Play()
ai.UIElements.FullScreen.Active=false
task.spawn(function()
task.wait(0.1)
ai.UIElements.FullScreen.Visible=false
end)
end
ai.UIElements.Main.Visible=false

ac(ai.UIElements.MainContainer,0.1,{ImageTransparency=1}):Play()



task.spawn(function()
task.wait(0.1)
if not ag then
ai.UIElements.FullScreen:Destroy()
else
ai.UIElements.MainContainer:Destroy()
end
end)

return function()end
end


return ai
end

return af end function a.o()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=a.load'l'.New
local af=a.load'm'.New

function aa.new(ag,ah,ai,aj)
local ak=a.load'n'.Init(nil,ag.WindUI,ag.WindUI.ScreenGui.KeySystem)
local al=ak.Create(true)

local am={}

local an

local ao=(ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Width)or 200

local ap=430
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
ap=430+(ao/2)
end

al.UIElements.Main.AutomaticSize="Y"
al.UIElements.Main.Size=UDim2.new(0,ap,0,0)

local aq

if ag.Icon then
aq=
ab.Image(ag.Icon,ag.Title..":"..ag.Icon,0,"Temp","KeySystem",ag.IconThemed)
aq.Size=UDim2.new(0,24,0,24)
aq.LayoutOrder=-1
end

local ar=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text=ag.KeySystem.Title or ag.Title,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextSize=20,
})

local as=ac("TextLabel",{
AutomaticSize="XY",
BackgroundTransparency=1,
Text="Key System",
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,0,0.5,0),
TextTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
},
TextSize=16,
})

local at=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aq,
ar,
})

local au=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





at,
as,
})

local av=af("Enter Key","key",nil,"Input",function(av)
an=av
end)

local aw
if ag.KeySystem.Note and ag.KeySystem.Note~=""then
aw=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=ag.KeySystem.Note,
TextSize=18,
TextTransparency=0.4,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ax=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
}),
}),
})

local ay
if ag.KeySystem.Thumbnail and ag.KeySystem.Thumbnail.Image then
local az
if ag.KeySystem.Thumbnail.Title then
az=ac("TextLabel",{
Text=ag.KeySystem.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
ay=ac("ImageLabel",{
Image=ag.KeySystem.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ao,1,-12),
Position=UDim2.new(0,6,0,6),
Parent=al.UIElements.Main,
ScaleType="Crop",
},{
az,
ac("UICorner",{
CornerRadius=UDim.new(0,20),
}),
})
end

ac("Frame",{

Size=UDim2.new(1,ay and-ao or 0,1,0),
Position=UDim2.new(0,ay and ao or 0,0,0),
BackgroundTransparency=1,
Parent=al.UIElements.Main,
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
au,
aw,
av,
ax,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
}),
}),
})





local az=ae("Exit","log-out",function()
al:Close()()
end,"Tertiary",ax.Frame)

if ay then
az.Parent=ay
az.Size=UDim2.new(0,0,0,42)
az.Position=UDim2.new(0,10,1,-10)
az.AnchorPoint=Vector2.new(0,1)
end

if ag.KeySystem.URL then
ae("Get key","key",function()
setclipboard(ag.KeySystem.URL)
end,"Secondary",ax.Frame)
end

if ag.KeySystem.API then








local aA=240
local aB=false
local b=ae("Get key","key",nil,"Secondary",ax.Frame)

local d=ab.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,1,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
})

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Parent=b.Frame,
},{
d,
ac("UIPadding",{
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
}),
})

local f=ab.Image("chevron-down","chevron-down",0,"Temp","KeySystem",true)

f.Size=UDim2.new(1,0,1,0)

ac("Frame",{
Size=UDim2.new(0,21,0,21),
Parent=b.Frame,
BackgroundTransparency=1,
},{
f,
})

local g=ab.NewRoundFrame(15,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Background",
},
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,5),
PaddingLeft=UDim.new(0,5),
PaddingRight=UDim.new(0,5),
PaddingBottom=UDim.new(0,5),
}),
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
}),
})

local h=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(0,aA,0,0),
ClipsDescendants=true,
AnchorPoint=Vector2.new(1,0),
Parent=b,
Position=UDim2.new(1,0,1,15),
},{
g,
})

ac("TextLabel",{
Text="Select Service",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
Parent=g,
},{
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
})

for j,l in next,ag.KeySystem.API do
local m=ag.WindUI.Services[l.Type]
if m then
local p={}
for r,u in next,m.Args do
table.insert(p,l[u])
end

local r=m.New(table.unpack(p))
r.Type=l.Type
table.insert(am,r)

local u=ab.Image(
l.Icon or m.Icon or Icons[l.Type]or"user",
l.Icon or m.Icon or Icons[l.Type]or"user",
0,
"Temp",
"KeySystem",
true
)
u.Size=UDim2.new(0,24,0,24)

local v=ab.NewRoundFrame(10,"Squircle",{
Size=UDim2.new(1,0,0,0),
ThemeTag={ImageColor3="Text"},
ImageTransparency=1,
Parent=g,
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,10),
VerticalAlignment="Center",
}),
u,
ac("UIPadding",{
PaddingTop=UDim.new(0,10),
PaddingLeft=UDim.new(0,10),
PaddingRight=UDim.new(0,10),
PaddingBottom=UDim.new(0,10),
}),
ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,-34,0,0),
AutomaticSize="Y",
},{
ac("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,5),
HorizontalAlignment="Center",
}),
ac("TextLabel",{
Text=l.Title or m.Name,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
ThemeTag={TextColor3="Text"},
TextTransparency=0.05,
TextSize=18,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
TextXAlignment="Left",
}),
ac("TextLabel",{
Text=l.Desc or"",
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
ThemeTag={TextColor3="Text"},
TextTransparency=0.2,
TextSize=16,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
TextWrapped=true,
Visible=l.Desc and true or false,
TextXAlignment="Left",
}),
}),
},true)

ab.AddSignal(v.MouseEnter,function()
ad(v,0.08,{ImageTransparency=0.95}):Play()
end)
ab.AddSignal(v.InputEnded,function()
ad(v,0.08,{ImageTransparency=1}):Play()
end)
ab.AddSignal(v.MouseButton1Click,function()
r.Copy()
ag.WindUI:Notify{
Title="Key System",
Content="Key link copied to clipboard.",
Image="key",
}
end)
end
end

ab.AddSignal(b.MouseButton1Click,function()
if not aB then
ad(
h,
0.3,
{Size=UDim2.new(0,aA,0,g.AbsoluteSize.Y+1)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(f,0.3,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ad(
h,
0.25,
{Size=UDim2.new(0,aA,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
ad(f,0.25,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
aB=not aB
end)
end

local function handleSuccess(aA)
al:Close()()
writefile((ag.Folder or"Temp").."/"..ah..".key",tostring(aA))
task.wait(0.4)
ai(true)
end

local aA=ae("Submit","arrow-right",function()
local aA=tostring(an or"empty")local aB=
ag.Folder or ag.Title

if ag.KeySystem.KeyValidator then
local b=ag.KeySystem.KeyValidator(aA)

if b then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(0.4)
ai(true)
end
else
ag.WindUI:Notify{
Title="Key System. Error",
Content="Invalid key.",
Icon="triangle-alert",
}
end
elseif not ag.KeySystem.API then
local b=type(ag.KeySystem.Key)=="table"and table.find(ag.KeySystem.Key,aA)
or ag.KeySystem.Key==aA

if b then
if ag.KeySystem.SaveKey then
handleSuccess(aA)
else
al:Close()()
task.wait(0.4)
ai(true)
end
end
else
local b,d
for f,g in next,am do
local h,j=g.Verify(aA)
if h then
b,d=true,j
break
end
d=j
end

if b then
handleSuccess(aA)
else
ag.WindUI:Notify{
Title="Key System. Error",
Content=d,
Icon="triangle-alert",
}
end
end
end,"Primary",ax)

aA.AnchorPoint=Vector2.new(1,0.5)
aA.Position=UDim2.new(1,0,0.5,0)










al:Open()
end

return aa end function a.p()




local aa=(cloneref or clonereference or function(aa)return aa end)


local function map(ab,ac,ad,ae,af)
return(ab-ac)*(af-ae)/(ad-ac)+ae
end

local function viewportPointToWorld(ab,ac)
local ad=aa(game:GetService"Workspace").CurrentCamera:ScreenPointToRay(ab.X,ab.Y)
return ad.Origin+ad.Direction*ac
end

local function getOffset()
local ab=aa(game:GetService"Workspace").CurrentCamera.ViewportSize.Y
return map(ab,0,2560,8,56)
end

return{viewportPointToWorld,getOffset}end function a.q()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=a.load'c'
local ac=ab.New


local ad,ae=unpack(a.load'p')
local af=Instance.new("Folder",aa(game:GetService"Workspace").CurrentCamera)


local function createAcrylic()
local ag=ac("Part",{
Name="Body",
Color=Color3.new(0,0,0),
Material=Enum.Material.Glass,
Size=Vector3.new(1,1,0),
Anchored=true,
CanCollide=false,
Locked=true,
CastShadow=false,
Transparency=0.98,
},{
ac("SpecialMesh",{
MeshType=Enum.MeshType.Brick,
Offset=Vector3.new(0,0,-1E-6),
}),
})

return ag
end


local function createAcrylicBlur(ag)
local ah={}

ag=ag or 0.001
local ai={
topLeft=Vector2.new(),
topRight=Vector2.new(),
bottomRight=Vector2.new(),
}
local aj=createAcrylic()
aj.Parent=af

local function updatePositions(ak,al)
ai.topLeft=al
ai.topRight=al+Vector2.new(ak.X,0)
ai.bottomRight=al+ak
end

local function render()
local ak=aa(game:GetService"Workspace").CurrentCamera
if ak then
ak=ak.CFrame
end
local al=ak
if not al then
al=CFrame.new()
end

local am=al
local an=ai.topLeft
local ao=ai.topRight
local ap=ai.bottomRight

local aq=ad(an,ag)
local ar=ad(ao,ag)
local as=ad(ap,ag)

local at=(ar-aq).Magnitude
local au=(ar-as).Magnitude

aj.CFrame=
CFrame.fromMatrix((aq+as)/2,am.XVector,am.YVector,am.ZVector)
aj.Mesh.Scale=Vector3.new(at,au,0)
end

local function onChange(ak)
local al=ae()
local am=ak.AbsoluteSize-Vector2.new(al,al)
local an=ak.AbsolutePosition+Vector2.new(al/2,al/2)

updatePositions(am,an)
task.spawn(render)
end

local function renderOnChange()
local ak=aa(game:GetService"Workspace").CurrentCamera
if not ak then
return
end

table.insert(ah,ak:GetPropertyChangedSignal"CFrame":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"ViewportSize":Connect(render))
table.insert(ah,ak:GetPropertyChangedSignal"FieldOfView":Connect(render))
task.spawn(render)
end

aj.Destroying:Connect(function()
for ak,al in ah do
pcall(function()
al:Disconnect()
end)
end
end)

renderOnChange()

return onChange,aj
end

return function(ag)
local ah={}
local ai,aj=createAcrylicBlur(ag)

local ak=ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
})

ab.AddSignal(ak:GetPropertyChangedSignal"AbsolutePosition",function()
ai(ak)
end)

ab.AddSignal(ak:GetPropertyChangedSignal"AbsoluteSize",function()
ai(ak)
end)

ah.AddParent=function(al)
ab.AddSignal(al:GetPropertyChangedSignal"Visible",function()

end)
end

ah.SetVisibility=function(al)
aj.Transparency=al and 0.98 or 1
end

ah.Frame=ak
ah.Model=aj

return ah
end end function a.r()


local aa=a.load'c'
local ab=a.load'q'

local ac=aa.New

return function(ad)
local ae={}

ae.Frame=ac("Frame",{
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(255,255,255),
BorderSizePixel=0,
},{












ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
Name="Background",
ThemeTag={
BackgroundColor3="AcrylicMain",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundColor3=Color3.fromRGB(255,255,255),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{










}),

ac("ImageLabel",{
Image="rbxassetid://9968344105",
ImageTransparency=0.98,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("ImageLabel",{
Image="rbxassetid://9968344227",
ImageTransparency=0.9,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.new(0,128,0,128),
Size=UDim2.fromScale(1,1),
BackgroundTransparency=1,
ThemeTag={
ImageTransparency="AcrylicNoise",
},
},{
ac("UICorner",{
CornerRadius=UDim.new(0,8),
}),
}),

ac("Frame",{
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
ZIndex=2,
},{










}),
})


local af

task.wait()
if ad.UseAcrylic then
af=ab()

af.Frame.Parent=ae.Frame
ae.Model=af.Model
ae.AddParent=af.AddParent
ae.SetVisibility=af.SetVisibility
end

return ae,af
end end function a.s()



local aa=(cloneref or clonereference or function(aa)return aa end)


local ab={
AcrylicBlur=a.load'q',

AcrylicPaint=a.load'r',
}

function ab.init()
local ac=Instance.new"DepthOfFieldEffect"
ac.FarIntensity=0
ac.InFocusRadius=0.1
ac.NearIntensity=1

local ad={}

function ab.Enable()
for ae,af in pairs(ad)do
af.Enabled=false
end
ac.Parent=aa(game:GetService"Lighting")
end

function ab.Disable()
for ae,af in pairs(ad)do
af.Enabled=af.enabled
end
ac.Parent=nil
end

local function registerDefaults()
local function register(ae)
if ae:IsA"DepthOfFieldEffect"then
ad[ae]={enabled=ae.Enabled}
end
end

for ae,af in pairs(aa(game:GetService"Lighting"):GetChildren())do
register(af)
end

if aa(game:GetService"Workspace").CurrentCamera then
for ae,af in pairs(aa(game:GetService"Workspace").CurrentCamera:GetChildren())do
register(af)
end
end
end

registerDefaults()
ab.Enable()
end

return ab end function a.t()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween


function aa.new(ae)
local af={
Title=ae.Title or"Dialog",
Content=ae.Content,
Icon=ae.Icon,
IconThemed=ae.IconThemed,
Thumbnail=ae.Thumbnail,
Buttons=ae.Buttons,

IconSize=22,
}

local ag=a.load'n'.Init(nil,ae.WindUI.ScreenGui.Popups)
local ah=ag.Create(true,"Popup")

local ai=200

local aj=430
if af.Thumbnail and af.Thumbnail.Image then
aj=430+(ai/2)
end

ah.UIElements.Main.AutomaticSize="Y"
ah.UIElements.Main.Size=UDim2.new(0,aj,0,0)



local ak

if af.Icon then
ak=ab.Image(
af.Icon,
af.Title..":"..af.Icon,
0,
ae.WindUI.Window,
"Popup",
true,
ae.IconThemed,
"PopupIcon"
)
ak.Size=UDim2.new(0,af.IconSize,0,af.IconSize)
ak.LayoutOrder=-1
end


local al=ac("TextLabel",{
AutomaticSize="Y",
BackgroundTransparency=1,
Text=af.Title,
TextXAlignment="Left",
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="PopupTitle",
},
TextSize=20,
TextWrapped=true,
Size=UDim2.new(1,ak and-af.IconSize-14 or 0,0,0)
})

local am=ac("Frame",{
BackgroundTransparency=1,
AutomaticSize="XY",
},{
ac("UIListLayout",{
Padding=UDim.new(0,14),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),
ak,al
})

local an=ac("Frame",{
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
},{





am,
})

local ao
if af.Content and af.Content~=""then
ao=ac("TextLabel",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Text=af.Content,
TextSize=18,
TextTransparency=.2,
ThemeTag={
TextColor3="PopupContent",
},
BackgroundTransparency=1,
RichText=true,
TextWrapped=true,
})
end

local ap=ac("Frame",{
Size=UDim2.new(1,0,0,42),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,9),
FillDirection="Horizontal",
HorizontalAlignment="Right"
})
})

local aq
if af.Thumbnail and af.Thumbnail.Image then
local ar
if af.Thumbnail.Title then
ar=ac("TextLabel",{
Text=af.Thumbnail.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
})
end
aq=ac("ImageLabel",{
Image=af.Thumbnail.Image,
BackgroundTransparency=1,
Size=UDim2.new(0,ai,1,0),
Parent=ah.UIElements.Main,
ScaleType="Crop"
},{
ar,
ac("UICorner",{
CornerRadius=UDim.new(0,0),
})
})
end

ac("Frame",{

Size=UDim2.new(1,aq and-ai or 0,1,0),
Position=UDim2.new(0,aq and ai or 0,0,0),
BackgroundTransparency=1,
Parent=ah.UIElements.Main
},{
ac("Frame",{

Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ac("UIListLayout",{
Padding=UDim.new(0,18),
FillDirection="Vertical",
}),
an,
ao,
ap,
ac("UIPadding",{
PaddingTop=UDim.new(0,16),
PaddingLeft=UDim.new(0,16),
PaddingRight=UDim.new(0,16),
PaddingBottom=UDim.new(0,16),
})
}),
})

local ar=a.load'l'.New

for as,at in next,af.Buttons do
ar(at.Title,at.Icon,at.Callback,at.Variant,ap,ah)
end

ah:Open()


return af
end

return aa end function a.u()
return function(aa)
return{
Dark={
Name="Dark",

Accent=Color3.fromHex"#18181b",
Dialog=Color3.fromHex"#161616",
Outline=Color3.fromHex"#FFFFFF",
Text=Color3.fromHex"#FFFFFF",
Placeholder=Color3.fromHex"#7a7a7a",
Background=Color3.fromHex"#101010",
Button=Color3.fromHex"#52525b",
Icon=Color3.fromHex"#a1a1aa",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,

SliderIcon=Color3.fromHex"#908F95",
Primary=Color3.fromHex"#0091FF",


LabelBackground=Color3.fromHex"#000000",
LabelBackgroundTransparency=0.83,
},

Light={
Name="Light",

Accent=Color3.fromHex"#FFFFFF",
Dialog=Color3.fromHex"#f4f4f5",
Outline=Color3.fromHex"#ffffff",
Text=Color3.fromHex"#000000",
Placeholder=Color3.fromHex"#555555",
Background=Color3.fromHex"#e9e9e9",
Button=Color3.fromHex"#18181b",
Icon=Color3.fromHex"#52525b",
Toggle=Color3.fromHex"#33C759",
Slider=Color3.fromHex"#0091FF",
Checkbox=Color3.fromHex"#0091FF",

TabBackground=Color3.fromHex"#ffffff",
TabBackgroundHover=Color3.fromHex"#ffffff",
TabBackgroundHoverTransparency=0.5,
TabBackgroundActive=Color3.fromHex"#ffffff",
TabBackgroundActiveTransparency=0,

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0,

LabelBackground=Color3.fromHex"#ffffff",
LabelBackgroundTransparency=0,
},

Rose={
Name="Rose",

Accent=Color3.fromHex"#be185d",
Dialog=Color3.fromHex"#4c0519",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#d67aa6",
Background=Color3.fromHex"#1f0308",
Button=Color3.fromHex"#e95f74",
Icon=Color3.fromHex"#fb7185",
},

Plant={
Name="Plant",

Accent=Color3.fromHex"#166534",
Dialog=Color3.fromHex"#052e16",

Text=Color3.fromHex"#f0fdf4",
Placeholder=Color3.fromHex"#4fbf7a",
Background=Color3.fromHex"#0a1b0f",
Button=Color3.fromHex"#16a34a",
Icon=Color3.fromHex"#4ade80",
},

Red={
Name="Red",

Accent=Color3.fromHex"#991b1b",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#d95353",
Background=Color3.fromHex"#1c0606",
Button=Color3.fromHex"#dc2626",
Icon=Color3.fromHex"#ef4444",
},

Indigo={
Name="Indigo",

Accent=Color3.fromHex"#3730a3",
Dialog=Color3.fromHex"#1e1b4b",

Text=Color3.fromHex"#f1f5f9",
Placeholder=Color3.fromHex"#7078d9",
Background=Color3.fromHex"#0f0a2e",
Button=Color3.fromHex"#4f46e5",
Icon=Color3.fromHex"#6366f1",
},

Sky={
Name="Sky",

Accent=Color3.fromHex"#00d4ff",
Dialog=Color3.fromHex"#0a4d66",

Text=Color3.fromHex"#e6f7ff",
Placeholder=Color3.fromHex"#66b3cc",
Background=Color3.fromHex"#051a26",
Button=Color3.fromHex"#00a8cc",
Icon=Color3.fromHex"#2db8d9",

Toggle=Color3.fromHex"#00d9d9",
Slider=Color3.fromHex"#00d4ff",
Checkbox=Color3.fromHex"#00d4ff",

PanelBackground=Color3.fromHex"#0d3a47",
PanelBackgroundTransparency=0.8,
},

Violet={
Name="Violet",

Accent=Color3.fromHex"#6d28d9",
Dialog=Color3.fromHex"#3c1361",

Text=Color3.fromHex"#faf5ff",
Placeholder=Color3.fromHex"#8f7ee0",
Background=Color3.fromHex"#1e0a3e",
Button=Color3.fromHex"#7c3aed",
Icon=Color3.fromHex"#8b5cf6",
},

Amber={
Name="Amber",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#b45309",Transparency=0},
["100"]={Color=Color3.fromHex"#d97706",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#451a03",Transparency=0},
["100"]={Color=Color3.fromHex"#6b2e05",Transparency=0},
},{Rotation=90}),






Text=aa:Gradient({
["0"]={Color=Color3.fromHex"#fffbeb",Transparency=0},
["100"]={Color=Color3.fromHex"#fff7ed",Transparency=0},
},{Rotation=45}),

Placeholder=aa:Gradient({
["0"]={Color=Color3.fromHex"#d1a326",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#1c1003",Transparency=0},
["100"]={Color=Color3.fromHex"#3f210d",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Icon=Color3.fromHex"#f59e0b",

Toggle=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#f59e0b",Transparency=0},
},{Rotation=45}),

Slider=Color3.fromHex"#d97706",

Checkbox=aa:Gradient({
["0"]={Color=Color3.fromHex"#d97706",Transparency=0},
["100"]={Color=Color3.fromHex"#fbbf24",Transparency=0},
},{Rotation=45}),

PanelBackground=Color3.fromHex"#FFFFFF",
PanelBackgroundTransparency=0.95,
},

Emerald={
Name="Emerald",

Accent=Color3.fromHex"#047857",
Dialog=Color3.fromHex"#022c22",

Text=Color3.fromHex"#ecfdf5",
Placeholder=Color3.fromHex"#3fbf8f",
Background=Color3.fromHex"#011411",
Button=Color3.fromHex"#059669",
Icon=Color3.fromHex"#10b981",
},

Midnight={
Name="Midnight",

Accent=Color3.fromHex"#1e3a8a",
Dialog=Color3.fromHex"#0c1e42",

Text=Color3.fromHex"#dbeafe",
Placeholder=Color3.fromHex"#2f74d1",
Background=Color3.fromHex"#0a0f1e",
Button=Color3.fromHex"#2563eb",
Primary=Color3.fromHex"#2563eb",
Icon=Color3.fromHex"#5591f4",
},

Crimson={
Name="Crimson",

Accent=Color3.fromHex"#b91c1c",
Dialog=Color3.fromHex"#450a0a",

Text=Color3.fromHex"#fef2f2",
Placeholder=Color3.fromHex"#6f757b",
Background=Color3.fromHex"#0c0404",
Button=Color3.fromHex"#991b1b",
Icon=Color3.fromHex"#dc2626",
},

MonokaiPro={
Name="Monokai Pro",

Accent=Color3.fromHex"#fc9867",
Dialog=Color3.fromHex"#1e1e1e",

Text=Color3.fromHex"#fcfcfa",
Placeholder=Color3.fromHex"#6f6f6f",
Background=Color3.fromHex"#191622",
Button=Color3.fromHex"#ab9df2",
Icon=Color3.fromHex"#a9dc76",

Metadata={
PullRequest=23,
},
},

CottonCandy={
Name="Cotton Candy",

Accent=Color3.fromHex"#ec4899",
Dialog=Color3.fromHex"#2d1b3d",

Text=Color3.fromHex"#fdf2f8",
Placeholder=Color3.fromHex"#8a5fd3",
Background=Color3.fromHex"#1a0b2e",
Button=Color3.fromHex"#d946ef",
Slider=Color3.fromHex"#d946ef",
Icon=Color3.fromHex"#06b6d4",
},

Mellowsi={
Name="Mellowsi",

Accent=Color3.fromHex"#342A1E",
Dialog=Color3.fromHex"#291C13",

Text=Color3.fromHex"#F5EBDD",
Placeholder=Color3.fromHex"#9C8A73",
Background=Color3.fromHex"#1C1002",
Button=Color3.fromHex"#342A1E",
Icon=Color3.fromHex"#C9B79C",

Toggle=Color3.fromHex"#a9873f",
Slider=Color3.fromHex"#C9A24D",
Checkbox=Color3.fromHex"#C9A24D",

Metadata={
PullRequest=52,
},
},

Rainbow={
Name="Rainbow",

Accent=aa:Gradient({
["0"]={Color=Color3.fromHex"#00ff41",Transparency=0},
["33"]={Color=Color3.fromHex"#00ffff",Transparency=0},
["66"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["100"]={Color=Color3.fromHex"#8000ff",Transparency=0},
},{Rotation=45}),

Dialog=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#8000ff",Transparency=0},
["50"]={Color=Color3.fromHex"#0080ff",Transparency=0},
["75"]={Color=Color3.fromHex"#00ff80",Transparency=0},
["100"]={Color=Color3.fromHex"#ff8000",Transparency=0},
},{Rotation=135}),


Text=Color3.fromHex"#ffffff",
Placeholder=Color3.fromHex"#00ff80",

Background=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0040",Transparency=0},
["20"]={Color=Color3.fromHex"#ff4000",Transparency=0},
["40"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["60"]={Color=Color3.fromHex"#00ff40",Transparency=0},
["80"]={Color=Color3.fromHex"#0040ff",Transparency=0},
["100"]={Color=Color3.fromHex"#4000ff",Transparency=0},
},{Rotation=90}),

Button=aa:Gradient({
["0"]={Color=Color3.fromHex"#ff0080",Transparency=0},
["25"]={Color=Color3.fromHex"#ff8000",Transparency=0},
["50"]={Color=Color3.fromHex"#ffff00",Transparency=0},
["75"]={Color=Color3.fromHex"#80ff00",Transparency=0},
["100"]={Color=Color3.fromHex"#00ffff",Transparency=0},
},{Rotation=60}),

Icon=Color3.fromHex"#ffffff",
},
}
end end function a.v()

local aa={}

local ab=a.load'c'
local ac=ab.New local ad=
ab.Tween

function aa.New(ae,af,ag,ah,ai)
local aj=ai or 10
local ak
if af and af~=""then
ak=ac("ImageLabel",{
Image=ab.Icon(af)[1],
ImageRectSize=ab.Icon(af)[2].ImageRectSize,
ImageRectOffset=ab.Icon(af)[2].ImageRectPosition,
Size=UDim2.new(0,21,0,21),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
})
end

local al=ac("TextLabel",{
BackgroundTransparency=1,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Regular),
Size=UDim2.new(1,ak and-29 or 0,1,0),
TextXAlignment="Left",
ThemeTag={
TextColor3=ah and"Placeholder"or"Text",
},
Text=ae,
})

local am=ac("TextButton",{
Size=UDim2.new(1,0,0,42),
Parent=ag,
BackgroundTransparency=1,
Text="",
},{
ac("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ab.NewRoundFrame(aj,"Squircle",{
ThemeTag={
ImageColor3="Accent",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.97,
}),
ab.NewRoundFrame(aj,"Glass-1.4",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.48,
},{













}),
ab.NewRoundFrame(aj,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Frame",
ThemeTag={
ImageColor3="LabelBackground",
ImageTransparency="LabelBackgroundTransparency",
},


},{
ac("UIPadding",{
PaddingLeft=UDim.new(0,12),
PaddingRight=UDim.new(0,12),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,8),
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ak,
al,
}),
}),
})

return am
end

return aa end function a.w()

local aa={}

local ab=(cloneref or clonereference or function(ab)return ab end)


local ac=ab(game:GetService"UserInputService")

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween


function aa.New(ag,ah,ai,aj)
local ak=ae("Frame",{
Size=UDim2.new(0,aj,1,0),
BackgroundTransparency=1,
Position=UDim2.new(1,0,0,0),
AnchorPoint=Vector2.new(1,0),
Parent=ah,
ZIndex=999,
Active=true,
})

local al=ad.NewRoundFrame(aj/2,"Squircle",{
Size=UDim2.new(1,0,0,0),
ImageTransparency=0.85,
ThemeTag={ImageColor3="Text"},
Parent=ak,
})

local am=ae("Frame",{
Size=UDim2.new(1,12,1,12),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Active=true,
ZIndex=999,
Parent=al,
})

local an=false
local ao=0

local function updateSliderSize()
local ap=ag
local aq=ap.AbsoluteCanvasSize.Y
local ar=ap.AbsoluteWindowSize.Y

if aq<=ar then
al.Visible=false
return
end

local as=math.clamp(ar/aq,0.1,1)
al.Size=UDim2.new(1,0,as,0)
al.Visible=true
end

local function updateScrollingFramePosition()
local ap=al.Position.Y.Scale
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then return end

local at=math.max(1-al.Size.Y.Scale,0)
if at<=0 then return end

local au=ap/at

ag.CanvasPosition=Vector2.new(
ag.CanvasPosition.X,
au*as
)
end

local function updateThumbPosition()
if an then return end

local ap=ag.CanvasPosition.Y
local aq=ag.AbsoluteCanvasSize.Y
local ar=ag.AbsoluteWindowSize.Y
local as=math.max(aq-ar,0)

if as<=0 then
al.Position=UDim2.new(0,0,0,0)
return
end

local at=ap/as
local au=math.max(1-al.Size.Y.Scale,0)
local av=math.clamp(at*au,0,au)

al.Position=UDim2.new(0,0,av,0)
end

ad.AddSignal(ak.InputBegan,function(ap)
if(ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch)then
local aq=al.AbsolutePosition.Y
local ar=aq+al.AbsoluteSize.Y

if not(ap.Position.Y>=aq and ap.Position.Y<=ar)then
local as=ak.AbsolutePosition.Y
local at=ak.AbsoluteSize.Y
local au=al.AbsoluteSize.Y

local av=ap.Position.Y-as-au/2
local aw=at-au

local ax=math.clamp(av/aw,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ax,0)
updateScrollingFramePosition()
end
end
end)

ad.AddSignal(am.InputBegan,function(ap)
if ap.UserInputType==Enum.UserInputType.MouseButton1 or ap.UserInputType==Enum.UserInputType.Touch then
an=true
ao=ap.Position.Y-al.AbsolutePosition.Y

local aq
local ar

aq=ac.InputChanged:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseMovement or as.UserInputType==Enum.UserInputType.Touch then
local at=ak.AbsolutePosition.Y
local au=ak.AbsoluteSize.Y
local av=al.AbsoluteSize.Y

local aw=as.Position.Y-at-ao
local ax=au-av

local ay=math.clamp(aw/ax,0,1-al.Size.Y.Scale)

al.Position=UDim2.new(0,0,ay,0)
updateScrollingFramePosition()
end
end)

ar=ac.InputEnded:Connect(function(as)
if as.UserInputType==Enum.UserInputType.MouseButton1 or as.UserInputType==Enum.UserInputType.Touch then
an=false
if aq then aq:Disconnect()end
if ar then ar:Disconnect()end
end
end)
end
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteWindowSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"AbsoluteCanvasSize",function()
updateSliderSize()
updateThumbPosition()
end)

ad.AddSignal(ag:GetPropertyChangedSignal"CanvasPosition",function()
if not an then
updateThumbPosition()
end
end)

updateSliderSize()
updateThumbPosition()

return ak
end


return aa end function a.x()
local aa={}


local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag)
local ah={
Title=af.Title or"Tag",
Icon=af.Icon,
Color=af.Color or Color3.fromHex"#315dff",
Radius=af.Radius or 999,
Border=af.Border or false,

TagFrame=nil,
Height=26,
Padding=10,
TextSize=14,
IconSize=16,
}

local ai
if ah.Icon then
ai=ab.Image(
ah.Icon,
ah.Icon,
0,
af.Window,
"Tag",
false
)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.ImageLabel.ImageColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or nil
end

local aj=ac("TextLabel",{
BackgroundTransparency=1,
AutomaticSize="XY",
TextSize=ah.TextSize,
FontFace=Font.new(ab.Font,Enum.FontWeight.SemiBold),
Text=ah.Title,
TextColor3=typeof(ah.Color)=="Color3"and ab.GetTextColorForHSB(ah.Color)or nil,
})

local ak

if typeof(ah.Color)=="table"then

ak=ac"UIGradient"
for al,am in next,ah.Color do
ak[al]=am
end

aj.TextColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
if ai then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
end



local al=ab.NewRoundFrame(ah.Radius,"Squircle",{
AutomaticSize="X",
Size=UDim2.new(0,0,0,ah.Height),
Parent=ag,
ImageColor3=typeof(ah.Color)=="Color3"and ah.Color or Color3.new(1,1,1),
},{
ak,
ab.NewRoundFrame(ah.Radius,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=.75
}),
ac("Frame",{
Size=UDim2.new(0,0,1,0),
AutomaticSize="X",
Name="Content",
BackgroundTransparency=1,
},{
ai,
aj,
ac("UIPadding",{
PaddingLeft=UDim.new(0,ah.Padding),
PaddingRight=UDim.new(0,ah.Padding),
}),
ac("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,ah.Padding/1.5)
})
}),
})


function ah.SetTitle(am,an)
ah.Title=an
aj.Text=an

return ah
end

function ah.SetColor(am,an)
ah.Color=an
if typeof(an)=="table"then
local ao=ab.GetAverageColor(an)
ad(aj,.06,{TextColor3=ab.GetTextColorForHSB(ao)}):Play()
local ap=al:FindFirstChildOfClass"UIGradient"or ac("UIGradient",{Parent=al})
for aq,ar in next,an do ap[aq]=ar end
ad(al,.06,{ImageColor3=Color3.new(1,1,1)}):Play()
else
if ak then
ak:Destroy()
end
ad(aj,.06,{TextColor3=ab.GetTextColorForHSB(an)}):Play()
if ai then
ad(ai.ImageLabel,.06,{ImageColor3=ab.GetTextColorForHSB(an)}):Play()
end
ad(al,.06,{ImageColor3=an}):Play()
end

return ah
end

function ah.SetIcon(am,an)
ah.Icon=an

if an then
ai=ab.Image(
an,
an,
0,
af.Window,
"Tag",
false
)

ai.Size=UDim2.new(0,ah.IconSize,0,ah.IconSize)
ai.Parent=al

if typeof(ah.Color)=="Color3"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ah.Color)
elseif typeof(ah.Color)=="table"then
ai.ImageLabel.ImageColor3=ab.GetTextColorForHSB(ab.GetAverageColor(ak))
end
else
if ai then
ai:Destroy()
ai=nil
end
end
return ah
end

function ah.Destroy(am)
al:Destroy()
return ah
end

return ah
end


return aa end function a.y()
local aa=(cloneref or clonereference or function(aa)return aa end)


local ab=aa(game:GetService"RunService")
local ac=aa(game:GetService"HttpService")

local ad

local ae
ae={
Folder=nil,
Path=nil,
Configs={},
Parser={
Colorpicker={
Save=function(af)
return{
__type=af.__type,
value=af.Default:ToHex(),
transparency=af.Transparency or nil,
}
end,
Load=function(af,ag)
if af and af.Update then
af:Update(Color3.fromHex(ag.value),ag.transparency or nil)
end
end
},
Dropdown={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Select then
af:Select(ag.value)
end
end
},
Input={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Keybind={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
Slider={
Save=function(af)
return{
__type=af.__type,
value=af.Value.Default,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(tonumber(ag.value))
end
end
},
Toggle={
Save=function(af)
return{
__type=af.__type,
value=af.Value,
}
end,
Load=function(af,ag)
if af and af.Set then
af:Set(ag.value)
end
end
},
}
}

function ae.Init(af,ag)
if not ag.Folder then
warn"[ WindUI.ConfigManager ] Window.Folder is not specified."
return false
end
if ab:IsStudio()or not writefile then
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return false
end

ad=ag
ae.Folder=ad.Folder
ae.Path="WindUI/"..tostring(ae.Folder).."/config/"

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

local ah=ae:AllConfigs()

for ai,aj in next,ah do
if isfile and readfile and isfile(aj..".json")then
ae.Configs[aj]=readfile(aj..".json")
end
end

return ae
end

function ae.SetPath(af,ag)
if not ag then
warn"[ WindUI.ConfigManager ] Custom path is not specified."
return false
end

ae.Path=ag
if not ag:match"/$"then
ae.Path=ag.."/"
end

if not isfolder(ae.Path)then
makefolder(ae.Path)
end

return true
end

function ae.CreateConfig(af,ag,ah)
local ai={
Path=ae.Path..ag..".json",
Elements={},
CustomData={},
AutoLoad=ah or false,
Version=1.2,
}

if not ag then
return false,"No config file is selected"
end

function ai.SetAsCurrent(aj)
ad:SetCurrentConfig(ai)
end

function ai.Register(aj,ak,al)
ai.Elements[ak]=al
end

function ai.Set(aj,ak,al)
ai.CustomData[ak]=al
end

function ai.Get(aj,ak)
return ai.CustomData[ak]
end

function ai.SetAutoLoad(aj,ak)
ai.AutoLoad=ak
end

function ai.Save(aj)
if ad.PendingFlags then
for ak,al in next,ad.PendingFlags do
ai:Register(ak,al)
end
end

local ak={
__version=ai.Version,
__elements={},
__autoload=ai.AutoLoad,
__custom=ai.CustomData
}

for al,am in next,ai.Elements do
if ae.Parser[am.__type]then
ak.__elements[tostring(al)]=ae.Parser[am.__type].Save(am)
end
end

local al=ac:JSONEncode(ak)
if writefile then
writefile(ai.Path,al)
end

return ak
end

function ai.Load(aj)
if isfile and not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
local ak=readfile or function()
warn"[ WindUI.ConfigManager ] The config system doesn't work in the studio."
return nil
end
return ac:JSONDecode(ak(ai.Path))
end)

if not ak then
return false,"Failed to parse config file"
end

if not al.__version then
local am={
__version=ai.Version,
__elements=al,
__custom={}
}
al=am
end

if ad.PendingFlags then
for am,an in next,ad.PendingFlags do
ai:Register(am,an)
end
end

for am,an in next,(al.__elements or{})do
if ai.Elements[am]and ae.Parser[an.__type]then
task.spawn(function()
ae.Parser[an.__type].Load(ai.Elements[am],an)
end)
end
end

ai.CustomData=al.__custom or{}

return ai.CustomData
end

function ai.Delete(aj)
if not delfile then
return false,"delfile function is not available"
end

if not isfile(ai.Path)then
return false,"Config file does not exist"
end

local ak,al=pcall(function()
delfile(ai.Path)
end)

if not ak then
return false,"Failed to delete config file: "..tostring(al)
end

ae.Configs[ag]=nil

if ad.CurrentConfig==ai then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ai.GetData(aj)
return{
elements=ai.Elements,
custom=ai.CustomData,
autoload=ai.AutoLoad
}
end


if isfile(ai.Path)then
local aj,ak=pcall(function()
return ac:JSONDecode(readfile(ai.Path))
end)

if aj and ak and ak.__autoload then
ai.AutoLoad=true

task.spawn(function()
task.wait(0.5)
local al,am=pcall(function()
return ai:Load()
end)
if al then
if ad.Debug then print("[ WindUI.ConfigManager ] AutoLoaded config: "..ag)end
else
warn("[ WindUI.ConfigManager ] Failed to AutoLoad config: "..ag.." - "..tostring(am))
end
end)
end
end


ai:SetAsCurrent()
ae.Configs[ag]=ai
return ai
end

function ae.Config(af,ag,ah)
return ae:CreateConfig(ag,ah)
end

function ae.GetAutoLoadConfigs(af)
local ag={}

for ah,ai in pairs(ae.Configs)do
if ai.AutoLoad then
table.insert(ag,ah)
end
end

return ag
end

function ae.DeleteConfig(af,ag)
if not delfile then
return false,"delfile function is not available"
end

local ah=ae.Path..ag..".json"

if not isfile(ah)then
return false,"Config file does not exist"
end

local ai,aj=pcall(function()
delfile(ah)
end)

if not ai then
return false,"Failed to delete config file: "..tostring(aj)
end

ae.Configs[ag]=nil

if ad.CurrentConfig and ad.CurrentConfig.Path==ah then
ad.CurrentConfig=nil
end

return true,"Config deleted successfully"
end

function ae.AllConfigs(af)
if not listfiles then return{}end

local ag={}
if not isfolder(ae.Path)then
makefolder(ae.Path)
return ag
end

for ah,ai in next,listfiles(ae.Path)do
local aj=ai:match"([^\\/]+)%.json$"
if aj then
table.insert(ag,aj)
end
end

return ag
end

function ae.GetConfig(af,ag)
return ae.Configs[ag]
end

return ae end function a.z()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


local ae=(cloneref or clonereference or function(ae)return ae end)


ae(game:GetService"UserInputService")


function aa.New(af)
local ag={
Button=nil
}

local ah













local ai=ac("TextLabel",{
Text=af.Title,
TextSize=17,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
AutomaticSize="XY",
})

local aj=ac("Frame",{
Size=UDim2.new(0,36,0,36),
BackgroundTransparency=1,
Name="Drag",
},{
ac("ImageLabel",{
Image=ab.Icon"move"[1],
ImageRectOffset=ab.Icon"move"[2].ImageRectPosition,
ImageRectSize=ab.Icon"move"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.3,
})
})
local ak=ac("Frame",{
Size=UDim2.new(0,1,1,0),
Position=UDim2.new(0,36,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=.9,
})

local al=ac("Frame",{
Size=UDim2.new(0,0,0,0),
Position=UDim2.new(0.5,0,0,28),
AnchorPoint=Vector2.new(0.5,0.5),
Parent=af.Parent,
BackgroundTransparency=1,
Active=true,
Visible=false,
})


local am=ac("UIScale",{
Scale=1,
})

local an=ac("Frame",{
Size=UDim2.new(0,0,0,44),
AutomaticSize="X",
Parent=al,
Active=false,
BackgroundTransparency=.25,
ZIndex=99,
BackgroundColor3=Color3.new(0,0,0),
},{
am,
ac("UICorner",{
CornerRadius=UDim.new(1,0)
}),
ac("UIStroke",{
Thickness=1,
ApplyStrokeMode="Border",
Color=Color3.new(1,1,1),
Transparency=0,
},{
ac("UIGradient",{
Color=ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff")
})
}),
aj,
ak,

ac("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),

ac("TextButton",{
AutomaticSize="XY",
Active=true,
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,36),

BackgroundColor3=Color3.new(1,1,1),
},{
ac("UICorner",{
CornerRadius=UDim.new(1,-4)
}),
ah,
ac("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai,
ac("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
}),
}),
ac("UIPadding",{
PaddingLeft=UDim.new(0,4),
PaddingRight=UDim.new(0,4),
})
})

ag.Button=an



function ag.SetIcon(ao,ap)
if ah then
ah:Destroy()
end
if ap then
ah=ab.Image(
ap,
af.Title,
0,
af.Folder,
"OpenButton",
true,
af.IconThemed
)
ah.Size=UDim2.new(0,22,0,22)
ah.LayoutOrder=-1
ah.Parent=ag.Button.TextButton
end
end

if af.Icon then
ag:SetIcon(af.Icon)
end



ab.AddSignal(an:GetPropertyChangedSignal"AbsoluteSize",function()
al.Size=UDim2.new(
0,an.AbsoluteSize.X,
0,an.AbsoluteSize.Y
)
end)

ab.AddSignal(an.TextButton.MouseEnter,function()
ad(an.TextButton,.1,{BackgroundTransparency=.93}):Play()
end)
ab.AddSignal(an.TextButton.MouseLeave,function()
ad(an.TextButton,.1,{BackgroundTransparency=1}):Play()
end)

local ao=ab.Drag(al)


function ag.Visible(ap,aq)
al.Visible=aq
end

function ag.SetScale(ap,aq)
am.Scale=aq
end

function ag.Edit(ap,aq)
local ar={
Title=aq.Title,
Icon=aq.Icon,
Enabled=aq.Enabled,
Position=aq.Position,
OnlyIcon=aq.OnlyIcon or false,
Draggable=aq.Draggable or nil,
OnlyMobile=aq.OnlyMobile,
CornerRadius=aq.CornerRadius or UDim.new(1,0),
StrokeThickness=aq.StrokeThickness or 2,
Scale=aq.Scale or 1,
Color=aq.Color
or ColorSequence.new(Color3.fromHex"40c9ff",Color3.fromHex"e81cff"),
}



if ar.Enabled==false then
af.IsOpenButtonEnabled=false
end

if ar.OnlyMobile~=false then
ar.OnlyMobile=true
else
af.IsPC=false
end


if ar.Draggable==false and aj and ak then
aj.Visible=ar.Draggable
ak.Visible=ar.Draggable

if ao then
ao:Set(ar.Draggable)
end
end

if ar.Position and al then
al.Position=ar.Position
end

if ar.OnlyIcon==true and ai then
ai.Visible=false
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,7)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,7)
elseif ar.OnlyIcon==false then
ai.Visible=true
an.TextButton.UIPadding.PaddingLeft=UDim.new(0,11)
an.TextButton.UIPadding.PaddingRight=UDim.new(0,11)
end





if ai then
if ar.Title then
ai.Text=ar.Title
ab:ChangeTranslationKey(ai,ar.Title)
elseif ar.Title==nil then

end
end

if ar.Icon then
ag:SetIcon(ar.Icon)
end

an.UIStroke.UIGradient.Color=ar.Color
if Glow then
Glow.UIGradient.Color=ar.Color
end

an.UICorner.CornerRadius=ar.CornerRadius
an.TextButton.UICorner.CornerRadius=UDim.new(ar.CornerRadius.Scale,ar.CornerRadius.Offset-4)
an.UIStroke.Thickness=ar.StrokeThickness

ag:SetScale(ar.Scale)
end

return ag
end



return aa end function a.A()
local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={
Container=nil,
TooltipSize=16,

TooltipArrowSizeX=ai=="Small"and 16 or 24,
TooltipArrowSizeY=ai=="Small"and 6 or 9,

PaddingX=ai=="Small"and 12 or 14,
PaddingY=ai=="Small"and 7 or 9,

Radius=999,

TitleFrame=nil,
}

ah=ah or""
aj=aj~=false

local al=ac("TextLabel",{
AutomaticSize="XY",
TextWrapped=aj,
BackgroundTransparency=1,
FontFace=Font.new(ab.Font,Enum.FontWeight.Medium),
Text=ae,
TextSize=ai=="Small"and 15 or 17,
TextTransparency=1,
ThemeTag={
TextColor3="Tooltip"..ah.."Text",
}
})

ak.TitleFrame=al

local am=ac("UIScale",{
Scale=.9
})

local an=ac("Frame",{
AnchorPoint=Vector2.new(0.5,0),
AutomaticSize="XY",
BackgroundTransparency=1,
Parent=af,

Visible=false
},{
ac("UISizeConstraint",{
MaxSize=Vector2.new(400,math.huge)
}),
ac("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
LayoutOrder=99,
Visible=ag,
Name="Arrow",
},{
ac("ImageLabel",{
Size=UDim2.new(0,ak.TooltipArrowSizeX,0,ak.TooltipArrowSizeY),
BackgroundTransparency=1,

Image="rbxassetid://105854070513330",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
},{










}),
}),
ab.NewRoundFrame(ak.Radius,"Squircle",{
AutomaticSize="XY",
ThemeTag={
ImageColor3="Tooltip"..ah,
},
ImageTransparency=1,
Name="Background",
},{



ac("Frame",{



AutomaticSize="XY",
BackgroundTransparency=1,
},{
ac("UICorner",{
CornerRadius=UDim.new(0,16),
}),
ac("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Horizontal",
VerticalAlignment="Center"
}),

al,
ac("UIPadding",{
PaddingTop=UDim.new(0,ak.PaddingY),
PaddingLeft=UDim.new(0,ak.PaddingX),
PaddingRight=UDim.new(0,ak.PaddingX),
PaddingBottom=UDim.new(0,ak.PaddingY),
}),
})
}),
am,
ac("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Center",
}),
})
ak.Container=an

function ak.Open(ao)
an.Visible=true


ad(an.Background,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.2,{TextTransparency=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.22,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function ak.Close(ao,ap)

ad(an.Background,.3,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(an.Arrow.ImageLabel,.2,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(al,.3,{TextTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ad(am,.35,{Scale=.9},Enum.EasingStyle.Quint,Enum.EasingDirection.In):Play()

ap=ap~=false
if ap then
task.wait(.35)

an.Visible=false
an:Destroy()
end
end

return ak
end



return aa end function a.B()
local aa=a.load'c'
local ab=aa.New
local ac=aa.NewRoundFrame
local ad=aa.Tween

local function Color3ToHSB(ae)
local af,ag,ah=ae.R,ae.G,ae.B
local ai=math.max(af,ag,ah)
local aj=math.min(af,ag,ah)
local ak=ai-aj

local al=0
if ak~=0 then
if ai==af then
al=(ag-ah)/ak%6
elseif ai==ag then
al=(ah-af)/ak+2
else
al=(af-ag)/ak+4
end
al=al*60
end

local am=(ai==0)and 0 or(ak/ai)
local an=ai

return{
h=math.floor(al+0.5),
s=am,
b=an,
}
end

local function GetPerceivedBrightness(ae)
local af=ae.R
local ag=ae.G
local ah=ae.B
return 0.299*af+0.587*ag+0.114*ah
end

local function GetTextColorForHSB(ae)
local af=Color3ToHSB(ae)
local ag=af.h

if GetPerceivedBrightness(ae)>0.5 then
return Color3.fromHSV(ag/360,0,0.05)
else
return Color3.fromHSV(ag/360,0,0.98)
end
end

local function getElementPosition(ae,af)
if type(af)~="number"or af~=math.floor(af)then
return nil,1
end

local ag=#ae
if ag==0 or af<1 or af>ag then
return nil,2
end

local function isDelimiter(ah)
if ah==nil then
return true
end

local ai=ah.__type
return ai=="Divider"or ai=="Space"or ai=="Section"or ai=="Code"
end

if isDelimiter(ae[af])then
return nil,3
end

local function calculate(ah,ai)
if ai==1 then
return"Squircle"
end
if ah==1 then
return"Squircle-TL-TR"
end
if ah==ai then
return"Squircle-BL-BR"
end
return"Square"
end

local ah=1
local ai=0

for aj=1,ag do
local ak=ae[aj]
if isDelimiter(ak)then
if af>=ah and af<=aj-1 then
local al=af-ah+1
return calculate(al,ai)
end
ah=aj+1
ai=0
else
ai=ai+1
end
end

if af>=ah and af<=ag then
local aj=af-ah+1
return calculate(aj,ai)
end

return nil,4
end

return function(ae)
local af={
Title=ae.Title,
Desc=ae.Desc or nil,
Hover=ae.Hover,
Thumbnail=ae.Thumbnail,
ThumbnailSize=ae.ThumbnailSize or 80,
Image=ae.Image,
IconThemed=ae.IconThemed or false,
IconAlign=ae.IconAlign or"Left",
ImageSize=ae.ImageSize or 30,
Color=ae.Color,
Scalable=ae.Scalable,
Parent=ae.Parent,
Justify=ae.Justify or"Between",
UIPadding=ae.Window.ElementConfig.UIPadding,
UICorner=ae.Window.ElementConfig.UICorner,
Size=ae.Size or"Default",
UIElements={},
Index=ae.Index,

ListRow=ae.ListRow==true,
ExpandableDesc=ae.ExpandableDesc or false,
DescExpanded=ae.DescExpanded or false,
ShowChevron=ae.ShowChevron or false,
RightSlotWidth=ae.RightSlotWidth or 0,
DividerLeftInset=ae.DividerLeftInset,
DividerRightInset=ae.DividerRightInset,
}

local ag=af.ListRow
local ah=af.Size=="Small"and-4 or af.Size=="Large"and 4 or 0
local ai=af.Size=="Small"and-4 or af.Size=="Large"and 4 or 0

local aj=af.ImageSize
local ak=af.ThumbnailSize
local al=true
local am=0
local an=af.Desc~=nil and af.Desc~=""

local ao
local ap

if af.Thumbnail then
ao=aa.Image(
af.Thumbnail,
af.Title,
ae.Window.NewElements and af.UICorner-11 or(af.UICorner-4),
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ao.Size=UDim2.new(1,0,0,ak)
end

if af.Image then
ap=aa.Image(
af.Image,
af.Title,
ae.Window.NewElements and af.UICorner-11 or(af.UICorner-4),
ae.Window.Folder,
"Image",
af.IconThemed,
not af.Color and true or false,
"ElementIcon"
)

if typeof(af.Color)=="string"and not string.find(af.Image,"rbxthumb")then
ap.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"and not string.find(af.Image,"rbxthumb")then
ap.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end

ap.Size=UDim2.new(0,aj,0,aj)
am=aj
end

local function CreateText(aq,ar)
local as=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"and GetTextColorForHSB(af.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=aq or"",
TextSize=ar=="Desc"and 15 or 17,
TextXAlignment="Left",
TextYAlignment=ar=="Desc"and"Top"or"Center",
ThemeTag={
TextColor3=not af.Color and("Element"..ar)or nil,
},
TextColor3=af.Color and as or nil,
TextTransparency=ar=="Desc"and 0.3 or 0,
TextWrapped=ar=="Desc",
TextTruncate=ar=="Desc"and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd,
Size=af.Justify=="Between"and UDim2.new(1,0,0,0)or UDim2.new(0,0,0,0),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,ar=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
})
end

local aq=CreateText(af.Title,"Title")
local ar=CreateText(af.Desc,"Desc")

if not af.Title or af.Title==""then
aq.Visible=false
end

ar.Visible=an
ar.AutomaticSize="Y"
ar.Size=UDim2.new(1,0,0,0)

local as=ab("Frame",{
Name="DescInner",
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,4),
}),
ar,
})

local at=ab("Frame",{
Name="DescHolder",
BackgroundTransparency=1,
ClipsDescendants=true,
Visible=false,
Size=UDim2.new(1,0,0,0),
},{
as,
})

local au=ab("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
VerticalAlignment="Top",
HorizontalAlignment="Left",
})

local av=ab("Frame",{
Name="TextContent",
LayoutOrder=af.IconAlign=="Right"and 1 or 2,
BackgroundTransparency=1,
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and(ap and-am-af.UIPadding or-am)or 0,
0,
0
),
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,(ae.Window.NewElements and af.UIPadding/2 or 0)+ai),
PaddingLeft=UDim.new(0,(ae.Window.NewElements and af.UIPadding/2 or 0)+ah),
PaddingRight=UDim.new(0,(ae.Window.NewElements and af.UIPadding/2 or 0)+ah),
PaddingBottom=UDim.new(0,(ae.Window.NewElements and af.UIPadding/2 or 0)+ai),
}),
au,
aq,
at,
})

local aw=ab("Frame",{
Name="ImageWrap",
LayoutOrder=af.IconAlign=="Right"and 2 or 1,
BackgroundTransparency=1,
Size=UDim2.new(0,ap and aj or 0,0,24),
Visible=ap~=nil,
},{
ap and ab("Frame",{
Name="IconCenter",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
},{
ap,
})or nil,
})

if ap then
ap.AnchorPoint=Vector2.new(0.5,0.5)
ap.Position=UDim2.new(0.5,0,0.5,0)
end

local ax=ab("Frame",{
Name="TitleFrame",
BackgroundTransparency=1,
Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and-ae.TextOffset or 0,
0,
0
),
AutomaticSize=af.Justify=="Between"and"Y"or"XY",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ap and af.UIPadding or 0),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=af.Justify~="Between"and af.Justify or"Left",
}),
aw,
av,
})

af.UIElements.Title=aq
af.UIElements.Desc=ar
af.UIElements.DescHolder=at
af.UIElements.TextContent=av
af.UIElements.RowFrame=ax
af.UIElements.ImageWrap=aw

af.UIElements.Container=ab("Frame",{
Name="Container",
Size=UDim2.new(1,0,0,32),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=af.Justify=="Between"and"Left"or"Center",
}),
ao,
ax,
})

local ay=aa.Image("lock","lock",0,ae.Window.Folder,"Lock",false)
ay.Size=UDim2.new(0,20,0,20)
ay.ImageLabel.ImageColor3=Color3.new(1,1,1)
ay.ImageLabel.ImageTransparency=0.4

local az=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local aA=ab("Frame",{
Size=UDim2.new(1,af.UIPadding*2,1,af.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local aB,b=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=aA,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ay,
az,
},nil,true)

local d,f=ac(af.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aA,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local g,h=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aA,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local j,l=ac(af.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aA,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
},nil,true)

local m,p=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=aA,
},{
ab("UIGradient",{
Name="HoverGradient",
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.25,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.75,0.9),
NumberSequenceKeypoint.new(1,1),
},
}),
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local r,u=ac(af.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=af.Color and 0.05 or 0.93,
Parent=ae.Parent,
ThemeTag={
ImageColor3=not af.Color and"ElementBackground"or nil,
},
ImageColor3=af.Color and(
typeof(af.Color)=="string"and Color3.fromHex(aa.Colors[af.Color])
or typeof(af.Color)=="Color3"and af.Color
)or nil,
},{
af.UIElements.Container,
aA,
ab("UIPadding",{
PaddingTop=UDim.new(0,af.UIPadding),
PaddingLeft=UDim.new(0,af.UIPadding),
PaddingRight=UDim.new(0,af.UIPadding),
PaddingBottom=UDim.new(0,af.UIPadding),
}),
},true,true)

af.UIElements.Main=r
af.UIElements.Locked=aB

local v
local x
local z
local A
local B

if ag then
v=ab("Frame",{
Name="RightSlot",
BackgroundTransparency=1,
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,af.UIPadding-8),
Size=UDim2.new(0,math.max(af.RightSlotWidth,af.ShowChevron and 24 or 0),0,36),
AutomaticSize="X",
Parent=r,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Right",
VerticalAlignment="Center",
Padding=UDim.new(0,10),
}),
})

if af.ShowChevron then
x=ab("Frame",{
Name="ChevronWrap",
Size=UDim2.new(0,24,0,24),
BackgroundTransparency=1,
LayoutOrder=999,
Parent=v,
})

z=ab("TextButton",{
Name="ChevronButton",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
Parent=x,
})

A=ab("TextLabel",{
Name="ChevronIcon",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="›",
TextSize=24,
TextTransparency=0.25,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
TextXAlignment="Center",
TextYAlignment="Center",
ThemeTag={
TextColor3="Text",
},
Parent=z,
})
end

B=ab("Frame",{
Name="Divider",
BackgroundTransparency=0.88,
ThemeTag={
BackgroundColor3="Text",
},
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,1,0),
Size=UDim2.new(1,0,0,1),
Visible=false,
Parent=r,
ZIndex=3,
},{
ab("UICorner",{
CornerRadius=UDim.new(0,999),
}),
})
end

af.UIElements.RightSlot=v
af.UIElements.ChevronWrap=x
af.UIElements.ChevronButton=z
af.UIElements.ChevronIcon=A
af.UIElements.Divider=B

local function GetDescTargetHeight()
local C=math.max(as.AbsoluteSize.Y,ar.TextBounds.Y+8)
if C<=0 then
C=18
end
return C
end

local function RefreshDivider()
if not ag or not B or not r or not aq then
return
end

local C=r.AbsolutePosition
local F=r.AbsoluteSize

if F.X<=0 then
return
end

local G
if af.DividerLeftInset then
G=af.DividerLeftInset
else
G=math.floor(math.max(aq.AbsolutePosition.X-C.X,18))
end

local H=F.X-af.UIPadding

if af.DividerRightInset then
H=F.X-af.DividerRightInset
end

local J=math.max(H-G,24)

B.Position=UDim2.new(0,G,1,af.UIPadding)
B.Size=UDim2.new(0,J,0,1)
end

if an then
if af.ExpandableDesc then
at.Visible=af.DescExpanded
at.Size=UDim2.new(1,0,0,af.DescExpanded and GetDescTargetHeight()or 0)
else
at.Visible=true
at.Size=UDim2.new(1,0,0,GetDescTargetHeight())
end
else
at.Visible=false
at.Size=UDim2.new(1,0,0,0)
end

function af.SetExpanded(C,F,G)
if not af.ExpandableDesc or not an then
return
end

af.DescExpanded=F==true

if af.DescExpanded then
at.Visible=true
local H=GetDescTargetHeight()

if G then
at.Size=UDim2.new(1,0,0,H)
if A then
A.Rotation=90
end
else
ad(at,0.20,{
Size=UDim2.new(1,0,0,H),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if A then
ad(A,0.20,{
Rotation=90,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
else
if G then
at.Size=UDim2.new(1,0,0,0)
at.Visible=false
if A then
A.Rotation=0
end
else
ad(at,0.20,{
Size=UDim2.new(1,0,0,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if A then
ad(A,0.20,{
Rotation=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.delay(0.20,function()
if not af.DescExpanded then
at.Visible=false
end
end)
end
end

task.defer(RefreshDivider)
end

function af.ToggleExpanded(C)
af:SetExpanded(not af.DescExpanded,false)
end

if an and af.ExpandableDesc then
af:SetExpanded(af.DescExpanded,true)

if z then
aa.AddSignal(z.MouseButton1Click,function()
af:ToggleExpanded()
end)
end
end

if ag and v then
aa.AddSignal(r:GetPropertyChangedSignal"AbsoluteSize",function()
task.defer(RefreshDivider)
end)

aa.AddSignal(v:GetPropertyChangedSignal"AbsoluteSize",function()
task.defer(RefreshDivider)
end)

aa.AddSignal(aq:GetPropertyChangedSignal"TextBounds",function()
task.defer(RefreshDivider)
end)

task.defer(RefreshDivider)
end

if af.Hover then
aa.AddSignal(r.MouseEnter,function()
if al then
ad(r,0.12,{ImageTransparency=af.Color and 0.15 or 0.9}):Play()
ad(m,0.12,{ImageTransparency=0.9}):Play()
ad(j,0.12,{ImageTransparency=0.8}):Play()

aa.AddSignal(r.MouseMoved,function(C)
m.HoverGradient.Offset=
Vector2.new(((C-r.AbsolutePosition.X)/r.AbsoluteSize.X)-0.5,0)
j.HoverGradient.Offset=
Vector2.new(((C-r.AbsolutePosition.X)/r.AbsoluteSize.X)-0.5,0)
end)
end
end)

aa.AddSignal(r.InputEnded,function()
if al then
ad(r,0.12,{ImageTransparency=af.Color and 0.05 or 0.93}):Play()
ad(m,0.12,{ImageTransparency=1}):Play()
ad(j,0.12,{ImageTransparency=1}):Play()
end
end)
end

function af.SetTitle(C,F)
af.Title=F
aq.Text=F
task.defer(RefreshDivider)
end

function af.SetDesc(C,F)
af.Desc=F
ar.Text=F or""
an=F~=nil and F~=""

if not an then
ar.Visible=false
at.Visible=false
at.Size=UDim2.new(1,0,0,0)
if x then
x.Visible=false
end
else
ar.Visible=true
if x then
x.Visible=true
end

if af.ExpandableDesc then
if af.DescExpanded then
af:SetExpanded(true,true)
else
at.Visible=false
at.Size=UDim2.new(1,0,0,0)
end
else
at.Visible=true
at.Size=UDim2.new(1,0,0,GetDescTargetHeight())
end
end

task.defer(RefreshDivider)
end

function af.Colorize(C,F,G)
if af.Color then
F[G]=typeof(af.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
or typeof(af.Color)=="Color3"and GetTextColorForHSB(af.Color)
or nil
end
end

if ae.ElementTable then
aa.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if af.Title~=aq.Text then
af:SetTitle(aq.Text)
ae.ElementTable.Title=aq.Text
end
end)

aa.AddSignal(ar:GetPropertyChangedSignal"Text",function()
if af.Desc~=ar.Text then
af:SetDesc(ar.Text)
ae.ElementTable.Desc=ar.Text
end
end)
end

function af.SetThumbnail(C,F,G)
af.Thumbnail=F
if G then
af.ThumbnailSize=G
ak=G
end

if ao then
if F then
ao:Destroy()
ao=aa.Image(
F,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ao.Size=UDim2.new(1,0,0,ak)
ao.Parent=af.UIElements.Container
local H=af.UIElements.Container:FindFirstChild"UIListLayout"
if H then
ao.LayoutOrder=-1
end
else
ao.Visible=false
end
else
if F then
ao=aa.Image(
F,
af.Title,
af.UICorner-3,
ae.Window.Folder,
"Thumbnail",
false,
af.IconThemed
)
ao.Size=UDim2.new(1,0,0,ak)
ao.Parent=af.UIElements.Container
local H=af.UIElements.Container:FindFirstChild"UIListLayout"
if H then
ao.LayoutOrder=-1
end
end
end

task.defer(RefreshDivider)
end

function af.SetImage(C,F,G)
af.Image=F
if G then
af.ImageSize=G
aj=G
end

if F then
if ap then
ap:Destroy()
end

ap=aa.Image(
F,
F,
af.UICorner-3,
ae.Window.Folder,
"Image",
not af.Color and true or false
)

if typeof(af.Color)=="string"and not string.find(F,"rbxthumb")then
ap.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[af.Color]))
elseif typeof(af.Color)=="Color3"and not string.find(F,"rbxthumb")then
ap.ImageLabel.ImageColor3=GetTextColorForHSB(af.Color)
end

ap.Size=UDim2.new(0,aj,0,aj)
ap.AnchorPoint=Vector2.new(0.5,0.5)
ap.Position=UDim2.new(0.5,0,0.5,0)
ap.Parent=aw

aw.Visible=true
aw.Size=UDim2.new(0,aj,0,24)
am=aj
else
if ap then
ap.Visible=false
end
aw.Visible=false
aw.Size=UDim2.new(0,0,0,24)
am=0
end

av.Size=UDim2.new(
af.Justify=="Between"and 1 or 0,
af.Justify=="Between"and(aw.Visible and-am-af.UIPadding or 0)or 0,
1,
0
)

local H=ax:FindFirstChildOfClass"UIListLayout"
if H then
H.Padding=UDim.new(0,aw.Visible and af.UIPadding or 0)
end

task.defer(RefreshDivider)
end

function af.Destroy(C)
r:Destroy()
end

function af.Lock(C,F)
al=false
aB.Active=true
aB.Visible=true
az.Text=F or"Locked"
end

function af.Unlock(C)
al=true
aB.Active=false
aB.Visible=false
end

function af.Highlight(C)
local F=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.1,0.9),
NumberSequenceKeypoint.new(0.5,0.3),
NumberSequenceKeypoint.new(0.9,0.9),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=d,
})

local G=ab("UIGradient",{
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(0.5,Color3.new(1,1,1)),
ColorSequenceKeypoint.new(1,Color3.new(1,1,1)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,1),
NumberSequenceKeypoint.new(0.15,0.8),
NumberSequenceKeypoint.new(0.5,0.1),
NumberSequenceKeypoint.new(0.85,0.8),
NumberSequenceKeypoint.new(1,1),
},
Rotation=0,
Offset=Vector2.new(-1,0),
Parent=g,
})

d.ImageTransparency=0.65
g.ImageTransparency=0.88

ad(F,0.75,{
Offset=Vector2.new(1,0),
}):Play()

ad(G,0.75,{
Offset=Vector2.new(1,0),
}):Play()

task.spawn(function()
task.wait(0.75)
d.ImageTransparency=1
g.ImageTransparency=1
F:Destroy()
G:Destroy()
end)
end

function af.UpdateShape(C)
if ae.Window.NewElements then
local F
if ae.ParentConfig.ParentType=="Group"then
F="Squircle"
else
F=getElementPosition(C.Elements,af.Index)
end

if F and r then
u:SetType(F)
b:SetType(F)
h:SetType(F)
f:SetType(F.."-Outline")
p:SetType(F)
l:SetType(F.."-Outline")

if ag and B then
B.Visible=(F=="Square"or F=="Squircle-TL-TR")
task.defer(RefreshDivider)
end
end
end
end

return af
end end function a.C()

local aa=a.load'c'
local ab=aa.New

local ac={}

local ad=a.load'l'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
af.ListRow=true
af.IsButtons=af.Buttons and#af.Buttons>0 and true or false

local ag={
__type="Paragraph",
Title=af.Title or"Paragraph",
Desc=af.Desc or nil,
Locked=af.Locked or false,
}

local ah=a.load'B'(af)

ag.ParagraphFrame=ah

if af.Buttons and#af.Buttons>0 then
local ai=ab("Frame",{
Size=UDim2.new(1,0,0,38),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ah.UIElements.Container,
},{
ab("UIListLayout",{
Padding=UDim.new(0,af.Window.NewElements and 8 or 10),
FillDirection="Vertical",
}),
})

for aj,ak in next,af.Buttons do
local al=ad(
ak.Title,
ak.Icon,
ak.Callback,
"White",
ai,
nil,
nil,
af.Window.NewElements and 999 or 10
)
al.Size=UDim2.new(1,0,0,38)
end
end

return ag.__type,ag
end

return ac end function a.D()

local aa=a.load'c'local ab=
aa.New

local ac={}

function ac.New(ad,ae)
local af={
__type="Button",
Title=ae.Title or"Button",
Desc=ae.Desc or nil,
Icon=ae.Icon or"mouse-pointer-click",
IconThemed=ae.IconThemed or false,
Color=ae.Color,
Justify=ae.Justify or"Between",
IconAlign=ae.IconAlign or"Right",
Locked=ae.Locked or false,
LockedTitle=ae.LockedTitle,
Callback=ae.Callback or function()end,
UIElements={},
}

local ag=true
local ah=ae.Window.NewElements==true
and ae.ParentType~="Group"
and ae.Size~="Small"

af.ButtonFrame=a.load'B'{
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,
Window=ae.Window,
Color=af.Color,
Justify=ah and"Between"or af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
Size=ae.Size,

ListRow=ah,
}

af.UIElements.ButtonIcon=aa.Image(
af.Icon,
af.Icon,
0,
ae.Window.Folder,
"Button",
not af.Color and true or nil,
af.IconThemed
)

af.UIElements.ButtonIcon.Size=UDim2.new(0,20,0,20)

if af.Justify=="Between"then
af.UIElements.ButtonIcon.Parent=af.ButtonFrame.UIElements.Main
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,af.IconAlign=="Right"and-32 or-16,0.5,0)
else
af.UIElements.ButtonIcon.Parent=af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
end

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ai)
af.Locked=true
ag=false
return af.ButtonFrame:Lock(af.LockedTitle)
end

function af.Unlock(ai)
af.Locked=false
ag=true
return af.ButtonFrame:Unlock()
end

if af.Locked then
af:Lock()
end

aa.AddSignal(af.ButtonFrame.UIElements.Main.MouseButton1Click,function()
if ag then
task.spawn(function()
aa.SafeCallback(af.Callback)
end)
end
end)

return af.__type,af
end

return ac end function a.E()

local aa={}

local ab=a.load'c'
local ac=ab.New
local ad=ab.Tween

local ae=game:GetService"UserInputService"

local function Disconnect(af)
if af then
af:Disconnect()
return nil
end
return nil
end

function aa.New(af,ag,ah,ai,aj,ak,al)
local am={
Value=af==true,
}

local an=12
local ao=(ag and ag~="")and ab.Icon(ag)or nil
local ap=ah or 13
local aq

if ao then
aq=ac("ImageLabel",{
Size=UDim2.new(0,ap,0,ap),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Image=ao[1],
ImageRectOffset=ao[2].ImageRectPosition,
ImageRectSize=ao[2].ImageRectSize,
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=4,
})
end

local ar=ak and 48 or 40
local as=24
local at=ak and 22 or 18
local au=20
local av=2
local aw=ar-at-2

local ax=ac("Frame",{
Size=UDim2.new(0,ar,0,as),
BackgroundTransparency=1,
Parent=ai,
})

local ay=ab.NewRoundFrame(an,"Squircle",{
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text",
},
Parent=ax,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0,0),
Position=UDim2.new(0,0,0,0),
},{
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(an,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.82,
},{
ac("UIGradient",{
Rotation=90,
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0.15),
NumberSequenceKeypoint.new(1,1),
},
}),
}),
ab.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,8,0,8),
Position=UDim2.new(1,-12,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="OffDot",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.35,
ZIndex=3,
}),
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(0,at,0,au),
Position=UDim2.new(0,av,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ImageTransparency=1,
Name="Frame",
},{
ab.NewRoundFrame(an+6,"Squircle",{
Size=UDim2.new(1,10,1,10),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="Glow",
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=1,
ZIndex=1,
}),
ab.NewRoundFrame(an,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0,
ThemeTag={
ImageColor3="ToggleBar",
},
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Bar",
ZIndex=3,
},{
ab.NewRoundFrame(an,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.45,
ZIndex=4,
}),
aq,
ac("UIScale",{
Scale=1,
}),
}),
}),
})

local az
local aA
local aB=0

local function PlayPulse()
aB+=1
local b=aB

ad(ay.Frame.Bar.UIScale,0.12,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

local d=ad(ay.Frame.Glow,0.12,{
Size=UDim2.new(1,16,1,16),
ImageTransparency=0.62,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out)
d:Play()

task.delay(0.13,function()
if b~=aB then
return
end

ad(ay.Frame.Bar.UIScale,0.18,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(ay.Frame.Glow,0.2,{
Size=UDim2.new(1,10,1,10),
ImageTransparency=0.76,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Set(b,d,f,g)
am.Value=d==true
f=f~=false

if not g then
ad(ay.Frame,0.16,{
Position=UDim2.new(0,am.Value and aw or av,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
else
ay.Frame.Position=UDim2.new(0,am.Value and aw or av,0.5,0)
end

if am.Value then
ad(ay.Layer,0.14,{
ImageTransparency=0.3,
}):Play()

ad(ay.Stroke,0.14,{
ImageTransparency=0.68,
}):Play()

ad(ay.OffDot,0.12,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if aq then
ad(aq,0.1,{
ImageTransparency=0,
}):Play()
end

if g then
ay.Frame.Glow.ImageTransparency=0.76
ay.Frame.Glow.Size=UDim2.new(1,10,1,10)
else
PlayPulse()
end
else
aB+=1

ad(ay.Layer,0.14,{
ImageTransparency=1,
}):Play()

ad(ay.Stroke,0.14,{
ImageTransparency=0.82,
}):Play()

ad(ay.OffDot,0.12,{
ImageTransparency=0.35,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if aq then
ad(aq,0.1,{
ImageTransparency=1,
}):Play()
end

ad(ay.Frame.Glow,0.18,{
ImageTransparency=1,
Size=UDim2.new(1,6,1,6),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(ay.Frame.Bar.UIScale,0.18,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
if aj and f then
ab.SafeCallback(aj,am.Value)
end
end)
end

function am.Animate(b,d,f)
if not al or not al.Window or al.Window.IsToggleDragging then
return
end

al.Window.IsToggleDragging=true

local g=d.Position.X
local h=d.Position.Y
local j=ay.Frame.Position.X.Offset
local l=false

ad(ay.Frame.Bar.UIScale,0.18,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if f.Value then
ad(ay.Frame.Glow,0.18,{
ImageTransparency=0.68,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

az=Disconnect(az)

az=ae.InputChanged:Connect(function(m)
if
al.Window.IsToggleDragging
and(m.UserInputType==Enum.UserInputType.MouseMovement
or m.UserInputType==Enum.UserInputType.Touch)
then
if l then
return
end

local p=math.abs(m.Position.X-g)
local r=math.abs(m.Position.Y-h)

if r>p and r>10 then
l=true
al.Window.IsToggleDragging=false

az=Disconnect(az)
aA=Disconnect(aA)

ad(ay.Frame,0.15,{
Position=UDim2.new(0,j,0.5,0),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ad(ay.Frame.Bar.UIScale,0.18,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

return
end

local u=m.Position.X-g
local v=math.max(av,math.min(j+u,aw))

ad(ay.Frame,0.05,{
Position=UDim2.new(0,v,0.5,0),
},Enum.EasingStyle.Linear,Enum.EasingDirection.Out):Play()
end
end)

aA=Disconnect(aA)

aA=ae.InputEnded:Connect(function(m)
if
al.Window.IsToggleDragging
and(m.UserInputType==Enum.UserInputType.MouseButton1
or m.UserInputType==Enum.UserInputType.Touch)
then
al.Window.IsToggleDragging=false

az=Disconnect(az)
aA=Disconnect(aA)

if l then
return
end

local p=ay.Frame.Position.X.Offset
local r=math.abs(m.Position.X-g)

if r<10 then
f:Set(not f.Value,true,false)
else
local u=p+(at/2)
local v=ar/2
f:Set(u>v,true,false)
end

ad(ay.Frame.Bar.UIScale,0.18,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end)
end

return ax,am
end

return aa end function a.F()

local aa={}

local ab=a.load'c'local ac=
ab.New
local ad=ab.Tween


function aa.New(ae,af,ag,ah,ai,aj)
local ak={}

af=af or"sfsymbols:checkmark"

local al=9

local am=ab.Image(
af,
af,
0,
(aj and aj.Window.Folder or"Temp"),
"Checkbox",
true,
false,
"CheckboxIcon"
)
am.Size=UDim2.new(1,-26+ag,1,-26+ag)
am.AnchorPoint=Vector2.new(0.5,0.5)
am.Position=UDim2.new(0.5,0,0.5,0)


local an=ab.NewRoundFrame(al,"Squircle",{
ImageTransparency=.85,
ThemeTag={
ImageColor3="Text"
},
Parent=ah,
Size=UDim2.new(0,26,0,26),
},{
ab.NewRoundFrame(al,"Squircle",{
Size=UDim2.new(1,0,1,0),
Name="Layer",
ThemeTag={
ImageColor3="Checkbox",
},
ImageTransparency=1,
}),
ab.NewRoundFrame(al,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Stroke",
ThemeTag={
ImageColor3="CheckboxBorder",
ImageTransparency="CheckboxBorderTransparency",
},
},{







}),

am,
})

function ak.Set(ao,ap)
if ap then
ad(an.Layer,0.06,{
ImageTransparency=0,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=0,
}):Play()
else
ad(an.Layer,0.05,{
ImageTransparency=1,
}):Play()



ad(am.ImageLabel,0.06,{
ImageTransparency=1,
}):Play()
end

task.spawn(function()
if ai then
ab.SafeCallback(ai,ap)
end
end)
end

return an,ak
end


return aa end function a.G()
local aa=a.load'c'local ab=
aa.New local ac=
aa.Tween

local ad=a.load'E'.New
local ae=a.load'F'.New

local af={}

local function IsInside(ag,ah,ai)
if not ag or not ag.Visible then
return false
end

ai=ai or 0

local aj=ag.AbsolutePosition
local ak=ag.AbsoluteSize

return ah.X>=(aj.X-ai)
and ah.X<=(aj.X+ak.X+ai)
and ah.Y>=(aj.Y-ai)
and ah.Y<=(aj.Y+ak.Y+ai)
end

function af.New(ag,ah)
local ai={
__type="Toggle",
Title=ah.Title or"Toggle",
Desc=ah.Desc or nil,
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
Value=ah.Value,
Icon=ah.Icon or nil,
IconThemed=ah.IconThemed or false,
IconSize=ah.IconSize or 23,
Type=ah.Type or"Toggle",
Callback=ah.Callback or function()end,
UIElements={},
}

local aj=ai.Desc~=nil and ai.Desc~=""

ai.ToggleFrame=a.load'B'{
Title=ai.Title,
Desc=ai.Desc,
Image=ai.Icon,
ImageSize=ai.Icon and math.max((ai.IconSize or 23)-3,18)or nil,
IconThemed=ai.IconThemed,

Window=ah.Window,
Parent=ah.Parent,
TextOffset=aj and 140 or 108,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
ElementTable=ai,
ParentConfig=ah,

ListRow=ah.Window.NewElements==true,
ExpandableDesc=aj,
DescExpanded=false,
ShowChevron=aj,
RightSlotWidth=aj and 120 or 90,
}

local ak=true

if ai.Value==nil then
ai.Value=false
end

function ai.Lock(al)
ai.Locked=true
ak=false
return ai.ToggleFrame:Lock(ai.LockedTitle)
end

function ai.Unlock(al)
ai.Locked=false
ak=true
return ai.ToggleFrame:Unlock()
end

if ai.Locked then
ai:Lock()
end

local al=ai.Value

local am,an
if ai.Type=="Toggle"then
am,an=ad(
al,
nil,
ai.IconSize,
ai.ToggleFrame.UIElements.Main,
ai.Callback,
ah.Window.NewElements,
ah
)
elseif ai.Type=="Checkbox"then
am,an=ae(
al,
nil,
ai.IconSize,
ai.ToggleFrame.UIElements.Main,
ai.Callback,
ah
)
else
error("Unknown Toggle Type: "..tostring(ai.Type))
end

if ai.ToggleFrame.UIElements.RightSlot then
am.Parent=ai.ToggleFrame.UIElements.RightSlot
am.LayoutOrder=1
else
am.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
am.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)
end

function ai.Set(ao,ap,aq,ar)
if ak then
an:Set(ap,aq,ar or false)
al=ap
ai.Value=ap
end
end

ai:Set(al,false,ah.Window.NewElements)

local function PressingChevron(ao)
local ap=ai.ToggleFrame.UIElements.ChevronButton
if not ap or not ao or not ao.Position then
return false
end
return IsInside(ap,ao.Position,8)
end

if ah.Window.NewElements and an.Animate then
aa.AddSignal(ai.ToggleFrame.UIElements.Main.InputBegan,function(ao)
if ai.Locked then
return
end

if PressingChevron(ao)then
return
end

if
not ah.Window.IsToggleDragging
and(ao.UserInputType==Enum.UserInputType.MouseButton1 or ao.UserInputType==Enum.UserInputType.Touch)
then
an:Animate(ao,ai)
end
end)
else
aa.AddSignal(ai.ToggleFrame.UIElements.Main.MouseButton1Click,function()
if ai.Locked then
return
end

local ao=game:GetService"UserInputService":GetMouseLocation()
if IsInside(ai.ToggleFrame.UIElements.ChevronButton,ao,8)then
return
end

ai:Set(not ai.Value,nil,ah.Window.NewElements)
end)
end

return ai.__type,ai
end

return af end function a.H()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ac=aa(game:GetService"UserInputService")
local ad=aa(game:GetService"RunService")

local ae=a.load'c'
local af=ae.New
local ag=ae.Tween

local ah={}

local ai=false

local function GetPrecisionFromStep(aj)
local ak=tostring(aj or 1)
local al=ak:match"%.(%d+)"
return al and#al or 0
end

local function CreateLegacySlider(aj)
local ak={
__type="Slider",
Title=aj.Title or nil,
Desc=aj.Desc or nil,
Locked=aj.Locked or nil,
LockedTitle=aj.LockedTitle,
Value=aj.Value or{},
Icons=aj.Icons or nil,
IsTooltip=aj.IsTooltip or false,

InputBox=aj.InputBox,
IsTextbox=aj.IsTextbox,

Step=aj.Step or 1,
Precision=aj.Precision,

Callback=aj.Callback or function()end,
UIElements={},
IsFocusing=false,

TextBoxWidth=aj.Window.NewElements and 36 or 30,
TextBoxHeight=aj.Window.NewElements and 28 or 26,
ThumbSize=13,
IconSize=aj.Window.NewElements and 16 or 14,
RailHeight=4,
BodyHeight=aj.Window.NewElements and 28 or 26,
}

if ak.InputBox==nil then
ak.InputBox=ak.IsTextbox
end
ak.InputBox=ak.InputBox==true

local al
local am
local an

local ao=ak.Value.Min or 0
local ap=ak.Value.Max or 100
local aq=ak.Value.Default or ao

local ar=true
local as=ak.Precision
if as==nil then
as=GetPrecisionFromStep(ak.Step)
end

local function FormatValue(at)
if as>0 then
return string.format("%."..as.."f",at)
end
return tostring(math.floor(at+0.5))
end

local function NormalizeValue(at)
at=tonumber(at)or aq or ao
at=math.clamp(at,ao,ap)

local au=ak.Step or 1
if au>0 then
at=ao+(math.floor(((at-ao)/au)+0.5)*au)
end

at=math.clamp(at,ao,ap)

if as>0 then
at=tonumber(string.format("%."..as.."f",at))
else
at=math.floor(at+0.5)
end

return at
end

local function ValueToDelta(at)
if ap==ao then
return 0
end
return math.clamp((at-ao)/(ap-ao),0,1)
end

local at=aj.Window.NewElements and(ak.ThumbSize*2)or(ak.ThumbSize+2)
local au=aj.Window.NewElements and(ak.ThumbSize+4)or(ak.ThumbSize+2)
local av=math.floor(at/2)

local aw,ax
local ay=0
local az=0

if ak.Icons then
if ak.Icons.From then
aw=ae.Image(
ak.Icons.From,
ak.Icons.From,
0,
aj.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
aw.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
ay=ak.IconSize+6
end

if ak.Icons.To then
ax=ae.Image(
ak.Icons.To,
ak.Icons.To,
0,
aj.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
ax.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
az=ak.IconSize+6
end
end

ak.SliderFrame=a.load'B'{
Title=nil,
Desc=nil,
Parent=aj.Parent,
TextOffset=0,
Hover=false,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
}

ak.UIElements.Root=af("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ak.SliderFrame.UIElements.Main,
},{
af("UIListLayout",{
Padding=UDim.new(0,(ak.Title or ak.InputBox)and 8 or 0),
FillDirection="Vertical",
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
}),
})

local aA=ak.Title~=nil or ak.InputBox

ak.UIElements.HeaderRow=af("Frame",{
Size=UDim2.new(1,0,0,aA and ak.TextBoxHeight or 0),
BackgroundTransparency=1,
Visible=aA,
Parent=ak.UIElements.Root,
LayoutOrder=1,
ClipsDescendants=false,
})

if ak.Title then
ak.UIElements.TitleAccent=ae.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(0,10,0,3),
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
ThemeTag={
ImageColor3="Slider",
},
ImageTransparency=0.08,
Parent=ak.UIElements.HeaderRow,
})
end

ak.UIElements.TitleLabel=af("TextLabel",{
Size=UDim2.new(1,ak.InputBox and-(ak.TextBoxWidth+12)or 0,1,0),
Position=UDim2.new(0,ak.Title and 16 or 0,0,0),
BackgroundTransparency=1,
Text=ak.Title or"",
Visible=ak.Title~=nil,
TextXAlignment="Left",
TextYAlignment="Center",
TextSize=15,
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.04,
Parent=ak.UIElements.HeaderRow,
})

if ak.InputBox then
ak.UIElements.TextBox=af("TextBox",{
Size=UDim2.new(0,ak.TextBoxWidth,0,ak.TextBoxHeight),
Position=UDim2.new(1,2,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
TextXAlignment="Center",
ClearTextOnFocus=false,
Text=FormatValue(aq),
TextSize=14,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.08,
Parent=ak.UIElements.HeaderRow,
},{
ae.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text",
},
ZIndex=0,
}),
ae.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.78,
ImageColor3=Color3.new(1,1,1),
Name="Stroke",
ZIndex=0,
}),
af("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
})
end

ak.UIElements.BodyRow=af("Frame",{
Size=UDim2.new(1,0,0,ak.BodyHeight),
BackgroundTransparency=1,
Parent=ak.UIElements.Root,
LayoutOrder=2,
})

if aw then
aw.AnchorPoint=Vector2.new(0,0.5)
aw.Position=UDim2.new(0,0,0.5,0)
aw.Parent=ak.UIElements.BodyRow
end

if ax then
ax.AnchorPoint=Vector2.new(1,0.5)
ax.Position=UDim2.new(1,0,0.5,0)
ax.Parent=ak.UIElements.BodyRow
end

ak.UIElements.RailHitbox=af("Frame",{
Size=UDim2.new(1,-(ay+az),0,ak.BodyHeight),
Position=UDim2.new(0,ay,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
Parent=ak.UIElements.BodyRow,
ClipsDescendants=false,
})

ak.UIElements.TrackInset=af("Frame",{
Size=UDim2.new(1,-(av*2),1,0),
Position=UDim2.new(0,av,0,0),
BackgroundTransparency=1,
Parent=ak.UIElements.RailHitbox,
})

ak.UIElements.Track=ae.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.95,
Size=UDim2.new(1,0,0,ak.RailHeight),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Track",
ThemeTag={
ImageColor3="Text",
},
Parent=ak.UIElements.TrackInset,
})

ak.UIElements.Fill=ae.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=UDim2.new(ValueToDelta(aq),0,1,0),
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Slider",
},
Parent=ak.UIElements.Track,
},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,at,0,au),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
ZIndex=2,
},{
ae.NewRoundFrame(99,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.6,
ZIndex=3,
}),
}),
})

local aB
if ak.IsTooltip then
aB=a.load'A'.New(aq,ak.UIElements.Fill.Thumb,true,"Secondary","Small",false)
aB.Container.AnchorPoint=Vector2.new(0.5,1)
aB.Container.Position=UDim2.new(0.5,0,0,-8)
end

function ak.Lock(b)
ak.Locked=true
ar=false
return ak.SliderFrame:Lock(ak.LockedTitle)
end

function ak.Unlock(b)
ak.Locked=false
ar=true
return ak.SliderFrame:Unlock()
end

if ak.Locked then
ak:Lock()
end

local function GetScrollingFrameParent()
local b=aj.Tab and aj.Tab.UIElements and aj.Tab.UIElements.ContainerFrame
if b and b:IsA"ScrollingFrame"then
return b
end

local d=ak.SliderFrame.UIElements.Main:FindFirstAncestorWhichIsA"ScrollingFrame"
if d then
return d
end

return nil
end

local b=GetScrollingFrameParent()

local function UpdateVisuals(d,f,g)
local h=ValueToDelta(d)

if f then
ag(ak.UIElements.Fill,0.05,{
Size=UDim2.new(h,0,1,0),
}):Play()
else
ak.UIElements.Fill.Size=UDim2.new(h,0,1,0)
end

if ak.InputBox and ak.UIElements.TextBox and not g then
ak.UIElements.TextBox.Text=FormatValue(d)
end

if aB then
aB.TitleFrame.Text=FormatValue(d)
end
end

local function CommitValue(d,f,g,h)
if not ar then
return
end

d=NormalizeValue(d)
UpdateVisuals(d,g,h)

local j=d~=aq
aq=d
ak.Value.Default=d

if j and f then
ae.SafeCallback(ak.Callback,d)
end
end

function ak.Set(d,f,g)
if not ar then
return
end

if not ak.IsFocusing and not ai and g and(g.UserInputType==Enum.UserInputType.MouseButton1 or g.UserInputType==Enum.UserInputType.Touch)then
al=(g.UserInputType==Enum.UserInputType.Touch)
if b then
b.ScrollingEnabled=false
end
ai=true

local function UpdateFromPointer()
local h=al and g.Position.X or ac:GetMouseLocation().X
local j=math.clamp((h-ak.UIElements.TrackInset.AbsolutePosition.X)/ak.UIElements.TrackInset.AbsoluteSize.X,0,1)
local l=ao+j*(ap-ao)
CommitValue(l,true,true,false)
end

UpdateFromPointer()

am=ad.RenderStepped:Connect(function()
UpdateFromPointer()
end)

an=ac.InputEnded:Connect(function(h)
if(h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch)and g==h then
if am then
am:Disconnect()
am=nil
end
if an then
an:Disconnect()
an=nil
end

ai=false
if b then
b.ScrollingEnabled=true
end

if aj.Window.NewElements then
ag(ak.UIElements.Fill.Thumb,0.2,{
ImageTransparency=0,
Size=UDim2.new(0,at,0,au),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

if aB then
aB:Close(false)
end
end
end)
elseif not g then
CommitValue(f,true,true,false)
end
end

function ak.SetMax(d,f)
ap=f
ak.Value.Max=f

if aq>f then
ak:Set(f)
else
UpdateVisuals(aq,true,ak.IsFocusing)
end
end

function ak.SetMin(d,f)
ao=f
ak.Value.Min=f

if aq<f then
ak:Set(f)
else
UpdateVisuals(aq,true,ak.IsFocusing)
end
end

if ak.InputBox and ak.UIElements.TextBox then
ae.AddSignal(ak.UIElements.TextBox.Focused,function()
ak.IsFocusing=true

ag(ak.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.45,
}):Play()
end)

ae.AddSignal(ak.UIElements.TextBox:GetPropertyChangedSignal"Text",function()
if not ak.IsFocusing then
return
end

local d=tonumber(ak.UIElements.TextBox.Text)
if d~=nil then
local f=NormalizeValue(d)
UpdateVisuals(f,true,true)
end
end)

ae.AddSignal(ak.UIElements.TextBox.FocusLost,function()
ak.IsFocusing=false

ag(ak.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.78,
}):Play()

local d=tonumber(ak.UIElements.TextBox.Text)
if d~=nil then
CommitValue(d,true,true,false)
else
ak.UIElements.TextBox.Text=FormatValue(aq)
if aB then
aB.TitleFrame.Text=FormatValue(aq)
end
end
end)
end

ae.AddSignal(ak.UIElements.RailHitbox.InputBegan,function(d)
if ak.Locked or ai then
return
end

ak:Set(aq,d)

if d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch then
if aj.Window.NewElements then
ag(ak.UIElements.Fill.Thumb,0.24,{
ImageTransparency=0.85,
Size=UDim2.new(0,at+8,0,au+4),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if aB then
aB:Open()
end
end
end)

return ak.__type,ak
end

function ah.New(aj,ak)
local al=ak.Window.NewElements==true and ak.ParentType~="Group"

if not al then
return CreateLegacySlider(ak)
end

local am={
__type="Slider",
Title=ak.Title or nil,
Desc=ak.Desc or nil,
Locked=ak.Locked or nil,
LockedTitle=ak.LockedTitle,
Value=ak.Value or{},
Icons=ak.Icons or nil,
IsTooltip=ak.IsTooltip or false,

InputBox=ak.InputBox,
IsTextbox=ak.IsTextbox,
Step=ak.Step or 1,
Precision=ak.Precision,

Callback=ak.Callback or function()end,
UIElements={},
IsFocusing=false,

TextBoxWidth=ak.Window.NewElements and 58 or 52,
TextBoxHeight=ak.Window.NewElements and 28 or 26,
ThumbSize=13,
IconSize=ak.Window.NewElements and 16 or 14,
RailHeight=4,
BodyHeight=ak.Window.NewElements and 28 or 26,
}

if am.InputBox==nil then
am.InputBox=am.IsTextbox
end
am.InputBox=am.InputBox==true

local an
local ao
local ap

local aq=am.Value.Min or 0
local ar=am.Value.Max or 100
local as=am.Value.Default or aq

local at=true
local au=am.Precision
if au==nil then
au=GetPrecisionFromStep(am.Step)
end

local function FormatValue(av)
if au>0 then
return string.format("%."..au.."f",av)
end
return tostring(math.floor(av+0.5))
end

local function NormalizeValue(av)
av=tonumber(av)or as or aq
av=math.clamp(av,aq,ar)

local aw=am.Step or 1
if aw>0 then
av=aq+(math.floor(((av-aq)/aw)+0.5)*aw)
end

av=math.clamp(av,aq,ar)

if au>0 then
av=tonumber(string.format("%."..au.."f",av))
else
av=math.floor(av+0.5)
end

return av
end

local function ValueToDelta(av)
if ar==aq then
return 0
end
return math.clamp((av-aq)/(ar-aq),0,1)
end

local av=ak.Window.NewElements and(am.ThumbSize*2)or(am.ThumbSize+2)
local aw=ak.Window.NewElements and(am.ThumbSize+4)or(am.ThumbSize+2)
local ax=math.floor(av/2)

local ay,az
local aA=0
local aB=0

if am.Icons then
if am.Icons.From then
ay=ae.Image(
am.Icons.From,
am.Icons.From,
0,
ak.Window.Folder,
"SliderIconFrom",
true,
true,
"SliderIconFrom"
)
ay.Size=UDim2.new(0,am.IconSize,0,am.IconSize)
aA=am.IconSize+8
end

if am.Icons.To then
az=ae.Image(
am.Icons.To,
am.Icons.To,
0,
ak.Window.Folder,
"SliderIconTo",
true,
true,
"SliderIconTo"
)
az.Size=UDim2.new(0,am.IconSize,0,am.IconSize)
aB=am.IconSize+8
end
end

am.SliderFrame=a.load'B'{
Title=am.Title,
Desc=am.Desc,
Parent=ak.Parent,
TextOffset=am.InputBox and(am.TextBoxWidth+24)or 0,
Hover=false,
Tab=ak.Tab,
Index=ak.Index,
Window=ak.Window,
ElementTable=am,
ParentConfig=ak,

ListRow=true,
ShowChevron=false,
ExpandableDesc=false,
RightSlotWidth=am.InputBox and am.TextBoxWidth or 0,
}

local b=am.SliderFrame.UIElements.Container

if am.InputBox and am.SliderFrame.UIElements.RightSlot then
am.UIElements.TextBox=af("TextBox",{
Size=UDim2.new(0,am.TextBoxWidth,0,am.TextBoxHeight),
TextXAlignment="Center",
ClearTextOnFocus=false,
Text=FormatValue(as),
TextSize=14,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.08,
Parent=am.SliderFrame.UIElements.RightSlot,
LayoutOrder=1,
},{
ae.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text",
},
ZIndex=0,
}),
ae.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.78,
ImageColor3=Color3.new(1,1,1),
Name="Stroke",
ZIndex=0,
}),
af("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
})
end

am.UIElements.BodyRow=af("Frame",{
Name="BodyRow",
Size=UDim2.new(1,0,0,am.BodyHeight),
BackgroundTransparency=1,
Parent=b,
})

if ay then
ay.AnchorPoint=Vector2.new(0,0.5)
ay.Position=UDim2.new(0,0,0.5,0)
ay.Parent=am.UIElements.BodyRow
end

if az then
az.AnchorPoint=Vector2.new(1,0.5)
az.Position=UDim2.new(1,0,0.5,0)
az.Parent=am.UIElements.BodyRow
end

am.UIElements.RailHitbox=af("Frame",{
Size=UDim2.new(1,-(aA+aB),0,am.BodyHeight),
Position=UDim2.new(0,aA,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
Parent=am.UIElements.BodyRow,
ClipsDescendants=false,
})

am.UIElements.TrackInset=af("Frame",{
Size=UDim2.new(1,-(ax*2),1,0),
Position=UDim2.new(0,ax,0,0),
BackgroundTransparency=1,
Parent=am.UIElements.RailHitbox,
})

am.UIElements.Track=ae.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.95,
Size=UDim2.new(1,0,0,am.RailHeight),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Track",
ThemeTag={
ImageColor3="Text",
},
Parent=am.UIElements.TrackInset,
})

am.UIElements.Fill=ae.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=UDim2.new(ValueToDelta(as),0,1,0),
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Slider",
},
Parent=am.UIElements.Track,
},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,av,0,aw),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
ZIndex=2,
},{
ae.NewRoundFrame(99,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.6,
ZIndex=3,
}),
}),
})

local d
if am.IsTooltip then
d=a.load'A'.New(as,am.UIElements.Fill.Thumb,true,"Secondary","Small",false)
d.Container.AnchorPoint=Vector2.new(0.5,1)
d.Container.Position=UDim2.new(0.5,0,0,-8)
end

function am.Lock(f)
am.Locked=true
at=false
return am.SliderFrame:Lock(am.LockedTitle)
end

function am.Unlock(f)
am.Locked=false
at=true
return am.SliderFrame:Unlock()
end

if am.Locked then
am:Lock()
end

local function GetScrollingFrameParent()
local f=ak.Tab and ak.Tab.UIElements and ak.Tab.UIElements.ContainerFrame
if f and f:IsA"ScrollingFrame"then
return f
end

local g=am.SliderFrame.UIElements.Main:FindFirstAncestorWhichIsA"ScrollingFrame"
if g then
return g
end

return nil
end

local f=GetScrollingFrameParent()

local function UpdateVisuals(g,h,j)
local l=ValueToDelta(g)

if h then
ag(am.UIElements.Fill,0.05,{
Size=UDim2.new(l,0,1,0),
}):Play()
else
am.UIElements.Fill.Size=UDim2.new(l,0,1,0)
end

if am.InputBox and am.UIElements.TextBox and not j then
am.UIElements.TextBox.Text=FormatValue(g)
end

if d then
d.TitleFrame.Text=FormatValue(g)
end
end

local function CommitValue(g,h,j,l)
if not at then
return
end

g=NormalizeValue(g)
UpdateVisuals(g,j,l)

local m=g~=as
as=g
am.Value.Default=g

if m and h then
ae.SafeCallback(am.Callback,g)
end
end

function am.Set(g,h,j)
if not at then
return
end

if not am.IsFocusing and not ai and j and(j.UserInputType==Enum.UserInputType.MouseButton1 or j.UserInputType==Enum.UserInputType.Touch)then
an=(j.UserInputType==Enum.UserInputType.Touch)
if f then
f.ScrollingEnabled=false
end
ai=true

local function UpdateFromPointer()
local l=an and j.Position.X or ac:GetMouseLocation().X
local m=math.clamp((l-am.UIElements.TrackInset.AbsolutePosition.X)/am.UIElements.TrackInset.AbsoluteSize.X,0,1)
local p=aq+m*(ar-aq)
CommitValue(p,true,true,false)
end

UpdateFromPointer()

ao=ad.RenderStepped:Connect(function()
UpdateFromPointer()
end)

ap=ac.InputEnded:Connect(function(l)
if(l.UserInputType==Enum.UserInputType.MouseButton1 or l.UserInputType==Enum.UserInputType.Touch)and j==l then
if ao then
ao:Disconnect()
ao=nil
end
if ap then
ap:Disconnect()
ap=nil
end

ai=false
if f then
f.ScrollingEnabled=true
end

if ak.Window.NewElements then
ag(am.UIElements.Fill.Thumb,0.2,{
ImageTransparency=0,
Size=UDim2.new(0,av,0,aw),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

if d then
d:Close(false)
end
end
end)
elseif not j then
CommitValue(h,true,true,false)
end
end

function am.SetMax(g,h)
ar=h
am.Value.Max=h

if as>h then
am:Set(h)
else
UpdateVisuals(as,true,am.IsFocusing)
end
end

function am.SetMin(g,h)
aq=h
am.Value.Min=h

if as<h then
am:Set(h)
else
UpdateVisuals(as,true,am.IsFocusing)
end
end

if am.InputBox and am.UIElements.TextBox then
ae.AddSignal(am.UIElements.TextBox.Focused,function()
am.IsFocusing=true

ag(am.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.45,
}):Play()
end)

ae.AddSignal(am.UIElements.TextBox:GetPropertyChangedSignal"Text",function()
if not am.IsFocusing then
return
end

local g=tonumber(am.UIElements.TextBox.Text)
if g~=nil then
local h=NormalizeValue(g)
UpdateVisuals(h,true,true)
end
end)

ae.AddSignal(am.UIElements.TextBox.FocusLost,function()
am.IsFocusing=false

ag(am.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.78,
}):Play()

local g=tonumber(am.UIElements.TextBox.Text)
if g~=nil then
CommitValue(g,true,true,false)
else
am.UIElements.TextBox.Text=FormatValue(as)
if d then
d.TitleFrame.Text=FormatValue(as)
end
end
end)
end

ae.AddSignal(am.UIElements.RailHitbox.InputBegan,function(g)
if am.Locked or ai then
return
end

am:Set(as,g)

if g.UserInputType==Enum.UserInputType.MouseButton1 or g.UserInputType==Enum.UserInputType.Touch then
if ak.Window.NewElements then
ag(am.UIElements.Fill.Thumb,0.24,{
ImageTransparency=0.85,
Size=UDim2.new(0,av+8,0,aw+4),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if d then
d:Open()
end
end
end)

return am.__type,am
end

return ah end function a.I()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ac=aa(game:GetService"UserInputService")

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween

local ag={
UICorner=6,
UIPadding=8,
}

local ah=a.load'v'.New

function ag.New(ai,aj)
local function NormalizeKeyCode(ak)
if typeof(ak)=="EnumItem"then
return ak.Name
elseif type(ak)=="string"then
return ak
else
return"F"
end
end

local ak={
__type="Keybind",
Title=aj.Title or"Keybind",
Desc=aj.Desc or nil,
Locked=aj.Locked or false,
LockedTitle=aj.LockedTitle,
Value=NormalizeKeyCode(aj.Value)or"F",
Callback=aj.Callback or function()end,
CanChange=aj.CanChange or true,
Picking=false,
UIElements={},
}

local al=true

ak.KeybindFrame=a.load'B'{
Title=ak.Title,
Desc=ak.Desc,
Parent=aj.Parent,
TextOffset=85,
Hover=ak.CanChange,
Tab=aj.Tab,
Index=aj.Index,
Window=aj.Window,
ElementTable=ak,
ParentConfig=aj,
}

ak.UIElements.Keybind=ah(ak.Value,nil,ak.KeybindFrame.UIElements.Main,nil,aj.Window.NewElements and 12 or 10)

ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
ak.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
ak.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ae("UIScale",{
Parent=ak.UIElements.Keybind,
Scale=.85,
})

ad.AddSignal(ak.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
ak.UIElements.Keybind.Size=UDim2.new(
0,24
+ak.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function ak.Lock(am)
ak.Locked=true
al=false
return ak.KeybindFrame:Lock(ak.LockedTitle)
end
function ak.Unlock(am)
ak.Locked=false
al=true
return ak.KeybindFrame:Unlock()
end

function ak.Set(am,an)
local ao=NormalizeKeyCode(an)
ak.Value=ao
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ao
end

if ak.Locked then
ak:Lock()
end

ad.AddSignal(ak.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if al then
if ak.CanChange then
ak.Picking=true
ak.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local am
am=ac.InputBegan:Connect(function(an)
local ao

if an.UserInputType==Enum.UserInputType.Keyboard then
ao=an.KeyCode.Name
elseif an.UserInputType==Enum.UserInputType.MouseButton1 then
ao="MouseLeft"
elseif an.UserInputType==Enum.UserInputType.MouseButton2 then
ao="MouseRight"
end

local ap
ap=ac.InputEnded:Connect(function(aq)
if aq.KeyCode.Name==ao or ao=="MouseLeft"and aq.UserInputType==Enum.UserInputType.MouseButton1 or ao=="MouseRight"and aq.UserInputType==Enum.UserInputType.MouseButton2 then
ak.Picking=false

ak.UIElements.Keybind.Frame.Frame.TextLabel.Text=ao
ak.Value=ao

am:Disconnect()
ap:Disconnect()
end
end)
end)
end
end
end)

ad.AddSignal(ac.InputBegan,function(am,an)
if ac:GetFocusedTextBox()then
return
end

if not al then
return
end

if am.UserInputType==Enum.UserInputType.Keyboard then
if am.KeyCode.Name==ak.Value then
ad.SafeCallback(ak.Callback,am.KeyCode.Name)
end
elseif am.UserInputType==Enum.UserInputType.MouseButton1 and ak.Value=="MouseLeft"then
ad.SafeCallback(ak.Callback,"MouseLeft")
elseif am.UserInputType==Enum.UserInputType.MouseButton2 and ak.Value=="MouseRight"then
ad.SafeCallback(ak.Callback,"MouseRight")
end
end)

return ak.__type,ak
end

return ag end function a.J()
local aa=a.load'c'
local ac=aa.New local ad=
aa.Tween

local ae={
UICorner=8,
UIPadding=8,
}local af=a.load'l'

.New
local ag=a.load'm'.New

function ae.New(ah,ai)
local aj={
__type="Input",
Title=ai.Title or"Input",
Desc=ai.Desc or nil,
Type=ai.Type or"Input",
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
InputIcon=ai.InputIcon or false,
Placeholder=ai.Placeholder or"Enter Text...",
Value=ai.Value or"",
Callback=ai.Callback or function()end,
ClearTextOnFocus=ai.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local ak=true
local al=aj.Type=="Input"
local am=ai.Window.NewElements==true and al

aj.InputFrame=a.load'B'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=am and(aj.Width+24)or 20,
Hover=false,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,

ListRow=am,
ExpandableDesc=false,
DescExpanded=false,
ShowChevron=false,
RightSlotWidth=am and aj.Width or 0,
}

local an=ag(
aj.Placeholder,
aj.InputIcon,
aj.InputFrame.UIElements.Container,
aj.Type,
function(an)
aj:Set(an,true)
end,
nil,
ai.Window.NewElements and 12 or 10,
aj.ClearTextOnFocus
)

if al then
an.Size=UDim2.new(0,aj.Width,0,36)

if aj.InputFrame.UIElements.RightSlot then
an.AnchorPoint=Vector2.new(1,0.5)
an.Position=UDim2.new(1,0,0.5,0)
an.Parent=aj.InputFrame.UIElements.RightSlot
an.LayoutOrder=1
else
an.LayoutOrder=10
an.Position=UDim2.new(1,0,ai.Window.NewElements and 0 or 0.5,0)
an.AnchorPoint=Vector2.new(1,ai.Window.NewElements and 0 or 0.5)

if ai.ParentType=="Group"then
an.Size=UDim2.new(1,-ae.UIPadding*2,0,36)
an.AnchorPoint=Vector2.new(0.5,0.5)
an.Position=UDim2.new(0.5,0,0.5,0)
end
end
else
an.Size=UDim2.new(1,0,0,148)
end

ac("UIScale",{
Parent=an,
Scale=1,
})

function aj.Lock(ao)
aj.Locked=true
ak=false
return aj.InputFrame:Lock(aj.LockedTitle)
end

function aj.Unlock(ao)
aj.Locked=false
ak=true
return aj.InputFrame:Unlock()
end

function aj.Set(ao,ap,aq)
if ak then
aj.Value=ap
aa.SafeCallback(aj.Callback,ap)

if not aq then
an.Frame.Frame.TextBox.Text=ap
end
end
end

function aj.SetPlaceholder(ao,ap)
an.Frame.Frame.TextBox.PlaceholderText=ap
aj.Placeholder=ap
end

aj:Set(aj.Value)

if aj.Locked then
aj:Lock()
end

return aj.__type,aj
end

return ae end function a.K()

local aa=a.load'c'
local ac=aa.New

local ae={}

function ae.New(af,ag)
local ah=ac("Frame",{
Size=ag.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ai=ac("Frame",{
Parent=ag.Parent,
Size=ag.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ah
})

return"Divider",{__type="Divider",ElementFrame=ai}
end

return ae end function a.L()
local aa={}

local ac=(cloneref or clonereference or function(ac)
return ac
end)

local ae=ac(game:GetService"UserInputService")
local af=ac(game:GetService"Players").LocalPlayer:GetMouse()
local ag=ac(game:GetService"Workspace").CurrentCamera

local ah=workspace.CurrentCamera

local ai=a.load'm'.New

local aj=a.load'c'
local ak=aj.New
local al=aj.Tween

function aa.New(am,an,ao,ap,aq)
local ar={}

if not an.Callback then
aq="Menu"
end

an.UIElements.UIListLayout=ak("UIListLayout",{
Padding=UDim.new(0,ao.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

an.UIElements.Menu=aj.NewRoundFrame(ao.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.MenuPadding),
PaddingLeft=UDim.new(0,ao.MenuPadding),
PaddingRight=UDim.new(0,ao.MenuPadding),
PaddingBottom=UDim.new(0,ao.MenuPadding),
}),
ak("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.MenuPadding),
}),
ak("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,an.SearchBarEnabled and-ao.MenuPadding-ao.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
},{
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding),
}),
ak("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
an.UIElements.UIListLayout,
}),
}),
})

an.UIElements.MenuCanvas=ak("Frame",{
Size=UDim2.new(0,an.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=am.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
an.UIElements.Menu,
ak("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
}),
})

local function RecalculateCanvasSize()
an.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=
UDim2.fromOffset(0,an.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
local as=ah.ViewportSize.Y*0.6

local at=an.UIElements.UIListLayout.AbsoluteContentSize.Y
local au=an.SearchBarEnabled and(ao.SearchBarHeight+(ao.MenuPadding*3))
or(ao.MenuPadding*2)
local av=at+au

if av>as then
an.UIElements.MenuCanvas.Size=
UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X,as)
else
an.UIElements.MenuCanvas.Size=
UDim2.fromOffset(an.UIElements.MenuCanvas.AbsoluteSize.X,av)
end
end

function UpdatePosition()
local as=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local at=an.UIElements.MenuCanvas

local au=ag.ViewportSize.Y
-(as.AbsolutePosition.Y+as.AbsoluteSize.Y)
-ao.MenuPadding
-54
local av=at.AbsoluteSize.Y+ao.MenuPadding

local aw=-54
if au<av then
aw=av-au-54
end

at.Position=UDim2.new(
0,
as.AbsolutePosition.X+as.AbsoluteSize.X,
0,
as.AbsolutePosition.Y+as.AbsoluteSize.Y-aw+(ao.MenuPadding*2)
)
end

local as

function ar.Display(at)
local au=an.Values
local av=""

if an.Multi then
local aw={}
if typeof(an.Value)=="table"then
for ax,ay in ipairs(an.Value)do
local az=typeof(ay)=="table"and ay.Title or ay
aw[az]=true
end
end

for ax,ay in ipairs(au)do
local az=typeof(ay)=="table"and ay.Title or ay
if aw[az]then
av=av..az..", "
end
end

if#av>0 then
av=av:sub(1,#av-2)
end
else
av=typeof(an.Value)=="table"and an.Value.Title or an.Value or""
end

if an.UIElements.Dropdown then
an.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(av==""and"--"or av)
end
end

local function Callback(at)
ar:Display()
if an.Callback then
task.spawn(function()
aj.SafeCallback(an.Callback,an.Value)
end)
else
task.spawn(function()
aj.SafeCallback(at)
end)
end
end

function ar.LockValues(at,au)
if not au then
return
end

for av,aw in next,an.Tabs do
if aw and aw.UIElements and aw.UIElements.TabItem then
local ax=aw.Name
local ay=false

for az,aA in next,au do
if ax==aA then
ay=true
break
end
end

if ay then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

aw.UIElements.TabItem.Active=false
aw.Locked=true
else
if aw.Selected then
al(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
al(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
al(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(
aw.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=aq=="Dropdown"and 0.4 or 0.05}
):Play()
if aw.UIElements.TabIcon then
al(
aw.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=aq=="Dropdown"and 0.2 or 0}
):Play()
end
end

aw.UIElements.TabItem.Active=true
aw.Locked=false
end
end
end
end

function ar.Refresh(at,au)
for av,aw in next,an.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not aw:IsA"UIListLayout"then
aw:Destroy()
end
end

an.Tabs={}

if an.SearchBarEnabled then
if not as then
as=ai("Search...","search",an.UIElements.Menu,nil,function(av)
for aw,ax in next,an.Tabs do
if string.find(string.lower(ax.Name),string.lower(av),1,true)then
ax.UIElements.TabItem.Visible=true
else
ax.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
as.Size=UDim2.new(1,0,0,ao.SearchBarHeight)
as.Position=UDim2.new(0,0,0,0)
as.Name="SearchBar"
end
end

for av,aw in next,au do
if aw.Type~="Divider"then
local ax={
Name=typeof(aw)=="table"and aw.Title or aw,
Desc=typeof(aw)=="table"and aw.Desc or nil,
Icon=typeof(aw)=="table"and aw.Icon or nil,
IconSize=typeof(aw)=="table"and aw.IconSize or nil,
Original=aw,
Selected=false,
Locked=typeof(aw)=="table"and aw.Locked or false,
UIElements={},
}
local ay
if ax.Icon then
ay=aj.Image(ax.Icon,ax.Icon,0,am.Window.Folder,"Dropdown",true)
ay.Size=
UDim2.new(0,ax.IconSize or ao.TabIcon,0,ax.IconSize or ao.TabIcon)
ay.ImageLabel.ImageTransparency=aq=="Dropdown"and 0.2 or 0
ax.UIElements.TabIcon=ay
end
ax.UIElements.TabItem=aj.NewRoundFrame(
ao.MenuCorner-ao.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,36),
AutomaticSize=ax.Desc and"Y",
ImageTransparency=1,
Parent=an.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not ax.Locked,
},
{
aj.NewRoundFrame(ao.MenuCorner-ao.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
ak("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ak("UIPadding",{
PaddingTop=UDim.new(0,ao.TabPadding),
PaddingLeft=UDim.new(0,ao.TabPadding),
PaddingRight=UDim.new(0,ao.TabPadding),
PaddingBottom=UDim.new(0,ao.TabPadding),
}),
ak("UICorner",{
CornerRadius=UDim.new(0,ao.MenuCorner-ao.MenuPadding),
}),
ay,
ak("Frame",{
Size=UDim2.new(1,ay and-ao.TabPadding-ao.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
ak("TextLabel",{
Text=ax.Name,
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
ak("TextLabel",{
Text=ax.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(aj.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=aq=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=ax.Desc and true or false,
Name="Desc",
}),
ak("UIListLayout",{
Padding=UDim.new(0,ao.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)

if ax.Locked then
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if an.Multi and typeof(an.Value)=="string"then
for az,aA in next,an.Values do
if typeof(aA)=="table"then
if aA.Title==an.Value then
an.Value={aA}
end
else
if aA==an.Value then
an.Value={an.Value}
end
end
end
end

if an.Multi then
local az=false
if typeof(an.Value)=="table"then
for aA,aB in ipairs(an.Value)do
local b=typeof(aB)=="table"and aB.Title or aB
if b==ax.Name then
az=true
break
end
end
end
ax.Selected=az
else
local az=typeof(an.Value)=="table"and an.Value.Title or an.Value
ax.Selected=az==ax.Name
end

if ax.Selected and not ax.Locked then
ax.UIElements.TabItem.ImageTransparency=0.95
ax.UIElements.TabItem.Highlight.ImageTransparency=0.75
ax.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if ax.UIElements.TabIcon then
ax.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

an.Tabs[av]=ax

ar:Display()

if aq=="Dropdown"then
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then
return
end

if an.Multi then
if not ax.Selected then
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(an.Value,ax.Original)
else
if not an.AllowNone and#an.Value==1 then
return
end
ax.Selected=false
al(ax.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for az,aA in next,an.Value do
if typeof(aA)=="table"and(aA.Title==ax.Name)or(aA==ax.Name)then
table.remove(an.Value,az)
break
end
end
end
else
for az,aA in next,an.Tabs do
al(aA.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
al(aA.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
al(
aA.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if aA.UIElements.TabIcon then
al(aA.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
aA.Selected=false
end
ax.Selected=true
al(ax.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
al(ax.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
al(ax.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if ax.UIElements.TabIcon then
al(ax.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
an.Value=ax.Original
end
Callback()
end)
elseif aq=="Menu"then
if not ax.Locked then
aj.AddSignal(ax.UIElements.TabItem.MouseEnter,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=0.95}):Play()
end)
aj.AddSignal(ax.UIElements.TabItem.InputEnded,function()
al(ax.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
aj.AddSignal(ax.UIElements.TabItem.MouseButton1Click,function()
if ax.Locked then
return
end
Callback(aw.Callback or function()end)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'K'
:New{Parent=an.UIElements.Menu.Frame.ScrollingFrame}
end
end










an.UIElements.MenuCanvas.Size=UDim2.new(
0,
an.MenuWidth+6+6+5+5+18+6+6,
an.UIElements.MenuCanvas.Size.Y.Scale,
an.UIElements.MenuCanvas.Size.Y.Offset
)
Callback()

an.Values=au
end

ar:Refresh(an.Values)

function ar.Select(at,au)
if au then
an.Value=au
else
if an.Multi then
an.Value={}
else
an.Value=nil
end
end
ar:Refresh(an.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

function ar.Open(at)
if ap then
an.UIElements.Menu.Visible=true
an.UIElements.MenuCanvas.Visible=true
an.UIElements.MenuCanvas.Active=true
an.UIElements.Menu.Size=UDim2.new(1,0,0,0)
al(an.UIElements.Menu,0.1,{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.05,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
an.Opened=true
end)

UpdatePosition()
end
end

function ar.Close(at)
an.Opened=false

al(an.UIElements.Menu,0.25,{
Size=UDim2.new(1,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
an.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(0.25)
an.UIElements.MenuCanvas.Visible=false
an.UIElements.MenuCanvas.Active=false
end)
end

aj.AddSignal(
(
an.UIElements.Dropdown and an.UIElements.Dropdown.MouseButton1Click
or an.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
ar:Open()
end
)

aj.AddSignal(ae.InputBegan,function(at)
if
at.UserInputType==Enum.UserInputType.MouseButton1
or at.UserInputType==Enum.UserInputType.Touch
then
local au=an.UIElements.MenuCanvas
local av,aw=au.AbsolutePosition,au.AbsoluteSize

local ax=an.UIElements.Dropdown or an.DropdownFrame.UIElements.Main
local ay=ax.AbsolutePosition
local az=ax.AbsoluteSize

local aA=af.X>=ay.X
and af.X<=ay.X+az.X
and af.Y>=ay.Y
and af.Y<=ay.Y+az.Y

local aB=af.X>=av.X
and af.X<=av.X+aw.X
and af.Y>=av.Y
and af.Y<=av.Y+aw.Y

if am.Window.CanDropdown and an.Opened and not aA and not aB then
ar:Close()
end
end
end)

aj.AddSignal(
an.UIElements.Dropdown and an.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or an.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return ar
end

return aa end function a.M()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ac=
aa(game:GetService"Workspace").CurrentCamera

local ae=a.load'c'
local af=ae.New local ag=
ae.Tween

local ah=a.load'v'.New local ai=a.load'm'
.New
local aj=a.load'L'.New local ak=

workspace.CurrentCamera

local al={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function al.New(am,an)
local ao={
__type="Dropdown",
Title=an.Title or"Dropdown",
Desc=an.Desc or nil,
Locked=an.Locked or false,
LockedTitle=an.LockedTitle,
Values=an.Values or{},
MenuWidth=an.MenuWidth or 180,
Value=an.Value,
AllowNone=an.AllowNone,
SearchBarEnabled=an.SearchBarEnabled or false,
Multi=an.Multi,
Callback=an.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}local ap=

ao.Desc~=nil and ao.Desc~=""

if ao.Multi and not ao.Value then
ao.Value={}
end
if ao.Values and typeof(ao.Value)=="number"then
ao.Value=ao.Values[ao.Value]
end

local aq=true
local ar=an.Window.NewElements==true and an.ParentType~="Group"

ao.DropdownFrame=a.load'B'{
Title=ao.Title,
Desc=ao.Desc,
Parent=an.Parent,
TextOffset=ar and(ao.Callback and(ao.Width+24)or 32)
or(ao.Callback and ao.Width or 20),
Hover=not ao.Callback and true or false,
Tab=an.Tab,
Index=an.Index,
Window=an.Window,
ElementTable=ao,
ParentConfig=an,

ListRow=ar,
ExpandableDesc=false,
DescExpanded=false,
ShowChevron=false,
RightSlotWidth=ao.Callback and ao.Width or 0,
}

if ao.Callback then
ao.UIElements.Dropdown=
ah("",nil,ao.DropdownFrame.UIElements.Container,nil,an.Window.NewElements and 12 or 10)

ao.UIElements.Dropdown.LayoutOrder=10
ao.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,ao.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

ao.UIElements.Dropdown.Size=UDim2.new(0,ao.Width,0,36)

if ao.DropdownFrame.UIElements.RightSlot then
ao.UIElements.Dropdown.Parent=ao.DropdownFrame.UIElements.RightSlot
ao.UIElements.Dropdown.LayoutOrder=1
else
ao.UIElements.Dropdown.Position=UDim2.new(1,0,ar and 0 or 0.5,0)
ao.UIElements.Dropdown.AnchorPoint=Vector2.new(1,ar and 0 or 0.5)

if an.ParentType=="Group"then
ao.UIElements.Dropdown.Size=UDim2.new(1,-al.UIPadding*2,0,36)
ao.UIElements.Dropdown.AnchorPoint=Vector2.new(0.5,0.5)
ao.UIElements.Dropdown.Position=UDim2.new(0.5,0,0.5,0)
end
end
end

ao.DropdownMenu=aj(an,ao,al,aq,"Dropdown")

ao.Display=ao.DropdownMenu.Display
ao.Refresh=ao.DropdownMenu.Refresh
ao.Select=ao.DropdownMenu.Select
ao.Open=ao.DropdownMenu.Open
ao.Close=ao.DropdownMenu.Close

af("ImageLabel",{
Image=ae.Icon"chevrons-up-down"[1],
ImageRectOffset=ae.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ae.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,ao.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=ao.UIElements.Dropdown and ao.UIElements.Dropdown.Frame or ao.DropdownFrame.UIElements.Main,
})

function ao.Lock(as)
ao.Locked=true
aq=false
return ao.DropdownFrame:Lock(ao.LockedTitle)
end

function ao.Unlock(as)
ao.Locked=false
aq=true
return ao.DropdownFrame:Unlock()
end

if ao.Locked then
ao:Lock()
end

return ao.__type,ao
end

return al end function a.N()








local aa={}
local ae={
lua={
"and","break","or","else","elseif","if","then","until","repeat","while","do","for","in","end",
"local","return","function","export",
},
rbx={
"game","workspace","script","math","string","table","task","wait","select","next","Enum",
"tick","assert","shared","loadstring","tonumber","tostring","type",
"typeof","unpack","Instance","CFrame","Vector3","Vector2","Color3","UDim","UDim2","Ray","BrickColor",
"OverlapParams","RaycastParams","Axes","Random","Region3","Rect","TweenInfo",
"collectgarbage","not","utf8","pcall","xpcall","_G","setmetatable","getmetatable","os","pairs","ipairs"
},
operators={
"#","+","-","*","%","/","^","=","~","=","<",">",
}
}

local af={
numbers=Color3.fromHex"#FAB387",
boolean=Color3.fromHex"#FAB387",
operator=Color3.fromHex"#94E2D5",
lua=Color3.fromHex"#CBA6F7",
rbx=Color3.fromHex"#F38BA8",
str=Color3.fromHex"#A6E3A1",
comment=Color3.fromHex"#9399B2",
null=Color3.fromHex"#F38BA8",
call=Color3.fromHex"#89B4FA",
self_call=Color3.fromHex"#89B4FA",
local_property=Color3.fromHex"#CBA6F7",
}

local function createKeywordSet(ah)
local aj={}
for ak,al in ipairs(ah)do
aj[al]=true
end
return aj
end

local ah=createKeywordSet(ae.lua)
local aj=createKeywordSet(ae.rbx)
local ak=createKeywordSet(ae.operators)

local function getHighlight(al,am)
local an=al[am]

if af[an.."_color"]then
return af[an.."_color"]
end

if tonumber(an)then
return af.numbers
elseif an=="nil"then
return af.null
elseif an:sub(1,2)=="--"then
return af.comment
elseif ak[an]then
return af.operator
elseif ah[an]then
return af.lua
elseif aj[an]then
return af.rbx
elseif an:sub(1,1)=="\""or an:sub(1,1)=="\'"then
return af.str
elseif an=="true"or an=="false"then
return af.boolean
end

if al[am+1]=="("then
if al[am-1]==":"then
return af.self_call
end

return af.call
end

if al[am-1]=="."then
if al[am-2]=="Enum"then
return af.rbx
end

return af.local_property
end
end

function aa.run(al)
local am={}
local an=""

local ao=false
local ap=false
local aq=false

for ar=1,#al do
local as=al:sub(ar,ar)

if ap then
if as=="\n"and not aq then
table.insert(am,an)
table.insert(am,as)
an=""

ap=false
elseif al:sub(ar-1,ar)=="]]"and aq then
an=an.."]"

table.insert(am,an)
an=""

ap=false
aq=false
else
an=an..as
end
elseif ao then
if as==ao and al:sub(ar-1,ar-1)~="\\"or as=="\n"then
an=an..as
ao=false
else
an=an..as
end
else
if al:sub(ar,ar+1)=="--"then
table.insert(am,an)
an="-"
ap=true
aq=al:sub(ar+2,ar+3)=="[["
elseif as=="\""or as=="\'"then
table.insert(am,an)
an=as
ao=as
elseif ak[as]then
table.insert(am,an)
table.insert(am,as)
an=""
elseif as:match"[%w_]"then
an=an..as
else
table.insert(am,an)
table.insert(am,as)
an=""
end
end
end

table.insert(am,an)

local ar={}

for as,at in ipairs(am)do
local au=getHighlight(am,as)

if au then
local av=string.format("<font color = \"#%s\">%s</font>",au:ToHex(),at:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(ar,av)
else
table.insert(ar,at)
end
end

return table.concat(ar)
end

return aa end function a.O()
local aa={}

local ae=a.load'c'
local af=ae.New
local ah=ae.Tween

local aj=a.load'N'

function aa.New(ak,al,am,an,ao)
local ap={
Radius=12,
Padding=10
}

local aq=af("TextLabel",{
Text="",
TextColor3=Color3.fromHex"#CDD6F4",
TextTransparency=0,
TextSize=14,
TextWrapped=false,
LineHeight=1.15,
RichText=true,
TextXAlignment="Left",
Size=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
AutomaticSize="XY",
},{
af("UIPadding",{
PaddingTop=UDim.new(0,ap.Padding+3),
PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),
PaddingBottom=UDim.new(0,ap.Padding+3),
})
})
aq.Font="Code"

local ar=af("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
aq
})

local as=af("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ap.Padding/2,0,ap.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=an and true or false,
},{
ae.NewRoundFrame(ap.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
af("UIScale",{
Scale=1,
}),
af("ImageLabel",{
Image=ae.Icon"copy"[1],
ImageRectSize=ae.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ae.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ae.AddSignal(as.MouseEnter,function()
ah(as.Button,.05,{ImageTransparency=.95}):Play()
ah(as.Button.UIScale,.05,{Scale=.9}):Play()
end)
ae.AddSignal(as.InputEnded,function()
ah(as.Button,.08,{ImageTransparency=1}):Play()
ah(as.Button.UIScale,.08,{Scale=1}):Play()
end)

local at=ae.NewRoundFrame(ap.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
AutomaticSize="Y",
Parent=am,
},{
ae.NewRoundFrame(ap.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ae.NewRoundFrame(ap.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ap.Padding*2)),
Visible=al and true or false
},{
af("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
af("TextLabel",{
Text=al,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,as and-20-(ap.Padding*2),0,0)
}),
af("UIPadding",{

PaddingLeft=UDim.new(0,ap.Padding+3),
PaddingRight=UDim.new(0,ap.Padding+3),

}),
af("UIListLayout",{
Padding=UDim.new(0,ap.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
ar,
af("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
as,
})

ap.CodeFrame=at

ae.AddSignal(aq:GetPropertyChangedSignal"TextBounds",function()
ar.Size=UDim2.new(1,0,0,(aq.TextBounds.Y/(ao or 1))+((ap.Padding+3)*2))
end)

function ap.Set(au)
aq.Text=aj.run(au)
end

function ap.Destroy()
at:Destroy()
ap=nil
end

ap.Set(ak)

ae.AddSignal(as.MouseButton1Click,function()
if an then
an()
local au=ae.Icon"check"
as.Button.ImageLabel.Image=au[1]
as.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition

task.wait(1)
local av=ae.Icon"copy"
as.Button.ImageLabel.Image=av[1]
as.Button.ImageLabel.ImageRectSize=av[2].ImageRectSize
as.Button.ImageLabel.ImageRectOffset=av[2].ImageRectPosition
end
end)
return ap
end


return aa end function a.P()
local aa=a.load'c'local ae=
aa.New


local af=a.load'O'

local ah={}

function ah.New(aj,ak)
local al={
__type="Code",
Title=ak.Title,
Code=ak.Code,
OnCopy=ak.OnCopy,
}

local am=not al.Locked











local an=af.New(al.Code,al.Title,ak.Parent,function()
if am then
local an=al.Title or"code"
local ao,ap=pcall(function()
toclipboard(al.Code)

if al.OnCopy then al.OnCopy()end
end)
if not ao then
ak.WindUI:Notify{
Title="Error",
Content="The "..an.." is not copied. Error: "..ap,
Icon="x",
Duration=5,
}
end
end
end,ak.WindUI.UIScale,al)

function al.SetCode(ao,ap)
an.Set(ap)
al.Code=ap
end

function al.Set(ao,ap)
return al.SetCode(ap)
end

function al.Destroy(ao)
an.Destroy()
al=nil
end

al.ElementFrame=an.CodeFrame

return al.__type,al
end

return ah end function a.Q()
local aa=a.load'c'
local ae=aa.New local af=
aa.Tween

local ah=(cloneref or clonereference or function(ah)return ah end)

local aj=ah(game:GetService"UserInputService")
ah(game:GetService"TouchInputService")
local ak=ah(game:GetService"RunService")
local al=ah(game:GetService"Players")

local am=ak.RenderStepped
local an=al.LocalPlayer
local ao=an:GetMouse()

local ap=a.load'l'.New
local aq=a.load'm'.New

local ar={
UICorner=9,

}

function ar.Colorpicker(as,at,au,av)
local aw={
__type="Colorpicker",
Title=at.Title,
Desc=at.Desc,
Default=at.Value or at.Default,
Callback=at.Callback,
Transparency=at.Transparency,
UIElements=at.UIElements,

TextPadding=10,
}

function aw.SetHSVFromRGB(ax,ay)
local az,aA,aB=Color3.toHSV(ay)
aw.Hue=az
aw.Sat=aA
aw.Vib=aB
end

aw:SetHSVFromRGB(aw.Default)

local ax=a.load'n'.Init(au)
local ay=ax.Create()

aw.ColorpickerFrame=ay

ay.UIElements.Main.Size=UDim2.new(1,0,0,0)



local az,aA,aB=aw.Hue,aw.Sat,aw.Vib

aw.UIElements.Title=ae("TextLabel",{
Text=aw.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIPadding",{
PaddingTop=UDim.new(0,aw.TextPadding/2),
PaddingLeft=UDim.new(0,aw.TextPadding/2),
PaddingRight=UDim.new(0,aw.TextPadding/2),
PaddingBottom=UDim.new(0,aw.TextPadding/2),
})
})





local b=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=aw.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

aw.UIElements.SatVibMap=ae("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+aw.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(az,1,1),
BackgroundTransparency=0,
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=45,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),

b,
})

aw.UIElements.Inputs=ae("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(aw.Transparency and 240 or 210,40+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main
},{
ae("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local d=ae("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=aw.Transparency,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),







d,
})

local f=ae("Frame",{
BackgroundColor3=aw.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ae("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+aw.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(0,8),
}),







aa.NewRoundFrame(8,"SquircleOutline",{
ThemeTag={
ImageColor3="Outline",
},
Size=UDim2.new(1,0,1,0),
ImageTransparency=.85,
ZIndex=99999,
},{
ae("UIGradient",{
Rotation=60,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
}
})
}),
f,
})

local g={}

for h=0,1,0.1 do
table.insert(g,ColorSequenceKeypoint.new(h,Color3.fromHSV(h,1,1)))
end

local h=ae("UIGradient",{
Color=ColorSequence.new(g),
Rotation=90,
})

local j=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local l=ae("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=j,


BackgroundColor3=aw.Default
},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local m=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+aw.TextPadding),
Parent=ay.UIElements.Main,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
h,
j,
})


function CreateNewInput(p,r)
local u=aq(p,nil,aw.UIElements.Inputs)

ae("TextLabel",{
BackgroundTransparency=1,
TextTransparency=.4,
TextSize=17,
FontFace=Font.new(aa.Font,Enum.FontWeight.Regular),
AutomaticSize="XY",
ThemeTag={
TextColor3="Placeholder",
},
AnchorPoint=Vector2.new(1,0.5),
Position=UDim2.new(1,-12,0.5,0),
Parent=u.Frame,
Text=p,
})

ae("UIScale",{
Parent=u,
Scale=.85,
})

u.Frame.Frame.TextBox.Text=r
u.Size=UDim2.new(0,150,0,42)

return u
end

local function ToRGB(p)
return{
R=math.floor(p.R*255),
G=math.floor(p.G*255),
B=math.floor(p.B*255)
}
end

local p=CreateNewInput("Hex","#"..aw.Default:ToHex())

local r=CreateNewInput("Red",ToRGB(aw.Default).R)
local u=CreateNewInput("Green",ToRGB(aw.Default).G)
local v=CreateNewInput("Blue",ToRGB(aw.Default).B)
local x
if aw.Transparency then
x=CreateNewInput("Alpha",((1-aw.Transparency)*100).."%")
end

local z=ae("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+aw.TextPadding),
BackgroundTransparency=1,
Parent=ay.UIElements.Main,
LayoutOrder=4,
},{
ae("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local A={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()av(Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib),aw.Transparency)end
}
}

for B,C in next,A do
local F=ap(C.Title,C.Icon,C.Callback,C.Variant,z,ay,false)
F.Size=UDim2.new(0.5,-3,0,40)
F.AutomaticSize="None"
end



local B,C,F
if aw.Transparency then
local G=ae("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

C=ae("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=G,

},{
ae("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ae("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

F=ae("Frame",{
Size=UDim2.fromScale(1,1),
},{
ae("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ae("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

B=ae("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+aw.TextPadding),
Parent=ay.UIElements.Main,
BackgroundTransparency=1,
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ae("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ae("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
F,
G,
})
end

function aw.Round(G,H,J)
if J==0 then
return math.floor(H)
end
H=tostring(H)
return H:find"%."and tonumber(H:sub(1,H:find"%."+J))or H
end


function aw.Update(G,H,J)
if H then az,aA,aB=Color3.toHSV(H)else az,aA,aB=aw.Hue,aw.Sat,aw.Vib end

aw.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(az,1,1)
b.Position=UDim2.new(aA,0,1-aB,0)
b.BackgroundColor3=Color3.fromHSV(az,aA,aB)
f.BackgroundColor3=Color3.fromHSV(az,aA,aB)
l.BackgroundColor3=Color3.fromHSV(az,1,1)
l.Position=UDim2.new(0.5,0,az,0)

p.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(az,aA,aB):ToHex()
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).R
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).G
v.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(az,aA,aB)).B

if J or aw.Transparency then
f.BackgroundTransparency=aw.Transparency or J
F.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundColor3=Color3.fromHSV(az,aA,aB)
C.BackgroundTransparency=aw.Transparency or J
C.Position=UDim2.new(0.5,0,1-aw.Transparency or J,0)
x.Frame.Frame.TextBox.Text=aw:Round((1-aw.Transparency or J)*100,0).."%"
end
end

aw:Update(aw.Default,aw.Transparency)




local function GetRGB()
local G=Color3.fromHSV(aw.Hue,aw.Sat,aw.Vib)
return{R=math.floor(G.r*255),G=math.floor(G.g*255),B=math.floor(G.b*255)}
end



local function clamp(G,H,J)
return math.clamp(tonumber(G)or 0,H,J)
end

aa.AddSignal(p.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=p.Frame.Frame.TextBox.Text:gsub("#","")
local J,L=pcall(Color3.fromHex,H)
if J and typeof(L)=="Color3"then
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(L)
aw:Update()
aw.Default=L
end
end
end)

local function updateColorFromInput(G,H)
aa.AddSignal(G.Frame.Frame.TextBox.FocusLost,function(J)
if J then
local L=G.Frame.Frame.TextBox
local M=GetRGB()
local N=clamp(L.Text,0,255)
L.Text=tostring(N)

M[H]=N
local O=Color3.fromRGB(M.R,M.G,M.B)
aw.Hue,aw.Sat,aw.Vib=Color3.toHSV(O)
aw:Update()
end
end)
end

updateColorFromInput(r,"R")
updateColorFromInput(u,"G")
updateColorFromInput(v,"B")

if aw.Transparency then
aa.AddSignal(x.Frame.Frame.TextBox.FocusLost,function(G)
if G then
local H=x.Frame.Frame.TextBox
local J=clamp(H.Text,0,100)
H.Text=tostring(J)

aw.Transparency=1-J*0.01
aw:Update(nil,aw.Transparency)
end
end)
end



local G=aw.UIElements.SatVibMap
aa.AddSignal(G.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=G.AbsolutePosition.X
local L=J+G.AbsoluteSize.X
local M=math.clamp(ao.X,J,L)

local N=G.AbsolutePosition.Y
local O=N+G.AbsoluteSize.Y
local P=math.clamp(ao.Y,N,O)

aw.Sat=(M-J)/(L-J)
aw.Vib=1-((P-N)/(O-N))
aw:Update()

am:Wait()
end
end
end)

aa.AddSignal(m.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=m.AbsolutePosition.Y
local L=J+m.AbsoluteSize.Y
local M=math.clamp(ao.Y,J,L)

aw.Hue=((M-J)/(L-J))
aw:Update()

am:Wait()
end
end
end)

if aw.Transparency then
aa.AddSignal(B.InputBegan,function(H)
if H.UserInputType==Enum.UserInputType.MouseButton1 or H.UserInputType==Enum.UserInputType.Touch then
while aj:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local J=B.AbsolutePosition.Y
local L=J+B.AbsoluteSize.Y
local M=math.clamp(ao.Y,J,L)

aw.Transparency=1-((M-J)/(L-J))
aw:Update()

am:Wait()
end
end
end)
end

return aw
end

function ar.New(as,at)
local au={
__type="Colorpicker",
Title=at.Title or"Colorpicker",
Desc=at.Desc or nil,
Locked=at.Locked or false,
LockedTitle=at.LockedTitle,
Default=at.Default or Color3.new(1,1,1),
Callback=at.Callback or function()end,

UIScale=at.UIScale,
Transparency=at.Transparency,
UIElements={}
}

local av=true



au.ColorpickerFrame=a.load'B'{
Title=au.Title,
Desc=au.Desc,
Parent=at.Parent,
TextOffset=40,
Hover=false,
Tab=at.Tab,
Index=at.Index,
Window=at.Window,
ElementTable=au,
ParentConfig=at,
}

au.UIElements.Colorpicker=aa.NewRoundFrame(ar.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=au.Default,
Parent=au.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function au.Lock(aw)
au.Locked=true
av=false
return au.ColorpickerFrame:Lock(au.LockedTitle)
end
function au.Unlock(aw)
au.Locked=false
av=true
return au.ColorpickerFrame:Unlock()
end

if au.Locked then
au:Lock()
end


function au.Update(aw,ax,ay)
au.UIElements.Colorpicker.ImageTransparency=ay or 0
au.UIElements.Colorpicker.ImageColor3=ax
au.Default=ax
if ay then
au.Transparency=ay
end
end

function au.Set(aw,ax,ay)
return au:Update(ax,ay)
end

aa.AddSignal(au.UIElements.Colorpicker.MouseButton1Click,function()
if av then
ar:Colorpicker(au,at.Window,function(aw,ax)
au:Update(aw,ax)
au.Default=aw
au.Transparency=ax
aa.SafeCallback(au.Callback,aw,ax)
end).ColorpickerFrame:Open()
end
end)

return au.__type,au
end

return ar end function a.R()
local aa=a.load'c'
local ae=aa.New
local af=aa.Tween

local ah={}

function ah.New(aj,ak)
local al={
__type="Section",
Title=ak.Title or"Section",
Desc=ak.Desc,
Icon=ak.Icon,
IconThemed=ak.IconThemed,
TextXAlignment=ak.TextXAlignment or"Left",
TextSize=ak.TextSize or 19,
DescTextSize=ak.DescTextSize or 16,
Box=ak.Box or false,
BoxBorder=ak.BoxBorder or false,
FontWeight=ak.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=ak.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=ak.TextTransparency or 0.05,
DescTextTransparency=ak.DescTextTransparency or 0.4,
Opened=ak.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local am

function al.SetIcon(an,ao)
al.Icon=ao or nil
if am then
am:Destroy()
end
if ao then
am=aa.Image(
ao,
ao..":"..al.Title,
0,
ak.Window.Folder,
al.__type,
true,
al.IconThemed,
"SectionIcon"
)
am.Size=UDim2.new(0,al.IconSize,0,al.IconSize)
end
end

local an=ae("Frame",{
Size=UDim2.new(0,al.IconSize,0,al.IconSize),
BackgroundTransparency=1,
Visible=false,
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
}),
})

if al.Icon then
al:SetIcon(al.Icon)
end

local ao=ae("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ae("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=al.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4),
}),
})

local ap,aq

local function createTitle(ar,as)
return ae("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=al.TextXAlignment,
AutomaticSize="Y",
TextSize=as=="Title"and al.TextSize or al.DescTextSize,
TextTransparency=as=="Title"and al.TextTransparency or al.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,as=="Title"and al.FontWeight or al.DescFontWeight),
Text=ar,
Size=UDim2.new(1,0,0,0),
TextWrapped=true,
Parent=ao,
})
end

ap=createTitle(al.Title,"Title")
if al.Desc then
aq=createTitle(al.Desc,"Desc")
end

local function UpdateTitleSize()
local ar=0
if am then
ar=ar-(al.IconSize+8)
end
if an.Visible then
ar=ar-(al.IconSize+8)
end
ao.Size=UDim2.new(1,ar,0,0)
end

local ar=aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=ak.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag={
ImageTransparency=al.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not al.Box and 1 or nil,
},{
aa.NewRoundFrame(ak.Window.ElementConfig.UICorner,ak.Window.NewElements and"Glass-1"or"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=al.Box and al.BoxBorder,
Name="Outline",
}),
ae("TextButton",{
Size=UDim2.new(1,0,0,al.Expandable and 0 or(not aq and al.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not al.Expandable or aq)and"Y"or nil,
Text="",
Name="Top",
},{
al.Box and ae("UIPadding",{
PaddingTop=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding+(ak.Window.NewElements and 4 or 0)),
})or nil,
am,
ao,
ae("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
an,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,al.HeaderSize),
},{
al.Box and ae("UIPadding",{
PaddingLeft=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,ak.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,ak.Window.ElementConfig.UIPadding),
})or nil,
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ak.Window.NewElements and 0 or ak.Tab.Gap),
VerticalAlignment="Top",
}),
}),
})

al.ElementFrame=ar

if aq then
ar.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
ar.Content.Position=UDim2.new(0,0,0,ar.Top.AbsoluteSize.Y/ak.UIScale)

if al.Opened then
al:Open(true)
else
al.Close(true)
end
end)
end

local as=ak.ElementsModule

as.Load(al,ar.Content,as.Elements,ak.Window,ak.WindUI,function()
if not al.Expandable then
al.Expandable=true
an.Visible=true
UpdateTitleSize()
end
end,as,ak.UIScale,ak.Tab)

UpdateTitleSize()

function al.SetTitle(at,au)
al.Title=au
ap.Text=au
end

function al.SetDesc(at,au)
al.Desc=au
if not aq then
aq=createTitle(au,"Desc")
end
aq.Text=au
end

function al.Destroy(at)
for au,av in next,al.Elements do
av:Destroy()
end

ar:Destroy()
end

function al.Open(at,au)
if al.Expandable then
al.Opened=true
if au then
ar.Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,0,(ar.Top.AbsoluteSize.Y)/ak.UIScale+(ar.Content.AbsoluteSize.Y/ak.UIScale))
an.ImageLabel.Rotation=180
else
af(ar,0.33,{
Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,0,(ar.Top.AbsoluteSize.Y)/ak.UIScale+(ar.Content.AbsoluteSize.Y/ak.UIScale)),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

af(an.ImageLabel,0.2,{
Rotation=180,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

function al.Close(at,au)
if al.Expandable then
al.Opened=false
if au then
ar.Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,0,(ar.Top.AbsoluteSize.Y/ak.UIScale))
an.ImageLabel.Rotation=0
else
af(ar,0.26,{
Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,0,(ar.Top.AbsoluteSize.Y/ak.UIScale)),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
af(an.ImageLabel,0.2,{
Rotation=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

aa.AddSignal(ar.Top.MouseButton1Click,function()
if al.Expandable then
if al.Opened then
al:Close()
else
al:Open()
end
end
end)

aa.AddSignal(ar.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if al.Opened then
al:Open(true)
end
end)

task.spawn(function()
task.wait(0.02)
if al.Expandable then
ar.Size=UDim2.new(ar.Size.X.Scale,ar.Size.X.Offset,0,ar.Top.AbsoluteSize.Y/ak.UIScale)
ar.AutomaticSize="None"
ar.Top.Size=UDim2.new(1,0,0,(not aq and al.HeaderSize or 0))
ar.Top.AutomaticSize=(not al.Expandable or aq)and"Y"or"None"
ar.Content.Visible=true
end
if al.Opened then
al:Open()
end
end)

return al.__type,al
end

return ah end function a.S()

local aa=a.load'c'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak=ae("Frame",{
Parent=aj.Parent,
Size=aj.ParentType~="Group"and UDim2.new(1,-7,0,7*(aj.Columns or 1))or UDim2.new(0,7*(aj.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=ak}
end

return af end function a.T()
local aa=a.load'c'
local ae=aa.New

local af={}

local function ParseAspectRatio(ah)
if type(ah)=="string"then
local aj,ak=ah:match"(%d+):(%d+)"
if aj and ak then
return tonumber(aj)/tonumber(ak)
end
elseif type(ah)=="number"then
return ah
end
return nil
end

function af.New(ah,aj)
local ak={
__type="Image",
Image=aj.Image or"",
AspectRatio=aj.AspectRatio or"16:9",
Radius=aj.Radius or aj.Window.ElementConfig.UICorner,
}
local al=aa.Image(
ak.Image,
ak.Image,
ak.Radius,
aj.Window.Folder,
"Image",
false
)
if al and al.Parent then
al.Parent=aj.Parent
al.Size=UDim2.new(1,0,0,0)
al.BackgroundTransparency=1












local am=ParseAspectRatio(ak.AspectRatio)
local an

if am then
an=ae("UIAspectRatioConstraint",{
Parent=al,
AspectRatio=am,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function ak.Destroy(ao)
al:Destroy()
end
end

return ak.__type,ak
end

return af end function a.U()
local aa=a.load'c'
local ae=aa.New

local af={}

function af.New(ah,aj)
local ak={
__type="Group",
Elements={}
}

local al=ae("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=aj.Parent,
},{
ae("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,aj.Tab and aj.Tab.Gap or(Window.NewElements and 1 or 6))
}),
})

local am=aj.ElementsModule
am.Load(
ak,
al,
am.Elements,
aj.Window,
aj.WindUI,
function(an,ao)
local ap=aj.Tab and aj.Tab.Gap or(aj.Window.NewElements and 1 or 6)

local aq={}
local ar=0

for as,at in next,ao do
if at.__type=="Space"then
ar=ar+(at.ElementFrame.Size.X.Offset or 6)
elseif at.__type=="Divider"then
ar=ar+(at.ElementFrame.Size.X.Offset or 1)
else
table.insert(aq,at)
end
end

local as=#aq
if as==0 then return end

local at=1/as

local au=ap*(as-1)

local av=-(au+ar)

local aw=math.floor(av/as)
local ax=av-(aw*as)

for ay,az in next,aq do
local aA=aw
if ay<=math.abs(ax)then
aA=aA-1
end

if az.ElementFrame then
az.ElementFrame.Size=UDim2.new(at,aA,0,0)
end
end
end,
am,
aj.UIScale,
aj.Tab
)



return ak.__type,ak
end

return af end function a.V()
return{
Elements={
Paragraph=a.load'C',
Button=a.load'D',
Toggle=a.load'G',
Slider=a.load'H',
Keybind=a.load'I',
Input=a.load'J',
Dropdown=a.load'M',
Code=a.load'P',
Colorpicker=a.load'Q',
Section=a.load'R',
Divider=a.load'K',
Space=a.load'S',
Image=a.load'T',
Group=a.load'U',

},
Load=function(aa,ae,af,ah,aj,ak,al,am,an)
for ao,ap in next,af do
aa[ao]=function(aq,ar)
ar=ar or{}
ar.Tab=an or aa
ar.ParentType=aa.__type
ar.ParentTable=aa
ar.Index=#aa.Elements+1
ar.GlobalIndex=#ah.AllElements+1
ar.Parent=ae
ar.Window=ah
ar.WindUI=aj
ar.UIScale=am
ar.ElementsModule=al local

as, at=ap:New(ar)

if ar.Flag and typeof(ar.Flag)=="string"then
if ah.CurrentConfig then
ah.CurrentConfig:Register(ar.Flag,at)

if ah.PendingConfigData and ah.PendingConfigData[ar.Flag]then
local au=ah.PendingConfigData[ar.Flag]

local av=ah.ConfigManager
if av.Parser[au.__type]then
task.defer(function()
local aw,ax=pcall(function()
av.Parser[au.__type].Load(at,au)
end)

if aw then
ah.PendingConfigData[ar.Flag]=nil
else
warn(
"[ WindUI ] Failed to apply pending config for '"
..ar.Flag
.."': "
..tostring(ax)
)
end
end)
end
end
else
ah.PendingFlags=ah.PendingFlags or{}
ah.PendingFlags[ar.Flag]=at
end
end

local au
for av,aw in next,at do
if typeof(aw)=="table"and av~="ElementFrame"and av:match"Frame$"then
au=aw
break
end
end

if au then
at.ElementFrame=au.UIElements.Main
function at.SetTitle(av,aw)
return au.SetTitle and au:SetTitle(aw)
end
function at.SetDesc(av,aw)
return au.SetDesc and au:SetDesc(aw)
end
function at.SetImage(av,aw,ax)
return au.SetImage and au:SetImage(aw,ax)
end
function at.SetThumbnail(av,aw,ax)
return au.SetThumbnail and au:SetThumbnail(aw,ax)
end
function at.Highlight(av)
au:Highlight()
end
function at.Destroy(av)
au:Destroy()

table.remove(ah.AllElements,ar.GlobalIndex)
table.remove(aa.Elements,ar.Index)
table.remove(an.Elements,ar.Index)
aa:UpdateAllElementShapes(aa)
end
end

ah.AllElements[ar.Index]=at
aa.Elements[ar.Index]=at
if an then
an.Elements[ar.Index]=at
end

if ah.NewElements then
aa:UpdateAllElementShapes(aa)
end

if ak then
ak(at,aa.Elements)
end
return at
end
end
function aa.UpdateAllElementShapes(ao,ap)
for aq,ar in next,ap.Elements do
local as
for at,au in pairs(ar)do
if typeof(au)=="table"and at:match"Frame$"then
as=au
break
end
end

if as then

as.Index=aq
if as.UpdateShape then

as.UpdateShape(ap)
end
end
end
end
end,
}end function a.W()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ae=game:GetService"Players"

aa(game:GetService"UserInputService")
local af=ae.LocalPlayer:GetMouse()

local ah=a.load'c'
local aj=ah.New
local ak=ah.Tween

local al=a.load'A'.New
local am=a.load'w'.New



local an={
Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(an)end,
}

function an.Init(ao,ap,aq,ar)
Window=ao
WindUI=ap
an.ToolTipParent=aq
an.TabHighlight=ar
return an
end

function an.New(ao,ap)
local aq={
__type="Tab",
Title=ao.Title or"Tab",
Desc=ao.Desc,
Icon=ao.Icon,
IconColor=ao.IconColor,
IconShape=ao.IconShape,
IconThemed=ao.IconThemed,
Locked=ao.Locked,
ShowTabTitle=ao.ShowTabTitle,
TabTitleAlign=ao.TabTitleAlign or"Left",
CustomEmptyPage=(ao.CustomEmptyPage and next(ao.CustomEmptyPage)~=nil)and ao.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=ao.Border,
Selected=false,
Index=nil,
Parent=ao.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 0 or 6,

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}

if aq.IconShape then
aq.TabPaddingX=2+(Window.UIPadding/4)
aq.TabPaddingY=2+(Window.UIPadding/4)
aq.TitlePaddingY=2+(Window.UIPadding/4)
end

an.TabCount=an.TabCount+1

local ar=an.TabCount
aq.Index=ar

aq.UIElements.Main=ah.NewRoundFrame(aq.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=ao.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ah.NewRoundFrame(aq.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline",
}),
ah.NewRoundFrame(aq.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("TextLabel",{
Text=aq.Title,
ThemeTag={
TextColor3="TabTitle",
},
TextTransparency=not aq.Locked and 0.4 or 0.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ah.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,aq.TitlePaddingY),
PaddingBottom=UDim.new(0,aq.TitlePaddingY),
}),
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,aq.TabPaddingY),
PaddingLeft=UDim.new(0,aq.TabPaddingX),
PaddingRight=UDim.new(0,aq.TabPaddingX),
PaddingBottom=UDim.new(0,aq.TabPaddingY),
}),
}),
},true)

local as=0
local at
local au

if aq.Icon then
at=ah.Image(
aq.Icon,
aq.Icon..":"..aq.Title,
0,
Window.Folder,
aq.__type,
aq.IconColor and false or true,
aq.IconThemed,
"TabIcon"
)
at.Size=UDim2.new(0,16,0,16)
if aq.IconColor then
at.ImageLabel.ImageColor3=aq.IconColor
end
if not aq.IconShape then
at.Parent=aq.UIElements.Main.Frame
aq.UIElements.Icon=at
at.ImageLabel.ImageTransparency=not aq.Locked and 0 or 0.7
as=-18-(Window.UIPadding/2)
aq.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,as,0,0)
elseif aq.IconColor then
ah.NewRoundFrame(
aq.IconShape~="Circle"and(aq.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=aq.IconColor,
Parent=aq.UIElements.Main.Frame,
},
{
at,
ah.NewRoundFrame(
aq.IconShape~="Circle"and(aq.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Glass-1.4",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=0,
Name="Outline",
}
),
}
)
at.AnchorPoint=Vector2.new(0.5,0.5)
at.Position=UDim2.new(0.5,0,0.5,0)
at.ImageLabel.ImageTransparency=0
at.ImageLabel.ImageColor3=ah.GetTextColorForHSB(aq.IconColor,0.68)
as=-28-(Window.UIPadding/2)
aq.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,as,0,0)
end

au=
ah.Image(aq.Icon,aq.Icon..":"..aq.Title,0,Window.Folder,aq.__type,true,aq.IconThemed)
au.Size=UDim2.new(0,16,0,16)
au.ImageLabel.ImageTransparency=not aq.Locked and 0 or 0.7
as=-30
end

aq.UIElements.ContainerFrame=aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,aq.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,aq.Gap),
HorizontalAlignment="Center",
}),
})

aq.UIElements.ContainerFrameCanvas=aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
aq.UIElements.ContainerFrame,
aj("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=aq.ShowTabTitle or false,
Name="TabTitle",
},{
au,
aj("TextLabel",{
Text=aq.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(ah.Font,Enum.FontWeight.SemiBold),
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
aj("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=aq.TabTitleAlign,
}),
}),
aj("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=aq.ShowTabTitle or false,
}),
})

table.insert(an.Containers,aq.UIElements.ContainerFrameCanvas)
table.insert(an.Tabs,aq)

aq.ContainerFrame=aq.UIElements.ContainerFrameCanvas

ah.AddSignal(aq.UIElements.Main.MouseButton1Click,function()
if not aq.Locked then
an:SelectTab(ar)
end
end)

if Window.ScrollBarEnabled then
am(aq.UIElements.ContainerFrame,aq.UIElements.ContainerFrameCanvas,Window,3)
end

local av
local aw
local ax
local ay=false

if aq.Desc then
ah.AddSignal(aq.UIElements.Main.InputBegan,function()
ay=true
aw=task.spawn(function()
task.wait(0.35)
if ay and not av then
av=al(aq.Desc,an.ToolTipParent,true)
av.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if av then
av.Container.Position=UDim2.new(0,af.X,0,af.Y-4)
end
end

updatePosition()
ax=af.Move:Connect(updatePosition)
av:Open()
end
end)
end)
end

ah.AddSignal(aq.UIElements.Main.MouseEnter,function()
if not aq.Locked then
ah.SetThemeTag(aq.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)

ah.AddSignal(aq.UIElements.Main.InputEnded,function()
if aq.Desc then
ay=false
if aw then
task.cancel(aw)
aw=nil
end
if ax then
ax:Disconnect()
ax=nil
end
if av then
av:Close()
av=nil
end
end

if not aq.Locked then
ah.SetThemeTag(aq.UIElements.Main.Frame,{
ImageTransparency="TabBorderTransparency",
},0.1)
end
end)

function aq.ScrollToTheElement(az,aA)
aq.UIElements.ContainerFrame.ScrollingEnabled=false

ah.Tween(aq.UIElements.ContainerFrame,0.45,{
CanvasPosition=Vector2.new(
0,
aq.Elements[aA].ElementFrame.AbsolutePosition.Y
-aq.UIElements.ContainerFrame.AbsolutePosition.Y
-aq.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.48)

if aq.Elements[aA].Highlight then
aq.Elements[aA]:Highlight()
end
aq.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return aq
end

local az=a.load'V'

az.Load(
aq,
aq.UIElements.ContainerFrame,
az.Elements,
Window,
WindUI,
nil,
az,
ap
)

function aq.SubTabGroup(aA)
local aB={}
local b={}
local d=1

local f=4
local g=42
local h=54
local j=6
local l=76

local function GetButtonWidth(m)
if m<=2 then
return 72
elseif m==3 then
return 66
else
return 60
end
end

local m=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aq.UIElements.ContainerFrame,
},{
aj("UIListLayout",{
Padding=UDim.new(0,4),
SortOrder="LayoutOrder",
}),
})

local p=aj("Frame",{
Size=UDim2.new(1,0,0,h),
BackgroundTransparency=1,
Parent=m,
})

local r=ah.NewRoundFrame(999,"Squircle",{
Name="NavigationBar",
Size=UDim2.new(0,0,0,h),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.93,
Parent=p,
},{
ah.NewRoundFrame(999,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.82,
}),
ah.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(1,-2,1,-2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="InnerGlass",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.965,
}),
aj("Frame",{
Name="TopLine",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.965,
Size=UDim2.new(1,-20,0,1),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
},{
aj("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),
})

local u=aj("Frame",{
Name="ButtonsWrap",
Size=UDim2.new(0,0,0,g),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Parent=r,
})

local v=ah.NewRoundFrame(999,"Squircle",{
Name="ActivePill",
Size=UDim2.new(0,l-4,0,g-4),
Position=UDim2.new(0,2,0,2),
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=0.06,
Visible=false,
Parent=u,
},{
ah.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.86,
}),
aj("Frame",{
Name="TopLine",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.96,
Size=UDim2.new(1,-18,0,1),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
},{
aj("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),
})

local x=aj("Frame",{
Name="ItemsFrame",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,g),
Parent=u,
},{
aj("UIListLayout",{
Padding=UDim.new(0,f),
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
SortOrder="LayoutOrder",
}),
})

local z=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=m,
},{
aj("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
}),
})

local function UpdateBarSize()
local A=#b
if A<=0 then
r.Size=UDim2.new(0,0,0,h)
u.Size=UDim2.new(0,0,0,g)
x.Size=UDim2.new(0,0,0,g)
v.Visible=false
return
end

l=GetButtonWidth(A)

local B=(A*l)+(math.max(A-1,0)*f)

for C,F in ipairs(b)do
F.Button.Size=UDim2.new(0,l,0,g)
end

v.Size=UDim2.new(0,l-4,0,g-4)
r.Size=UDim2.new(0,B+(j*2),0,h)
u.Size=UDim2.new(0,B,0,g)
x.Size=UDim2.new(0,B,0,g)
v.Visible=true
end

local function MoveActivePill(A,B)
local C=((A-1)*(l+f))+2

if B then
v.Position=UDim2.new(0,C,0,2)
else
ak(
v,
0.22,
{Position=UDim2.new(0,C,0,2)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end

local function SetSubTab(A,B)
d=A
MoveActivePill(A,B)

for C,F in ipairs(b)do
local G=(C==A)
F.Page.Visible=G

if B then
F.Label.TextTransparency=G and 0 or 0.22
if F.Icon then
F.Icon.ImageTransparency=G and 0 or 0.22
end
else
ak(
F.Label,
0.18,
{TextTransparency=G and 0 or 0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if F.Icon then
ak(
F.Icon,
0.18,
{ImageTransparency=G and 0 or 0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end
end

function aB.AddSubTab(A,B,C)
local F=setmetatable({
Title=B,
Name=B,
__type="Tab",
Elements={},
UIElements={},
},{__index=aq})

local G=(#b==0)

local H=aj("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=G,
Parent=z,
},{
aj("UIListLayout",{
Padding=UDim.new(0,aq.Gap),
SortOrder="LayoutOrder",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,0),
PaddingLeft=UDim.new(0,0),
PaddingRight=UDim.new(0,0),
PaddingBottom=UDim.new(0,0),
}),
})

local J=C and ah.Icon(C)

local L=J and aj("ImageLabel",{
Name="Icon",
Image=J[1],
ImageRectOffset=J[2].ImageRectPosition,
ImageRectSize=J[2].ImageRectSize,
Size=UDim2.new(0,16,0,16),
BackgroundTransparency=1,
ImageColor3=Color3.new(1,1,1),
ImageTransparency=G and 0 or 0.22,
LayoutOrder=1,
})or nil

local M=aj("TextLabel",{
Name="Label",
Text=B,
Size=UDim2.new(1,-8,0,18),
BackgroundTransparency=1,
TextXAlignment="Center",
TextYAlignment="Center",
TextWrapped=false,
TextTruncate="AtEnd",
TextSize=10,
TextColor3=Color3.new(1,1,1),
TextTransparency=G and 0 or 0.22,
FontFace=Font.new(ah.Font,Enum.FontWeight.SemiBold),
LayoutOrder=2,
})

local N=aj("TextButton",{
Name="NavButton",
Size=UDim2.new(0,l,0,g),
BackgroundTransparency=1,
AutoButtonColor=false,
Text="",
Parent=x,
},{
aj("Frame",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment="Center",
VerticalAlignment="Center",
Padding=UDim.new(0,1),
SortOrder="LayoutOrder",
}),
L,
M,
}),
})

F.UIElements.ContainerFrame=H
F.UIElements.Main=N

local O=#b+1

ah.AddSignal(N.MouseButton1Click,function()
SetSubTab(O,false)
end)

ah.AddSignal(N.MouseEnter,function()
if d~=O then
ak(
M,
0.14,
{TextTransparency=0.1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if L then
ak(
L,
0.14,
{ImageTransparency=0.1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end)

ah.AddSignal(N.MouseLeave,function()
if d~=O then
ak(
M,
0.14,
{TextTransparency=0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if L then
ak(
L,
0.14,
{ImageTransparency=0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end)

table.insert(b,{
Page=H,
Button=N,
Icon=L,
Label=M,
})

UpdateBarSize()

az.Load(
F,
H,
az.Elements,
Window,
WindUI,
nil,
az,
ap
)

if G then
SetSubTab(1,true)
else
SetSubTab(d,true)
end

return F
end

return aB
end

function aq.LockAll(aA)
for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==aq.Index and b.Lock then
b:Lock()
end
end
end

function aq.UnlockAll(aA)
for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==aq.Index and b.Unlock then
b:Unlock()
end
end
end

function aq.GetLocked(aA)
local aB={}
for b,d in next,Window.AllElements do
if d.Tab and d.Tab.Index and d.Tab.Index==aq.Index and d.Locked==true then
table.insert(aB,d)
end
end
return aB
end

function aq.GetUnlocked(aA)
local aB={}
for b,d in next,Window.AllElements do
if d.Tab and d.Tab.Index and d.Tab.Index==aq.Index and d.Locked==false then
table.insert(aB,d)
end
end
return aB
end

function aq.Select(aA)
return an:SelectTab(aq.Index)
end

task.spawn(function()
local aA
if aq.CustomEmptyPage.Icon then
aA=
ah.Image(aq.CustomEmptyPage.Icon,aq.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
aA.Size=
UDim2.fromOffset(aq.CustomEmptyPage.IconSize or 48,aq.CustomEmptyPage.IconSize or 48)
end

local aB=aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=aq.UIElements.ContainerFrame,
},{
aj("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
aA,
aq.CustomEmptyPage.Title
and aj("TextLabel",{
AutomaticSize="XY",
Text=aq.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(ah.Font,Enum.FontWeight.Medium),
})
or nil,
aq.CustomEmptyPage.Desc
and aj("TextLabel",{
AutomaticSize="XY",
Text=aq.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(ah.Font,Enum.FontWeight.Regular),
})
or nil,
})

local b
b=ah.AddSignal(aq.UIElements.ContainerFrame.ChildAdded,function()
aB.Visible=false
b:Disconnect()
end)
end)

return aq
end

function an.OnChange(ao,ap)
an.OnChangeFunc=ap
end

function an.SelectTab(ao,ap)
local aq=an.Tabs[ap]
local ar=an.Containers[ap]

if not aq or not ar or aq.Locked then
return
end

an.SelectedTab=ap

for as,at in next,an.Tabs do
if not at.Locked then
ah.SetThemeTag(at.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if at.Border then
ah.SetThemeTag(at.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
ah.SetThemeTag(at.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
if at.UIElements.Icon and not at.IconColor then
ah.SetThemeTag(at.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparency",
},0.15)
end
at.Selected=false
end
end

ah.SetThemeTag(aq.UIElements.Main,{
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if aq.Border then
ah.SetThemeTag(aq.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
ah.SetThemeTag(aq.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
if aq.UIElements.Icon and not aq.IconColor then
ah.SetThemeTag(aq.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end
aq.Selected=true

task.spawn(function()
for as,at in next,an.Containers do
at.AnchorPoint=Vector2.new(0,0.05)
at.Visible=false
end
ar.Visible=true
local as=game:GetService"TweenService"

local at=TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local au=as:Create(ar,at,{
AnchorPoint=Vector2.new(0,0),
})
au:Play()
end)

an.OnChangeFunc(ap)
end

return an end function a.X()

local aa={}


local ae=a.load'c'
local af=ae.New
local ah=ae.Tween

local aj=a.load'W'

function aa.New(ak,al,am,an,ao)
local ap={
Title=ak.Title or"Section",
Icon=ak.Icon,
IconThemed=ak.IconThemed,
Opened=ak.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local aq
if ap.Icon then
aq=ae.Image(
ap.Icon,
ap.Icon,
0,
am,
"Section",
true,
ap.IconThemed,
"TabSectionIcon"
)

aq.Size=UDim2.new(0,ap.IconSize,0,ap.IconSize)
aq.ImageLabel.ImageTransparency=.25
end

local ar=af("Frame",{
Size=UDim2.new(0,ap.IconSize,0,ap.IconSize),
BackgroundTransparency=1,
Visible=false
},{
af("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ae.Icon"chevron-down"[1],
ImageRectSize=ae.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ae.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local as=af("Frame",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Parent=al,
ClipsDescendants=true,
},{
af("TextButton",{
Size=UDim2.new(1,0,0,ap.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
aq,
af("TextLabel",{
Text=ap.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
aq and(-ap.IconSize-10)*2
or(-ap.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ae.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
af("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
ar,
af("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
af("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ap.HeaderSize)
},{
af("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,ao.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ap.Tab(at,au)
if not ap.Expandable then
ap.Expandable=true
ar.Visible=true
end
au.Parent=as.Content
return aj.New(au,an)
end

function ap.Open(at)
if ap.Expandable then
ap.Opened=true
ah(as,0.33,{
Size=UDim2.new(1,0,0,ap.HeaderSize+(as.Content.AbsoluteSize.Y/an))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ah(ar.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ap.Close(at)
if ap.Expandable then
ap.Opened=false
ah(as,0.26,{
Size=UDim2.new(1,0,0,ap.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ah(ar.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ae.AddSignal(as.TextButton.MouseButton1Click,function()
if ap.Expandable then
if ap.Opened then
ap:Close()
else
ap:Open()
end
end
end)

ae.AddSignal(as.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ap.Opened then
ap:Open()
end
end)

if ap.Opened then
task.spawn(function()
task.wait()
ap:Open()
end)
end



return ap
end


return aa end function a.Y()
return{
Tab="table-of-contents",
Paragraph="type",
Button="square-mouse-pointer",
Toggle="toggle-right",
Slider="sliders-horizontal",
Keybind="command",
Input="text-cursor-input",
Dropdown="chevrons-up-down",
Code="terminal",
Colorpicker="palette",
}end function a.Z()
local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")

local ae={
Margin=8,
Padding=9,
}

local af=a.load'c'
local ah=af.New
local aj=af.Tween

function ae.new(ak,al,am)
local an={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'Y',
}

local ao=ah("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(1,-((an.IconSize*2)+(an.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ap=ah("ImageLabel",{
Image=af.Icon"x"[1],
ImageRectSize=af.Icon"x"[2].ImageRectSize,
ImageRectOffset=af.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize),
},{
ah("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})

local aq=ah("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ah("UIPadding",{
PaddingTop=UDim.new(0,an.Padding),
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
PaddingBottom=UDim.new(0,an.Padding),
}),
})

local ar=af.NewRoundFrame(an.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
af.NewRoundFrame(an.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ah("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ah("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ah("ImageLabel",{
Image=af.Icon"search"[1],
ImageRectSize=af.Icon"search"[2].ImageRectSize,
ImageRectOffset=af.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize),
}),
ao,
ap,
ah("UIListLayout",{
Padding=UDim.new(0,an.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ah("UIPadding",{
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
}),
}),
}),
ah("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ah("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
aq,
ah("UISizeConstraint",{
MaxSize=Vector2.new(an.Width,an.MaxHeight),
}),
}),
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
})

local as=ah("Frame",{
Size=UDim2.new(0,an.Width,0,0),
AutomaticSize="Y",
Parent=al,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ah("UIScale",{
Scale=0.9,
}),
ar,
af.NewRoundFrame(an.Radius,"Glass-0.7",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,


ThemeTag={
ImageColor3="SearchBarBorder",
ImageTransparency="SearchBarBorderTransparency",
},
Name="Outline",
}),
})

local function CreateSearchTab(at,au,av,aw,ax,ay)
local az=ah("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=aw or nil,
},{
af.NewRoundFrame(an.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
af.NewRoundFrame(an.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ah("UIPadding",{
PaddingTop=UDim.new(0,an.Padding-2),
PaddingLeft=UDim.new(0,an.Padding),
PaddingRight=UDim.new(0,an.Padding),
PaddingBottom=UDim.new(0,an.Padding-2),
}),
ah("ImageLabel",{
Image=af.Icon(av)[1],
ImageRectSize=af.Icon(av)[2].ImageRectSize,
ImageRectOffset=af.Icon(av)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,an.IconSize,0,an.IconSize),
}),
ah("Frame",{
Size=UDim2.new(1,-an.IconSize-an.Padding,0,0),
BackgroundTransparency=1,
},{
ah("TextLabel",{
Text=at,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
ah("TextLabel",{
Text=au or"",
Visible=au and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
ah("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
}),
ah("UIListLayout",{
Padding=UDim.new(0,an.Padding),
FillDirection="Horizontal",
}),
}),
},true),
ah("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-an.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=ax,

},{
af.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
ah("Frame",{
Size=UDim2.new(1,-an.Padding-2,0,0),
Position=UDim2.new(0,an.Padding+2,0,0),
BackgroundTransparency=1,
},{
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ah("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



az.Main.Size=UDim2.new(
1,
0,
0,
az.Main.Outline.Frame.Desc.Visible
and(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y+6+az.Main.Outline.Frame.Desc.TextBounds.Y)
or(((an.Padding-2)*2)+az.Main.Outline.Frame.Title.TextBounds.Y)
)

af.AddSignal(az.Main.MouseEnter,function()
aj(az.Main,0.04,{ImageTransparency=0.95}):Play()
aj(az.Main.Outline,0.04,{ImageTransparency=0.75}):Play()
end)
af.AddSignal(az.Main.InputEnded,function()
aj(az.Main,0.08,{ImageTransparency=1}):Play()
aj(az.Main.Outline,0.08,{ImageTransparency=1}):Play()
end)
af.AddSignal(az.Main.MouseButton1Click,function()
if ay then
ay()
end
end)

return az
end

local function ContainsText(at,au)
if not au or au==""then
return false
end

if not at or at==""then
return false
end

local av=string.lower(at)
local aw=string.lower(au)

return string.find(av,aw,1,true)~=nil
end

local function Search(at)
if not at or at==""then
return{}
end

local au={}
for av,aw in next,ak.Tabs do
local ax=ContainsText(aw.Title or"",at)
local ay={}

for az,aA in next,aw.Elements do
if aA.__type~="Section"then
local aB=ContainsText(aA.Title or"",at)
local b=ContainsText(aA.Desc or"",at)

if aB or b then
ay[az]={
Title=aA.Title,
Desc=aA.Desc,
Original=aA,
__type=aA.__type,
Index=az,
}
end
end
end

if ax or next(ay)~=nil then
au[av]={
Tab=aw,
Title=aw.Title,
Icon=aw.Icon,
Elements=ay,
}
end
end
return au
end

af.AddSignal(aq.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

aj(aq,0.06,{
Size=UDim2.new(
1,
0,
0,
math.clamp(
aq.UIListLayout.AbsoluteContentSize.Y+(an.Padding*2),
0,
an.MaxHeight
)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function an.Open(at)
task.spawn(function()
ar.Frame.Visible=true
as.Visible=true
aj(as.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function an.Close(at,au)
task.spawn(function()
am()
ar.Frame.Visible=false
aj(as.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.12)
as.Visible=false
if au then
as:Destroy()
end
end)
end

af.AddSignal(ap.TextButton.MouseButton1Click,function()
an:Close(true)
end)

an:Open()

function an.Search(at,au)
au=au or""

local av=Search(au)

aq.Visible=true
ar.Frame.Results.Frame.Visible=true
for aw,ax in next,aq:GetChildren()do
if ax.ClassName~="UIListLayout"and ax.ClassName~="UIPadding"then
ax:Destroy()
end
end

if av and next(av)~=nil then
for aw,ax in next,av do
local ay=an.Icons.Tab
local az=CreateSearchTab(ax.Title,nil,ay,aq,true,function()
an:Close()
ak:SelectTab(aw)
end)
if ax.Elements and next(ax.Elements)~=nil then
for aA,aB in next,ax.Elements do
local b=an.Icons[aB.__type]
CreateSearchTab(
aB.Title,
aB.Desc,
b,
az:FindFirstChild"ParentContainer"and az.ParentContainer.Frame
or nil,
false,
function()
an:Close()
ak:SelectTab(aw)
if ax.Tab.ScrollToTheElement then

ax.Tab:ScrollToTheElement(aB.Index)
end

end
)

end
end
end
elseif au~=""then
ah("TextLabel",{
Size=UDim2.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=Font.new(af.Font,Enum.FontWeight.Medium),
Parent=aq,
Name="NotFound",
})
else
aq.Visible=false
ar.Frame.Results.Frame.Visible=false
end
end

af.AddSignal(ao:GetPropertyChangedSignal"Text",function()
an:Search(ao.Text)
end)

return an
end

return ae end function a._()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ae=aa(game:GetService"UserInputService")
local af=aa(game:GetService"RunService")
local ah=aa(game:GetService"Players")

local aj=workspace.CurrentCamera

local ak=a.load's'

local al=a.load'c'
local am=al.New
local an=al.Tween

local ao=a.load'v'.New
local ap=a.load'l'.New
local aq=a.load'w'.New
local ar=a.load'x'

local as=a.load'y'



return function(at)
local au={
Title=at.Title or"UI Library",
SubTitle=at.SubTitle,
TitleMessages=at.TitleMessages,
TitleAnim=at.TitleAnim,
TitleFont=at.TitleFont or al.Font,
TitleFontWeight=at.TitleFontWeight or Enum.FontWeight.SemiBold,
TitleTextSize=at.TitleTextSize or 16,

Author=at.Author,
Icon=at.Icon,
IconSize=at.IconSize or 22,
IconThemed=at.IconThemed,
IconRadius=at.IconRadius or 0,
Folder=at.Folder,
Resizable=at.Resizable~=false,
Background=at.Background,
BackgroundImageTransparency=at.BackgroundImageTransparency or 0,
ShadowTransparency=at.ShadowTransparency or 0.6,
User=at.User or{},
Footer=at.Footer or{},
Topbar=at.Topbar or{Height=52,ButtonsType="Default"},

Size=at.Size,

MinSize=at.MinSize or Vector2.new(560,350),
MaxSize=at.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=at.TopBarButtonIconSize,

ToggleKey=at.ToggleKey,
ElementsRadius=at.ElementsRadius,
Radius=at.Radius or 16,
Transparent=at.Transparent or false,
HideSearchBar=at.HideSearchBar~=false,
ScrollBarEnabled=at.ScrollBarEnabled or false,
SideBarWidth=at.SideBarWidth or 200,
Acrylic=at.Acrylic or false,
NewElements=at.NewElements or false,
IgnoreAlerts=at.IgnoreAlerts or false,
HidePanelBackground=at.HidePanelBackground or false,
AutoScale=at.AutoScale~=false,
OpenButton=at.OpenButton,
DragFrameSize=160,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=at.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=at.Resizable~=false,
IsOpenButtonEnabled=true,

CurrentConfig=nil,
ConfigManager=nil,
AcrylicPaint=nil,
CurrentTab=nil,
TabModule=nil,

OnOpenCallback=nil,
OnCloseCallback=nil,
OnDestroyCallback=nil,

IsPC=false,

Gap=5,

TopBarButtons={},
AllElements={},

ElementConfig={},

PendingFlags={},

IsToggleDragging=false,
}

au.UICorner=au.Radius
au.TopBarButtonIconSize=au.TopBarButtonIconSize or(au.Topbar.ButtonsType=="Mac"and 11 or 16)

au.ElementConfig={
UIPadding=(au.NewElements and 10 or 13),
UICorner=au.ElementsRadius or(au.NewElements and 23 or 12),
}

local av=au.Size or UDim2.new(0,580,0,460)
au.Size=UDim2.new(
av.X.Scale,
math.clamp(av.X.Offset,au.MinSize.X,au.MaxSize.X),
av.Y.Scale,
math.clamp(av.Y.Offset,au.MinSize.Y,au.MaxSize.Y)
)

if au.Topbar=={}then
au.Topbar={Height=52,ButtonsType="Default"}
end

if not af:IsStudio()and au.Folder and writefile then
if not isfolder("WindUI/"..au.Folder)then
makefolder("WindUI/"..au.Folder)
end
if not isfolder("WindUI/"..au.Folder.."/assets")then
makefolder("WindUI/"..au.Folder.."/assets")
end
if not isfolder(au.Folder)then
makefolder(au.Folder)
end
if not isfolder(au.Folder.."/assets")then
makefolder(au.Folder.."/assets")
end
end

local aw=am("UICorner",{
CornerRadius=UDim.new(0,au.UICorner),
})

if au.Folder then
au.ConfigManager=as:Init(au)
end

if au.Acrylic then
local ax=ak.AcrylicPaint{UseAcrylic=au.Acrylic}
au.AcrylicPaint=ax
end

local ax=am("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
am("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local ay=al.NewRoundFrame(au.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
am("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=al.Icon"expand"[1],
ImageRectOffset=al.Icon"expand"[2].ImageRectPosition,
ImageRectSize=al.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local az=al.NewRoundFrame(au.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})

au.UIElements.SideBar=am("ScrollingFrame",{
Size=UDim2.new(
1,
au.ScrollBarEnabled and-3-(au.UIPadding/2)or 0,
1,
not au.HideSearchBar and-45 or 0
),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ClipsDescendants=true,
VerticalScrollBarPosition="Left",
},{
am("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
am("UIPadding",{
PaddingBottom=UDim.new(0,au.UIPadding/2),
}),
am("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,au.Gap),
}),
}),
am("UIPadding",{
PaddingLeft=UDim.new(0,au.UIPadding/2),
PaddingRight=UDim.new(0,au.UIPadding/2),
}),
})

au.UIElements.SideBarContainer=am("Frame",{
Size=UDim2.new(
0,
au.SideBarWidth,
1,
au.User.Enabled and-au.Topbar.Height-42-(au.UIPadding*2)or-au.Topbar.Height
),
Position=UDim2.new(0,0,0,au.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
am("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,not au.HideSearchBar and-45-au.UIPadding/2 or 0),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
au.UIElements.SideBar,
})

if au.ScrollBarEnabled then
aq(au.UIElements.SideBar,au.UIElements.SideBarContainer.Content,au,3)
end

au.UIElements.MainBar=am("Frame",{
Size=UDim2.new(1,-au.UIElements.SideBarContainer.AbsoluteSize.X,1,-au.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
al.NewRoundFrame(au.UICorner-(au.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},
ZIndex=3,
Name="Background",
Visible=not au.HidePanelBackground,
}),
am("UIPadding",{
PaddingLeft=UDim.new(0,au.UIPadding/2),
PaddingRight=UDim.new(0,au.UIPadding/2),
PaddingBottom=UDim.new(0,au.UIPadding/2),
}),
})

local aA=am("ImageLabel",{
Image="rbxassetid://8992230677",
ThemeTag={
ImageColor3="WindowShadow",
},
ImageTransparency=1,
Size=UDim2.new(1,100,1,100),
Position=UDim2.new(0,-50,0,-50),
ScaleType="Slice",
SliceCenter=Rect.new(99,99,99,99),
BackgroundTransparency=1,
ZIndex=-999999999999999,
Name="Blur",
})

if ae.TouchEnabled and not ae.KeyboardEnabled then
au.IsPC=false
elseif ae.KeyboardEnabled then
au.IsPC=true
else
au.IsPC=nil
end

local aB
if au.User then
local function GetUserThumb()
local b=ah:GetUserThumbnailAsync(
au.User.Anonymous and 1 or ah.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return b
end

aB=am("TextButton",{
Size=UDim2.new(
0,
au.UIElements.SideBarContainer.AbsoluteSize.X-(au.UIPadding/2),
0,
42+au.UIPadding
),
Position=UDim2.new(0,au.UIPadding/2,1,-(au.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=au.User.Enabled or false,
},{
al.NewRoundFrame(au.UICorner-(au.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline",
},{
am("UIGradient",{
Rotation=78,
Color=ColorSequence.new{
ColorSequenceKeypoint.new(0.0,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,255,255)),
ColorSequenceKeypoint.new(1.0,Color3.fromRGB(255,255,255)),
},
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0.0,0.1),
NumberSequenceKeypoint.new(0.5,1),
NumberSequenceKeypoint.new(1.0,0.1),
},
}),
}),
al.NewRoundFrame(au.UICorner-(au.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
am("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=0.93,
},{
am("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
am("TextLabel",{
Text=au.User.Anonymous and"Anonymous"or ah.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(al.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName",
}),
am("TextLabel",{
Text=au.User.Anonymous and"anonymous"or ah.LocalPlayer.Name,
TextSize=15,
TextTransparency=0.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName",
}),
am("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
}),
}),
am("UIListLayout",{
Padding=UDim.new(0,au.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
am("UIPadding",{
PaddingLeft=UDim.new(0,au.UIPadding/2),
PaddingRight=UDim.new(0,au.UIPadding/2),
}),
}),
})

function au.User.Enable(b)
au.User.Enabled=true
an(
au.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,au.SideBarWidth,1,-au.Topbar.Height-42-(au.UIPadding*2))},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aB.Visible=true
end

function au.User.Disable(b)
au.User.Enabled=false
an(
au.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,au.SideBarWidth,1,-au.Topbar.Height)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aB.Visible=false
end

function au.User.SetAnonymous(b,d)
if d~=false then
d=true
end
au.User.Anonymous=d
aB.UserIcon.ImageLabel.Image=GetUserThumb()
aB.UserIcon.Frame.DisplayName.Text=d and"Anonymous"or ah.LocalPlayer.DisplayName
aB.UserIcon.Frame.UserName.Text=d and"anonymous"or ah.LocalPlayer.Name
end

if au.User.Enabled then
au.User:Enable()
else
au.User:Disable()
end

if au.User.Callback then
al.AddSignal(aB.MouseButton1Click,function()
au.User.Callback()
end)
al.AddSignal(aB.MouseEnter,function()
an(aB.UserIcon,0.04,{ImageTransparency=0.95}):Play()
an(aB.Outline,0.04,{ImageTransparency=0.85}):Play()
end)
al.AddSignal(aB.InputEnded,function()
an(aB.UserIcon,0.04,{ImageTransparency=1}):Play()
an(aB.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local b
local d

local f=false
local g

local h=typeof(au.Background)=="string"and string.match(au.Background,"^video:(.+)")or nil
local j=typeof(au.Background)=="string"
and not h
and string.match(au.Background,"^https?://.+")
or nil

local function GetImageExtension(l)
local m=l:match"%.(%w+)$"or l:match"%.(%w+)%?"
if m then
m=m:lower()
if m=="jpg"or m=="jpeg"or m=="png"or m=="webp"then
return"."..m
end
end
return".png"
end

if typeof(au.Background)=="string"and h then
f=true

if string.find(h,"http")then
local l=au.Folder.."/assets/."..al.SanitizeFilename(h)..".webm"
if not isfile(l)then
local m,p=pcall(function()
local m=game.HttpGet and game:HttpGet(h)
writefile(l,m.Body)
end)
if not m then
warn("[ WindUI.Window.Background ] Failed to download video: "..tostring(p))
return
end
end

local m,p=pcall(function()
return getcustomasset(l)
end)
if not m then
warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(p))
return
end
warn"[ WindUI.Window.Background ] VideoFrame may not work with custom video"
h=p
end

g=am("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=h,
Looped=true,
Volume=0,
},{
am("UICorner",{
CornerRadius=UDim.new(0,au.UICorner),
}),
})
g:Play()
elseif j then
local l=au.Folder
.."/assets/."
..al.SanitizeFilename(j)
..GetImageExtension(j)

if isfile and not isfile(l)then
local m,p=pcall(function()
local m=game.HttpGet and game:HttpGet(j)
writefile(l,m.Body)
end)
if not m then
warn("[ Window.Background ] Failed to download image: "..tostring(p))
return
end
end

local m,p=pcall(function()
return getcustomasset(l)
end)
if not m then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(p))
return
end

g=am("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=p,
ImageTransparency=0,
ScaleType="Crop",
},{
am("UICorner",{
CornerRadius=UDim.new(0,au.UICorner),
}),
})
elseif au.Background then
g=am("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(au.Background)=="string"and au.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
am("UICorner",{
CornerRadius=UDim.new(0,au.UICorner),
}),
})
end

local l=al.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
am("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

local function createAuthor(m)
return am("TextLabel",{
Text=m,
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=au.UIElements.Main and au.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local m
local p

if au.Author then
m=createAuthor(au.Author)
end

local r={
Text=au.Title,
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=au.TitleTextSize,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
}

if typeof(au.TitleFont)=="EnumItem"then
r.Font=au.TitleFont
else
r.FontFace=Font.new(au.TitleFont,au.TitleFontWeight)
end

local u=am("TextLabel",r)

local function ApplyWindowTitleFont()
if typeof(au.TitleFont)=="EnumItem"then
u.Font=au.TitleFont
else
u.FontFace=Font.new(au.TitleFont,au.TitleFontWeight)
end
u.TextSize=au.TitleTextSize
end

local v=0

local function GetTitleMessages()
local x={}

if type(au.TitleMessages)=="table"and#au.TitleMessages>0 then
for z,A in ipairs(au.TitleMessages)do
if type(A)=="string"and A~=""then
table.insert(x,A)
end
end
else
if type(au.Title)=="string"and au.Title~=""then
table.insert(x,au.Title)
end
if type(au.SubTitle)=="string"and au.SubTitle~=""and au.SubTitle~=au.Title then
table.insert(x,au.SubTitle)
end
end

if#x==0 then
x={"UI Library"}
end

return x
end

local function GetTitleAnimConfig()
local x=au.TitleAnim

if not x or x==false or x=="None"then
return nil
end

if type(x)=="string"then
local z=
(x=="FadeLoop"or x=="Pulse"or x=="TypingCursor"or x=="TypingWrite")
return{
Type=x,
Speed=0.055,
Delay=3.5,
Loop=z,
CursorChar="▏",
}
end

if type(x)=="table"then
local z=x.Type or x.Name or"TypingWrite"
local A=
(z=="FadeLoop"or z=="Pulse"or z=="TypingCursor"or z=="TypingWrite")

return{
Type=z,
Speed=x.Speed or 0.055,
Delay=x.Delay or 3.5,
Loop=x.Loop==nil and A or x.Loop,
CursorChar=x.CursorChar or"▏",
}
end

return nil
end

local function ResetWindowTitleVisual()
u.Text=au.Title
u.TextTransparency=0
u.Position=UDim2.new(0,0,0,0)
u.TextSize=au.TitleTextSize
ApplyWindowTitleFont()
end

local function StopWindowTitleAnimation()
v+=1
ResetWindowTitleVisual()
end

local function RunWindowTitleAnimation()
StopWindowTitleAnimation()

local x=GetTitleAnimConfig()
if not x then
return
end

local z=v
local A=GetTitleMessages()
local B=string.lower(tostring(x.Type))

task.spawn(function()
local function alive()
return z==v and not au.Destroyed
end

local C=1

local function getCurrentMessage()
return A[C]or au.Title or"UI Library"
end

local function nextMessage()
C+=1
if C>#A then
C=1
end
end

if B=="typingwrite"or B=="typingcursor"then
repeat
local F=getCurrentMessage()

u.Text=""
u.TextTransparency=0

for G=1,#F do
if not alive()then
return
end

local H=string.sub(F,1,G)
if B=="typingcursor"then
u.Text=H..x.CursorChar
else
u.Text=H
end

task.wait(x.Speed)
end

u.Text=F

if B=="typingcursor"then
for G=1,4 do
if not alive()then
return
end
u.Text=F..x.CursorChar
task.wait(0.3)

if not alive()then
return
end
u.Text=F
task.wait(0.3)
end
end

if#A<=1 and not x.Loop then
break
end

task.wait(x.Delay)
nextMessage()
until not alive()

if alive()then
ResetWindowTitleVisual()
end
elseif B=="fadeloop"then
while alive()do
local F=getCurrentMessage()
u.Text=F

an(
u,
0.8,
{TextTransparency=0.28},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut
):Play()
task.wait(0.8)

if not alive()then
return
end

an(
u,
0.8,
{TextTransparency=0},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut
):Play()
task.wait(x.Delay)

if#A>1 or x.Loop then
nextMessage()
else
break
end
end
elseif B=="pulse"then
while alive()do
local F=getCurrentMessage()
u.Text=F

an(
u,
0.18,
{TextSize=au.TitleTextSize+1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
task.wait(0.18)

if not alive()then
return
end

an(
u,
0.22,
{TextSize=au.TitleTextSize},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
task.wait(x.Delay)

if#A>1 or x.Loop then
nextMessage()
else
break
end
end
elseif B=="slidereveal"then
repeat
local F=getCurrentMessage()
u.Text=F
u.Position=UDim2.new(0,-10,0,0)
u.TextTransparency=1

an(
u,
0.28,
{
Position=UDim2.new(0,0,0,0),
TextTransparency=0,
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if#A<=1 and not x.Loop then
break
end

task.wait(x.Delay)
nextMessage()
until not alive()

if alive()then
ResetWindowTitleVisual()
end
end
end)
end

local x

au.UIElements.Main=am("Frame",{
Size=au.Size,
Position=au.Position,
BackgroundTransparency=1,
Parent=at.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
at.WindUI.UIScaleObj,
au.AcrylicPaint and au.AcrylicPaint.Frame or nil,
aA,
al.NewRoundFrame(au.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
},
},{
g,
l,
ax,
}),
x,
aw,
ay,
az,
am("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",
Visible=false,
ZIndex=97,
},{
am("UICorner",{
CornerRadius=UDim.new(0,au.UICorner),
}),
au.UIElements.SideBarContainer,
au.UIElements.MainBar,
aB,
d,
am("Frame",{
Size=UDim2.new(1,0,0,au.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar",
},{
b,

am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Name="MacButtons",
Visible=au.Topbar.ButtonsType=="Mac",
},{
am("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
VerticalAlignment="Center",
}),
}),

am("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
am("UIListLayout",{
Padding=UDim.new(0,au.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
am("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
u,
m,
}),
am("UIPadding",{
PaddingLeft=UDim.new(0,4),
}),
}),

am("ScrollingFrame",{
Name="Center",
BackgroundTransparency=1,
AutomaticSize="Y",
ScrollBarThickness=0,
ScrollingDirection="X",
AutomaticCanvasSize="X",
CanvasSize=UDim2.new(0,0,0,0),
Size=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,0.5),
Position=UDim2.new(0,0,0.5,0),
Visible=false,
},{
am("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,au.UIPadding/2),
}),
}),

am("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
am("UIListLayout",{
Padding=UDim.new(0,au.Topbar.ButtonsType=="Default"and 9 or 8),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
VerticalAlignment="Center",
}),
}),

am("UIPadding",{
PaddingTop=UDim.new(0,au.UIPadding),
PaddingLeft=UDim.new(
0,
au.Topbar.ButtonsType=="Default"and au.UIPadding or au.UIPadding-2
),
PaddingRight=UDim.new(0,au.Topbar.ButtonsType=="Mac"and 14 or 8),
PaddingBottom=UDim.new(0,au.UIPadding),
}),
}),
}),
})

local z=au.UIElements.Main.Main.Topbar

local A=al.NewRoundFrame(999,"Squircle",{
Name="HoverHint",
Size=UDim2.new(0,0,0,22),
AutomaticSize="XY",
BackgroundTransparency=1,
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Text",
},
Parent=z,
Visible=false,
ZIndex=10050,
},{
al.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.83,
ZIndex=10051,
}),
am("TextLabel",{
Name="Label",
AutomaticSize="XY",
BackgroundTransparency=1,
Text="",
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
TextSize=12,
TextTransparency=0.18,
ThemeTag={
TextColor3="Text",
},
ZIndex=10052,
}),
am("UIPadding",{
PaddingLeft=UDim.new(0,9),
PaddingRight=UDim.new(0,9),
PaddingTop=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
})

local B=0

local function HideHoverHint()
B+=1
A.Visible=false
end

local function ShowHoverHint(C,F)
B+=1
local G=B

task.spawn(function()
task.wait(0.32)

if G~=B or not C or not C.Parent then
return
end

A.Label.Text=F or""
A.Visible=true
A.ImageTransparency=0.14
A.Outline.ImageTransparency=0.86

task.wait()

if G~=B or not C or not C.Parent then
A.Visible=false
return
end

local H=z.AbsolutePosition
local J=C.AbsolutePosition
local L=C.AbsoluteSize
local M=A.AbsoluteSize

local N=(J.X-H.X)+(L.X/2)-(M.X/2)
local O=math.max(z.AbsoluteSize.X-M.X-8,8)
N=math.clamp(N,8,O)

A.Position=UDim2.new(0,N,1,6)

an(A,0.12,{
ImageTransparency=0.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

an(A.Outline,0.12,{
ImageTransparency=0.8,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

local function UpdateTopbarLayout()
local C=at.WindUI.UIScale
local F=z.Right.UIListLayout.AbsoluteContentSize.X/C
local G=z.Left.AbsoluteSize.X/C

if au.Topbar.ButtonsType=="Mac"then
local H=z.MacButtons.UIListLayout.AbsoluteContentSize.X/C
local J=H+8

z.Left.Position=UDim2.new(0,J,0,0)
G=G+J
else
z.Left.Position=UDim2.new(0,0,0,0)
end

z.Center.Position=UDim2.new(
0,
G+(au.UIPadding/C),
0.5,
0
)

z.Center.Size=UDim2.new(
1,
-G-F-((au.UIPadding*2)/C),
1,
0
)
end

al.AddSignal(z.Left:GetPropertyChangedSignal"AbsoluteSize",UpdateTopbarLayout)
al.AddSignal(z.Right.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",UpdateTopbarLayout)

if au.Topbar.ButtonsType=="Mac"then
al.AddSignal(z.MacButtons.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",UpdateTopbarLayout)
end

task.defer(UpdateTopbarLayout)

function au.CreateTopbarButton(C,F,G,H,J,L,M,N,O,P)
local Q=M or Color3.fromHex"#F4695F"

local R=au.Topbar.ButtonsType=="Mac"
local S=R and O==true
local T=R and not S

local U=(au.Topbar.ButtonsType=="Default")or T

local V=al.Image(
G,
G,
0,
au.Folder,
"WindowTopbarIcon",
U,
L,
"WindowTopbarButtonIcon"
)

if T then
local W=N or 18

V.Size=UDim2.new(0,W,0,W)
V.AnchorPoint=Vector2.new(0.5,0.5)
V.Position=UDim2.new(0.5,0,0.5,0)
V.ImageLabel.ImageTransparency=0.22
V.ImageLabel.ImageColor3=Q==Color3.fromHex"#F4695F"
and Color3.fromRGB(235,235,235)
or Q

local X=am("TextButton",{
Size=UDim2.new(0,28,0,28),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
ZIndex=9999,
},{
V,
am("UIScale",{
Scale=1,
}),
})

local Y=am("Frame",{
Size=UDim2.new(0,28,0,28),
BackgroundTransparency=1,
Parent=z.Right,
LayoutOrder=J or 999,
},{
X,
})

au.TopBarButtons[100-(J or 999)]={
Name=F,
Object=Y,
}

al.AddSignal(X.MouseButton1Click,function()
if H then
H()
end
end)

al.AddSignal(X.MouseEnter,function()
ShowHoverHint(Y,P or F or"")
an(X.UIScale,0.12,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

an(V.ImageLabel,0.12,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

al.AddSignal(X.MouseLeave,function()
HideHoverHint()
an(X.UIScale,0.12,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

an(V.ImageLabel,0.12,{
ImageTransparency=0.22,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

al.AddSignal(X.MouseButton1Down,function()
an(X.UIScale,0.08,{
Scale=0.92,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

al.AddSignal(X.InputEnded,function()
an(X.UIScale,0.12,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

return Y
end

V.Size=au.Topbar.ButtonsType=="Default"
and UDim2.new(0,N or au.TopBarButtonIconSize,0,N or au.TopBarButtonIconSize)
or UDim2.new(0,0,0,0)
V.AnchorPoint=Vector2.new(0.5,0.5)
V.Position=UDim2.new(0.5,0,0.5,0)
V.ImageLabel.ImageTransparency=au.Topbar.ButtonsType=="Default"and 0 or 1

if S then
V.ImageLabel.ImageColor3=al.GetTextColorForHSB(Q)
end

local W=al.NewRoundFrame(
au.Topbar.ButtonsType=="Default"and au.UICorner-(au.UIPadding/2)or 999,
"Squircle",
{
Size=au.Topbar.ButtonsType=="Default"
and UDim2.new(0,au.Topbar.Height-16,0,au.Topbar.Height-16)
or UDim2.new(0,14,0,14),
LayoutOrder=J or 999,
ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=S and Q or nil,
ThemeTag=au.Topbar.ButtonsType=="Default"and{
ImageColor3="Text",
}or nil,
ImageTransparency=au.Topbar.ButtonsType=="Default"and 1 or 0,
},
{
al.NewRoundFrame(
au.Topbar.ButtonsType=="Default"and au.UICorner-(au.UIPadding/2)or 999,
"Glass-1",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=au.Topbar.ButtonsType=="Default"and 1 or 0.5,
Name="Outline",
}
),
V,
am("UIScale",{
Scale=1,
}),
},
true
)

local X=z.Right
if S then
X=z.MacButtons
end

local Y=am("Frame",{
Size=au.Topbar.ButtonsType~="Default"and UDim2.new(0,24,0,24)
or UDim2.new(0,au.Topbar.Height-16,0,au.Topbar.Height-16),
BackgroundTransparency=1,
Parent=X,
LayoutOrder=J or 999,
},{
W,
})

au.TopBarButtons[100-(J or 999)]={
Name=F,
Object=Y,
}

al.AddSignal(W.MouseButton1Click,function()
if H then
H()
end
end)

al.AddSignal(W.MouseEnter,function()
if au.Topbar.ButtonsType=="Default"then
an(W,0.15,{ImageTransparency=0.93}):Play()
an(W.Outline,0.15,{ImageTransparency=0.75}):Play()
else
an(
V.ImageLabel,
0.1,
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

an(
V,
0.1,
{
Size=UDim2.new(
0,
N or au.TopBarButtonIconSize,
0,
N or au.TopBarButtonIconSize
),
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

al.AddSignal(W.MouseButton1Down,function()
an(W.UIScale,0.2,{Scale=0.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

al.AddSignal(W.MouseLeave,function()
if au.Topbar.ButtonsType=="Default"then
an(W,0.1,{ImageTransparency=1}):Play()
an(W.Outline,0.1,{ImageTransparency=1}):Play()
else
an(
V.ImageLabel,
0.1,
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

an(
V,
0.1,
{Size=UDim2.new(0,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

al.AddSignal(W.InputEnded,function()
an(W.UIScale,0.2,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end)

return Y
end

function au.Topbar.Button(C,F)
return au:CreateTopbarButton(
F.Name,
F.Icon,
F.Callback,
F.LayoutOrder or 0,
F.IconThemed,
F.Color,
F.IconSize,
false,
F.Title
)
end

local C=al.Drag(
au.UIElements.Main,
{au.UIElements.Main.Main.Topbar,l.Frame},
function(C,F)
if not au.Closed then
if C and F==l.Frame then
an(l,0.1,{ImageTransparency=0.35}):Play()
else
an(l,0.2,{ImageTransparency=0.8}):Play()
end
au.Position=au.UIElements.Main.Position
au.Dragging=C
end
end
)

if not f and au.Background and typeof(au.Background)=="table"then
local F=am"UIGradient"
for G,H in next,au.Background do
F[G]=H
end

au.UIElements.BackgroundGradient=al.NewRoundFrame(au.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=au.UIElements.Main.Background,
ImageTransparency=au.Transparent and at.WindUI.TransparencyValue or 0,
},{
F,
})
end

au.OpenButtonMain=a.load'z'.New(au)

task.spawn(function()
if au.Icon then
local F=am("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=au.UIElements.Main.Main.Topbar.Left,
})

p=al.Image(
au.Icon,
au.Title,
au.IconRadius,
au.Folder,
"Window",
true,
au.IconThemed,
"WindowTopbarIcon"
)
p.Parent=F
p.Size=UDim2.new(0,au.IconSize,0,au.IconSize)
p.Position=UDim2.new(0.5,0,0.5,0)
p.AnchorPoint=Vector2.new(0.5,0.5)

au.OpenButtonMain:SetIcon(au.Icon)
else
au.OpenButtonMain:SetIcon(au.Icon)
end
end)

function au.SetToggleKey(F,G)
au.ToggleKey=G
end

function au.SetTitle(F,G)
au.Title=G
if au.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function au.SetSubTitle(F,G)
au.SubTitle=G
if au.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function au.SetTitleMessages(F,G)
au.TitleMessages=G
if au.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function au.SetTitleAnim(F,G)
au.TitleAnim=G
if au.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function au.SetTitleStyle(F,G,H,J)
if G then
au.TitleFont=G
end
if H then
au.TitleFontWeight=H
end
if J then
au.TitleTextSize=J
end

ApplyWindowTitleFont()

if au.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function au.SetAuthor(F,G)
au.Author=G
if not m then
m=createAuthor(au.Author)
end
m.Text=G
end

function au.SetSize(F,G)
if typeof(G)=="UDim2"then
au.Size=G
an(au.UIElements.Main,0.08,{Size=G},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

function au.SetBackgroundImage(F,G)
au.UIElements.Main.Background.ImageLabel.Image=G
end

function au.SetBackgroundImageTransparency(F,G)
if g and g:IsA"ImageLabel"then
g.ImageTransparency=math.floor(G*10+0.5)/10
end
au.BackgroundImageTransparency=math.floor(G*10+0.5)/10
end

function au.SetBackgroundTransparency(F,G)
local H=math.floor(tonumber(G)*10+0.5)/10
at.WindUI.TransparencyValue=H
au:ToggleTransparency(H>0)
end

local F
local G

au:CreateTopbarButton(
"Fullscreen",
au.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
au:ToggleFullscreen()
end,
(au.Topbar.ButtonsType=="Default"and 998 or 999),
true,
Color3.fromHex"#60C762",
au.Topbar.ButtonsType=="Mac"and 9 or nil,
au.Topbar.ButtonsType=="Mac"
)

function au.ToggleFullscreen(H)
local J=au.IsFullscreen
C:Set(J)

if not J then
F=au.UIElements.Main.Position
G=au.UIElements.Main.Size
au.CanResize=false
else
if au.Resizable then
au.CanResize=true
end
end

an(
au.UIElements.Main,
0.45,
{Size=J and G or UDim2.new(1,-20,1,-72)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

an(
au.UIElements.Main,
0.45,
{Position=J and F or UDim2.new(0.5,0,0.5,26)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

au.IsFullscreen=not J
end

au:CreateTopbarButton(
"Minimize",
"minus",
function()
au:Close()
end,
(au.Topbar.ButtonsType=="Default"and 997 or 998),
nil,
Color3.fromHex"#F4C948",
nil,
au.Topbar.ButtonsType=="Mac"
)

function au.OnOpen(H,J)
au.OnOpenCallback=J
end

function au.OnClose(H,J)
au.OnCloseCallback=J
end

function au.OnDestroy(H,J)
au.OnDestroyCallback=J
end

if at.WindUI.UseAcrylic then
au.AcrylicPaint.AddParent(au.UIElements.Main)
end

function au.SetIconSize(H,J)
local L
if typeof(J)=="number"then
L=UDim2.new(0,J,0,J)
au.IconSize=J
elseif typeof(J)=="UDim2"then
L=J
au.IconSize=J.X.Offset
end

if p then
p.Size=L
end
end

function au.Open(H)
task.spawn(function()
if au.OnOpenCallback then
task.spawn(function()
al.SafeCallback(au.OnOpenCallback)
end)
end

task.wait(0.06)
au.Closed=false

an(au.UIElements.Main.Background,0.2,{
ImageTransparency=au.Transparent and at.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if au.UIElements.BackgroundGradient then
an(au.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

an(au.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if g then
if g:IsA"VideoFrame"then
g.Visible=true
else
an(g,0.2,{
ImageTransparency=au.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if au.OpenButtonMain and au.IsOpenButtonEnabled then
au.OpenButtonMain:Visible(false)
end

an(
aA,
0.25,
{ImageTransparency=au.ShadowTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if x then
an(x,0.25,{Transparency=0.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(0.3)
an(
l,
0.45,
{Size=UDim2.new(0,au.DragFrameSize,0,4),ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
C:Set(true)
task.wait(0.45)
if au.Resizable then
an(
ax.ImageLabel,
0.45,
{ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
au.CanResize=true
end
end)

au.CanDropdown=true
au.UIElements.Main.Visible=true

task.spawn(function()
task.wait(0.05)
au.UIElements.Main:WaitForChild"Main".Visible=true
RunWindowTitleAnimation()
at.WindUI:ToggleAcrylic(true)
end)
end)
end

function au.Close(H)
local J={}

if au.OnCloseCallback then
task.spawn(function()
al.SafeCallback(au.OnCloseCallback)
end)
end

at.WindUI:ToggleAcrylic(false)
au.UIElements.Main:WaitForChild"Main".Visible=false
StopWindowTitleAnimation()

au.CanDropdown=false
au.Closed=true

an(au.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()

if au.UIElements.BackgroundGradient then
an(au.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

an(au.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()

if g then
if g:IsA"VideoFrame"then
g.Visible=false
else
an(g,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

an(aA,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if x then
an(x,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

an(
l,
0.3,
{Size=UDim2.new(0,0,0,4),ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.InOut
):Play()

an(
ax.ImageLabel,
0.3,
{ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()

C:Set(false)
au.CanResize=false

task.spawn(function()
task.wait(0.4)
au.UIElements.Main.Visible=false

if au.OpenButtonMain and not au.Destroyed and not au.IsPC and au.IsOpenButtonEnabled then
au.OpenButtonMain:Visible(true)
end
end)

function J.Destroy(L)
task.spawn(function()
if au.OnDestroyCallback then
task.spawn(function()
al.SafeCallback(au.OnDestroyCallback)
end)
end

if au.AcrylicPaint and au.AcrylicPaint.Model then
au.AcrylicPaint.Model:Destroy()
end

au.Destroyed=true
task.wait(0.4)

at.WindUI.ScreenGui:Destroy()
at.WindUI.NotificationGui:Destroy()
at.WindUI.DropdownGui:Destroy()
at.WindUI.TooltipGui:Destroy()

al.DisconnectAll()
return
end)
end

return J
end

function au.Destroy(H)
return au:Close():Destroy()
end

function au.Toggle(H)
if au.Closed then
au:Open()
else
au:Close()
end
end

function au.ToggleTransparency(H,J)
au.Transparent=J
at.WindUI.Transparent=J
au.UIElements.Main.Background.ImageTransparency=J and at.WindUI.TransparencyValue or 0
end

function au.LockAll(H)
for J,L in next,au.AllElements do
if L.Lock then
L:Lock()
end
end
end

function au.UnlockAll(H)
for J,L in next,au.AllElements do
if L.Unlock then
L:Unlock()
end
end
end

function au.GetLocked(H)
local J={}
for L,M in next,au.AllElements do
if M.Locked then
table.insert(J,M)
end
end
return J
end

function au.GetUnlocked(H)
local J={}
for L,M in next,au.AllElements do
if M.Locked==false then
table.insert(J,M)
end
end
return J
end

function au.GetUIScale(H)
return at.WindUI.UIScale
end

function au.SetUIScale(H,J)
at.WindUI.UIScale=J
an(at.WindUI.UIScaleObj,0.2,{Scale=J},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return au
end

function au.SetToTheCenter(H)
an(
au.UIElements.Main,
0.45,
{Position=UDim2.new(0.5,0,0.5,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
return au
end

function au.SetCurrentConfig(H,J)
au.CurrentConfig=J
end

do
local H=40
local J=aj.ViewportSize
local L=au.UIElements.Main.AbsoluteSize

if not au.IsFullscreen and au.AutoScale then
local M=J.X-(H*2)
local N=J.Y-(H*2)

local O=M/L.X
local P=N/L.Y

local Q=math.min(O,P)
local R=math.clamp(Q,0.3,1.0)

local S=au:GetUIScale()or 1
local T=0.05

if math.abs(R-S)>T then
au:SetUIScale(R)
end
end
end

if au.OpenButtonMain and au.OpenButtonMain.Button then
al.AddSignal(au.OpenButtonMain.Button.TextButton.MouseButton1Click,function()
au:Open()
end)
end

al.AddSignal(ae.InputBegan,function(H,J)
if J then
return
end

if au.ToggleKey and H.KeyCode==au.ToggleKey then
au:Toggle()
end
end)

task.spawn(function()
au:Open()
end)

function au.EditOpenButton(H,J)
return au.OpenButtonMain:Edit(J)
end

if au.OpenButton and typeof(au.OpenButton)=="table"then
au:EditOpenButton(au.OpenButton)
end

local H=a.load'W'
local J=a.load'X'
local L=H.Init(au,at.WindUI,at.WindUI.TooltipGui)

L:OnChange(function(M)
au.CurrentTab=M
end)

au.TabModule=L

function au.Tab(M,N)
N.Parent=au.UIElements.SideBar.Frame
return L.New(N,at.WindUI.UIScale)
end

function au.SelectTab(M,N)
L:SelectTab(N)
end

function au.Section(M,N)
return J.New(
N,
au.UIElements.SideBar.Frame,
au.Folder,
at.WindUI.UIScale,
au
)
end

function au.IsResizable(M,N)
au.Resizable=N
au.CanResize=N
end

function au.SetPanelBackground(M,N)
if typeof(N)=="boolean"then
au.HidePanelBackground=N
au.UIElements.MainBar.Background.Visible=N

if L then
for O,P in next,L.Containers do
P.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,au.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingLeft=UDim.new(0,au.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingRight=UDim.new(0,au.HidePanelBackground and 20 or 10)
P.ScrollingFrame.UIPadding.PaddingBottom=UDim.new(0,au.HidePanelBackground and 20 or 10)
end
end
end
end

function au.Divider(M)
local N=am("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})

local O=am("Frame",{
Parent=au.UIElements.SideBar.Frame,
Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
N,
})

return O
end

local M=a.load'n'.Init(au,at.WindUI,nil)
function au.Dialog(N,O)
local P={
Title=O.Title or"Dialog",
Width=O.Width or 320,
Content=O.Content,
Buttons=O.Buttons or{},
TextPadding=14,
}

local Q=M.Create(false)
Q.UIElements.Main.Size=UDim2.new(0,P.Width,0,0)

local R=am("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=Q.UIElements.Main,
},{
am("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,Q.UIPadding),
}),
})

local S=am("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=R,
},{
am("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,Q.UIPadding),
VerticalAlignment="Center",
}),
am("UIPadding",{
PaddingTop=UDim.new(0,P.TextPadding/2),
PaddingLeft=UDim.new(0,P.TextPadding/2),
PaddingRight=UDim.new(0,P.TextPadding/2),
}),
})

local T
if O.Icon then
T=al.Image(
O.Icon,
P.Title..":"..O.Icon,
0,
au,
"Dialog",
true,
O.IconThemed
)
T.Size=UDim2.new(0,22,0,22)
T.Parent=S
end

Q.UIElements.UIListLayout=am("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=Q.UIElements.Main,
})

am("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=Q.UIElements.Main,
})

Q.UIElements.Title=am("TextLabel",{
Text=P.Title,
TextSize=20,
FontFace=Font.new(al.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,T and-26-Q.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=S,
})

if P.Content then
am("TextLabel",{
Text=P.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(al.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=R,
},{
am("UIPadding",{
PaddingLeft=UDim.new(0,P.TextPadding/2),
PaddingRight=UDim.new(0,P.TextPadding/2),
PaddingBottom=UDim.new(0,P.TextPadding/2),
}),
})
end

local U=am("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local V=am("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=Q.UIElements.Main,
LayoutOrder=4,
},{
U,
})

local W={}

for X,Y in next,P.Buttons do
local _=
ap(Y.Title,Y.Icon,Y.Callback,Y.Variant,V,Q,true)
table.insert(W,_)
end

local function CheckButtonsOverflow()
U.FillDirection=Enum.FillDirection.Horizontal
U.HorizontalAlignment=Enum.HorizontalAlignment.Right
U.VerticalAlignment=Enum.VerticalAlignment.Center
V.AutomaticSize=Enum.AutomaticSize.None

for X,Y in ipairs(W)do
Y.Size=UDim2.new(0,0,1,0)
Y.AutomaticSize=Enum.AutomaticSize.X
end

task.wait()

local X=U.AbsoluteContentSize.X/at.WindUI.UIScale
local Y=V.AbsoluteSize.X/at.WindUI.UIScale

if X>Y then
U.FillDirection=Enum.FillDirection.Vertical
U.HorizontalAlignment=Enum.HorizontalAlignment.Right
U.VerticalAlignment=Enum.VerticalAlignment.Bottom
V.AutomaticSize=Enum.AutomaticSize.Y

for _,aC in ipairs(W)do
aC.Size=UDim2.new(1,0,0,40)
aC.AutomaticSize=Enum.AutomaticSize.None
end
else
local aC=Y-X
if aC>0 then
local _
local aD=math.huge

for aE,aF in ipairs(W)do
local aG=aF.AbsoluteSize.X/at.WindUI.UIScale
if aG<aD then
aD=aG
_=aF
end
end

if _ then
_.Size=UDim2.new(0,aD+aC,1,0)
_.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

al.AddSignal(Q.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

task.wait()
Q:Open()

return Q
end

local aC=false

au:CreateTopbarButton(
"Close",
"x",
function()
if not aC then
if not au.IgnoreAlerts then
aC=true
au:SetToTheCenter()
au:Dialog{
Title="Close Window",
Content="Do you want to close this window? You will not be able to open it again.",
Buttons={
{
Title="Cancel",
Callback=function()
aC=false
end,
Variant="Secondary",
},
{
Title="Close Window",
Callback=function()
aC=false
au:Destroy()
end,
Variant="Primary",
},
},
}
else
au:Destroy()
end
end
end,
(au.Topbar.ButtonsType=="Default"and 999 or 997),
nil,
Color3.fromHex"#F4695F",
nil,
au.Topbar.ButtonsType=="Mac"
)

function au.Tag(aD,aE)
if au.UIElements.Main.Main.Topbar.Center.Visible==false then
au.UIElements.Main.Main.Topbar.Center.Visible=true
end
return ar:New(aE,au.UIElements.Main.Main.Topbar.Center)
end

local aD
local aE
local aF

local function startResizing(aG)
if au.CanResize then
aD=true
ay.Active=true
aE=au.UIElements.Main.Size
aF=aG.Position
an(ax.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

al.AddSignal(aG.Changed,function()
if aG.UserInputState==Enum.UserInputState.End then
aD=false
ay.Active=false
an(ax.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

al.AddSignal(ax.InputBegan,function(aG)
if aG.UserInputType==Enum.UserInputType.MouseButton1 or aG.UserInputType==Enum.UserInputType.Touch then
if au.CanResize then
startResizing(aG)
end
end
end)

al.AddSignal(ae.InputChanged,function(aG)
if aG.UserInputType==Enum.UserInputType.MouseMovement or aG.UserInputType==Enum.UserInputType.Touch then
if aD and au.CanResize then
local N=aG.Position-aF
local O=UDim2.new(0,aE.X.Offset+N.X*2,0,aE.Y.Offset+N.Y*2)

O=UDim2.new(
O.X.Scale,
math.clamp(O.X.Offset,au.MinSize.X,au.MaxSize.X),
O.Y.Scale,
math.clamp(O.Y.Offset,au.MinSize.Y,au.MaxSize.Y)
)

an(au.UIElements.Main,0.08,{
Size=O,
},Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()

au.Size=O
end
end
end)

al.AddSignal(ax.MouseEnter,function()
if not aD then
an(ax.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)

al.AddSignal(ax.MouseLeave,function()
if not aD then
an(ax.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)

local aG=0
local N=0.4
local O
local P=0

local function onDoubleClick()
au:SetToTheCenter()
end

al.AddSignal(l.Frame.MouseButton1Up,function()
local Q=tick()
local R=au.Position

P+=1

if P==1 then
aG=Q
O=R

task.spawn(function()
task.wait(N)
if P==1 then
P=0
O=nil
end
end)
elseif P==2 then
if Q-aG<=N and R==O then
onDoubleClick()
end

P=0
O=nil
aG=0
else
P=1
aG=Q
O=R
end
end)

if not au.HideSearchBar then
local Q=a.load'Z'
local R=false

local S=ao("Search","search",au.UIElements.SideBarContainer,true)
S.Size=UDim2.new(1,-au.UIPadding/2,0,39)
S.Position=UDim2.new(0,au.UIPadding/2,0,0)

al.AddSignal(S.MouseButton1Click,function()
if R then
return
end

Q.new(au.TabModule,au.UIElements.Main,function()
R=false
if au.Resizable then
au.CanResize=true
end

an(az,0.1,{ImageTransparency=1}):Play()
az.Active=false
end)

an(az,0.1,{ImageTransparency=0.65}):Play()
az.Active=true

R=true
au.CanResize=false
end)
end

function au.DisableTopbarButtons(Q,R)
for S,T in next,R do
for U,V in next,au.TopBarButtons do
if V.Name==T then
V.Object.Visible=false
end
end
end
end

return au
end end end

local aa={
Window=nil,
Theme=nil,
Creator=a.load'c',
LocalizationModule=a.load'd',
NotificationModule=a.load'e',
Themes=nil,
Transparent=false,

TransparencyValue=0.15,

UIScale=1,

ConfigManager=nil,
Version="0.0.0",

Services=a.load'j',

OnThemeChangeFunction=nil,

cloneref=nil,
UIScaleObj=nil,
}

local ae=(cloneref or clonereference or function(ae)
return ae
end)

aa.cloneref=ae

local af=ae(game:GetService"HttpService")
local ah=ae(game:GetService"Players")
local aj=ae(game:GetService"CoreGui")
local ak=ae(game:GetService"RunService")

local al=ah.LocalPlayer or nil

local am=af:JSONDecode(a.load'k')
if am then
aa.Version=am.version
end

local an=a.load'o'

local ao=aa.Creator

local ap=ao.New




local aq=a.load's'

local ar=protectgui or(syn and syn.protect_gui)or function()end

local as=gethui and gethui()or(aj or al:WaitForChild"PlayerGui")

local at=ap("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=at

aa.ScreenGui=ap("ScreenGui",{
Name="WindUI",
Parent=as,
IgnoreGuiInset=true,
ScreenInsets="None",
},{

ap("Folder",{
Name="Window",
}),






ap("Folder",{
Name="KeySystem",
}),
ap("Folder",{
Name="Popups",
}),
ap("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=ap("ScreenGui",{
Name="WindUI/Notifications",
Parent=as,
IgnoreGuiInset=true,
})
aa.DropdownGui=ap("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=as,
IgnoreGuiInset=true,
})
aa.TooltipGui=ap("ScreenGui",{
Name="WindUI/Tooltips",
Parent=as,
IgnoreGuiInset=true,
})
ar(aa.ScreenGui)
ar(aa.NotificationGui)
ar(aa.DropdownGui)
ar(aa.TooltipGui)

ao.Init(aa)

function aa.SetParent(au,av)
if aa.ScreenGui then
aa.ScreenGui.Parent=av
end
if aa.NotificationGui then
aa.NotificationGui.Parent=av
end
if aa.DropdownGui then
aa.DropdownGui.Parent=av
end
if aa.TooltipGui then
aa.TooltipGui.Parent=av
end
end
math.clamp(aa.TransparencyValue,0,1)

local au=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(av,aw)
aw.Holder=au.Frame
aw.Window=aa.Window

return aa.NotificationModule.New(aw)
end

function aa.SetNotificationLower(av,aw)
au.SetLower(aw)
end

function aa.SetFont(av,aw)
ao.UpdateFont(aw)
end

function aa.OnThemeChange(av,aw)
aa.OnThemeChangeFunction=aw
end

function aa.AddTheme(av,aw)
aa.Themes[aw.Name]=aw
return aw
end

function aa.SetTheme(av,aw)
if aa.Themes[aw]then
aa.Theme=aa.Themes[aw]
ao.SetTheme(aa.Themes[aw])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(aw)
end

return aa.Themes[aw]
end
return nil
end

function aa.GetThemes(av)
return aa.Themes
end
function aa.GetCurrentTheme(av)
return aa.Theme.Name
end
function aa.GetTransparency(av)
return aa.Transparent or false
end
function aa.GetWindowSize(av)
return aa.Window.UIElements.Main.Size
end
function aa.Localization(av,aw)
return aa.LocalizationModule:New(aw,ao)
end

function aa.SetLanguage(av,aw)
if ao.Localization then
return ao.SetLanguage(aw)
end
return false
end

function aa.ToggleAcrylic(av,aw)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=aw
aa.Window.AcrylicPaint.Model.Transparency=aw and 0.98 or 1
if aw then
aq.Enable()
else
aq.Disable()
end
end
end

function aa.Gradient(av,aw,ax)
local ay={}
local az={}

for aA,aB in next,aw do
local aC=tonumber(aA)
if aC then
aC=math.clamp(aC/100,0,1)

local aD=aB.Color
if typeof(aD)=="string"and string.sub(aD,1,1)=="#"then
aD=Color3.fromHex(aD)
end

local aE=aB.Transparency or 0

table.insert(ay,ColorSequenceKeypoint.new(aC,aD))
table.insert(az,NumberSequenceKeypoint.new(aC,aE))
end
end

table.sort(ay,function(aA,aB)
return aA.Time<aB.Time
end)
table.sort(az,function(aA,aB)
return aA.Time<aB.Time
end)

if#ay<2 then
table.insert(ay,ColorSequenceKeypoint.new(1,ay[1].Value))
table.insert(az,NumberSequenceKeypoint.new(1,az[1].Value))
end

local aA={
Color=ColorSequence.new(ay),
Transparency=NumberSequence.new(az),
}

if ax then
for aB,aC in pairs(ax)do
aA[aB]=aC
end
end

return aA
end

function aa.Popup(av,aw)
aw.WindUI=aa
return a.load't'.new(aw)
end

aa.Themes=a.load'u'(aa)

ao.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(ao.Language)

function aa.CreateWindow(av,aw)
local ax=a.load'_'

if not ak:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
if aw.Folder then
makefolder(aw.Folder)
else
makefolder(aw.Title)
end
end

aw.WindUI=aa
aw.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local ay=true

local az=aa.Themes[aw.Theme or"Dark"]


ao.SetTheme(az)

local aA=gethwid or function()
return ah.LocalPlayer.UserId
end

local aB=aA()

if aw.KeySystem then
ay=false

local function loadKeysystem()
an.new(aw,aB,function(aC)
ay=aC
end)
end

local aC=(aw.Folder or"Temp").."/"..aB..".key"

if aw.KeySystem.KeyValidator then
if aw.KeySystem.SaveKey and isfile(aC)then
local aD=readfile(aC)
local aE=aw.KeySystem.KeyValidator(aD)

if aE then
ay=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not aw.KeySystem.API then
if aw.KeySystem.SaveKey and isfile(aC)then
local aD=readfile(aC)
local aE=(type(aw.KeySystem.Key)=="table")and table.find(aw.KeySystem.Key,aD)
or tostring(aw.KeySystem.Key)==tostring(aD)

if aE then
ay=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(aC)then
local aD=readfile(aC)
local aE=false

for aF,aG in next,aw.KeySystem.API do
local b=aa.Services[aG.Type]
if b then
local d={}
for f,g in next,b.Args do
table.insert(d,aG[g])
end

local f=b.New(table.unpack(d))
local g=f.Verify(aD)
if g then
aE=true
break
end
end
end

ay=aE
if not aE then
loadKeysystem()
end
else
loadKeysystem()
end
end

repeat
task.wait()
until ay
end

local aC=ax(aw)

aa.Transparent=aw.Transparent
aa.Window=aC

if aw.Acrylic then
aq.init()
end













return aC
end

return aa