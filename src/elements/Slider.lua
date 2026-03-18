local cloneref = (cloneref or clonereference or function(instance) return instance end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Element = {}

local IsSliderHolding = false

local function GetPrecisionFromStep(step)
    local stepString = tostring(step or 1)
    local decimal = stepString:match("%.(%d+)")
    return decimal and #decimal or 0
end

function Element:New(Config)
    local Slider = {
        __type = "Slider",
        Title = Config.Title or nil,
        Desc = Config.Desc or nil,
        Locked = Config.Locked or nil,
        LockedTitle = Config.LockedTitle,
        Value = Config.Value or {},
        Icons = Config.Icons or nil,
        IsTooltip = Config.IsTooltip or false,

        InputBox = Config.InputBox,
        IsTextbox = Config.IsTextbox, -- backward compatibility
        Step = Config.Step or 1,
        Precision = Config.Precision,

        Callback = Config.Callback or function() end,
        UIElements = {},
        IsFocusing = false,

        Width = Config.Width or 130,
        TextBoxWidth = Config.Window.NewElements and 58 or 50,
        ThumbSize = 13,
        IconSize = 26,
    }

    if Slider.InputBox == nil then
        Slider.InputBox = Slider.IsTextbox
    end
    Slider.InputBox = Slider.InputBox == true

    if Slider.Icons == {} then
        Slider.Icons = {
            From = "sfsymbols:sunMinFill",
            To = "sfsymbols:sunMaxFill",
        }
    end

    local isTouch
    local moveconnection
    local releaseconnection

    local MinValue = Slider.Value.Min or 0
    local MaxValue = Slider.Value.Max or 100
    local CurrentValue = Slider.Value.Default or MinValue

    local CanCallback = true
    local Precision = Slider.Precision
    if Precision == nil then
        Precision = GetPrecisionFromStep(Slider.Step)
    end

    local function FormatValue(val)
        if Precision > 0 then
            return string.format("%." .. Precision .. "f", val)
        end
        return tostring(math.floor(val + 0.5))
    end

    local function NormalizeValue(val)
        val = tonumber(val) or CurrentValue or MinValue
        val = math.clamp(val, MinValue, MaxValue)

        local step = Slider.Step or 1
        if step > 0 then
            val = MinValue + (math.floor(((val - MinValue) / step) + 0.5) * step)
        end

        val = math.clamp(val, MinValue, MaxValue)

        if Precision > 0 then
            val = tonumber(string.format("%." .. Precision .. "f", val))
        else
            val = math.floor(val + 0.5)
        end

        return val
    end

    local function ValueToDelta(val)
        if MaxValue == MinValue then
            return 0
        end
        return math.clamp((val - MinValue) / (MaxValue - MinValue), 0, 1)
    end

    local IconFrom, IconTo
    local TotalIconsWidth = 0

    if Slider.Icons then
        if Slider.Icons.From then
            IconFrom = Creator.Image(
                Slider.Icons.From,
                Slider.Icons.From,
                0,
                Config.Window.Folder,
                "SliderIconFrom",
                true,
                true,
                "SliderIconFrom"
            )
            IconFrom.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
            TotalIconsWidth = TotalIconsWidth + Slider.IconSize + 4
        end

        if Slider.Icons.To then
            IconTo = Creator.Image(
                Slider.Icons.To,
                Slider.Icons.To,
                0,
                Config.Window.Folder,
                "SliderIconTo",
                true,
                true,
                "SliderIconTo"
            )
            IconTo.Size = UDim2.new(0, Slider.IconSize, 0, Slider.IconSize)
            TotalIconsWidth = TotalIconsWidth + Slider.IconSize + 4
        end
    end

    Slider.SliderFrame = require("../components/window/Element")({
        Title = Slider.Title,
        Desc = Slider.Desc,
        Parent = Config.Parent,
        TextOffset = Slider.Width,
        Hover = false,
        Tab = Config.Tab,
        Index = Config.Index,
        Window = Config.Window,
        ElementTable = Slider,
        ParentConfig = Config,
    })

    Slider.UIElements.SliderFill = Creator.NewRoundFrame(99, "Squircle", {
        Name = "Frame",
        Size = UDim2.new(ValueToDelta(CurrentValue), 0, 1, 0),
        ImageTransparency = 0.1,
        ThemeTag = {
            ImageColor3 = "Slider",
        },
    }, {
        Creator.NewRoundFrame(99, "Squircle", {
            Size = UDim2.new(0, Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2), 0, Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2)),
            Position = UDim2.new(1, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            ThemeTag = {
                ImageColor3 = "SliderThumb",
            },
            Name = "Thumb",
        }, {
            Creator.NewRoundFrame(99, "Glass-1", {
                Size = UDim2.new(1, 0, 1, 0),
                ImageColor3 = Color3.new(1, 1, 1),
                Name = "Highlight",
                ImageTransparency = 0.6,
            }),
        })
    })

    Slider.UIElements.SliderIcon = Creator.NewRoundFrame(99, "Squircle", {
        ImageTransparency = 0.95,
        Size = UDim2.new(1, -(TotalIconsWidth > 0 and TotalIconsWidth or 0), 0, 4),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Name = "Frame",
        ThemeTag = {
            ImageColor3 = "Text",
        },
    }, {
        Slider.UIElements.SliderFill
    })

    Slider.UIElements.SliderContainer = New("Frame", {
        Size = UDim2.new(Slider.Title == nil and 1 or 0, Slider.Title == nil and 0 or Slider.Width, 0, 0),
        AutomaticSize = "Y",
        Position = UDim2.new(1, 0, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        BackgroundTransparency = 1,
        Parent = Slider.SliderFrame.UIElements.Main,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = "Vertical",
            HorizontalAlignment = "Center",
            VerticalAlignment = "Center",
            SortOrder = "LayoutOrder",
        }),
    })

    Slider.UIElements.ValueRow = New("Frame", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Visible = Slider.InputBox,
        Parent = Slider.UIElements.SliderContainer,
        LayoutOrder = 1,
    })

    Slider.UIElements.TextBox = New("TextBox", {
        Size = UDim2.new(0, Slider.TextBoxWidth, 1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        AnchorPoint = Vector2.new(1, 0),
        TextXAlignment = "Center",
        ClearTextOnFocus = false,
        Text = FormatValue(CurrentValue),
        ThemeTag = {
            TextColor3 = "Text"
        },
        TextTransparency = 0.15,
        TextSize = 14,
        FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
        BackgroundTransparency = 1,
        Visible = Slider.InputBox,
        Parent = Slider.UIElements.ValueRow,
    }, {
        Creator.NewRoundFrame(999, "Squircle", {
            Size = UDim2.new(1, 0, 1, 0),
            ImageTransparency = 0.9,
            ThemeTag = {
                ImageColor3 = "Text"
            },
            ZIndex = 0,
        }),
        Creator.NewRoundFrame(999, "Glass-1", {
            Size = UDim2.new(1, 0, 1, 0),
            ImageTransparency = 0.75,
            ImageColor3 = Color3.new(1, 1, 1),
            Name = "Stroke",
            ZIndex = 0,
        }),
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
        }),
    })

    Slider.UIElements.RailRow = New("Frame", {
        Size = UDim2.new(1, 0, 0, Slider.IconSize),
        BackgroundTransparency = 1,
        Parent = Slider.UIElements.SliderContainer,
        LayoutOrder = 2,
    }, {
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = "Horizontal",
            VerticalAlignment = "Center",
            HorizontalAlignment = Slider.Icons and (Slider.Icons.From and (Slider.Icons.To and "Center" or "Left") or Slider.Icons.To and "Right") or "Center",
        }),
        IconFrom,
        Slider.UIElements.SliderIcon,
        IconTo,
    })

    local Tooltip
    if Slider.IsTooltip then
        Tooltip = require("../components/ui/Tooltip").New(CurrentValue, Slider.UIElements.SliderFill.Thumb, true, "Secondary", "Small", false)
        Tooltip.Container.AnchorPoint = Vector2.new(0.5, 1)
        Tooltip.Container.Position = UDim2.new(0.5, 0, 0, -8)
    end

    function Slider:Lock()
        Slider.Locked = true
        CanCallback = false
        return Slider.SliderFrame:Lock(Slider.LockedTitle)
    end

    function Slider:Unlock()
        Slider.Locked = false
        CanCallback = true
        return Slider.SliderFrame:Unlock()
    end

    if Slider.Locked then
        Slider:Lock()
    end

    local ScrollingFrameParent = Config.Tab.UIElements.ContainerFrame

    local function UpdateVisuals(newValue, shouldTween, preserveInputText)
        local delta = ValueToDelta(newValue)

        if shouldTween then
            Tween(Slider.UIElements.SliderFill, 0.05, {
                Size = UDim2.new(delta, 0, 1, 0)
            }):Play()
        else
            Slider.UIElements.SliderFill.Size = UDim2.new(delta, 0, 1, 0)
        end

        if Slider.InputBox and Slider.UIElements.TextBox and not preserveInputText then
            Slider.UIElements.TextBox.Text = FormatValue(newValue)
        end

        if Tooltip then
            Tooltip.TitleFrame.Text = FormatValue(newValue)
        end
    end

    local function CommitValue(newValue, shouldCallback, shouldTween, preserveInputText)
        if not CanCallback then
            return
        end

        newValue = NormalizeValue(newValue)
        UpdateVisuals(newValue, shouldTween, preserveInputText)

        local changed = newValue ~= CurrentValue
        CurrentValue = newValue
        Slider.Value.Default = newValue

        if changed and shouldCallback then
            Creator.SafeCallback(Slider.Callback, newValue)
        end
    end

    function Slider:Set(newValue, input)
        if not CanCallback then
            return
        end

        if not Slider.IsFocusing and not IsSliderHolding and input and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            isTouch = (input.UserInputType == Enum.UserInputType.Touch)
            ScrollingFrameParent.ScrollingEnabled = false
            IsSliderHolding = true

            local function UpdateFromPointer()
                local inputPosition = isTouch and input.Position.X or UserInputService:GetMouseLocation().X
                local delta = math.clamp((inputPosition - Slider.UIElements.SliderIcon.AbsolutePosition.X) / Slider.UIElements.SliderIcon.AbsoluteSize.X, 0, 1)
                local rawValue = MinValue + delta * (MaxValue - MinValue)
                CommitValue(rawValue, true, true, false)
            end

            UpdateFromPointer()

            moveconnection = RunService.RenderStepped:Connect(function()
                UpdateFromPointer()
            end)

            releaseconnection = UserInputService.InputEnded:Connect(function(endInput)
                if (endInput.UserInputType == Enum.UserInputType.MouseButton1 or endInput.UserInputType == Enum.UserInputType.Touch) and input == endInput then
                    if moveconnection then
                        moveconnection:Disconnect()
                        moveconnection = nil
                    end
                    if releaseconnection then
                        releaseconnection:Disconnect()
                        releaseconnection = nil
                    end

                    IsSliderHolding = false
                    ScrollingFrameParent.ScrollingEnabled = true

                    if Config.Window.NewElements then
                        Tween(Slider.UIElements.SliderFill.Thumb, 0.2, {
                            ImageTransparency = 0,
                            Size = UDim2.new(0, Config.Window.NewElements and (Slider.ThumbSize * 2) or (Slider.ThumbSize + 2), 0, Config.Window.NewElements and (Slider.ThumbSize + 4) or (Slider.ThumbSize + 2))
                        }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
                    end

                    if Tooltip then
                        Tooltip:Close(false)
                    end
                end
            end)
        elseif not input then
            CommitValue(newValue, true, true, false)
        end
    end

    function Slider:SetMax(newMax)
        MaxValue = newMax
        Slider.Value.Max = newMax

        if CurrentValue > newMax then
            Slider:Set(newMax)
        else
            UpdateVisuals(CurrentValue, true, Slider.IsFocusing)
        end
    end

    function Slider:SetMin(newMin)
        MinValue = newMin
        Slider.Value.Min = newMin

        if CurrentValue < newMin then
            Slider:Set(newMin)
        else
            UpdateVisuals(CurrentValue, true, Slider.IsFocusing)
        end
    end

    Creator.AddSignal(Slider.UIElements.TextBox.Focused, function()
        Slider.IsFocusing = true

        Tween(Slider.UIElements.TextBox.Stroke, 0.12, {
            ImageTransparency = 0.45
        }):Play()
    end)

    Creator.AddSignal(Slider.UIElements.TextBox:GetPropertyChangedSignal("Text"), function()
        if not Slider.InputBox or not Slider.IsFocusing then
            return
        end

        local typedValue = tonumber(Slider.UIElements.TextBox.Text)
        if typedValue ~= nil then
            local previewValue = NormalizeValue(typedValue)
            UpdateVisuals(previewValue, true, true)
        end
    end)

    Creator.AddSignal(Slider.UIElements.TextBox.FocusLost, function()
        Slider.IsFocusing = false

        Tween(Slider.UIElements.TextBox.Stroke, 0.12, {
            ImageTransparency = 0.75
        }):Play()

        local newValue = tonumber(Slider.UIElements.TextBox.Text)
        if newValue ~= nil then
            CommitValue(newValue, true, true, false)
        else
            Slider.UIElements.TextBox.Text = FormatValue(CurrentValue)
            if Tooltip then
                Tooltip.TitleFrame.Text = FormatValue(CurrentValue)
            end
        end
    end)

    Creator.AddSignal(Slider.UIElements.RailRow.InputBegan, function(input)
        if Slider.Locked or IsSliderHolding then
            return
        end

        Slider:Set(CurrentValue, input)

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if Config.Window.NewElements then
                Tween(Slider.UIElements.SliderFill.Thumb, 0.24, {
                    ImageTransparency = 0.85,
                    Size = UDim2.new(0, (Config.Window.NewElements and (Slider.ThumbSize * 2) or Slider.ThumbSize) + 8, 0, Slider.ThumbSize + 8)
                }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
            end

            if Tooltip then
                Tooltip:Open()
            end
        end
    end)

    return Slider.__type, Slider
end

return Element
