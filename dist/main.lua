--[[
     _      ___         ____  ______
    | | /| / (_)__  ___/ / / / /  _/
    | |/ |/ / / _ \/ _  / /_/ // /  
    |__/|__/_/_//_/\_,_/\____/___/
    
    v1.6.64  |  2026-03-19  |  Roblox UI Library for scripts
    
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

local ae=(cloneref or clonereference or function(ae)
return ae
end)

ae(game:GetService"UserInputService")

local function Color3ToHSB(af)
local ag,ah,ai=af.R,af.G,af.B
local aj=math.max(ag,ah,ai)
local ak=math.min(ag,ah,ai)
local al=aj-ak

local am=0
if al~=0 then
if aj==ag then
am=(ah-ai)/al%6
elseif aj==ah then
am=(ai-ag)/al+2
else
am=(ag-ah)/al+4
end
am=am*60
else
am=0
end

local an=(aj==0)and 0 or(al/aj)
local ao=aj

return{
h=math.floor(am+0.5),
s=an,
b=ao,
}
end

local function GetPerceivedBrightness(af)
local ag=af.R
local ah=af.G
local ai=af.B
return 0.299*ag+0.587*ah+0.114*ai
end

local function GetTextColorForHSB(af)
local ag=Color3ToHSB(af)local
ah, ai, aj=ag.h, ag.s, ag.b
if GetPerceivedBrightness(af)>0.5 then
return Color3.fromHSV(ah/360,0,0.05)
else
return Color3.fromHSV(ah/360,0,0.98)
end
end

local function getElementPosition(af,ag)
if type(ag)~="number"or ag~=math.floor(ag)then
return nil,1
end






local ah=#af


if ah==0 or ag<1 or ag>ah then
return nil,2
end

local function isDelimiter(ai)
if ai==nil then
return true
end
local aj=ai.__type
return aj=="Divider"or aj=="Space"or aj=="Section"or aj=="Code"
end

if isDelimiter(af[ag])then
return nil,3
end

local function calculate(ai,aj)
if aj==1 then
return"Squircle"
end
if ai==1 then
return"Squircle-TL-TR"
end
if ai==aj then
return"Squircle-BL-BR"
end
return"Square"
end

local ai=1
local aj=0

for ak=1,ah do
local al=af[ak]
if isDelimiter(al)then
if ag>=ai and ag<=ak-1 then
local am=ag-ai+1
return calculate(am,aj)
end
ai=ak+1
aj=0
else
aj=aj+1
end
end

if ag>=ai and ag<=ah then
local ak=ag-ai+1
return calculate(ak,aj)
end

return nil,4
end

return function(af)
local ag={
Title=af.Title,
Desc=af.Desc or nil,
Hover=af.Hover,
Thumbnail=af.Thumbnail,
ThumbnailSize=af.ThumbnailSize or 80,
Image=af.Image,
IconThemed=af.IconThemed or false,
ImageSize=af.ImageSize or 30,
Color=af.Color,
Scalable=af.Scalable,
Parent=af.Parent,
Justify=af.Justify or"Between",
UIPadding=af.Window.ElementConfig.UIPadding,
UICorner=af.Window.ElementConfig.UICorner,
Size=af.Size or"Default",
UIElements={},

Index=af.Index,
}

local ah=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0
local ai=ag.Size=="Small"and-4 or ag.Size=="Large"and 4 or 0

local aj=ag.ImageSize
local ak=ag.ThumbnailSize
local al=true


local am=0

local an
local ao
if ag.Thumbnail then
an=aa.Image(
ag.Thumbnail,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
end
if ag.Image then
ao=aa.Image(
ag.Image,
ag.Title,
af.Window.NewElements and ag.UICorner-11 or(ag.UICorner-4),
af.Window.Folder,
"Image",
ag.IconThemed,
not ag.Color and true or false,
"ElementIcon"
)
if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Size=UDim2.new(0,aj,0,aj)

am=aj
end

local function CreateText(ap,aq)
local ar=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)

return ab("TextLabel",{
BackgroundTransparency=1,
Text=ap or"",
TextSize=aq=="Desc"and 15 or 17,
TextXAlignment="Left",
ThemeTag={
TextColor3=not ag.Color and("Element"..aq)or nil,
},
TextColor3=ag.Color and ar or nil,
TextTransparency=aq=="Desc"and 0.3 or 0,
TextWrapped=true,
Size=UDim2.new(ag.Justify=="Between"and 1 or 0,0,0,0),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
FontFace=Font.new(aa.Font,aq=="Desc"and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
})
end

local ap=CreateText(ag.Title,"Title")
local aq=CreateText(ag.Desc,"Desc")
if not ag.Title or ag.Title==""then
aq.Visible=false
end
if not ag.Desc or ag.Desc==""then
aq.Visible=false
end

ag.UIElements.Title=ap
ag.UIElements.Desc=aq

ag.UIElements.Container=ab("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment=ag.Justify=="Between"and"Left"or"Center",
}),
an,
ab("Frame",{
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and-af.TextOffset or 0,
0,
0
),
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
BackgroundTransparency=1,
Name="TitleFrame",
},{
ab("UIListLayout",{
Padding=UDim.new(0,ag.UIPadding),
FillDirection="Horizontal",
VerticalAlignment=af.Window.NewElements and(ag.Justify=="Between"and"Top"or"Center")
or"Center",
HorizontalAlignment=ag.Justify~="Between"and ag.Justify or"Center",
}),
ao,
ab("Frame",{
BackgroundTransparency=1,
AutomaticSize=ag.Justify=="Between"and"Y"or"XY",
Size=UDim2.new(
ag.Justify=="Between"and 1 or 0,
ag.Justify=="Between"and(ao and-am-ag.UIPadding or-am)
or 0,
1,
0
),
Name="TitleFrame",
},{
ab("UIPadding",{
PaddingTop=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ai),
PaddingLeft=UDim.new(0,(af.Window.NewElements and ag.UIPadding/2 or 0)+ah),
PaddingRight=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ah
),
PaddingBottom=UDim.new(
0,
(af.Window.NewElements and ag.UIPadding/2 or 0)+ai
),
}),
ab("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
ap,
aq,
}),
}),
})





local ar=aa.Image("lock","lock",0,af.Window.Folder,"Lock",false)
ar.Size=UDim2.new(0,20,0,20)
ar.ImageLabel.ImageColor3=Color3.new(1,1,1)
ar.ImageLabel.ImageTransparency=0.4

local as=ab("TextLabel",{
Text="Locked",
TextSize=18,
FontFace=Font.new(aa.Font,Enum.FontWeight.Medium),
AutomaticSize="XY",
BackgroundTransparency=1,
TextColor3=Color3.new(1,1,1),
TextTransparency=0.05,
})

local at=ab("Frame",{
Size=UDim2.new(1,ag.UIPadding*2,1,ag.UIPadding*2),
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ZIndex=9999999,
})

local au,av=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.25,
ImageColor3=Color3.new(0,0,0),
Visible=false,
Active=false,
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
ar,
as,
},nil,true)

local aw,ax=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local ay,az=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
},{
ab("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Center",
Padding=UDim.new(0,8),
}),
},nil,true)

local aA,aB=ac(ag.UICorner,"Squircle-Outline",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
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

local b,d=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
Active=false,
ThemeTag={
ImageColor3="Text",
},
Parent=at,
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

local f,g=ac(ag.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ImageTransparency=ag.Color and 0.05 or 0.93,



Parent=af.Parent,
ThemeTag={
ImageColor3=not ag.Color and"ElementBackground"or nil,
},
ImageColor3=ag.Color and(typeof(ag.Color)=="string"and Color3.fromHex(
aa.Colors[ag.Color]
)or typeof(ag.Color)=="Color3"and ag.Color)or nil,
},{
ag.UIElements.Container,
at,
ab("UIPadding",{
PaddingTop=UDim.new(0,ag.UIPadding),
PaddingLeft=UDim.new(0,ag.UIPadding),
PaddingRight=UDim.new(0,ag.UIPadding),
PaddingBottom=UDim.new(0,ag.UIPadding),
}),
},true,true)

ag.UIElements.Main=f
ag.UIElements.Locked=au

if ag.Hover then
aa.AddSignal(f.MouseEnter,function()
if al then
ad(f,0.12,{ImageTransparency=ag.Color and 0.15 or 0.9}):Play()
ad(b,0.12,{ImageTransparency=0.9}):Play()
ad(aA,0.12,{ImageTransparency=0.8}):Play()
aa.AddSignal(f.MouseMoved,function(h,j)
b.HoverGradient.Offset=
Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
aA.HoverGradient.Offset=
Vector2.new(((h-f.AbsolutePosition.X)/f.AbsoluteSize.X)-0.5,0)
end)
end
end)
aa.AddSignal(f.InputEnded,function()
if al then
ad(f,0.12,{ImageTransparency=ag.Color and 0.05 or 0.93}):Play()
ad(b,0.12,{ImageTransparency=1}):Play()
ad(aA,0.12,{ImageTransparency=1}):Play()
end
end)
end

function ag.SetTitle(h,j)
ag.Title=j
ap.Text=j
end

function ag.SetDesc(h,j)
ag.Desc=j
aq.Text=j or""
if not j then
aq.Visible=false
elseif not aq.Visible then
aq.Visible=true
end
end

function ag.Colorize(h,j,l)
if ag.Color then
j[l]=typeof(ag.Color)=="string"
and GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
or typeof(ag.Color)=="Color3"and GetTextColorForHSB(ag.Color)
or nil
end
end

if af.ElementTable then
aa.AddSignal(ap:GetPropertyChangedSignal"Text",function()
if ag.Title~=ap.Text then
ag:SetTitle(ap.Text)
af.ElementTable.Title=ap.Text
end
end)
aa.AddSignal(aq:GetPropertyChangedSignal"Text",function()
if ag.Desc~=aq.Text then
ag:SetDesc(aq.Text)
af.ElementTable.Desc=aq.Text
end
end)
end





function ag.SetThumbnail(h,j,l)
ag.Thumbnail=j
if l then
ag.ThumbnailSize=l
ak=l
end

if an then
if j then
an:Destroy()
an=aa.Image(
j,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
else
an.Visible=false
end
else
if j then
an=aa.Image(
j,
ag.Title,
ag.UICorner-3,
af.Window.Folder,
"Thumbnail",
false,
ag.IconThemed
)
an.Size=UDim2.new(1,0,0,ak)
an.Parent=ag.UIElements.Container
local m=ag.UIElements.Container:FindFirstChild"UIListLayout"
if m then
an.LayoutOrder=-1
end
end
end
end

function ag.SetImage(h,j,l)
ag.Image=j
if l then
ag.ImageSize=l
aj=l
end

if j then
local m=ao.Parent
ao:Destroy()

ao=aa.Image(
j,
j,
ag.UICorner-3,
af.Window.Folder,
"Image",
not ag.Color and true or false
)

if typeof(ag.Color)=="string"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(Color3.fromHex(aa.Colors[ag.Color]))
elseif typeof(ag.Color)=="Color3"and not string.find(ag.Image,"rbxthumb")then
ao.ImageLabel.ImageColor3=GetTextColorForHSB(ag.Color)
end

ao.Visible=true
ao.Parent=m
ao.LayoutOrder=-99

ao.Size=UDim2.new(0,aj,0,aj)
am=ag.ImageSize+ag.UIPadding
else
if ao then
ao.Visible=true
end
am=0
end

ag.UIElements.Container.TitleFrame.TitleFrame.Size=UDim2.new(1,-am,1,0)
end

function ag.Destroy(h)
f:Destroy()
end

function ag.Lock(h,j)
al=false
au.Active=true
au.Visible=true
as.Text=j or"Locked"
end

function ag.Unlock(h)
al=true
au.Active=false
au.Visible=false
end

function ag.Highlight(h)
local j=ab("UIGradient",{
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
Parent=aw,
})

local l=ab("UIGradient",{
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
Parent=ay,
})

aw.ImageTransparency=0.65
ay.ImageTransparency=0.88

ad(j,0.75,{
Offset=Vector2.new(1,0),
}):Play()

ad(l,0.75,{
Offset=Vector2.new(1,0),
}):Play()

task.spawn(function()
task.wait(0.75)
aw.ImageTransparency=1
ay.ImageTransparency=1
j:Destroy()
l:Destroy()
end)
end

function ag.UpdateShape(h)
if af.Window.NewElements then
local j
if af.ParentConfig.ParentType=="Group"then
j="Squircle"
else
j=getElementPosition(h.Elements,ag.Index)
end

if j and f then
g:SetType(j)
av:SetType(j)
az:SetType(j)
ax:SetType(j.."-Outline")
d:SetType(j)
aB:SetType(j.."-Outline")
end
end
end





return ag
end end function a.C()

local aa=a.load'c'
local ab=aa.New

local ac={}

local ad=a.load'l'.New

function ac.New(ae,af)
af.Hover=false
af.TextOffset=0
af.ParentConfig=af
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
Parent=ah.UIElements.Container
},{
ab("UIListLayout",{
Padding=UDim.new(0,10),
FillDirection="Vertical",
})
})


for aj,ak in next,af.Buttons do
local al=ad(ak.Title,ak.Icon,ak.Callback,"White",ai,nil,nil,af.Window.NewElements and 999 or 10)
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
UIElements={}
}

local ag=true

