local Toggle = {}

local Creator = require("../../modules/Creator")
local New = Creator.New
local Tween = Creator.Tween

local UserInputService = game:GetService("UserInputService")

local function Disconnect(conn)
	if conn then
		conn:Disconnect()
		return nil
	end
	return nil
end

function Toggle.New(Value, Icon, IconSize, Parent, Callback, NewElement, Config)
	local Toggle = {
		Value = Value == true,
	}

	local Radius = 12
	local ParsedIcon = (Icon and Icon ~= "") and Creator.Icon(Icon) or nil
	local FinalIconSize = IconSize or 13
	local IconToggleFrame

	if ParsedIcon then
		IconToggleFrame = New("ImageLabel", {
			Size = UDim2.new(0, FinalIconSize, 0, FinalIconSize),
			BackgroundTransparency = 1,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.new(0.5, 0, 0.5, 0),
			Image = ParsedIcon[1],
			ImageRectOffset = ParsedIcon[2].ImageRectPosition,
			ImageRectSize = ParsedIcon[2].ImageRectSize,
			ImageTransparency = 1,
			ImageColor3 = Color3.new(0, 0, 0),
			ZIndex = 4,
		})
	end

	local ToggleWidth = NewElement and 48 or 40
	local ToggleHeight = 24
	local FrameWidth = NewElement and 22 or 18
	local FrameHeight = 20
	local LeftOffset = 2
	local RightOffset = ToggleWidth - FrameWidth - 2

	local ToggleContainer = New("Frame", {
		Size = UDim2.new(0, ToggleWidth, 0, ToggleHeight),
		BackgroundTransparency = 1,
		Parent = Parent,
	})

	local ToggleFrame = Creator.NewRoundFrame(Radius, "Squircle", {
		ImageTransparency = 0.88,
		ThemeTag = {
			ImageColor3 = "Text",
		},
		Parent = ToggleContainer,
		Size = UDim2.new(1, 0, 1, 0),
		AnchorPoint = Vector2.new(0, 0),
		Position = UDim2.new(0, 0, 0, 0),
	}, {
		Creator.NewRoundFrame(Radius, "Squircle", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Layer",
			ThemeTag = {
				ImageColor3 = "Accent",
			},
			ImageTransparency = 1,
		}),
		Creator.NewRoundFrame(Radius, "SquircleOutline", {
			Size = UDim2.new(1, 0, 1, 0),
			Name = "Stroke",
			ImageColor3 = Color3.new(1, 1, 1),
			ImageTransparency = 0.82,
		}, {
			New("UIGradient", {
				Rotation = 90,
				Transparency = NumberSequence.new({
					NumberSequenceKeypoint.new(0, 0.15),
					NumberSequenceKeypoint.new(1, 1),
				}),
			}),
		}),
		Creator.NewRoundFrame(999, "Squircle", {
			Size = UDim2.new(0, 8, 0, 8),
			Position = UDim2.new(1, -12, 0.5, 0),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Name = "OffDot",
			ThemeTag = {
				ImageColor3 = "Text",
			},
			ImageTransparency = 0.35,
			ZIndex = 3,
		}),
		Creator.NewRoundFrame(Radius, "Squircle", {
			Size = UDim2.new(0, FrameWidth, 0, FrameHeight),
			Position = UDim2.new(0, LeftOffset, 0.5, 0),
			AnchorPoint = Vector2.new(0, 0.5),
			ImageTransparency = 1,
			Name = "Frame",
		}, {
			Creator.NewRoundFrame(Radius + 6, "Squircle", {
				Size = UDim2.new(1, 10, 1, 10),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Name = "Glow",
				ThemeTag = {
					ImageColor3 = "Accent",
				},
				ImageTransparency = 1,
				ZIndex = 1,
			}),
			Creator.NewRoundFrame(Radius, "Squircle", {
				Size = UDim2.new(1, 0, 1, 0),
				ImageTransparency = 0,
				ThemeTag = {
					ImageColor3 = "ToggleBar",
				},
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Name = "Bar",
				ZIndex = 3,
			}, {
				Creator.NewRoundFrame(Radius, "Glass-1", {
					Size = UDim2.new(1, 0, 1, 0),
					ImageColor3 = Color3.new(1, 1, 1),
					Name = "Highlight",
					ImageTransparency = 0.45,
					ZIndex = 4,
				}),
				IconToggleFrame,
				New("UIScale", {
					Scale = 1,
				}),
			}),
		}),
	})

	local dragConnection
	local endConnection
	local pulseToken = 0

	local function PlayPulse()
		pulseToken += 1
		local currentToken = pulseToken

		Tween(ToggleFrame.Frame.Bar.UIScale, 0.12, {
			Scale = 1.08,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		local glowGrow = Tween(ToggleFrame.Frame.Glow, 0.12, {
			Size = UDim2.new(1, 16, 1, 16),
			ImageTransparency = 0.62,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		glowGrow:Play()

		task.delay(0.13, function()
			if currentToken ~= pulseToken then
				return
			end

			Tween(ToggleFrame.Frame.Bar.UIScale, 0.18, {
				Scale = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(ToggleFrame.Frame.Glow, 0.2, {
				Size = UDim2.new(1, 10, 1, 10),
				ImageTransparency = 0.76,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end)
	end

	function Toggle:Set(Toggled, isCallback, isAnim)
		Toggle.Value = Toggled == true
		isCallback = isCallback ~= false

		if not isAnim then
			Tween(ToggleFrame.Frame, 0.16, {
				Position = UDim2.new(0, Toggle.Value and RightOffset or LeftOffset, 0.5, 0),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		else
			ToggleFrame.Frame.Position = UDim2.new(0, Toggle.Value and RightOffset or LeftOffset, 0.5, 0)
		end

		if Toggle.Value then
			Tween(ToggleFrame.Layer, 0.14, {
				ImageTransparency = 0.3,
			}):Play()

			Tween(ToggleFrame.Stroke, 0.14, {
				ImageTransparency = 0.68,
			}):Play()

			Tween(ToggleFrame.OffDot, 0.12, {
				ImageTransparency = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if IconToggleFrame then
				Tween(IconToggleFrame, 0.1, {
					ImageTransparency = 0,
				}):Play()
			end

			if isAnim then
				ToggleFrame.Frame.Glow.ImageTransparency = 0.76
				ToggleFrame.Frame.Glow.Size = UDim2.new(1, 10, 1, 10)
			else
				PlayPulse()
			end
		else
			pulseToken += 1

			Tween(ToggleFrame.Layer, 0.14, {
				ImageTransparency = 1,
			}):Play()

			Tween(ToggleFrame.Stroke, 0.14, {
				ImageTransparency = 0.82,
			}):Play()

			Tween(ToggleFrame.OffDot, 0.12, {
				ImageTransparency = 0.35,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			if IconToggleFrame then
				Tween(IconToggleFrame, 0.1, {
					ImageTransparency = 1,
				}):Play()
			end

			Tween(ToggleFrame.Frame.Glow, 0.18, {
				ImageTransparency = 1,
				Size = UDim2.new(1, 6, 1, 6),
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

			Tween(ToggleFrame.Frame.Bar.UIScale, 0.18, {
				Scale = 1,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end

		task.spawn(function()
			if Callback and isCallback then
				Creator.SafeCallback(Callback, Toggle.Value)
			end
		end)
	end

	function Toggle:Animate(input, ToggleObj)
		if not Config or not Config.Window or Config.Window.IsToggleDragging then
			return
		end

		Config.Window.IsToggleDragging = true

		local startMouseX = input.Position.X
		local startMouseY = input.Position.Y
		local startFrameX = ToggleFrame.Frame.Position.X.Offset
		local isScrolling = false

		Tween(ToggleFrame.Frame.Bar.UIScale, 0.18, {
			Scale = 1.08,
		}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

		if ToggleObj.Value then
			Tween(ToggleFrame.Frame.Glow, 0.18, {
				ImageTransparency = 0.68,
			}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
		end

		dragConnection = Disconnect(dragConnection)

		dragConnection = UserInputService.InputChanged:Connect(function(inputChanged)
			if
				Config.Window.IsToggleDragging
				and (inputChanged.UserInputType == Enum.UserInputType.MouseMovement
					or inputChanged.UserInputType == Enum.UserInputType.Touch)
			then
				if isScrolling then
					return
				end

				local deltaX = math.abs(inputChanged.Position.X - startMouseX)
				local deltaY = math.abs(inputChanged.Position.Y - startMouseY)

				if deltaY > deltaX and deltaY > 10 then
					isScrolling = true
					Config.Window.IsToggleDragging = false

					dragConnection = Disconnect(dragConnection)
					endConnection = Disconnect(endConnection)

					Tween(ToggleFrame.Frame, 0.15, {
						Position = UDim2.new(0, startFrameX, 0.5, 0),
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

					Tween(ToggleFrame.Frame.Bar.UIScale, 0.18, {
						Scale = 1,
					}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()

					return
				end

				local mouseDelta = inputChanged.Position.X - startMouseX
				local newX = math.max(LeftOffset, math.min(startFrameX + mouseDelta, RightOffset))

				Tween(ToggleFrame.Frame, 0.05, {
					Position = UDim2.new(0, newX, 0.5, 0),
				}, Enum.EasingStyle.Linear, Enum.EasingDirection.Out):Play()
			end
		end)

		endConnection = Disconnect(endConnection)

		endConnection = UserInputService.InputEnded:Connect(function(inputEnded)
			if
				Config.Window.IsToggleDragging
				and (inputEnded.UserInputType == Enum.UserInputType.MouseButton1
					or inputEnded.UserInputType == Enum.UserInputType.Touch)
			then
				Config.Window.IsToggleDragging = false

				dragConnection = Disconnect(dragConnection)
				endConnection = Disconnect(endConnection)

				if isScrolling then
					return
				end

				local currentX = ToggleFrame.Frame.Position.X.Offset
				local delta = math.abs(inputEnded.Position.X - startMouseX)

				if delta < 10 then
					ToggleObj:Set(not ToggleObj.Value, true, false)
				else
					local barCenter = currentX + (FrameWidth / 2)
					local toggleCenter = ToggleWidth / 2
					ToggleObj:Set(barCenter > toggleCenter, true, false)
				end

				Tween(ToggleFrame.Frame.Bar.UIScale, 0.18, {
					Scale = 1,
				}, Enum.EasingStyle.Quint, Enum.EasingDirection.Out):Play()
			end
		end)
	end

	return ToggleContainer, Toggle
end

return Toggle
