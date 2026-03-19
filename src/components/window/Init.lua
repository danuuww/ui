-- /* src/components/Window/Init.lua */

local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local UserInputService = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))

local CurrentCamera = workspace.CurrentCamera

local Acrylic = require("../../utils/Acrylic/Init")

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateLabel = require("../ui/Label").New
local CreateButton = require("../ui/Button").New
local CreateScrollSlider = require("../ui/ScrollSlider").New
local Tag = require("../ui/Tag")

local ConfigManager = require("../../config/Init")

local Notified = false

return function(Config)
	local Window = {
		Title = Config.Title or "UI Library",
		SubTitle = Config.SubTitle,
		TitleMessages = Config.TitleMessages,
		TitleAnim = Config.TitleAnim,
		TitleFont = Config.TitleFont or Creator.Font,
		TitleFontWeight = Config.TitleFontWeight or Enum.FontWeight.SemiBold,
		TitleTextSize = Config.TitleTextSize or 16,

		Author = Config.Author,
		Icon = Config.Icon,
		IconSize = Config.IconSize or 22,
		IconThemed = Config.IconThemed,
		IconRadius = Config.IconRadius or 0,
		Folder = Config.Folder,
		Resizable = Config.Resizable ~= false,
		Background = Config.Background,
		BackgroundImageTransparency = Config.BackgroundImageTransparency or 0,
		ShadowTransparency = Config.ShadowTransparency or 0.6,
		User = Config.User or {},
		Footer = Config.Footer or {},
		Topbar = Config.Topbar or { Height = 52, ButtonsType = "Default" },

		Size = Config.Size,

		MinSize = Config.MinSize or Vector2.new(560, 350),
		MaxSize = Config.MaxSize or Vector2.new(850, 560),

		TopBarButtonIconSize = Config.TopBarButtonIconSize,

		ToggleKey = Config.ToggleKey,
		ElementsRadius = Config.ElementsRadius,
		Radius = Config.Radius or 16,
		Transparent = Config.Transparent or false,
		HideSearchBar = Config.HideSearchBar ~= false,
		ScrollBarEnabled = Config.ScrollBarEnabled or false,
		SideBarWidth = Config.SideBarWidth or 200,
		Acrylic = Config.Acrylic or false,
		NewElements = Config.NewElements or false,
		IgnoreAlerts = Config.IgnoreAlerts or false,
		HidePanelBackground = Config.HidePanelBackground or false,
		AutoScale = Config.AutoScale ~= false,
		OpenButton = Config.OpenButton,
		DragFrameSize = 160,

		Position = UDim2.new(0.5, 0, 0.5, 0),
		UICorner = nil,
		UIPadding = 14,
		UIElements = {},
		CanDropdown = true,
		Closed = false,
		Parent = Config.Parent,
		Destroyed = false,
		IsFullscreen = false,
		CanResize = Config.Resizable ~= false,
		IsOpenButtonEnabled = true,

		CurrentConfig = nil,
		ConfigManager = nil,
		AcrylicPaint = nil,
		CurrentTab = nil,
		TabModule = nil,

		OnOpenCallback = nil,
		OnCloseCallback = nil,
		OnDestroyCallback = nil,

		IsPC = false,

		Gap = 5,

		TopBarButtons = {},
		AllElements = {},

		ElementConfig = {},

		PendingFlags = {},

		IsToggleDragging = false,
	}

	Window.UICorner = Window.Radius
	Window.TopBarButtonIconSize = Window.TopBarButtonIconSize or (Window.Topbar.ButtonsType == "Mac" and 11 or 16)

	Window.ElementConfig = {
		UIPadding = (Window.NewElements and 10 or 13),
		UICorner = Window.ElementsRadius or (Window.NewElements and 23 or 12),
	}

	local WindowSize = Window.Size or UDim2.new(0, 580, 0, 460)
	Window.Size = UDim2.new(
		WindowSize.X.Scale,
		math.clamp(WindowSize.X.Offset, Window.MinSize.X, Window.MaxSize.X),
		WindowSize.Y.Scale,
		math.clamp(WindowSize.Y.Offset, Window.MinSize.Y, Window.MaxSize.Y)
	)

	if Window.Topbar == {} then
		Window.Topbar = { Height = 52, ButtonsType = "Default" }
	end

	if not RunService:IsStudio() and Window.Folder and writefile then
		if not isfolder("WindUI/" .. Window.Folder) then
			makefolder("WindUI/" .. Window.Folder)
		end
		if not isfolder("WindUI/" .. Window.Folder .. "/assets") then
			makefolder("WindUI/" .. Window.Folder .. "/assets")
		end
		if not isfolder(Window.Folder) then
			makefolder(Window.Folder)
		end
		if not isfolder(Window.Folder .. "/assets") then
			makefolder(Window.Folder .. "/assets")
		end
	end

	local UICorner = New("UICorner", {
		CornerRadius = UDim.new(0, Window.UICorner),
	})

	if Window.Folder then
		Window.ConfigManager = ConfigManager:Init(Window)
	end

	if Window.Acrylic then
		local AcrylicPaint = Acrylic.AcrylicPaint({ UseAcrylic = Window.Acrylic })
		Window.AcrylicPaint = AcrylicPaint
	end

	local ResizeHandle = New("Frame", {
		Size = UDim2.new(0, 32, 0, 32),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		ZIndex = 99,
		Active = true,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 96, 0, 96),
			BackgroundTransparency = 1,
			Image = "rbxassetid://120997033468887",
			Position = UDim2.new(0.5, -16, 0.5, -16),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1,
		}),
	})

	local FullScreenIcon = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 98,
		Active = false,
	}, {
		New("ImageLabel", {
			Size = UDim2.new(0, 70, 0, 70),
			Image = Creator.Icon("expand")[1],
			ImageRectOffset = Creator.Icon("expand")[2].ImageRectPosition,
			ImageRectSize = Creator.Icon("expand")[2].ImageRectSize,
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageTransparency = 1,
		}),
	})

	local FullScreenBlur = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		ImageColor3 = Color3.new(0, 0, 0),
		ZIndex = 999,
		Active = false,
	})

	Window.UIElements.SideBar = New("ScrollingFrame", {
		Size = UDim2.new(
			1,
			Window.ScrollBarEnabled and -3 - (Window.UIPadding / 2) or 0,
			1,
			not Window.HideSearchBar and -39 - 6 or 0
		),
		Position = UDim2.new(0, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
		ClipsDescendants = true,
		VerticalScrollBarPosition = "Left",
	}, {
		New("Frame", {
			BackgroundTransparency = 1,
			AutomaticSize = "Y",
			Size = UDim2.new(1, 0, 0, 0),
			Name = "Frame",
		}, {
			New("UIPadding", {
				PaddingBottom = UDim.new(0, Window.UIPadding / 2),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, Window.Gap),
			}),
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, Window.UIPadding / 2),
			PaddingRight = UDim.new(0, Window.UIPadding / 2),
		}),
	})

	Window.UIElements.SideBarContainer = New("Frame", {
		Size = UDim2.new(
			0,
			Window.SideBarWidth,
			1,
			Window.User.Enabled and -Window.Topbar.Height - 42 - (Window.UIPadding * 2) or -Window.Topbar.Height
		),
		Position = UDim2.new(0, 0, 0, Window.Topbar.Height),
		BackgroundTransparency = 1,
		Visible = true,
	}, {
		New("Frame", {
			Name = "Content",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, not Window.HideSearchBar and -39 - 6 - Window.UIPadding / 2 or 0),
			Position = UDim2.new(0, 0, 1, 0),
			AnchorPoint = Vector2.new(0, 1),
		}),
		Window.UIElements.SideBar,
	})

	if Window.ScrollBarEnabled then
		CreateScrollSlider(Window.UIElements.SideBar, Window.UIElements.SideBarContainer.Content, Window, 3)
	end

	Window.UIElements.MainBar = New("Frame", {
		Size = UDim2.new(1, -Window.UIElements.SideBarContainer.AbsoluteSize.X, 1, -Window.Topbar.Height),
		Position = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(1, 1),
		BackgroundTransparency = 1,
	}, {
		Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "PanelBackground",
				ImageTransparency = "PanelBackgroundTransparency",
			},
			ZIndex = 3,
			Name = "Background",
			Visible = not Window.HidePanelBackground,
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, Window.UIPadding / 2),
			PaddingRight = UDim.new(0, Window.UIPadding / 2),
			PaddingBottom = UDim.new(0, Window.UIPadding / 2),
		}),
	})

	local Blur = New("ImageLabel", {
		Image = "rbxassetid://8992230677",
		ThemeTag = {
			ImageColor3 = "WindowShadow",
		},
		ImageTransparency = 1,
		Size = UDim2.new(1, 100, 1, 100),
		Position = UDim2.new(0, -50, 0, -50),
		ScaleType = "Slice",
		SliceCenter = Rect.new(99, 99, 99, 99),
		BackgroundTransparency = 1,
		ZIndex = -999999999999999,
		Name = "Blur",
	})

	if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
		Window.IsPC = false
	elseif UserInputService.KeyboardEnabled then
		Window.IsPC = true
	else
		Window.IsPC = nil
	end

	local UserIcon
	if Window.User then
		local function GetUserThumb()
			local ImageId = Players:GetUserThumbnailAsync(
				Window.User.Anonymous and 1 or Players.LocalPlayer.UserId,
				Enum.ThumbnailType.HeadShot,
				Enum.ThumbnailSize.Size420x420
			)
			return ImageId
		end

		UserIcon = New("TextButton", {
			Size = UDim2.new(
				0,
				Window.UIElements.SideBarContainer.AbsoluteSize.X - (Window.UIPadding / 2),
				0,
				42 + Window.UIPadding
			),
			Position = UDim2.new(0, Window.UIPadding / 2, 1, -(Window.UIPadding / 2)),
			AnchorPoint = Vector2.new(0, 1),
			BackgroundTransparency = 1,
			Visible = Window.User.Enabled or false,
		}, {
			Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "SquircleOutline", {
				Size = UDim2.new(1, 0, 1, 0),
				ThemeTag = {
					ImageColor3 = "Text",
				},
				ImageTransparency = 1,
				Name = "Outline",
			}, {
				New("UIGradient", {
					Rotation = 78,
					Color = ColorSequence.new({
						ColorSequenceKeypoint.new(0.0, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
						ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 255, 255)),
					}),
					Transparency = NumberSequence.new({
						NumberSequenceKeypoint.new(0.0, 0.1),
						NumberSequenceKeypoint.new(0.5, 1),
						NumberSequenceKeypoint.new(1.0, 0.1),
					}),
				}),
			}),
			Creator.NewRoundFrame(Window.UICorner - (Window.UIPadding / 2), "Squircle", {
				Size = UDim2.new(1, 0, 1, 0),
				ThemeTag = {
					ImageColor3 = "Text",
				},
				ImageTransparency = 1,
				Name = "UserIcon",
			}, {
				New("ImageLabel", {
					Image = GetUserThumb(),
					BackgroundTransparency = 1,
					Size = UDim2.new(0, 42, 0, 42),
					ThemeTag = {
						BackgroundColor3 = "Text",
					},
					BackgroundTransparency = 0.93,
				}, {
					New("UICorner", {
						CornerRadius = UDim.new(1, 0),
					}),
				}),
				New("Frame", {
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
				}, {
					New("TextLabel", {
						Text = Window.User.Anonymous and "Anonymous" or Players.LocalPlayer.DisplayName,
						TextSize = 17,
						ThemeTag = {
							TextColor3 = "Text",
						},
						FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
						AutomaticSize = "Y",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -(42 / 2) - 6, 0, 0),
						TextTruncate = "AtEnd",
						TextXAlignment = "Left",
						Name = "DisplayName",
					}),
					New("TextLabel", {
						Text = Window.User.Anonymous and "anonymous" or Players.LocalPlayer.Name,
						TextSize = 15,
						TextTransparency = 0.6,
						ThemeTag = {
							TextColor3 = "Text",
						},
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
						AutomaticSize = "Y",
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -(42 / 2) - 6, 0, 0),
						TextTruncate = "AtEnd",
						TextXAlignment = "Left",
						Name = "UserName",
					}),
					New("UIListLayout", {
						Padding = UDim.new(0, 4),
						HorizontalAlignment = "Left",
					}),
				}),
				New("UIListLayout", {
					Padding = UDim.new(0, Window.UIPadding),
					FillDirection = "Horizontal",
					VerticalAlignment = "Center",
				}),
				New("UIPadding", {
					PaddingLeft = UDim.new(0, Window.UIPadding / 2),
					PaddingRight = UDim.new(0, Window.UIPadding / 2),
				}),
			}),
		})

		function Window.User:Enable()
			Window.User.Enabled = true
			Tween(
				Window.UIElements.SideBarContainer,
				0.25,
				{ Size = UDim2.new(0, Window.SideBarWidth, 1, -Window.Topbar.Height - 42 - (Window.UIPadding * 2)) },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()
			UserIcon.Visible = true
		end

		function Window.User:Disable()
			Window.User.Enabled = false
			Tween(
				Window.UIElements.SideBarContainer,
				0.25,
				{ Size = UDim2.new(0, Window.SideBarWidth, 1, -Window.Topbar.Height) },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()
			UserIcon.Visible = false
		end

		function Window.User:SetAnonymous(v)
			if v ~= false then
				v = true
			end
			Window.User.Anonymous = v
			UserIcon.UserIcon.ImageLabel.Image = GetUserThumb()
			UserIcon.UserIcon.Frame.DisplayName.Text = v and "Anonymous" or Players.LocalPlayer.DisplayName
			UserIcon.UserIcon.Frame.UserName.Text = v and "anonymous" or Players.LocalPlayer.Name
		end

		if Window.User.Enabled then
			Window.User:Enable()
		else
			Window.User:Disable()
		end

		if Window.User.Callback then
			Creator.AddSignal(UserIcon.MouseButton1Click, function()
				Window.User.Callback()
			end)
			Creator.AddSignal(UserIcon.MouseEnter, function()
				Tween(UserIcon.UserIcon, 0.04, { ImageTransparency = 0.95 }):Play()
				Tween(UserIcon.Outline, 0.04, { ImageTransparency = 0.85 }):Play()
			end)
			Creator.AddSignal(UserIcon.InputEnded, function()
				Tween(UserIcon.UserIcon, 0.04, { ImageTransparency = 1 }):Play()
				Tween(UserIcon.Outline, 0.04, { ImageTransparency = 1 }):Play()
			end)
		end
	end

	local Outline1
	local Outline2

	local IsVideoBG = false
	local BGImage = nil

	local BGVideo = typeof(Window.Background) == "string" and string.match(Window.Background, "^video:(.+)") or nil
	local BGImageUrl = typeof(Window.Background) == "string"
			and not BGVideo
			and string.match(Window.Background, "^https?://.+")
		or nil

	local function GetImageExtension(url)
		local ext = url:match("%.(%w+)$") or url:match("%.(%w+)%?")
		if ext then
			ext = ext:lower()
			if ext == "jpg" or ext == "jpeg" or ext == "png" or ext == "webp" then
				return "." .. ext
			end
		end
		return ".png"
	end

	if typeof(Window.Background) == "string" and BGVideo then
		IsVideoBG = true

		if string.find(BGVideo, "http") then
			local videoPath = Window.Folder .. "/assets/." .. Creator.SanitizeFilename(BGVideo) .. ".webm"
			if not isfile(videoPath) then
				local success, result = pcall(function()
					local response = game.HttpGet and game:HttpGet(BGVideo)
					writefile(videoPath, response.Body)
				end)
				if not success then
					warn("[ WindUI.Window.Background ] Failed to download video: " .. tostring(result))
					return
				end
			end

			local success, customAsset = pcall(function()
				return getcustomasset(videoPath)
			end)
			if not success then
				warn("[ WindUI.Window.Background ] Failed to load custom asset: " .. tostring(customAsset))
				return
			end
			warn("[ WindUI.Window.Background ] VideoFrame may not work with custom video")
			BGVideo = customAsset
		end

		BGImage = New("VideoFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Video = BGVideo,
			Looped = true,
			Volume = 0,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
		BGImage:Play()
	elseif BGImageUrl then
		local imagePath = Window.Folder
			.. "/assets/."
			.. Creator.SanitizeFilename(BGImageUrl)
			.. GetImageExtension(BGImageUrl)

		if isfile and not isfile(imagePath) then
			local success, result = pcall(function()
				local response = game.HttpGet and game:HttpGet(BGImageUrl)
				writefile(imagePath, response.Body)
			end)
			if not success then
				warn("[ Window.Background ] Failed to download image: " .. tostring(result))
				return
			end
		end

		local success, customAsset = pcall(function()
			return getcustomasset(imagePath)
		end)
		if not success then
			warn("[ Window.Background ] Failed to load custom asset: " .. tostring(customAsset))
			return
		end

		BGImage = New("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = customAsset,
			ImageTransparency = 0,
			ScaleType = "Crop",
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	elseif Window.Background then
		BGImage = New("ImageLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Image = typeof(Window.Background) == "string" and Window.Background or "",
			ImageTransparency = 1,
			ScaleType = "Crop",
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
		})
	end

	local BottomDragFrame = Creator.NewRoundFrame(99, "Squircle", {
		ImageTransparency = 0.8,
		ImageColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 0, 0, 4),
		Position = UDim2.new(0.5, 0, 1, 4),
		AnchorPoint = Vector2.new(0.5, 0),
	}, {
		New("TextButton", {
			Size = UDim2.new(1, 12, 1, 12),
			BackgroundTransparency = 1,
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Active = true,
			ZIndex = 99,
			Name = "Frame",
		}),
	})

	local function createAuthor(text)
		return New("TextLabel", {
			Text = text,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			BackgroundTransparency = 1,
			TextTransparency = 0.35,
			AutomaticSize = "XY",
			Parent = Window.UIElements.Main and Window.UIElements.Main.Main.Topbar.Left.Title,
			TextXAlignment = "Left",
			TextSize = 13,
			LayoutOrder = 2,
			ThemeTag = {
				TextColor3 = "WindowTopbarAuthor",
			},
			Name = "Author",
		})
	end

	local WindowAuthor
	local WindowIcon

	if Window.Author then
		WindowAuthor = createAuthor(Window.Author)
	end

	local WindowTitleProps = {
		Text = Window.Title,
		BackgroundTransparency = 1,
		AutomaticSize = "XY",
		Name = "Title",
		TextXAlignment = "Left",
		TextSize = Window.TitleTextSize,
		ThemeTag = {
			TextColor3 = "WindowTopbarTitle",
		},
	}

	if typeof(Window.TitleFont) == "EnumItem" then
		WindowTitleProps.Font = Window.TitleFont
	else
		WindowTitleProps.FontFace = Font.new(Window.TitleFont, Window.TitleFontWeight)
	end

	local WindowTitle = New("TextLabel", WindowTitleProps)

	local function ApplyWindowTitleFont()
		if typeof(Window.TitleFont) == "EnumItem" then
			WindowTitle.Font = Window.TitleFont
		else
			WindowTitle.FontFace = Font.new(Window.TitleFont, Window.TitleFontWeight)
		end
		WindowTitle.TextSize = Window.TitleTextSize
	end

	local TitleAnimToken = 0

	local function GetTitleMessages()
		local messages = {}

		if type(Window.TitleMessages) == "table" and #Window.TitleMessages > 0 then
			for _, msg in ipairs(Window.TitleMessages) do
				if type(msg) == "string" and msg ~= "" then
					table.insert(messages, msg)
				end
			end
		else
			if type(Window.Title) == "string" and Window.Title ~= "" then
				table.insert(messages, Window.Title)
			end
			if type(Window.SubTitle) == "string" and Window.SubTitle ~= "" and Window.SubTitle ~= Window.Title then
				table.insert(messages, Window.SubTitle)
			end
		end

		if #messages == 0 then
			messages = { "UI Library" }
		end

		return messages
	end

	local function GetTitleAnimConfig()
		local anim = Window.TitleAnim

		if not anim or anim == false or anim == "None" then
			return nil
		end

		if type(anim) == "string" then
			local loopDefault =
				(anim == "FadeLoop" or anim == "Pulse" or anim == "TypingCursor" or anim == "TypingWrite")
			return {
				Type = anim,
				Speed = 0.055,
				Delay = 3.5,
				Loop = loopDefault,
				CursorChar = "▏",
			}
		end

		if type(anim) == "table" then
			local animType = anim.Type or anim.Name or "TypingWrite"
			local loopDefault =
				(animType == "FadeLoop" or animType == "Pulse" or animType == "TypingCursor" or animType == "TypingWrite")

			return {
				Type = animType,
				Speed = anim.Speed or 0.055,
				Delay = anim.Delay or 3.5,
				Loop = anim.Loop == nil and loopDefault or anim.Loop,
				CursorChar = anim.CursorChar or "▏",
			}
		end

		return nil
	end

	local function ResetWindowTitleVisual()
		WindowTitle.Text = Window.Title
		WindowTitle.TextTransparency = 0
		WindowTitle.Position = UDim2.new(0, 0, 0, 0)
		WindowTitle.TextSize = Window.TitleTextSize
		ApplyWindowTitleFont()
	end

	local function StopWindowTitleAnimation()
		TitleAnimToken += 1
		ResetWindowTitleVisual()
	end

	local function RunWindowTitleAnimation()
		StopWindowTitleAnimation()

		local anim = GetTitleAnimConfig()
		if not anim then
			return
		end

		local token = TitleAnimToken
		local messages = GetTitleMessages()
		local animType = string.lower(tostring(anim.Type))

		task.spawn(function()
			local function alive()
				return token == TitleAnimToken and not Window.Destroyed
			end

			local index = 1

			local function getCurrentMessage()
				return messages[index] or Window.Title or "UI Library"
			end

			local function nextMessage()
				index += 1
				if index > #messages then
					index = 1
				end
			end

			if animType == "typingwrite" or animType == "typingcursor" then
				repeat
					local baseTitle = getCurrentMessage()

					WindowTitle.Text = ""
					WindowTitle.TextTransparency = 0

					for i = 1, #baseTitle do
						if not alive() then
							return
						end

						local partial = string.sub(baseTitle, 1, i)
						if animType == "typingcursor" then
							WindowTitle.Text = partial .. anim.CursorChar
						else
							WindowTitle.Text = partial
						end

						task.wait(anim.Speed)
					end

					WindowTitle.Text = baseTitle

					if animType == "typingcursor" then
						for _ = 1, 4 do
							if not alive() then
								return
							end
							WindowTitle.Text = baseTitle .. anim.CursorChar
							task.wait(0.3)

							if not alive() then
								return
							end
							WindowTitle.Text = baseTitle
							task.wait(0.3)
						end
					end

					if #messages <= 1 and not anim.Loop then
						break
					end

					task.wait(anim.Delay)
					nextMessage()
				until not alive()

				if alive() then
					ResetWindowTitleVisual()
				end
			elseif animType == "fadeloop" then
				while alive() do
					local baseTitle = getCurrentMessage()
					WindowTitle.Text = baseTitle

					Tween(
						WindowTitle,
						0.8,
						{ TextTransparency = 0.28 },
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.InOut
					):Play()
					task.wait(0.8)

					if not alive() then
						return
					end

					Tween(
						WindowTitle,
						0.8,
						{ TextTransparency = 0 },
						Enum.EasingStyle.Sine,
						Enum.EasingDirection.InOut
					):Play()
					task.wait(anim.Delay)

					if #messages > 1 or anim.Loop then
						nextMessage()
					else
						break
					end
				end
			elseif animType == "pulse" then
				while alive() do
					local baseTitle = getCurrentMessage()
					WindowTitle.Text = baseTitle

					Tween(
						WindowTitle,
						0.18,
						{ TextSize = Window.TitleTextSize + 1 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()
					task.wait(0.18)

					if not alive() then
						return
					end

					Tween(
						WindowTitle,
						0.22,
						{ TextSize = Window.TitleTextSize },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()
					task.wait(anim.Delay)

					if #messages > 1 or anim.Loop then
						nextMessage()
					else
						break
					end
				end
			elseif animType == "slidereveal" then
				repeat
					local baseTitle = getCurrentMessage()
					WindowTitle.Text = baseTitle
					WindowTitle.Position = UDim2.new(0, -10, 0, 0)
					WindowTitle.TextTransparency = 1

					Tween(
						WindowTitle,
						0.28,
						{
							Position = UDim2.new(0, 0, 0, 0),
							TextTransparency = 0,
						},
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()

					if #messages <= 1 and not anim.Loop then
						break
					end

					task.wait(anim.Delay)
					nextMessage()
				until not alive()

				if alive() then
					ResetWindowTitleVisual()
				end
			end
		end)
	end

	local UIStroke

	Window.UIElements.Main = New("Frame", {
		Size = Window.Size,
		Position = Window.Position,
		BackgroundTransparency = 1,
		Parent = Config.Parent,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Active = true,
	}, {
		Config.WindUI.UIScaleObj,
		Window.AcrylicPaint and Window.AcrylicPaint.Frame or nil,
		Blur,
		Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			ImageTransparency = 1,
			Size = UDim2.new(1, 0, 1, -240),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Name = "Background",
			ThemeTag = {
				ImageColor3 = "WindowBackground",
			},
		}, {
			BGImage,
			BottomDragFrame,
			ResizeHandle,
		}),
		UIStroke,
		UICorner,
		FullScreenIcon,
		FullScreenBlur,
		New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Name = "Main",
			Visible = false,
			ZIndex = 97,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, Window.UICorner),
			}),
			Window.UIElements.SideBarContainer,
			Window.UIElements.MainBar,
			UserIcon,
			Outline2,
			New("Frame", {
				Size = UDim2.new(1, 0, 0, Window.Topbar.Height),
				BackgroundTransparency = 1,
				BackgroundColor3 = Color3.fromRGB(50, 50, 50),
				Name = "Topbar",
			}, {
				Outline1,

				New("Frame", {
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 0, 0.5, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Name = "MacButtons",
					Visible = Window.Topbar.ButtonsType == "Mac",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, 8),
						FillDirection = "Horizontal",
						SortOrder = "LayoutOrder",
						VerticalAlignment = "Center",
					}),
				}),

				New("Frame", {
					AutomaticSize = "X",
					Size = UDim2.new(0, 0, 1, 0),
					BackgroundTransparency = 1,
					Name = "Left",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.UIPadding + 4),
						SortOrder = "LayoutOrder",
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
					}),
					New("Frame", {
						AutomaticSize = "XY",
						BackgroundTransparency = 1,
						Name = "Title",
						Size = UDim2.new(0, 0, 1, 0),
						LayoutOrder = 2,
					}, {
						New("UIListLayout", {
							Padding = UDim.new(0, 0),
							SortOrder = "LayoutOrder",
							FillDirection = "Vertical",
							VerticalAlignment = "Center",
						}),
						WindowTitle,
						WindowAuthor,
					}),
					New("UIPadding", {
						PaddingLeft = UDim.new(0, 4),
					}),
				}),

				New("ScrollingFrame", {
					Name = "Center",
					BackgroundTransparency = 1,
					AutomaticSize = "Y",
					ScrollBarThickness = 0,
					ScrollingDirection = "X",
					AutomaticCanvasSize = "X",
					CanvasSize = UDim2.new(0, 0, 0, 0),
					Size = UDim2.new(0, 0, 1, 0),
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.new(0, 0, 0.5, 0),
					Visible = false,
				}, {
					New("UIListLayout", {
						FillDirection = "Horizontal",
						VerticalAlignment = "Center",
						HorizontalAlignment = "Left",
						Padding = UDim.new(0, Window.UIPadding / 2),
					}),
				}),

				New("Frame", {
					AutomaticSize = "XY",
					BackgroundTransparency = 1,
					Position = UDim2.new(1, 0, 0.5, 0),
					AnchorPoint = Vector2.new(1, 0.5),
					Name = "Right",
				}, {
					New("UIListLayout", {
						Padding = UDim.new(0, Window.Topbar.ButtonsType == "Default" and 9 or 8),
						FillDirection = "Horizontal",
						SortOrder = "LayoutOrder",
						VerticalAlignment = "Center",
					}),
				}),

				New("UIPadding", {
					PaddingTop = UDim.new(0, Window.UIPadding),
					PaddingLeft = UDim.new(
						0,
						Window.Topbar.ButtonsType == "Default" and Window.UIPadding or Window.UIPadding - 2
					),
					PaddingRight = UDim.new(0, 8),
					PaddingBottom = UDim.new(0, Window.UIPadding),
				}),
			}),
		}),
	})

	local Topbar = Window.UIElements.Main.Main.Topbar

	local HoverHint = Creator.NewRoundFrame(999, "Squircle", {
		Name = "HoverHint",
		Size = UDim2.new(0, 0, 0, 22),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		ImageTransparency = 0.1,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = Topbar,
		Visible = false,
		ZIndex = 10050,
	}, {
		Creator.NewRoundFrame(999, "Glass-1", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Outline",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.83,
			ZIndex = 10051,
		}),
		New("TextLabel", {
			Name = "Label",
			AutomaticSize = "XY",
			BackgroundTransparency = 1,
			Text = "",
			FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
			TextSize = 12,
			TextTransparency = 0.18,
			ThemeTag = {
				TextColor3 = "Text",
			},
			ZIndex = 10052,
		}),
		New("UIPadding", {
			PaddingLeft = UDim.new(0, 9),
			PaddingRight = UDim.new(0, 9),
			PaddingTop = UDim.new(0, 4),
			PaddingBottom = UDim.new(0, 4),
		}),
	})

	local HoverHintToken = 0

	local function HideHoverHint()
		HoverHintToken += 1
		HoverHint.Visible = false
	end

	local function ShowHoverHint(TargetFrame, Text)
		HoverHintToken += 1
		local token = HoverHintToken

		task.spawn(function()
			task.wait(0.32)

			if token ~= HoverHintToken or not TargetFrame or not TargetFrame.Parent then
				return
			end

			HoverHint.Label.Text = Text or ""
			HoverHint.Visible = true
			HoverHint.ImageTransparency = 0.14
			HoverHint.Outline.ImageTransparency = 0.86

			task.wait()

			if token ~= HoverHintToken or not TargetFrame or not TargetFrame.Parent then
				HoverHint.Visible = false
				return
			end

			local topbarAbs = Topbar.AbsolutePosition
			local targetAbs = TargetFrame.AbsolutePosition
			local targetSize = TargetFrame.AbsoluteSize
			local hintSize = HoverHint.AbsoluteSize

			local posX = (targetAbs.X - topbarAbs.X) + (targetSize.X / 2) - (hintSize.X / 2)
			local maxX = math.max(Topbar.AbsoluteSize.X - hintSize.X - 8, 8)
			posX = math.clamp(posX, 8, maxX)

			HoverHint.Position = UDim2.new(0, posX, 1, 6)

			Tween(HoverHint, 0.12, {
				ImageTransparency = 0.08,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(HoverHint.Outline, 0.12, {
				ImageTransparency = 0.8,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end)
	end

	local function UpdateTopbarLayout()
		local Scale = Config.WindUI.UIScale
		local RightWidth = Topbar.Right.UIListLayout.AbsoluteContentSize.X / Scale
		local LeftWidth = Topbar.Left.AbsoluteSize.X / Scale

		if Window.Topbar.ButtonsType == "Mac" then
			local MacWidth = Topbar.MacButtons.UIListLayout.AbsoluteContentSize.X / Scale
			Topbar.Left.Position = UDim2.new(
				0,
				MacWidth + Window.UIPadding - 4,
				0,
				0
			)
			LeftWidth = LeftWidth + MacWidth + Window.UIPadding - 4
		else
			Topbar.Left.Position = UDim2.new(0, 0, 0, 0)
		end

		Topbar.Center.Position = UDim2.new(
			0,
			LeftWidth + (Window.UIPadding / Scale),
			0.5,
			0
		)

		Topbar.Center.Size = UDim2.new(
			1,
			-LeftWidth - RightWidth - ((Window.UIPadding * 2) / Scale),
			1,
			0
		)
	end

	Creator.AddSignal(Topbar.Left:GetPropertyChangedSignal("AbsoluteSize"), UpdateTopbarLayout)
	Creator.AddSignal(Topbar.Right.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateTopbarLayout)

	if Window.Topbar.ButtonsType == "Mac" then
		Creator.AddSignal(Topbar.MacButtons.UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"), UpdateTopbarLayout)
	end

	task.defer(UpdateTopbarLayout)

	function Window:CreateTopbarButton(Name, Icon, Callback, LayoutOrder, IconThemed, Color, IconSize, UseMacSystemCluster, HoverTitle)
		local SafeColor = Color or Color3.fromHex("#F4695F")

		local IsMacMode = Window.Topbar.ButtonsType == "Mac"
		local IsMacSystemButton = IsMacMode and UseMacSystemCluster == true
		local IsMacCustomButton = IsMacMode and not IsMacSystemButton

		local iconThemeAsText = (Window.Topbar.ButtonsType == "Default") or IsMacCustomButton

		local IconFrame = Creator.Image(
			Icon,
			Icon,
			0,
			Window.Folder,
			"WindowTopbarIcon",
			iconThemeAsText,
			IconThemed,
			"WindowTopbarButtonIcon"
		)

		if IsMacCustomButton then
			local iconPixelSize = IconSize or 18

			IconFrame.Size = UDim2.new(0, iconPixelSize, 0, iconPixelSize)
			IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			IconFrame.ImageLabel.ImageTransparency = 0.22
			IconFrame.ImageLabel.ImageColor3 = SafeColor == Color3.fromHex("#F4695F")
				and Color3.fromRGB(235, 235, 235)
				or SafeColor

			local Button = New("TextButton", {
				Size = UDim2.new(0, 28, 0, 28),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 9999,
			}, {
				IconFrame,
				New("UIScale", {
					Scale = 1,
				}),
			})

			local ButtonContainer = New("Frame", {
				Size = UDim2.new(0, 28, 0, 28),
				BackgroundTransparency = 1,
				Parent = Topbar.Right,
				LayoutOrder = LayoutOrder or 999,
			}, {
				Button,
			})

			Window.TopBarButtons[100 - (LayoutOrder or 999)] = {
				Name = Name,
				Object = ButtonContainer,
			}

			Creator.AddSignal(Button.MouseButton1Click, function()
				if Callback then
					Callback()
				end
			end)

			Creator.AddSignal(Button.MouseEnter, function()
				ShowHoverHint(ButtonContainer, HoverTitle or Name or "")
				Tween(Button.UIScale, 0.12, {
					Scale = 1.08,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

				Tween(IconFrame.ImageLabel, 0.12, {
					ImageTransparency = 0,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end)

			Creator.AddSignal(Button.MouseLeave, function()
				HideHoverHint()
				Tween(Button.UIScale, 0.12, {
					Scale = 1,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

				Tween(IconFrame.ImageLabel, 0.12, {
					ImageTransparency = 0.22,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end)

			Creator.AddSignal(Button.MouseButton1Down, function()
				Tween(Button.UIScale, 0.08, {
					Scale = 0.92,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end)

			Creator.AddSignal(Button.InputEnded, function()
				Tween(Button.UIScale, 0.12, {
					Scale = 1.08,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end)

			return ButtonContainer
		end

		IconFrame.Size = Window.Topbar.ButtonsType == "Default"
				and UDim2.new(0, IconSize or Window.TopBarButtonIconSize, 0, IconSize or Window.TopBarButtonIconSize)
			or UDim2.new(0, 0, 0, 0)
		IconFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		IconFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		IconFrame.ImageLabel.ImageTransparency = Window.Topbar.ButtonsType == "Default" and 0 or 1

		if IsMacSystemButton then
			IconFrame.ImageLabel.ImageColor3 = Creator.GetTextColorForHSB(SafeColor)
		end

		local Button = Creator.NewRoundFrame(
			Window.Topbar.ButtonsType == "Default" and Window.UICorner - (Window.UIPadding / 2) or 999,
			"Squircle",
			{
				Size = Window.Topbar.ButtonsType == "Default"
						and UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16)
					or UDim2.new(0, 14, 0, 14),
				LayoutOrder = LayoutOrder or 999,
				ZIndex = 9999,
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				ImageColor3 = IsMacSystemButton and SafeColor or nil,
				ThemeTag = Window.Topbar.ButtonsType == "Default" and {
					ImageColor3 = "Text",
				} or nil,
				ImageTransparency = Window.Topbar.ButtonsType == "Default" and 1 or 0,
			},
			{
				Creator.NewRoundFrame(
					Window.Topbar.ButtonsType == "Default" and Window.UICorner - (Window.UIPadding / 2) or 999,
					"Glass-1",
					{
						Size = UDim2.new(1, 0, 1, 0),
						ThemeTag = {
							ImageColor3 = "Outline",
						},
						ImageTransparency = Window.Topbar.ButtonsType == "Default" and 1 or 0.5,
						Name = "Outline",
					}
				),
				IconFrame,
				New("UIScale", {
					Scale = 1,
				}),
			},
			true
		)

		local TargetParent = Topbar.Right
		if IsMacSystemButton then
			TargetParent = Topbar.MacButtons
		end

		local ButtonContainer = New("Frame", {
			Size = Window.Topbar.ButtonsType ~= "Default" and UDim2.new(0, 24, 0, 24)
				or UDim2.new(0, Window.Topbar.Height - 16, 0, Window.Topbar.Height - 16),
			BackgroundTransparency = 1,
			Parent = TargetParent,
			LayoutOrder = LayoutOrder or 999,
		}, {
			Button,
		})

		Window.TopBarButtons[100 - (LayoutOrder or 999)] = {
			Name = Name,
			Object = ButtonContainer,
		}

		Creator.AddSignal(Button.MouseButton1Click, function()
			if Callback then
				Callback()
			end
		end)

		Creator.AddSignal(Button.MouseEnter, function()
			if Window.Topbar.ButtonsType == "Default" then
				Tween(Button, 0.15, { ImageTransparency = 0.93 }):Play()
				Tween(Button.Outline, 0.15, { ImageTransparency = 0.75 }):Play()
			else
				Tween(
					IconFrame.ImageLabel,
					0.1,
					{ ImageTransparency = 0 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()

				Tween(
					IconFrame,
					0.1,
					{
						Size = UDim2.new(
							0,
							IconSize or Window.TopBarButtonIconSize,
							0,
							IconSize or Window.TopBarButtonIconSize
						),
					},
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end)

		Creator.AddSignal(Button.MouseButton1Down, function()
			Tween(Button.UIScale, 0.2, { Scale = 0.9 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end)

		Creator.AddSignal(Button.MouseLeave, function()
			if Window.Topbar.ButtonsType == "Default" then
				Tween(Button, 0.1, { ImageTransparency = 1 }):Play()
				Tween(Button.Outline, 0.1, { ImageTransparency = 1 }):Play()
			else
				Tween(
					IconFrame.ImageLabel,
					0.1,
					{ ImageTransparency = 1 },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()

				Tween(
					IconFrame,
					0.1,
					{ Size = UDim2.new(0, 0, 0, 0) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end)

		Creator.AddSignal(Button.InputEnded, function()
			Tween(Button.UIScale, 0.2, { Scale = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
		end)

		return ButtonContainer
	end

	function Window.Topbar:Button(ButtonConfig)
		return Window:CreateTopbarButton(
			ButtonConfig.Name,
			ButtonConfig.Icon,
			ButtonConfig.Callback,
			ButtonConfig.LayoutOrder or 0,
			ButtonConfig.IconThemed,
			ButtonConfig.Color,
			ButtonConfig.IconSize,
			false,
			ButtonConfig.Title
		)
	end

	local WindowDragModule = Creator.Drag(
		Window.UIElements.Main,
		{ Window.UIElements.Main.Main.Topbar, BottomDragFrame.Frame },
		function(dragging, frame)
			if not Window.Closed then
				if dragging and frame == BottomDragFrame.Frame then
					Tween(BottomDragFrame, 0.1, { ImageTransparency = 0.35 }):Play()
				else
					Tween(BottomDragFrame, 0.2, { ImageTransparency = 0.8 }):Play()
				end
				Window.Position = Window.UIElements.Main.Position
				Window.Dragging = dragging
			end
		end
	)

	if not IsVideoBG and Window.Background and typeof(Window.Background) == "table" then
		local BackgroundGradient = New("UIGradient")
		for key, value in next, Window.Background do
			BackgroundGradient[key] = value
		end

		Window.UIElements.BackgroundGradient = Creator.NewRoundFrame(Window.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			Parent = Window.UIElements.Main.Background,
			ImageTransparency = Window.Transparent and Config.WindUI.TransparencyValue or 0,
		}, {
			BackgroundGradient,
		})
	end

	Window.OpenButtonMain = require("./Openbutton").New(Window)

	task.spawn(function()
		if Window.Icon then
			local WindowIconContainer = New("Frame", {
				Size = UDim2.new(0, 22, 0, 22),
				BackgroundTransparency = 1,
				Parent = Window.UIElements.Main.Main.Topbar.Left,
			})

			WindowIcon = Creator.Image(
				Window.Icon,
				Window.Title,
				Window.IconRadius,
				Window.Folder,
				"Window",
				true,
				Window.IconThemed,
				"WindowTopbarIcon"
			)
			WindowIcon.Parent = WindowIconContainer
			WindowIcon.Size = UDim2.new(0, Window.IconSize, 0, Window.IconSize)
			WindowIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
			WindowIcon.AnchorPoint = Vector2.new(0.5, 0.5)

			Window.OpenButtonMain:SetIcon(Window.Icon)
		else
			Window.OpenButtonMain:SetIcon(Window.Icon)
		end
	end)

	function Window:SetToggleKey(keycode)
		Window.ToggleKey = keycode
	end

	function Window:SetTitle(text)
		Window.Title = text
		if Window.Closed then
			StopWindowTitleAnimation()
		else
			RunWindowTitleAnimation()
		end
	end

	function Window:SetSubTitle(text)
		Window.SubTitle = text
		if Window.Closed then
			StopWindowTitleAnimation()
		else
			RunWindowTitleAnimation()
		end
	end

	function Window:SetTitleMessages(messages)
		Window.TitleMessages = messages
		if Window.Closed then
			StopWindowTitleAnimation()
		else
			RunWindowTitleAnimation()
		end
	end

	function Window:SetTitleAnim(anim)
		Window.TitleAnim = anim
		if Window.Closed then
			StopWindowTitleAnimation()
		else
			RunWindowTitleAnimation()
		end
	end

	function Window:SetTitleStyle(fontId, fontWeight, textSize)
		if fontId then
			Window.TitleFont = fontId
		end
		if fontWeight then
			Window.TitleFontWeight = fontWeight
		end
		if textSize then
			Window.TitleTextSize = textSize
		end

		ApplyWindowTitleFont()

		if Window.Closed then
			StopWindowTitleAnimation()
		else
			RunWindowTitleAnimation()
		end
	end

	function Window:SetAuthor(text)
		Window.Author = text
		if not WindowAuthor then
			WindowAuthor = createAuthor(Window.Author)
		end
		WindowAuthor.Text = text
	end

	function Window:SetSize(size)
		if typeof(size) == "UDim2" then
			Window.Size = size
			Tween(Window.UIElements.Main, 0.08, { Size = size }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end
	end

	function Window:SetBackgroundImage(id)
		Window.UIElements.Main.Background.ImageLabel.Image = id
	end

	function Window:SetBackgroundImageTransparency(v)
		if BGImage and BGImage:IsA("ImageLabel") then
			BGImage.ImageTransparency = math.floor(v * 10 + 0.5) / 10
		end
		Window.BackgroundImageTransparency = math.floor(v * 10 + 0.5) / 10
	end

	function Window:SetBackgroundTransparency(v)
		local rounded = math.floor(tonumber(v) * 10 + 0.5) / 10
		Config.WindUI.TransparencyValue = rounded
		Window:ToggleTransparency(rounded > 0)
	end

	local CurrentPos
	local CurrentSize

	local FullscreenButton = Window:CreateTopbarButton(
		"Fullscreen",
		Window.Topbar.ButtonsType == "Mac" and "rbxassetid://127426072704909" or "maximize",
		function()
			Window:ToggleFullscreen()
		end,
		(Window.Topbar.ButtonsType == "Default" and 998 or 999),
		true,
		Color3.fromHex("#60C762"),
		Window.Topbar.ButtonsType == "Mac" and 9 or nil,
		Window.Topbar.ButtonsType == "Mac"
	)

	function Window:ToggleFullscreen()
		local isFullscreen = Window.IsFullscreen
		WindowDragModule:Set(isFullscreen)

		if not isFullscreen then
			CurrentPos = Window.UIElements.Main.Position
			CurrentSize = Window.UIElements.Main.Size
			Window.CanResize = false
		else
			if Window.Resizable then
				Window.CanResize = true
			end
		end

		Tween(
			Window.UIElements.Main,
			0.45,
			{ Size = isFullscreen and CurrentSize or UDim2.new(1, -20, 1, -20 - 52) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()

		Tween(
			Window.UIElements.Main,
			0.45,
			{ Position = isFullscreen and CurrentPos or UDim2.new(0.5, 0, 0.5, 52 / 2) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()

		Window.IsFullscreen = not isFullscreen
	end

	Window:CreateTopbarButton(
		"Minimize",
		"minus",
		function()
			Window:Close()
		end,
		(Window.Topbar.ButtonsType == "Default" and 997 or 998),
		nil,
		Color3.fromHex("#F4C948"),
		nil,
		Window.Topbar.ButtonsType == "Mac"
	)

	function Window:OnOpen(func)
		Window.OnOpenCallback = func
	end

	function Window:OnClose(func)
		Window.OnCloseCallback = func
	end

	function Window:OnDestroy(func)
		Window.OnDestroyCallback = func
	end

	if Config.WindUI.UseAcrylic then
		Window.AcrylicPaint.AddParent(Window.UIElements.Main)
	end

	function Window:SetIconSize(Size)
		local NewSize
		if typeof(Size) == "number" then
			NewSize = UDim2.new(0, Size, 0, Size)
			Window.IconSize = Size
		elseif typeof(Size) == "UDim2" then
			NewSize = Size
			Window.IconSize = Size.X.Offset
		end

		if WindowIcon then
			WindowIcon.Size = NewSize
		end
	end

	function Window:Open()
		task.spawn(function()
			if Window.OnOpenCallback then
				task.spawn(function()
					Creator.SafeCallback(Window.OnOpenCallback)
				end)
			end

			task.wait(0.06)
			Window.Closed = false

			Tween(Window.UIElements.Main.Background, 0.2, {
				ImageTransparency = Window.Transparent and Config.WindUI.TransparencyValue or 0,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if Window.UIElements.BackgroundGradient then
				Tween(Window.UIElements.BackgroundGradient, 0.2, {
					ImageTransparency = 0,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end

			Tween(Window.UIElements.Main.Background, 0.4, {
				Size = UDim2.new(1, 0, 1, 0),
			}, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out):Play()

			if BGImage then
				if BGImage:IsA("VideoFrame") then
					BGImage.Visible = true
				else
					Tween(BGImage, 0.2, {
						ImageTransparency = Window.BackgroundImageTransparency,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				end
			end

			if Window.OpenButtonMain and Window.IsOpenButtonEnabled then
				Window.OpenButtonMain:Visible(false)
			end

			Tween(
				Blur,
				0.25,
				{ ImageTransparency = Window.ShadowTransparency },
				Enum.EasingStyle.Quint,
				Enum.EasingDirection.Out
			):Play()

			if UIStroke then
				Tween(UIStroke, 0.25, { Transparency = 0.8 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end

			task.spawn(function()
				task.wait(0.3)
				Tween(
					BottomDragFrame,
					0.45,
					{ Size = UDim2.new(0, Window.DragFrameSize, 0, 4), ImageTransparency = 0.8 },
					Enum.EasingStyle.Exponential,
					Enum.EasingDirection.Out
				):Play()
				WindowDragModule:Set(true)
				task.wait(0.45)
				if Window.Resizable then
					Tween(
						ResizeHandle.ImageLabel,
						0.45,
						{ ImageTransparency = 0.8 },
						Enum.EasingStyle.Exponential,
						Enum.EasingDirection.Out
					):Play()
					Window.CanResize = true
				end
			end)

			Window.CanDropdown = true
			Window.UIElements.Main.Visible = true

			task.spawn(function()
				task.wait(0.05)
				Window.UIElements.Main:WaitForChild("Main").Visible = true
				RunWindowTitleAnimation()
				Config.WindUI:ToggleAcrylic(true)
			end)
		end)
	end

	function Window:Close()
		local Close = {}

		if Window.OnCloseCallback then
			task.spawn(function()
				Creator.SafeCallback(Window.OnCloseCallback)
			end)
		end

		Config.WindUI:ToggleAcrylic(false)
		Window.UIElements.Main:WaitForChild("Main").Visible = false
		StopWindowTitleAnimation()

		Window.CanDropdown = false
		Window.Closed = true

		Tween(Window.UIElements.Main.Background, 0.32, {
			ImageTransparency = 1,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()

		if Window.UIElements.BackgroundGradient then
			Tween(Window.UIElements.BackgroundGradient, 0.32, {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut):Play()
		end

		Tween(Window.UIElements.Main.Background, 0.4, {
			Size = UDim2.new(1, 0, 1, -240),
		}, Enum.EasingStyle.Exponential, Enum.EasingDirection.InOut):Play()

		if BGImage then
			if BGImage:IsA("VideoFrame") then
				BGImage.Visible = false
			else
				Tween(BGImage, 0.3, {
					ImageTransparency = 1,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end

		Tween(Blur, 0.25, { ImageTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		if UIStroke then
			Tween(UIStroke, 0.25, { Transparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end

		Tween(
			BottomDragFrame,
			0.3,
			{ Size = UDim2.new(0, 0, 0, 4), ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.InOut
		):Play()

		Tween(
			ResizeHandle.ImageLabel,
			0.3,
			{ ImageTransparency = 1 },
			Enum.EasingStyle.Exponential,
			Enum.EasingDirection.Out
		):Play()

		WindowDragModule:Set(false)
		Window.CanResize = false

		task.spawn(function()
			task.wait(0.4)
			Window.UIElements.Main.Visible = false

			if Window.OpenButtonMain and not Window.Destroyed and not Window.IsPC and Window.IsOpenButtonEnabled then
				Window.OpenButtonMain:Visible(true)
			end
		end)

		function Close:Destroy()
			task.spawn(function()
				if Window.OnDestroyCallback then
					task.spawn(function()
						Creator.SafeCallback(Window.OnDestroyCallback)
					end)
				end

				if Window.AcrylicPaint and Window.AcrylicPaint.Model then
					Window.AcrylicPaint.Model:Destroy()
				end

				Window.Destroyed = true
				task.wait(0.4)

				Config.WindUI.ScreenGui:Destroy()
				Config.WindUI.NotificationGui:Destroy()
				Config.WindUI.DropdownGui:Destroy()
				Config.WindUI.TooltipGui:Destroy()

				Creator.DisconnectAll()
				return
			end)
		end

		return Close
	end

	function Window:Destroy()
		return Window:Close():Destroy()
	end

	function Window:Toggle()
		if Window.Closed then
			Window:Open()
		else
			Window:Close()
		end
	end

	function Window:ToggleTransparency(Value)
		Window.Transparent = Value
		Config.WindUI.Transparent = Value
		Window.UIElements.Main.Background.ImageTransparency = Value and Config.WindUI.TransparencyValue or 0
	end

	function Window:LockAll()
		for _, element in next, Window.AllElements do
			if element.Lock then
				element:Lock()
			end
		end
	end

	function Window:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Unlock then
				element:Unlock()
			end
		end
	end

	function Window:GetLocked()
		local LockedElements = {}
		for _, element in next, Window.AllElements do
			if element.Locked then
				table.insert(LockedElements, element)
			end
		end
		return LockedElements
	end

	function Window:GetUnlocked()
		local UnlockedElements = {}
		for _, element in next, Window.AllElements do
			if element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end
		return UnlockedElements
	end

	function Window:GetUIScale()
		return Config.WindUI.UIScale
	end

	function Window:SetUIScale(v)
		Config.WindUI.UIScale = v
		Tween(Config.WindUI.UIScaleObj, 0.2, { Scale = v }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		return Window
	end

	function Window:SetToTheCenter()
		Tween(
			Window.UIElements.Main,
			0.45,
			{ Position = UDim2.new(0.5, 0, 0.5, 0) },
			Enum.EasingStyle.Quint,
			Enum.EasingDirection.Out
		):Play()
		return Window
	end

	function Window:SetCurrentConfig(ConfigModule)
		Window.CurrentConfig = ConfigModule
	end

	do
		local Margin = 40
		local ViewportSize = CurrentCamera.ViewportSize
		local MainAbsSize = Window.UIElements.Main.AbsoluteSize

		if not Window.IsFullscreen and Window.AutoScale then
			local AvailableWidth = ViewportSize.X - (Margin * 2)
			local AvailableHeight = ViewportSize.Y - (Margin * 2)

			local ScaleX = AvailableWidth / MainAbsSize.X
			local ScaleY = AvailableHeight / MainAbsSize.Y

			local RequiredScale = math.min(ScaleX, ScaleY)
			local FinalScale = math.clamp(RequiredScale, 0.3, 1.0)

			local CurrentScale = Window:GetUIScale() or 1
			local Tolerance = 0.05

			if math.abs(FinalScale - CurrentScale) > Tolerance then
				Window:SetUIScale(FinalScale)
			end
		end
	end

	if Window.OpenButtonMain and Window.OpenButtonMain.Button then
		Creator.AddSignal(Window.OpenButtonMain.Button.TextButton.MouseButton1Click, function()
			Window:Open()
		end)
	end

	Creator.AddSignal(UserInputService.InputBegan, function(input, isProcessed)
		if isProcessed then
			return
		end

		if Window.ToggleKey and input.KeyCode == Window.ToggleKey then
			Window:Toggle()
		end
	end)

	task.spawn(function()
		Window:Open()
	end)

	function Window:EditOpenButton(OpenButtonConfig)
		return Window.OpenButtonMain:Edit(OpenButtonConfig)
	end

	if Window.OpenButton and typeof(Window.OpenButton) == "table" then
		Window:EditOpenButton(Window.OpenButton)
	end

	local TabModuleMain = require("./Tab")
	local SectionModule = require("./Section")
	local TabModule = TabModuleMain.Init(Window, Config.WindUI, Config.WindUI.TooltipGui)

	TabModule:OnChange(function(t)
		Window.CurrentTab = t
	end)

	Window.TabModule = TabModule

	function Window:Tab(TabConfig)
		TabConfig.Parent = Window.UIElements.SideBar.Frame
		return TabModule.New(TabConfig, Config.WindUI.UIScale)
	end

	function Window:SelectTab(Tab)
		TabModule:SelectTab(Tab)
	end

	function Window:Section(SectionConfig)
		return SectionModule.New(
			SectionConfig,
			Window.UIElements.SideBar.Frame,
			Window.Folder,
			Config.WindUI.UIScale,
			Window
		)
	end

	function Window:IsResizable(v)
		Window.Resizable = v
		Window.CanResize = v
	end

	function Window:SetPanelBackground(v)
		if typeof(v) == "boolean" then
			Window.HidePanelBackground = v
			Window.UIElements.MainBar.Background.Visible = v

			if TabModule then
				for _, Container in next, TabModule.Containers do
					Container.ScrollingFrame.UIPadding.PaddingTop = UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingLeft = UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingRight = UDim.new(0, Window.HidePanelBackground and 20 or 10)
					Container.ScrollingFrame.UIPadding.PaddingBottom = UDim.new(0, Window.HidePanelBackground and 20 or 10)
				end
			end
		end
	end

	function Window:Divider()
		local Divider = New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
		})

		local MainDivider = New("Frame", {
			Parent = Window.UIElements.SideBar.Frame,
			Size = UDim2.new(1, -7, 0, 5),
			BackgroundTransparency = 1,
		}, {
			Divider,
		})

		return MainDivider
	end

	local DialogModule = require("./Dialog").Init(Window, Config.WindUI, nil)
	function Window:Dialog(DialogConfig)
		local DialogTable = {
			Title = DialogConfig.Title or "Dialog",
			Width = DialogConfig.Width or 320,
			Content = DialogConfig.Content,
			Buttons = DialogConfig.Buttons or {},
			TextPadding = 14,
		}

		local Dialog = DialogModule.Create(false)
		Dialog.UIElements.Main.Size = UDim2.new(0, DialogTable.Width, 0, 0)

		local DialogTopColFrame = New("Frame", {
			Size = UDim2.new(1, 0, 1, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
		}, {
			New("UIListLayout", {
				FillDirection = "Vertical",
				Padding = UDim.new(0, Dialog.UIPadding),
			}),
		})

		local DialogTopRowFrame = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = DialogTopColFrame,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				Padding = UDim.new(0, Dialog.UIPadding),
				VerticalAlignment = "Center",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
				PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
			}),
		})

		local Icon
		if DialogConfig.Icon then
			Icon = Creator.Image(
				DialogConfig.Icon,
				DialogTable.Title .. ":" .. DialogConfig.Icon,
				0,
				Window,
				"Dialog",
				true,
				DialogConfig.IconThemed
			)
			Icon.Size = UDim2.new(0, 22, 0, 22)
			Icon.Parent = DialogTopRowFrame
		end

		Dialog.UIElements.UIListLayout = New("UIListLayout", {
			Padding = UDim.new(0, 12),
			FillDirection = "Vertical",
			HorizontalAlignment = "Left",
			VerticalFlex = "SpaceBetween",
			Parent = Dialog.UIElements.Main,
		})

		New("UISizeConstraint", {
			MinSize = Vector2.new(180, 20),
			MaxSize = Vector2.new(400, math.huge),
			Parent = Dialog.UIElements.Main,
		})

		Dialog.UIElements.Title = New("TextLabel", {
			Text = DialogTable.Title,
			TextSize = 20,
			FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
			TextXAlignment = "Left",
			TextWrapped = true,
			RichText = true,
			Size = UDim2.new(1, Icon and -26 - Dialog.UIPadding or 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				TextColor3 = "Text",
			},
			BackgroundTransparency = 1,
			Parent = DialogTopRowFrame,
		})

		if DialogTable.Content then
			New("TextLabel", {
				Text = DialogTable.Content,
				TextSize = 18,
				TextTransparency = 0.4,
				TextWrapped = true,
				RichText = true,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextXAlignment = "Left",
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				LayoutOrder = 2,
				ThemeTag = {
					TextColor3 = "Text",
				},
				BackgroundTransparency = 1,
				Parent = DialogTopColFrame,
			}, {
				New("UIPadding", {
					PaddingLeft = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingRight = UDim.new(0, DialogTable.TextPadding / 2),
					PaddingBottom = UDim.new(0, DialogTable.TextPadding / 2),
				}),
			})
		end

		local ButtonsLayout = New("UIListLayout", {
			Padding = UDim.new(0, 6),
			FillDirection = "Horizontal",
			HorizontalAlignment = "Right",
		})

		local ButtonsContent = New("Frame", {
			Size = UDim2.new(1, 0, 0, 40),
			AutomaticSize = "None",
			BackgroundTransparency = 1,
			Parent = Dialog.UIElements.Main,
			LayoutOrder = 4,
		}, {
			ButtonsLayout,
		})

		local Buttons = {}

		for _, Button in next, DialogTable.Buttons do
			local ButtonFrame =
				CreateButton(Button.Title, Button.Icon, Button.Callback, Button.Variant, ButtonsContent, Dialog, true)
			table.insert(Buttons, ButtonFrame)
		end

		local function CheckButtonsOverflow()
			ButtonsLayout.FillDirection = Enum.FillDirection.Horizontal
			ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
			ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			ButtonsContent.AutomaticSize = Enum.AutomaticSize.None

			for _, button in ipairs(Buttons) do
				button.Size = UDim2.new(0, 0, 1, 0)
				button.AutomaticSize = Enum.AutomaticSize.X
			end

			task.wait()

			local totalWidth = ButtonsLayout.AbsoluteContentSize.X / Config.WindUI.UIScale
			local parentWidth = ButtonsContent.AbsoluteSize.X / Config.WindUI.UIScale

			if totalWidth > parentWidth then
				ButtonsLayout.FillDirection = Enum.FillDirection.Vertical
				ButtonsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
				ButtonsLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
				ButtonsContent.AutomaticSize = Enum.AutomaticSize.Y

				for _, button in ipairs(Buttons) do
					button.Size = UDim2.new(1, 0, 0, 40)
					button.AutomaticSize = Enum.AutomaticSize.None
				end
			else
				local availableSpace = parentWidth - totalWidth
				if availableSpace > 0 then
					local smallestButton = nil
					local smallestWidth = math.huge

					for _, button in ipairs(Buttons) do
						local buttonWidth = button.AbsoluteSize.X / Config.WindUI.UIScale
						if buttonWidth < smallestWidth then
							smallestWidth = buttonWidth
							smallestButton = button
						end
					end

					if smallestButton then
						smallestButton.Size = UDim2.new(0, smallestWidth + availableSpace, 1, 0)
						smallestButton.AutomaticSize = Enum.AutomaticSize.None
					end
				end
			end
		end

		Creator.AddSignal(Dialog.UIElements.Main:GetPropertyChangedSignal("AbsoluteSize"), CheckButtonsOverflow)
		CheckButtonsOverflow()

		task.wait()
		Dialog:Open()

		return Dialog
	end

	local ClickedClose = false

	Window:CreateTopbarButton(
		"Close",
		"x",
		function()
			if not ClickedClose then
				if not Window.IgnoreAlerts then
					ClickedClose = true
					Window:SetToTheCenter()
					Window:Dialog({
						Title = "Close Window",
						Content = "Do you want to close this window? You will not be able to open it again.",
						Buttons = {
							{
								Title = "Cancel",
								Callback = function()
									ClickedClose = false
								end,
								Variant = "Secondary",
							},
							{
								Title = "Close Window",
								Callback = function()
									ClickedClose = false
									Window:Destroy()
								end,
								Variant = "Primary",
							},
						},
					})
				else
					Window:Destroy()
				end
			end
		end,
		(Window.Topbar.ButtonsType == "Default" and 999 or 997),
		nil,
		Color3.fromHex("#F4695F"),
		nil,
		Window.Topbar.ButtonsType == "Mac"
	)

	function Window:Tag(TagConfig)
		if Window.UIElements.Main.Main.Topbar.Center.Visible == false then
			Window.UIElements.Main.Main.Topbar.Center.Visible = true
		end
		return Tag:New(TagConfig, Window.UIElements.Main.Main.Topbar.Center)
	end

	local isResizing
	local initialSize
	local initialInputPosition

	local function startResizing(input)
		if Window.CanResize then
			isResizing = true
			FullScreenIcon.Active = true
			initialSize = Window.UIElements.Main.Size
			initialInputPosition = input.Position
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()

			Creator.AddSignal(input.Changed, function()
				if input.UserInputState == Enum.UserInputState.End then
					isResizing = false
					FullScreenIcon.Active = false
					Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
				end
			end)
		end
	end

	Creator.AddSignal(ResizeHandle.InputBegan, function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if Window.CanResize then
				startResizing(input)
			end
		end
	end)

	Creator.AddSignal(UserInputService.InputChanged, function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if isResizing and Window.CanResize then
				local delta = input.Position - initialInputPosition
				local newSize = UDim2.new(0, initialSize.X.Offset + delta.X * 2, 0, initialSize.Y.Offset + delta.Y * 2)

				newSize = UDim2.new(
					newSize.X.Scale,
					math.clamp(newSize.X.Offset, Window.MinSize.X, Window.MaxSize.X),
					newSize.Y.Scale,
					math.clamp(newSize.Y.Offset, Window.MinSize.Y, Window.MaxSize.Y)
				)

				Tween(Window.UIElements.Main, 0.08, {
					Size = newSize,
				}, Enum.EasingStyle.Quad, Enum.EasingDirection.Out):Play()

				Window.Size = newSize
			end
		end
	end)

	Creator.AddSignal(ResizeHandle.MouseEnter, function()
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.1, { ImageTransparency = 0.35 }):Play()
		end
	end)

	Creator.AddSignal(ResizeHandle.MouseLeave, function()
		if not isResizing then
			Tween(ResizeHandle.ImageLabel, 0.17, { ImageTransparency = 0.8 }):Play()
		end
	end)

	local LastUpTime = 0
	local DoubleClickWindow = 0.4
	local InitialPosition = nil
	local ClickCount = 0

	local function onDoubleClick()
		Window:SetToTheCenter()
	end

	Creator.AddSignal(BottomDragFrame.Frame.MouseButton1Up, function()
		local currentTime = tick()
		local currentPosition = Window.Position

		ClickCount += 1

		if ClickCount == 1 then
			LastUpTime = currentTime
			InitialPosition = currentPosition

			task.spawn(function()
				task.wait(DoubleClickWindow)
				if ClickCount == 1 then
					ClickCount = 0
					InitialPosition = nil
				end
			end)
		elseif ClickCount == 2 then
			if currentTime - LastUpTime <= DoubleClickWindow and currentPosition == InitialPosition then
				onDoubleClick()
			end

			ClickCount = 0
			InitialPosition = nil
			LastUpTime = 0
		else
			ClickCount = 1
			LastUpTime = currentTime
			InitialPosition = currentPosition
		end
	end)

	if not Window.HideSearchBar then
		local SearchBar = require("../search/Init")
		local IsOpen = false

		local SearchLabel = CreateLabel("Search", "search", Window.UIElements.SideBarContainer, true)
		SearchLabel.Size = UDim2.new(1, -Window.UIPadding / 2, 0, 39)
		SearchLabel.Position = UDim2.new(0, Window.UIPadding / 2, 0, 0)

		Creator.AddSignal(SearchLabel.MouseButton1Click, function()
			if IsOpen then
				return
			end

			SearchBar.new(Window.TabModule, Window.UIElements.Main, function()
				IsOpen = false
				if Window.Resizable then
					Window.CanResize = true
				end

				Tween(FullScreenBlur, 0.1, { ImageTransparency = 1 }):Play()
				FullScreenBlur.Active = false
			end)

			Tween(FullScreenBlur, 0.1, { ImageTransparency = 0.65 }):Play()
			FullScreenBlur.Active = true

			IsOpen = true
			Window.CanResize = false
		end)
	end

	function Window:DisableTopbarButtons(btns)
		for _, b in next, btns do
			for _, i in next, Window.TopBarButtons do
				if i.Name == b then
					i.Object.Visible = false
				end
			end
		end
	end

	return Window
end