af.ButtonFrame=a.load'B'{
Title=af.Title,
Desc=af.Desc,
Parent=ae.Parent,




Window=ae.Window,
Color=af.Color,
Justify=af.Justify,
TextOffset=20,
Hover=true,
Scalable=true,
Tab=ae.Tab,
Index=ae.Index,
ElementTable=af,
ParentConfig=ae,
Size=ae.Size,
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
af.UIElements.ButtonIcon.Parent=af.Justify=="Between"and af.ButtonFrame.UIElements.Main or af.ButtonFrame.UIElements.Container.TitleFrame
af.UIElements.ButtonIcon.LayoutOrder=af.IconAlign=="Left"and-99999 or 99999
af.UIElements.ButtonIcon.AnchorPoint=Vector2.new(1,0.5)
af.UIElements.ButtonIcon.Position=UDim2.new(1,0,0.5,0)

af.ButtonFrame:Colorize(af.UIElements.ButtonIcon.ImageLabel,"ImageColor3")

function af.Lock(ah)
af.Locked=true
ag=false
return af.ButtonFrame:Lock(af.LockedTitle)
end
function af.Unlock(ah)
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


return aa end function a.F()
local aa=a.load'c'
local ab=aa.New
local ac=aa.Tween

local ad=a.load'E'.New

local ae={}

local function CreateIosSwitch(af,ag,ah)
local ai=ag==true

local aj=ah.Window.NewElements and 72 or 68
local ak=ah.Window.NewElements and 38 or 34
local al=ak-4
local am=al+10
local an=10

local ao=2+(al/2)
local ap=aj-2-(al/2)

local aq=ab("Frame",{
Name="IosSwitch",
Size=UDim2.new(0,aj,0,ak),
BackgroundTransparency=1,
Parent=af,
LayoutOrder=1,
})

local ar=aa.NewRoundFrame(999,"Squircle",{
Name="Track",
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.76,
Parent=aq,
},{
aa.NewRoundFrame(999,"Glass-1",{
Name="Stroke",
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.76,
}),
aa.NewRoundFrame(999,"Squircle",{
Name="OnFill",
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=ai and 0.22 or 1,
},{
aa.NewRoundFrame(999,"Glass-1",{
Name="OnGlow",
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.87,
}),
}),
aa.NewRoundFrame(999,"Squircle",{
Name="OffDot",
Size=UDim2.new(0,an,0,an),
Position=UDim2.new(1,-14,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.fromRGB(236,236,242),
ImageTransparency=ai and 1 or 0.34,
},{
aa.NewRoundFrame(999,"Squircle-Outline",{
Name="OffDotStroke",
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.65,
}),
}),
aa.NewRoundFrame(999,"Squircle",{
Name="KnobGlow",
Size=UDim2.new(0,am,0,am),
Position=UDim2.new(0,ai and ap or ao,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=ai and 0.82 or 1,
}),
aa.NewRoundFrame(999,"Squircle",{
Name="Knob",
Size=UDim2.new(0,al,0,al),
Position=UDim2.new(0,ai and ap or ao,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageColor3=Color3.fromRGB(247,247,249),
ImageTransparency=0,
},{
aa.NewRoundFrame(999,"Glass-1",{
Name="Highlight",
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.42,
}),
}),
ab("TextButton",{
Name="Hitbox",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
ZIndex=10,
}),
})

local as={}

function as.Set(at,au,av,aw)
ai=au==true

local ax=UDim2.new(0,ai and ap or ao,0.5,0)
local ay=ai and 0.22 or 1
local az=ai and 0.82 or 1
local aA=ai and 1 or 0.34

if aw==false then
ar.OnFill.ImageTransparency=ay
ar.KnobGlow.ImageTransparency=az
ar.OffDot.ImageTransparency=aA
ar.Knob.Position=ax
ar.KnobGlow.Position=ax
else
ac(ar.OnFill,0.18,{
ImageTransparency=ay,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ac(ar.KnobGlow,0.18,{
ImageTransparency=az,
Position=ax,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ac(ar.OffDot,0.16,{
ImageTransparency=aA,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ac(ar.Knob,0.18,{
Position=ax,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

function as.Press(at)
ac(ar.Knob,0.12,{
Size=UDim2.new(0,al+2,0,al+2),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

function as.Release(at)
ac(ar.Knob,0.12,{
Size=UDim2.new(0,al,0,al),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

as:Set(ai,nil,false)

return aq,as
end

function ae.New(af,ag)
local ah={
__type="Toggle",
Title=ag.Title or"Toggle",
Desc=ag.Desc or nil,
Locked=ag.Locked or false,
LockedTitle=ag.LockedTitle,
Value=ag.Value,
Icon=ag.Icon or nil,
IconSize=ag.IconSize or 20,
Type=ag.Type or"Toggle",
Callback=ag.Callback or function()end,
UIElements={},
}

local ai=ah.Desc~=nil and ah.Desc~=""

if ah.Value==nil then
ah.Value=false
end

local aj=ai and 112 or 84
local ak=ai and 124 or 92

ah.ToggleFrame=a.load'B'{
Title=ah.Title,
Desc=ah.Desc,
Window=ag.Window,
Parent=ag.Parent,
TextOffset=ak,
Hover=false,
Tab=ag.Tab,
Index=ag.Index,
ElementTable=ah,
ParentConfig=ag,

Image=ah.Icon,
ImageSize=ah.IconSize,

RightSlotWidth=aj,
DividerRightInset=aj+8,
ExpandableDesc=ai,
ShowChevron=ai,
DescExpanded=false,
}

local al=true
local am=ah.Value

function ah.Lock(an)
ah.Locked=true
al=false
return ah.ToggleFrame:Lock(ah.LockedTitle)
end

function ah.Unlock(an)
ah.Locked=false
al=true
return ah.ToggleFrame:Unlock()
end

if ah.Locked then
ah:Lock()
end

local an=ah.ToggleFrame.UIElements.RightSlot
local ao
local ap

if ah.Type=="Toggle"then
ao,ap=CreateIosSwitch(an,am,ag)
elseif ah.Type=="Checkbox"then
ao,ap=
ad(am,nil,0,an,ah.Callback,ag)
ao.LayoutOrder=1
else
error("Unknown Toggle Type: "..tostring(ah.Type))
end

ah.UIElements.Switch=ao

function ah.Set(aq,ar,as,at)
if not al then
return
end

local au=ar==true
am=au
ah.Value=au

if ap and ap.Set then
ap:Set(au,false,at)
end

if as~=false then
aa.SafeCallback(ah.Callback,au)
end
end

ah:Set(am,false,false)

if ah.Type=="Toggle"then
aa.AddSignal(ao.Track.Hitbox.MouseButton1Click,function()
if ah.Locked then
return
end
ah:Set(not ah.Value,true,true)
end)

aa.AddSignal(ao.Track.Hitbox.MouseButton1Down,function()
if ah.Locked then
return
end
if ap and ap.Press then
ap:Press()
end
end)

aa.AddSignal(ao.Track.Hitbox.InputEnded,function(aq)
if
aq.UserInputType==Enum.UserInputType.MouseButton1
or aq.UserInputType==Enum.UserInputType.Touch
then
if ap and ap.Release then
ap:Release()
end
end
end)
else
aa.AddSignal(ah.ToggleFrame.UIElements.Main.MouseButton1Click,function()
if ah.Locked then
return
end
ah:Set(not ah.Value,true,ag.Window.NewElements)
end)
end

if not ai and ah.Type=="Toggle"then
aa.AddSignal(ah.ToggleFrame.UIElements.Main.MouseButton1Click,function()
if ah.Locked then
return
end
ah:Set(not ah.Value,true,true)
end)
end

return ah.__type,ah
end

return ae end function a.G()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")
local ac=aa(game:GetService"RunService")

local ad=a.load'c'
local ae=ad.New
local af=ad.Tween

local ag={}

local ah=false

local function GetPrecisionFromStep(ai)
local aj=tostring(ai or 1)
local ak=aj:match"%.(%d+)"
return ak and#ak or 0
end

function ag.New(ai,aj)
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

TextBoxWidth=aj.Window.NewElements and 58 or 52,
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
aw=ad.Image(
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
ax=ad.Image(
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

ak.UIElements.Root=ae("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ak.SliderFrame.UIElements.Main,
},{
ae("UIListLayout",{
Padding=UDim.new(0,(ak.Title or ak.InputBox)and 8 or 0),
FillDirection="Vertical",
HorizontalAlignment="Center",
SortOrder="LayoutOrder",
})
})

local aA=ak.Title~=nil or ak.InputBox

ak.UIElements.HeaderRow=ae("Frame",{
Size=UDim2.new(1,0,0,aA and ak.TextBoxHeight or 0),
BackgroundTransparency=1,
Visible=aA,
Parent=ak.UIElements.Root,
LayoutOrder=1,
ClipsDescendants=false,
})

if ak.Title then
ak.UIElements.TitleAccent=ad.NewRoundFrame(999,"Squircle",{
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

ak.UIElements.TitleLabel=ae("TextLabel",{
Size=UDim2.new(1,ak.InputBox and-(ak.TextBoxWidth+12)or 0,1,0),
Position=UDim2.new(0,ak.Title and 16 or 0,0,0),
BackgroundTransparency=1,
Text=ak.Title or"",
Visible=ak.Title~=nil,
TextXAlignment="Left",
TextYAlignment="Center",
TextSize=15,
FontFace=Font.new(ad.Font,Enum.FontWeight.SemiBold),
ThemeTag={
TextColor3="Text"
},
TextTransparency=0.04,
Parent=ak.UIElements.HeaderRow,
})

if ak.InputBox then
ak.UIElements.TextBox=ae("TextBox",{
Size=UDim2.new(0,ak.TextBoxWidth,0,ak.TextBoxHeight),
Position=UDim2.new(1,2,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
TextXAlignment="Center",
ClearTextOnFocus=false,
Text=FormatValue(aq),
TextSize=14,
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
ThemeTag={
TextColor3="Text"
},
TextTransparency=0.08,
Parent=ak.UIElements.HeaderRow,
},{
ad.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.88,
ThemeTag={
ImageColor3="Text"
},
ZIndex=0,
}),
ad.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.78,
ImageColor3=Color3.new(1,1,1),
Name="Stroke",
ZIndex=0,
}),
ae("UIPadding",{
PaddingLeft=UDim.new(0,8),
PaddingRight=UDim.new(0,8),
}),
})
end

ak.UIElements.BodyRow=ae("Frame",{
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

ak.UIElements.RailHitbox=ae("Frame",{
Size=UDim2.new(1,-(ay+az),0,ak.BodyHeight),
Position=UDim2.new(0,ay,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
BackgroundTransparency=1,
Parent=ak.UIElements.BodyRow,
ClipsDescendants=false,
})

ak.UIElements.TrackInset=ae("Frame",{
Size=UDim2.new(1,-(av*2),1,0),
Position=UDim2.new(0,av,0,0),
BackgroundTransparency=1,
Parent=ak.UIElements.RailHitbox,
})

ak.UIElements.Track=ad.NewRoundFrame(99,"Squircle",{
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

ak.UIElements.Fill=ad.NewRoundFrame(99,"Squircle",{
Name="Fill",
Size=UDim2.new(ValueToDelta(aq),0,1,0),
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Slider",
},
Parent=ak.UIElements.Track,
},{
ad.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,at,0,au),
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="SliderThumb",
},
Name="Thumb",
ZIndex=2,
},{
ad.NewRoundFrame(99,"Glass-1",{
Size=UDim2.new(1,0,1,0),
ImageColor3=Color3.new(1,1,1),
Name="Highlight",
ImageTransparency=0.6,
ZIndex=3,
}),
})
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
af(ak.UIElements.Fill,0.05,{
Size=UDim2.new(h,0,1,0)
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
ad.SafeCallback(ak.Callback,d)
end
end

function ak.Set(d,f,g)
if not ar then
return
end

if not ak.IsFocusing and not ah and g and(g.UserInputType==Enum.UserInputType.MouseButton1 or g.UserInputType==Enum.UserInputType.Touch)then
al=(g.UserInputType==Enum.UserInputType.Touch)
if b then
b.ScrollingEnabled=false
end
ah=true

local function UpdateFromPointer()
local h=al and g.Position.X or ab:GetMouseLocation().X
local j=math.clamp((h-ak.UIElements.TrackInset.AbsolutePosition.X)/ak.UIElements.TrackInset.AbsoluteSize.X,0,1)
local l=ao+j*(ap-ao)
CommitValue(l,true,true,false)
end

UpdateFromPointer()

am=ac.RenderStepped:Connect(function()
UpdateFromPointer()
end)

an=ab.InputEnded:Connect(function(h)
if(h.UserInputType==Enum.UserInputType.MouseButton1 or h.UserInputType==Enum.UserInputType.Touch)and g==h then
if am then
am:Disconnect()
am=nil
end
if an then
an:Disconnect()
an=nil
end

ah=false
if b then
b.ScrollingEnabled=true
end

if aj.Window.NewElements then
af(ak.UIElements.Fill.Thumb,0.2,{
ImageTransparency=0,
Size=UDim2.new(0,at,0,au)
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
ad.AddSignal(ak.UIElements.TextBox.Focused,function()
ak.IsFocusing=true

af(ak.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.45
}):Play()
end)

ad.AddSignal(ak.UIElements.TextBox:GetPropertyChangedSignal"Text",function()
if not ak.IsFocusing then
return
end

local d=tonumber(ak.UIElements.TextBox.Text)
if d~=nil then
local f=NormalizeValue(d)
UpdateVisuals(f,true,true)
end
end)

ad.AddSignal(ak.UIElements.TextBox.FocusLost,function()
ak.IsFocusing=false

af(ak.UIElements.TextBox.Stroke,0.12,{
ImageTransparency=0.78
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

ad.AddSignal(ak.UIElements.RailHitbox.InputBegan,function(d)
if ak.Locked or ah then
return
end

ak:Set(aq,d)

if d.UserInputType==Enum.UserInputType.MouseButton1 or d.UserInputType==Enum.UserInputType.Touch then
if aj.Window.NewElements then
af(ak.UIElements.Fill.Thumb,0.24,{
ImageTransparency=0.85,
Size=UDim2.new(0,at+8,0,au+4)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

if aB then
aB:Open()
end
end
end)

return ak.__type,ak
end

return ag end function a.H()

local aa=(cloneref or clonereference or function(aa)return aa end)

local ab=aa(game:GetService"UserInputService")

local ac=a.load'c'
local ad=ac.New local ae=
ac.Tween

local af={
UICorner=6,
UIPadding=8,
}

local ag=a.load'v'.New

function af.New(ah,ai)
local function NormalizeKeyCode(aj)
if typeof(aj)=="EnumItem"then
return aj.Name
elseif type(aj)=="string"then
return aj
else
return"F"
end
end

local aj={
__type="Keybind",
Title=ai.Title or"Keybind",
Desc=ai.Desc or nil,
Locked=ai.Locked or false,
LockedTitle=ai.LockedTitle,
Value=NormalizeKeyCode(ai.Value)or"F",
Callback=ai.Callback or function()end,
CanChange=ai.CanChange or true,
Picking=false,
UIElements={},
}

local ak=true

aj.KeybindFrame=a.load'B'{
Title=aj.Title,
Desc=aj.Desc,
Parent=ai.Parent,
TextOffset=85,
Hover=aj.CanChange,
Tab=ai.Tab,
Index=ai.Index,
Window=ai.Window,
ElementTable=aj,
ParentConfig=ai,
}

aj.UIElements.Keybind=ag(aj.Value,nil,aj.KeybindFrame.UIElements.Main,nil,ai.Window.NewElements and 12 or 10)

aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
aj.UIElements.Keybind.AnchorPoint=Vector2.new(1,0.5)
aj.UIElements.Keybind.Position=UDim2.new(1,0,0.5,0)

ad("UIScale",{
Parent=aj.UIElements.Keybind,
Scale=.85,
})

ac.AddSignal(aj.UIElements.Keybind.Frame.Frame.TextLabel:GetPropertyChangedSignal"TextBounds",function()
aj.UIElements.Keybind.Size=UDim2.new(
0,24
+aj.UIElements.Keybind.Frame.Frame.TextLabel.TextBounds.X,
0,
42
)
end)

function aj.Lock(al)
aj.Locked=true
ak=false
return aj.KeybindFrame:Lock(aj.LockedTitle)
end
function aj.Unlock(al)
aj.Locked=false
ak=true
return aj.KeybindFrame:Unlock()
end

function aj.Set(al,am)
local an=NormalizeKeyCode(am)
aj.Value=an
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
end

if aj.Locked then
aj:Lock()
end

ac.AddSignal(aj.KeybindFrame.UIElements.Main.MouseButton1Click,function()
if ak then
if aj.CanChange then
aj.Picking=true
aj.UIElements.Keybind.Frame.Frame.TextLabel.Text="..."

task.wait(0.2)

local al
al=ab.InputBegan:Connect(function(am)
local an

if am.UserInputType==Enum.UserInputType.Keyboard then
an=am.KeyCode.Name
elseif am.UserInputType==Enum.UserInputType.MouseButton1 then
an="MouseLeft"
elseif am.UserInputType==Enum.UserInputType.MouseButton2 then
an="MouseRight"
end

local ao
ao=ab.InputEnded:Connect(function(ap)
if ap.KeyCode.Name==an or an=="MouseLeft"and ap.UserInputType==Enum.UserInputType.MouseButton1 or an=="MouseRight"and ap.UserInputType==Enum.UserInputType.MouseButton2 then
aj.Picking=false

aj.UIElements.Keybind.Frame.Frame.TextLabel.Text=an
aj.Value=an

al:Disconnect()
ao:Disconnect()
end
end)
end)
end
end
end)

ac.AddSignal(ab.InputBegan,function(al,am)
if ab:GetFocusedTextBox()then
return
end

if not ak then
return
end

if al.UserInputType==Enum.UserInputType.Keyboard then
if al.KeyCode.Name==aj.Value then
ac.SafeCallback(aj.Callback,al.KeyCode.Name)
end
elseif al.UserInputType==Enum.UserInputType.MouseButton1 and aj.Value=="MouseLeft"then
ac.SafeCallback(aj.Callback,"MouseLeft")
elseif al.UserInputType==Enum.UserInputType.MouseButton2 and aj.Value=="MouseRight"then
ac.SafeCallback(aj.Callback,"MouseRight")
end
end)

return aj.__type,aj
end

return af end function a.I()
local aa=a.load'c'
local ab=aa.New local ac=
aa.Tween

local ad={
UICorner=8,
UIPadding=8,
}local ae=a.load'l'


.New
local af=a.load'm'.New

function ad.New(ag,ah)
local ai={
__type="Input",
Title=ah.Title or"Input",
Desc=ah.Desc or nil,
Type=ah.Type or"Input",
Locked=ah.Locked or false,
LockedTitle=ah.LockedTitle,
InputIcon=ah.InputIcon or false,
Placeholder=ah.Placeholder or"Enter Text...",
Value=ah.Value or"",
Callback=ah.Callback or function()end,
ClearTextOnFocus=ah.ClearTextOnFocus or false,
UIElements={},

Width=150,
}

local aj=true

ai.InputFrame=a.load'B'{
Title=ai.Title,
Desc=ai.Desc,
Parent=ah.Parent,
TextOffset=ai.Width,
Hover=false,
Tab=ah.Tab,
Index=ah.Index,
Window=ah.Window,
ElementTable=ai,
ParentConfig=ah,
}

local ak=af(
ai.Placeholder,
ai.InputIcon,
ai.Type=="Textarea"and ai.InputFrame.UIElements.Container or ai.InputFrame.UIElements.Main,
ai.Type,
function(ak)
ai:Set(ak,true)
end,
nil,
ah.Window.NewElements and 12 or 10,
ai.ClearTextOnFocus
)

if ai.Type=="Input"then
ak.Size=UDim2.new(0,ai.Width,0,36)
ak.Position=UDim2.new(1,0,ah.Window.NewElements and 0 or 0.5,0)
ak.AnchorPoint=Vector2.new(1,ah.Window.NewElements and 0 or 0.5)
else
ak.Size=UDim2.new(1,0,0,148)
end

ab("UIScale",{
Parent=ak,
Scale=1,
})

function ai.Lock(al)
ai.Locked=true
aj=false
return ai.InputFrame:Lock(ai.LockedTitle)
end
function ai.Unlock(al)
ai.Locked=false
aj=true
return ai.InputFrame:Unlock()
end


function ai.Set(al,am,an)
if aj then
ai.Value=am
aa.SafeCallback(ai.Callback,am)

if not an then
ak.Frame.Frame.TextBox.Text=am
end
end
end

function ai.SetPlaceholder(al,am)
ak.Frame.Frame.TextBox.PlaceholderText=am
ai.Placeholder=am
end

ai:Set(ai.Value)

if ai.Locked then
ai:Lock()
end

return ai.__type,ai
end

return ad end function a.J()
local aa=a.load'c'
local ab=aa.New

local ad={}

function ad.New(ae,af)
local ag=ab("Frame",{
Size=af.ParentType~="Group"and UDim2.new(1,0,0,1)or UDim2.new(0,1,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=.9,
ThemeTag={
BackgroundColor3="Text"
}
})
local ah=ab("Frame",{
Parent=af.Parent,
Size=af.ParentType~="Group"and UDim2.new(1,-7,0,7)or UDim2.new(0,7,1,-7),
BackgroundTransparency=1,
},{
ag
})

return"Divider",{__type="Divider",ElementFrame=ah}
end

return ad end function a.K()
local aa={}

local ab=(cloneref or clonereference or function(ab)
return ab
end)

local ad=ab(game:GetService"UserInputService")
local ae=ab(game:GetService"Players").LocalPlayer:GetMouse()
local af=ab(game:GetService"Workspace").CurrentCamera

local ag=workspace.CurrentCamera

local ah=a.load'm'.New

local ai=a.load'c'
local aj=ai.New
local ak=ai.Tween

function aa.New(al,am,an,ao,ap)
local aq={}

if not am.Callback then
ap="Menu"
end

am.UIElements.UIListLayout=aj("UIListLayout",{
Padding=UDim.new(0,an.MenuPadding/1.5),
FillDirection="Vertical",
HorizontalAlignment="Center",
})

am.UIElements.Menu=ai.NewRoundFrame(an.MenuCorner,"Squircle",{
ThemeTag={
ImageColor3="Background",
},
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
},{
aj("UIPadding",{
PaddingTop=UDim.new(0,an.MenuPadding),
PaddingLeft=UDim.new(0,an.MenuPadding),
PaddingRight=UDim.new(0,an.MenuPadding),
PaddingBottom=UDim.new(0,an.MenuPadding),
}),
aj("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.MenuPadding),
}),
aj("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,am.SearchBarEnabled and-an.MenuPadding-an.SearchBarHeight),

ClipsDescendants=true,
LayoutOrder=999,
},{
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
aj("ScrollingFrame",{
Size=UDim2.new(1,0,1,0),
ScrollBarThickness=0,
ScrollingDirection="Y",
AutomaticCanvasSize="Y",
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
ScrollBarImageTransparency=1,
},{
am.UIElements.UIListLayout,
}),
}),
})

am.UIElements.MenuCanvas=aj("Frame",{
Size=UDim2.new(0,am.MenuWidth,0,300),
BackgroundTransparency=1,
Position=UDim2.new(-10,0,-10,0),
Visible=false,
Active=false,

Parent=al.WindUI.DropdownGui,
AnchorPoint=Vector2.new(1,0),
},{
am.UIElements.Menu,
aj("UISizeConstraint",{
MinSize=Vector2.new(170,0),
MaxSize=Vector2.new(300,400),
}),
})

local function RecalculateCanvasSize()
am.UIElements.Menu.Frame.ScrollingFrame.CanvasSize=
UDim2.fromOffset(0,am.UIElements.UIListLayout.AbsoluteContentSize.Y)
end

local function RecalculateListSize()
local ar=ag.ViewportSize.Y*0.6

local as=am.UIElements.UIListLayout.AbsoluteContentSize.Y
local at=am.SearchBarEnabled and(an.SearchBarHeight+(an.MenuPadding*3))
or(an.MenuPadding*2)
local au=as+at

if au>ar then
am.UIElements.MenuCanvas.Size=
UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,ar)
else
am.UIElements.MenuCanvas.Size=
UDim2.fromOffset(am.UIElements.MenuCanvas.AbsoluteSize.X,au)
end
end

function UpdatePosition()
local ar=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local as=am.UIElements.MenuCanvas

local at=af.ViewportSize.Y
-(ar.AbsolutePosition.Y+ar.AbsoluteSize.Y)
-an.MenuPadding
-54
local au=as.AbsoluteSize.Y+an.MenuPadding

local av=-54
if at<au then
av=au-at-54
end

as.Position=UDim2.new(
0,
ar.AbsolutePosition.X+ar.AbsoluteSize.X,
0,
ar.AbsolutePosition.Y+ar.AbsoluteSize.Y-av+(an.MenuPadding*2)
)
end

local ar

function aq.Display(as)
local at=am.Values
local au=""

if am.Multi then
local av={}
if typeof(am.Value)=="table"then
for aw,ax in ipairs(am.Value)do
local ay=typeof(ax)=="table"and ax.Title or ax
av[ay]=true
end
end

for aw,ax in ipairs(at)do
local ay=typeof(ax)=="table"and ax.Title or ax
if av[ay]then
au=au..ay..", "
end
end

if#au>0 then
au=au:sub(1,#au-2)
end
else
au=typeof(am.Value)=="table"and am.Value.Title or am.Value or""
end

if am.UIElements.Dropdown then
am.UIElements.Dropdown.Frame.Frame.TextLabel.Text=(au==""and"--"or au)
end
end

local function Callback(as)
aq:Display()
if am.Callback then
task.spawn(function()
ai.SafeCallback(am.Callback,am.Value)
end)
else
task.spawn(function()
ai.SafeCallback(as)
end)
end
end

function aq.LockValues(as,at)
if not at then
return
end

for au,av in next,am.Tabs do
if av and av.UIElements and av.UIElements.TabItem then
local aw=av.Name
local ax=false

for ay,az in next,at do
if aw==az then
ax=true
break
end
end

if ax then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.6}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.6}):Play()
end

av.UIElements.TabItem.Active=false
av.Locked=true
else
if av.Selected then
ak(av.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(av.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if av.UIElements.TabIcon then
ak(av.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
else
ak(av.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(av.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(
av.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=ap=="Dropdown"and 0.4 or 0.05}
):Play()
if av.UIElements.TabIcon then
ak(
av.UIElements.TabIcon.ImageLabel,
0.1,
{ImageTransparency=ap=="Dropdown"and 0.2 or 0}
):Play()
end
end

av.UIElements.TabItem.Active=true
av.Locked=false
end
end
end
end

function aq.Refresh(as,at)
for au,av in next,am.UIElements.Menu.Frame.ScrollingFrame:GetChildren()do
if not av:IsA"UIListLayout"then
av:Destroy()
end
end

am.Tabs={}

if am.SearchBarEnabled then
if not ar then
ar=ah("Search...","search",am.UIElements.Menu,nil,function(au)
for av,aw in next,am.Tabs do
if string.find(string.lower(aw.Name),string.lower(au),1,true)then
aw.UIElements.TabItem.Visible=true
else
aw.UIElements.TabItem.Visible=false
end
RecalculateListSize()
RecalculateCanvasSize()
end
end,true)
ar.Size=UDim2.new(1,0,0,an.SearchBarHeight)
ar.Position=UDim2.new(0,0,0,0)
ar.Name="SearchBar"
end
end

for au,av in next,at do
if av.Type~="Divider"then
local aw={
Name=typeof(av)=="table"and av.Title or av,
Desc=typeof(av)=="table"and av.Desc or nil,
Icon=typeof(av)=="table"and av.Icon or nil,
IconSize=typeof(av)=="table"and av.IconSize or nil,
Original=av,
Selected=false,
Locked=typeof(av)=="table"and av.Locked or false,
UIElements={},
}
local ax
if aw.Icon then
ax=ai.Image(aw.Icon,aw.Icon,0,al.Window.Folder,"Dropdown",true)
ax.Size=
UDim2.new(0,aw.IconSize or an.TabIcon,0,aw.IconSize or an.TabIcon)
ax.ImageLabel.ImageTransparency=ap=="Dropdown"and 0.2 or 0
aw.UIElements.TabIcon=ax
end
aw.UIElements.TabItem=ai.NewRoundFrame(
an.MenuCorner-an.MenuPadding,
"Squircle",
{
Size=UDim2.new(1,0,0,36),
AutomaticSize=aw.Desc and"Y",
ImageTransparency=1,
Parent=am.UIElements.Menu.Frame.ScrollingFrame,
ImageColor3=Color3.new(1,1,1),
Active=not aw.Locked,
},
{
ai.NewRoundFrame(an.MenuCorner-an.MenuPadding,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="DropdownTabBorder",
},
ImageTransparency=1,
Name="Highlight",
},{













}),
aj("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
aj("UIPadding",{
PaddingTop=UDim.new(0,an.TabPadding),
PaddingLeft=UDim.new(0,an.TabPadding),
PaddingRight=UDim.new(0,an.TabPadding),
PaddingBottom=UDim.new(0,an.TabPadding),
}),
aj("UICorner",{
CornerRadius=UDim.new(0,an.MenuCorner-an.MenuPadding),
}),
ax,
aj("Frame",{
Size=UDim2.new(1,ax and-an.TabPadding-an.TabIcon or 0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Name="Title",
},{
aj("TextLabel",{
Text=aw.Name,
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Medium),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and 0.4 or 0.05,
LayoutOrder=999,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
}),
aj("TextLabel",{
Text=aw.Desc or"",
TextXAlignment="Left",
FontFace=Font.new(ai.Font,Enum.FontWeight.Regular),
ThemeTag={
TextColor3="Text",
BackgroundColor3="Text",
},
TextSize=15,
BackgroundTransparency=1,
TextTransparency=ap=="Dropdown"and 0.6 or 0.35,
LayoutOrder=999,
AutomaticSize="Y",
TextWrapped=true,
Size=UDim2.new(1,0,0,0),
Visible=aw.Desc and true or false,
Name="Desc",
}),
aj("UIListLayout",{
Padding=UDim.new(0,an.TabPadding/3),
FillDirection="Vertical",
}),
}),
}),
},
true
)

if aw.Locked then
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0.6
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0.6
end
end

if am.Multi and typeof(am.Value)=="string"then
for ay,az in next,am.Values do
if typeof(az)=="table"then
if az.Title==am.Value then
am.Value={az}
end
else
if az==am.Value then
am.Value={am.Value}
end
end
end
end

if am.Multi then
local ay=false
if typeof(am.Value)=="table"then
for az,aA in ipairs(am.Value)do
local aB=typeof(aA)=="table"and aA.Title or aA
if aB==aw.Name then
ay=true
break
end
end
end
aw.Selected=ay
else
local ay=typeof(am.Value)=="table"and am.Value.Title or am.Value
aw.Selected=ay==aw.Name
end

if aw.Selected and not aw.Locked then
aw.UIElements.TabItem.ImageTransparency=0.95
aw.UIElements.TabItem.Highlight.ImageTransparency=0.75
aw.UIElements.TabItem.Frame.Title.TextLabel.TextTransparency=0
if aw.UIElements.TabIcon then
aw.UIElements.TabIcon.ImageLabel.ImageTransparency=0
end
end

am.Tabs[au]=aw

aq:Display()

if ap=="Dropdown"then
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then
return
end

if am.Multi then
if not aw.Selected then
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
table.insert(am.Value,aw.Original)
else
if not am.AllowNone and#am.Value==1 then
return
end
aw.Selected=false
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0.4}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end

for ay,az in next,am.Value do
if typeof(az)=="table"and(az.Title==aw.Name)or(az==aw.Name)then
table.remove(am.Value,ay)
break
end
end
end
else
for ay,az in next,am.Tabs do
ak(az.UIElements.TabItem,0.1,{ImageTransparency=1}):Play()
ak(az.UIElements.TabItem.Highlight,0.1,{ImageTransparency=1}):Play()
ak(
az.UIElements.TabItem.Frame.Title.TextLabel,
0.1,
{TextTransparency=0.4}
):Play()
if az.UIElements.TabIcon then
ak(az.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0.2}):Play()
end
az.Selected=false
end
aw.Selected=true
ak(aw.UIElements.TabItem,0.1,{ImageTransparency=0.95}):Play()
ak(aw.UIElements.TabItem.Highlight,0.1,{ImageTransparency=0.75}):Play()
ak(aw.UIElements.TabItem.Frame.Title.TextLabel,0.1,{TextTransparency=0}):Play()
if aw.UIElements.TabIcon then
ak(aw.UIElements.TabIcon.ImageLabel,0.1,{ImageTransparency=0}):Play()
end
am.Value=aw.Original
end
Callback()
end)
elseif ap=="Menu"then
if not aw.Locked then
ai.AddSignal(aw.UIElements.TabItem.MouseEnter,function()
ak(aw.UIElements.TabItem,0.08,{ImageTransparency=0.95}):Play()
end)
ai.AddSignal(aw.UIElements.TabItem.InputEnded,function()
ak(aw.UIElements.TabItem,0.08,{ImageTransparency=1}):Play()
end)
end
ai.AddSignal(aw.UIElements.TabItem.MouseButton1Click,function()
if aw.Locked then
return
end
Callback(av.Callback or function()end)
end)
end

RecalculateCanvasSize()
RecalculateListSize()
else a.load'J'
:New{Parent=am.UIElements.Menu.Frame.ScrollingFrame}
end
end










am.UIElements.MenuCanvas.Size=UDim2.new(
0,
am.MenuWidth+6+6+5+5+18+6+6,
am.UIElements.MenuCanvas.Size.Y.Scale,
am.UIElements.MenuCanvas.Size.Y.Offset
)
Callback()

am.Values=at
end

aq:Refresh(am.Values)

function aq.Select(as,at)
if at then
am.Value=at
else
if am.Multi then
am.Value={}
else
am.Value=nil
end
end
aq:Refresh(am.Values)
end

RecalculateListSize()
RecalculateCanvasSize()

function aq.Open(as)
if ao then
am.UIElements.Menu.Visible=true
am.UIElements.MenuCanvas.Visible=true
am.UIElements.MenuCanvas.Active=true
am.UIElements.Menu.Size=UDim2.new(1,0,0,0)
ak(am.UIElements.Menu,0.1,{
Size=UDim2.new(1,0,1,0),
ImageTransparency=0.05,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
am.Opened=true
end)

UpdatePosition()
end
end

function aq.Close(as)
am.Opened=false

ak(am.UIElements.Menu,0.25,{
Size=UDim2.new(1,0,0,0),
ImageTransparency=1,
},Enum.EasingStyle.Quart,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.1)
am.UIElements.Menu.Visible=false
end)

task.spawn(function()
task.wait(0.25)
am.UIElements.MenuCanvas.Visible=false
am.UIElements.MenuCanvas.Active=false
end)
end

ai.AddSignal(
(
am.UIElements.Dropdown and am.UIElements.Dropdown.MouseButton1Click
or am.DropdownFrame.UIElements.Main.MouseButton1Click
),
function()
aq:Open()
end
)

ai.AddSignal(ad.InputBegan,function(as)
if
as.UserInputType==Enum.UserInputType.MouseButton1
or as.UserInputType==Enum.UserInputType.Touch
then
local at=am.UIElements.MenuCanvas
local au,av=at.AbsolutePosition,at.AbsoluteSize

local aw=am.UIElements.Dropdown or am.DropdownFrame.UIElements.Main
local ax=aw.AbsolutePosition
local ay=aw.AbsoluteSize

local az=ae.X>=ax.X
and ae.X<=ax.X+ay.X
and ae.Y>=ax.Y
and ae.Y<=ax.Y+ay.Y

local aA=ae.X>=au.X
and ae.X<=au.X+av.X
and ae.Y>=au.Y
and ae.Y<=au.Y+av.Y

if al.Window.CanDropdown and am.Opened and not az and not aA then
aq:Close()
end
end
end)

ai.AddSignal(
am.UIElements.Dropdown and am.UIElements.Dropdown:GetPropertyChangedSignal"AbsolutePosition"
or am.DropdownFrame.UIElements.Main:GetPropertyChangedSignal"AbsolutePosition",
UpdatePosition
)

return aq
end

return aa end function a.L()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")
aa(game:GetService"Players").LocalPlayer:GetMouse()local ab=
aa(game:GetService"Workspace").CurrentCamera

local ad=a.load'c'
local ae=ad.New local af=
ad.Tween

local ag=a.load'v'.New local ah=a.load'm'
.New
local ai=a.load'K'.New local aj=

workspace.CurrentCamera

local ak={
UICorner=10,
UIPadding=12,
MenuCorner=15,
MenuPadding=5,
TabPadding=10,
SearchBarHeight=39,
TabIcon=18,
}

function ak.New(al,am)
local an={
__type="Dropdown",
Title=am.Title or"Dropdown",
Desc=am.Desc or nil,
Locked=am.Locked or false,
LockedTitle=am.LockedTitle,
Values=am.Values or{},
MenuWidth=am.MenuWidth or 180,
Value=am.Value,
AllowNone=am.AllowNone,
SearchBarEnabled=am.SearchBarEnabled or false,
Multi=am.Multi,
Callback=am.Callback or nil,

UIElements={},

Opened=false,
Tabs={},

Width=150,
}

if an.Multi and not an.Value then
an.Value={}
end
if an.Values and typeof(an.Value)=="number"then
an.Value=an.Values[an.Value]
end

local ao=true

an.DropdownFrame=a.load'B'{
Title=an.Title,
Desc=an.Desc,
Parent=am.Parent,
TextOffset=an.Callback and an.Width or 20,
Hover=not an.Callback and true or false,
Tab=am.Tab,
Index=am.Index,
Window=am.Window,
ElementTable=an,
ParentConfig=am,
}

if an.Callback then
an.UIElements.Dropdown=
ag("",nil,an.DropdownFrame.UIElements.Main,nil,am.Window.NewElements and 12 or 10)

an.UIElements.Dropdown.Frame.Frame.TextLabel.TextTruncate="AtEnd"
an.UIElements.Dropdown.Frame.Frame.TextLabel.Size=
UDim2.new(1,an.UIElements.Dropdown.Frame.Frame.TextLabel.Size.X.Offset-18-12-12,0,0)

an.UIElements.Dropdown.Size=UDim2.new(0,an.Width,0,36)
an.UIElements.Dropdown.Position=UDim2.new(1,0,am.Window.NewElements and 0 or 0.5,0)
an.UIElements.Dropdown.AnchorPoint=Vector2.new(1,am.Window.NewElements and 0 or 0.5)





end

an.DropdownMenu=ai(am,an,ak,ao,"Dropdown")

an.Display=an.DropdownMenu.Display
an.Refresh=an.DropdownMenu.Refresh
an.Select=an.DropdownMenu.Select
an.Open=an.DropdownMenu.Open
an.Close=an.DropdownMenu.Close

ae("ImageLabel",{
Image=ad.Icon"chevrons-up-down"[1],
ImageRectOffset=ad.Icon"chevrons-up-down"[2].ImageRectPosition,
ImageRectSize=ad.Icon"chevrons-up-down"[2].ImageRectSize,
Size=UDim2.new(0,18,0,18),
Position=UDim2.new(1,an.UIElements.Dropdown and-12 or 0,0.5,0),
ThemeTag={
ImageColor3="Icon",
},
AnchorPoint=Vector2.new(1,0.5),
Parent=an.UIElements.Dropdown and an.UIElements.Dropdown.Frame
or an.DropdownFrame.UIElements.Main,
})

function an.Lock(ap)
an.Locked=true
ao=false
return an.DropdownFrame:Lock(an.LockedTitle)
end
function an.Unlock(ap)
an.Locked=false
ao=true
return an.DropdownFrame:Unlock()
end

if an.Locked then
an:Lock()
end

return an.__type,an
end

return ak end function a.M()







local aa={}
local ad={
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

local ae={
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

local function createKeywordSet(ag)
local ai={}
for aj,ak in ipairs(ag)do
ai[ak]=true
end
return ai
end

local ag=createKeywordSet(ad.lua)
local ai=createKeywordSet(ad.rbx)
local aj=createKeywordSet(ad.operators)

local function getHighlight(ak,al)
local am=ak[al]

if ae[am.."_color"]then
return ae[am.."_color"]
end

if tonumber(am)then
return ae.numbers
elseif am=="nil"then
return ae.null
elseif am:sub(1,2)=="--"then
return ae.comment
elseif aj[am]then
return ae.operator
elseif ag[am]then
return ae.lua
elseif ai[am]then
return ae.rbx
elseif am:sub(1,1)=="\""or am:sub(1,1)=="\'"then
return ae.str
elseif am=="true"or am=="false"then
return ae.boolean
end

if ak[al+1]=="("then
if ak[al-1]==":"then
return ae.self_call
end

return ae.call
end

if ak[al-1]=="."then
if ak[al-2]=="Enum"then
return ae.rbx
end

return ae.local_property
end
end

function aa.run(ak)
local al={}
local am=""

local an=false
local ao=false
local ap=false

for aq=1,#ak do
local ar=ak:sub(aq,aq)

if ao then
if ar=="\n"and not ap then
table.insert(al,am)
table.insert(al,ar)
am=""

ao=false
elseif ak:sub(aq-1,aq)=="]]"and ap then
am=am.."]"

table.insert(al,am)
am=""

ao=false
ap=false
else
am=am..ar
end
elseif an then
if ar==an and ak:sub(aq-1,aq-1)~="\\"or ar=="\n"then
am=am..ar
an=false
else
am=am..ar
end
else
if ak:sub(aq,aq+1)=="--"then
table.insert(al,am)
am="-"
ao=true
ap=ak:sub(aq+2,aq+3)=="[["
elseif ar=="\""or ar=="\'"then
table.insert(al,am)
am=ar
an=ar
elseif aj[ar]then
table.insert(al,am)
table.insert(al,ar)
am=""
elseif ar:match"[%w_]"then
am=am..ar
else
table.insert(al,am)
table.insert(al,ar)
am=""
end
end
end

table.insert(al,am)

local aq={}

for ar,as in ipairs(al)do
local at=getHighlight(al,ar)

if at then
local au=string.format("<font color = \"#%s\">%s</font>",at:ToHex(),as:gsub("<","&lt;"):gsub(">","&gt;"))

table.insert(aq,au)
else
table.insert(aq,as)
end
end

return table.concat(aq)
end

return aa end function a.N()
local aa={}

local ad=a.load'c'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'M'

function aa.New(aj,ak,al,am,an)
local ao={
Radius=12,
Padding=10
}

local ap=ae("TextLabel",{
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
ae("UIPadding",{
PaddingTop=UDim.new(0,ao.Padding+3),
PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),
PaddingBottom=UDim.new(0,ao.Padding+3),
})
})
ap.Font="Code"

local aq=ae("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticCanvasSize="X",
ScrollingDirection="X",
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
ScrollBarThickness=0,
},{
ap
})

local ar=ae("TextButton",{
BackgroundTransparency=1,
Size=UDim2.new(0,30,0,30),
Position=UDim2.new(1,-ao.Padding/2,0,ao.Padding/2),
AnchorPoint=Vector2.new(1,0),
Visible=am and true or false,
},{
ad.NewRoundFrame(ao.Radius-4,"Squircle",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=1,
Size=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Button",
},{
ae("UIScale",{
Scale=1,
}),
ae("ImageLabel",{
Image=ad.Icon"copy"[1],
ImageRectSize=ad.Icon"copy"[2].ImageRectSize,
ImageRectOffset=ad.Icon"copy"[2].ImageRectPosition,
BackgroundTransparency=1,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Size=UDim2.new(0,12,0,12),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.1,
})
})
})

ad.AddSignal(ar.MouseEnter,function()
ag(ar.Button,.05,{ImageTransparency=.95}):Play()
ag(ar.Button.UIScale,.05,{Scale=.9}):Play()
end)
ad.AddSignal(ar.InputEnded,function()
ag(ar.Button,.08,{ImageTransparency=1}):Play()
ag(ar.Button.UIScale,.08,{Scale=1}):Play()
end)

local as=ad.NewRoundFrame(ao.Radius,"Squircle",{



ImageColor3=Color3.fromHex"#212121",
ImageTransparency=.035,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
AutomaticSize="Y",
Parent=al,
},{
ad.NewRoundFrame(ao.Radius,"SquircleOutline",{
Size=UDim2.new(1,0,1,0),



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.955,
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
},{
ad.NewRoundFrame(ao.Radius,"Squircle-TL-TR",{



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.96,
Size=UDim2.new(1,0,0,20+(ao.Padding*2)),
Visible=ak and true or false
},{
ae("ImageLabel",{
Size=UDim2.new(0,18,0,18),
BackgroundTransparency=1,
Image="rbxassetid://132464694294269",



ImageColor3=Color3.fromHex"#ffffff",
ImageTransparency=.2,
}),
ae("TextLabel",{
Text=ak,



TextColor3=Color3.fromHex"#ffffff",
TextTransparency=.2,
TextSize=16,
AutomaticSize="Y",
FontFace=Font.new(ad.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
BackgroundTransparency=1,
TextTruncate="AtEnd",
Size=UDim2.new(1,ar and-20-(ao.Padding*2),0,0)
}),
ae("UIPadding",{

PaddingLeft=UDim.new(0,ao.Padding+3),
PaddingRight=UDim.new(0,ao.Padding+3),

}),
ae("UIListLayout",{
Padding=UDim.new(0,ao.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
})
}),
aq,
ae("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
})
}),
ar,
})

ao.CodeFrame=as

ad.AddSignal(ap:GetPropertyChangedSignal"TextBounds",function()
aq.Size=UDim2.new(1,0,0,(ap.TextBounds.Y/(an or 1))+((ao.Padding+3)*2))
end)

function ao.Set(at)
ap.Text=ai.run(at)
end

function ao.Destroy()
as:Destroy()
ao=nil
end

ao.Set(aj)

ad.AddSignal(ar.MouseButton1Click,function()
if am then
am()
local at=ad.Icon"check"
ar.Button.ImageLabel.Image=at[1]
ar.Button.ImageLabel.ImageRectSize=at[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=at[2].ImageRectPosition

task.wait(1)
local au=ad.Icon"copy"
ar.Button.ImageLabel.Image=au[1]
ar.Button.ImageLabel.ImageRectSize=au[2].ImageRectSize
ar.Button.ImageLabel.ImageRectOffset=au[2].ImageRectPosition
end
end)
return ao
end


return aa end function a.O()
local aa=a.load'c'local ad=
aa.New


local ae=a.load'N'

local ag={}

function ag.New(ai,aj)
local ak={
__type="Code",
Title=aj.Title,
Code=aj.Code,
OnCopy=aj.OnCopy,
}

local al=not ak.Locked











local am=ae.New(ak.Code,ak.Title,aj.Parent,function()
if al then
local am=ak.Title or"code"
local an,ao=pcall(function()
toclipboard(ak.Code)

if ak.OnCopy then ak.OnCopy()end
end)
if not an then
aj.WindUI:Notify{
Title="Error",
Content="The "..am.." is not copied. Error: "..ao,
Icon="x",
Duration=5,
}
end
end
end,aj.WindUI.UIScale,ak)

function ak.SetCode(an,ao)
am.Set(ao)
ak.Code=ao
end

function ak.Set(an,ao)
return ak.SetCode(ao)
end

function ak.Destroy(an)
am.Destroy()
ak=nil
end

ak.ElementFrame=am.CodeFrame

return ak.__type,ak
end

return ag end function a.P()
local aa=a.load'c'
local ad=aa.New local ae=
aa.Tween

local ag=(cloneref or clonereference or function(ag)return ag end)

local ai=ag(game:GetService"UserInputService")
ag(game:GetService"TouchInputService")
local aj=ag(game:GetService"RunService")
local ak=ag(game:GetService"Players")

local al=aj.RenderStepped
local am=ak.LocalPlayer
local an=am:GetMouse()

local ao=a.load'l'.New
local ap=a.load'm'.New

local aq={
UICorner=9,

}

function aq.Colorpicker(ar,as,at,au)
local av={
__type="Colorpicker",
Title=as.Title,
Desc=as.Desc,
Default=as.Value or as.Default,
Callback=as.Callback,
Transparency=as.Transparency,
UIElements=as.UIElements,

TextPadding=10,
}

function av.SetHSVFromRGB(aw,ax)
local ay,az,aA=Color3.toHSV(ax)
av.Hue=ay
av.Sat=az
av.Vib=aA
end

av:SetHSVFromRGB(av.Default)

local aw=a.load'n'.Init(at)
local ax=aw.Create()

av.ColorpickerFrame=ax

ax.UIElements.Main.Size=UDim2.new(1,0,0,0)



local ay,az,aA=av.Hue,av.Sat,av.Vib

av.UIElements.Title=ad("TextLabel",{
Text=av.Title,
TextSize=20,
FontFace=Font.new(aa.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text"
},
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIPadding",{
PaddingTop=UDim.new(0,av.TextPadding/2),
PaddingLeft=UDim.new(0,av.TextPadding/2),
PaddingRight=UDim.new(0,av.TextPadding/2),
PaddingBottom=UDim.new(0,av.TextPadding/2),
})
})





local aB=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=HueDragHolder,
BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

av.UIElements.SatVibMap=ad("ImageLabel",{
Size=UDim2.fromOffset(160,158),
Position=UDim2.fromOffset(0,40+av.TextPadding),
Image="rbxassetid://4155801252",
BackgroundColor3=Color3.fromHSV(ay,1,1),
BackgroundTransparency=0,
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
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
ad("UIGradient",{
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

aB,
})

av.UIElements.Inputs=ad("Frame",{
AutomaticSize="XY",
Size=UDim2.new(0,0,0,0),
Position=UDim2.fromOffset(av.Transparency and 240 or 210,40+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main
},{
ad("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Vertical",
})
})





local b=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=av.Transparency,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(85,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
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
ad("UIGradient",{
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







b,
})

local d=ad("Frame",{
BackgroundColor3=av.Default,
Size=UDim2.fromScale(1,1),
BackgroundTransparency=0,
ZIndex=9,
},{
ad("UICorner",{
CornerRadius=UDim.new(0,8),
}),
})

ad("ImageLabel",{
Image="http://www.roblox.com/asset/?id=14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Position=UDim2.fromOffset(0,208+av.TextPadding),
Size=UDim2.fromOffset(75,24),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
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
ad("UIGradient",{
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

local f={}

for g=0,1,0.1 do
table.insert(f,ColorSequenceKeypoint.new(g,Color3.fromHSV(g,1,1)))
end

local g=ad("UIGradient",{
Color=ColorSequence.new(f),
Rotation=90,
})

local h=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
})

local j=ad("Frame",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
Parent=h,


BackgroundColor3=av.Default
},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})
})

local l=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(180,40+av.TextPadding),
Parent=ax.UIElements.Main,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
g,
h,
})


function CreateNewInput(m,p)
local r=ap(m,nil,av.UIElements.Inputs)

ad("TextLabel",{
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
Parent=r.Frame,
Text=m,
})

ad("UIScale",{
Parent=r,
Scale=.85,
})

r.Frame.Frame.TextBox.Text=p
r.Size=UDim2.new(0,150,0,42)

return r
end

local function ToRGB(m)
return{
R=math.floor(m.R*255),
G=math.floor(m.G*255),
B=math.floor(m.B*255)
}
end

local m=CreateNewInput("Hex","#"..av.Default:ToHex())

local p=CreateNewInput("Red",ToRGB(av.Default).R)
local r=CreateNewInput("Green",ToRGB(av.Default).G)
local u=CreateNewInput("Blue",ToRGB(av.Default).B)
local v
if av.Transparency then
v=CreateNewInput("Alpha",((1-av.Transparency)*100).."%")
end

local x=ad("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="Y",
Position=UDim2.new(0,0,0,254+av.TextPadding),
BackgroundTransparency=1,
Parent=ax.UIElements.Main,
LayoutOrder=4,
},{
ad("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
}),






})

local z={
{
Title="Cancel",
Variant="Secondary",
Callback=function()end
},
{
Title="Apply",
Icon="chevron-right",
Variant="Primary",
Callback=function()au(Color3.fromHSV(av.Hue,av.Sat,av.Vib),av.Transparency)end
}
}

for A,B in next,z do
local C=ao(B.Title,B.Icon,B.Callback,B.Variant,x,ax,false)
C.Size=UDim2.new(0.5,-3,0,40)
C.AutomaticSize="None"
end



local A,B,C
if av.Transparency then
local F=ad("Frame",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.fromOffset(0,0),
BackgroundTransparency=1,
})

B=ad("ImageLabel",{
Size=UDim2.new(0,14,0,14),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0,0),
ThemeTag={
BackgroundColor3="Text",
},
Parent=F,

},{
ad("UIStroke",{
Thickness=2,
Transparency=.1,
ThemeTag={
Color="Text",
},
}),
ad("UICorner",{
CornerRadius=UDim.new(1,0),
})

})

C=ad("Frame",{
Size=UDim2.fromScale(1,1),
},{
ad("UIGradient",{
Transparency=NumberSequence.new{
NumberSequenceKeypoint.new(0,0),
NumberSequenceKeypoint.new(1,1),
},
Rotation=270,
}),
ad("UICorner",{
CornerRadius=UDim.new(0,6),
}),
})

A=ad("Frame",{
Size=UDim2.fromOffset(6,192),
Position=UDim2.fromOffset(210,40+av.TextPadding),
Parent=ax.UIElements.Main,
BackgroundTransparency=1,
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
ad("ImageLabel",{
Image="rbxassetid://14204231522",
ImageTransparency=0.45,
ScaleType=Enum.ScaleType.Tile,
TileSize=UDim2.fromOffset(40,40),
BackgroundTransparency=1,
Size=UDim2.fromScale(1,1),
},{
ad("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
C,
F,
})
end

function av.Round(F,G,H)
if H==0 then
return math.floor(G)
end
G=tostring(G)
return G:find"%."and tonumber(G:sub(1,G:find"%."+H))or G
end


function av.Update(F,G,H)
if G then ay,az,aA=Color3.toHSV(G)else ay,az,aA=av.Hue,av.Sat,av.Vib end

av.UIElements.SatVibMap.BackgroundColor3=Color3.fromHSV(ay,1,1)
aB.Position=UDim2.new(az,0,1-aA,0)
aB.BackgroundColor3=Color3.fromHSV(ay,az,aA)
d.BackgroundColor3=Color3.fromHSV(ay,az,aA)
j.BackgroundColor3=Color3.fromHSV(ay,1,1)
j.Position=UDim2.new(0.5,0,ay,0)

m.Frame.Frame.TextBox.Text="#"..Color3.fromHSV(ay,az,aA):ToHex()
p.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).R
r.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).G
u.Frame.Frame.TextBox.Text=ToRGB(Color3.fromHSV(ay,az,aA)).B

if H or av.Transparency then
d.BackgroundTransparency=av.Transparency or H
C.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundColor3=Color3.fromHSV(ay,az,aA)
B.BackgroundTransparency=av.Transparency or H
B.Position=UDim2.new(0.5,0,1-av.Transparency or H,0)
v.Frame.Frame.TextBox.Text=av:Round((1-av.Transparency or H)*100,0).."%"
end
end

av:Update(av.Default,av.Transparency)




local function GetRGB()
local F=Color3.fromHSV(av.Hue,av.Sat,av.Vib)
return{R=math.floor(F.r*255),G=math.floor(F.g*255),B=math.floor(F.b*255)}
end



local function clamp(F,G,H)
return math.clamp(tonumber(F)or 0,G,H)
end

aa.AddSignal(m.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=m.Frame.Frame.TextBox.Text:gsub("#","")
local H,J=pcall(Color3.fromHex,G)
if H and typeof(J)=="Color3"then
av.Hue,av.Sat,av.Vib=Color3.toHSV(J)
av:Update()
av.Default=J
end
end
end)

local function updateColorFromInput(F,G)
aa.AddSignal(F.Frame.Frame.TextBox.FocusLost,function(H)
if H then
local J=F.Frame.Frame.TextBox
local L=GetRGB()
local M=clamp(J.Text,0,255)
J.Text=tostring(M)

L[G]=M
local N=Color3.fromRGB(L.R,L.G,L.B)
av.Hue,av.Sat,av.Vib=Color3.toHSV(N)
av:Update()
end
end)
end

updateColorFromInput(p,"R")
updateColorFromInput(r,"G")
updateColorFromInput(u,"B")

if av.Transparency then
aa.AddSignal(v.Frame.Frame.TextBox.FocusLost,function(F)
if F then
local G=v.Frame.Frame.TextBox
local H=clamp(G.Text,0,100)
G.Text=tostring(H)

av.Transparency=1-H*0.01
av:Update(nil,av.Transparency)
end
end)
end



local F=av.UIElements.SatVibMap
aa.AddSignal(F.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=F.AbsolutePosition.X
local J=H+F.AbsoluteSize.X
local L=math.clamp(an.X,H,J)

local M=F.AbsolutePosition.Y
local N=M+F.AbsoluteSize.Y
local O=math.clamp(an.Y,M,N)

av.Sat=(L-H)/(J-H)
av.Vib=1-((O-M)/(N-M))
av:Update()

al:Wait()
end
end
end)

aa.AddSignal(l.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=l.AbsolutePosition.Y
local J=H+l.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Hue=((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)

if av.Transparency then
aa.AddSignal(A.InputBegan,function(G)
if G.UserInputType==Enum.UserInputType.MouseButton1 or G.UserInputType==Enum.UserInputType.Touch then
while ai:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)do
local H=A.AbsolutePosition.Y
local J=H+A.AbsoluteSize.Y
local L=math.clamp(an.Y,H,J)

av.Transparency=1-((L-H)/(J-H))
av:Update()

al:Wait()
end
end
end)
end

return av
end

function aq.New(ar,as)
local at={
__type="Colorpicker",
Title=as.Title or"Colorpicker",
Desc=as.Desc or nil,
Locked=as.Locked or false,
LockedTitle=as.LockedTitle,
Default=as.Default or Color3.new(1,1,1),
Callback=as.Callback or function()end,

UIScale=as.UIScale,
Transparency=as.Transparency,
UIElements={}
}

local au=true



at.ColorpickerFrame=a.load'B'{
Title=at.Title,
Desc=at.Desc,
Parent=as.Parent,
TextOffset=40,
Hover=false,
Tab=as.Tab,
Index=as.Index,
Window=as.Window,
ElementTable=at,
ParentConfig=as,
}

at.UIElements.Colorpicker=aa.NewRoundFrame(aq.UICorner,"Squircle",{
ImageTransparency=0,
Active=true,
ImageColor3=at.Default,
Parent=at.ColorpickerFrame.UIElements.Main,
Size=UDim2.new(0,26,0,26),
AnchorPoint=Vector2.new(1,0),
Position=UDim2.new(1,0,0,0),
ZIndex=2
},nil,true)


function at.Lock(av)
at.Locked=true
au=false
return at.ColorpickerFrame:Lock(at.LockedTitle)
end
function at.Unlock(av)
at.Locked=false
au=true
return at.ColorpickerFrame:Unlock()
end

if at.Locked then
at:Lock()
end


function at.Update(av,aw,ax)
at.UIElements.Colorpicker.ImageTransparency=ax or 0
at.UIElements.Colorpicker.ImageColor3=aw
at.Default=aw
if ax then
at.Transparency=ax
end
end

function at.Set(av,aw,ax)
return at:Update(aw,ax)
end

aa.AddSignal(at.UIElements.Colorpicker.MouseButton1Click,function()
if au then
aq:Colorpicker(at,as.Window,function(av,aw)
at:Update(av,aw)
at.Default=av
at.Transparency=aw
aa.SafeCallback(at.Callback,av,aw)
end).ColorpickerFrame:Open()
end
end)

return at.__type,at
end

return aq end function a.Q()
local aa=a.load'c'
local ad=aa.New
local ae=aa.Tween

local ag={}

function ag.New(ai,aj)
local ak={
__type="Section",
Title=aj.Title or"Section",
Desc=aj.Desc,
Icon=aj.Icon,
IconThemed=aj.IconThemed,
TextXAlignment=aj.TextXAlignment or"Left",
TextSize=aj.TextSize or 19,
DescTextSize=aj.DescTextSize or 16,
Box=aj.Box or false,
BoxBorder=aj.BoxBorder or false,
FontWeight=aj.FontWeight or Enum.FontWeight.SemiBold,
DescFontWeight=aj.DescFontWeight or Enum.FontWeight.Medium,
TextTransparency=aj.TextTransparency or 0.05,
DescTextTransparency=aj.DescTextTransparency or 0.4,
Opened=aj.Opened or false,
UIElements={},

HeaderSize=42,
IconSize=20,
Padding=10,

Elements={},

Expandable=false,
}

local al


function ak.SetIcon(am,an)
ak.Icon=an or nil
if al then al:Destroy()end
if an then
al=aa.Image(
an,
an..":"..ak.Title,
0,
aj.Window.Folder,
ak.__type,
true,
ak.IconThemed,
"SectionIcon"
)
al.Size=UDim2.new(0,ak.IconSize,0,ak.IconSize)
end
end

local am=ad("Frame",{
Size=UDim2.new(0,ak.IconSize,0,ak.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ad("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=aa.Icon"chevron-down"[1],
ImageRectSize=aa.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=aa.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageTransparency="SectionExpandIconTransparency",
ImageColor3="SectionExpandIcon",
},
})
})


if ak.Icon then
ak:SetIcon(ak.Icon)
end

local an=ad("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ad("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment=ak.TextXAlignment,
VerticalAlignment="Center",
Padding=UDim.new(0,4)
})
})

local ao,ap

local function createTitle(aq,ar)
return ad("TextLabel",{
BackgroundTransparency=1,
TextXAlignment=ak.TextXAlignment,
AutomaticSize="Y",
TextSize=ar=="Title"and ak.TextSize or ak.DescTextSize,
TextTransparency=ar=="Title"and ak.TextTransparency or ak.DescTextTransparency,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(aa.Font,ar=="Title"and ak.FontWeight or ak.DescFontWeight),


Text=aq,
Size=UDim2.new(
1,
0,
0,
0
),
TextWrapped=true,
Parent=an,
})
end

ao=createTitle(ak.Title,"Title")
if ak.Desc then
ap=createTitle(ak.Desc,"Desc")
end

local function UpdateTitleSize()
local aq=0
if al then
aq=aq-(ak.IconSize+8)
end
if am.Visible then
aq=aq-(ak.IconSize+8)
end
an.Size=UDim2.new(1,aq,0,0)
end


local aq=aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
Parent=aj.Parent,
ClipsDescendants=true,
AutomaticSize="Y",
ThemeTag={
ImageTransparency=ak.Box and"SectionBoxBackgroundTransparency"or nil,
ImageColor3="SectionBoxBackground",
},
ImageTransparency=not ak.Box and 1 or nil,
},{
aa.NewRoundFrame(aj.Window.ElementConfig.UICorner,aj.Window.NewElements and"Glass-1"or"SquircleOutline",{
Size=UDim2.new(1,0,1,0),

ThemeTag={
ImageTransparency="SectionBoxBorderTransparency",
ImageColor3="SectionBoxBorder",
},
Visible=ak.Box and ak.BoxBorder,
Name="Outline",
}),
ad("TextButton",{
Size=UDim2.new(1,0,0,ak.Expandable and 0 or(not ap and ak.HeaderSize or 0)),
BackgroundTransparency=1,
AutomaticSize=(not ak.Expandable or ap)and"Y"or nil,
Text="",
Name="Top",
},{
ak.Box and ad("UIPadding",{
PaddingTop=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
PaddingBottom=UDim.new(0,aj.Window.ElementConfig.UIPadding+(aj.Window.NewElements and 4 or 0)),
})or nil,
al,
an,
ad("UIListLayout",{
Padding=UDim.new(0,8),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
}),
am,
}),
ad("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=false,
Position=UDim2.new(0,0,0,ak.HeaderSize)
},{
ak.Box and ad("UIPadding",{
PaddingLeft=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingRight=UDim.new(0,aj.Window.ElementConfig.UIPadding),
PaddingBottom=UDim.new(0,aj.Window.ElementConfig.UIPadding),
})or nil,
ad("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,aj.Tab.Gap),
VerticalAlignment="Top",
}),
})
})





ak.ElementFrame=aq

if ap then
aq.Top:GetPropertyChangedSignal"AbsoluteSize":Connect(function()
aq.Content.Position=UDim2.new(0,0,0,aq.Top.AbsoluteSize.Y/aj.UIScale)

if ak.Opened then ak:Open(true)else ak.Close(true)end
end)
end


local ar=aj.ElementsModule

ar.Load(ak,aq.Content,ar.Elements,aj.Window,aj.WindUI,function()
if not ak.Expandable then
ak.Expandable=true
am.Visible=true
UpdateTitleSize()
end
end,ar,aj.UIScale,aj.Tab)


UpdateTitleSize()

function ak.SetTitle(as,at)
ak.Title=at
ao.Text=at
end

function ak.SetDesc(as,at)
ak.Desc=at
if not ap then
ap=createTitle(at,"Desc")
end
ap.Text=at
end

function ak.Destroy(as)
for at,au in next,ak.Elements do
au:Destroy()
end








aq:Destroy()
end

function ak.Open(as,at)
if ak.Expandable then
ak.Opened=true
if at then
aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y)/aj.UIScale+(aq.Content.AbsoluteSize.Y/aj.UIScale))
am.ImageLabel.Rotation=180
else
ae(aq,0.33,{
Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y)/aj.UIScale+(aq.Content.AbsoluteSize.Y/aj.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ae(am.ImageLabel,0.2,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end
function ak.Close(as,at)
if ak.Expandable then
ak.Opened=false
if at then
aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y/aj.UIScale))
am.ImageLabel.Rotation=0
else
ae(aq,0.26,{
Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,(aq.Top.AbsoluteSize.Y/aj.UIScale))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ae(am.ImageLabel,0.2,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
end

aa.AddSignal(aq.Top.MouseButton1Click,function()
if ak.Expandable then
if ak.Opened then
ak:Close()
else
ak:Open()
end
end
end)

aa.AddSignal(aq.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ak.Opened then
ak:Open(true)
end
end)

task.spawn(function()
task.wait(0.02)
if ak.Expandable then








aq.Size=UDim2.new(aq.Size.X.Scale,aq.Size.X.Offset,0,aq.Top.AbsoluteSize.Y/aj.UIScale)
aq.AutomaticSize="None"
aq.Top.Size=UDim2.new(1,0,0,(not ap and ak.HeaderSize or 0))
aq.Top.AutomaticSize=(not ak.Expandable or ap)and"Y"or"None"
aq.Content.Visible=true
end
if ak.Opened then
ak:Open()
end

end)

return ak.__type,ak
end

return ag end function a.R()

local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj=ad("Frame",{
Parent=ai.Parent,
Size=ai.ParentType~="Group"and UDim2.new(1,-7,0,7*(ai.Columns or 1))or UDim2.new(0,7*(ai.Columns or 1),0,0),
BackgroundTransparency=1,
})

return"Space",{__type="Space",ElementFrame=aj}
end

return ae end function a.S()
local aa=a.load'c'
local ad=aa.New

local ae={}

local function ParseAspectRatio(ag)
if type(ag)=="string"then
local ai,aj=ag:match"(%d+):(%d+)"
if ai and aj then
return tonumber(ai)/tonumber(aj)
end
elseif type(ag)=="number"then
return ag
end
return nil
end

function ae.New(ag,ai)
local aj={
__type="Image",
Image=ai.Image or"",
AspectRatio=ai.AspectRatio or"16:9",
Radius=ai.Radius or ai.Window.ElementConfig.UICorner,
}
local ak=aa.Image(
aj.Image,
aj.Image,
aj.Radius,
ai.Window.Folder,
"Image",
false
)
if ak and ak.Parent then
ak.Parent=ai.Parent
ak.Size=UDim2.new(1,0,0,0)
ak.BackgroundTransparency=1












local al=ParseAspectRatio(aj.AspectRatio)
local am

if al then
am=ad("UIAspectRatioConstraint",{
Parent=ak,
AspectRatio=al,
AspectType="ScaleWithParentSize",
DominantAxis="Width"
})
end

function aj.Destroy(an)
ak:Destroy()
end
end

return aj.__type,aj
end

return ae end function a.T()
local aa=a.load'c'
local ad=aa.New

local ae={}

function ae.New(ag,ai)
local aj={
__type="Group",
Elements={}
}

local ak=ad("Frame",{
Size=UDim2.new(1,0,0,0),
BackgroundTransparency=1,
AutomaticSize="Y",
Parent=ai.Parent,
},{
ad("UIListLayout",{
FillDirection="Horizontal",
HorizontalAlignment="Center",

Padding=UDim.new(0,ai.Tab and ai.Tab.Gap or(Window.NewElements and 1 or 6))
}),
})

local al=ai.ElementsModule
al.Load(
aj,
ak,
al.Elements,
ai.Window,
ai.WindUI,
function(am,an)
local ao=ai.Tab and ai.Tab.Gap or(ai.Window.NewElements and 1 or 6)

local ap={}
local aq=0

for ar,as in next,an do
if as.__type=="Space"then
aq=aq+(as.ElementFrame.Size.X.Offset or 6)
elseif as.__type=="Divider"then
aq=aq+(as.ElementFrame.Size.X.Offset or 1)
else
table.insert(ap,as)
end
end

local ar=#ap
if ar==0 then return end

local as=1/ar

local at=ao*(ar-1)

local au=-(at+aq)

local av=math.floor(au/ar)
local aw=au-(av*ar)

for ax,ay in next,ap do
local az=av
if ax<=math.abs(aw)then
az=az-1
end

if ay.ElementFrame then
ay.ElementFrame.Size=UDim2.new(as,az,1,0)
end
end
end,
al,
ai.UIScale,
ai.Tab
)



return aj.__type,aj
end

return ae end function a.U()
return{
Elements={
Paragraph=a.load'C',
Button=a.load'D',
Toggle=a.load'F',
Slider=a.load'G',
Keybind=a.load'H',
Input=a.load'I',
Dropdown=a.load'L',
Code=a.load'O',
Colorpicker=a.load'P',
Section=a.load'Q',
Divider=a.load'J',
Space=a.load'R',
Image=a.load'S',
Group=a.load'T',

},
Load=function(aa,ad,ae,ag,ai,aj,ak,al,am)
for an,ao in next,ae do
aa[an]=function(ap,aq)
aq=aq or{}
aq.Tab=am or aa
aq.ParentType=aa.__type
aq.ParentTable=aa
aq.Index=#aa.Elements+1
aq.GlobalIndex=#ag.AllElements+1
aq.Parent=ad
aq.Window=ag
aq.WindUI=ai
aq.UIScale=al
aq.ElementsModule=ak local

ar, as=ao:New(aq)

if aq.Flag and typeof(aq.Flag)=="string"then
if ag.CurrentConfig then
ag.CurrentConfig:Register(aq.Flag,as)

if ag.PendingConfigData and ag.PendingConfigData[aq.Flag]then
local at=ag.PendingConfigData[aq.Flag]

local au=ag.ConfigManager
if au.Parser[at.__type]then
task.defer(function()
local av,aw=pcall(function()
au.Parser[at.__type].Load(as,at)
end)

if av then
ag.PendingConfigData[aq.Flag]=nil
else
warn(
"[ WindUI ] Failed to apply pending config for '"
..aq.Flag
.."': "
..tostring(aw)
)
end
end)
end
end
else
ag.PendingFlags=ag.PendingFlags or{}
ag.PendingFlags[aq.Flag]=as
end
end

local at
for au,av in next,as do
if typeof(av)=="table"and au~="ElementFrame"and au:match"Frame$"then
at=av
break
end
end

if at then
as.ElementFrame=at.UIElements.Main
function as.SetTitle(au,av)
return at.SetTitle and at:SetTitle(av)
end
function as.SetDesc(au,av)
return at.SetDesc and at:SetDesc(av)
end
function as.SetImage(au,av,aw)
return at.SetImage and at:SetImage(av,aw)
end
function as.SetThumbnail(au,av,aw)
return at.SetThumbnail and at:SetThumbnail(av,aw)
end
function as.Highlight(au)
at:Highlight()
end
function as.Destroy(au)
at:Destroy()

table.remove(ag.AllElements,aq.GlobalIndex)
table.remove(aa.Elements,aq.Index)
table.remove(am.Elements,aq.Index)
aa:UpdateAllElementShapes(aa)
end
end

ag.AllElements[aq.Index]=as
aa.Elements[aq.Index]=as
if am then
am.Elements[aq.Index]=as
end

if ag.NewElements then
aa:UpdateAllElementShapes(aa)
end

if aj then
aj(as,aa.Elements)
end
return as
end
end
function aa.UpdateAllElementShapes(an,ao)
for ap,aq in next,ao.Elements do
local ar
for as,at in pairs(aq)do
if typeof(at)=="table"and as:match"Frame$"then
ar=at
break
end
end

if ar then

ar.Index=ap
if ar.UpdateShape then

ar.UpdateShape(ao)
end
end
end
end
end,
}end function a.V()

local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=game:GetService"Players"

aa(game:GetService"UserInputService")
local ae=ad.LocalPlayer:GetMouse()

local ag=a.load'c'
local ai=ag.New
local aj=ag.Tween

local ak=a.load'A'.New
local al=a.load'w'.New



local am={
Tabs={},
Containers={},
SelectedTab=nil,
TabCount=0,
ToolTipParent=nil,
TabHighlight=nil,

OnChangeFunc=function(am)end,
}

function am.Init(an,ao,ap,aq)
Window=an
WindUI=ao
am.ToolTipParent=ap
am.TabHighlight=aq
return am
end

function am.New(an,ao)
local ap={
__type="Tab",
Title=an.Title or"Tab",
Desc=an.Desc,
Icon=an.Icon,
IconColor=an.IconColor,
IconShape=an.IconShape,
IconThemed=an.IconThemed,
Locked=an.Locked,
ShowTabTitle=an.ShowTabTitle,
TabTitleAlign=an.TabTitleAlign or"Left",
CustomEmptyPage=(an.CustomEmptyPage and next(an.CustomEmptyPage)~=nil)and an.CustomEmptyPage
or{Icon="lucide:frown",IconSize=48,Title="This tab is Empty",Desc=nil},
Border=an.Border,
Selected=false,
Index=nil,
Parent=an.Parent,
UIElements={},
Elements={},
ContainerFrame=nil,
UICorner=Window.UICorner-(Window.UIPadding/2),

Gap=Window.NewElements and 1 or 6,

TabPaddingX=4+(Window.UIPadding/2),
TabPaddingY=3+(Window.UIPadding/2),
TitlePaddingY=0,
}

if ap.IconShape then
ap.TabPaddingX=2+(Window.UIPadding/4)
ap.TabPaddingY=2+(Window.UIPadding/4)
ap.TitlePaddingY=2+(Window.UIPadding/4)
end

am.TabCount=am.TabCount+1

local aq=am.TabCount
ap.Index=aq

ap.UIElements.Main=ag.NewRoundFrame(ap.UICorner,"Squircle",{
BackgroundTransparency=1,
Size=UDim2.new(1,-7,0,0),
AutomaticSize="Y",
Parent=an.Parent,
ThemeTag={
ImageColor3="TabBackground",
},
ImageTransparency=1,
},{
ag.NewRoundFrame(ap.UICorner,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="TabBorder",
},
ImageTransparency=1,
Name="Outline",
}),
ag.NewRoundFrame(ap.UICorner,"Squircle",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Frame",
},{
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,2+(Window.UIPadding/2)),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ai("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="TabTitle",
},
TextTransparency=not ap.Locked and 0.4 or 0.7,
TextSize=15,
Size=UDim2.new(1,0,0,0),
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
TextWrapped=true,
RichText=true,
AutomaticSize="Y",
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,ap.TitlePaddingY),
PaddingBottom=UDim.new(0,ap.TitlePaddingY),
}),
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,ap.TabPaddingY),
PaddingLeft=UDim.new(0,ap.TabPaddingX),
PaddingRight=UDim.new(0,ap.TabPaddingX),
PaddingBottom=UDim.new(0,ap.TabPaddingY),
}),
}),
},true)

