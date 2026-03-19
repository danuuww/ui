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
	})

	Button.UIElements.ButtonIcon = Creator.Image(
		Button.Icon,
		Button.Icon,
		0,
		Config.Window.Folder,
		"Button",
		not Button.Color and true or nil,
		Button.IconThemed
	)
	
	Button.UIElements.ButtonIcon.Size = UDim2.new(0,20,0,20)
	
	if Button.Justify == "Between" then
		Button.UIElements.ButtonIcon.Parent = Button.ButtonFrame.UIElements.Main
		Button.UIElements.ButtonIcon.AnchorPoint = Vector2.new(1, 0.5)
		Button.UIElements.ButtonIcon.Position = UDim2.new(1, Button.IconAlign == "Right" and -32 or -16, 0.5, 0)
	else
		Button.UIElements.ButtonIcon.Parent = Button.ButtonFrame.UIElements.Container.TitleFrame
		Button.UIElements.ButtonIcon.LayoutOrder = Button.IconAlign == "Left" and -99999 or 99999
	end
	
	Button.ButtonFrame:Colorize(Button.UIElements.ButtonIcon.ImageLabel, "ImageColor3")

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
