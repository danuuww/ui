local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateCheckbox = require("../components/ui/Checkbox").New

local Element = {}

local function CreateIosSwitch(Parent, DefaultValue, Config)
	local State = DefaultValue == true

	local Width = Config.Window.NewElements and 72 or 68
	local Height = Config.Window.NewElements and 38 or 34
	local KnobSize = Height - 4
	local KnobGlowSize = KnobSize + 10
	local OffDotSize = 10

	local OffX = 2 + (KnobSize / 2)
	local OnX = Width - 2 - (KnobSize / 2)

	local Root = New("Frame", {
		Name = "IosSwitch",
		Size = UDim2.new(0, Width, 0, Height),
		BackgroundTransparency = 1,
		Parent = Parent,
		LayoutOrder = 1,
	})

	local Track = Creator.NewRoundFrame(999, "Squircle", {
		Name = "Track",
		Size = UDim2.new(1, 0, 1, 0),
		ThemeTag = {
			ImageColor3 = "Text",
		},
		ImageTransparency = 0.76,
		Parent = Root,
	}, {
		Creator.NewRoundFrame(999, "Glass-1", {
			Name = "Stroke",
			Size = UDim2.new(1, 0, 1, 0),
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.76,
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "OnFill",
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "Accent",
			},
			ImageTransparency = State and 0.22 or 1,
		}, {
			Creator.NewRoundFrame(999, "Glass-1", {
				Name = "OnGlow",
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = 0.87,
			}),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "OffDot",
			Size = UDim2.new(0, OffDotSize, 0, OffDotSize),
			Position = UDim2.new(1, -14, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = Color3.fromRGB(236, 236, 242),
			ImageTransparency = State and 1 or 0.34,
		}, {
			Creator.NewRoundFrame(999, "Squircle-Outline", {
				Name = "OffDotStroke",
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = 0.65,
			}),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "KnobGlow",
			Size = UDim2.new(0, KnobGlowSize, 0, KnobGlowSize),
			Position = UDim2.new(0, State and OnX or OffX, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ThemeTag = {
				ImageColor3 = "Accent",
			},
			ImageTransparency = State and 0.82 or 1,
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Name = "Knob",
			Size = UDim2.new(0, KnobSize, 0, KnobSize),
			Position = UDim2.new(0, State and OnX or OffX, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = Color3.fromRGB(247, 247, 249),
			ImageTransparency = 0,
		}, {
			Creator.NewRoundFrame(999, "Glass-1", {
				Name = "Highlight",
				Size = UDim2.new(1, 0, 1, 0),
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = 0.42,
			}),
		}),
		New("TextButton", {
			Name = "Hitbox",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			AutoButtonColor = false,
			ZIndex = 10,
		}),
	})

	local Controller = {}

	function Controller:Set(Value, _, Animate)
		State = Value == true

		local KnobPos = UDim2.new(0, State and OnX or OffX, 0.5, 0)
		local OnTransparency = State and 0.22 or 1
		local GlowTransparency = State and 0.82 or 1
		local OffDotTransparency = State and 1 or 0.34

		if Animate == false then
			Track.OnFill.ImageTransparency = OnTransparency
			Track.KnobGlow.ImageTransparency = GlowTransparency
			Track.OffDot.ImageTransparency = OffDotTransparency
			Track.Knob.Position = KnobPos
			Track.KnobGlow.Position = KnobPos
		else
			Tween(Track.OnFill, 0.18, {
				ImageTransparency = OnTransparency,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(Track.KnobGlow, 0.18, {
				ImageTransparency = GlowTransparency,
				Position = KnobPos,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(Track.OffDot, 0.16, {
				ImageTransparency = OffDotTransparency,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(Track.Knob, 0.18, {
				Position = KnobPos,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end
	end

	function Controller:Press()
		Tween(Track.Knob, 0.12, {
			Size = UDim2.new(0, KnobSize + 2, 0, KnobSize + 2),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
	end

	function Controller:Release()
		Tween(Track.Knob, 0.12, {
			Size = UDim2.new(0, KnobSize, 0, KnobSize),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
	end

	Controller:Set(State, nil, false)

	return Root, Controller
end

function Element:New(Config)
	local Toggle = {
		__type = "Toggle",
		Title = Config.Title or "Toggle",
		Desc = Config.Desc or nil,
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Value = Config.Value,
		Icon = Config.Icon or nil,
		IconSize = Config.IconSize or 20,
		Type = Config.Type or "Toggle",
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local HasDesc = Toggle.Desc ~= nil and Toggle.Desc ~= ""

	if Toggle.Value == nil then
		Toggle.Value = false
	end

	local RightSlotWidth = HasDesc and 112 or 84
	local TextOffset = HasDesc and 124 or 92

	Toggle.ToggleFrame = require("../components/window/Element")({
		Title = Toggle.Title,
		Desc = Toggle.Desc,
		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = TextOffset,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Toggle,
		ParentConfig = Config,

		Image = Toggle.Icon,
		ImageSize = Toggle.IconSize,

		RightSlotWidth = RightSlotWidth,
		DividerRightInset = RightSlotWidth + 8,
		ExpandableDesc = HasDesc,
		ShowChevron = HasDesc,
		DescExpanded = false,
	})

	local CanCallback = true
	local Toggled = Toggle.Value

	function Toggle:Lock()
		Toggle.Locked = true
		CanCallback = false
		return Toggle.ToggleFrame:Lock(Toggle.LockedTitle)
	end

	function Toggle:Unlock()
		Toggle.Locked = false
		CanCallback = true
		return Toggle.ToggleFrame:Unlock()
	end

	if Toggle.Locked then
		Toggle:Lock()
	end

	local RightSlot = Toggle.ToggleFrame.UIElements.RightSlot
	local ToggleFrame
	local ToggleFunc

	if Toggle.Type == "Toggle" then
		ToggleFrame, ToggleFunc = CreateIosSwitch(RightSlot, Toggled, Config)
	elseif Toggle.Type == "Checkbox" then
		ToggleFrame, ToggleFunc =
			CreateCheckbox(Toggled, nil, 0, RightSlot, Toggle.Callback, Config)
		ToggleFrame.LayoutOrder = 1
	else
		error("Unknown Toggle Type: " .. tostring(Toggle.Type))
	end

	Toggle.UIElements.Switch = ToggleFrame

	function Toggle:Set(Value, IsCallback, IsAnim)
		if not CanCallback then
			return
		end

		local NewValue = Value == true
		Toggled = NewValue
		Toggle.Value = NewValue

		if ToggleFunc and ToggleFunc.Set then
			ToggleFunc:Set(NewValue, false, IsAnim)
		end

		if IsCallback ~= false then
			Creator.SafeCallback(Toggle.Callback, NewValue)
		end
	end

	Toggle:Set(Toggled, false, false)

	if Toggle.Type == "Toggle" then
		Creator.AddSignal(ToggleFrame.Track.Hitbox.MouseButton1Click, function()
			if Toggle.Locked then
				return
			end
			Toggle:Set(not Toggle.Value, true, true)
		end)

		Creator.AddSignal(ToggleFrame.Track.Hitbox.MouseButton1Down, function()
			if Toggle.Locked then
				return
			end
			if ToggleFunc and ToggleFunc.Press then
				ToggleFunc:Press()
			end
		end)

		Creator.AddSignal(ToggleFrame.Track.Hitbox.InputEnded, function(Input)
			if
				Input.UserInputType == Enum.UserInputType.MouseButton1
				or Input.UserInputType == Enum.UserInputType.Touch
			then
				if ToggleFunc and ToggleFunc.Release then
					ToggleFunc:Release()
				end
			end
		end)
	else
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.MouseButton1Click, function()
			if Toggle.Locked then
				return
			end
			Toggle:Set(not Toggle.Value, true, Config.Window.NewElements)
		end)
	end

	if not HasDesc and Toggle.Type == "Toggle" then
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.MouseButton1Click, function()
			if Toggle.Locked then
				return
			end
			Toggle:Set(not Toggle.Value, true, true)
		end)
	end

	return Toggle.__type, Toggle
end

return Element