local ar=0
local as
local at

if ap.Icon then
as=ag.Image(
ap.Icon,
ap.Icon..":"..ap.Title,
0,
Window.Folder,
ap.__type,
ap.IconColor and false or true,
ap.IconThemed,
"TabIcon"
)
as.Size=UDim2.new(0,16,0,16)
if ap.IconColor then
as.ImageLabel.ImageColor3=ap.IconColor
end
if not ap.IconShape then
as.Parent=ap.UIElements.Main.Frame
ap.UIElements.Icon=as
as.ImageLabel.ImageTransparency=not ap.Locked and 0 or 0.7
ar=-18-(Window.UIPadding/2)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ar,0,0)
elseif ap.IconColor then
ag.NewRoundFrame(
ap.IconShape~="Circle"and(ap.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
"Squircle",
{
Size=UDim2.new(0,26,0,26),
ImageColor3=ap.IconColor,
Parent=ap.UIElements.Main.Frame,
},
{
as,
ag.NewRoundFrame(
ap.IconShape~="Circle"and(ap.UICorner+5-(2+(Window.UIPadding/4)))or 9999,
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
as.AnchorPoint=Vector2.new(0.5,0.5)
as.Position=UDim2.new(0.5,0,0.5,0)
as.ImageLabel.ImageTransparency=0
as.ImageLabel.ImageColor3=ag.GetTextColorForHSB(ap.IconColor,0.68)
ar=-28-(Window.UIPadding/2)
ap.UIElements.Main.Frame.TextLabel.Size=UDim2.new(1,ar,0,0)
end

at=
ag.Image(ap.Icon,ap.Icon..":"..ap.Title,0,Window.Folder,ap.__type,true,ap.IconThemed)
at.Size=UDim2.new(0,16,0,16)
at.ImageLabel.ImageTransparency=not ap.Locked and 0 or 0.7
ar=-30
end

ap.UIElements.ContainerFrame=ai("ScrollingFrame",{
Size=UDim2.new(1,0,1,ap.ShowTabTitle and-((Window.UIPadding*2.4)+12)or 0),
BackgroundTransparency=1,
ScrollBarThickness=0,
ElasticBehavior="Never",
CanvasSize=UDim2.new(0,0,0,0),
AnchorPoint=Vector2.new(0,1),
Position=UDim2.new(0,0,1,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
},{
ai("UIPadding",{
PaddingTop=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingLeft=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingRight=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
PaddingBottom=UDim.new(0,not Window.HidePanelBackground and 20 or 10),
}),
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,ap.Gap),
HorizontalAlignment="Center",
}),
})

ap.UIElements.ContainerFrameCanvas=ai("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Visible=false,
Parent=Window.UIElements.MainBar,
ZIndex=5,
},{
ap.UIElements.ContainerFrame,
ai("Frame",{
Size=UDim2.new(1,0,0,((Window.UIPadding*2.4)+12)),
BackgroundTransparency=1,
Visible=ap.ShowTabTitle or false,
Name="TabTitle",
},{
at,
ai("TextLabel",{
Text=ap.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=20,
TextTransparency=0.1,
Size=UDim2.new(0,0,1,0),
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),
RichText=true,
LayoutOrder=2,
TextXAlignment="Left",
BackgroundTransparency=1,
AutomaticSize="X",
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,20),
PaddingLeft=UDim.new(0,20),
PaddingRight=UDim.new(0,20),
PaddingBottom=UDim.new(0,20),
}),
ai("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,10),
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment=ap.TabTitleAlign,
}),
}),
ai("Frame",{
Size=UDim2.new(1,0,0,1),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
Position=UDim2.new(0,0,0,((Window.UIPadding*2.4)+12)),
Visible=ap.ShowTabTitle or false,
}),
})

