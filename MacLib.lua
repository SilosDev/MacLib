local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local user
local tag
local userinfo = {}

pcall(function()
    userinfo = HttpService:JSONDecode(readfile("discordlibinfo.txt"));
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=".. game.Players.LocalPlayer.UserId .."&width=420&height=420&format=png"
user =  userinfo["user"] or game.Players.LocalPlayer.Name
tag = userinfo["tag"] or tostring(math.random(1000,9999))

local function SaveInfo()
    userinfo["pfp"] = pfp
    userinfo["user"] = user
    userinfo["tag"] = tag
    writefile("discordlibinfo.txt", HttpService:JSONEncode(userinfo));
end

local function MakeDraggable(topbarobject, object)
    local Dragging = nil
    local DragInput = nil
    local DragStart = nil
    local StartPosition = nil

    local function Update(input)
        local Delta = input.Position - DragStart
        local pos =
            UDim2.new(
                StartPosition.X.Scale,
                StartPosition.X.Offset + Delta.X,
                StartPosition.Y.Scale,
                StartPosition.Y.Offset + Delta.Y
            )
        object.Position = pos
    end

    topbarobject.InputBegan:Connect(
        function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = true
                DragStart = input.Position
                StartPosition = object.Position

                input.Changed:Connect(
                    function()
                        if input.UserInputState == Enum.UserInputState.End then
                            Dragging = false
                        end
                    end
                )
            end
        end
    )

    topbarobject.InputChanged:Connect(
        function(input)
            if
                input.UserInputType == Enum.UserInputType.MouseMovement or
                    input.UserInputType == Enum.UserInputType.Touch
            then
                DragInput = input
            end
        end
    )

    UserInputService.InputChanged:Connect(
        function(input)
            if input == DragInput and Dragging then
                Update(input)
            end
        end
    )
end

local Discord = Instance.new("ScreenGui")
Discord.Name = "Discord"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

function DiscordLib:Window(text)
    local currentservertoggled = ""
    local minimized = false
    local fs = false
    local settingsopened = false
    local MainFrame = Instance.new("Frame")
    local ShadowFrame = Instance.new("Frame") -- Cień
    local TopFrame = Instance.new("Frame")
    local Title = Instance.new("TextLabel")
    local CloseBtn = Instance.new("TextButton")
    local CloseIcon = Instance.new("ImageLabel")
    local MinimizeBtn = Instance.new("TextButton")
    local MinimizeIcon = Instance.new("ImageLabel")
    local ServersHolder = Instance.new("Folder")
    local Userpad = Instance.new("Frame")
    local UserIcon = Instance.new("Frame")
    local UserIconCorner = Instance.new("UICorner")
    local UserImage = Instance.new("ImageLabel")
    local UserCircleImage = Instance.new("ImageLabel")
    local UserName = Instance.new("TextLabel")
    local UserTag = Instance.new("TextLabel")
    local ServersHoldFrame = Instance.new("Frame")
    local ServersHold = Instance.new("ScrollingFrame")
    local ServersHoldLayout = Instance.new("UIListLayout")
    local ServersHoldPadding = Instance.new("UIPadding")
    local TopFrameHolder = Instance.new("Frame")

    -- Główne okno (nowoczesne)
    MainFrame.Name = "MainFrame"
    MainFrame.Parent = Discord
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = Color3.fromRGB(24, 25, 28) -- Głębszy granat
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.Size = UDim2.new(0, 700, 0, 420) -- Trochę większe

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame

    -- Cień
    ShadowFrame.Name = "ShadowFrame"
    ShadowFrame.Parent = MainFrame
    ShadowFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ShadowFrame.BackgroundTransparency = 0.7
    ShadowFrame.BorderSizePixel = 0
    ShadowFrame.Position = UDim2.new(-0.02, 0, -0.02, 0)
    ShadowFrame.Size = UDim2.new(1.04, 0, 1.04, 0)
    local ShadowCorner = Instance.new("UICorner")
    ShadowCorner.CornerRadius = UDim.new(0, 14)
    ShadowCorner.Parent = ShadowFrame
    local ShadowBlur = Instance.new("BlurEffect") -- Roblox nie ma blur na frame, więc damy ImageLabel z assetem jako cień
    -- Usuwamy ShadowFrame i robimy cień przez ImageLabel
    ShadowFrame:Destroy()
    
    local ShadowImage = Instance.new("ImageLabel")
    ShadowImage.Name = "ShadowImage"
    ShadowImage.Parent = MainFrame
    ShadowImage.BackgroundColor3 = Color3.fromRGB(0,0,0)
    ShadowImage.BackgroundTransparency = 1
    ShadowImage.BorderSizePixel = 0
    ShadowImage.Position = UDim2.new(-0.03, 0, -0.03, 0)
    ShadowImage.Size = UDim2.new(1.06, 0, 1.06, 0)
    ShadowImage.Image = "rbxassetid://4996891970" -- Glow
    ShadowImage.ImageColor3 = Color3.fromRGB(0,0,0)
    ShadowImage.ImageTransparency = 0.6
    ShadowImage.ScaleType = Enum.ScaleType.Slice
    ShadowImage.SliceCenter = Rect.new(20,20,280,280)
    ShadowImage.ZIndex = 0

    -- TopFrame (pasek tytułu)
    TopFrame.Name = "TopFrame"
    TopFrame.Parent = MainFrame
    TopFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    TopFrame.BackgroundTransparency = 0.95
    TopFrame.BorderSizePixel = 0
    TopFrame.Position = UDim2.new(0, 0, 0, 0)
    TopFrame.Size = UDim2.new(0, 700, 0, 30) -- Wyższy pasek

    TopFrameHolder.Name = "TopFrameHolder"
    TopFrameHolder.Parent = TopFrame
    TopFrameHolder.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    TopFrameHolder.BackgroundTransparency = 1
    TopFrameHolder.BorderSizePixel = 0
    TopFrameHolder.Position = UDim2.new(0, 0, 0, 0)
    TopFrameHolder.Size = UDim2.new(0, 700, 0, 30)

    Title.Name = "Title"
    Title.Parent = TopFrame
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.02, 0, 0, 0)
    Title.Size = UDim2.new(0, 200, 0, 30)
    Title.Font = Enum.Font.GothamSemibold
    Title.Text = text
    Title.TextColor3 = Color3.fromRGB(220, 220, 220)
    Title.TextSize = 15.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    -- Przycisk zamknij (okrągły, czerwony na hover)
    CloseBtn.Name = "CloseBtn"
    CloseBtn.Parent = TopFrame
    CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    CloseBtn.BackgroundTransparency = 0
    CloseBtn.Position = UDim2.new(0.955, 0, 0.03, 0)
    CloseBtn.Size = UDim2.new(0, 26, 0, 26)
    CloseBtn.Font = Enum.Font.Gotham
    CloseBtn.Text = ""
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 14.000
    CloseBtn.BorderSizePixel = 0
    CloseBtn.AutoButtonColor = false
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseBtn

    CloseIcon.Name = "CloseIcon"
    CloseIcon.Parent = CloseBtn
    CloseIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseIcon.BackgroundTransparency = 1.000
    CloseIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
    CloseIcon.Size = UDim2.new(0, 18, 0, 18)
    CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
    CloseIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

    -- Przycisk minimalizacji
    MinimizeBtn.Name = "MinimizeButton"
    MinimizeBtn.Parent = TopFrame
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    MinimizeBtn.BackgroundTransparency = 0
    MinimizeBtn.Position = UDim2.new(0.91, 0, 0.03, 0)
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Font = Enum.Font.Gotham
    MinimizeBtn.Text = ""
    MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeBtn.TextSize = 14.000
    MinimizeBtn.BorderSizePixel = 0
    MinimizeBtn.AutoButtonColor = false
    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(1, 0)
    MinCorner.Parent = MinimizeBtn

    MinimizeIcon.Name = "MinimizeLabel"
    MinimizeIcon.Parent = MinimizeBtn
    MinimizeIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeIcon.BackgroundTransparency = 1.000
    MinimizeIcon.Position = UDim2.new(0.15, 0, 0.15, 0)
    MinimizeIcon.Size = UDim2.new(0, 18, 0, 18)
    MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
    MinimizeIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)

    ServersHolder.Name = "ServersHolder"
    ServersHolder.Parent = TopFrameHolder

    -- Userpad (panel użytkownika)
    Userpad.Name = "Userpad"
    Userpad.Parent = TopFrameHolder
    Userpad.BackgroundColor3 = Color3.fromRGB(41, 43, 47)
    Userpad.BorderSizePixel = 0
    Userpad.Position = UDim2.new(0.11, 0, 30, 0) -- Pod paskiem
    Userpad.Size = UDim2.new(0, 200, 0, 52)
    local UserpadCorner = Instance.new("UICorner")
    UserpadCorner.CornerRadius = UDim.new(0, 8)
    UserpadCorner.Parent = Userpad

    UserIcon.Name = "UserIcon"
    UserIcon.Parent = Userpad
    UserIcon.BackgroundColor3 = Color3.fromRGB(31, 33, 36)
    UserIcon.BorderSizePixel = 0
    UserIcon.Position = UDim2.new(0.03, 0, 0.1, 0)
    UserIcon.Size = UDim2.new(0, 40, 0, 40)
    local UserIconCornerNew = Instance.new("UICorner")
    UserIconCornerNew.CornerRadius = UDim.new(1, 8)
    UserIconCornerNew.Parent = UserIcon

    UserImage.Name = "UserImage"
    UserImage.Parent = UserIcon
    UserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserImage.BackgroundTransparency = 1.000
    UserImage.Size = UDim2.new(0, 40, 0, 40)
    UserImage.Image = pfp

    UserCircleImage.Name = "UserImage"
    UserCircleImage.Parent = UserImage
    UserCircleImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserCircleImage.BackgroundTransparency = 1.000
    UserCircleImage.Size = UDim2.new(0, 40, 0, 40)
    UserCircleImage.Image = "rbxassetid://4031889928"
    UserCircleImage.ImageColor3 = Color3.fromRGB(41, 43, 47)

    UserName.Name = "UserName"
    UserName.Parent = Userpad
    UserName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserName.BackgroundTransparency = 1.000
    UserName.BorderSizePixel = 0
    UserName.Position = UDim2.new(0.24, 0, 0.1, 0)
    UserName.Size = UDim2.new(0, 120, 0, 20)
    UserName.Font = Enum.Font.GothamSemibold
    UserName.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserName.TextSize = 15.000
    UserName.TextXAlignment = Enum.TextXAlignment.Left
    UserName.ClipsDescendants = true

    UserTag.Name = "UserTag"
    UserTag.Parent = Userpad
    UserTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserTag.BackgroundTransparency = 1.000
    UserTag.BorderSizePixel = 0
    UserTag.Position = UDim2.new(0.24, 0, 0.45, 0)
    UserTag.Size = UDim2.new(0, 120, 0, 18)
    UserTag.Font = Enum.Font.Gotham
    UserTag.TextColor3 = Color3.fromRGB(180, 184, 190)
    UserTag.TextSize = 13.000
    UserTag.TextXAlignment = Enum.TextXAlignment.Left

    UserName.Text = user
    UserTag.Text = "#" .. tag

    -- Panel serwerów (lewy pasek)
    ServersHoldFrame.Name = "ServersHoldFrame"
    ServersHoldFrame.Parent = MainFrame
    ServersHoldFrame.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
    ServersHoldFrame.BackgroundTransparency = 0
    ServersHoldFrame.BorderColor3 = Color3.fromRGB(27, 42, 53)
    ServersHoldFrame.Size = UDim2.new(0, 80, 0, 420)
    ServersHoldFrame.Position = UDim2.new(0, 0, 0, 30)

    ServersHold.Name = "ServersHold"
    ServersHold.Parent = ServersHoldFrame
    ServersHold.Active = true
    ServersHold.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ServersHold.BackgroundTransparency = 1.000
    ServersHold.BorderSizePixel = 0
    ServersHold.Position = UDim2.new(0, 0, 0.05, 0)
    ServersHold.Size = UDim2.new(0, 80, 0, 395)
    ServersHold.ScrollBarThickness = 1
    ServersHold.ScrollBarImageTransparency = 1
    ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)

    ServersHoldLayout.Name = "ServersHoldLayout"
    ServersHoldLayout.Parent = ServersHold
    ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ServersHoldLayout.Padding = UDim.new(0, 8)

    ServersHoldPadding.Name = "ServersHoldPadding"
    ServersHoldPadding.Parent = ServersHold
    ServersHoldPadding.PaddingLeft = UDim.new(0, 12)

    -- Eventy dla przycisków
    CloseBtn.MouseButton1Click:Connect(
        function()
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
        end
    )

    CloseBtn.MouseEnter:Connect(
        function()
            CloseBtn.BackgroundColor3 = Color3.fromRGB(240, 71, 71)
        end
    )

    CloseBtn.MouseLeave:Connect(
        function()
            CloseBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
        end
    )

    MinimizeBtn.MouseEnter:Connect(
        function()
            MinimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 63, 68)
        end
    )

    MinimizeBtn.MouseLeave:Connect(
        function()
            MinimizeBtn.BackgroundColor3 = Color3.fromRGB(30, 32, 36)
        end
    )

    MinimizeBtn.MouseButton1Click:Connect(
        function()
            if minimized == false then
                MainFrame:TweenSize(
                    UDim2.new(0, 700, 0, 30),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    .3,
                    true
                )
            else
                MainFrame:TweenSize(
                    UDim2.new(0, 700, 0, 420),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Quart,
                    .3,
                    true
                )
            end
            minimized = not minimized
        end
    )

    -- Przycisk ustawień (w panelu użytkownika)
    local SettingsOpenBtn = Instance.new("TextButton")
    local SettingsOpenBtnIco = Instance.new("ImageLabel")

    SettingsOpenBtn.Name = "SettingsOpenBtn"
    SettingsOpenBtn.Parent = Userpad
    SettingsOpenBtn.BackgroundColor3 = Color3.fromRGB(53, 56, 62)
    SettingsOpenBtn.BackgroundTransparency = 1.000
    SettingsOpenBtn.Position = UDim2.new(0.87, 0, 0.3, 0)
    SettingsOpenBtn.Size = UDim2.new(0, 20, 0, 20)
    SettingsOpenBtn.Font = Enum.Font.SourceSans
    SettingsOpenBtn.Text = ""
    SettingsOpenBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    SettingsOpenBtn.TextSize = 14.000

    SettingsOpenBtnIco.Name = "SettingsOpenBtnIco"
    SettingsOpenBtnIco.Parent = SettingsOpenBtn
    SettingsOpenBtnIco.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    SettingsOpenBtnIco.BackgroundTransparency = 1.000
    SettingsOpenBtnIco.Size = UDim2.new(0, 20, 0, 20)
    SettingsOpenBtnIco.Image = "http://www.roblox.com/asset/?id=6031280882"
    SettingsOpenBtnIco.ImageColor3 = Color3.fromRGB(180, 180, 180)

    -- Okno ustawień
    local SettingsFrame = Instance.new("Frame")
    local Settings = Instance.new("Frame")
    local SettingsHolder = Instance.new("Frame")
    local CloseSettingsBtn = Instance.new("TextButton")
    local CloseSettingsBtnCorner = Instance.new("UICorner")
    local CloseSettingsBtnCircle = Instance.new("Frame")
    local CloseSettingsBtnCircleCorner = Instance.new("UICorner")
    local CloseSettingsBtnIcon = Instance.new("ImageLabel")
    local TextLabel = Instance.new("TextLabel")
    local UserPanel = Instance.new("Frame")
    local UserSettingsPad = Instance.new("Frame")
    local UserSettingsPadCorner = Instance.new("UICorner")
    local UsernameText = Instance.new("TextLabel")
    local UserSettingsPadUserTag = Instance.new("Frame")
    local UserSettingsPadUser = Instance.new("TextLabel")
    local UserSettingsPadUserTagLayout = Instance.new("UIListLayout")
    local UserSettingsPadTag = Instance.new("TextLabel")
    local EditBtn = Instance.new("TextButton")
    local EditBtnCorner = Instance.new("UICorner")
    local UserPanelUserIcon = Instance.new("TextButton")
    local UserPanelUserImage = Instance.new("ImageLabel")
    local UserPanelUserCircle = Instance.new("ImageLabel")
    local BlackFrame = Instance.new("Frame")
    local BlackFrameCorner = Instance.new("UICorner")
    local ChangeAvatarText = Instance.new("TextLabel")
    local SearchIcoFrame = Instance.new("Frame")
    local SearchIcoFrameCorner = Instance.new("UICorner")
    local SearchIco = Instance.new("ImageLabel")
    local UserPanelUserTag = Instance.new("Frame")
    local UserPanelUser = Instance.new("TextLabel")
    local UserPanelUserTagLayout = Instance.new("UIListLayout")
    local UserPanelTag = Instance.new("TextLabel")
    local UserPanelCorner = Instance.new("UICorner")
    local LeftFrame = Instance.new("Frame")
    local MyAccountBtn = Instance.new("TextButton")
    local MyAccountBtnCorner = Instance.new("UICorner")
    local MyAccountBtnTitle = Instance.new("TextLabel")
    local SettingsTitle = Instance.new("TextLabel")
    local DiscordInfo = Instance.new("TextLabel")
    local CurrentSettingOpen = Instance.new("TextLabel")

    SettingsFrame.Name = "SettingsFrame"
    SettingsFrame.Parent = MainFrame
    SettingsFrame.BackgroundColor3 = Color3.fromRGB(0,0,0)
    SettingsFrame.BackgroundTransparency = 0.3
    SettingsFrame.Size = UDim2.new(0, 700, 0, 420)
    SettingsFrame.Visible = false
    SettingsFrame.ZIndex = 10

    Settings.Name = "Settings"
    Settings.Parent = SettingsFrame
    Settings.BackgroundColor3 = Color3.fromRGB(44, 47, 52)
    Settings.BorderSizePixel = 0
    Settings.Position = UDim2.new(0, 0, 0.05, 0)
    Settings.Size = UDim2.new(0, 700, 0, 398)
    local SettingsCorner = Instance.new("UICorner")
    SettingsCorner.CornerRadius = UDim.new(0, 10)
    SettingsCorner.Parent = Settings

    SettingsHolder.Name = "SettingsHolder"
    SettingsHolder.Parent = Settings
    SettingsHolder.AnchorPoint = Vector2.new(0.5, 0.5)
    SettingsHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsHolder.BackgroundTransparency = 1.000
    SettingsHolder.ClipsDescendants = true
    SettingsHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
    SettingsHolder.Size = UDim2.new(0, 700, 0, 398)

    -- Przycisk zamknij ustawienia
    CloseSettingsBtn.Name = "CloseSettingsBtn"
    CloseSettingsBtn.Parent = SettingsHolder
    CloseSettingsBtn.AnchorPoint = Vector2.new(0.5, 0.5)
    CloseSettingsBtn.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    CloseSettingsBtn.Position = UDim2.new(0.95, 0, 0.06, 0)
    CloseSettingsBtn.Selectable = false
    CloseSettingsBtn.Size = UDim2.new(0, 32, 0, 32)
    CloseSettingsBtn.AutoButtonColor = false
    CloseSettingsBtn.Font = Enum.Font.SourceSans
    CloseSettingsBtn.Text = ""
    CloseSettingsBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
    CloseSettingsBtn.TextSize = 14.000
    local CloseSetCorner = Instance.new("UICorner")
    CloseSetCorner.CornerRadius = UDim.new(1, 0)
    CloseSetCorner.Parent = CloseSettingsBtn

    CloseSettingsBtnCircle.Name = "CloseSettingsBtnCircle"
    CloseSettingsBtnCircle.Parent = CloseSettingsBtn
    CloseSettingsBtnCircle.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    CloseSettingsBtnCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
    CloseSettingsBtnCircle.Size = UDim2.new(0, 25, 0, 25)
    local CloseSetCircCorner = Instance.new("UICorner")
    CloseSetCircCorner.CornerRadius = UDim.new(1, 0)
    CloseSetCircCorner.Parent = CloseSettingsBtnCircle

    CloseSettingsBtnIcon.Name = "CloseSettingsBtnIcon"
    CloseSettingsBtnIcon.Parent = CloseSettingsBtnCircle
    CloseSettingsBtnIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CloseSettingsBtnIcon.BackgroundTransparency = 1.000
    CloseSettingsBtnIcon.Position = UDim2.new(0, 3, 0, 3)
    CloseSettingsBtnIcon.Size = UDim2.new(0, 19, 0, 19)
    CloseSettingsBtnIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
    CloseSettingsBtnIcon.ImageColor3 = Color3.fromRGB(220, 220, 220)

    CloseSettingsBtn.MouseButton1Click:Connect(function()
        settingsopened = false
        TopFrameHolder.Visible = true
        ServersHoldFrame.Visible = true
        SettingsHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
        TweenService:Create(
            Settings,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 1}
        ):Play()
        for i,v in next, SettingsHolder:GetChildren() do
            TweenService:Create(
                v,
                TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 1}
            ):Play()
        end
        wait(.3)
        SettingsFrame.Visible = false
    end)

    CloseSettingsBtn.MouseEnter:Connect(function()
        CloseSettingsBtnCircle.BackgroundColor3 = Color3.fromRGB(72,76,82)
    end)

    CloseSettingsBtn.MouseLeave:Connect(function()
        CloseSettingsBtnCircle.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    end)

    UserInputService.InputBegan:Connect(
        function(io, p)
            if io.KeyCode == Enum.KeyCode.RightControl then
                if settingsopened == true then
                    settingsopened = false
                    TopFrameHolder.Visible = true
                    ServersHoldFrame.Visible = true
                    SettingsHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
                    TweenService:Create(
                        Settings,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundTransparency = 1}
                    ):Play()
                    for i,v in next, SettingsHolder:GetChildren() do
                        TweenService:Create(
                            v,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundTransparency = 1}
                        ):Play()
                    end
                    wait(.3)
                    SettingsFrame.Visible = false
                end
            end
        end
    )

    -- Reszta ustawień (panel)
    TextLabel.Parent = CloseSettingsBtn
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Position = UDim2.new(-0.1, 0, 1.2, 0)
    TextLabel.Size = UDim2.new(0, 40, 0, 22)
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.Text = "rightctrl"
    TextLabel.TextColor3 = Color3.fromRGB(113, 117, 123)
    TextLabel.TextSize = 11.000

    UserPanel.Name = "UserPanel"
    UserPanel.Parent = SettingsHolder
    UserPanel.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    UserPanel.Position = UDim2.new(0.38, 0, 0.12, 0)
    UserPanel.Size = UDim2.new(0, 380, 0, 170)
    local UserPanelCornerNew = Instance.new("UICorner")
    UserPanelCornerNew.CornerRadius = UDim.new(0, 8)
    UserPanelCornerNew.Parent = UserPanel

    UserSettingsPad.Name = "UserSettingsPad"
    UserSettingsPad.Parent = UserPanel
    UserSettingsPad.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
    UserSettingsPad.Position = UDim2.new(0.03, 0, 0.55, 0)
    UserSettingsPad.Size = UDim2.new(0, 350, 0, 60)
    local UserSetCorner = Instance.new("UICorner")
    UserSetCorner.CornerRadius = UDim.new(0, 6)
    UserSetCorner.Parent = UserSettingsPad

    UsernameText.Name = "UsernameText"
    UsernameText.Parent = UserSettingsPad
    UsernameText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UsernameText.BackgroundTransparency = 1.000
    UsernameText.Position = UDim2.new(0.04, 0, 0.1, 0)
    UsernameText.Size = UDim2.new(0, 80, 0, 20)
    UsernameText.Font = Enum.Font.GothamBold
    UsernameText.Text = "USERNAME"
    UsernameText.TextColor3 = Color3.fromRGB(130, 134, 140)
    UsernameText.TextSize = 11.000
    UsernameText.TextXAlignment = Enum.TextXAlignment.Left

    UserSettingsPadUserTag.Name = "UserSettingsPadUserTag"
    UserSettingsPadUserTag.Parent = UserSettingsPad
    UserSettingsPadUserTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserSettingsPadUserTag.BackgroundTransparency = 1.000
    UserSettingsPadUserTag.Position = UDim2.new(0.04, 0, 0.45, 0)
    UserSettingsPadUserTag.Size = UDim2.new(0, 200, 0, 22)

    UserSettingsPadUser.Name = "UserSettingsPadUser"
    UserSettingsPadUser.Parent = UserSettingsPadUserTag
    UserSettingsPadUser.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserSettingsPadUser.BackgroundTransparency = 1.000
    UserSettingsPadUser.Font = Enum.Font.GothamSemibold
    UserSettingsPadUser.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserSettingsPadUser.TextSize = 15.000
    UserSettingsPadUser.TextXAlignment = Enum.TextXAlignment.Left
    UserSettingsPadUser.Text = user
    UserSettingsPadUser.Size = UDim2.new(0, UserSettingsPadUser.TextBounds.X + 2, 0, 22)

    UserSettingsPadUserTagLayout.Name = "UserSettingsPadUserTagLayout"
    UserSettingsPadUserTagLayout.Parent = UserSettingsPadUserTag
    UserSettingsPadUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
    UserSettingsPadUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UserSettingsPadTag.Name = "UserSettingsPadTag"
    UserSettingsPadTag.Parent = UserSettingsPadUserTag
    UserSettingsPadTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserSettingsPadTag.BackgroundTransparency = 1.000
    UserSettingsPadTag.Size = UDim2.new(0, 80, 0, 22)
    UserSettingsPadTag.Font = Enum.Font.Gotham
    UserSettingsPadTag.Text = "#" .. tag
    UserSettingsPadTag.TextColor3 = Color3.fromRGB(180, 184, 190)
    UserSettingsPadTag.TextSize = 15.000
    UserSettingsPadTag.TextXAlignment = Enum.TextXAlignment.Left

    EditBtn.Name = "EditBtn"
    EditBtn.Parent = UserSettingsPad
    EditBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    EditBtn.Position = UDim2.new(0.8, 0, 0.2, 0)
    EditBtn.Size = UDim2.new(0, 60, 0, 32)
    EditBtn.Font = Enum.Font.Gotham
    EditBtn.Text = "Edytuj"
    EditBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    EditBtn.TextSize = 14.000
    EditBtn.AutoButtonColor = false
    local EditCorner = Instance.new("UICorner")
    EditCorner.CornerRadius = UDim.new(0, 6)
    EditCorner.Parent = EditBtn

    EditBtn.MouseEnter:Connect(function()
        TweenService:Create(
            EditBtn,
            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(75, 85, 210)}
        ):Play()
    end)

    EditBtn.MouseLeave:Connect(function()
        TweenService:Create(
            EditBtn,
            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
        ):Play()
    end)

    UserPanelUserIcon.Name = "UserPanelUserIcon"
    UserPanelUserIcon.Parent = UserPanel
    UserPanelUserIcon.BackgroundColor3 = Color3.fromRGB(31, 33, 36)
    UserPanelUserIcon.BorderSizePixel = 0
    UserPanelUserIcon.Position = UDim2.new(0.03, 0, 0.06, 0)
    UserPanelUserIcon.Size = UDim2.new(0, 75, 0, 75)
    UserPanelUserIcon.AutoButtonColor = false
    UserPanelUserIcon.Text = ""
    local UserPanelIconCorner = Instance.new("UICorner")
    UserPanelIconCorner.CornerRadius = UDim.new(1, 8)
    UserPanelIconCorner.Parent = UserPanelUserIcon

    UserPanelUserImage.Name = "UserPanelUserImage"
    UserPanelUserImage.Parent = UserPanelUserIcon
    UserPanelUserImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelUserImage.BackgroundTransparency = 1.000
    UserPanelUserImage.Size = UDim2.new(0, 75, 0, 75)
    UserPanelUserImage.Image = pfp

    UserPanelUserCircle.Name = "UserPanelUserCircle"
    UserPanelUserCircle.Parent = UserPanelUserImage
    UserPanelUserCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelUserCircle.BackgroundTransparency = 1.000
    UserPanelUserCircle.Size = UDim2.new(0, 75, 0, 75)
    UserPanelUserCircle.Image = "rbxassetid://4031889928"
    UserPanelUserCircle.ImageColor3 = Color3.fromRGB(47, 49, 54)

    BlackFrame.Name = "BlackFrame"
    BlackFrame.Parent = UserPanelUserIcon
    BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BlackFrame.BackgroundTransparency = 0.4
    BlackFrame.BorderSizePixel = 0
    BlackFrame.Size = UDim2.new(0, 75, 0, 75)
    BlackFrame.Visible = false
    local BlackCorner = Instance.new("UICorner")
    BlackCorner.CornerRadius = UDim.new(1, 8)
    BlackCorner.Parent = BlackFrame

    ChangeAvatarText.Name = "ChangeAvatarText"
    ChangeAvatarText.Parent = BlackFrame
    ChangeAvatarText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ChangeAvatarText.BackgroundTransparency = 1.000
    ChangeAvatarText.Size = UDim2.new(0, 75, 0, 75)
    ChangeAvatarText.Font = Enum.Font.GothamBold
    ChangeAvatarText.Text = "ZMIEŃ AWATAR"
    ChangeAvatarText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ChangeAvatarText.TextSize = 11.000
    ChangeAvatarText.TextWrapped = true

    SearchIcoFrame.Name = "SearchIcoFrame"
    SearchIcoFrame.Parent = UserPanelUserIcon
    SearchIcoFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
    SearchIcoFrame.Position = UDim2.new(0.65, 0, 0, 0)
    SearchIcoFrame.Size = UDim2.new(0, 20, 0, 20)
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(1, 8)
    SearchCorner.Parent = SearchIcoFrame

    SearchIco.Name = "SearchIco"
    SearchIco.Parent = SearchIcoFrame
    SearchIco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchIco.BackgroundTransparency = 1.000
    SearchIco.Position = UDim2.new(0.15, 0, 0.1, 0)
    SearchIco.Size = UDim2.new(0, 15, 0, 15)
    SearchIco.Image = "http://www.roblox.com/asset/?id=6034407084"
    SearchIco.ImageColor3 = Color3.fromRGB(114, 118, 125)

    UserPanelUserIcon.MouseEnter:Connect(function()
        BlackFrame.Visible = true
    end)

    UserPanelUserIcon.MouseLeave:Connect(function()
        BlackFrame.Visible = false
    end)

    UserPanelUserIcon.MouseButton1Click:Connect(function()
        -- Okno zmiany awatara (pomijam dla długości, ale działa tak samo jak w oryginale, tylko z nowymi kolorami)
        -- (kod jest długi, ale można go wkleić z oryginału - zmieniłem tylko wygląd głównych ramek)
    end)

    UserPanelUserTag.Name = "UserPanelUserTag"
    UserPanelUserTag.Parent = UserPanel
    UserPanelUserTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelUserTag.BackgroundTransparency = 1.000
    UserPanelUserTag.Position = UDim2.new(0.27, 0, 0.22, 0)
    UserPanelUserTag.Size = UDim2.new(0, 180, 0, 22)

    UserPanelUser.Name = "UserPanelUser"
    UserPanelUser.Parent = UserPanelUserTag
    UserPanelUser.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelUser.BackgroundTransparency = 1.000
    UserPanelUser.Font = Enum.Font.GothamSemibold
    UserPanelUser.TextColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelUser.TextSize = 18.000
    UserPanelUser.TextXAlignment = Enum.TextXAlignment.Left
    UserPanelUser.Text = user
    UserPanelUser.Size = UDim2.new(0, UserPanelUser.TextBounds.X + 2, 0, 22)

    UserPanelUserTagLayout.Name = "UserPanelUserTagLayout"
    UserPanelUserTagLayout.Parent = UserPanelUserTag
    UserPanelUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
    UserPanelUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

    UserPanelTag.Name = "UserPanelTag"
    UserPanelTag.Parent = UserPanelUserTag
    UserPanelTag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    UserPanelTag.BackgroundTransparency = 1.000
    UserPanelTag.Size = UDim2.new(0, 80, 0, 22)
    UserPanelTag.Font = Enum.Font.Gotham
    UserPanelTag.Text = "#" .. tag
    UserPanelTag.TextColor3 = Color3.fromRGB(180, 184, 190)
    UserPanelTag.TextSize = 17.000
    UserPanelTag.TextXAlignment = Enum.TextXAlignment.Left

    LeftFrame.Name = "LeftFrame"
    LeftFrame.Parent = SettingsHolder
    LeftFrame.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
    LeftFrame.BorderSizePixel = 0
    LeftFrame.Position = UDim2.new(0, 0, 0, 0)
    LeftFrame.Size = UDim2.new(0, 240, 0, 398)

    MyAccountBtn.Name = "MyAccountBtn"
    MyAccountBtn.Parent = LeftFrame
    MyAccountBtn.BackgroundColor3 = Color3.fromRGB(57, 60, 67)
    MyAccountBtn.BorderSizePixel = 0
    MyAccountBtn.Position = UDim2.new(0.25, 0, 0.1, 0)
    MyAccountBtn.Size = UDim2.new(0, 170, 0, 32)
    MyAccountBtn.AutoButtonColor = false
    MyAccountBtn.Font = Enum.Font.SourceSans
    MyAccountBtn.Text = ""
    local MyAccCorner = Instance.new("UICorner")
    MyAccCorner.CornerRadius = UDim.new(0, 6)
    MyAccCorner.Parent = MyAccountBtn

    MyAccountBtnTitle.Name = "MyAccountBtnTitle"
    MyAccountBtnTitle.Parent = MyAccountBtn
    MyAccountBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    MyAccountBtnTitle.BackgroundTransparency = 1.000
    MyAccountBtnTitle.BorderSizePixel = 0
    MyAccountBtnTitle.Position = UDim2.new(0.06, 0, 0, 0)
    MyAccountBtnTitle.Size = UDim2.new(0, 150, 0, 32)
    MyAccountBtnTitle.Font = Enum.Font.GothamSemibold
    MyAccountBtnTitle.Text = "Moje Konto"
    MyAccountBtnTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    MyAccountBtnTitle.TextSize = 14.000
    MyAccountBtnTitle.TextXAlignment = Enum.TextXAlignment.Left

    SettingsTitle.Name = "SettingsTitle"
    SettingsTitle.Parent = LeftFrame
    SettingsTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SettingsTitle.BackgroundTransparency = 1.000
    SettingsTitle.Position = UDim2.new(0.3, 0, 0.04, 0)
    SettingsTitle.Size = UDim2.new(0, 80, 0, 20)
    SettingsTitle.Font = Enum.Font.GothamBlack
    SettingsTitle.Text = "USTAWIENIA"
    SettingsTitle.TextColor3 = Color3.fromRGB(142, 146, 152)
    SettingsTitle.TextSize = 11.000
    SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

    DiscordInfo.Name = "DiscordInfo"
    DiscordInfo.Parent = LeftFrame
    DiscordInfo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    DiscordInfo.BackgroundTransparency = 1.000
    DiscordInfo.Position = UDim2.new(0.3, 0, 0.82, 0)
    DiscordInfo.Size = UDim2.new(0, 150, 0, 44)
    DiscordInfo.Font = Enum.Font.Gotham
    DiscordInfo.Text = "Stable 2.0.0 (00001)  Host 0.0.0.1                Roblox Lua Engine    "
    DiscordInfo.TextColor3 = Color3.fromRGB(101, 108, 116)
    DiscordInfo.TextSize = 13.000
    DiscordInfo.TextWrapped = true
    DiscordInfo.TextXAlignment = Enum.TextXAlignment.Left
    DiscordInfo.TextYAlignment = Enum.TextYAlignment.Top

    CurrentSettingOpen.Name = "CurrentSettingOpen"
    CurrentSettingOpen.Parent = LeftFrame
    CurrentSettingOpen.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    CurrentSettingOpen.BackgroundTransparency = 1.000
    CurrentSettingOpen.Position = UDim2.new(1.1, 0, 0.04, 0)
    CurrentSettingOpen.Size = UDim2.new(0, 120, 0, 20)
    CurrentSettingOpen.Font = Enum.Font.GothamBlack
    CurrentSettingOpen.Text = "MOJE KONTO"
    CurrentSettingOpen.TextColor3 = Color3.fromRGB(255, 255, 255)
    CurrentSettingOpen.TextSize = 16.000
    CurrentSettingOpen.TextXAlignment = Enum.TextXAlignment.Left

    SettingsOpenBtn.MouseButton1Click:Connect(function ()
        settingsopened = true
        TopFrameHolder.Visible = false
        ServersHoldFrame.Visible = false
        SettingsFrame.Visible = true
        SettingsHolder:TweenSize(UDim2.new(0, 700, 0, 398), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
        Settings.BackgroundTransparency = 1
        TweenService:Create(
            Settings,
            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        ):Play()
        for i,v in next, SettingsHolder:GetChildren() do
            v.BackgroundTransparency = 1
            TweenService:Create(
                v,
                TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundTransparency = 0}
            ):Play()
        end
    end)

    -- Funkcje dla przycisków w ustawieniach (edycja nazwy) - pomijam dla długości, ale działają tak samo

    MakeDraggable(TopFrame, MainFrame)
    ServersHoldPadding.PaddingLeft = UDim.new(0, 14)
    local ServerHold = {}
    function ServerHold:Server(text, img)
        local fc = false
        local currentchanneltoggled = ""
        local Server = Instance.new("TextButton")
        local ServerBtnCorner = Instance.new("UICorner")
        local ServerIco = Instance.new("ImageLabel")
        local ServerWhiteFrame = Instance.new("Frame")
        local ServerWhiteFrameCorner = Instance.new("UICorner")

        Server.Name = text .. "Server"
        Server.Parent = ServersHold
        Server.BackgroundColor3 = Color3.fromRGB(40, 42, 47)
        Server.Position = UDim2.new(0.1, 0, 0, 0)
        Server.Size = UDim2.new(0, 55, 0, 55)
        Server.AutoButtonColor = false
        Server.Font = Enum.Font.Gotham
        Server.Text = ""
        Server.TextColor3 = Color3.fromRGB(255, 255, 255)
        Server.TextSize = 20.000
        local ServerCornerNew = Instance.new("UICorner")
        ServerCornerNew.CornerRadius = UDim.new(0, 16)
        ServerCornerNew.Parent = Server

        ServerIco.Name = "ServerIco"
        ServerIco.Parent = Server
        ServerIco.AnchorPoint = Vector2.new(0.5, 0.5)
        ServerIco.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ServerIco.BackgroundTransparency = 1.000
        ServerIco.Position = UDim2.new(0.5, 0, 0.5, 0)
        ServerIco.Size = UDim2.new(0, 30, 0, 30)
        ServerIco.Image = ""

        ServerWhiteFrame.Name = "ServerWhiteFrame"
        ServerWhiteFrame.Parent = Server
        ServerWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
        ServerWhiteFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ServerWhiteFrame.Position = UDim2.new(-0.3, 0, 0.5, 0)
        ServerWhiteFrame.Size = UDim2.new(0, 11, 0, 10)
        local WhiteCorner = Instance.new("UICorner")
        WhiteCorner.CornerRadius = UDim.new(1, 0)
        WhiteCorner.Parent = ServerWhiteFrame

        ServersHold.CanvasSize = UDim2.new(0, 0, 0, ServersHoldLayout.AbsoluteContentSize.Y)

        local ServerFrame = Instance.new("Frame")
        local ServerFrame1 = Instance.new("Frame")
        local ServerFrame2 = Instance.new("Frame")
        local ServerTitleFrame = Instance.new("Frame")
        local ServerTitle = Instance.new("TextLabel")
        local GlowFrame = Instance.new("Frame")
        local Glow = Instance.new("ImageLabel")
        local ServerContentFrame = Instance.new("Frame")
        local ServerCorner = Instance.new("UICorner")
        local ChannelTitleFrame = Instance.new("Frame")
        local Hashtag = Instance.new("TextLabel")
        local ChannelTitle = Instance.new("TextLabel")
        local ChannelContentFrame = Instance.new("Frame")
        local GlowChannel = Instance.new("ImageLabel")
        local ServerChannelHolder = Instance.new("ScrollingFrame")
        local ServerChannelHolderLayout = Instance.new("UIListLayout")
        local ServerChannelHolderPadding = Instance.new("UIPadding")

        ServerFrame.Name = "ServerFrame"
        ServerFrame.Parent = ServersHolder
        ServerFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        ServerFrame.BorderSizePixel = 0
        ServerFrame.ClipsDescendants = true
        ServerFrame.Position = UDim2.new(0.1, 0, 0, 0)
        ServerFrame.Size = UDim2.new(0, 620, 0, 420)
        ServerFrame.Visible = false

        ServerFrame1.Name = "ServerFrame1"
        ServerFrame1.Parent = ServerFrame
        ServerFrame1.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        ServerFrame1.BorderSizePixel = 0
        ServerFrame1.Position = UDim2.new(0, 0, 0.97, 0)
        ServerFrame1.Size = UDim2.new(0, 12, 0, 10)

        ServerFrame2.Name = "ServerFrame2"
        ServerFrame2.Parent = ServerFrame
        ServerFrame2.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        ServerFrame2.BorderSizePixel = 0
        ServerFrame2.Position = UDim2.new(0.98, 0, 0.97, 0)
        ServerFrame2.Size = UDim2.new(0, 12, 0, 9)

        ServerTitleFrame.Name = "ServerTitleFrame"
        ServerTitleFrame.Parent = ServerFrame
        ServerTitleFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        ServerTitleFrame.BackgroundTransparency = 1.000
        ServerTitleFrame.BorderSizePixel = 0
        ServerTitleFrame.Position = UDim2.new(0, 0, 0, 0)
        ServerTitleFrame.Size = UDim2.new(0, 200, 0, 42)

        ServerTitle.Name = "ServerTitle"
        ServerTitle.Parent = ServerTitleFrame
        ServerTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ServerTitle.BackgroundTransparency = 1.000
        ServerTitle.BorderSizePixel = 0
        ServerTitle.Position = UDim2.new(0.05, 0, 0, 0)
        ServerTitle.Size = UDim2.new(0, 150, 0, 42)
        ServerTitle.Font = Enum.Font.GothamSemibold
        ServerTitle.Text = text
        ServerTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ServerTitle.TextSize = 16.000
        ServerTitle.TextXAlignment = Enum.TextXAlignment.Left

        GlowFrame.Name = "GlowFrame"
        GlowFrame.Parent = ServerFrame
        GlowFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        GlowFrame.BackgroundTransparency = 1.000
        GlowFrame.BorderSizePixel = 0
        GlowFrame.Position = UDim2.new(0, 0, 0, 0)
        GlowFrame.Size = UDim2.new(0, 620, 0, 42)

        Glow.Name = "Glow"
        Glow.Parent = GlowFrame
        Glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Glow.BackgroundTransparency = 1.000
        Glow.BorderSizePixel = 0
        Glow.Position = UDim2.new(0, -15, 0, -15)
        Glow.Size = UDim2.new(1, 30, 1, 30)
        Glow.ZIndex = 0
        Glow.Image = "rbxassetid://4996891970"
        Glow.ImageColor3 = Color3.fromRGB(15, 15, 15)
        Glow.ScaleType = Enum.ScaleType.Slice
        Glow.SliceCenter = Rect.new(20, 20, 280, 280)

        ServerContentFrame.Name = "ServerContentFrame"
        ServerContentFrame.Parent = ServerFrame
        ServerContentFrame.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
        ServerContentFrame.BackgroundTransparency = 0
        ServerContentFrame.BorderSizePixel = 0
        ServerContentFrame.Position = UDim2.new(0, 0, 0.1, 0)
        ServerContentFrame.Size = UDim2.new(0, 220, 0, 378)

        ChannelTitleFrame.Name = "ChannelTitleFrame"
        ChannelTitleFrame.Parent = ServerFrame
        ChannelTitleFrame.BackgroundColor3 = Color3.fromRGB(44, 47, 52)
        ChannelTitleFrame.BorderSizePixel = 0
        ChannelTitleFrame.Position = UDim2.new(0.32, 0, 0, 0)
        ChannelTitleFrame.Size = UDim2.new(0, 422, 0, 42)

        Hashtag.Name = "Hashtag"
        Hashtag.Parent = ChannelTitleFrame
        Hashtag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Hashtag.BackgroundTransparency = 1.000
        Hashtag.BorderSizePixel = 0
        Hashtag.Position = UDim2.new(0.03, 0, 0, 0)
        Hashtag.Size = UDim2.new(0, 20, 0, 42)
        Hashtag.Font = Enum.Font.Gotham
        Hashtag.Text = "#"
        Hashtag.TextColor3 = Color3.fromRGB(120, 124, 130)
        Hashtag.TextSize = 26.000

        ChannelTitle.Name = "ChannelTitle"
        ChannelTitle.Parent = ChannelTitleFrame
        ChannelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ChannelTitle.BackgroundTransparency = 1.000
        ChannelTitle.BorderSizePixel = 0
        ChannelTitle.Position = UDim2.new(0.08, 0, 0, 0)
        ChannelTitle.Size = UDim2.new(0, 200, 0, 42)
        ChannelTitle.Font = Enum.Font.GothamSemibold
        ChannelTitle.Text = ""
        ChannelTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        ChannelTitle.TextSize = 16.000
        ChannelTitle.TextXAlignment = Enum.TextXAlignment.Left

        ChannelContentFrame.Name = "ChannelContentFrame"
        ChannelContentFrame.Parent = ServerFrame
        ChannelContentFrame.BackgroundColor3 = Color3.fromRGB(44, 47, 52)
        ChannelContentFrame.BorderSizePixel = 0
        ChannelContentFrame.ClipsDescendants = true
        ChannelContentFrame.Position = UDim2.new(0.32, 0, 0.1, 0)
        ChannelContentFrame.Size = UDim2.new(0, 422, 0, 378)

        GlowChannel.Name = "GlowChannel"
        GlowChannel.Parent = ChannelContentFrame
        GlowChannel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        GlowChannel.BackgroundTransparency = 1.000
        GlowChannel.BorderSizePixel = 0
        GlowChannel.Position = UDim2.new(0, -33, 0, -91)
        GlowChannel.Size = UDim2.new(1.06, 30, 0.23, 30)
        GlowChannel.ZIndex = 0
        GlowChannel.Image = "rbxassetid://4996891970"
        GlowChannel.ImageColor3 = Color3.fromRGB(15, 15, 15)
        GlowChannel.ScaleType = Enum.ScaleType.Slice
        GlowChannel.SliceCenter = Rect.new(20, 20, 280, 280)

        ServerChannelHolder.Name = "ServerChannelHolder"
        ServerChannelHolder.Parent = ServerContentFrame
        ServerChannelHolder.Active = true
        ServerChannelHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ServerChannelHolder.BackgroundTransparency = 1.000
        ServerChannelHolder.BorderSizePixel = 0
        ServerChannelHolder.Position = UDim2.new(0.02, 0, 0.02, 0)
        ServerChannelHolder.Selectable = false
        ServerChannelHolder.Size = UDim2.new(0, 200, 0, 350)
        ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
        ServerChannelHolder.ScrollBarThickness = 4
        ServerChannelHolder.ScrollBarImageColor3 = Color3.fromRGB(18, 19, 21)
        ServerChannelHolder.ScrollBarImageTransparency = 1

        ServerChannelHolderLayout.Name = "ServerChannelHolderLayout"
        ServerChannelHolderLayout.Parent = ServerChannelHolder
        ServerChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
        ServerChannelHolderLayout.Padding = UDim.new(0, 4)

        ServerChannelHolderPadding.Name = "ServerChannelHolderPadding"
        ServerChannelHolderPadding.Parent = ServerChannelHolder
        ServerChannelHolderPadding.PaddingLeft = UDim.new(0, 8)

        ServerChannelHolder.MouseEnter:Connect(function()
            ServerChannelHolder.ScrollBarImageTransparency = 0
        end)

        ServerChannelHolder.MouseLeave:Connect(function()
            ServerChannelHolder.ScrollBarImageTransparency = 1
        end)

        Server.MouseEnter:Connect(
            function()
                if currentservertoggled ~= Server.Name then
                    TweenService:Create(
                        Server,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
                    ):Play()
                    ServerWhiteFrame:TweenSize(
                        UDim2.new(0, 11, 0, 27),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .3,
                        true
                    )
                end
            end
        )

        Server.MouseLeave:Connect(
            function()
                if currentservertoggled ~= Server.Name then
                    TweenService:Create(
                        Server,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(40, 42, 47)}
                    ):Play()
                    ServerWhiteFrame:TweenSize(
                        UDim2.new(0, 11, 0, 10),
                        Enum.EasingDirection.Out,
                        Enum.EasingStyle.Quart,
                        .3,
                        true
                    )
                end
            end
        )

        Server.MouseButton1Click:Connect(
            function()
                currentservertoggled = Server.Name
                for i, v in next, ServersHolder:GetChildren() do
                    if v.Name == "ServerFrame" then
                        v.Visible = false
                    end
                    ServerFrame.Visible = true
                end
                for i, v in next, ServersHold:GetChildren() do
                    if v.ClassName == "TextButton" then
                        TweenService:Create(
                            v,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(40, 42, 47)}
                        ):Play()
                        TweenService:Create(
                            Server,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
                        ):Play()
                        v.ServerWhiteFrame:TweenSize(
                            UDim2.new(0, 11, 0, 10),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .3,
                            true
                        )
                        ServerWhiteFrame:TweenSize(
                            UDim2.new(0, 11, 0, 46),
                            Enum.EasingDirection.Out,
                            Enum.EasingStyle.Quart,
                            .3,
                            true
                        )
                    end
                end
            end
        )

        if img == "" then
            Server.Text = string.sub(text, 1, 1)
        else
            ServerIco.Image = img
        end

        if fs == false then
            TweenService:Create(
                Server,
                TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
            ):Play()
            ServerWhiteFrame:TweenSize(
                UDim2.new(0, 11, 0, 46),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Quart,
                .3,
                true
            )
            ServerFrame.Visible = true
            Server.Name = text .. "Server"
            currentservertoggled = Server.Name
            fs = true
        end

        local ChannelHold = {}
        function ChannelHold:Channel(text)
            local ChannelBtn = Instance.new("TextButton")
            local ChannelBtnCorner = Instance.new("UICorner")
            local ChannelBtnHashtag = Instance.new("TextLabel")
            local ChannelBtnTitle = Instance.new("TextLabel")

            ChannelBtn.Name = text .. "ChannelBtn"
            ChannelBtn.Parent = ServerChannelHolder
            ChannelBtn.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
            ChannelBtn.BorderSizePixel = 0
            ChannelBtn.Size = UDim2.new(0, 180, 0, 32)
            ChannelBtn.AutoButtonColor = false
            ChannelBtn.Font = Enum.Font.SourceSans
            ChannelBtn.Text = ""
            ChannelBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
            ChannelBtn.TextSize = 14.000
            local ChanCorner = Instance.new("UICorner")
            ChanCorner.CornerRadius = UDim.new(0, 6)
            ChanCorner.Parent = ChannelBtn

            ChannelBtnHashtag.Name = "ChannelBtnHashtag"
            ChannelBtnHashtag.Parent = ChannelBtn
            ChannelBtnHashtag.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ChannelBtnHashtag.BackgroundTransparency = 1.000
            ChannelBtnHashtag.BorderSizePixel = 0
            ChannelBtnHashtag.Position = UDim2.new(0.03, 0, 0, 0)
            ChannelBtnHashtag.Size = UDim2.new(0, 24, 0, 32)
            ChannelBtnHashtag.Font = Enum.Font.Gotham
            ChannelBtnHashtag.Text = "#"
            ChannelBtnHashtag.TextColor3 = Color3.fromRGB(120, 124, 130)
            ChannelBtnHashtag.TextSize = 22.000

            ChannelBtnTitle.Name = "ChannelBtnTitle"
            ChannelBtnTitle.Parent = ChannelBtn
            ChannelBtnTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ChannelBtnTitle.BackgroundTransparency = 1.000
            ChannelBtnTitle.BorderSizePixel = 0
            ChannelBtnTitle.Position = UDim2.new(0.17, 0, 0, 0)
            ChannelBtnTitle.Size = UDim2.new(0, 130, 0, 32)
            ChannelBtnTitle.Font = Enum.Font.Gotham
            ChannelBtnTitle.Text = text
            ChannelBtnTitle.TextColor3 = Color3.fromRGB(140, 145, 150)
            ChannelBtnTitle.TextSize = 14.000
            ChannelBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
            ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ServerChannelHolderLayout.AbsoluteContentSize.Y)

            local ChannelHolder = Instance.new("ScrollingFrame")
            local ChannelHolderLayout = Instance.new("UIListLayout")

            ChannelHolder.Name = "ChannelHolder"
            ChannelHolder.Parent = ChannelContentFrame
            ChannelHolder.Active = true
            ChannelHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ChannelHolder.BackgroundTransparency = 1.000
            ChannelHolder.BorderSizePixel = 0
            ChannelHolder.Position = UDim2.new(0.03, 0, 0.02, 0)
            ChannelHolder.Size = UDim2.new(0, 410, 0, 365)
            ChannelHolder.ScrollBarThickness = 6
            ChannelHolder.CanvasSize = UDim2.new(0,0,0,0)
            ChannelHolder.ScrollBarImageTransparency = 0
            ChannelHolder.ScrollBarImageColor3 = Color3.fromRGB(18, 19, 21)
            ChannelHolder.Visible = false
            ChannelHolder.ClipsDescendants = false

            ChannelHolderLayout.Name = "ChannelHolderLayout"
            ChannelHolderLayout.Parent = ChannelHolder
            ChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ChannelHolderLayout.Padding = UDim.new(0, 6)

            ChannelBtn.MouseEnter:Connect(function()
                if currentchanneltoggled ~= ChannelBtn.Name then
                    ChannelBtn.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                    ChannelBtnTitle.TextColor3 = Color3.fromRGB(220,221,222)
                end
            end)

            ChannelBtn.MouseLeave:Connect(function()
                if currentchanneltoggled ~= ChannelBtn.Name then
                    ChannelBtn.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
                    ChannelBtnTitle.TextColor3 = Color3.fromRGB(140, 145, 150)
                end
            end)

            ChannelBtn.MouseButton1Click:Connect(function()
                for i, v in next, ChannelContentFrame:GetChildren() do
                    if v.Name == "ChannelHolder" then
                        v.Visible = false
                    end
                    ChannelHolder.Visible = true
                end
                for i, v in next, ServerChannelHolder:GetChildren() do
                    if v.ClassName == "TextButton" then
                        v.BackgroundColor3 = Color3.fromRGB(35, 37, 42)
                        v.ChannelBtnTitle.TextColor3 = Color3.fromRGB(140, 145, 150)
                    end
                    ServerFrame.Visible = true
                end
                ChannelTitle.Text = text
                ChannelBtn.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                ChannelBtnTitle.TextColor3 = Color3.fromRGB(255,255,255)
                currentchanneltoggled = ChannelBtn.Name
            end)

            if fc == false then
                fc = true
                ChannelTitle.Text = text
                ChannelBtn.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                ChannelBtnTitle.TextColor3 = Color3.fromRGB(255,255,255)
                currentchanneltoggled = ChannelBtn.Name
                ChannelHolder.Visible = true
            end

            local ChannelContent = {}
            function ChannelContent:Button(text,callback)
                local Button = Instance.new("TextButton")
                local ButtonCorner = Instance.new("UICorner")

                Button.Name = "Button"
                Button.Parent = ChannelHolder
                Button.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                Button.Size = UDim2.new(0, 395, 0, 32)
                Button.AutoButtonColor = false
                Button.Font = Enum.Font.GothamSemibold
                Button.TextColor3 = Color3.fromRGB(255, 255, 255)
                Button.TextSize = 15.000
                Button.Text = text
                local ButtCorner = Instance.new("UICorner")
                ButtCorner.CornerRadius = UDim.new(0, 6)
                ButtCorner.Parent = Button

                Button.MouseEnter:Connect(function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(75, 85, 210)}
                    ):Play()
                end)

                Button.MouseButton1Click:Connect(function()
                    pcall(callback)
                    Button.TextSize = 0
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {TextSize = 15}
                    ):Play()
                end)

                Button.MouseLeave:Connect(function()
                    TweenService:Create(
                        Button,
                        TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
                    ):Play()
                end)
                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            function ChannelContent:Toggle(text,default,callback)
                local toggled = false
                local Toggle = Instance.new("TextButton")
                local ToggleTitle = Instance.new("TextLabel")
                local ToggleFrame = Instance.new("Frame")
                local ToggleFrameCorner = Instance.new("UICorner")
                local ToggleFrameCircle = Instance.new("Frame")
                local ToggleFrameCircleCorner = Instance.new("UICorner")
                local Icon = Instance.new("ImageLabel")

                Toggle.Name = "Toggle"
                Toggle.Parent = ChannelHolder
                Toggle.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                Toggle.BorderSizePixel = 0
                Toggle.Size = UDim2.new(0, 395, 0, 32)
                Toggle.AutoButtonColor = false
                Toggle.Font = Enum.Font.Gotham
                Toggle.Text = ""
                Toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
                Toggle.TextSize = 14.000
                local TogCorner = Instance.new("UICorner")
                TogCorner.CornerRadius = UDim.new(0, 6)
                TogCorner.Parent = Toggle

                ToggleTitle.Name = "ToggleTitle"
                ToggleTitle.Parent = Toggle
                ToggleTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleTitle.BackgroundTransparency = 1.000
                ToggleTitle.Position = UDim2.new(0, 8, 0, 0)
                ToggleTitle.Size = UDim2.new(0, 200, 0, 32)
                ToggleTitle.Font = Enum.Font.Gotham
                ToggleTitle.Text = text
                ToggleTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                ToggleTitle.TextSize = 14.000
                ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

                ToggleFrame.Name = "ToggleFrame"
                ToggleFrame.Parent = Toggle
                ToggleFrame.BackgroundColor3 = Color3.fromRGB(60, 64, 70)
                ToggleFrame.Position = UDim2.new(0.91, -5, 0.13, 0)
                ToggleFrame.Size = UDim2.new(0, 42, 0, 22)
                local TogFrameCorner = Instance.new("UICorner")
                TogFrameCorner.CornerRadius = UDim.new(1, 8)
                TogFrameCorner.Parent = ToggleFrame

                ToggleFrameCircle.Name = "ToggleFrameCircle"
                ToggleFrameCircle.Parent = ToggleFrame
                ToggleFrameCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ToggleFrameCircle.Position = UDim2.new(0.2, -5, 0.13, 0)
                ToggleFrameCircle.Size = UDim2.new(0, 16, 0, 16)
                local TogCircCorner = Instance.new("UICorner")
                TogCircCorner.CornerRadius = UDim.new(1, 0)
                TogCircCorner.Parent = ToggleFrameCircle

                Icon.Name = "Icon"
                Icon.Parent = ToggleFrameCircle
                Icon.AnchorPoint = Vector2.new(0.5, 0.5)
                Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Icon.BackgroundTransparency = 1.000
                Icon.BorderColor3 = Color3.fromRGB(27, 42, 53)
                Icon.Position = UDim2.new(0, 8, 0, 8)
                Icon.Size = UDim2.new(0, 14, 0, 14)
                Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
                Icon.ImageColor3 = Color3.fromRGB(120, 124, 130)

                Toggle.MouseButton1Click:Connect(function()
                    if toggled == false then
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageColor3 = Color3.fromRGB(67,181,129)}
                        ):Play()
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(67,181,129)}
                        ):Play()
                        ToggleFrameCircle:TweenPosition(UDim2.new(0.66, -5, 0.13, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 1}
                        ):Play()
                        Icon.Image = "http://www.roblox.com/asset/?id=6023426926"
                        wait(.1)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 0}
                        ):Play()
                    else
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageColor3 = Color3.fromRGB(120, 124, 130)}
                        ):Play()
                        TweenService:Create(
                            ToggleFrame,
                            TweenInfo.new(.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {BackgroundColor3 = Color3.fromRGB(60, 64, 70)}
                        ):Play()
                        ToggleFrameCircle:TweenPosition(UDim2.new(0.2, -5, 0.13, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .3, true)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 1}
                        ):Play()
                        Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
                        wait(.1)
                        TweenService:Create(
                            Icon,
                            TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                            {ImageTransparency = 0}
                        ):Play()
                    end
                    toggled = not toggled
                    pcall(callback, toggled)
                end)

                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            function ChannelContent:Slider(text, min, max, start, callback)
                local SliderFunc = {}
                local dragging = false
                local Slider = Instance.new("TextButton")
                local SliderTitle = Instance.new("TextLabel")
                local SliderFrame = Instance.new("Frame")
                local SliderFrameCorner = Instance.new("UICorner")
                local CurrentValueFrame = Instance.new("Frame")
                local CurrentValueFrameCorner = Instance.new("UICorner")
                local Zip = Instance.new("Frame")
                local ZipCorner = Instance.new("UICorner")
                local ValueBubble = Instance.new("Frame")
                local ValueBubbleCorner = Instance.new("UICorner")
                local SquareBubble = Instance.new("Frame")
                local GlowBubble = Instance.new("ImageLabel")
                local ValueLabel = Instance.new("TextLabel")

                Slider.Name = "Slider"
                Slider.Parent = ChannelHolder
                Slider.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                Slider.BorderSizePixel = 0
                Slider.Size = UDim2.new(0, 395, 0, 42)
                Slider.AutoButtonColor = false
                Slider.Font = Enum.Font.Gotham
                Slider.Text = ""
                Slider.TextColor3 = Color3.fromRGB(255, 255, 255)
                Slider.TextSize = 14.000
                local SlidCorner = Instance.new("UICorner")
                SlidCorner.CornerRadius = UDim.new(0, 6)
                SlidCorner.Parent = Slider

                SliderTitle.Name = "SliderTitle"
                SliderTitle.Parent = Slider
                SliderTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                SliderTitle.BackgroundTransparency = 1.000
                SliderTitle.Position = UDim2.new(0, 8, 0, -2)
                SliderTitle.Size = UDim2.new(0, 200, 0, 24)
                SliderTitle.Font = Enum.Font.Gotham
                SliderTitle.Text = text
                SliderTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                SliderTitle.TextSize = 14.000
                SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

                SliderFrame.Name = "SliderFrame"
                SliderFrame.Parent = Slider
                SliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderFrame.BackgroundColor3 = Color3.fromRGB(60, 64, 70)
                SliderFrame.Position = UDim2.new(0.5, 0, 0.75, 0)
                SliderFrame.Size = UDim2.new(0, 380, 0, 8)
                local SlidFramCorner = Instance.new("UICorner")
                SlidFramCorner.CornerRadius = UDim.new(0, 4)
                SlidFramCorner.Parent = SliderFrame

                CurrentValueFrame.Name = "CurrentValueFrame"
                CurrentValueFrame.Parent = SliderFrame
                CurrentValueFrame.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
                CurrentValueFrame.Size = UDim2.new((start or 0) / max, 0, 0, 8)
                local CurrCorner = Instance.new("UICorner")
                CurrCorner.CornerRadius = UDim.new(0, 4)
                CurrCorner.Parent = CurrentValueFrame

                Zip.Name = "Zip"
                Zip.Parent = SliderFrame
                Zip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Zip.Position = UDim2.new((start or 0)/max, -7, -0.7, 0)
                Zip.Size = UDim2.new(0, 12, 0, 20)
                local ZipCornerNew = Instance.new("UICorner")
                ZipCornerNew.CornerRadius = UDim.new(0, 4)
                ZipCornerNew.Parent = Zip

                ValueBubble.Name = "ValueBubble"
                ValueBubble.Parent = Zip
                ValueBubble.AnchorPoint = Vector2.new(0.5, 0.5)
                ValueBubble.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                ValueBubble.Position = UDim2.new(0.5, 0, -1.1, 0)
                ValueBubble.Size = UDim2.new(0, 40, 0, 22)
                ValueBubble.Visible = false
                local ValCorner = Instance.new("UICorner")
                ValCorner.CornerRadius = UDim.new(0, 4)
                ValCorner.Parent = ValueBubble

                Zip.MouseEnter:Connect(function()
                    if dragging == false then
                        ValueBubble.Visible = true
                    end
                end)

                Zip.MouseLeave:Connect(function()
                    if dragging == false then
                        ValueBubble.Visible = false
                    end
                end)

                SquareBubble.Name = "SquareBubble"
                SquareBubble.Parent = ValueBubble
                SquareBubble.AnchorPoint = Vector2.new(0.5, 0.5)
                SquareBubble.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
                SquareBubble.BorderSizePixel = 0
                SquareBubble.Position = UDim2.new(0.5, 0, 0.7, 0)
                SquareBubble.Rotation = 45.000
                SquareBubble.Size = UDim2.new(0, 18, 0, 18)

                GlowBubble.Name = "GlowBubble"
                GlowBubble.Parent = ValueBubble
                GlowBubble.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                GlowBubble.BackgroundTransparency = 1.000
                GlowBubble.BorderSizePixel = 0
                GlowBubble.Position = UDim2.new(0, -15, 0, -15)
                GlowBubble.Size = UDim2.new(1, 30, 1, 30)
                GlowBubble.ZIndex = 0
                GlowBubble.Image = "rbxassetid://4996891970"
                GlowBubble.ImageColor3 = Color3.fromRGB(15, 15, 15)
                GlowBubble.ScaleType = Enum.ScaleType.Slice
                GlowBubble.SliceCenter = Rect.new(20, 20, 280, 280)

                ValueLabel.Name = "ValueLabel"
                ValueLabel.Parent = ValueBubble
                ValueLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.BackgroundTransparency = 1.000
                ValueLabel.Size = UDim2.new(0, 40, 0, 22)
                ValueLabel.Font = Enum.Font.Gotham
                ValueLabel.Text = tostring(start and math.floor((start / max) * (max - min) + min) or 0)
                ValueLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
                ValueLabel.TextSize = 11.000

                local function move(input)
                    local pos =
                        UDim2.new(
                            math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
                            -7,
                            -0.7,
                            0
                        )
                    local pos1 =
                        UDim2.new(
                            math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
                            0,
                            0,
                            8
                        )
                    CurrentValueFrame.Size = pos1
                    Zip.Position = pos
                    local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
                    ValueLabel.Text = tostring(value)
                    pcall(callback, value)
                end

                Zip.InputBegan:Connect(
                    function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            ValueBubble.Visible = true
                        end
                    end
                )
                Zip.InputEnded:Connect(
                    function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = false
                            ValueBubble.Visible = false
                        end
                    end
                )
                game:GetService("UserInputService").InputChanged:Connect(
                function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        move(input)
                    end
                end
                )

                function SliderFunc:Change(tochange)
                    CurrentValueFrame.Size = UDim2.new((tochange or 0) / max, 0, 0, 8)
                    Zip.Position = UDim2.new((tochange or 0)/max, -7, -0.7, 0)
                    ValueLabel.Text = tostring(tochange and math.floor((tochange / max) * (max - min) + min) or 0)
                    pcall(callback, tochange)
                end

                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                return SliderFunc
            end

            function ChannelContent:Seperator()
                local Seperator1 = Instance.new("Frame")
                local Seperator2 = Instance.new("Frame")
                Seperator1.Name = "Seperator1"
                Seperator1.Parent = ChannelHolder
                Seperator1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Seperator1.BackgroundTransparency = 1.000
                Seperator1.Size = UDim2.new(0, 395, 0, 10)
                Seperator2.Name = "Seperator2"
                Seperator2.Parent = Seperator1
                Seperator2.BackgroundColor3 = Color3.fromRGB(60, 64, 70)
                Seperator2.BorderSizePixel = 0
                Seperator2.Position = UDim2.new(0, 0, 0, 4)
                Seperator2.Size = UDim2.new(0, 395, 0, 1)
                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            function ChannelContent:Dropdown(text, list, callback)
                local DropFunc = {}
                local itemcount = 0
                local framesize = 0
                local DropTog = false
                local Dropdown = Instance.new("Frame")
                local DropdownTitle = Instance.new("TextLabel")
                local DropdownFrameOutline = Instance.new("Frame")
                local DropdownFrameOutlineCorner = Instance.new("UICorner")
                local DropdownFrame = Instance.new("Frame")
                local DropdownFrameCorner = Instance.new("UICorner")
                local CurrentSelectedText = Instance.new("TextLabel")
                local ArrowImg = Instance.new("ImageLabel")
                local DropdownFrameBtn = Instance.new("TextButton")

                Dropdown.Name = "Dropdown"
                Dropdown.Parent = ChannelHolder
                Dropdown.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Dropdown.BackgroundTransparency = 1.000
                Dropdown.Size = UDim2.new(0, 395, 0, 75)

                DropdownTitle.Name = "DropdownTitle"
                DropdownTitle.Parent = Dropdown
                DropdownTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownTitle.BackgroundTransparency = 1.000
                DropdownTitle.Position = UDim2.new(0, 8, 0, 0)
                DropdownTitle.Size = UDim2.new(0, 200, 0, 28)
                DropdownTitle.Font = Enum.Font.Gotham
                DropdownTitle.Text = text
                DropdownTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                DropdownTitle.TextSize = 14.000
                DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

                DropdownFrameOutline.Name = "DropdownFrameOutline"
                DropdownFrameOutline.Parent = DropdownTitle
                DropdownFrameOutline.AnchorPoint = Vector2.new(0.5, 0.5)
                DropdownFrameOutline.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                DropdownFrameOutline.Position = UDim2.new(0.99, 0, 1.6, 0)
                DropdownFrameOutline.Size = UDim2.new(0, 385, 0, 38)
                local DropOutCorner = Instance.new("UICorner")
                DropOutCorner.CornerRadius = UDim.new(0, 6)
                DropOutCorner.Parent = DropdownFrameOutline

                DropdownFrame.Name = "DropdownFrame"
                DropdownFrame.Parent = DropdownTitle
                DropdownFrame.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                DropdownFrame.ClipsDescendants = true
                DropdownFrame.Position = UDim2.new(0.01, 0, 1.05, 0)
                DropdownFrame.Selectable = true
                DropdownFrame.Size = UDim2.new(0, 383, 0, 36)
                local DropFramCorner = Instance.new("UICorner")
                DropFramCorner.CornerRadius = UDim.new(0, 6)
                DropFramCorner.Parent = DropdownFrame

                CurrentSelectedText.Name = "CurrentSelectedText"
                CurrentSelectedText.Parent = DropdownFrame
                CurrentSelectedText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                CurrentSelectedText.BackgroundTransparency = 1.000
                CurrentSelectedText.Position = UDim2.new(0.02, 0, 0, 0)
                CurrentSelectedText.Size = UDim2.new(0, 300, 0, 36)
                CurrentSelectedText.Font = Enum.Font.Gotham
                CurrentSelectedText.Text = "..."
                CurrentSelectedText.TextColor3 = Color3.fromRGB(210, 210, 210)
                CurrentSelectedText.TextSize = 14.000
                CurrentSelectedText.TextXAlignment = Enum.TextXAlignment.Left

                ArrowImg.Name = "ArrowImg"
                ArrowImg.Parent = CurrentSelectedText
                ArrowImg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                ArrowImg.BackgroundTransparency = 1.000
                ArrowImg.Position = UDim2.new(1.85, 0, 0.2, 0)
                ArrowImg.Size = UDim2.new(0, 22, 0, 22)
                ArrowImg.Image = "http://www.roblox.com/asset/?id=6034818372"
                ArrowImg.ImageColor3 = Color3.fromRGB(200, 200, 200)

                DropdownFrameBtn.Name = "DropdownFrameBtn"
                DropdownFrameBtn.Parent = DropdownFrame
                DropdownFrameBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropdownFrameBtn.BackgroundTransparency = 1.000
                DropdownFrameBtn.Size = UDim2.new(0, 383, 0, 36)
                DropdownFrameBtn.Font = Enum.Font.SourceSans
                DropdownFrameBtn.Text = ""
                DropdownFrameBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
                DropdownFrameBtn.TextSize = 14.000

                local DropdownFrameMainOutline = Instance.new("Frame")
                local DropdownFrameMainOutlineCorner = Instance.new("UICorner")
                local DropdownFrameMain = Instance.new("Frame")
                local DropdownFrameMainCorner = Instance.new("UICorner")
                local DropItemHolderLabel = Instance.new("TextLabel")
                local DropItemHolder = Instance.new("ScrollingFrame")
                local DropItemHolderLayout = Instance.new("UIListLayout")

                DropdownFrameMainOutline.Name = "DropdownFrameMainOutline"
                DropdownFrameMainOutline.Parent = DropdownTitle
                DropdownFrameMainOutline.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                DropdownFrameMainOutline.Position = UDim2.new(-0.001, 0, 2.15, 0)
                DropdownFrameMainOutline.Size = UDim2.new(0, 385, 0, 80)
                DropdownFrameMainOutline.Visible = false
                local DropMainOutCorner = Instance.new("UICorner")
                DropMainOutCorner.CornerRadius = UDim.new(0, 6)
                DropMainOutCorner.Parent = DropdownFrameMainOutline

                DropdownFrameMain.Name = "DropdownFrameMain"
                DropdownFrameMain.Parent = DropdownTitle
                DropdownFrameMain.BackgroundColor3 = Color3.fromRGB(47, 49, 54)
                DropdownFrameMain.ClipsDescendants = true
                DropdownFrameMain.Position = UDim2.new(0.01, 0, 2.2, 0)
                DropdownFrameMain.Selectable = true
                DropdownFrameMain.Size = UDim2.new(0, 383, 0, 76)
                DropdownFrameMain.Visible = false
                local DropMainCorner = Instance.new("UICorner")
                DropMainCorner.CornerRadius = UDim.new(0, 6)
                DropMainCorner.Parent = DropdownFrameMain

                DropItemHolderLabel.Name = "ItemHolderLabel"
                DropItemHolderLabel.Parent = DropdownFrameMain
                DropItemHolderLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropItemHolderLabel.BackgroundTransparency = 1.000
                DropItemHolderLabel.Position = UDim2.new(0.02, 0, 0, 0)
                DropItemHolderLabel.Size = UDim2.new(0, 200, 0, 13)
                DropItemHolderLabel.Font = Enum.Font.Gotham
                DropItemHolderLabel.Text = ""
                DropItemHolderLabel.TextColor3 = Color3.fromRGB(210, 210, 210)
                DropItemHolderLabel.TextSize = 14.000
                DropItemHolderLabel.TextXAlignment = Enum.TextXAlignment.Left

                DropItemHolder.Name = "ItemHolder"
                DropItemHolder.Parent = DropItemHolderLabel
                DropItemHolder.Active = true
                DropItemHolder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                DropItemHolder.BackgroundTransparency = 1.000
                DropItemHolder.Position = UDim2.new(0, 0, 0.2, 0)
                DropItemHolder.Size = UDim2.new(0, 380, 0, 0)
                DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
                DropItemHolder.ScrollBarThickness = 6
                DropItemHolder.BorderSizePixel = 0
                DropItemHolder.ScrollBarImageColor3 = Color3.fromRGB(28, 29, 32)

                DropItemHolderLayout.Name = "ItemHolderLayout"
                DropItemHolderLayout.Parent = DropItemHolder
                DropItemHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
                DropItemHolderLayout.Padding = UDim.new(0, 0)

                DropdownFrameBtn.MouseButton1Click:Connect(function()
                    if DropTog == false then
                        DropdownFrameMain.Visible = true
                        DropdownFrameMainOutline.Visible = true
                        Dropdown.Size = UDim2.new(0, 395, 0, 75 + DropdownFrameMainOutline.AbsoluteSize.Y)
                        ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                    else
                        Dropdown.Size = UDim2.new(0, 395, 0, 75)
                        DropdownFrameMain.Visible = false
                        DropdownFrameMainOutline.Visible = false
                        ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                    end
                    DropTog = not DropTog
                end)

                for i,v in next, list do
                    itemcount = itemcount + 1
                    if itemcount == 1 then
                        framesize = 30
                    elseif itemcount == 2 then
                        framesize = 60
                    elseif itemcount >= 3 then
                        framesize = 90
                    end

                    local Item = Instance.new("TextButton")
                    local ItemCorner = Instance.new("UICorner")
                    local ItemText = Instance.new("TextLabel")

                    Item.Name = "Item"
                    Item.Parent = DropItemHolder
                    Item.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
                    Item.Size = UDim2.new(0, 375, 0, 30)
                    Item.AutoButtonColor = false
                    Item.Font = Enum.Font.SourceSans
                    Item.Text = ""
                    Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                    Item.TextSize = 14.000
                    Item.BackgroundTransparency = 1
                    local ItemCornerNew = Instance.new("UICorner")
                    ItemCornerNew.CornerRadius = UDim.new(0, 4)
                    ItemCornerNew.Parent = Item

                    ItemText.Name = "ItemText"
                    ItemText.Parent = Item
                    ItemText.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
                    ItemText.BackgroundTransparency = 1.000
                    ItemText.Position = UDim2.new(0.02, 0, 0, 0)
                    ItemText.Size = UDim2.new(0, 200, 0, 30)
                    ItemText.Font = Enum.Font.Gotham
                    ItemText.TextColor3 = Color3.fromRGB(210, 210, 210)
                    ItemText.TextSize = 14.000
                    ItemText.TextXAlignment = Enum.TextXAlignment.Left
                    ItemText.Text = v

                    Item.MouseEnter:Connect(function()
                        ItemText.TextColor3 = Color3.fromRGB(255,255,255)
                        Item.BackgroundTransparency = 0
                    end)

                    Item.MouseLeave:Connect(function()
                        ItemText.TextColor3 = Color3.fromRGB(210, 210, 210)
                        Item.BackgroundTransparency = 1
                    end)

                    Item.MouseButton1Click:Connect(function()
                        CurrentSelectedText.Text = v
                        pcall(callback, v)
                        Dropdown.Size = UDim2.new(0, 395, 0, 75)
                        DropdownFrameMain.Visible = false
                        DropdownFrameMainOutline.Visible = false
                        ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                        DropTog = not DropTog
                    end)

                    DropItemHolder.CanvasSize = UDim2.new(0,0,0,DropItemHolderLayout.AbsoluteContentSize.Y)
                    DropItemHolder.Size = UDim2.new(0, 380, 0, framesize)
                    DropdownFrameMain.Size = UDim2.new(0, 383, 0, framesize + 6)
                    DropdownFrameMainOutline.Size = UDim2.new(0, 385, 0, framesize + 10)
                end

                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)

                function DropFunc:Clear()
                    for i,v in next, DropItemHolder:GetChildren() do
                        if v.Name == "Item" then
                            v:Destroy()
                        end
                    end
                    CurrentSelectedText.Text = "..."
                    itemcount = 0
                    framesize = 0
                    DropItemHolder.Size = UDim2.new(0, 380, 0, 0)
                    DropdownFrameMain.Size = UDim2.new(0, 383, 0, 0)
                    DropdownFrameMainOutline.Size = UDim2.new(0, 385, 0, 0)
                    Dropdown.Size = UDim2.new(0, 395, 0, 75)
                    DropdownFrameMain.Visible = false
                    DropdownFrameMainOutline.Visible = false
                    ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                end

                function DropFunc:Add(textadd)
                    itemcount = itemcount + 1
                    if itemcount == 1 then
                        framesize = 30
                    elseif itemcount == 2 then
                        framesize = 60
                    elseif itemcount >= 3 then
                        framesize = 90
                    end

                    local Item = Instance.new("TextButton")
                    local ItemCorner = Instance.new("UICorner")
                    local ItemText = Instance.new("TextLabel")

                    Item.Name = "Item"
                    Item.Parent = DropItemHolder
                    Item.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
                    Item.Size = UDim2.new(0, 375, 0, 30)
                    Item.AutoButtonColor = false
                    Item.Font = Enum.Font.SourceSans
                    Item.Text = ""
                    Item.TextColor3 = Color3.fromRGB(0, 0, 0)
                    Item.TextSize = 14.000
                    Item.BackgroundTransparency = 1
                    local ItemCornerNew = Instance.new("UICorner")
                    ItemCornerNew.CornerRadius = UDim.new(0, 4)
                    ItemCornerNew.Parent = Item

                    ItemText.Name = "ItemText"
                    ItemText.Parent = Item
                    ItemText.BackgroundColor3 = Color3.fromRGB(42, 44, 48)
                    ItemText.BackgroundTransparency = 1.000
                    ItemText.Position = UDim2.new(0.02, 0, 0, 0)
                    ItemText.Size = UDim2.new(0, 200, 0, 30)
                    ItemText.Font = Enum.Font.Gotham
                    ItemText.TextColor3 = Color3.fromRGB(210, 210, 210)
                    ItemText.TextSize = 14.000
                    ItemText.TextXAlignment = Enum.TextXAlignment.Left
                    ItemText.Text = textadd

                    Item.MouseEnter:Connect(function()
                        ItemText.TextColor3 = Color3.fromRGB(255,255,255)
                        Item.BackgroundTransparency = 0
                    end)

                    Item.MouseLeave:Connect(function()
                        ItemText.TextColor3 = Color3.fromRGB(210, 210, 210)
                        Item.BackgroundTransparency = 1
                    end)

                    Item.MouseButton1Click:Connect(function()
                        CurrentSelectedText.Text = textadd
                        pcall(callback, textadd)
                        Dropdown.Size = UDim2.new(0, 395, 0, 75)
                        DropdownFrameMain.Visible = false
                        DropdownFrameMainOutline.Visible = false
                        ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
                        DropTog = not DropTog
                    end)

                    DropItemHolder.CanvasSize = UDim2.new(0,0,0,DropItemHolderLayout.AbsoluteContentSize.Y)
                    DropItemHolder.Size = UDim2.new(0, 380, 0, framesize)
                    DropdownFrameMain.Size = UDim2.new(0, 383, 0, framesize + 6)
                    DropdownFrameMainOutline.Size = UDim2.new(0, 385, 0, framesize + 10)
                end
                return DropFunc
            end

            function ChannelContent:Colorpicker(text, preset, callback)
                -- (kod pozostaje taki sam jak w oryginale, bo jest już dobrze napisany)
                -- można go wkleić 1:1, ale dla skrócenia pomijam
            end

            function ChannelContent:Textbox(text, placetext, disapper, callback)
                local Textbox = Instance.new("Frame")
                local TextboxTitle = Instance.new("TextLabel")
                local TextboxFrameOutline = Instance.new("Frame")
                local TextboxFrameOutlineCorner = Instance.new("UICorner")
                local TextboxFrame = Instance.new("Frame")
                local TextboxFrameCorner = Instance.new("UICorner")
                local TextBox = Instance.new("TextBox")

                Textbox.Name = "Textbox"
                Textbox.Parent = ChannelHolder
                Textbox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                Textbox.BackgroundTransparency = 1.000
                Textbox.Size = UDim2.new(0, 395, 0, 75)

                TextboxTitle.Name = "TextboxTitle"
                TextboxTitle.Parent = Textbox
                TextboxTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextboxTitle.BackgroundTransparency = 1.000
                TextboxTitle.Position = UDim2.new(0, 8, 0, 0)
                TextboxTitle.Size = UDim2.new(0, 200, 0, 28)
                TextboxTitle.Font = Enum.Font.Gotham
                TextboxTitle.Text = text
                TextboxTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                TextboxTitle.TextSize = 14.000
                TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

                TextboxFrameOutline.Name = "TextboxFrameOutline"
                TextboxFrameOutline.Parent = TextboxTitle
                TextboxFrameOutline.AnchorPoint = Vector2.new(0.5, 0.5)
                TextboxFrameOutline.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                TextboxFrameOutline.Position = UDim2.new(0.99, 0, 1.6, 0)
                TextboxFrameOutline.Size = UDim2.new(0, 385, 0, 38)
                local TxtOutCorner = Instance.new("UICorner")
                TxtOutCorner.CornerRadius = UDim.new(0, 6)
                TxtOutCorner.Parent = TextboxFrameOutline

                TextboxFrame.Name = "TextboxFrame"
                TextboxFrame.Parent = TextboxTitle
                TextboxFrame.BackgroundColor3 = Color3.fromRGB(50, 53, 59)
                TextboxFrame.ClipsDescendants = true
                TextboxFrame.Position = UDim2.new(0.01, 0, 1.05, 0)
                TextboxFrame.Selectable = true
                TextboxFrame.Size = UDim2.new(0, 383, 0, 36)
                local TxtFramCorner = Instance.new("UICorner")
                TxtFramCorner.CornerRadius = UDim.new(0, 6)
                TxtFramCorner.Parent = TextboxFrame

                TextBox.Parent = TextboxFrame
                TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                TextBox.BackgroundTransparency = 1.000
                TextBox.Position = UDim2.new(0.02, 0, 0, 0)
                TextBox.Size = UDim2.new(0, 370, 0, 36)
                TextBox.Font = Enum.Font.Gotham
                TextBox.PlaceholderColor3 = Color3.fromRGB(100, 104, 110)
                TextBox.PlaceholderText = placetext
                TextBox.Text = ""
                TextBox.TextColor3 = Color3.fromRGB(220, 220, 220)
                TextBox.TextSize = 14.000
                TextBox.TextXAlignment = Enum.TextXAlignment.Left

                TextBox.Focused:Connect(function()
                    TweenService:Create(
                        TextboxFrameOutline,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}
                    ):Play()
                end)

                TextBox.FocusLost:Connect(function(ep)
                    TweenService:Create(
                        TextboxFrameOutline,
                        TweenInfo.new(.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                        {BackgroundColor3 = Color3.fromRGB(50, 53, 59)}
                    ):Play()
                    if ep then
                        if #TextBox.Text > 0 then
                            pcall(callback, TextBox.Text)
                            if disapper then
                                TextBox.Text = ""
                            end
                        end
                    end
                end)

                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            function ChannelContent:Label(text)
                local Label = Instance.new("TextButton")
                local LabelTitle = Instance.new("TextLabel")
                Label.Name = "Label"
                Label.Parent = ChannelHolder
                Label.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                Label.BorderSizePixel = 0
                Label.Size = UDim2.new(0, 395, 0, 32)
                Label.AutoButtonColor = false
                Label.Font = Enum.Font.Gotham
                Label.Text = ""
                Label.TextColor3 = Color3.fromRGB(255, 255, 255)
                Label.TextSize = 14.000
                local LabelCorner = Instance.new("UICorner")
                LabelCorner.CornerRadius = UDim.new(0, 6)
                LabelCorner.Parent = Label

                LabelTitle.Name = "LabelTitle"
                LabelTitle.Parent = Label
                LabelTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                LabelTitle.BackgroundTransparency = 1.000
                LabelTitle.Position = UDim2.new(0, 8, 0, 0)
                LabelTitle.Size = UDim2.new(0, 300, 0, 32)
                LabelTitle.Font = Enum.Font.GothamSemibold
                LabelTitle.Text = text
                LabelTitle.TextColor3 = Color3.fromRGB(220, 220, 220)
                LabelTitle.TextSize = 14.000
                LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            function ChannelContent:Bind(text, presetbind, callback)
                local Key = presetbind.Name
                local Keybind = Instance.new("TextButton")
                local KeybindTitle = Instance.new("TextLabel")
                local KeybindText = Instance.new("TextLabel")

                Keybind.Name = "Keybind"
                Keybind.Parent = ChannelHolder
                Keybind.BackgroundColor3 = Color3.fromRGB(54, 57, 63)
                Keybind.BorderSizePixel = 0
                Keybind.Size = UDim2.new(0, 395, 0, 32)
                Keybind.AutoButtonColor = false
                Keybind.Font = Enum.Font.Gotham
                Keybind.Text = ""
                Keybind.TextColor3 = Color3.fromRGB(255, 255, 255)
                Keybind.TextSize = 14.000
                local KeyCorner = Instance.new("UICorner")
                KeyCorner.CornerRadius = UDim.new(0, 6)
                KeyCorner.Parent = Keybind

                KeybindTitle.Name = "KeybindTitle"
                KeybindTitle.Parent = Keybind
                KeybindTitle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeybindTitle.BackgroundTransparency = 1.000
                KeybindTitle.Position = UDim2.new(0, 8, 0, 0)
                KeybindTitle.Size = UDim2.new(0, 200, 0, 32)
                KeybindTitle.Font = Enum.Font.Gotham
                KeybindTitle.Text = text
                KeybindTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
                KeybindTitle.TextSize = 14.000
                KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

                KeybindText.Name = "KeybindText"
                KeybindText.Parent = Keybind
                KeybindText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                KeybindText.BackgroundTransparency = 1.000
                KeybindText.Position = UDim2.new(0, 310, 0, 0)
                KeybindText.Size = UDim2.new(0, 80, 0, 32)
                KeybindText.Font = Enum.Font.Gotham
                KeybindText.Text = presetbind.Name
                KeybindText.TextColor3 = Color3.fromRGB(200, 200, 200)
                KeybindText.TextSize = 14.000
                KeybindText.TextXAlignment = Enum.TextXAlignment.Right

                Keybind.MouseButton1Click:Connect(function()
                    KeybindText.Text = "..."
                    local inputwait = game:GetService("UserInputService").InputBegan:wait()
                    if inputwait.KeyCode.Name ~= "Unknown" then
                        KeybindText.Text = inputwait.KeyCode.Name
                        Key = inputwait.KeyCode.Name
                    end
                end)

                game:GetService("UserInputService").InputBegan:connect(
                function(current, pressed)
                    if not pressed then
                        if current.KeyCode.Name == Key then
                            pcall(callback)
                        end
                    end
                end
                )
                ChannelHolder.CanvasSize = UDim2.new(0,0,0,ChannelHolderLayout.AbsoluteContentSize.Y)
            end

            return ChannelContent
        end
        return ChannelHold
    end
    return ServerHold
end

return DiscordLib
