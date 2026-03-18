local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local Creator = require("../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local Players = cloneref(game:GetService("Players"))
local LocalPlayer = Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

local NotificationModule = {
	UICorner = 28,
	UIPadding = 16,
	NotificationIndex = 0,
	Notifications = {},
}

local function GetHolderWidth()
	local viewportX = CurrentCamera and CurrentCamera.ViewportSize.X or 800
	return math.clamp(viewportX - 28, 300, 430)
end

local function GetDefaultAvatar()
	local success, imageId = pcall(function()
		return Players:GetUserThumbnailAsync(
			LocalPlayer and LocalPlayer.UserId or 1,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size150x150
		)
	end)

	if success and imageId then
		return imageId
	end

	return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

function NotificationModule.Init(Parent)
	local NotModule = {
		Lower = false,
	}

	local function ApplyHolderLayout()
		local width = GetHolderWidth()
		local topOffset = NotModule.Lower and 94 or 62

		NotModule.Frame.Position = UDim2.new(0.5, 0, 0, topOffset)
		NotModule.Frame.Size = UDim2.new(0, width, 1, -(topOffset + 20))
	end

	function NotModule.SetLower(val)
		NotModule.Lower = val
		ApplyHolderLayout()
	end

	NotModule.Frame = New("Frame", {
		Position = UDim2.new(0.5, 0, 0, 62),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0, GetHolderWidth(), 1, -(62 + 20)),
		Parent = Parent,
		BackgroundTransparency = 1,
		ClipsDescendants = false,
	}, {
		New("UIListLayout", {
			HorizontalAlignment = "Center",
			SortOrder = "LayoutOrder",
			VerticalAlignment = "Top",
			Padding = UDim.new(0, 10),
		}),
	})

	if CurrentCamera then
		Creator.AddSignal(CurrentCamera:GetPropertyChangedSignal("ViewportSize"), function()
			ApplyHolderLayout()
		end)
	end

	return NotModule
end