table.insert(am.Containers,ap.UIElements.ContainerFrameCanvas)
table.insert(am.Tabs,ap)

ap.ContainerFrame=ap.UIElements.ContainerFrameCanvas

ag.AddSignal(ap.UIElements.Main.MouseButton1Click,function()
if not ap.Locked then
am:SelectTab(aq)
end
end)

if Window.ScrollBarEnabled then
al(ap.UIElements.ContainerFrame,ap.UIElements.ContainerFrameCanvas,Window,3)
end

local au
local av
local aw
local ax=false

if ap.Desc then
ag.AddSignal(ap.UIElements.Main.InputBegan,function()
ax=true
av=task.spawn(function()
task.wait(0.35)
if ax and not au then
au=ak(ap.Desc,am.ToolTipParent,true)
au.Container.AnchorPoint=Vector2.new(0.5,0.5)

local function updatePosition()
if au then
au.Container.Position=UDim2.new(0,ae.X,0,ae.Y-4)
end
end

updatePosition()
aw=ae.Move:Connect(updatePosition)
au:Open()
end
end)
end)
end

ag.AddSignal(ap.UIElements.Main.MouseEnter,function()
if not ap.Locked then
ag.SetThemeTag(ap.UIElements.Main.Frame,{
ImageTransparency="TabBackgroundHoverTransparency",
ImageColor3="TabBackgroundHover",
},0.1)
end
end)

