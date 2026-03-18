local Toggle = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService") 

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
    local Toggle = {}
    
    local Radius = 24/2
    local IconToggleFrame
    if Icon and Icon ~= "" then
        IconToggleFrame = New("ImageLabel", {
            Size = UDim2.new(0,20-7,0,20-7),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0.5,0.5),
            Position = UDim2.new(0.5,0,0.5,0),
            Image = Creator.Icon(Icon)[2],
            ImageRectOffset = Creator.Icon(Icon)[1].ImageRectPosition,
            ImageRectSize = Creator.Icon(Icon)[1].ImageRectSize,
            ImageTransparency = 1,
            ImageColor3 = Color3.new(0,0,0),
        })
    end
    
    local ToggleContainer = New("Frame", {
        Size = UDim2.new(0,2,0,26),
        BackgroundTransparency = 1,
        Parent = Parent,
    })

    local FrameWidth = NewElement and 30 or 20
    local ToggleWidth = NewElement and (24+24+4) or (24*1.7)

    -- === FITUR CUSTOM: BREATHING GLOW ===
    local Glow = New("ImageLabel", {
        Name = "BreathingGlow",
        BackgroundTransparency = 1,
        Image = "rbxassetid://1316045217", 
        ThemeTag = { ImageColor3 = "Accent" }, 
        ImageTransparency = 1, 
        Size = UDim2.new(0, ToggleWidth + 15, 0, 24 + 15),
        Position = UDim2.new(0, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        ZIndex = 0,
        Parent = ToggleContainer
    })

    local glowTweenInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local breathingAnim = TweenService:Create(Glow, glowTweenInfo, {
        ImageTransparency = 0.5, 
        Size = UDim2.new(0, ToggleWidth + 30, 0, 24 + 30)
    })
    -- ====================================
    
    local ToggleFrame = Creator.NewRoundFrame(Radius, "Squircle",{
        ImageTransparency =.85,
        ThemeTag = {
            ImageColor3 = "Text"
        },
        Parent = ToggleContainer,
        Size = UDim2.new(0, ToggleWidth, 0, 24),
        AnchorPoint = Vector2.new(1,0.5),
        Position = UDim2.new(0,0,0.5,0),
    }, {
        Creator.NewRoundFrame(Radius, "Squircle", {
            Size = UDim2.new(1,0,1,0),
            Name = "Layer",
            ThemeTag = {
                ImageColor3 = "Toggle",
            },
            ImageTransparency = 1, 
        }),
        Creator.NewRoundFrame(Radius, "SquircleOutline", {
            Size = UDim2.new(1,0,1,0),
            Name = "Stroke",
            ImageColor3 = Color3.new(1,1,1),
            ImageTransparency = 1, 
        }, {
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                })
            })
        }),
        
        --bar
        Creator.NewRoundFrame(Radius, "Squircle", {
            Size = UDim2.new(0, FrameWidth, 0, 20),
            Position = UDim2.new(0,2,0.5,0),
            AnchorPoint = Vector2.new(0,0.5),
            ImageTransparency = 1,
            Name = "Frame",
        }, {
            Creator.NewRoundFrame(Radius, "Squircle", {
                Size = UDim2.new(1,0,1,0),
                ImageTransparency = 0,
                ThemeTag = {
                    ImageColor3 = "ToggleBar",
                },
                AnchorPoint = Vector2.new(0.5,0.5),
                Position = UDim2.new(0.5,0,0.5,0),
                Name = "Bar"
            }, {
                Creator.NewRoundFrame(Radius, "Glass-1", {
                    Size = UDim2.new(1,0,1,0),
                    ImageColor3 = Color3.new(1,1,1),
                    Name = "Highlight",
                    ImageTransparency = 0.4,
                }),
                IconToggleFrame,
                New("UIScale", {
                    Scale = 1, 
                })
            }),
        })
    })
    
    local dragConnection
    local endConnection
    local startX
    
    function Toggle:Set(Toggled, isCallback, isAnim)
        if not isAnim then
            if Toggled then
                Tween(ToggleFrame.Frame, 0.15, {
                    Position = UDim2.new(0, ToggleWidth - FrameWidth - 2, 0.5, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            else
                Tween(ToggleFrame.Frame, 0.15, {
                    Position = UDim2.new(0, 2, 0.5, 0),
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end
        else
            if Toggled then
                ToggleFrame.Frame.Position = UDim2.new(0, ToggleWidth - FrameWidth - 2, 0.5, 0)
            else
                ToggleFrame.Frame.Position = UDim2.new(0, 2, 0.5, 0)
            end
        end
    
        if Toggled then
            Tween(ToggleFrame.Layer, 0.1, { ImageTransparency = 0 }):Play()
            if IconToggleFrame then 
                Tween(IconToggleFrame, 0.1, { ImageTransparency = 0 }):Play()
            end
            -- LOGIKA ANIMASI GLOW MENYALA
            breathingAnim:Play()
        else
            Tween(ToggleFrame.Layer, 0.1, { ImageTransparency = 1 }):Play()
            if IconToggleFrame then 
                Tween(IconToggleFrame, 0.1, { ImageTransparency = 1 }):Play()
            end
            -- LOGIKA ANIMASI GLOW MATI & MENGHILANG HALUS
            breathingAnim:Cancel()
            Tween(Glow, 0.3, { ImageTransparency = 1, Size = UDim2.new(0, ToggleWidth + 15, 0, 24 + 15) }):Play()
        end
    
        isCallback = isCallback ~= false
        
        task.spawn(function()
            if Callback and isCallback then
                Creator.SafeCallback(Callback, Toggled)
            end
        end)
    end
    
    function Toggle:Animate(input, ToggleObj)
        if not Config.Window.IsToggleDragging then
            Config.Window.IsToggleDragging = true
            
            local startMouseX = input.Position.X
            local startMouseY = input.Position.Y
            local startFrameX = ToggleFrame.Frame.Position.X.Offset
            local isScrolling = false
            
            Tween(ToggleFrame.Frame.Bar.UIScale, 0.28, {Scale = 1.5}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            Tween(ToggleFrame.Frame.Bar, 0.28, {ImageTransparency =.85}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            
            if dragConnection then
                dragConnection:Disconnect()
            end
            
            dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
                if Config.Window.IsToggleDragging and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement or inputChanged.UserInputType == Enum.UserInputType.Touch) then
                    if isScrolling then return end
                    
                    local deltaX = math.abs(inputChanged.Position.X - startMouseX)
                    local deltaY = math.abs(inputChanged.Position.Y - startMouseY)
                    
                    if deltaY > deltaX and deltaY > 10 then
                        isScrolling = true
                        Config.Window.IsToggleDragging = false
                        
                        if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                        if endConnection then endConnection:Disconnect() endConnection = nil end
                        
                        Tween(ToggleFrame.Frame, 0.15, { Position = UDim2.new(0, startFrameX, 0.5, 0) }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        Tween(ToggleFrame.Frame.Bar.UIScale, 0.23, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        Tween(ToggleFrame.Frame.Bar, 0.23, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                        return
                    end
                    
                    local mouseDelta = inputChanged.Position.X - startMouseX
                    local newX = math.max(2, math.min(startFrameX + mouseDelta, ToggleWidth - FrameWidth - 2))
                    
                    Tween(ToggleFrame.Frame, 0.05, { Position = UDim2.new(0, newX, 0.5, 0) }, Enum.EasingStyle.Linear, Enum.EasingDirection.Out):Play()
                end
            end)
            
            if endConnection then endConnection:Disconnect() end
            
            endConnection = UserInputService.InputEnded:Connect(function(inputEnded)
                if Config.Window.IsToggleDragging and (inputEnded.UserInputType == Enum.UserInputType.MouseButton1 or inputEnded.UserInputType == Enum.UserInputType.Touch) then
                    Config.Window.IsToggleDragging = false
                    
                    if dragConnection then dragConnection:Disconnect() dragConnection = nil end
                    if endConnection then endConnection:Disconnect() endConnection = nil end
                    
                    if isScrolling then return end
                    
                    local currentX = ToggleFrame.Frame.Position.X.Offset
                    local delta = math.abs(inputEnded.Position.X - startMouseX)
                    
                    if delta < 10 then
                        local objValue = not ToggleObj.Value
                        ToggleObj:Set(objValue, true, false)
                    else
                        local barCenter = currentX + FrameWidth / 2
                        local toggleCenter = ToggleWidth / 2
                        local newValue = barCenter > toggleCenter
                        ToggleObj:Set(newValue, true, false)
                    end
                    
                    Tween(ToggleFrame.Frame.Bar.UIScale, 0.23, {Scale = 1}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                    Tween(ToggleFrame.Frame.Bar, 0.23, {ImageTransparency = 0}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
                end
            end)
        end
    end
    
    return ToggleContainer, Toggle
end

return Toggle
