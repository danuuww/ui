local Creator = require("../../modules/Creator")
local New = Creator.New
local NewRoundFrame = Creator.NewRoundFrame
local Tween = Creator.Tween

local function Color3ToHSB(color)
	local r, g, b = color.R, color.G, color.B
	local max = math.max(r, g, b)
	local min = math.min(r, g, b)
	local delta = max - min

	local h = 0
	if delta ~= 0 then
		if max == r then
			h = (g - b) / delta % 6
		elseif max == g then
			h = (b - r) / delta + 2
		else
			h = (r - g) / delta + 4
		end
		h = h * 60
	end

	local s = (max == 0) and 0 or (delta / max)
	local v = max

	return {
		h = math.floor(h + 0.5),
		s = s,
		b = v,
	}
end

local function GetPerceivedBrightness(color)
	local r = color.R
	local g = color.G
	local b = color.B
	return 0.299 * r + 0.587 * g + 0.114 * b
end

local function GetTextColorForHSB(color)
	local hsb = Color3ToHSB(color)
	local h = hsb.h

	if GetPerceivedBrightness(color) > 0.5 then
		return Color3.fromHSV(h / 360, 0, 0.05)
	else
		return Color3.fromHSV(h / 360, 0, 0.98)
	end
end

local function getElementPosition(elements, targetIndex)
	if type(targetIndex) ~= "number" or targetIndex ~= math.floor(targetIndex) then
		return nil, 1
	end

	local maxIndex = #elements
	if maxIndex == 0 or targetIndex < 1 or targetIndex > maxIndex then
		return nil, 2
	end

	local function isDelimiter(el)
		if el == nil then
			return true
		end

		local t = el.__type
		return t == "Divider" or t == "Space" or t == "Section" or t == "Code"
	end

	if isDelimiter(elements[targetIndex]) then
		return nil, 3
	end

	local function calculate(pos, size)
		if size == 1 then
			return "Squircle"
		end
		if pos == 1 then
			return "Squircle-TL-TR"
		end
		if pos == size then
			return "Squircle-BL-BR"
		end
		return "Square"
	end

	local groupStart = 1
	local groupCount = 0

	for i = 1, maxIndex do
		local el = elements[i]
		if isDelimiter(el) then
			if targetIndex >= groupStart and targetIndex <= i - 1 then
				local pos = targetIndex - groupStart + 1
				return calculate(pos, groupCount)
			end
			groupStart = i + 1
			groupCount = 0
		else
			groupCount = groupCount + 1
		end
	end

	if targetIndex >= groupStart and targetIndex <= maxIndex then
		local pos = targetIndex - groupStart + 1
		return calculate(pos, groupCount)
	end

	return nil, 4
end

