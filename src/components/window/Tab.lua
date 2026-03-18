local cloneref = (cloneref or clonereference or function(instance)
	return instance
end)

local Players = game:GetService("Players")

local UserInputService = cloneref(game:GetService("UserInputService"))
local Mouse = Players.LocalPlayer:GetMouse()

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local CreateToolTip = require("../ui/Tooltip").New
local CreateScrollSlider = require("../ui/ScrollSlider").New

local Window, WindUI, UIScale

local TabModule = {
	Tabs = {},
	Containers = {},
	SelectedTab = nil,
	TabCount = 0,
	ToolTipParent = nil,
	TabHighlight = nil,

	OnChangeFunc = function(v) end,
}

function TabModule.Init(WindowTable, WindUITable, ToolTipParent, TabHighlight)
	Window = WindowTable
	WindUI = WindUITable
	TabModule.ToolTipParent = ToolTipParent
	TabModule.TabHighlight = TabHighlight
	return TabModule
end

function TabModule.New(Config, UIScale)
	local Tab = {
		__type = "Tab",
		Title = Config.Title or "Tab",
		Desc = Config.Desc,
		Icon = Config.Icon,
		IconColor = Config.IconColor,
		IconShape = Config.IconShape,
		IconThemed = Config.IconThemed,
		Locked = Config.Locked,
		ShowTabTitle = Config.ShowTabTitle,
		TabTitleAlign = Config.TabTitleAlign or "Left",
		CustomEmptyPage = (Config.CustomEmptyPage and next(Config.CustomEmptyPage) ~= nil) and Config.CustomEmptyPage
			or { Icon = "lucide:frown", IconSize = 48, Title = "This tab is Empty", Desc = nil },
		Border = Config.Border,
		Selected = false,
		Index = nil,
		Parent = Config.Parent,
		UIElements = {},
		Elements = {},
		ContainerFrame = nil,
		UICorner = Window.UICorner - (Window.UIPadding / 2),

		Gap = Window.NewElements and 1 or 6,

		TabPaddingX = 4 + (Window.UIPadding / 2),
		TabPaddingY = 3 + (Window.UIPadding / 2),
		TitlePaddingY = 0,
	}

	if Tab.IconShape then
		Tab.TabPaddingX = 2 + (Window.UIPadding / 4)
		Tab.TabPaddingY = 2 + (Window.UIPadding / 4)
		Tab.TitlePaddingY = 2 + (Window.UIPadding / 4)
	end

	TabModule.TabCount = TabModule.TabCount + 1

	local TabIndex = TabModule.TabCount
	Tab.Index = TabIndex

	Tab.UIElements.Main = Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -7, 0, 0),
		AutomaticSize = "Y",
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = "TabBackground",
		},
		ImageTransparency = 1,
	}, {
		Creator.NewRoundFrame(Tab.UICorner, "Glass-1.4", {
			Size = UDim2.new(1, 0, 1, 0),
			ThemeTag = {
				ImageColor3 = "TabBorder",
			},
			ImageTransparency = 1,
			Name = "Outline",
		}),
		Creator.NewRoundFrame(Tab.UICorner, "Squircle", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 1,
			Name = "Frame",
		}, {
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 2 + (Window.UIPadding / 2)),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
			}),
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "TabTitle",
				},
				TextTransparency = not Tab.Locked and 0.4 or 0.7,
				TextSize = 15,
				Size = UDim2.new(1, 0, 0, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextWrapped = true,
				RichText = true,
				AutomaticSize = "Y",
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
			}, {
				New("UIPadding", {
					PaddingTop = UDim.new(0, Tab.TitlePaddingY),
					PaddingBottom = UDim.new(0, Tab.TitlePaddingY),
				}),
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, Tab.TabPaddingY),
				PaddingLeft = UDim.new(0, Tab.TabPaddingX),
				PaddingRight = UDim.new(0, Tab.TabPaddingX),
				PaddingBottom = UDim.new(0, Tab.TabPaddingY),
			}),
		}),
	}, true)

	local TextOffset = 0
	local Icon
	local Icon2

	if Tab.Icon then
		Icon = Creator.Image(
			Tab.Icon,
			Tab.Icon .. ":" .. Tab.Title,
			0,
			Window.Folder,
			Tab.__type,
			Tab.IconColor and false or true,
			Tab.IconThemed,
			"TabIcon"
		)
		Icon.Size = UDim2.new(0, 16, 0, 16)
		if Tab.IconColor then
			Icon.ImageLabel.ImageColor3 = Tab.IconColor
		end
		if not Tab.IconShape then
			Icon.Parent = Tab.UIElements.Main.Frame
			Tab.UIElements.Icon = Icon
			Icon.ImageLabel.ImageTransparency = not Tab.Locked and 0 or 0.7
			TextOffset = -16 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		elseif Tab.IconColor then
			local _IconBG = Creator.NewRoundFrame(
				Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
				"Squircle",
				{
					Size = UDim2.new(0, 26, 0, 26),
					ImageColor3 = Tab.IconColor,
					Parent = Tab.UIElements.Main.Frame,
				},
				{
					Icon,
					Creator.NewRoundFrame(
						Tab.IconShape ~= "Circle" and (Tab.UICorner + 5 - (2 + (Window.UIPadding / 4))) or 9999,
						"Glass-1.4",
						{
							Size = UDim2.new(1, 0, 1, 0),
							ThemeTag = {
								ImageColor3 = "White",
							},
							ImageTransparency = 0,
							Name = "Outline",
						}
					),
				}
			)
			Icon.AnchorPoint = Vector2.new(0.5, 0.5)
			Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
			Icon.ImageLabel.ImageTransparency = 0
			Icon.ImageLabel.ImageColor3 = Creator.GetTextColorForHSB(Tab.IconColor, 0.68)
			TextOffset = -26 - 2 - (Window.UIPadding / 2)
			Tab.UIElements.Main.Frame.TextLabel.Size = UDim2.new(1, TextOffset, 0, 0)
		end

		Icon2 =
			Creator.Image(Tab.Icon, Tab.Icon .. ":" .. Tab.Title, 0, Window.Folder, Tab.__type, true, Tab.IconThemed)
		Icon2.Size = UDim2.new(0, 16, 0, 16)
		Icon2.ImageLabel.ImageTransparency = not Tab.Locked and 0 or 0.7
		TextOffset = -30
	end

	Tab.UIElements.ContainerFrame = New("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, Tab.ShowTabTitle and -((Window.UIPadding * 2.4) + 12) or 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		ElasticBehavior = "Never",
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		AutomaticCanvasSize = "Y",
		ScrollingDirection = "Y",
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingLeft = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingRight = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
			PaddingBottom = UDim.new(0, not Window.HidePanelBackground and 20 or 10),
		}),
		New("UIListLayout", {
			SortOrder = "LayoutOrder",
			Padding = UDim.new(0, Tab.Gap),
			HorizontalAlignment = "Center",
		}),
	})

	Tab.UIElements.ContainerFrameCanvas = New("Frame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		Visible = false,
		Parent = Window.UIElements.MainBar,
		ZIndex = 5,
	}, {
		Tab.UIElements.ContainerFrame,
		New("Frame", {
			Size = UDim2.new(1, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			BackgroundTransparency = 1,
			Visible = Tab.ShowTabTitle or false,
			Name = "TabTitle",
		}, {
			Icon2,
			New("TextLabel", {
				Text = Tab.Title,
				ThemeTag = {
					TextColor3 = "Text",
				},
				TextSize = 20,
				TextTransparency = 0.1,
				Size = UDim2.new(0, 0, 1, 0),
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				RichText = true,
				LayoutOrder = 2,
				TextXAlignment = "Left",
				BackgroundTransparency = 1,
				AutomaticSize = "X",
			}),
			New("UIPadding", {
				PaddingTop = UDim.new(0, 20),
				PaddingLeft = UDim.new(0, 20),
				PaddingRight = UDim.new(0, 20),
				PaddingBottom = UDim.new(0, 20),
			}),
			New("UIListLayout", {
				SortOrder = "LayoutOrder",
				Padding = UDim.new(0, 10),
				FillDirection = "Horizontal",
				VerticalAlignment = "Center",
				HorizontalAlignment = Tab.TabTitleAlign,
			}),
		}),
		New("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			BackgroundTransparency = 0.9,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			Position = UDim2.new(0, 0, 0, ((Window.UIPadding * 2.4) + 12)),
			Visible = Tab.ShowTabTitle or false,
		}),
	})

	table.insert(TabModule.Containers, Tab.UIElements.ContainerFrameCanvas)
	table.insert(TabModule.Tabs, Tab)

	Tab.ContainerFrame = Tab.UIElements.ContainerFrameCanvas

	Creator.AddSignal(Tab.UIElements.Main.MouseButton1Click, function()
		if not Tab.Locked then
			TabModule:SelectTab(TabIndex)
		end
	end)

	if Window.ScrollBarEnabled then
		CreateScrollSlider(Tab.UIElements.ContainerFrame, Tab.UIElements.ContainerFrameCanvas, Window, 3)
	end

	local ToolTip
	local hoverTimer
	local MouseConn
	local IsHovering = false

	if Tab.Desc then
		Creator.AddSignal(Tab.UIElements.Main.InputBegan, function()
			IsHovering = true
			hoverTimer = task.spawn(function()
				task.wait(0.35)
				if IsHovering and not ToolTip then
					ToolTip = CreateToolTip(Tab.Desc, TabModule.ToolTipParent, true)
					ToolTip.Container.AnchorPoint = Vector2.new(0.5, 0.5)

					local function updatePosition()
						if ToolTip then
							ToolTip.Container.Position = UDim2.new(0, Mouse.X, 0, Mouse.Y - 4)
						end
					end

					updatePosition()
					MouseConn = Mouse.Move:Connect(updatePosition)
					ToolTip:Open()
				end
			end)
		end)
	end

	Creator.AddSignal(Tab.UIElements.Main.MouseEnter, function()
		if not Tab.Locked then
			Creator.SetThemeTag(Tab.UIElements.Main.Frame, {
				ImageTransparency = "TabBackgroundHoverTransparency",
				ImageColor3 = "TabBackgroundHover",
			}, 0.1)
		end
	end)
	Creator.AddSignal(Tab.UIElements.Main.InputEnded, function()
		if Tab.Desc then
			IsHovering = false
			if hoverTimer then
				task.cancel(hoverTimer)
				hoverTimer = nil
			end
			if MouseConn then
				MouseConn:Disconnect()
				MouseConn = nil
			end
			if ToolTip then
				ToolTip:Close()
				ToolTip = nil
			end
		end

		if not Tab.Locked then
			Creator.SetThemeTag(Tab.UIElements.Main.Frame, {
				ImageTransparency = "TabBorderTransparency",
			}, 0.1)
		end
	end)

	function Tab:ScrollToTheElement(elemindex)
		Tab.UIElements.ContainerFrame.ScrollingEnabled = false

		Creator.Tween(Tab.UIElements.ContainerFrame, 0.45, {
			CanvasPosition = Vector2.new(
				0,
				Tab.Elements[elemindex].ElementFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.AbsolutePosition.Y
					- Tab.UIElements.ContainerFrame.UIPadding.PaddingTop.Offset
			),
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		task.spawn(function()
			task.wait(0.48)

			if Tab.Elements[elemindex].Highlight then
				Tab.Elements[elemindex]:Highlight()
			end
			Tab.UIElements.ContainerFrame.ScrollingEnabled = true
		end)

		return Tab
	end

	local ElementsModule = require("../../elements/Init")

	ElementsModule.Load(
		Tab,
		Tab.UIElements.ContainerFrame,
		ElementsModule.Elements,
		Window,
		WindUI,
		nil,
		ElementsModule,
		UIScale
	)

	function Tab:SubTabGroup()
		local SubGroupModule = {}
		local SubTabs = {}
		local SelectedSubTab = 1

		local BUTTON_GAP = 6
		local BUTTON_HEIGHT = 58
		local BAR_HEIGHT = 74
		local BAR_PADDING_X = 8
		local CurrentButtonWidth = 76

		local function GetButtonWidth(count)
			if count <= 2 then
				return 96
			elseif count == 3 then
				return 86
			else
				return 76
			end
		end

		local MainSubGroupContainer = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = Tab.UIElements.ContainerFrame,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 10),
				SortOrder = "LayoutOrder",
			}),
		})

		local NavigationBarHolder = New("Frame", {
			Size = UDim2.new(1, 0, 0, BAR_HEIGHT),
			BackgroundTransparency = 1,
			Parent = MainSubGroupContainer,
		})

		local NavigationBar = Creator.NewRoundFrame(999, "Squircle", {
			Name = "NavigationBar",
			Size = UDim2.new(0, 0, 0, BAR_HEIGHT),
			Position = UDim2.new(0.5, 0, 0, 0),
			AnchorPoint = Vector2.new(0.5, 0),
			ImageColor3 = Color3.fromRGB(205, 210, 220),
			ImageTransparency = 0.78,
			Parent = NavigationBarHolder,
		}, {
			Creator.NewRoundFrame(999, "Glass-1.4", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Outline",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ImageTransparency = 0.72,
			}),
			Creator.NewRoundFrame(999, "Squircle", {
				Size = UDim2.new(1, -2, 1, -2),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Name = "InnerGlass",
				ImageColor3 = Color3.fromRGB(170, 176, 188),
				ImageTransparency = 0.92,
			}),
			New("Frame", {
				Name = "TopLine",
				BackgroundColor3 = Color3.new(1, 1, 1),
				BackgroundTransparency = 0.95,
				Size = UDim2.new(1, -18, 0, 1),
				Position = UDim2.new(0.5, 0, 0, 1),
				AnchorPoint = Vector2.new(0.5, 0),
			}, {
				New("UICorner", {
					CornerRadius = UDim.new(0, 999),
				}),
			}),
			New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ImageTransparency = 0.975,
				Size = UDim2.new(0, 54, 0, 54),
				Position = UDim2.new(1, -72, 0, 6),
			}),
			New("ImageLabel", {
				BackgroundTransparency = 1,
				Image = "rbxassetid://1316045217",
				ImageColor3 = Color3.fromRGB(240, 244, 255),
				ImageTransparency = 0.982,
				Size = UDim2.new(0, 38, 0, 38),
				Position = UDim2.new(1, -30, 0, 16),
			}),
		})

		local ButtonsWrap = New("Frame", {
			Name = "ButtonsWrap",
			Size = UDim2.new(0, 0, 0, BUTTON_HEIGHT),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundTransparency = 1,
			Parent = NavigationBar,
		})

		local ActivePill = Creator.NewRoundFrame(999, "Squircle", {
			Name = "ActivePill",
			Size = UDim2.new(0, CurrentButtonWidth, 0, BUTTON_HEIGHT),
			Position = UDim2.new(0, 0, 0, 0),
			ThemeTag = {
				ImageColor3 = "Accent",
			},
			ImageTransparency = 0.04,
			Visible = false,
			Parent = ButtonsWrap,
		}, {
			Creator.NewRoundFrame(999, "Glass-1", {
				Size = UDim2.new(1, 0, 1, 0),
				Name = "Outline",
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = 0.82,
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
		})

		local ItemsFrame = New("Frame", {
			Name = "ItemsFrame",
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 0, 0, BUTTON_HEIGHT),
			Parent = ButtonsWrap,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, BUTTON_GAP),
				FillDirection = "Horizontal",
				HorizontalAlignment = "Left",
				VerticalAlignment = "Center",
				SortOrder = "LayoutOrder",
			}),
		})

		local ContentContainer = New("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = "Y",
			BackgroundTransparency = 1,
			Parent = MainSubGroupContainer,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 6),
				SortOrder = "LayoutOrder",
			}),
		})

		local function UpdateBarSize()
			local count = #SubTabs
			if count <= 0 then
				NavigationBar.Size = UDim2.new(0, 0, 0, BAR_HEIGHT)
				ButtonsWrap.Size = UDim2.new(0, 0, 0, BUTTON_HEIGHT)
				ItemsFrame.Size = UDim2.new(0, 0, 0, BUTTON_HEIGHT)
				ActivePill.Visible = false
				return
			end

			CurrentButtonWidth = GetButtonWidth(count)

			local buttonsWidth = (count * CurrentButtonWidth) + (math.max(count - 1, 0) * BUTTON_GAP)

			for _, item in ipairs(SubTabs) do
				item.Button.Size = UDim2.new(0, CurrentButtonWidth, 0, BUTTON_HEIGHT)
			end

			ActivePill.Size = UDim2.new(0, CurrentButtonWidth, 0, BUTTON_HEIGHT)
			NavigationBar.Size = UDim2.new(0, buttonsWidth + (BAR_PADDING_X * 2), 0, BAR_HEIGHT)
			ButtonsWrap.Size = UDim2.new(0, buttonsWidth, 0, BUTTON_HEIGHT)
			ItemsFrame.Size = UDim2.new(0, buttonsWidth, 0, BUTTON_HEIGHT)
			ActivePill.Visible = true
		end

		local function MoveActivePill(index, instant)
			local x = (index - 1) * (CurrentButtonWidth + BUTTON_GAP)

			if instant then
				ActivePill.Position = UDim2.new(0, x, 0, 0)
			else
				Tween(
					ActivePill,
					0.22,
					{ Position = UDim2.new(0, x, 0, 0) },
					Enum.EasingStyle.Quint,
					Enum.EasingDirection.Out
				):Play()
			end
		end

		local function SetSubTab(index, instant)
			SelectedSubTab = index
			MoveActivePill(index, instant)

			for i, other in ipairs(SubTabs) do
				local isSelected = (i == index)
				other.Page.Visible = isSelected

				if instant then
					other.Label.TextTransparency = isSelected and 0 or 0.22
					if other.Icon then
						other.Icon.ImageTransparency = isSelected and 0 or 0.22
					end
				else
					Tween(
						other.Label,
						0.18,
						{ TextTransparency = isSelected and 0 or 0.22 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()

					if other.Icon then
						Tween(
							other.Icon,
							0.18,
							{ ImageTransparency = isSelected and 0 or 0.22 },
							Enum.EasingStyle.Quint,
							Enum.EasingDirection.Out
						):Play()
					end
				end
			end
		end

		function SubGroupModule:AddSubTab(SubTabTitle, IconName)
			local SubTabObject = setmetatable({
				Title = SubTabTitle,
				Name = SubTabTitle,
				__type = "Tab",
				Elements = {},
				UIElements = {},
			}, { __index = Tab })

			local isFirstTab = (#SubTabs == 0)

			local PageFrame = New("Frame", {
				Size = UDim2.new(1, 0, 0, 0),
				AutomaticSize = "Y",
				BackgroundTransparency = 1,
				Visible = isFirstTab,
				Parent = ContentContainer,
			}, {
				New("UIListLayout", {
					Padding = UDim.new(0, 6),
					SortOrder = "LayoutOrder",
				}),
				New("UIPadding", {
					PaddingTop = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 2),
					PaddingBottom = UDim.new(0, 2),
				}),
			})

			local IconData = IconName and Creator.Icon(IconName)

			local IconImage = IconData and New("ImageLabel", {
				Name = "Icon",
				Image = IconData[1],
				ImageRectOffset = IconData[2].ImageRectPosition,
				ImageRectSize = IconData[2].ImageRectSize,
				Size = UDim2.new(0, 20, 0, 20),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.new(1, 1, 1),
				ImageTransparency = isFirstTab and 0 or 0.22,
				LayoutOrder = 1,
			}) or nil

			local LabelText = New("TextLabel", {
				Name = "Label",
				Text = SubTabTitle,
				Size = UDim2.new(1, -8, 0, 18),
				BackgroundTransparency = 1,
				TextXAlignment = "Center",
				TextYAlignment = "Center",
				TextWrapped = false,
				TextTruncate = "AtEnd",
				TextSize = 12,
				TextColor3 = Color3.new(1, 1, 1),
				TextTransparency = isFirstTab and 0 or 0.22,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.SemiBold),
				LayoutOrder = 2,
			})

			local NavButton = New("TextButton", {
				Name = "NavButton",
				Size = UDim2.new(0, CurrentButtonWidth, 0, BUTTON_HEIGHT),
				BackgroundTransparency = 1,
				AutoButtonColor = false,
				Text = "",
				Parent = ItemsFrame,
			}, {
				New("Frame", {
					Name = "Content",
					Size = UDim2.new(1, 0, 1, 0),
					BackgroundTransparency = 1,
				}, {
					New("UIListLayout", {
						FillDirection = "Vertical",
						HorizontalAlignment = "Center",
						VerticalAlignment = "Center",
						Padding = UDim.new(0, 3),
						SortOrder = "LayoutOrder",
					}),
					IconImage,
					LabelText,
				})
			})

			SubTabObject.UIElements.ContainerFrame = PageFrame
			SubTabObject.UIElements.Main = NavButton

			local CurrentIndex = #SubTabs + 1

			Creator.AddSignal(NavButton.MouseButton1Click, function()
				SetSubTab(CurrentIndex, false)
			end)

			Creator.AddSignal(NavButton.MouseEnter, function()
				if SelectedSubTab ~= CurrentIndex then
					Tween(
						LabelText,
						0.14,
						{ TextTransparency = 0.1 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()

					if IconImage then
						Tween(
							IconImage,
							0.14,
							{ ImageTransparency = 0.1 },
							Enum.EasingStyle.Quint,
							Enum.EasingDirection.Out
						):Play()
					end
				end
			end)

			Creator.AddSignal(NavButton.MouseLeave, function()
				if SelectedSubTab ~= CurrentIndex then
					Tween(
						LabelText,
						0.14,
						{ TextTransparency = 0.22 },
						Enum.EasingStyle.Quint,
						Enum.EasingDirection.Out
					):Play()

					if IconImage then
						Tween(
							IconImage,
							0.14,
							{ ImageTransparency = 0.22 },
							Enum.EasingStyle.Quint,
							Enum.EasingDirection.Out
						):Play()
					end
				end
			end)

			table.insert(SubTabs, {
				Page = PageFrame,
				Button = NavButton,
				Icon = IconImage,
				Label = LabelText,
			})

			UpdateBarSize()

			ElementsModule.Load(
				SubTabObject,
				PageFrame,
				ElementsModule.Elements,
				Window,
				WindUI,
				nil,
				ElementsModule,
				UIScale
			)

			if isFirstTab then
				SetSubTab(1, true)
			else
				SetSubTab(SelectedSubTab, true)
			end

			return SubTabObject
		end

		return SubGroupModule
	end

	function Tab:LockAll()
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Lock then
				element:Lock()
			end
		end
	end
	function Tab:UnlockAll()
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Unlock then
				element:Unlock()
			end
		end
	end
	function Tab:GetLocked()
		local LockedElements = {}
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == true then
				table.insert(LockedElements, element)
			end
		end
		return LockedElements
	end
	function Tab:GetUnlocked()
		local UnlockedElements = {}
		for _, element in next, Window.AllElements do
			if element.Tab and element.Tab.Index and element.Tab.Index == Tab.Index and element.Locked == false then
				table.insert(UnlockedElements, element)
			end
		end
		return UnlockedElements
	end

	function Tab:Select()
		return TabModule:SelectTab(Tab.Index)
	end

	task.spawn(function()
		local EmptyPageIcon
		if Tab.CustomEmptyPage.Icon then
			EmptyPageIcon =
				Creator.Image(Tab.CustomEmptyPage.Icon, Tab.CustomEmptyPage.Icon, 0, "Temp", "EmptyPage", true)
			EmptyPageIcon.Size =
				UDim2.fromOffset(Tab.CustomEmptyPage.IconSize or 48, Tab.CustomEmptyPage.IconSize or 48)
		end

		local Empty = New("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, -Window.UIElements.Main.Main.Topbar.AbsoluteSize.Y),
			Parent = Tab.UIElements.ContainerFrame,
		}, {
			New("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = "LayoutOrder",
				VerticalAlignment = "Center",
				HorizontalAlignment = "Center",
				FillDirection = "Vertical",
			}),
			EmptyPageIcon,
			Tab.CustomEmptyPage.Title
					and New("TextLabel", {
						AutomaticSize = "XY",
						Text = Tab.CustomEmptyPage.Title,
						ThemeTag = {
							TextColor3 = "Text",
						},
						TextSize = 18,
						TextTransparency = 0.5,
						BackgroundTransparency = 1,
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
					})
				or nil,
			Tab.CustomEmptyPage.Desc
					and New("TextLabel", {
						AutomaticSize = "XY",
						Text = Tab.CustomEmptyPage.Desc,
						ThemeTag = {
							TextColor3 = "Text",
						},
						TextSize = 15,
						TextTransparency = 0.65,
						BackgroundTransparency = 1,
						FontFace = Font.new(Creator.Font, Enum.FontWeight.Regular),
					})
				or nil,
		})

		local CreationConn
		CreationConn = Creator.AddSignal(Tab.UIElements.ContainerFrame.ChildAdded, function()
			Empty.Visible = false
			CreationConn:Disconnect()
		end)
	end)

	return Tab
end

function TabModule:OnChange(func)
	TabModule.OnChangeFunc = func
end

function TabModule:SelectTab(TabIndex)
	local SelectedTab = TabModule.Tabs[TabIndex]
	local SelectedContainer = TabModule.Containers[TabIndex]

	if not SelectedTab or not SelectedContainer or SelectedTab.Locked then
		return
	end

	TabModule.SelectedTab = TabIndex

	for _, TabObject in next, TabModule.Tabs do
		if not TabObject.Locked then
			Creator.SetThemeTag(TabObject.UIElements.Main, {
				ImageTransparency = "TabBorderTransparency",
			}, 0.15)
			if TabObject.Border then
				Creator.SetThemeTag(TabObject.UIElements.Main.Outline, {
					ImageTransparency = "TabBorderTransparency",
				}, 0.15)
			end
			Creator.SetThemeTag(TabObject.UIElements.Main.Frame.TextLabel, {
				TextTransparency = "TabTextTransparency",
			}, 0.15)
			if TabObject.UIElements.Icon and not TabObject.IconColor then
				Creator.SetThemeTag(TabObject.UIElements.Icon.ImageLabel, {
					ImageTransparency = "TabIconTransparency",
				}, 0.15)
			end
			TabObject.Selected = false
		end
	end

	Creator.SetThemeTag(SelectedTab.UIElements.Main, {
		ImageTransparency = "TabBackgroundActiveTransparency",
	}, 0.15)
	if SelectedTab.Border then
		Creator.SetThemeTag(SelectedTab.UIElements.Main.Outline, {
			ImageTransparency = "TabBorderTransparencyActive",
		}, 0.15)
	end
	Creator.SetThemeTag(SelectedTab.UIElements.Main.Frame.TextLabel, {
		TextTransparency = "TabTextTransparencyActive",
	}, 0.15)
	if SelectedTab.UIElements.Icon and not SelectedTab.IconColor then
		Creator.SetThemeTag(SelectedTab.UIElements.Icon.ImageLabel, {
			ImageTransparency = "TabIconTransparencyActive",
		}, 0.15)
	end
	SelectedTab.Selected = true

	task.spawn(function()
		for _, ContainerObject in next, TabModule.Containers do
			ContainerObject.AnchorPoint = Vector2.new(0, 0.05)
			ContainerObject.Visible = false
		end
		SelectedContainer.Visible = true
		local TweenService = game:GetService("TweenService")

		local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local tween = TweenService:Create(SelectedContainer, tweenInfo, {
			AnchorPoint = Vector2.new(0, 0),
		})
		tween:Play()
	end)

	TabModule.OnChangeFunc(TabIndex)
end

return TabModule
