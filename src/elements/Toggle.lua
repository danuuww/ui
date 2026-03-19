local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateToggle = require("../components/ui/Toggle").New
local CreateCheckbox = require("../components/ui/Checkbox").New

local Element = {}

local function IsInside(GuiObject, Position, Padding)
	if not GuiObject or not GuiObject.Visible then
		return false
	end

	Padding = Padding or 0

	local AbsolutePosition = GuiObject.AbsolutePosition
	local AbsoluteSize = GuiObject.AbsoluteSize

	return Position.X >= (AbsolutePosition.X - Padding)
		and Position.X <= (AbsolutePosition.X + AbsoluteSize.X + Padding)
		and Position.Y >= (AbsolutePosition.Y - Padding)
		and Position.Y <= (AbsolutePosition.Y + AbsoluteSize.Y + Padding)
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
		IconThemed = Config.IconThemed or false,
		IconSize = Config.IconSize or 23,
		Type = Config.Type or "Toggle",
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local HasDesc = Toggle.Desc ~= nil and Toggle.Desc ~= ""

	Toggle.ToggleFrame = require("../components/window/Element")({
		Title = Toggle.Title,
		Desc = Toggle.Desc,
		Image = Toggle.Icon,
		ImageSize = Toggle.Icon and math.max((Toggle.IconSize or 23) - 3, 18) or nil,
		IconThemed = Toggle.IconThemed,

		Window = Config.Window,
		Parent = Config.Parent,
		TextOffset = HasDesc and 140 or 108,
		Hover = false,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Toggle,
		ParentConfig = Config,

		ListRow = Config.Window.NewElements == true,
		ExpandableDesc = HasDesc,
		DescExpanded = false,
		ShowChevron = HasDesc,
		RightSlotWidth = HasDesc and 120 or 90,
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

	local ToggleFrame, ToggleFunc
	if Toggle.Type == "Toggle" then
		ToggleFrame, ToggleFunc = CreateToggle(
			Toggled,
			nil,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config.Window.NewElements,
			Config
		)
	elseif Toggle.Type == "Checkbox" then
		ToggleFrame, ToggleFunc = CreateCheckbox(
			Toggled,
			nil,
			Toggle.IconSize,
			Toggle.ToggleFrame.UIElements.Main,
			Toggle.Callback,
			Config
		)
	else
		error("Unknown Toggle Type: " .. tostring(Toggle.Type))
	end

	if Toggle.ToggleFrame.UIElements.RightSlot then
		ToggleFrame.Parent = Toggle.ToggleFrame.UIElements.RightSlot
		ToggleFrame.LayoutOrder = 1
	else
		ToggleFrame.AnchorPoint = Vector2.new(1, Config.Window.NewElements and 0 or 0.5)
		ToggleFrame.Position = UDim2.new(1, 0, Config.Window.NewElements and 0 or 0.5, 0)
	end

	function Toggle:Set(v, isCallback, isAnim)
		if CanCallback then
			ToggleFunc:Set(v, isCallback, isAnim or false)
			Toggled = v
			Toggle.Value = v
		end
	end

	Toggle:Set(Toggled, false, Config.Window.NewElements)

	local function PressingChevron(input)
		local ChevronButton = Toggle.ToggleFrame.UIElements.ChevronButton
		if not ChevronButton or not input or not input.Position then
			return false
		end
		return IsInside(ChevronButton, input.Position, 8)
	end

	if Config.Window.NewElements and ToggleFunc.Animate then
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.InputBegan, function(input)
			if Toggle.Locked then
				return
			end

			if PressingChevron(input) then
				return
			end

			if
				not Config.Window.IsToggleDragging
				and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch)
			then
				ToggleFunc:Animate(input, Toggle)
			end
		end)
	else
		Creator.AddSignal(Toggle.ToggleFrame.UIElements.Main.MouseButton1Click, function()
			if Toggle.Locked then
				return
			end

			local MousePos = game:GetService("UserInputService"):GetMouseLocation()
			if IsInside(Toggle.ToggleFrame.UIElements.ChevronButton, MousePos, 8) then
				return
			end

			Toggle:Set(not Toggle.Value, nil, Config.Window.NewElements)
		end)
	end

	return Toggle.__type, Toggle
end

return Element