ag.AddSignal(ap.UIElements.Main.InputEnded,function()
if ap.Desc then
ax=false
if av then
task.cancel(av)
av=nil
end
if aw then
aw:Disconnect()
aw=nil
end
if au then
au:Close()
au=nil
end
end

if not ap.Locked then
ag.SetThemeTag(ap.UIElements.Main.Frame,{
ImageTransparency="TabBorderTransparency",
},0.1)
end
end)

function ap.ScrollToTheElement(ay,az)
ap.UIElements.ContainerFrame.ScrollingEnabled=false

ag.Tween(ap.UIElements.ContainerFrame,0.45,{
CanvasPosition=Vector2.new(
0,
ap.Elements[az].ElementFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.AbsolutePosition.Y
-ap.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.spawn(function()
task.wait(0.48)

if ap.Elements[az].Highlight then
ap.Elements[az]:Highlight()
end
ap.UIElements.ContainerFrame.ScrollingEnabled=true
end)

return ap
end

local ay=a.load'U'

ay.Load(
ap,
ap.UIElements.ContainerFrame,
ay.Elements,
Window,
WindUI,
nil,
ay,
ao
)

function ap.SubTabGroup(az)
local aA={}
local aB={}
local b=1

local d=4
local f=42
local g=54
local h=6
local j=76

local function GetButtonWidth(l)
if l<=2 then
return 72
elseif l==3 then
return 66
else
return 60
end
end

local l=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=ap.UIElements.ContainerFrame,
},{
ai("UIListLayout",{
Padding=UDim.new(0,4),
SortOrder="LayoutOrder",
}),
})

local m=ai("Frame",{
Size=UDim2.new(1,0,0,g),
BackgroundTransparency=1,
Parent=l,
})

local p=ag.NewRoundFrame(999,"Squircle",{
Name="NavigationBar",
Size=UDim2.new(0,0,0,g),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.93,
Parent=m,
},{
ag.NewRoundFrame(999,"Glass-1.4",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.82,
}),
ag.NewRoundFrame(999,"Squircle",{
Size=UDim2.new(1,-2,1,-2),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Name="InnerGlass",
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.965,
}),
ai("Frame",{
Name="TopLine",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.965,
Size=UDim2.new(1,-20,0,1),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
},{
ai("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),
})

local r=ai("Frame",{
Name="ButtonsWrap",
Size=UDim2.new(0,0,0,f),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
Parent=p,
})

local u=ag.NewRoundFrame(999,"Squircle",{
Name="ActivePill",
Size=UDim2.new(0,j-4,0,f-4),
Position=UDim2.new(0,2,0,2),
ThemeTag={
ImageColor3="Accent",
},
ImageTransparency=0.06,
Visible=false,
Parent=r,
},{
ag.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.86,
}),
ai("Frame",{
Name="TopLine",
BackgroundColor3=Color3.new(1,1,1),
BackgroundTransparency=0.96,
Size=UDim2.new(1,-18,0,1),
Position=UDim2.new(0.5,0,0,1),
AnchorPoint=Vector2.new(0.5,0),
},{
ai("UICorner",{
CornerRadius=UDim.new(0,999),
}),
}),
})

local v=ai("Frame",{
Name="ItemsFrame",
BackgroundTransparency=1,
Size=UDim2.new(0,0,0,f),
Parent=r,
},{
ai("UIListLayout",{
Padding=UDim.new(0,d),
FillDirection="Horizontal",
HorizontalAlignment="Left",
VerticalAlignment="Center",
SortOrder="LayoutOrder",
}),
})

local x=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=l,
},{
ai("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
}),
})

local function UpdateBarSize()
local z=#aB
if z<=0 then
p.Size=UDim2.new(0,0,0,g)
r.Size=UDim2.new(0,0,0,f)
v.Size=UDim2.new(0,0,0,f)
u.Visible=false
return
end

j=GetButtonWidth(z)

local A=(z*j)+(math.max(z-1,0)*d)

for B,C in ipairs(aB)do
C.Button.Size=UDim2.new(0,j,0,f)
end

u.Size=UDim2.new(0,j-4,0,f-4)
p.Size=UDim2.new(0,A+(h*2),0,g)
r.Size=UDim2.new(0,A,0,f)
v.Size=UDim2.new(0,A,0,f)
u.Visible=true
end

local function MoveActivePill(z,A)
local B=((z-1)*(j+d))+2

if A then
u.Position=UDim2.new(0,B,0,2)
else
aj(
u,
0.22,
{Position=UDim2.new(0,B,0,2)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end

local function SetSubTab(z,A)
b=z
MoveActivePill(z,A)

for B,C in ipairs(aB)do
local F=(B==z)
C.Page.Visible=F

if A then
C.Label.TextTransparency=F and 0 or 0.22
if C.Icon then
C.Icon.ImageTransparency=F and 0 or 0.22
end
else
aj(
C.Label,
0.18,
{TextTransparency=F and 0 or 0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if C.Icon then
aj(
C.Icon,
0.18,
{ImageTransparency=F and 0 or 0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end
end

function aA.AddSubTab(z,A,B)
local C=setmetatable({
Title=A,
Name=A,
__type="Tab",
Elements={},
UIElements={},
},{__index=ap})

local F=(#aB==0)

local G=ai("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=F,
Parent=x,
},{
ai("UIListLayout",{
Padding=UDim.new(0,ap.Gap),
SortOrder="LayoutOrder",
}),
ai("UIPadding",{
PaddingTop=UDim.new(0,0),
PaddingLeft=UDim.new(0,0),
PaddingRight=UDim.new(0,0),
PaddingBottom=UDim.new(0,0),
}),
})

local H=B and ag.Icon(B)

local J=H and ai("ImageLabel",{
Name="Icon",
Image=H[1],
ImageRectOffset=H[2].ImageRectPosition,
ImageRectSize=H[2].ImageRectSize,
Size=UDim2.new(0,16,0,16),
BackgroundTransparency=1,
ImageColor3=Color3.new(1,1,1),
ImageTransparency=F and 0 or 0.22,
LayoutOrder=1,
})or nil

local L=ai("TextLabel",{
Name="Label",
Text=A,
Size=UDim2.new(1,-8,0,18),
BackgroundTransparency=1,
TextXAlignment="Center",
TextYAlignment="Center",
TextWrapped=false,
TextTruncate="AtEnd",
TextSize=10,
TextColor3=Color3.new(1,1,1),
TextTransparency=F and 0 or 0.22,
FontFace=Font.new(ag.Font,Enum.FontWeight.SemiBold),
LayoutOrder=2,
})

local M=ai("TextButton",{
Name="NavButton",
Size=UDim2.new(0,j,0,f),
BackgroundTransparency=1,
AutoButtonColor=false,
Text="",
Parent=v,
},{
ai("Frame",{
Name="Content",
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ai("UIListLayout",{
FillDirection="Vertical",
HorizontalAlignment="Center",
VerticalAlignment="Center",
Padding=UDim.new(0,1),
SortOrder="LayoutOrder",
}),
J,
L,
}),
})

C.UIElements.ContainerFrame=G
C.UIElements.Main=M

local N=#aB+1

ag.AddSignal(M.MouseButton1Click,function()
SetSubTab(N,false)
end)

ag.AddSignal(M.MouseEnter,function()
if b~=N then
aj(
L,
0.14,
{TextTransparency=0.1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if J then
aj(
J,
0.14,
{ImageTransparency=0.1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end)

ag.AddSignal(M.MouseLeave,function()
if b~=N then
aj(
L,
0.14,
{TextTransparency=0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if J then
aj(
J,
0.14,
{ImageTransparency=0.22},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end
end)

table.insert(aB,{
Page=G,
Button=M,
Icon=J,
Label=L,
})

UpdateBarSize()

ay.Load(
C,
G,
ay.Elements,
Window,
WindUI,
nil,
ay,
ao
)

if F then
SetSubTab(1,true)
else
SetSubTab(b,true)
end

return C
end

return aA
end

function ap.LockAll(az)
for aA,aB in next,Window.AllElements do
if aB.Tab and aB.Tab.Index and aB.Tab.Index==ap.Index and aB.Lock then
aB:Lock()
end
end
end

function ap.UnlockAll(az)
for aA,aB in next,Window.AllElements do
if aB.Tab and aB.Tab.Index and aB.Tab.Index==ap.Index and aB.Unlock then
aB:Unlock()
end
end
end

function ap.GetLocked(az)
local aA={}
for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==ap.Index and b.Locked==true then
table.insert(aA,b)
end
end
return aA
end

function ap.GetUnlocked(az)
local aA={}
for aB,b in next,Window.AllElements do
if b.Tab and b.Tab.Index and b.Tab.Index==ap.Index and b.Locked==false then
table.insert(aA,b)
end
end
return aA
end

function ap.Select(az)
return am:SelectTab(ap.Index)
end

task.spawn(function()
local az
if ap.CustomEmptyPage.Icon then
az=
ag.Image(ap.CustomEmptyPage.Icon,ap.CustomEmptyPage.Icon,0,"Temp","EmptyPage",true)
az.Size=
UDim2.fromOffset(ap.CustomEmptyPage.IconSize or 48,ap.CustomEmptyPage.IconSize or 48)
end

local aA=ai("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,-Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
Parent=ap.UIElements.ContainerFrame,
},{
ai("UIListLayout",{
Padding=UDim.new(0,8),
SortOrder="LayoutOrder",
VerticalAlignment="Center",
HorizontalAlignment="Center",
FillDirection="Vertical",
}),
az,
ap.CustomEmptyPage.Title
and ai("TextLabel",{
AutomaticSize="XY",
Text=ap.CustomEmptyPage.Title,
ThemeTag={
TextColor3="Text",
},
TextSize=18,
TextTransparency=0.5,
BackgroundTransparency=1,
FontFace=Font.new(ag.Font,Enum.FontWeight.Medium),
})
or nil,
ap.CustomEmptyPage.Desc
and ai("TextLabel",{
AutomaticSize="XY",
Text=ap.CustomEmptyPage.Desc,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.65,
BackgroundTransparency=1,
FontFace=Font.new(ag.Font,Enum.FontWeight.Regular),
})
or nil,
})

local aB
aB=ag.AddSignal(ap.UIElements.ContainerFrame.ChildAdded,function()
aA.Visible=false
aB:Disconnect()
end)
end)

return ap
end

function am.OnChange(an,ao)
am.OnChangeFunc=ao
end

function am.SelectTab(an,ao)
local ap=am.Tabs[ao]
local aq=am.Containers[ao]

if not ap or not aq or ap.Locked then
return
end

am.SelectedTab=ao

for ar,as in next,am.Tabs do
if not as.Locked then
ag.SetThemeTag(as.UIElements.Main,{
ImageTransparency="TabBorderTransparency",
},0.15)
if as.Border then
ag.SetThemeTag(as.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparency",
},0.15)
end
ag.SetThemeTag(as.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparency",
},0.15)
if as.UIElements.Icon and not as.IconColor then
ag.SetThemeTag(as.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparency",
},0.15)
end
as.Selected=false
end
end

ag.SetThemeTag(ap.UIElements.Main,{
ImageTransparency="TabBackgroundActiveTransparency",
},0.15)
if ap.Border then
ag.SetThemeTag(ap.UIElements.Main.Outline,{
ImageTransparency="TabBorderTransparencyActive",
},0.15)
end
ag.SetThemeTag(ap.UIElements.Main.Frame.TextLabel,{
TextTransparency="TabTextTransparencyActive",
},0.15)
if ap.UIElements.Icon and not ap.IconColor then
ag.SetThemeTag(ap.UIElements.Icon.ImageLabel,{
ImageTransparency="TabIconTransparencyActive",
},0.15)
end
ap.Selected=true

task.spawn(function()
for ar,as in next,am.Containers do
as.AnchorPoint=Vector2.new(0,0.05)
as.Visible=false
end
aq.Visible=true
local ar=game:GetService"TweenService"

local as=TweenInfo.new(0.15,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
local at=ar:Create(aq,as,{
AnchorPoint=Vector2.new(0,0),
})
at:Play()
end)

am.OnChangeFunc(ao)
end

return am end function a.W()

local aa={}


local ad=a.load'c'
local ae=ad.New
local ag=ad.Tween

local ai=a.load'V'

function aa.New(aj,ak,al,am,an)
local ao={
Title=aj.Title or"Section",
Icon=aj.Icon,
IconThemed=aj.IconThemed,
Opened=aj.Opened or false,

HeaderSize=42,
IconSize=18,

Expandable=false,
}

local ap
if ao.Icon then
ap=ad.Image(
ao.Icon,
ao.Icon,
0,
al,
"Section",
true,
ao.IconThemed,
"TabSectionIcon"
)

ap.Size=UDim2.new(0,ao.IconSize,0,ao.IconSize)
ap.ImageLabel.ImageTransparency=.25
end

local aq=ae("Frame",{
Size=UDim2.new(0,ao.IconSize,0,ao.IconSize),
BackgroundTransparency=1,
Visible=false
},{
ae("ImageLabel",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Image=ad.Icon"chevron-down"[1],
ImageRectSize=ad.Icon"chevron-down"[2].ImageRectSize,
ImageRectOffset=ad.Icon"chevron-down"[2].ImageRectPosition,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=.7,
})
})

local ar=ae("Frame",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Parent=ak,
ClipsDescendants=true,
},{
ae("TextButton",{
Size=UDim2.new(1,0,0,ao.HeaderSize),
BackgroundTransparency=1,
Text="",
},{
ap,
ae("TextLabel",{
Text=ao.Title,
TextXAlignment="Left",
Size=UDim2.new(
1,
ap and(-ao.IconSize-10)*2
or(-ao.IconSize-10),

1,
0
),
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ad.Font,Enum.FontWeight.SemiBold),
TextSize=14,
BackgroundTransparency=1,
TextTransparency=.7,

TextWrapped=true
}),
ae("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
Padding=UDim.new(0,10)
}),
aq,
ae("UIPadding",{
PaddingLeft=UDim.new(0,11),
PaddingRight=UDim.new(0,11),
})
}),
ae("Frame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
Name="Content",
Visible=true,
Position=UDim2.new(0,0,0,ao.HeaderSize)
},{
ae("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,an.Gap),
VerticalAlignment="Bottom",
}),
})
})


function ao.Tab(as,at)
if not ao.Expandable then
ao.Expandable=true
aq.Visible=true
end
at.Parent=ar.Content
return ai.New(at,am)
end

function ao.Open(as)
if ao.Expandable then
ao.Opened=true
ag(ar,0.33,{
Size=UDim2.new(1,0,0,ao.HeaderSize+(ar.Content.AbsoluteSize.Y/am))
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

ag(aq.ImageLabel,0.1,{Rotation=180},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end
function ao.Close(as)
if ao.Expandable then
ao.Opened=false
ag(ar,0.26,{
Size=UDim2.new(1,0,0,ao.HeaderSize)
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
ag(aq.ImageLabel,0.1,{Rotation=0},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

ad.AddSignal(ar.TextButton.MouseButton1Click,function()
if ao.Expandable then
if ao.Opened then
ao:Close()
else
ao:Open()
end
end
end)

ad.AddSignal(ar.Content.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()
if ao.Opened then
ao:Open()
end
end)

if ao.Opened then
task.spawn(function()
task.wait()
ao:Open()
end)
end



return ao
end


return aa end function a.X()
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
}end function a.Y()
local aa=(cloneref or clonereference or function(aa)
return aa
end)

aa(game:GetService"UserInputService")

local ad={
Margin=8,
Padding=9,
}

local ae=a.load'c'
local ag=ae.New
local ai=ae.Tween

function ad.new(aj,ak,al)
local am={
IconSize=18,
Padding=14,
Radius=22,
Width=400,
MaxHeight=380,

Icons=a.load'X',
}

local an=ag("TextBox",{
Text="",
PlaceholderText="Search...",
ThemeTag={
PlaceholderColor3="Placeholder",
TextColor3="Text",
},
Size=UDim2.new(1,-((am.IconSize*2)+(am.Padding*2)),0,0),
AutomaticSize="Y",
ClipsDescendants=true,
ClearTextOnFocus=false,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Regular),
TextSize=18,
})

local ao=ag("ImageLabel",{
Image=ae.Icon"x"[1],
ImageRectSize=ae.Icon"x"[2].ImageRectSize,
ImageRectOffset=ae.Icon"x"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
},{
ag("TextButton",{
Size=UDim2.new(1,8,1,8),
BackgroundTransparency=1,
Active=true,
ZIndex=999999999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Text="",
}),
})

local ap=ag("ScrollingFrame",{
Size=UDim2.new(1,0,0,0),
AutomaticCanvasSize="Y",
ScrollingDirection="Y",
ElasticBehavior="Never",
ScrollBarThickness=0,
CanvasSize=UDim2.new(0,0,0,0),
BackgroundTransparency=1,
Visible=false,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding),
}),
})

local aq=ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="WindowSearchBarBackground",
},
ImageTransparency=0,
},{
ae.NewRoundFrame(am.Radius,"Squircle",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,

Visible=false,
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Frame",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,46),
BackgroundTransparency=1,
},{








ag("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
},{
ag("ImageLabel",{
Image=ae.Icon"search"[1],
ImageRectSize=ae.Icon"search"[2].ImageRectSize,
ImageRectOffset=ae.Icon"search"[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
}),
an,
ao,
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
ag("UIPadding",{
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
}),
}),
}),
ag("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Results",
},{
ag("Frame",{
Size=UDim2.new(1,0,0,1),
ThemeTag={
BackgroundColor3="Outline",
},
BackgroundTransparency=0.9,
Visible=false,
}),
ap,
ag("UISizeConstraint",{
MaxSize=Vector2.new(am.Width,am.MaxHeight),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
})

local ar=ag("Frame",{
Size=UDim2.new(0,am.Width,0,0),
AutomaticSize="Y",
Parent=ak,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Visible=false,

ZIndex=99999999,
},{
ag("UIScale",{
Scale=0.9,
}),
aq,
ae.NewRoundFrame(am.Radius,"Glass-0.7",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,


ThemeTag={
ImageColor3="SearchBarBorder",
ImageTransparency="SearchBarBorderTransparency",
},
Name="Outline",
}),
})

local function CreateSearchTab(as,at,au,av,aw,ax)
local ay=ag("TextButton",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=av or nil,
},{
ae.NewRoundFrame(am.Radius-11,"Squircle",{
Size=UDim2.new(1,0,0,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),

ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Main",
},{
ae.NewRoundFrame(am.Radius-11,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ThemeTag={
ImageColor3="White",
},
ImageTransparency=1,
Name="Outline",
},{








ag("UIPadding",{
PaddingTop=UDim.new(0,am.Padding-2),
PaddingLeft=UDim.new(0,am.Padding),
PaddingRight=UDim.new(0,am.Padding),
PaddingBottom=UDim.new(0,am.Padding-2),
}),
ag("ImageLabel",{
Image=ae.Icon(au)[1],
ImageRectSize=ae.Icon(au)[2].ImageRectSize,
ImageRectOffset=ae.Icon(au)[2].ImageRectPosition,
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Icon",
},
ImageTransparency=0.1,
Size=UDim2.new(0,am.IconSize,0,am.IconSize),
}),
ag("Frame",{
Size=UDim2.new(1,-am.IconSize-am.Padding,0,0),
BackgroundTransparency=1,
},{
ag("TextLabel",{
Text=as,
ThemeTag={
TextColor3="Text",
},
TextSize=17,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Title",
}),
ag("TextLabel",{
Text=at or"",
Visible=at and true or false,
ThemeTag={
TextColor3="Text",
},
TextSize=15,
TextTransparency=0.3,
BackgroundTransparency=1,
TextXAlignment="Left",
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Size=UDim2.new(1,0,0,0),
TextTruncate="AtEnd",
AutomaticSize="Y",
Name="Desc",
})or nil,
ag("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Vertical",
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,am.Padding),
FillDirection="Horizontal",
}),
}),
},true),
ag("Frame",{
Name="ParentContainer",
Size=UDim2.new(1,-am.Padding,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Visible=aw,

},{
ae.NewRoundFrame(99,"Squircle",{
Size=UDim2.new(0,2,1,0),
BackgroundTransparency=1,
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=0.9,
}),
ag("Frame",{
Size=UDim2.new(1,-am.Padding-2,0,0),
Position=UDim2.new(0,am.Padding+2,0,0),
BackgroundTransparency=1,
},{
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
}),
}),
}),
ag("UIListLayout",{
Padding=UDim.new(0,0),
FillDirection="Vertical",
HorizontalAlignment="Right",
}),
})