return function(Config)
	local Element = {
		Title = Config.Title,
		Desc = Config.Desc or nil,
		Hover = Config.Hover,
		Thumbnail = Config.Thumbnail,
		ThumbnailSize = Config.ThumbnailSize or 80,
		Image = Config.Image,
		IconThemed = Config.IconThemed or false,
		IconAlign = Config.IconAlign or "Left",
		ImageSize = Config.ImageSize or 30,
		Color = Config.Color,
		Scalable = Config.Scalable,
		Parent = Config.Parent,
		Justify = Config.Justify or "Between",
		UIPadding = Config.Window.ElementConfig.UIPadding,
		UICorner = Config.Window.ElementConfig.UICorner,
		Size = Config.Size or "Default",
		UIElements = {},
		Index = Config.Index,

		ListRow = Config.ListRow == true,
		ExpandableDesc = Config.ExpandableDesc or false,
		DescExpanded = Config.DescExpanded or false,
		ShowChevron = Config.ShowChevron or false,
		RightSlotWidth = Config.RightSlotWidth or 0,
		DividerLeftInset = Config.DividerLeftInset,
		DividerRightInset = Config.DividerRightInset,
	}

	local UseListRow = Element.ListRow
	local AddPaddingX = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0
	local AddPaddingY = Element.Size == "Small" and -4 or Element.Size == "Large" and 4 or 0

	local ImageSize = Element.ImageSize
	local ThumbnailSize = Element.ThumbnailSize
	local CanHover = true
	local IconOffset = 0
	local HasDesc = Element.Desc ~= nil and Element.Desc ~= ""

	local ThumbnailFrame
	local ImageFrame

	if Element.Thumbnail then
		ThumbnailFrame = Creator.Image(
			Element.Thumbnail,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Thumbnail",
			false,
			Element.IconThemed
		)
		ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
	end

	if Element.Image then
		ImageFrame = Creator.Image(
			Element.Image,
			Element.Title,
			Config.Window.NewElements and Element.UICorner - 11 or (Element.UICorner - 4),
			Config.Window.Folder,
			"Image",
			Element.IconThemed,
			not Element.Color and true or false,
			"ElementIcon"
		)

		if typeof(Element.Color) == "string" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
		elseif typeof(Element.Color) == "Color3" and not string.find(Element.Image, "rbxthumb") then
			ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
		end

		ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
		IconOffset = ImageSize
	end

	local function CreateText(TextValue, Type)
		local TextColor = typeof(Element.Color) == "string"
				and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
			or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)

		return New("TextLabel", {
			BackgroundTransparency = 1,
			Text = TextValue or "",
			TextSize = Type == "Desc" and 15 or 17,
			TextXAlignment = "Left",
			TextYAlignment = Type == "Desc" and "Top" or "Center",
			ThemeTag = {
				TextColor3 = not Element.Color and ("Element" .. Type) or nil,
			},
			TextColor3 = Element.Color and TextColor or nil,
			TextTransparency = Type == "Desc" and 0.3 or 0,
			TextWrapped = Type == "Desc",
			TextTruncate = Type == "Desc" and Enum.TextTruncate.None or Enum.TextTruncate.AtEnd,
			Size = Element.Justify == "Between" and UDim2.new(1, 0, 0, 0) or UDim2.new(0, 0, 0, 0),
			AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
			FontFace = Font.new(Creator.Font, Type == "Desc" and Enum.FontWeight.Medium or Enum.FontWeight.SemiBold),
		})
	end

	local Title = CreateText(Element.Title, "Title")
	local Desc = CreateText(Element.Desc, "Desc")

	if not Element.Title or Element.Title == "" then
		Title.Visible = false
	end

	Desc.Visible = HasDesc
	Desc.AutomaticSize = "Y"
	Desc.Size = UDim2.new(1, 0, 0, 0)

	local DescInner = New("Frame", {
		Name = "DescInner",
		BackgroundTransparency = 1,
		AutomaticSize = "Y",
		Size = UDim2.new(1, 0, 0, 0),
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, 4),
		}),
		Desc,
	})

	local DescHolder = New("Frame", {
		Name = "DescHolder",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Visible = false,
		Size = UDim2.new(1, 0, 0, 0),
	}, {
		DescInner,
	})

	local TextList = New("UIListLayout", {
		Padding = UDim.new(0, 0),
		FillDirection = "Vertical",
		VerticalAlignment = "Top",
		HorizontalAlignment = "Left",
	})

	local TextContent = New("Frame", {
		Name = "TextContent",
		LayoutOrder = Element.IconAlign == "Right" and 1 or 2,
		BackgroundTransparency = 1,
		AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
		Size = UDim2.new(
			Element.Justify == "Between" and 1 or 0,
			Element.Justify == "Between" and (ImageFrame and -IconOffset - Element.UIPadding or -IconOffset) or 0,
			1,
			0
		),
	}, {
		New("UIPadding", {
			PaddingTop = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY),
			PaddingLeft = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX),
			PaddingRight = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingX),
			PaddingBottom = UDim.new(0, (Config.Window.NewElements and Element.UIPadding / 2 or 0) + AddPaddingY),
		}),
		TextList,
		Title,
		DescHolder,
	})

	local ImageWrap = New("Frame", {
		Name = "ImageWrap",
		LayoutOrder = Element.IconAlign == "Right" and 2 or 1,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, ImageFrame and ImageSize or 0, 0, 24),
		Visible = ImageFrame ~= nil,
	}, {
		ImageFrame and New("Frame", {
			Name = "IconCenter",
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
		}, {
			ImageFrame,
		}) or nil,
	})

	if ImageFrame then
		ImageFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ImageFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	end

	local RowFrame = New("Frame", {
		Name = "TitleFrame",
		BackgroundTransparency = 1,
		Size = UDim2.new(
			Element.Justify == "Between" and 1 or 0,
			Element.Justify == "Between" and -Config.TextOffset or 0,
			0,
			0
		),
		AutomaticSize = Element.Justify == "Between" and "Y" or "XY",
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, ImageFrame and Element.UIPadding or 0),
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = Element.Justify ~= "Between" and Element.Justify or "Left",
		}),
		ImageWrap,
		TextContent,
	})

	Element.UIElements.Title = Title
	Element.UIElements.Desc = Desc
	Element.UIElements.DescHolder = DescHolder
	Element.UIElements.TextContent = TextContent
	Element.UIElements.RowFrame = RowFrame
	Element.UIElements.ImageWrap = ImageWrap

	Element.UIElements.Container = New("Frame", {
		Name = "Container",
		Size = UDim2.new(1, 0, 0, 32),
		AutomaticSize = "Y",
		BackgroundTransparency = 1,
	}, {
		New("UIListLayout", {
			Padding = UDim.new(0, Element.UIPadding),
			FillDirection = "Vertical",
			VerticalAlignment = "Center",
			HorizontalAlignment = Element.Justify == "Between" and "Left" or "Center",
		}),
		ThumbnailFrame,
		RowFrame,
	})

	local LockedIcon = Creator.Image("lock", "lock", 0, Config.Window.Folder, "Lock", false)
	LockedIcon.Size = UDim2.new(0, 20, 0, 20)
	LockedIcon.ImageLabel.ImageColor3 = Color3.new(1, 1, 1)
	LockedIcon.ImageLabel.ImageTransparency = 0.4

	local LockedTitle = New("TextLabel", {
		Text = "Locked",
		TextSize = 18,
		FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
		AutomaticSize = "XY",
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.05,
	})

	local ElementFullFrame = New("Frame", {
		Size = UDim2.new(1, Element.UIPadding * 2, 1, Element.UIPadding * 2),
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		ZIndex = 9999999,
	})

	local Locked, LockedTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 0.25,
		ImageColor3 = Color3.new(0, 0, 0),
		Visible = false,
		Active = false,
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		LockedIcon,
		LockedTitle,
	}, nil, true)

	local HighlightOutline, HighlightOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local Highlight, HighlightTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local HoverOutline, HoverOutlineTable = NewRoundFrame(Element.UICorner, "Squircle-Outline", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
	}, nil, true)

	local Hover, HoverTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 1, 0),
		ImageTransparency = 1,
		Active = false,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ElementFullFrame,
	}, {
		New("UIGradient", {
			Name = "HoverGradient",
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.25, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.75, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
		}),
		New("UIListLayout", {
			FillDirection = "Horizontal",
			VerticalAlignment = "Center",
			HorizontalAlignment = "Center",
			Padding = UDim.new(0, 8),
		}),
	}, nil, true)

	local Main, MainTable = NewRoundFrame(Element.UICorner, "Squircle", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = "Y",
		ImageTransparency = Element.Color and 0.05 or 0.93,
		Parent = Config.Parent,
		ThemeTag = {
			ImageColor3 = not Element.Color and "ElementBackground" or nil,
		},
		ImageColor3 = Element.Color and (
			typeof(Element.Color) == "string" and Color3.fromHex(Creator.Colors[Element.Color])
			or typeof(Element.Color) == "Color3" and Element.Color
		) or nil,
	}, {
		Element.UIElements.Container,
		ElementFullFrame,
		New("UIPadding", {
			PaddingTop = UDim.new(0, Element.UIPadding),
			PaddingLeft = UDim.new(0, Element.UIPadding),
			PaddingRight = UDim.new(0, Element.UIPadding),
			PaddingBottom = UDim.new(0, Element.UIPadding),
		}),
	}, true, true)

	Element.UIElements.Main = Main
	Element.UIElements.Locked = Locked

	local RightSlot
	local ChevronWrap
	local ChevronButton
	local ChevronIcon
	local Divider

	if UseListRow then
		RightSlot = New("Frame", {
			Name = "RightSlot",
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, 0, 0.5, 0),
			Size = UDim2.new(0, math.max(Element.RightSlotWidth, Element.ShowChevron and 24 or 0), 0, 36),
			AutomaticSize = "X",
			Parent = Main,
		}, {
			New("UIListLayout", {
				FillDirection = "Horizontal",
				HorizontalAlignment = "Right",
				VerticalAlignment = "Center",
				Padding = UDim.new(0, 10),
			}),
		})

		if Element.ShowChevron then
			ChevronWrap = New("Frame", {
				Name = "ChevronWrap",
				Size = UDim2.new(0, 24, 0, 24),
				BackgroundTransparency = 1,
				LayoutOrder = 999,
				Parent = RightSlot,
			})

			ChevronButton = New("TextButton", {
				Name = "ChevronButton",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				AutoButtonColor = false,
				Parent = ChevronWrap,
			})

			ChevronIcon = New("TextLabel", {
				Name = "ChevronIcon",
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "›",
				TextSize = 24,
				TextTransparency = 0.25,
				FontFace = Font.new(Creator.Font, Enum.FontWeight.Medium),
				TextXAlignment = "Center",
				TextYAlignment = "Center",
				ThemeTag = {
					TextColor3 = "Text",
				},
				Parent = ChevronButton,
			})
		end

		Divider = New("Frame", {
			Name = "Divider",
			BackgroundTransparency = 0.88,
			ThemeTag = {
				BackgroundColor3 = "Text",
			},
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 1, 0),
			Size = UDim2.new(1, 0, 0, 1),
			Visible = false,
			Parent = Main,
			ZIndex = 3,
		}, {
			New("UICorner", {
				CornerRadius = UDim.new(0, 999),
			}),
		})
	end

	Element.UIElements.RightSlot = RightSlot
	Element.UIElements.ChevronWrap = ChevronWrap
	Element.UIElements.ChevronButton = ChevronButton
	Element.UIElements.ChevronIcon = ChevronIcon
	Element.UIElements.Divider = Divider

	local function GetDescTargetHeight()
		local y = math.max(DescInner.AbsoluteSize.Y, Desc.TextBounds.Y + 8)
		if y <= 0 then
			y = 18
		end
		return y
	end

	local function RefreshDivider()
		if not UseListRow or not Divider or not Main or not Title then
			return
		end

		local mainPos = Main.AbsolutePosition
		local mainSize = Main.AbsoluteSize

		if mainSize.X <= 0 then
			return
		end

		local leftInset
		if Element.DividerLeftInset then
			leftInset = Element.DividerLeftInset
		else
			leftInset = math.floor(math.max(Title.AbsolutePosition.X - mainPos.X, 18))
		end

		local endX = mainSize.X - Element.UIPadding
		
		if Element.DividerRightInset then
			endX = mainSize.X - Element.DividerRightInset
		end

		local width = math.max(endX - leftInset, 24)

		Divider.Position = UDim2.new(0, leftInset, 1, Element.UIPadding)
		Divider.Size = UDim2.new(0, width, 0, 1)
	end

	if HasDesc then
		if Element.ExpandableDesc then
			DescHolder.Visible = Element.DescExpanded
			DescHolder.Size = UDim2.new(1, 0, 0, Element.DescExpanded and GetDescTargetHeight() or 0)
		else
			DescHolder.Visible = true
			DescHolder.Size = UDim2.new(1, 0, 0, GetDescTargetHeight())
		end
	else
		DescHolder.Visible = false
		DescHolder.Size = UDim2.new(1, 0, 0, 0)
	end

	function Element:SetExpanded(State, Instant)
		if not Element.ExpandableDesc or not HasDesc then
			return
		end

		Element.DescExpanded = State == true

		if Element.DescExpanded then
			DescHolder.Visible = true
			local targetHeight = GetDescTargetHeight()

			if Instant then
				DescHolder.Size = UDim2.new(1, 0, 0, targetHeight)
				if ChevronIcon then
					ChevronIcon.Rotation = 90
				end
			else
				Tween(DescHolder, 0.20, {
					Size = UDim2.new(1, 0, 0, targetHeight),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

				if ChevronIcon then
					Tween(ChevronIcon, 0.20, {
						Rotation = 90,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				end
			end
		else
			if Instant then
				DescHolder.Size = UDim2.new(1, 0, 0, 0)
				DescHolder.Visible = false
				if ChevronIcon then
					ChevronIcon.Rotation = 0
				end
			else
				Tween(DescHolder, 0.20, {
					Size = UDim2.new(1, 0, 0, 0),
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

				if ChevronIcon then
					Tween(ChevronIcon, 0.20, {
						Rotation = 0,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
				end

				task.delay(0.20, function()
					if not Element.DescExpanded then
						DescHolder.Visible = false
					end
				end)
			end
		end

		task.defer(RefreshDivider)
	end

	function Element:ToggleExpanded()
		Element:SetExpanded(not Element.DescExpanded, false)
	end

	if HasDesc and Element.ExpandableDesc then
		Element:SetExpanded(Element.DescExpanded, true)

		if ChevronButton then
			Creator.AddSignal(ChevronButton.MouseButton1Click, function()
				Element:ToggleExpanded()
			end)
		end
	end

	if UseListRow and RightSlot then
		Creator.AddSignal(Main:GetPropertyChangedSignal("AbsoluteSize"), function()
			task.defer(RefreshDivider)
		end)

		Creator.AddSignal(RightSlot:GetPropertyChangedSignal("AbsoluteSize"), function()
			task.defer(RefreshDivider)
		end)

		Creator.AddSignal(Title:GetPropertyChangedSignal("TextBounds"), function()
			task.defer(RefreshDivider)
		end)

		task.defer(RefreshDivider)
	end

	if Element.Hover then
		Creator.AddSignal(Main.MouseEnter, function()
			if CanHover then
				Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.15 or 0.9 }):Play()
				Tween(Hover, 0.12, { ImageTransparency = 0.9 }):Play()
				Tween(HoverOutline, 0.12, { ImageTransparency = 0.8 }):Play()

				Creator.AddSignal(Main.MouseMoved, function(x)
					Hover.HoverGradient.Offset =
						Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
					HoverOutline.HoverGradient.Offset =
						Vector2.new(((x - Main.AbsolutePosition.X) / Main.AbsoluteSize.X) - 0.5, 0)
				end)
			end
		end)

		Creator.AddSignal(Main.InputEnded, function()
			if CanHover then
				Tween(Main, 0.12, { ImageTransparency = Element.Color and 0.05 or 0.93 }):Play()
				Tween(Hover, 0.12, { ImageTransparency = 1 }):Play()
				Tween(HoverOutline, 0.12, { ImageTransparency = 1 }):Play()
			end
		end)
	end

	function Element:SetTitle(Text)
		Element.Title = Text
		Title.Text = Text
		task.defer(RefreshDivider)
	end

	function Element:SetDesc(Text)
		Element.Desc = Text
		Desc.Text = Text or ""
		HasDesc = Text ~= nil and Text ~= ""

		if not HasDesc then
			Desc.Visible = false
			DescHolder.Visible = false
			DescHolder.Size = UDim2.new(1, 0, 0, 0)
			if ChevronWrap then
				ChevronWrap.Visible = false
			end
		else
			Desc.Visible = true
			if ChevronWrap then
				ChevronWrap.Visible = true
			end

			if Element.ExpandableDesc then
				if Element.DescExpanded then
					Element:SetExpanded(true, true)
				else
					DescHolder.Visible = false
					DescHolder.Size = UDim2.new(1, 0, 0, 0)
				end
			else
				DescHolder.Visible = true
				DescHolder.Size = UDim2.new(1, 0, 0, GetDescTargetHeight())
			end
		end

		task.defer(RefreshDivider)
	end

	function Element:Colorize(obj, prop)
		if Element.Color then
			obj[prop] = typeof(Element.Color) == "string"
					and GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
				or typeof(Element.Color) == "Color3" and GetTextColorForHSB(Element.Color)
				or nil
		end
	end

	if Config.ElementTable then
		Creator.AddSignal(Title:GetPropertyChangedSignal("Text"), function()
			if Element.Title ~= Title.Text then
				Element:SetTitle(Title.Text)
				Config.ElementTable.Title = Title.Text
			end
		end)

		Creator.AddSignal(Desc:GetPropertyChangedSignal("Text"), function()
			if Element.Desc ~= Desc.Text then
				Element:SetDesc(Desc.Text)
				Config.ElementTable.Desc = Desc.Text
			end
		end)
	end

	function Element:SetThumbnail(NewThumbnail, NewSize)
		Element.Thumbnail = NewThumbnail
		if NewSize then
			Element.ThumbnailSize = NewSize
			ThumbnailSize = NewSize
		end

		if ThumbnailFrame then
			if NewThumbnail then
				ThumbnailFrame:Destroy()
				ThumbnailFrame = Creator.Image(
					NewThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
				ThumbnailFrame.Parent = Element.UIElements.Container
				local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
				if layout then
					ThumbnailFrame.LayoutOrder = -1
				end
			else
				ThumbnailFrame.Visible = false
			end
		else
			if NewThumbnail then
				ThumbnailFrame = Creator.Image(
					NewThumbnail,
					Element.Title,
					Element.UICorner - 3,
					Config.Window.Folder,
					"Thumbnail",
					false,
					Element.IconThemed
				)
				ThumbnailFrame.Size = UDim2.new(1, 0, 0, ThumbnailSize)
				ThumbnailFrame.Parent = Element.UIElements.Container
				local layout = Element.UIElements.Container:FindFirstChild("UIListLayout")
				if layout then
					ThumbnailFrame.LayoutOrder = -1
				end
			end
		end

		task.defer(RefreshDivider)
	end

	function Element:SetImage(NewImage, NewSize)
		Element.Image = NewImage
		if NewSize then
			Element.ImageSize = NewSize
			ImageSize = NewSize
		end

		if NewImage then
			if ImageFrame then
				ImageFrame:Destroy()
			end

			ImageFrame = Creator.Image(
				NewImage,
				NewImage,
				Element.UICorner - 3,
				Config.Window.Folder,
				"Image",
				not Element.Color and true or false
			)

			if typeof(Element.Color) == "string" and not string.find(NewImage, "rbxthumb") then
				ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Color3.fromHex(Creator.Colors[Element.Color]))
			elseif typeof(Element.Color) == "Color3" and not string.find(NewImage, "rbxthumb") then
				ImageFrame.ImageLabel.ImageColor3 = GetTextColorForHSB(Element.Color)
			end

			ImageFrame.Size = UDim2.new(0, ImageSize, 0, ImageSize)
			ImageFrame.AnchorPoint = Vector2.new(0.5, 0.5)
			ImageFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
			ImageFrame.Parent = ImageWrap

			ImageWrap.Visible = true
			ImageWrap.Size = UDim2.new(0, ImageSize, 0, 24)
			IconOffset = ImageSize
		else
			if ImageFrame then
				ImageFrame.Visible = false
			end
			ImageWrap.Visible = false
			ImageWrap.Size = UDim2.new(0, 0, 0, 24)
			IconOffset = 0
		end

		TextContent.Size = UDim2.new(
			Element.Justify == "Between" and 1 or 0,
			Element.Justify == "Between" and (ImageWrap.Visible and -IconOffset - Element.UIPadding or 0) or 0,
			1,
			0
		)

		local layout = RowFrame:FindFirstChildOfClass("UIListLayout")
		if layout then
			layout.Padding = UDim.new(0, ImageWrap.Visible and Element.UIPadding or 0)
		end

		task.defer(RefreshDivider)
	end

	function Element:Destroy()
		Main:Destroy()
	end

	function Element:Lock(NewTitle)
		CanHover = false
		Locked.Active = true
		Locked.Visible = true
		LockedTitle.Text = NewTitle or "Locked"
	end

	function Element:Unlock()
		CanHover = true
		Locked.Active = false
		Locked.Visible = false
	end

	function Element:Highlight()
		local OutlineGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.1, 0.9),
				NumberSequenceKeypoint.new(0.5, 0.3),
				NumberSequenceKeypoint.new(0.9, 0.9),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = HighlightOutline,
		})

		local HighlightGradient = New("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(0.5, Color3.new(1, 1, 1)),
				ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)),
			}),
			Transparency = NumberSequence.new({
				NumberSequenceKeypoint.new(0, 1),
				NumberSequenceKeypoint.new(0.15, 0.8),
				NumberSequenceKeypoint.new(0.5, 0.1),
				NumberSequenceKeypoint.new(0.85, 0.8),
				NumberSequenceKeypoint.new(1, 1),
			}),
			Rotation = 0,
			Offset = Vector2.new(-1, 0),
			Parent = Highlight,
		})

		HighlightOutline.ImageTransparency = 0.65
		Highlight.ImageTransparency = 0.88

		Tween(OutlineGradient, 0.75, {
			Offset = Vector2.new(1, 0),
		}):Play()

		Tween(HighlightGradient, 0.75, {
			Offset = Vector2.new(1, 0),
		}):Play()

		task.spawn(function()
			task.wait(0.75)
			HighlightOutline.ImageTransparency = 1
			Highlight.ImageTransparency = 1
			OutlineGradient:Destroy()
			HighlightGradient:Destroy()
		end)
	end

	function Element.UpdateShape(Tab)
		if Config.Window.NewElements then
			local NewShape
			if Config.ParentConfig.ParentType == "Group" then
				NewShape = "Squircle"
			else
				NewShape = getElementPosition(Tab.Elements, Element.Index)
			end

			if NewShape and Main then
				MainTable:SetType(NewShape)
				LockedTable:SetType(NewShape)
				HighlightTable:SetType(NewShape)
				HighlightOutlineTable:SetType(NewShape .. "-Outline")
				HoverTable:SetType(NewShape)
				HoverOutlineTable:SetType(NewShape .. "-Outline")

				if UseListRow and Divider then
					Divider.Visible = (NewShape == "Square" or NewShape == "Squircle-TL-TR")
					task.defer(RefreshDivider)
				end
			end
		end
	end

	return Element
end
