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
	UICorner = 30,
	UIPadding = 14,
	NotificationIndex = 0,
	Notifications = {},
}

local function GetViewportX()
	return (CurrentCamera and CurrentCamera.ViewportSize.X) or 800
end

local function GetHolderWidth()
	local viewportX = GetViewportX()
	return math.clamp(math.floor(viewportX * 0.42), 300, 390)
end

local function GetTopOffset(lower)
	return lower and 62 or 18
end

local function GetUserAvatarByUserId(userId)
	local success, imageId = pcall(function()
		return Players:GetUserThumbnailAsync(
			userId or 1,
			Enum.ThumbnailType.HeadShot,
			Enum.ThumbnailSize.Size150x150
		)
	end)

	if success and imageId then
		return imageId
	end

	return "rbxasset://textures/ui/GuiImagePlaceholder.png"
end

local function GetDefaultAvatar()
	return GetUserAvatarByUserId(LocalPlayer and LocalPlayer.UserId or 1)
end

local function ResolveAvatar(avatarValue)
	if avatarValue == false then
		return nil
	end

	if avatarValue == nil or avatarValue == true then
		return GetDefaultAvatar()
	end

	if typeof(avatarValue) == "Instance" and avatarValue:IsA("Player") then
		return GetUserAvatarByUserId(avatarValue.UserId)
	end

	if typeof(avatarValue) == "number" then
		return GetUserAvatarByUserId(avatarValue)
	end

	if typeof(avatarValue) == "string" then
		local numericId = tonumber(avatarValue)
		if numericId then
			return GetUserAvatarByUserId(numericId)
		end

		return avatarValue
	end

	return GetDefaultAvatar()
end

function NotificationModule.Init(Parent)
	local NotModule = {
		Lower = false
	}

	local function ApplyHolderLayout()
		local topOffset = GetTopOffset(NotModule.Lower)

		NotModule.Frame.Position = UDim2.new(0.5, 0, 0, topOffset)
		NotModule.Frame.Size = UDim2.new(0, GetHolderWidth(), 1, -(topOffset + 20))
	end

	function NotModule.SetLower(val)
		NotModule.Lower = val
		ApplyHolderLayout()
	end

	NotModule.Frame = New("Frame", {
		Position = UDim2.new(0.5, 0, 0, GetTopOffset(false)),
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.new(0, GetHolderWidth(), 1, -(GetTopOffset(false) + 20)),
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
		Avatar = Config.Avatar,
		TimeText = Config.TimeText or "now",
		Background = Config.Background,
		BackgroundImageTransparency = Config.BackgroundImageTransparency or 1,
		Duration = Config.Duration or 5,
		CanClose = Config.CanClose ~= false,
		UIElements = {},
		Closed = false,
	}

	NotificationModule.NotificationIndex = NotificationModule.NotificationIndex + 1
	NotificationModule.Notifications[NotificationModule.NotificationIndex] = Notification

	local HolderWidth = GetHolderWidth()
	local AvatarSize = 52
	local BadgeSize = 18
	local AvatarImage = ResolveAvatar(Notification.Avatar)
	local HasAvatar = AvatarImage ~= nil

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
		AppBadge.Position = UDim2.new(0.5, 0, 0.5, 0)
	end

	local Main = Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 84),
		AutomaticSize = "Y",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -14),
		ImageColor3 = Color3.fromRGB(42, 42, 48),
		ImageTransparency = 1,
		Parent = nil,
	}, {
		Creator.NewRoundFrame(NotificationModule.UICorner, "Glass-1.4", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Outline",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 0.82,
		}),

		Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "InnerGlass",
			ImageColor3 = Color3.fromRGB(72, 72, 80),
			ImageTransparency = 0.9,
		}),

		New("Frame", {
			Name = "TopSheen",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.96,
			Size = UDim2.new(1, -18, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 1),
			AnchorPoint = Vector2.new(0.5, 0),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 999),
			}),
		}),

		New("Frame", {
			Name = "RightOrb1",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.975,
			Size = UDim2.new(0, 42, 0, 42),
			Position = UDim2.new(1, -66, 0, 9),
			Visible = true,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
		}),

		New("Frame", {
			Name = "RightOrb2",
			BackgroundColor3 = Color3.fromRGB(255, 255, 255),
			BackgroundTransparency = 0.982,
			Size = UDim2.new(0, 30, 0, 30),
			Position = UDim2.new(1, -28, 0, 15),
			Visible = true,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(1, 0),
			}),
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
				Size = UDim2.new(0, HasAvatar and AvatarSize or 0, 0, AvatarSize),
				Position = UDim2.new(0, 0, 0, 0),
				Visible = HasAvatar,
			}, {
				New("ImageLabel", {
					Name = "Avatar",
					Image = AvatarImage or "",
					BackgroundTransparency = 1,
					Size = UDim2.new(0, AvatarSize, 0, AvatarSize),
					ScaleType = "Crop",
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),

				New("Frame", {
					Name = "BadgeBack",
					Size = UDim2.new(0, BadgeSize + 6, 0, BadgeSize + 6),
					Position = UDim2.new(0, 2, 1, -2),
					AnchorPoint = Vector2.new(0, 1),
					BackgroundColor3 = Color3.fromRGB(28, 28, 32),
					BackgroundTransparency = 0.08,
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
				Size = UDim2.new(0, 52, 0, 18),
				Position = UDim2.new(1, -2, 0, 1),
				AnchorPoint = Vector2.new(1, 0),
				TextXAlignment = "Right",
				TextYAlignment = "Top",
				TextSize = 13,
				Font = Enum.Font.BuilderSansMedium,
				TextColor3 = Color3.fromRGB(235, 235, 239),
				TextTransparency = 0.08,
			}),

			New("Frame", {
				Name = "TextContainer",
				BackgroundTransparency = 1,
				AutomaticSize = "Y",
				Size = UDim2.new(1, -((HasAvatar and (AvatarSize + 12) or 0) + 58), 0, 0),
				Position = UDim2.new(0, HasAvatar and (AvatarSize + 12) or 0, 0, 1),
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 1),
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
					TextColor3 = Color3.fromRGB(247, 247, 250),
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
					TextColor3 = Color3.fromRGB(239, 239, 243),
					TextTransparency = 0.02,
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

		Tween(MainContainer, 0.28, {
			Size = UDim2.new(1, 0, 0, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.28, {
			Position = UDim2.new(0.5, 0, 0, -12),
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		task.wait(0.29)
		if MainContainer then
			MainContainer:Destroy()
		end
	end

	task.spawn(function()
		task.wait()

		local targetHeight = Main.AbsoluteSize.Y

		MainContainer.Size = UDim2.new(1, 0, 0, 0)
		Main.Position = UDim2.new(0.5, 0, 0, -12)
		Main.ImageTransparency = 1

		Tween(MainContainer, 0.3, {
			Size = UDim2.new(1, 0, 0, targetHeight),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.3, {
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = 0.16,
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