ay.Main.Size=UDim2.new(
1,
0,
0,
ay.Main.Outline.Frame.Desc.Visible
and(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y+6+ay.Main.Outline.Frame.Desc.TextBounds.Y)
or(((am.Padding-2)*2)+ay.Main.Outline.Frame.Title.TextBounds.Y)
)

ae.AddSignal(ay.Main.MouseEnter,function()
ai(ay.Main,0.04,{ImageTransparency=0.95}):Play()
ai(ay.Main.Outline,0.04,{ImageTransparency=0.75}):Play()
end)
ae.AddSignal(ay.Main.InputEnded,function()
ai(ay.Main,0.08,{ImageTransparency=1}):Play()
ai(ay.Main.Outline,0.08,{ImageTransparency=1}):Play()
end)
ae.AddSignal(ay.Main.MouseButton1Click,function()
if ax then
ax()
end
end)

return ay
end

local function ContainsText(as,at)
if not at or at==""then
return false
end

if not as or as==""then
return false
end

local au=string.lower(as)
local av=string.lower(at)

return string.find(au,av,1,true)~=nil
end

local function Search(as)
if not as or as==""then
return{}
end

local at={}
for au,av in next,aj.Tabs do
local aw=ContainsText(av.Title or"",as)
local ax={}

for ay,az in next,av.Elements do
if az.__type~="Section"then
local aA=ContainsText(az.Title or"",as)
local aB=ContainsText(az.Desc or"",as)

if aA or aB then
ax[ay]={
Title=az.Title,
Desc=az.Desc,
Original=az,
__type=az.__type,
Index=ay,
}
end
end
end

if aw or next(ax)~=nil then
at[au]={
Tab=av,
Title=av.Title,
Icon=av.Icon,
Elements=ax,
}
end
end
return at
end