function NotificationModule.New(Config)
	local Notification = {
		Title = Config.Title or "Notification",
		Content = Config.Content or nil,
		Icon = Config.Icon or nil,
		IconThemed = Config.IconThemed,
		Avatar = Config.Avatar or nil,
		TimeText = Config.TimeText or "now",
		Background = Config.Background,
		BackgroundImageTransparency = Config.BackgroundImageTransparency or 1,
		Duration = Config.Duration or 5,
		Buttons = Config.Buttons or {},
		CanClose = Config.CanClose ~= false,
		UIElements = {},
		Closed = false,
	}

	NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
	NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification

	local AvatarSize = 58
	local BadgeSize = 22
	local HolderWidth = GetHolderWidth()

	local AvatarImage = Notification.Avatar or GetDefaultAvatar()

	local AppBadge
	if Notification.Icon then
		AppBadge = Creator.Image(
			Notification.Icon,
			Notification.Title .. ":" .. Notification.Icon,
			0,
			Config.Window,
			"NotificationBadge",
			true,
			Notification.IconThemed
		)
		AppBadge.Size = UDim2.new(0, BadgeSize, 0, BadgeSize)
		AppBadge.AnchorPoint = Vector2.new(0.5, 0.5)
		AppBadge.Position = UDim2.new(1, -2, 1, -2)
	end

	local Main = Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 92),
		AutomaticSize = "Y",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -22),
		ImageTransparency = 0.1,
		ThemeTag = {
			ImageColor3 = "Notification",
		},
		Parent = nil,
	}, {
		Creator.NewRoundFrame(NotificationModule.UICorner, "Glass-1.4", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Outline",
			ImageTransparency = 0.68,
			ThemeTag = {
				ImageColor3 = "NotificationBorder",
			},
		}),

		New("ImageLabel", {
			Name = "Background",
			Image = Notification.Background,
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			ScaleType = "Crop",
			ImageTransparency = Notification.BackgroundImageTransparency,
			Visible = Notification.Background ~= nil,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, NotificationModule.UICorner),
			}),
		}),

		New("Frame", {
			Name = "Gloss",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			New("Frame", {
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.97,
				Size = UDim2.new(1, -10, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 1),
				AnchorPoint = Vector2.new(0.5, 0),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 999),
				}),
			}),
		}),

		New("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
		}, {
			New("UIPadding", {
				PaddingTop = UDim.new(0, NotificationModule.UIPadding),
				PaddingLeft = UDim.new(0, NotificationModule.UIPadding),
				PaddingRight = UDim.new(0, NotificationModule.UIPadding),
				PaddingBottom = UDim.new(0, NotificationModule.UIPadding),
			}),

			New("Frame", {
				Name = "AvatarHolder",
				BackgroundTransparency = 1,
				Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
				Position = UDim2.new(0, 0, 0, 0),
			}, {
				New("ImageLabel", {
					Name = "Avatar",
					Image = AvatarImage,
					BackgroundTransparency = 1,
					Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
					ScaleType = "Crop",
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				New("Frame", {
					Size = UDim2.new(0, BadgeSize + 4, 0, BadgeSize + 4),
					Position = UDim2.new(1, -2, 1, -2),
					AnchorPoint = Vector2.new(0.5, 0.5),
					BackgroundColor3 = Color3.fromRGB(24, 24, 26),
					BackgroundTransparency = 0.05,
					Visible = AppBadge ~= nil,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
					AppBadge,
				}),
			}),

			New("TextLabel", {
				Name = "Time",
				Text = Notification.TimeText,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 48, 0, 20),
				Position = UDim2.new(1, 0, 0, 1),
				AnchorPoint = Vector2.new(1, 0),
				TextXAlignment = "Right",
				TextYAlignment = "Top",
				TextSize = 14,
				Font = Enum.Font.BuilderSansMedium,
				TextColor3 = Color3.fromRGB(218, 218, 223),
				TextTransparency = 0.12,
			}),

			New("Frame", {
				Name = "TextContainer",
				BackgroundTransparency = 1,
				AutomaticSize = "Y",
				Size = UDim2.new(1, -(AvatarSize + 12 + 52), 0, 0),
				Position = UDim2.new(0, AvatarSize + 14, 0, 2),
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 2),
					SortOrder = "LayoutOrder",
					VerticalAlignment = "Top",
				}),

				New("TextLabel", {
					Name = "Title",
					Text = Notification.Title,
					BackgroundTransparency = 1,
					AutomaticSize = "Y",
					Size = UDim2.new(1, 0, 0, 0),
					TextWrapped = true,
					TextXAlignment = "Left",
					TextYAlignment = "Top",
					TextSize = 17,
					Font = Enum.Font.BuilderSansBold,
					TextColor3 = Color3.fromRGB(245, 245, 247),
				}),

				New("TextLabel", {
					Name = "Content",
					Text = Notification.Content or "",
					BackgroundTransparency = 1,
					AutomaticSize = "Y",
					Size = UDim2.new(1, 0, 0, 0),
					TextWrapped = true,
					TextXAlignment = "Left",
					TextYAlignment = "Top",
					TextSize = 16,
					Font = Enum.Font.BuilderSansMedium,
					TextColor3 = Color3.fromRGB(232, 232, 236),
					TextTransparency = 0.04,
					Visible = Notification.Content ~= nil,
				}),
			}),
		}),
	})

	local ClickCatcher
	if Notification.CanClose then
		ClickCatcher = New("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			Parent = Main,
		})
	end

	local MainContainer = New("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "None",
		Parent = Config.Holder,
		ClipsDescendants = false,
	}, {
		Main,
	})

	Notification.UIElements.Main = Main
	Notification.UIElements.MainContainer = MainContainer

	function Notification:Close()
		if Notification.Closed then
			return
		end

		Notification.Closed = true

		Tween(MainContainer, 0.35, {
			Size = UDim2.new(1, 0, 0, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.35, {
			Position = UDim2.new(0.5, 0, 0, -18),
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		task.wait(0.36)
		if MainContainer then
			MainContainer:Destroy()
		end
	end

	task.spawn(function()
		task.wait()

		local targetHeight = Main.AbsoluteSize.Y

		MainContainer.Size = UDim2.new(1, 0, 0, 0)
		Main.Position = UDim2.new(0.5, 0, 0, -22)
		Main.ImageTransparency = 1

		Tween(MainContainer, 0.38, {
			Size = UDim2.new(1, 0, 0, targetHeight),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.38, {
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = 0.1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		if Notification.Duration and Notification.Duration > 0 then
			task.wait(Notification.Duration)
			Notification:Close()
		end
	end)

	if ClickCatcher then
		Creator.AddSignal(ClickCatcher.MouseButton1Click, function()
			Notification:Close()
		end)
	end

	return Notification
end

return NotificationModule
