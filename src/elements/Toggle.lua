local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateToggle = require("../components/ui/Toggle").New
local CreateCheckbox = require("../components/ui/Checkbox").New

local Element = {}

local function IsPointerInside(Object, Input)
	if not Object or not Input then
		return false
	end

	local Pos = Object.AbsolutePosition
	local Size = Object.AbsoluteSize
	local Point = Input.Position

	return Point.X >= Pos.X
		and Point.X <= (Pos.X + Size.X)
		and Point.Y >= Pos.Y
		and Point.Y <= (Pos.Y + Size.Y)
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
		UIElements = {}
	}

	local HasDesc = Toggle.Desc ~= nil and Toggle.Desc ~= ""

	Toggle.ToggleFrame = require("../components/window/Element")({
		Title = Toggle.Title,
		Desc = Toggle.Desc,
		Image = Toggle.Icon,
		ImageSize = Toggle.Icon and math.clamp(Toggle.IconSize or 20, 18, 22) or nil,
		IconThemed = Config.IconThemed,
		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = HasDesc and 138 or 126,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Toggle,
		ParentConfig = Config,

		ExpandableDesc = HasDesc,
		DescExpanded = false,
		ShowChevron = HasDesc,
		RightSlotWidth = HasDesc and 118 or 92,
	})

	local CanCallback = true

	if Toggle.Value == nil then
		Toggle.Value = false
	end

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

	local Toggled = Toggle.Value
	local ToggleFrame
	local ToggleFunc

	if Toggle.Type == "Toggle" then
		ToggleFrame, ToggleFunc = CreateToggle(
			Toggled,
			nil,
			nil,
			Toggle.ToggleFrame.UIElements.RightSlot,
			Toggle.Callback,
			Config.Window.NewElements,
			Config
		)
	elseif Toggle.Type == "Checkbox" then
		ToggleFrame, ToggleFunc = CreateCheckbox(
			Toggled,
			nil,
			nil,
			Toggle.ToggleFrame.UIElements.RightSlot,
			Toggle.Callback,
			Config
		)
	else
		error("Unknown Toggle Type: " .. tostring(Toggle.Type))
	end

	Toggle.UIElements.Switch = ToggleFrame

	ToggleFrame.AnchorPoint = Vector2.new(0, 0.5)
	ToggleFrame.Position = UDim2.new(0, 0, 0.5, 0)
	ToggleFrame.LayoutOrder = 1
	ToggleFrame.ZIndex = 5

	local ToggleScale = New("UIScale", {
		Scale = Toggle.Type == "Toggle" and 0.90 or 0.92,
		Parent = ToggleFrame,
	})

	Toggle.UIElements.ToggleScale = ToggleScale

	local ChevronButton = Toggle.ToggleFrame.UIElements.ChevronButton

	local function RefreshRightSlot()
		local Width = ToggleFrame.AbsoluteSize.X
		if Width <= 0 then
			Width = Toggle.Type == "Toggle" and 84 or 28
		end

		local ExtraChevron = ChevronButton and ChevronButton.Parent and ChevronButton.Parent.AbsoluteSize.X or 0
		local Gap = ChevronButton and 8 or 0

		Toggle.ToggleFrame.RightSlotWidth = Width + ExtraChevron + Gap
	end

	task.defer(RefreshRightSlot)

	function Toggle:Set(v, isCallback, isAnim)
		if CanCallback then
			ToggleFunc:Set(v, isCallback, isAnim or false)
			Toggled = v
			Toggle.Value = v
		end
	end

	Toggle:Set(Toggled, false, Config.Window.NewElements)

	local function ShouldIgnoreMainPress(Input)
		if ChevronButton and IsPointerInside(ChevronButton, Input) then
			return true
		end
		return false
	end

	if Config.Window.NewElements and ToggleFunc.Animate then
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.InputBegan, function(Input)
			if Toggle.Locked then
				return
			end

			if ShouldIgnoreMainPress(Input) then
				return
			end

			if not Config.Window.IsToggleDragging
				and (Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch) then
				ToggleFunc:Animate(Input, Toggle)
			end
		end)
	else
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.MouseButton1Click, function()
			if Toggle.Locked then
				return
			end
			Toggle:Set(not Toggle.Value, nil, Config.Window.NewElements)
		end)
	end

	Creator.AddSignal(ToggleFrame:GetPropertyChangedSignal("AbsoluteSize"), function()
		RefreshRightSlot()
	end)

	if ChevronButton then
		Creator.AddSignal(ChevronButton.MouseEnter, function()
			local Icon = Toggle.ToggleFrame.UIElements.ChevronIcon
			if Icon then
				Tween(Icon, 0.12, {
					TextTransparency = 0.08,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end)

		Creator.AddSignal(ChevronButton.MouseLeave, function()
			local Icon = Toggle.ToggleFrame.UIElements.ChevronIcon
			if Icon then
				Tween(Icon, 0.12, {
					TextTransparency = 0.25,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end)
	end

	return Toggle.__type, Toggle
end

return Element
