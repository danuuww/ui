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
	UIPadding = 12,
	NotificationIndex = 0,
	Notifications = {},
}

local function GetViewportX()
	return (CurrentCamera and CurrentCamera.ViewportSize.X) or 800
end

local function GetHolderWidth()
	local viewportX = GetViewportX()
	return math.clamp(math.floor(viewportX * 0.32), 260, 332)
end

local function GetTopOffset(lower)
	return lower and 52 or 10
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

local function CreateGlowBlob(size, position, color, transparency)
	return New("ImageLabel", {
		BackgroundTransparency = 1,
		Image = "rbxassetid://1316045217",
		ImageColor3 = color,
		ImageTransparency = transparency,
		ScaleType = "Fit",
		Size = size,
		Position = position,
	})
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
			Padding = UDim.new(0, 8),
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
	local AvatarSize = 44
	local BadgeSize = 14
	local NotificationHeight = 72

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
		Size = UDim2.new(1, 0, 0, 0),
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, -12),
		AutomaticSize = Enum.AutomaticSize.Y,
		ImageColor3 = Color3.fromRGB(205, 210, 220),
		ImageTransparency = 1,
		Parent = nil,
	}, {
		Creator.NewRoundFrame(NotificationModule.UICorner, "Glass-1.4", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Outline",
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 0.5,
		}),

		Creator.NewRoundFrame(NotificationModule.UICorner, "Squircle", {
			Size = UDim2.new(1, -2, 1, -2),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "InnerGlass",
			ImageColor3 = Color3.fromRGB(170, 176, 188),
			ImageTransparency = 0.75,
		}),

		New("Frame", {
			Name = "TopLine",
			BackgroundColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 0.94,
			Size = UDim2.new(1, -18, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 1),
			AnchorPoint = Vector2.new(0.5, 0),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 999),
			}),
		}),

		New("Frame", {
			Name = "BottomShade",
			BackgroundColor3 = Color3.fromRGB(10, 10, 14),
			BackgroundTransparency = 0.985,
			Size = UDim2.new(1, -8, 0, 18),
			Position = UDim2.new(0.5, 0, 1, -4),
			AnchorPoint = Vector2.new(0.5, 1),
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 999),
			}),
		}),

		CreateGlowBlob(
			UDim2.new(0, 54, 0, 54),
			UDim2.new(1, -74, 0, 6),
			Color3.fromRGB(255, 255, 255),
			0.95
		),

		CreateGlowBlob(
			UDim2.new(0, 38, 0, 38),
			UDim2.new(1, -34, 0, 14),
			Color3.fromRGB(240, 244, 255),
			0.965
		),

		CreateGlowBlob(
			UDim2.new(0, 80, 0, 52),
			UDim2.new(0.5, -18, 0, -18),
			Color3.fromRGB(255, 255, 255),
			0.975
		),

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
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
		}, {
			New("UIPadding", {
				PaddingTop = UDim.new(0, NotificationModule.UIPadding),
				PaddingLeft = UDim.new(0, NotificationModule.UIPadding),
				PaddingRight = UDim.new(0, NotificationModule.UIPadding),
				PaddingBottom = UDim.new(0, NotificationModule.UIPadding),
			}),

			New("TextLabel", {
				Name = "Time",
				Text = Notification.TimeText,
				BackgroundTransparency = 1,
				Size = UDim2.new(0, 48, 0, 18),
				Position = UDim2.new(1, 0, 0, 2),
				AnchorPoint = Vector2.new(1, 0),
				TextXAlignment = "Right",
				TextYAlignment = "Top",
				TextSize = 12,
				Font = Enum.Font.BuilderSansMedium,
				TextColor3 = Color3.fromRGB(245, 246, 250),
				TextTransparency = 0.12,
				ZIndex = 2,
			}),

            New("Frame", {
                Name = "Wrapper",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -54, 0, 0),
                AutomaticSize = Enum.AutomaticSize.Y,
            }, {
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 10),
                }),

                New("Frame", {
                    Name = "AvatarHolder",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, HasAvatar and AvatarSize or 0, 0, AvatarSize),
                    Visible = HasAvatar,
                    LayoutOrder = 1,
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
                       Size = UDim2.new(0, BadgeSize + 4, 0, BadgeSize + 4),
                       Position = UDim2.new(1, 2, 1, 2),
                       AnchorPoint = Vector2.new(1, 1),
                       BackgroundColor3 = Color3.fromRGB(24, 24, 28),
                       BackgroundTransparency = 0.18,
                       Visible = AppBadge ~= nil,
                       ZIndex = 6,
                    }, {
                       New("UICorner", {
                          CornerRadius = UDim.new(1, 0),
                       }),
                       New("UIStroke", {
                          Color = Color3.new(1, 1, 1),
                          Transparency = 0.55,
                          Thickness = 1,
                       }),
                       AppBadge,
                    }),
                }),

                New("Frame", {
                    Name = "TextContainer",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, HasAvatar and -(AvatarSize + 10) or 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y,
                    LayoutOrder = 2,
                }, {
                    New("UIListLayout", {
                        Padding = UDim.new(0, 0),
                        SortOrder = "LayoutOrder",
                        VerticalAlignment = "Center",
                    }),

                    New("TextLabel", {
                        Name = "Title",
                        Text = Notification.Title,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 18),
                        TextWrapped = false,
                        TextTruncate = "AtEnd",
                        TextXAlignment = "Left",
                        TextYAlignment = "Center",
                        TextSize = 15,
                        Font = Enum.Font.BuilderSansBold,
                        TextColor3 = Color3.fromRGB(248, 248, 251),
                    }),

                    New("TextLabel", {
                        Name = "Content",
                        Text = Notification.Content or "",
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 18),
                        TextWrapped = true,
                        TextXAlignment = "Left",
                        TextYAlignment = "Center",
                        TextSize = 14,
                        Font = Enum.Font.BuilderSansMedium,
                        TextColor3 = Color3.fromRGB(239, 240, 244),
                        TextTransparency = 0.05,
                        Visible = Notification.Content ~= nil,
                        AutomaticSize = Enum.AutomaticSize.Y,
                    }),
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

	local sizeConnection
	
	function Notification:Close()
		if Notification.Closed then return end
		Notification.Closed = true
		
		if sizeConnection then
			sizeConnection:Disconnect()
			sizeConnection = nil
		end

		Tween(MainContainer, 0.24, {
			Size = UDim2.new(1, 0, 0, 0),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.24, {
			Position = UDim2.new(0.5, 0, 0, -10),
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		task.wait(0.25)
		if MainContainer then
			MainContainer:Destroy()
		end
	end

	task.spawn(function()
		task.wait()

		MainContainer.Size = UDim2.new(1, 0, 0, 0)
		Main.Position = UDim2.new(0.5, 0, 0, -10)
		Main.ImageTransparency = 1

		local TargetHeight = Main.AbsoluteSize.Y

		Tween(MainContainer, 0.26, {
			Size = UDim2.new(1, 0, 0, TargetHeight),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		Tween(Main, 0.26, {
			Position = UDim2.new(0.5, 0, 0, 0),
			ImageTransparency = 0.72,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		
		-- Hook dynamic size updates so it doesn't get cut off if content wraps late
		task.delay(0.28, function()
		    if Notification.Closed then return end
		    MainContainer.Size = UDim2.new(1, 0, 0, Main.AbsoluteSize.Y)
		    sizeConnection = Main:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
		        if Notification.Closed then return end
		        -- Smoothly adjust height if text dynamically changes
		        Tween(MainContainer, 0.15, {
		            Size = UDim2.new(1, 0, 0, Main.AbsoluteSize.Y)
		        }, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()
		    end)
		end)

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