ae.AddSignal(ap.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",function()

ai(ap,0.06,{
Size=UDim2.new(
1,
0,
0,
math.clamp(
ap.UIListLayout.AbsoluteContentSize.Y+(am.Padding*2),
0,
am.MaxHeight
)
),
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()






end)

function am.Open(as)
task.spawn(function()
aq.Frame.Visible=true
ar.Visible=true
ai(ar.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

function am.Close(as,at)
task.spawn(function()
al()
aq.Frame.Visible=false
ai(ar.UIScale,0.12,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

task.wait(0.12)
ar.Visible=false
if at then
ar:Destroy()
end
end)
end

ae.AddSignal(ao.TextButton.MouseButton1Click,function()
am:Close(true)
end)

am:Open()

function am.Search(as,at)
at=at or""

local au=Search(at)

ap.Visible=true
aq.Frame.Results.Frame.Visible=true
for av,aw in next,ap:GetChildren()do
if aw.ClassName~="UIListLayout"and aw.ClassName~="UIPadding"then
aw:Destroy()
end
end

if au and next(au)~=nil then
for av,aw in next,au do
local ax=am.Icons.Tab
local ay=CreateSearchTab(aw.Title,nil,ax,ap,true,function()
am:Close()
aj:SelectTab(av)
end)
if aw.Elements and next(aw.Elements)~=nil then
for az,aA in next,aw.Elements do
local aB=am.Icons[aA.__type]
CreateSearchTab(
aA.Title,
aA.Desc,
aB,
ay:FindFirstChild"ParentContainer"and ay.ParentContainer.Frame
or nil,
false,
function()
am:Close()
aj:SelectTab(av)
if aw.Tab.ScrollToTheElement then

aw.Tab:ScrollToTheElement(aA.Index)
end

end
)

end
end
end
elseif at~=""then
ag("TextLabel",{
Size=UDim2.new(1,0,0,70),
Text="No results found",
TextSize=16,
ThemeTag={
TextColor3="Text",
},
TextTransparency=0.2,
BackgroundTransparency=1,
FontFace=Font.new(ae.Font,Enum.FontWeight.Medium),
Parent=ap,
Name="NotFound",
})
else
ap.Visible=false
aq.Frame.Results.Frame.Visible=false
end
end

ae.AddSignal(an:GetPropertyChangedSignal"Text",function()
am:Search(an.Text)
end)

return am
end

return ad end function a.Z()



local aa=(cloneref or clonereference or function(aa)
return aa
end)

local ad=aa(game:GetService"UserInputService")
local ae=aa(game:GetService"RunService")
local ag=aa(game:GetService"Players")

local ai=workspace.CurrentCamera

local aj=a.load's'

local ak=a.load'c'
local al=ak.New
local am=ak.Tween

local an=a.load'v'.New
local ao=a.load'l'.New
local ap=a.load'w'.New
local aq=a.load'x'

local ar=a.load'y'



return function(as)
local at={
Title=as.Title or"UI Library",
SubTitle=as.SubTitle,
TitleMessages=as.TitleMessages,
TitleAnim=as.TitleAnim,
TitleFont=as.TitleFont or ak.Font,
TitleFontWeight=as.TitleFontWeight or Enum.FontWeight.SemiBold,
TitleTextSize=as.TitleTextSize or 16,

Author=as.Author,
Icon=as.Icon,
IconSize=as.IconSize or 22,
IconThemed=as.IconThemed,
IconRadius=as.IconRadius or 0,
Folder=as.Folder,
Resizable=as.Resizable~=false,
Background=as.Background,
BackgroundImageTransparency=as.BackgroundImageTransparency or 0,
ShadowTransparency=as.ShadowTransparency or 0.6,
User=as.User or{},
Footer=as.Footer or{},
Topbar=as.Topbar or{Height=52,ButtonsType="Default"},

Size=as.Size,

MinSize=as.MinSize or Vector2.new(560,350),
MaxSize=as.MaxSize or Vector2.new(850,560),

TopBarButtonIconSize=as.TopBarButtonIconSize,

ToggleKey=as.ToggleKey,
ElementsRadius=as.ElementsRadius,
Radius=as.Radius or 16,
Transparent=as.Transparent or false,
HideSearchBar=as.HideSearchBar~=false,
ScrollBarEnabled=as.ScrollBarEnabled or false,
SideBarWidth=as.SideBarWidth or 200,
Acrylic=as.Acrylic or false,
NewElements=as.NewElements or false,
IgnoreAlerts=as.IgnoreAlerts or false,
HidePanelBackground=as.HidePanelBackground or false,
AutoScale=as.AutoScale~=false,
OpenButton=as.OpenButton,
DragFrameSize=160,

Position=UDim2.new(0.5,0,0.5,0),
UICorner=nil,
UIPadding=14,
UIElements={},
CanDropdown=true,
Closed=false,
Parent=as.Parent,
Destroyed=false,
IsFullscreen=false,
CanResize=as.Resizable~=false,
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

at.UICorner=at.Radius
at.TopBarButtonIconSize=at.TopBarButtonIconSize or(at.Topbar.ButtonsType=="Mac"and 11 or 16)

at.ElementConfig={
UIPadding=(at.NewElements and 10 or 13),
UICorner=at.ElementsRadius or(at.NewElements and 23 or 12),
}

local au=at.Size or UDim2.new(0,580,0,460)
at.Size=UDim2.new(
au.X.Scale,
math.clamp(au.X.Offset,at.MinSize.X,at.MaxSize.X),
au.Y.Scale,
math.clamp(au.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

if at.Topbar=={}then
at.Topbar={Height=52,ButtonsType="Default"}
end

if not ae:IsStudio()and at.Folder and writefile then
if not isfolder("WindUI/"..at.Folder)then
makefolder("WindUI/"..at.Folder)
end
if not isfolder("WindUI/"..at.Folder.."/assets")then
makefolder("WindUI/"..at.Folder.."/assets")
end
if not isfolder(at.Folder)then
makefolder(at.Folder)
end
if not isfolder(at.Folder.."/assets")then
makefolder(at.Folder.."/assets")
end
end

local av=al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
})

if at.Folder then
at.ConfigManager=ar:Init(at)
end

if at.Acrylic then
local aw=aj.AcrylicPaint{UseAcrylic=at.Acrylic}
at.AcrylicPaint=aw
end

local aw=al("Frame",{
Size=UDim2.new(0,32,0,32),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(0.5,0.5),
BackgroundTransparency=1,
ZIndex=99,
Active=true,
},{
al("ImageLabel",{
Size=UDim2.new(0,96,0,96),
BackgroundTransparency=1,
Image="rbxassetid://120997033468887",
Position=UDim2.new(0.5,-16,0.5,-16),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local ax=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=98,
Active=false,
},{
al("ImageLabel",{
Size=UDim2.new(0,70,0,70),
Image=ak.Icon"expand"[1],
ImageRectOffset=ak.Icon"expand"[2].ImageRectPosition,
ImageRectSize=ak.Icon"expand"[2].ImageRectSize,
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
ImageTransparency=1,
}),
})

local ay=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
ImageTransparency=1,
ImageColor3=Color3.new(0,0,0),
ZIndex=999,
Active=false,
})

at.UIElements.SideBar=al("ScrollingFrame",{
Size=UDim2.new(
1,
at.ScrollBarEnabled and-3-(at.UIPadding/2)or 0,
1,
not at.HideSearchBar and-45 or 0
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
al("Frame",{
BackgroundTransparency=1,
AutomaticSize="Y",
Size=UDim2.new(1,0,0,0),
Name="Frame",
},{
al("UIPadding",{
PaddingBottom=UDim.new(0,at.UIPadding/2),
}),
al("UIListLayout",{
SortOrder="LayoutOrder",
Padding=UDim.new(0,at.Gap),
}),
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
}),
})

at.UIElements.SideBarContainer=al("Frame",{
Size=UDim2.new(
0,
at.SideBarWidth,
1,
at.User.Enabled and-at.Topbar.Height-42-(at.UIPadding*2)or-at.Topbar.Height
),
Position=UDim2.new(0,0,0,at.Topbar.Height),
BackgroundTransparency=1,
Visible=true,
},{
al("Frame",{
Name="Content",
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,not at.HideSearchBar and-45-at.UIPadding/2 or 0),
Position=UDim2.new(0,0,1,0),
AnchorPoint=Vector2.new(0,1),
}),
at.UIElements.SideBar,
})

if at.ScrollBarEnabled then
ap(at.UIElements.SideBar,at.UIElements.SideBarContainer.Content,at,3)
end

at.UIElements.MainBar=al("Frame",{
Size=UDim2.new(1,-at.UIElements.SideBarContainer.AbsoluteSize.X,1,-at.Topbar.Height),
Position=UDim2.new(1,0,1,0),
AnchorPoint=Vector2.new(1,1),
BackgroundTransparency=1,
},{
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="PanelBackground",
ImageTransparency="PanelBackgroundTransparency",
},
ZIndex=3,
Name="Background",
Visible=not at.HidePanelBackground,
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
PaddingBottom=UDim.new(0,at.UIPadding/2),
}),
})

local az=al("ImageLabel",{
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

if ad.TouchEnabled and not ad.KeyboardEnabled then
at.IsPC=false
elseif ad.KeyboardEnabled then
at.IsPC=true
else
at.IsPC=nil
end

local aA
if at.User then
local function GetUserThumb()
local aB=ag:GetUserThumbnailAsync(
at.User.Anonymous and 1 or ag.LocalPlayer.UserId,
Enum.ThumbnailType.HeadShot,
Enum.ThumbnailSize.Size420x420
)
return aB
end

aA=al("TextButton",{
Size=UDim2.new(
0,
at.UIElements.SideBarContainer.AbsoluteSize.X-(at.UIPadding/2),
0,
42+at.UIPadding
),
Position=UDim2.new(0,at.UIPadding/2,1,-(at.UIPadding/2)),
AnchorPoint=Vector2.new(0,1),
BackgroundTransparency=1,
Visible=at.User.Enabled or false,
},{
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"SquircleOutline",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="Outline",
},{
al("UIGradient",{
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
ak.NewRoundFrame(at.UICorner-(at.UIPadding/2),"Squircle",{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Text",
},
ImageTransparency=1,
Name="UserIcon",
},{
al("ImageLabel",{
Image=GetUserThumb(),
BackgroundTransparency=1,
Size=UDim2.new(0,42,0,42),
ThemeTag={
BackgroundColor3="Text",
},
BackgroundTransparency=0.93,
},{
al("UICorner",{
CornerRadius=UDim.new(1,0),
}),
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
},{
al("TextLabel",{
Text=at.User.Anonymous and"Anonymous"or ag.LocalPlayer.DisplayName,
TextSize=17,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="DisplayName",
}),
al("TextLabel",{
Text=at.User.Anonymous and"anonymous"or ag.LocalPlayer.Name,
TextSize=15,
TextTransparency=0.6,
ThemeTag={
TextColor3="Text",
},
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
AutomaticSize="Y",
BackgroundTransparency=1,
Size=UDim2.new(1,-27,0,0),
TextTruncate="AtEnd",
TextXAlignment="Left",
Name="UserName",
}),
al("UIListLayout",{
Padding=UDim.new(0,4),
HorizontalAlignment="Left",
}),
}),
al("UIListLayout",{
Padding=UDim.new(0,at.UIPadding),
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,at.UIPadding/2),
PaddingRight=UDim.new(0,at.UIPadding/2),
}),
}),
})

function at.User.Enable(aB)
at.User.Enabled=true
am(
at.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,at.SideBarWidth,1,-at.Topbar.Height-42-(at.UIPadding*2))},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aA.Visible=true
end

function at.User.Disable(aB)
at.User.Enabled=false
am(
at.UIElements.SideBarContainer,
0.25,
{Size=UDim2.new(0,at.SideBarWidth,1,-at.Topbar.Height)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
aA.Visible=false
end

function at.User.SetAnonymous(aB,b)
if b~=false then
b=true
end
at.User.Anonymous=b
aA.UserIcon.ImageLabel.Image=GetUserThumb()
aA.UserIcon.Frame.DisplayName.Text=b and"Anonymous"or ag.LocalPlayer.DisplayName
aA.UserIcon.Frame.UserName.Text=b and"anonymous"or ag.LocalPlayer.Name
end

if at.User.Enabled then
at.User:Enable()
else
at.User:Disable()
end

if at.User.Callback then
ak.AddSignal(aA.MouseButton1Click,function()
at.User.Callback()
end)
ak.AddSignal(aA.MouseEnter,function()
am(aA.UserIcon,0.04,{ImageTransparency=0.95}):Play()
am(aA.Outline,0.04,{ImageTransparency=0.85}):Play()
end)
ak.AddSignal(aA.InputEnded,function()
am(aA.UserIcon,0.04,{ImageTransparency=1}):Play()
am(aA.Outline,0.04,{ImageTransparency=1}):Play()
end)
end
end

local aB
local b

local d=false
local f

local g=typeof(at.Background)=="string"and string.match(at.Background,"^video:(.+)")or nil
local h=typeof(at.Background)=="string"
and not g
and string.match(at.Background,"^https?://.+")
or nil

local function GetImageExtension(j)
local l=j:match"%.(%w+)$"or j:match"%.(%w+)%?"
if l then
l=l:lower()
if l=="jpg"or l=="jpeg"or l=="png"or l=="webp"then
return"."..l
end
end
return".png"
end

if typeof(at.Background)=="string"and g then
d=true

if string.find(g,"http")then
local j=at.Folder.."/assets/."..ak.SanitizeFilename(g)..".webm"
if not isfile(j)then
local l,m=pcall(function()
local l=game.HttpGet and game:HttpGet(g)
writefile(j,l.Body)
end)
if not l then
warn("[ WindUI.Window.Background ] Failed to download video: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(j)
end)
if not l then
warn("[ WindUI.Window.Background ] Failed to load custom asset: "..tostring(m))
return
end
warn"[ WindUI.Window.Background ] VideoFrame may not work with custom video"
g=m
end

f=al("VideoFrame",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Video=g,
Looped=true,
Volume=0,
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
f:Play()
elseif h then
local j=at.Folder
.."/assets/."
..ak.SanitizeFilename(h)
..GetImageExtension(h)

if isfile and not isfile(j)then
local l,m=pcall(function()
local l=game.HttpGet and game:HttpGet(h)
writefile(j,l.Body)
end)
if not l then
warn("[ Window.Background ] Failed to download image: "..tostring(m))
return
end
end

local l,m=pcall(function()
return getcustomasset(j)
end)
if not l then
warn("[ Window.Background ] Failed to load custom asset: "..tostring(m))
return
end

f=al("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=m,
ImageTransparency=0,
ScaleType="Crop",
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
elseif at.Background then
f=al("ImageLabel",{
BackgroundTransparency=1,
Size=UDim2.new(1,0,1,0),
Image=typeof(at.Background)=="string"and at.Background or"",
ImageTransparency=1,
ScaleType="Crop",
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
})
end

local j=ak.NewRoundFrame(99,"Squircle",{
ImageTransparency=0.8,
ImageColor3=Color3.new(1,1,1),
Size=UDim2.new(0,0,0,4),
Position=UDim2.new(0.5,0,1,4),
AnchorPoint=Vector2.new(0.5,0),
},{
al("TextButton",{
Size=UDim2.new(1,12,1,12),
BackgroundTransparency=1,
Position=UDim2.new(0.5,0,0.5,0),
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
ZIndex=99,
Name="Frame",
}),
})

local function createAuthor(l)
return al("TextLabel",{
Text=l,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
BackgroundTransparency=1,
TextTransparency=0.35,
AutomaticSize="XY",
Parent=at.UIElements.Main and at.UIElements.Main.Main.Topbar.Left.Title,
TextXAlignment="Left",
TextSize=13,
LayoutOrder=2,
ThemeTag={
TextColor3="WindowTopbarAuthor",
},
Name="Author",
})
end

local l
local m

if at.Author then
l=createAuthor(at.Author)
end

local p={
Text=at.Title,
BackgroundTransparency=1,
AutomaticSize="XY",
Name="Title",
TextXAlignment="Left",
TextSize=at.TitleTextSize,
ThemeTag={
TextColor3="WindowTopbarTitle",
},
}

if typeof(at.TitleFont)=="EnumItem"then
p.Font=at.TitleFont
else
p.FontFace=Font.new(at.TitleFont,at.TitleFontWeight)
end

local r=al("TextLabel",p)

local function ApplyWindowTitleFont()
if typeof(at.TitleFont)=="EnumItem"then
r.Font=at.TitleFont
else
r.FontFace=Font.new(at.TitleFont,at.TitleFontWeight)
end
r.TextSize=at.TitleTextSize
end

local u=0

local function GetTitleMessages()
local v={}

if type(at.TitleMessages)=="table"and#at.TitleMessages>0 then
for x,z in ipairs(at.TitleMessages)do
if type(z)=="string"and z~=""then
table.insert(v,z)
end
end
else
if type(at.Title)=="string"and at.Title~=""then
table.insert(v,at.Title)
end
if type(at.SubTitle)=="string"and at.SubTitle~=""and at.SubTitle~=at.Title then
table.insert(v,at.SubTitle)
end
end

if#v==0 then
v={"UI Library"}
end

return v
end

local function GetTitleAnimConfig()
local v=at.TitleAnim

if not v or v==false or v=="None"then
return nil
end

if type(v)=="string"then
local x=
(v=="FadeLoop"or v=="Pulse"or v=="TypingCursor"or v=="TypingWrite")
return{
Type=v,
Speed=0.055,
Delay=3.5,
Loop=x,
CursorChar="▏",
}
end

if type(v)=="table"then
local x=v.Type or v.Name or"TypingWrite"
local z=
(x=="FadeLoop"or x=="Pulse"or x=="TypingCursor"or x=="TypingWrite")

return{
Type=x,
Speed=v.Speed or 0.055,
Delay=v.Delay or 3.5,
Loop=v.Loop==nil and z or v.Loop,
CursorChar=v.CursorChar or"▏",
}
end

return nil
end

local function ResetWindowTitleVisual()
r.Text=at.Title
r.TextTransparency=0
r.Position=UDim2.new(0,0,0,0)
r.TextSize=at.TitleTextSize
ApplyWindowTitleFont()
end

local function StopWindowTitleAnimation()
u+=1
ResetWindowTitleVisual()
end

local function RunWindowTitleAnimation()
StopWindowTitleAnimation()

local v=GetTitleAnimConfig()
if not v then
return
end

local x=u
local z=GetTitleMessages()
local A=string.lower(tostring(v.Type))

task.spawn(function()
local function alive()
return x==u and not at.Destroyed
end

local B=1

local function getCurrentMessage()
return z[B]or at.Title or"UI Library"
end

local function nextMessage()
B+=1
if B>#z then
B=1
end
end

if A=="typingwrite"or A=="typingcursor"then
repeat
local C=getCurrentMessage()

r.Text=""
r.TextTransparency=0

for F=1,#C do
if not alive()then
return
end

local G=string.sub(C,1,F)
if A=="typingcursor"then
r.Text=G..v.CursorChar
else
r.Text=G
end

task.wait(v.Speed)
end

r.Text=C

if A=="typingcursor"then
for F=1,4 do
if not alive()then
return
end
r.Text=C..v.CursorChar
task.wait(0.3)

if not alive()then
return
end
r.Text=C
task.wait(0.3)
end
end

if#z<=1 and not v.Loop then
break
end

task.wait(v.Delay)
nextMessage()
until not alive()

if alive()then
ResetWindowTitleVisual()
end
elseif A=="fadeloop"then
while alive()do
local C=getCurrentMessage()
r.Text=C

am(
r,
0.8,
{TextTransparency=0.28},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut
):Play()
task.wait(0.8)

if not alive()then
return
end

am(
r,
0.8,
{TextTransparency=0},
Enum.EasingStyle.Sine,
Enum.EasingDirection.InOut
):Play()
task.wait(v.Delay)

if#z>1 or v.Loop then
nextMessage()
else
break
end
end
elseif A=="pulse"then
while alive()do
local C=getCurrentMessage()
r.Text=C

am(
r,
0.18,
{TextSize=at.TitleTextSize+1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
task.wait(0.18)

if not alive()then
return
end

am(
r,
0.22,
{TextSize=at.TitleTextSize},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
task.wait(v.Delay)

if#z>1 or v.Loop then
nextMessage()
else
break
end
end
elseif A=="slidereveal"then
repeat
local C=getCurrentMessage()
r.Text=C
r.Position=UDim2.new(0,-10,0,0)
r.TextTransparency=1

am(
r,
0.28,
{
Position=UDim2.new(0,0,0,0),
TextTransparency=0,
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if#z<=1 and not v.Loop then
break
end

task.wait(v.Delay)
nextMessage()
until not alive()

if alive()then
ResetWindowTitleVisual()
end
end
end)
end

local v

at.UIElements.Main=al("Frame",{
Size=at.Size,
Position=at.Position,
BackgroundTransparency=1,
Parent=as.Parent,
AnchorPoint=Vector2.new(0.5,0.5),
Active=true,
},{
as.WindUI.UIScaleObj,
at.AcrylicPaint and at.AcrylicPaint.Frame or nil,
az,
ak.NewRoundFrame(at.UICorner,"Squircle",{
ImageTransparency=1,
Size=UDim2.new(1,0,1,-240),
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
Name="Background",
ThemeTag={
ImageColor3="WindowBackground",
},
},{
f,
j,
aw,
}),
v,
av,
ax,
ay,
al("Frame",{
Size=UDim2.new(1,0,1,0),
BackgroundTransparency=1,
Name="Main",
Visible=false,
ZIndex=97,
},{
al("UICorner",{
CornerRadius=UDim.new(0,at.UICorner),
}),
at.UIElements.SideBarContainer,
at.UIElements.MainBar,
aA,
b,
al("Frame",{
Size=UDim2.new(1,0,0,at.Topbar.Height),
BackgroundTransparency=1,
BackgroundColor3=Color3.fromRGB(50,50,50),
Name="Topbar",
},{
aB,

al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(0,0,0.5,0),
AnchorPoint=Vector2.new(0,0.5),
Name="MacButtons",
Visible=at.Topbar.ButtonsType=="Mac",
},{
al("UIListLayout",{
Padding=UDim.new(0,4),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
VerticalAlignment="Center",
}),
}),

al("Frame",{
AutomaticSize="X",
Size=UDim2.new(0,0,1,0),
BackgroundTransparency=1,
Name="Left",
},{
al("UIListLayout",{
Padding=UDim.new(0,at.UIPadding+4),
SortOrder="LayoutOrder",
FillDirection="Horizontal",
VerticalAlignment="Center",
}),
al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Name="Title",
Size=UDim2.new(0,0,1,0),
LayoutOrder=2,
},{
al("UIListLayout",{
Padding=UDim.new(0,0),
SortOrder="LayoutOrder",
FillDirection="Vertical",
VerticalAlignment="Center",
}),
r,
l,
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,4),
}),
}),

al("ScrollingFrame",{
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
al("UIListLayout",{
FillDirection="Horizontal",
VerticalAlignment="Center",
HorizontalAlignment="Left",
Padding=UDim.new(0,at.UIPadding/2),
}),
}),

al("Frame",{
AutomaticSize="XY",
BackgroundTransparency=1,
Position=UDim2.new(1,0,0.5,0),
AnchorPoint=Vector2.new(1,0.5),
Name="Right",
},{
al("UIListLayout",{
Padding=UDim.new(0,at.Topbar.ButtonsType=="Default"and 9 or 8),
FillDirection="Horizontal",
SortOrder="LayoutOrder",
VerticalAlignment="Center",
}),
}),

al("UIPadding",{
PaddingTop=UDim.new(0,at.UIPadding),
PaddingLeft=UDim.new(
0,
at.Topbar.ButtonsType=="Default"and at.UIPadding or at.UIPadding-2
),
PaddingRight=UDim.new(0,at.Topbar.ButtonsType=="Mac"and 14 or 8),
PaddingBottom=UDim.new(0,at.UIPadding),
}),
}),
}),
})

local x=at.UIElements.Main.Main.Topbar

local z=ak.NewRoundFrame(999,"Squircle",{
Name="HoverHint",
Size=UDim2.new(0,0,0,22),
AutomaticSize="XY",
BackgroundTransparency=1,
ImageTransparency=0.1,
ThemeTag={
ImageColor3="Text",
},
Parent=x,
Visible=false,
ZIndex=10050,
},{
ak.NewRoundFrame(999,"Glass-1",{
Size=UDim2.new(1,0,1,0),
Name="Outline",
ImageColor3=Color3.new(1,1,1),
ImageTransparency=0.83,
ZIndex=10051,
}),
al("TextLabel",{
Name="Label",
AutomaticSize="XY",
BackgroundTransparency=1,
Text="",
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
TextSize=12,
TextTransparency=0.18,
ThemeTag={
TextColor3="Text",
},
ZIndex=10052,
}),
al("UIPadding",{
PaddingLeft=UDim.new(0,9),
PaddingRight=UDim.new(0,9),
PaddingTop=UDim.new(0,4),
PaddingBottom=UDim.new(0,4),
}),
})

local A=0

local function HideHoverHint()
A+=1
z.Visible=false
end

local function ShowHoverHint(B,C)
A+=1
local F=A

task.spawn(function()
task.wait(0.32)

if F~=A or not B or not B.Parent then
return
end

z.Label.Text=C or""
z.Visible=true
z.ImageTransparency=0.14
z.Outline.ImageTransparency=0.86

task.wait()

if F~=A or not B or not B.Parent then
z.Visible=false
return
end

local G=x.AbsolutePosition
local H=B.AbsolutePosition
local J=B.AbsoluteSize
local L=z.AbsoluteSize

local M=(H.X-G.X)+(J.X/2)-(L.X/2)
local N=math.max(x.AbsoluteSize.X-L.X-8,8)
M=math.clamp(M,8,N)

z.Position=UDim2.new(0,M,1,6)

am(z,0.12,{
ImageTransparency=0.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

am(z.Outline,0.12,{
ImageTransparency=0.8,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)
end

local function UpdateTopbarLayout()
local B=as.WindUI.UIScale
local C=x.Right.UIListLayout.AbsoluteContentSize.X/B
local F=x.Left.AbsoluteSize.X/B

if at.Topbar.ButtonsType=="Mac"then
local G=x.MacButtons.UIListLayout.AbsoluteContentSize.X/B
local H=G+8

x.Left.Position=UDim2.new(0,H,0,0)
F=F+H
else
x.Left.Position=UDim2.new(0,0,0,0)
end

x.Center.Position=UDim2.new(
0,
F+(at.UIPadding/B),
0.5,
0
)

x.Center.Size=UDim2.new(
1,
-F-C-((at.UIPadding*2)/B),
1,
0
)
end

ak.AddSignal(x.Left:GetPropertyChangedSignal"AbsoluteSize",UpdateTopbarLayout)
ak.AddSignal(x.Right.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",UpdateTopbarLayout)

if at.Topbar.ButtonsType=="Mac"then
ak.AddSignal(x.MacButtons.UIListLayout:GetPropertyChangedSignal"AbsoluteContentSize",UpdateTopbarLayout)
end

task.defer(UpdateTopbarLayout)

function at.CreateTopbarButton(B,C,F,G,H,J,L,M,N,O)
local P=L or Color3.fromHex"#F4695F"

local Q=at.Topbar.ButtonsType=="Mac"
local R=Q and N==true
local S=Q and not R

local T=(at.Topbar.ButtonsType=="Default")or S

local U=ak.Image(
F,
F,
0,
at.Folder,
"WindowTopbarIcon",
T,
J,
"WindowTopbarButtonIcon"
)

if S then
local V=M or 18

U.Size=UDim2.new(0,V,0,V)
U.AnchorPoint=Vector2.new(0.5,0.5)
U.Position=UDim2.new(0.5,0,0.5,0)
U.ImageLabel.ImageTransparency=0.22
U.ImageLabel.ImageColor3=P==Color3.fromHex"#F4695F"
and Color3.fromRGB(235,235,235)
or P

local W=al("TextButton",{
Size=UDim2.new(0,28,0,28),
BackgroundTransparency=1,
Text="",
AutoButtonColor=false,
ZIndex=9999,
},{
U,
al("UIScale",{
Scale=1,
}),
})

local X=al("Frame",{
Size=UDim2.new(0,28,0,28),
BackgroundTransparency=1,
Parent=x.Right,
LayoutOrder=H or 999,
},{
W,
})

at.TopBarButtons[100-(H or 999)]={
Name=C,
Object=X,
}

ak.AddSignal(W.MouseButton1Click,function()
if G then
G()
end
end)

ak.AddSignal(W.MouseEnter,function()
ShowHoverHint(X,O or C or"")
am(W.UIScale,0.12,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

am(U.ImageLabel,0.12,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

ak.AddSignal(W.MouseLeave,function()
HideHoverHint()
am(W.UIScale,0.12,{
Scale=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

am(U.ImageLabel,0.12,{
ImageTransparency=0.22,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

ak.AddSignal(W.MouseButton1Down,function()
am(W.UIScale,0.08,{
Scale=0.92,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

ak.AddSignal(W.InputEnded,function()
am(W.UIScale,0.12,{
Scale=1.08,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

return X
end

U.Size=at.Topbar.ButtonsType=="Default"
and UDim2.new(0,M or at.TopBarButtonIconSize,0,M or at.TopBarButtonIconSize)
or UDim2.new(0,0,0,0)
U.AnchorPoint=Vector2.new(0.5,0.5)
U.Position=UDim2.new(0.5,0,0.5,0)
U.ImageLabel.ImageTransparency=at.Topbar.ButtonsType=="Default"and 0 or 1

if R then
U.ImageLabel.ImageColor3=ak.GetTextColorForHSB(P)
end

local V=ak.NewRoundFrame(
at.Topbar.ButtonsType=="Default"and at.UICorner-(at.UIPadding/2)or 999,
"Squircle",
{
Size=at.Topbar.ButtonsType=="Default"
and UDim2.new(0,at.Topbar.Height-16,0,at.Topbar.Height-16)
or UDim2.new(0,14,0,14),
LayoutOrder=H or 999,
ZIndex=9999,
AnchorPoint=Vector2.new(0.5,0.5),
Position=UDim2.new(0.5,0,0.5,0),
ImageColor3=R and P or nil,
ThemeTag=at.Topbar.ButtonsType=="Default"and{
ImageColor3="Text",
}or nil,
ImageTransparency=at.Topbar.ButtonsType=="Default"and 1 or 0,
},
{
ak.NewRoundFrame(
at.Topbar.ButtonsType=="Default"and at.UICorner-(at.UIPadding/2)or 999,
"Glass-1",
{
Size=UDim2.new(1,0,1,0),
ThemeTag={
ImageColor3="Outline",
},
ImageTransparency=at.Topbar.ButtonsType=="Default"and 1 or 0.5,
Name="Outline",
}
),
U,
al("UIScale",{
Scale=1,
}),
},
true
)

local W=x.Right
if R then
W=x.MacButtons
end

local X=al("Frame",{
Size=at.Topbar.ButtonsType~="Default"and UDim2.new(0,24,0,24)
or UDim2.new(0,at.Topbar.Height-16,0,at.Topbar.Height-16),
BackgroundTransparency=1,
Parent=W,
LayoutOrder=H or 999,
},{
V,
})

at.TopBarButtons[100-(H or 999)]={
Name=C,
Object=X,
}

ak.AddSignal(V.MouseButton1Click,function()
if G then
G()
end
end)

ak.AddSignal(V.MouseEnter,function()
if at.Topbar.ButtonsType=="Default"then
am(V,0.15,{ImageTransparency=0.93}):Play()
am(V.Outline,0.15,{ImageTransparency=0.75}):Play()
else
am(
U.ImageLabel,
0.1,
{ImageTransparency=0},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

am(
U,
0.1,
{
Size=UDim2.new(
0,
M or at.TopBarButtonIconSize,
0,
M or at.TopBarButtonIconSize
),
},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

ak.AddSignal(V.MouseButton1Down,function()
am(V.UIScale,0.2,{Scale=0.9},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end)

ak.AddSignal(V.MouseLeave,function()
if at.Topbar.ButtonsType=="Default"then
am(V,0.1,{ImageTransparency=1}):Play()
am(V.Outline,0.1,{ImageTransparency=1}):Play()
else
am(
U.ImageLabel,
0.1,
{ImageTransparency=1},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

am(
U,
0.1,
{Size=UDim2.new(0,0,0,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
end
end)

ak.AddSignal(V.InputEnded,function()
am(V.UIScale,0.2,{Scale=1},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end)

return X
end

function at.Topbar.Button(B,C)
return at:CreateTopbarButton(
C.Name,
C.Icon,
C.Callback,
C.LayoutOrder or 0,
C.IconThemed,
C.Color,
C.IconSize,
false,
C.Title
)
end

local B=ak.Drag(
at.UIElements.Main,
{at.UIElements.Main.Main.Topbar,j.Frame},
function(B,C)
if not at.Closed then
if B and C==j.Frame then
am(j,0.1,{ImageTransparency=0.35}):Play()
else
am(j,0.2,{ImageTransparency=0.8}):Play()
end
at.Position=at.UIElements.Main.Position
at.Dragging=B
end
end
)

if not d and at.Background and typeof(at.Background)=="table"then
local C=al"UIGradient"
for F,G in next,at.Background do
C[F]=G
end

at.UIElements.BackgroundGradient=ak.NewRoundFrame(at.UICorner,"Squircle",{
Size=UDim2.new(1,0,1,0),
Parent=at.UIElements.Main.Background,
ImageTransparency=at.Transparent and as.WindUI.TransparencyValue or 0,
},{
C,
})
end

at.OpenButtonMain=a.load'z'.New(at)

task.spawn(function()
if at.Icon then
local C=al("Frame",{
Size=UDim2.new(0,22,0,22),
BackgroundTransparency=1,
Parent=at.UIElements.Main.Main.Topbar.Left,
})

m=ak.Image(
at.Icon,
at.Title,
at.IconRadius,
at.Folder,
"Window",
true,
at.IconThemed,
"WindowTopbarIcon"
)
m.Parent=C
m.Size=UDim2.new(0,at.IconSize,0,at.IconSize)
m.Position=UDim2.new(0.5,0,0.5,0)
m.AnchorPoint=Vector2.new(0.5,0.5)

at.OpenButtonMain:SetIcon(at.Icon)
else
at.OpenButtonMain:SetIcon(at.Icon)
end
end)

function at.SetToggleKey(C,F)
at.ToggleKey=F
end

function at.SetTitle(C,F)
at.Title=F
if at.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function at.SetSubTitle(C,F)
at.SubTitle=F
if at.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function at.SetTitleMessages(C,F)
at.TitleMessages=F
if at.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function at.SetTitleAnim(C,F)
at.TitleAnim=F
if at.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function at.SetTitleStyle(C,F,G,H)
if F then
at.TitleFont=F
end
if G then
at.TitleFontWeight=G
end
if H then
at.TitleTextSize=H
end

ApplyWindowTitleFont()

if at.Closed then
StopWindowTitleAnimation()
else
RunWindowTitleAnimation()
end
end

function at.SetAuthor(C,F)
at.Author=F
if not l then
l=createAuthor(at.Author)
end
l.Text=F
end

function at.SetSize(C,F)
if typeof(F)=="UDim2"then
at.Size=F
am(at.UIElements.Main,0.08,{Size=F},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

function at.SetBackgroundImage(C,F)
at.UIElements.Main.Background.ImageLabel.Image=F
end

function at.SetBackgroundImageTransparency(C,F)
if f and f:IsA"ImageLabel"then
f.ImageTransparency=math.floor(F*10+0.5)/10
end
at.BackgroundImageTransparency=math.floor(F*10+0.5)/10
end

function at.SetBackgroundTransparency(C,F)
local G=math.floor(tonumber(F)*10+0.5)/10
as.WindUI.TransparencyValue=G
at:ToggleTransparency(G>0)
end

local C
local F

at:CreateTopbarButton(
"Fullscreen",
at.Topbar.ButtonsType=="Mac"and"rbxassetid://127426072704909"or"maximize",
function()
at:ToggleFullscreen()
end,
(at.Topbar.ButtonsType=="Default"and 998 or 999),
true,
Color3.fromHex"#60C762",
at.Topbar.ButtonsType=="Mac"and 9 or nil,
at.Topbar.ButtonsType=="Mac"
)

function at.ToggleFullscreen(G)
local H=at.IsFullscreen
B:Set(H)

if not H then
C=at.UIElements.Main.Position
F=at.UIElements.Main.Size
at.CanResize=false
else
if at.Resizable then
at.CanResize=true
end
end

am(
at.UIElements.Main,
0.45,
{Size=H and F or UDim2.new(1,-20,1,-72)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

am(
at.UIElements.Main,
0.45,
{Position=H and C or UDim2.new(0.5,0,0.5,26)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

at.IsFullscreen=not H
end

at:CreateTopbarButton(
"Minimize",
"minus",
function()
at:Close()
end,
(at.Topbar.ButtonsType=="Default"and 997 or 998),
nil,
Color3.fromHex"#F4C948",
nil,
at.Topbar.ButtonsType=="Mac"
)

function at.OnOpen(G,H)
at.OnOpenCallback=H
end

function at.OnClose(G,H)
at.OnCloseCallback=H
end

function at.OnDestroy(G,H)
at.OnDestroyCallback=H
end

if as.WindUI.UseAcrylic then
at.AcrylicPaint.AddParent(at.UIElements.Main)
end

function at.SetIconSize(G,H)
local J
if typeof(H)=="number"then
J=UDim2.new(0,H,0,H)
at.IconSize=H
elseif typeof(H)=="UDim2"then
J=H
at.IconSize=H.X.Offset
end

if m then
m.Size=J
end
end

function at.Open(G)
task.spawn(function()
if at.OnOpenCallback then
task.spawn(function()
ak.SafeCallback(at.OnOpenCallback)
end)
end

task.wait(0.06)
at.Closed=false

am(at.UIElements.Main.Background,0.2,{
ImageTransparency=at.Transparent and as.WindUI.TransparencyValue or 0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()

if at.UIElements.BackgroundGradient then
am(at.UIElements.BackgroundGradient,0.2,{
ImageTransparency=0,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

am(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,0),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.Out):Play()

if f then
if f:IsA"VideoFrame"then
f.Visible=true
else
am(f,0.2,{
ImageTransparency=at.BackgroundImageTransparency,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

if at.OpenButtonMain and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(false)
end

am(
az,
0.25,
{ImageTransparency=at.ShadowTransparency},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()

if v then
am(v,0.25,{Transparency=0.8},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

task.spawn(function()
task.wait(0.3)
am(
j,
0.45,
{Size=UDim2.new(0,at.DragFrameSize,0,4),ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
B:Set(true)
task.wait(0.45)
if at.Resizable then
am(
aw.ImageLabel,
0.45,
{ImageTransparency=0.8},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()
at.CanResize=true
end
end)

at.CanDropdown=true
at.UIElements.Main.Visible=true

task.spawn(function()
task.wait(0.05)
at.UIElements.Main:WaitForChild"Main".Visible=true
RunWindowTitleAnimation()
as.WindUI:ToggleAcrylic(true)
end)
end)
end

function at.Close(G)
local H={}

if at.OnCloseCallback then
task.spawn(function()
ak.SafeCallback(at.OnCloseCallback)
end)
end

as.WindUI:ToggleAcrylic(false)
at.UIElements.Main:WaitForChild"Main".Visible=false
StopWindowTitleAnimation()

at.CanDropdown=false
at.Closed=true

am(at.UIElements.Main.Background,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()

if at.UIElements.BackgroundGradient then
am(at.UIElements.BackgroundGradient,0.32,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.InOut):Play()
end

am(at.UIElements.Main.Background,0.4,{
Size=UDim2.new(1,0,1,-240),
},Enum.EasingStyle.Exponential,Enum.EasingDirection.InOut):Play()

if f then
if f:IsA"VideoFrame"then
f.Visible=false
else
am(f,0.3,{
ImageTransparency=1,
},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end
end

am(az,0.25,{ImageTransparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
if v then
am(v,0.25,{Transparency=1},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
end

am(
j,
0.3,
{Size=UDim2.new(0,0,0,4),ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.InOut
):Play()

am(
aw.ImageLabel,
0.3,
{ImageTransparency=1},
Enum.EasingStyle.Exponential,
Enum.EasingDirection.Out
):Play()

B:Set(false)
at.CanResize=false

task.spawn(function()
task.wait(0.4)
at.UIElements.Main.Visible=false

if at.OpenButtonMain and not at.Destroyed and not at.IsPC and at.IsOpenButtonEnabled then
at.OpenButtonMain:Visible(true)
end
end)

function H.Destroy(J)
task.spawn(function()
if at.OnDestroyCallback then
task.spawn(function()
ak.SafeCallback(at.OnDestroyCallback)
end)
end

if at.AcrylicPaint and at.AcrylicPaint.Model then
at.AcrylicPaint.Model:Destroy()
end

at.Destroyed=true
task.wait(0.4)

as.WindUI.ScreenGui:Destroy()
as.WindUI.NotificationGui:Destroy()
as.WindUI.DropdownGui:Destroy()
as.WindUI.TooltipGui:Destroy()

ak.DisconnectAll()
return
end)
end

return H
end

function at.Destroy(G)
return at:Close():Destroy()
end

function at.Toggle(G)
if at.Closed then
at:Open()
else
at:Close()
end
end

function at.ToggleTransparency(G,H)
at.Transparent=H
as.WindUI.Transparent=H
at.UIElements.Main.Background.ImageTransparency=H and as.WindUI.TransparencyValue or 0
end

function at.LockAll(G)
for H,J in next,at.AllElements do
if J.Lock then
J:Lock()
end
end
end

function at.UnlockAll(G)
for H,J in next,at.AllElements do
if J.Unlock then
J:Unlock()
end
end
end

function at.GetLocked(G)
local H={}
for J,L in next,at.AllElements do
if L.Locked then
table.insert(H,L)
end
end
return H
end

function at.GetUnlocked(G)
local H={}
for J,L in next,at.AllElements do
if L.Locked==false then
table.insert(H,L)
end
end
return H
end

function at.GetUIScale(G)
return as.WindUI.UIScale
end

function at.SetUIScale(G,H)
as.WindUI.UIScale=H
am(as.WindUI.UIScaleObj,0.2,{Scale=H},Enum.EasingStyle.Quint,Enum.EasingDirection.Out):Play()
return at
end

function at.SetToTheCenter(G)
am(
at.UIElements.Main,
0.45,
{Position=UDim2.new(0.5,0,0.5,0)},
Enum.EasingStyle.Quint,
Enum.EasingDirection.Out
):Play()
return at
end

function at.SetCurrentConfig(G,H)
at.CurrentConfig=H
end

do
local G=40
local H=ai.ViewportSize
local J=at.UIElements.Main.AbsoluteSize

if not at.IsFullscreen and at.AutoScale then
local L=H.X-(G*2)
local M=H.Y-(G*2)

local N=L/J.X
local O=M/J.Y

local P=math.min(N,O)
local Q=math.clamp(P,0.3,1.0)

local R=at:GetUIScale()or 1
local S=0.05

if math.abs(Q-R)>S then
at:SetUIScale(Q)
end
end
end

if at.OpenButtonMain and at.OpenButtonMain.Button then
ak.AddSignal(at.OpenButtonMain.Button.TextButton.MouseButton1Click,function()
at:Open()
end)
end

ak.AddSignal(ad.InputBegan,function(G,H)
if H then
return
end

if at.ToggleKey and G.KeyCode==at.ToggleKey then
at:Toggle()
end
end)

task.spawn(function()
at:Open()
end)

function at.EditOpenButton(G,H)
return at.OpenButtonMain:Edit(H)
end

if at.OpenButton and typeof(at.OpenButton)=="table"then
at:EditOpenButton(at.OpenButton)
end

local G=a.load'V'
local H=a.load'W'
local J=G.Init(at,as.WindUI,as.WindUI.TooltipGui)

J:OnChange(function(L)
at.CurrentTab=L
end)

at.TabModule=J

function at.Tab(L,M)
M.Parent=at.UIElements.SideBar.Frame
return J.New(M,as.WindUI.UIScale)
end

function at.SelectTab(L,M)
J:SelectTab(M)
end

function at.Section(L,M)
return H.New(
M,
at.UIElements.SideBar.Frame,
at.Folder,
as.WindUI.UIScale,
at
)
end

function at.IsResizable(L,M)
at.Resizable=M
at.CanResize=M
end

function at.SetPanelBackground(L,M)
if typeof(M)=="boolean"then
at.HidePanelBackground=M
at.UIElements.MainBar.Background.Visible=M

if J then
for N,O in next,J.Containers do
O.ScrollingFrame.UIPadding.PaddingTop=UDim.new(0,at.HidePanelBackground and 20 or 10)
O.ScrollingFrame.UIPadding.PaddingLeft=UDim.new(0,at.HidePanelBackground and 20 or 10)
O.ScrollingFrame.UIPadding.PaddingRight=UDim.new(0,at.HidePanelBackground and 20 or 10)
O.ScrollingFrame.UIPadding.PaddingBottom=UDim.new(0,at.HidePanelBackground and 20 or 10)
end
end
end
end

function at.Divider(L)
local M=al("Frame",{
Size=UDim2.new(1,0,0,1),
Position=UDim2.new(0.5,0,0,0),
AnchorPoint=Vector2.new(0.5,0),
BackgroundTransparency=0.9,
ThemeTag={
BackgroundColor3="Text",
},
})

local N=al("Frame",{
Parent=at.UIElements.SideBar.Frame,
Size=UDim2.new(1,-7,0,5),
BackgroundTransparency=1,
},{
M,
})

return N
end

local L=a.load'n'.Init(at,as.WindUI,nil)
function at.Dialog(M,N)
local O={
Title=N.Title or"Dialog",
Width=N.Width or 320,
Content=N.Content,
Buttons=N.Buttons or{},
TextPadding=14,
}

local P=L.Create(false)
P.UIElements.Main.Size=UDim2.new(0,O.Width,0,0)

local Q=al("Frame",{
Size=UDim2.new(1,0,1,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=P.UIElements.Main,
},{
al("UIListLayout",{
FillDirection="Vertical",
Padding=UDim.new(0,P.UIPadding),
}),
})

local R=al("Frame",{
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
BackgroundTransparency=1,
Parent=Q,
},{
al("UIListLayout",{
FillDirection="Horizontal",
Padding=UDim.new(0,P.UIPadding),
VerticalAlignment="Center",
}),
al("UIPadding",{
PaddingTop=UDim.new(0,O.TextPadding/2),
PaddingLeft=UDim.new(0,O.TextPadding/2),
PaddingRight=UDim.new(0,O.TextPadding/2),
}),
})

local S
if N.Icon then
S=ak.Image(
N.Icon,
O.Title..":"..N.Icon,
0,
at,
"Dialog",
true,
N.IconThemed
)
S.Size=UDim2.new(0,22,0,22)
S.Parent=R
end

P.UIElements.UIListLayout=al("UIListLayout",{
Padding=UDim.new(0,12),
FillDirection="Vertical",
HorizontalAlignment="Left",
VerticalFlex="SpaceBetween",
Parent=P.UIElements.Main,
})

al("UISizeConstraint",{
MinSize=Vector2.new(180,20),
MaxSize=Vector2.new(400,math.huge),
Parent=P.UIElements.Main,
})

P.UIElements.Title=al("TextLabel",{
Text=O.Title,
TextSize=20,
FontFace=Font.new(ak.Font,Enum.FontWeight.SemiBold),
TextXAlignment="Left",
TextWrapped=true,
RichText=true,
Size=UDim2.new(1,S and-26-P.UIPadding or 0,0,0),
AutomaticSize="Y",
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=R,
})

if O.Content then
al("TextLabel",{
Text=O.Content,
TextSize=18,
TextTransparency=0.4,
TextWrapped=true,
RichText=true,
FontFace=Font.new(ak.Font,Enum.FontWeight.Medium),
TextXAlignment="Left",
Size=UDim2.new(1,0,0,0),
AutomaticSize="Y",
LayoutOrder=2,
ThemeTag={
TextColor3="Text",
},
BackgroundTransparency=1,
Parent=Q,
},{
al("UIPadding",{
PaddingLeft=UDim.new(0,O.TextPadding/2),
PaddingRight=UDim.new(0,O.TextPadding/2),
PaddingBottom=UDim.new(0,O.TextPadding/2),
}),
})
end

local T=al("UIListLayout",{
Padding=UDim.new(0,6),
FillDirection="Horizontal",
HorizontalAlignment="Right",
})

local U=al("Frame",{
Size=UDim2.new(1,0,0,40),
AutomaticSize="None",
BackgroundTransparency=1,
Parent=P.UIElements.Main,
LayoutOrder=4,
},{
T,
})

local V={}

for W,X in next,O.Buttons do
local Y=
ao(X.Title,X.Icon,X.Callback,X.Variant,U,P,true)
table.insert(V,Y)
end

local function CheckButtonsOverflow()
T.FillDirection=Enum.FillDirection.Horizontal
T.HorizontalAlignment=Enum.HorizontalAlignment.Right
T.VerticalAlignment=Enum.VerticalAlignment.Center
U.AutomaticSize=Enum.AutomaticSize.None

for W,X in ipairs(V)do
X.Size=UDim2.new(0,0,1,0)
X.AutomaticSize=Enum.AutomaticSize.X
end

task.wait()

local W=T.AbsoluteContentSize.X/as.WindUI.UIScale
local X=U.AbsoluteSize.X/as.WindUI.UIScale

if W>X then
T.FillDirection=Enum.FillDirection.Vertical
T.HorizontalAlignment=Enum.HorizontalAlignment.Right
T.VerticalAlignment=Enum.VerticalAlignment.Bottom
U.AutomaticSize=Enum.AutomaticSize.Y

for Y,_ in ipairs(V)do
_.Size=UDim2.new(1,0,0,40)
_.AutomaticSize=Enum.AutomaticSize.None
end
else
local Y=X-W
if Y>0 then
local _
local aC=math.huge

for aD,aE in ipairs(V)do
local aF=aE.AbsoluteSize.X/as.WindUI.UIScale
if aF<aC then
aC=aF
_=aE
end
end

if _ then
_.Size=UDim2.new(0,aC+Y,1,0)
_.AutomaticSize=Enum.AutomaticSize.None
end
end
end
end

ak.AddSignal(P.UIElements.Main:GetPropertyChangedSignal"AbsoluteSize",CheckButtonsOverflow)
CheckButtonsOverflow()

task.wait()
P:Open()

return P
end

local aC=false

at:CreateTopbarButton(
"Close",
"x",
function()
if not aC then
if not at.IgnoreAlerts then
aC=true
at:SetToTheCenter()
at:Dialog{
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
at:Destroy()
end,
Variant="Primary",
},
},
}
else
at:Destroy()
end
end
end,
(at.Topbar.ButtonsType=="Default"and 999 or 997),
nil,
Color3.fromHex"#F4695F",
nil,
at.Topbar.ButtonsType=="Mac"
)

function at.Tag(aD,aE)
if at.UIElements.Main.Main.Topbar.Center.Visible==false then
at.UIElements.Main.Main.Topbar.Center.Visible=true
end
return aq:New(aE,at.UIElements.Main.Main.Topbar.Center)
end

local aD
local aE
local aF

local function startResizing(M)
if at.CanResize then
aD=true
ax.Active=true
aE=at.UIElements.Main.Size
aF=M.Position
am(aw.ImageLabel,0.1,{ImageTransparency=0.35}):Play()

ak.AddSignal(M.Changed,function()
if M.UserInputState==Enum.UserInputState.End then
aD=false
ax.Active=false
am(aw.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)
end
end

ak.AddSignal(aw.InputBegan,function(M)
if M.UserInputType==Enum.UserInputType.MouseButton1 or M.UserInputType==Enum.UserInputType.Touch then
if at.CanResize then
startResizing(M)
end
end
end)

ak.AddSignal(ad.InputChanged,function(M)
if M.UserInputType==Enum.UserInputType.MouseMovement or M.UserInputType==Enum.UserInputType.Touch then
if aD and at.CanResize then
local N=M.Position-aF
local O=UDim2.new(0,aE.X.Offset+N.X*2,0,aE.Y.Offset+N.Y*2)

O=UDim2.new(
O.X.Scale,
math.clamp(O.X.Offset,at.MinSize.X,at.MaxSize.X),
O.Y.Scale,
math.clamp(O.Y.Offset,at.MinSize.Y,at.MaxSize.Y)
)

am(at.UIElements.Main,0.08,{
Size=O,
},Enum.EasingStyle.Quad,Enum.EasingDirection.Out):Play()

at.Size=O
end
end
end)

ak.AddSignal(aw.MouseEnter,function()
if not aD then
am(aw.ImageLabel,0.1,{ImageTransparency=0.35}):Play()
end
end)

ak.AddSignal(aw.MouseLeave,function()
if not aD then
am(aw.ImageLabel,0.17,{ImageTransparency=0.8}):Play()
end
end)

local M=0
local N=0.4
local O
local P=0

local function onDoubleClick()
at:SetToTheCenter()
end

ak.AddSignal(j.Frame.MouseButton1Up,function()
local Q=tick()
local R=at.Position

P+=1

if P==1 then
M=Q
O=R

task.spawn(function()
task.wait(N)
if P==1 then
P=0
O=nil
end
end)
elseif P==2 then
if Q-M<=N and R==O then
onDoubleClick()
end

P=0
O=nil
M=0
else
P=1
M=Q
O=R
end
end)

if not at.HideSearchBar then
local Q=a.load'Y'
local R=false

local S=an("Search","search",at.UIElements.SideBarContainer,true)
S.Size=UDim2.new(1,-at.UIPadding/2,0,39)
S.Position=UDim2.new(0,at.UIPadding/2,0,0)

ak.AddSignal(S.MouseButton1Click,function()
if R then
return
end

Q.new(at.TabModule,at.UIElements.Main,function()
R=false
if at.Resizable then
at.CanResize=true
end

am(ay,0.1,{ImageTransparency=1}):Play()
ay.Active=false
end)

am(ay,0.1,{ImageTransparency=0.65}):Play()
ay.Active=true

R=true
at.CanResize=false
end)
end

function at.DisableTopbarButtons(Q,R)
for S,T in next,R do
for U,V in next,at.TopBarButtons do
if V.Name==T then
V.Object.Visible=false
end
end
end
end

return at
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

local ad=(cloneref or clonereference or function(ad)
return ad
end)

aa.cloneref=ad

local ae=ad(game:GetService"HttpService")
local ag=ad(game:GetService"Players")
local ai=ad(game:GetService"CoreGui")
local aj=ad(game:GetService"RunService")

local ak=ag.LocalPlayer or nil

local al=ae:JSONDecode(a.load'k')
if al then
aa.Version=al.version
end

local am=a.load'o'

local an=aa.Creator

local ao=an.New




local ap=a.load's'

local aq=protectgui or(syn and syn.protect_gui)or function()end

local ar=gethui and gethui()or(ai or ak:WaitForChild"PlayerGui")

local as=ao("UIScale",{
Scale=aa.UIScale,
})

aa.UIScaleObj=as

aa.ScreenGui=ao("ScreenGui",{
Name="WindUI",
Parent=ar,
IgnoreGuiInset=true,
ScreenInsets="None",
},{

ao("Folder",{
Name="Window",
}),






ao("Folder",{
Name="KeySystem",
}),
ao("Folder",{
Name="Popups",
}),
ao("Folder",{
Name="ToolTips",
}),
})

aa.NotificationGui=ao("ScreenGui",{
Name="WindUI/Notifications",
Parent=ar,
IgnoreGuiInset=true,
})
aa.DropdownGui=ao("ScreenGui",{
Name="WindUI/Dropdowns",
Parent=ar,
IgnoreGuiInset=true,
})
aa.TooltipGui=ao("ScreenGui",{
Name="WindUI/Tooltips",
Parent=ar,
IgnoreGuiInset=true,
})
aq(aa.ScreenGui)
aq(aa.NotificationGui)
aq(aa.DropdownGui)
aq(aa.TooltipGui)

an.Init(aa)

function aa.SetParent(at,au)
if aa.ScreenGui then
aa.ScreenGui.Parent=au
end
if aa.NotificationGui then
aa.NotificationGui.Parent=au
end
if aa.DropdownGui then
aa.DropdownGui.Parent=au
end
if aa.TooltipGui then
aa.TooltipGui.Parent=au
end
end
math.clamp(aa.TransparencyValue,0,1)

local at=aa.NotificationModule.Init(aa.NotificationGui)

function aa.Notify(au,av)
av.Holder=at.Frame
av.Window=aa.Window

return aa.NotificationModule.New(av)
end

function aa.SetNotificationLower(au,av)
at.SetLower(av)
end

function aa.SetFont(au,av)
an.UpdateFont(av)
end

function aa.OnThemeChange(au,av)
aa.OnThemeChangeFunction=av
end

function aa.AddTheme(au,av)
aa.Themes[av.Name]=av
return av
end

function aa.SetTheme(au,av)
if aa.Themes[av]then
aa.Theme=aa.Themes[av]
an.SetTheme(aa.Themes[av])

if aa.OnThemeChangeFunction then
aa.OnThemeChangeFunction(av)
end

return aa.Themes[av]
end
return nil
end

function aa.GetThemes(au)
return aa.Themes
end
function aa.GetCurrentTheme(au)
return aa.Theme.Name
end
function aa.GetTransparency(au)
return aa.Transparent or false
end
function aa.GetWindowSize(au)
return aa.Window.UIElements.Main.Size
end
function aa.Localization(au,av)
return aa.LocalizationModule:New(av,an)
end

function aa.SetLanguage(au,av)
if an.Localization then
return an.SetLanguage(av)
end
return false
end

function aa.ToggleAcrylic(au,av)
if aa.Window and aa.Window.AcrylicPaint and aa.Window.AcrylicPaint.Model then
aa.Window.Acrylic=av
aa.Window.AcrylicPaint.Model.Transparency=av and 0.98 or 1
if av then
ap.Enable()
else
ap.Disable()
end
end
end

function aa.Gradient(au,av,aw)
local ax={}
local ay={}

for az,aA in next,av do
local aB=tonumber(az)
if aB then
aB=math.clamp(aB/100,0,1)

local aC=aA.Color
if typeof(aC)=="string"and string.sub(aC,1,1)=="#"then
aC=Color3.fromHex(aC)
end

local aD=aA.Transparency or 0

table.insert(ax,ColorSequenceKeypoint.new(aB,aC))
table.insert(ay,NumberSequenceKeypoint.new(aB,aD))
end
end

table.sort(ax,function(az,aA)
return az.Time<aA.Time
end)
table.sort(ay,function(az,aA)
return az.Time<aA.Time
end)

if#ax<2 then
table.insert(ax,ColorSequenceKeypoint.new(1,ax[1].Value))
table.insert(ay,NumberSequenceKeypoint.new(1,ay[1].Value))
end

local az={
Color=ColorSequence.new(ax),
Transparency=NumberSequence.new(ay),
}

if aw then
for aA,aB in pairs(aw)do
az[aA]=aB
end
end

return az
end

function aa.Popup(au,av)
av.WindUI=aa
return a.load't'.new(av)
end

aa.Themes=a.load'u'(aa)

an.Themes=aa.Themes

aa:SetTheme"Dark"
aa:SetLanguage(an.Language)

function aa.CreateWindow(au,av)
local aw=a.load'Z'

if not aj:IsStudio()and writefile then
if not isfolder"WindUI"then
makefolder"WindUI"
end
if av.Folder then
makefolder(av.Folder)
else
makefolder(av.Title)
end
end

av.WindUI=aa
av.Parent=aa.ScreenGui.Window

if aa.Window then
warn"You cannot create more than one window"
return
end

local ax=true

local ay=aa.Themes[av.Theme or"Dark"]


an.SetTheme(ay)

local az=gethwid or function()
return ag.LocalPlayer.UserId
end

local aA=az()

if av.KeySystem then
ax=false

local function loadKeysystem()
am.new(av,aA,function(aB)
ax=aB
end)
end

local aB=(av.Folder or"Temp").."/"..aA..".key"

if av.KeySystem.KeyValidator then
if av.KeySystem.SaveKey and isfile(aB)then
local aC=readfile(aB)
local aD=av.KeySystem.KeyValidator(aC)

if aD then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
elseif not av.KeySystem.API then
if av.KeySystem.SaveKey and isfile(aB)then
local aC=readfile(aB)
local aD=(type(av.KeySystem.Key)=="table")and table.find(av.KeySystem.Key,aC)
or tostring(av.KeySystem.Key)==tostring(aC)

if aD then
ax=true
else
loadKeysystem()
end
else
loadKeysystem()
end
else
if isfile(aB)then
local aC=readfile(aB)
local aD=false

for aE,aF in next,av.KeySystem.API do
local b=aa.Services[aF.Type]
if b then
local d={}
for f,g in next,b.Args do
table.insert(d,aF[g])
end

local f=b.New(table.unpack(d))
local g=f.Verify(aC)
if g then
aD=true
break
end
end
end

ax=aD
if not aD then
loadKeysystem()
end
else
loadKeysystem()
end
end

repeat
task.wait()
until ax
end

local aB=aw(av)

aa.Transparent=av.Transparent
aa.Window=aB

if av.Acrylic then
ap.init()
end













return aB
end

return aa