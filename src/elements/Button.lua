local Creator = require("../modules/Creator")
local New = Creator.New

local Element = {}

function Element:New(Config)
	local Button = {
		__type = "Button",
		Title = Config.Title or "Button",
		Desc = Config.Desc or nil,
		Icon = Config.Icon or "mouse-pointer-click",
		IconThemed = Config.IconThemed or false,
		Color = Config.Color,
		Justify = Config.Justify or "Between",
		IconAlign = Config.IconAlign or "Right",
		Locked = Config.Locked or false,
		LockedTitle = Config.LockedTitle,
		Callback = Config.Callback or function() end,
		UIElements = {},
	}

	local CanCallback = true
	local UseListRow = Config.Window.NewElements == true
		and Config.ParentType ~= "Group"
		and Config.Size ~= "Small"

	Button.ButtonFrame = require("../components/window/Element")({
		Title = Button.Title,
		Desc = Button.Desc,
		Parent = Config.Parent,
		Window = Config.Window,
		Color = Button.Color,
		Justify = UseListRow and "Between" or Button.Justify,
		TextOffset = 20,
		Hover = true,
		Scalable = true,
		Tab = Config.Tab,
		Index = Config.Index,
		ElementTable = Button,
		ParentConfig = Config,
		Size = Config.Size,

		ListRow = UseListRow,
		Image = UseListRow and Button.Icon or nil,
		ImageSize = UseListRow and 20 or nil,
		IconThemed = UseListRow and Button.IconThemed or false,
	})

	if not UseListRow and Button.Icon and Button.Icon ~= "" then
		Button.UIElements.ButtonIcon = Creator.Image(
			Button.Icon,
			Button.Icon,
			0,
			Config.Window.Folder,
			"Button",
			not Button.Color and true or nil,
			Button.IconThemed
		)

		Button.UIElements.ButtonIcon.Size = UDim2.new(0, 20, 0, 20)
		Button.UIElements.ButtonIcon.Parent = Button.ButtonFrame.UIElements.Main
		Button.UIElements.ButtonIcon.AnchorPoint = Button.IconAlign == "Left"
			and Vector2.new(0, 0.5)
			or Vector2.new(1, 0.5)
		Button.UIElements.ButtonIcon.Position = Button.IconAlign == "Left"
			and UDim2.new(0, 14, 0.5, 0)
			or UDim2.new(1, -14, 0.5, 0)

		Button.ButtonFrame:Colorize(Button.UIElements.ButtonIcon.ImageLabel, "ImageColor3")
		
		local TextPadding = Button.ButtonFrame.UIElements.TextContent:FindFirstChildOfClass("UIPadding")
		if TextPadding then
			if Button.IconAlign == "Left" then
				TextPadding.PaddingLeft = UDim.new(0, TextPadding.PaddingLeft.Offset + 24)
			else
				TextPadding.PaddingRight = UDim.new(0, TextPadding.PaddingRight.Offset + 24)
			end
		end
	end

	function Button:Lock()
		Button.Locked = true
		CanCallback = false
		return Button.ButtonFrame:Lock(Button.LockedTitle)
	end

	function Button:Unlock()
		Button.Locked = false
		CanCallback = true
		return Button.ButtonFrame:Unlock()
	end

	if Button.Locked then
		Button:Lock()
	end

	Creator.AddSignal(Button.ButtonFrame.UIElements.Main.MouseButton1Click, function()
		if CanCallback then
			task.spawn(function()
				Creator.SafeCallback(Button.Callback)
			end)
		end
	end)

	return Button.__type, Button
end

return Element
