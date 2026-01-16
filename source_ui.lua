--[[ 
    NEXUSFLOW UI LIBRARY - SOURCE MODULE (v16.0 Clean Profile)
    Designed for: Dita Setia Hermawan
    
    Update:
    - Removed "Architect" Role text from Profile.
    - Simplified Title.
    - Centered Username in Sidebar.
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")

local NexusFlow = {}
local UI_Connections = {}

-- // THEME CONFIGURATION
NexusFlow.Themes = {
    Dark = {
        Main = Color3.fromRGB(20, 20, 24),
        Sidebar = Color3.fromRGB(26, 26, 32),
        Content = Color3.fromRGB(22, 22, 28),
        Accent = Color3.fromRGB(90, 180, 255),
        Text = Color3.fromRGB(245, 245, 245),
        SubText = Color3.fromRGB(160, 160, 160),
        Stroke = Color3.fromRGB(50, 50, 60),
        Hover = Color3.fromRGB(35, 35, 42),
    },
    Midnight = {
        Main = Color3.fromRGB(10, 10, 14),
        Sidebar = Color3.fromRGB(16, 16, 22),
        Content = Color3.fromRGB(12, 12, 18),
        Accent = Color3.fromRGB(120, 100, 255),
        Text = Color3.fromRGB(230, 230, 255),
        SubText = Color3.fromRGB(120, 120, 160),
        Stroke = Color3.fromRGB(40, 40, 55),
        Hover = Color3.fromRGB(25, 25, 35),
    },
    Blueprint = {
        Main = Color3.fromRGB(15, 25, 40),
        Sidebar = Color3.fromRGB(20, 35, 55),
        Content = Color3.fromRGB(25, 40, 60),
        Accent = Color3.fromRGB(50, 150, 255),
        Text = Color3.fromRGB(240, 250, 255),
        SubText = Color3.fromRGB(150, 180, 210),
        Stroke = Color3.fromRGB(60, 90, 120),
        Hover = Color3.fromRGB(30, 50, 80),
    },
    Ocean = {
        Main = Color3.fromRGB(15, 20, 25),
        Sidebar = Color3.fromRGB(20, 30, 35),
        Content = Color3.fromRGB(25, 35, 40),
        Accent = Color3.fromRGB(0, 200, 200),
        Text = Color3.fromRGB(240, 255, 255),
        SubText = Color3.fromRGB(130, 160, 160),
        Stroke = Color3.fromRGB(40, 60, 70),
        Hover = Color3.fromRGB(30, 45, 50),
    },
    Cherry = {
        Main = Color3.fromRGB(25, 15, 15),
        Sidebar = Color3.fromRGB(35, 20, 20),
        Content = Color3.fromRGB(30, 20, 20),
        Accent = Color3.fromRGB(255, 80, 80),
        Text = Color3.fromRGB(255, 240, 240),
        SubText = Color3.fromRGB(180, 130, 130),
        Stroke = Color3.fromRGB(70, 40, 40),
        Hover = Color3.fromRGB(50, 30, 30),
    },
    Serpent = {
        Main = Color3.fromRGB(15, 20, 15),
        Sidebar = Color3.fromRGB(20, 28, 20),
        Content = Color3.fromRGB(22, 32, 22),
        Accent = Color3.fromRGB(80, 220, 120),
        Text = Color3.fromRGB(240, 255, 240),
        SubText = Color3.fromRGB(130, 160, 130),
        Stroke = Color3.fromRGB(40, 70, 40),
        Hover = Color3.fromRGB(30, 45, 30),
    },
    Amethyst = {
        Main = Color3.fromRGB(20, 15, 25),
        Sidebar = Color3.fromRGB(30, 20, 40),
        Content = Color3.fromRGB(28, 22, 38),
        Accent = Color3.fromRGB(180, 100, 255),
        Text = Color3.fromRGB(250, 240, 255),
        SubText = Color3.fromRGB(160, 130, 180),
        Stroke = Color3.fromRGB(70, 50, 90),
        Hover = Color3.fromRGB(45, 30, 60),
    },
    Concrete = {
        Main = Color3.fromRGB(30, 30, 30),
        Sidebar = Color3.fromRGB(38, 38, 38),
        Content = Color3.fromRGB(35, 35, 35),
        Accent = Color3.fromRGB(200, 200, 200),
        Text = Color3.fromRGB(255, 255, 255),
        SubText = Color3.fromRGB(150, 150, 150),
        Stroke = Color3.fromRGB(80, 80, 80),
        Hover = Color3.fromRGB(50, 50, 50),
    }
}
NexusFlow.CurrentTheme = NexusFlow.Themes.Dark
local ThemeObjects = {}

-- // UTILITY
local function RegisterThemeObj(obj, prop, key)
    table.insert(ThemeObjects, {Object = obj, Property = prop, Key = key})
    obj[prop] = NexusFlow.CurrentTheme[key]
end

local function UpdateAllThemes(ThemeName)
    local NewTheme = NexusFlow.Themes[ThemeName] or NexusFlow.Themes.Dark
    NexusFlow.CurrentTheme = NewTheme
    for _, data in pairs(ThemeObjects) do
        if data.Object and data.Object.Parent then
            TweenService:Create(data.Object, TweenInfo.new(0.4), {[data.Property] = NewTheme[data.Key]}):Play()
        end
    end
end

local function Create(class, props)
    local inst = Instance.new(class)
    for k,v in pairs(props) do inst[k] = v end
    return inst
end

local function MakeDraggable(topbar, main)
    local dragging, dragStart, startPos
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(main, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- // NOTIFICATION
local NotifyFunc = nil
local function SetupNotifications(ScreenGui)
    local NotifContainer = Create("Frame", {
        Parent = ScreenGui, BackgroundTransparency = 1, Position = UDim2.new(1, -20, 1, -20),
        Size = UDim2.new(0, 300, 1, 0), AnchorPoint = Vector2.new(1, 1), ZIndex = 100
    })
    local List = Create("UIListLayout", {
        Parent = NotifContainer, SortOrder = Enum.SortOrder.LayoutOrder, 
        VerticalAlignment = Enum.VerticalAlignment.Bottom, Padding = UDim.new(0, 8)
    })

    NotifyFunc = function(Title, Text, Duration)
        local Frame = Create("Frame", {
            Parent = NotifContainer, BackgroundColor3 = NexusFlow.CurrentTheme.Main,
            Size = UDim2.new(0, 0, 0, 0), ClipsDescendants = true, BorderSizePixel = 0
        })
        RegisterThemeObj(Frame, "BackgroundColor3", "Main")
        Create("UICorner", {Parent = Frame, CornerRadius = UDim.new(0, 6)})
        local Stroke = Create("UIStroke", {Parent = Frame, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1})
        RegisterThemeObj(Stroke, "Color", "Stroke")

        local TTitle = Create("TextLabel", {
            Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 8),
            Size = UDim2.new(1, -24, 0, 18), Text = Title, Font = Enum.Font.GothamBold,
            TextSize = 13, TextColor3 = NexusFlow.CurrentTheme.Accent, TextXAlignment = Enum.TextXAlignment.Left
        })
        RegisterThemeObj(TTitle, "TextColor3", "Accent")

        local TText = Create("TextLabel", {
            Parent = Frame, BackgroundTransparency = 1, Position = UDim2.new(0, 12, 0, 26),
            Size = UDim2.new(1, -24, 0, 24), Text = Text, Font = Enum.Font.Gotham,
            TextSize = 12, TextColor3 = NexusFlow.CurrentTheme.Text, TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true
        })
        RegisterThemeObj(TText, "TextColor3", "Text")

        Frame.Size = UDim2.new(1, 0, 0, 0)
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(1, 0, 0, 60)}):Play()

        task.delay(Duration or 3, function()
            if Frame then
                TweenService:Create(Frame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1}):Play()
                TweenService:Create(TTitle, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                TweenService:Create(TText, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
                TweenService:Create(Stroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
                wait(0.3)
                Frame:Destroy()
            end
        end)
    end
end

-- // WINDOW CREATION
function NexusFlow:CreateWindow(Config)
    if game.CoreGui:FindFirstChild("NexusFlow_Main") then game.CoreGui.NexusFlow_Main:Destroy() end

    local ScreenGui = Create("ScreenGui", {Name = "NexusFlow_Main", Parent = CoreGui, ZIndexBehavior = Enum.ZIndexBehavior.Sibling})
    SetupNotifications(ScreenGui)

    -- Floating Logo
    local FloatingBtn = Create("ImageButton", {
        Parent = ScreenGui, BackgroundColor3 = NexusFlow.CurrentTheme.Main,
        Position = UDim2.new(0.1, 0, 0.1, 0), Size = UDim2.new(0, 40, 0, 40),
        Image = Config.Icon or "rbxassetid://13350795556", Visible = false, Active = true
    })
    RegisterThemeObj(FloatingBtn, "BackgroundColor3", "Main")
    RegisterThemeObj(FloatingBtn, "ImageColor3", "Accent")
    Create("UICorner", {Parent = FloatingBtn, CornerRadius = UDim.new(0, 12)})
    local FloatStroke = Create("UIStroke", {Parent = FloatingBtn, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1.5})
    RegisterThemeObj(FloatStroke, "Color", "Accent")
    MakeDraggable(FloatingBtn, FloatingBtn)

    -- Main Window
    local Shadow = Create("ImageLabel", {
        Parent = ScreenGui, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0), Size = UDim2.new(0, 650, 0, 450), 
        Image = "rbxassetid://6014261993", ImageColor3 = Color3.new(0,0,0), ImageTransparency = 0.5,
        ScaleType = Enum.ScaleType.Slice, SliceCenter = Rect.new(49, 49, 450, 450)
    })

    local MainFrame = Create("Frame", {
        Parent = Shadow, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = UDim2.new(0, 630, 0, 430), BorderSizePixel = 0, ClipsDescendants = true
    })
    RegisterThemeObj(MainFrame, "BackgroundColor3", "Main")
    Create("UICorner", {Parent = MainFrame, CornerRadius = UDim.new(0, 10)})
    
    -- Visuals
    local BgHolder = Create("Frame", {Parent = MainFrame, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, ZIndex = 1})
    local GridPattern = Create("ImageLabel", {
        Parent = BgHolder, BackgroundTransparency = 1, Size = UDim2.new(0, 800, 0, 600),
        Image = "rbxassetid://6031097239", ImageTransparency = 0.96, ImageColor3 = NexusFlow.CurrentTheme.SubText,
        ScaleType = Enum.ScaleType.Tile, TileSize = UDim2.new(0, 40, 0, 40)
    })
    RegisterThemeObj(GridPattern, "ImageColor3", "SubText")
    local Vignette = Create("ImageLabel", {
        Parent = BgHolder, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0),
        Image = "rbxassetid://4576475446", ImageTransparency = 0.5, ImageColor3 = NexusFlow.CurrentTheme.Main, ZIndex = 2
    })
    RegisterThemeObj(Vignette, "ImageColor3", "Main")
    task.spawn(function()
        local Connection
        Connection = RunService.RenderStepped:Connect(function()
            if not GridPattern.Parent then Connection:Disconnect() return end
            local Time = tick() * 10
            GridPattern.Position = UDim2.new(0, - (Time % 40), 0, - (Time % 40))
        end)
    end)

    local MainStroke = Create("UIStroke", {Parent = MainFrame, Thickness = 1, Transparency = 0.1})
    RegisterThemeObj(MainStroke, "Color", "Stroke")

    -- Sidebar
    local Sidebar = Create("Frame", {
        Parent = MainFrame, BackgroundColor3 = NexusFlow.CurrentTheme.Sidebar,
        Size = UDim2.new(0, 180, 1, 0), BorderSizePixel = 0, ZIndex = 3
    })
    RegisterThemeObj(Sidebar, "BackgroundColor3", "Sidebar")
    local SidebarStroke = Create("UIStroke", {Parent = Sidebar, Thickness = 1, Transparency = 0.6})
    RegisterThemeObj(SidebarStroke, "Color", "Stroke")

    -- Profile (UPDATED: Role Removed, Name Centered)
    local ProfileFrame = Create("Frame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 1, -50), Size = UDim2.new(1, 0, 0, 50)
    })
    local ProfileImg = Create("ImageLabel", {
        Parent = ProfileFrame, BackgroundColor3 = NexusFlow.CurrentTheme.SubText,
        Position = UDim2.new(0, 12, 0.5, -15), Size = UDim2.new(0, 30, 0, 30)
    })
    Create("UICorner", {Parent = ProfileImg, CornerRadius = UDim.new(1, 0)})
    task.spawn(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        ProfileImg.Image = content
    end)
    local PName = Create("TextLabel", {
        Parent = ProfileFrame, 
        BackgroundTransparency = 1, 
        Position = UDim2.new(0, 50, 0.5, 0), -- Centered vertically
        AnchorPoint = Vector2.new(0, 0.5), -- Anchor point center
        Size = UDim2.new(0, 100, 0, 16), 
        Text = LocalPlayer.DisplayName, 
        Font = Enum.Font.GothamBold,
        TextSize = 13, 
        TextXAlignment = Enum.TextXAlignment.Left, 
        TextColor3 = NexusFlow.CurrentTheme.Text
    })
    RegisterThemeObj(PName, "TextColor3", "Text")
    
    -- [REMOVED] PRole (Architect text removed)

    -- Title
    local TitleLabel = Create("TextLabel", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 15, 0, 20),
        Size = UDim2.new(1, -15, 0, 20), 
        Text = Config.Title or "NEXUSFLOW", -- Default Title
        Font = Enum.Font.GothamBlack, TextSize = 16, TextColor3 = NexusFlow.CurrentTheme.Text,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    RegisterThemeObj(TitleLabel, "TextColor3", "Text")

    -- Tab Container
    local TabScroll = Create("ScrollingFrame", {
        Parent = Sidebar, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 60),
        Size = UDim2.new(1, 0, 1, -110), ScrollBarThickness = 0, CanvasSize = UDim2.new(0,0,0,0)
    })
    local TabList = Create("UIListLayout", {
        Parent = TabScroll, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder,
        HorizontalAlignment = Enum.HorizontalAlignment.Center
    })
    Create("UIPadding", {Parent = TabScroll, PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10)})
    TabList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabScroll.CanvasSize = UDim2.new(0,0,0,TabList.AbsoluteContentSize.Y + 16) end)

    -- Content
    local Content = Create("Frame", {
        Parent = MainFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 180, 0, 0),
        Size = UDim2.new(1, -180, 1, 0), ClipsDescendants = true, ZIndex = 3
    })
    
    local TopBar = Create("Frame", {Parent = Content, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 36)})
    MakeDraggable(TopBar, Shadow)
    
    local CloseBtn = Create("ImageButton", {
        Parent = TopBar, BackgroundTransparency = 1, Size = UDim2.new(0, 18, 0, 18),
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -10, 0.5, 0),
        Image = "rbxassetid://6031094678", ImageColor3 = NexusFlow.CurrentTheme.SubText
    })
    RegisterThemeObj(CloseBtn, "ImageColor3", "SubText")
    
    local MinimizeBtn = Create("ImageButton", {
        Parent = TopBar, BackgroundTransparency = 1, Size = UDim2.new(0, 18, 0, 18),
        AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -35, 0.5, 0),
        Image = "rbxassetid://6031094670", ImageColor3 = NexusFlow.CurrentTheme.SubText
    })
    RegisterThemeObj(MinimizeBtn, "ImageColor3", "SubText")
    
    -- Actions
    CloseBtn.MouseButton1Click:Connect(function()
        NotifyFunc("System", "Unloading NexusFlow...", 1.5)
        local RollTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 630, 0, 0)})
        TweenService:Create(Shadow, TweenInfo.new(0.5), {ImageTransparency = 1}):Play()
        RollTween:Play()
        task.wait(1.5)
        ScreenGui:Destroy()
    end)
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        local RollTween = TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 630, 0, 0)})
        TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        RollTween:Play()
        RollTween.Completed:Wait()
        Shadow.Visible = false
        FloatingBtn.Size = UDim2.new(0,0,0,0)
        FloatingBtn.Visible = true
        TweenService:Create(FloatingBtn, TweenInfo.new(0.4, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0,40,0,40)}):Play()
    end)
    
    FloatingBtn.MouseButton1Click:Connect(function()
        TweenService:Create(FloatingBtn, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0)}):Play()
        wait(0.2)
        FloatingBtn.Visible = false
        Shadow.Visible = true
        TweenService:Create(Shadow, TweenInfo.new(0.3), {ImageTransparency = 0.5}):Play()
        MainFrame.Size = UDim2.new(0, 630, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 630, 0, 430)}):Play()
    end)

    local Pages = Create("Frame", {
        Parent = Content, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 40),
        Size = UDim2.new(1, 0, 1, -40)
    })

    -- // FUNCTIONS
    local Win = {}
    local CurrentTab = nil

    function Win:CreateTab(Name)
        local Tab = {Left = {}, Right = {}}
        local Btn = Create("TextButton", {Parent = TabScroll, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), Text = "", AutoButtonColor = false})
        Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 6)})
        local Lbl = Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -10, 1, 0), Text = Name, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = NexusFlow.CurrentTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left})
        RegisterThemeObj(Lbl, "TextColor3", "SubText")
        local ActiveLine = Create("Frame", {Parent = Btn, BackgroundColor3 = NexusFlow.CurrentTheme.Accent, Position = UDim2.new(0, 0, 0.5, -6), Size = UDim2.new(0, 2, 0, 12), Transparency = 1})
        RegisterThemeObj(ActiveLine, "BackgroundColor3", "Accent")
        Create("UICorner", {Parent = ActiveLine, CornerRadius = UDim.new(1,0)})
        local Page = Create("ScrollingFrame", {Parent = Pages, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 1, 0), Visible = false, ScrollBarThickness = 2, CanvasSize = UDim2.new(0,0,0,0)})
        RegisterThemeObj(Page, "ScrollBarImageColor3", "Accent")
        local LeftCol = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 10), Size = UDim2.new(0.5, -15, 1, -20)})
        local LeftList = Create("UIListLayout", {Parent = LeftCol, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
        local RightCol = Create("Frame", {Parent = Page, BackgroundTransparency = 1, Position = UDim2.new(0.5, 5, 0, 10), Size = UDim2.new(0.5, -15, 1, -20)})
        local RightList = Create("UIListLayout", {Parent = RightCol, Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder})
        local function UpdateCanvas() Page.CanvasSize = UDim2.new(0,0,0, math.max(LeftList.AbsoluteContentSize.Y, RightList.AbsoluteContentSize.Y) + 20) end
        LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
        local function Activate()
            if CurrentTab == Btn then return end
            if CurrentTab then
                TweenService:Create(CurrentTab, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                TweenService:Create(CurrentTab.TextLabel, TweenInfo.new(0.3), {TextColor3 = NexusFlow.CurrentTheme.SubText}):Play()
                TweenService:Create(CurrentTab.Frame, TweenInfo.new(0.3), {Transparency = 1}):Play()
                for _,v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end
            end
            CurrentTab = Btn
            Page.Visible = true
            TweenService:Create(Btn, TweenInfo.new(0.3), {BackgroundColor3 = NexusFlow.CurrentTheme.Hover, BackgroundTransparency = 0}):Play()
            TweenService:Create(Lbl, TweenInfo.new(0.3), {TextColor3 = NexusFlow.CurrentTheme.Text}):Play()
            TweenService:Create(ActiveLine, TweenInfo.new(0.3), {Transparency = 0}):Play()
        end
        Btn.MouseButton1Click:Connect(Activate)
        if not CurrentTab then Activate() end

        local function CreateFunctions(Container, TargetObj)
            function TargetObj:CreateSection(Text)
                local Cont = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 24)})
                local Txt = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(0, 2, 0, 4), Size = UDim2.new(1, -4, 1, -4), Text = Text, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = NexusFlow.CurrentTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left})
                RegisterThemeObj(Txt, "TextColor3", "SubText")
                local Line = Create("Frame", {Parent = Cont, BackgroundColor3 = NexusFlow.CurrentTheme.Stroke, Position = UDim2.new(0, 0, 1, -2), Size = UDim2.new(1, 0, 0, 1)})
                RegisterThemeObj(Line, "BackgroundColor3", "Stroke")
            end
            function TargetObj:CreateLabel(Text)
                local Cont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 28)})
                RegisterThemeObj(Cont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = Cont, CornerRadius = UDim.new(0, 6)})
                local Str = Create("UIStroke", {Parent = Cont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(Str, "Color", "Stroke")
                local Lbl = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -20, 1, 0), Text = Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = NexusFlow.CurrentTheme.Text, TextXAlignment = Enum.TextXAlignment.Left})
                RegisterThemeObj(Lbl, "TextColor3", "Text")
            end
            function TargetObj:CreateButton(Text, Callback)
                local Cont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 32)})
                RegisterThemeObj(Cont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = Cont, CornerRadius = UDim.new(0, 6)})
                local Str = Create("UIStroke", {Parent = Cont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(Str, "Color", "Stroke")
                local B = Create("TextButton", {Parent = Cont, BackgroundTransparency = 1, Size = UDim2.new(1,0,1,0), Text = Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextColor3 = NexusFlow.CurrentTheme.Text})
                RegisterThemeObj(B, "TextColor3", "Text")
                B.MouseEnter:Connect(function() TweenService:Create(Str, TweenInfo.new(0.2), {Color = NexusFlow.CurrentTheme.Accent, Transparency = 0}):Play() end)
                B.MouseLeave:Connect(function() TweenService:Create(Str, TweenInfo.new(0.2), {Color = NexusFlow.CurrentTheme.Stroke, Transparency = 0.5}):Play() end)
                B.MouseButton1Click:Connect(function() Callback() TweenService:Create(Cont, TweenInfo.new(0.1), {Size = UDim2.new(1, -4, 0, 30)}):Play() wait(0.1) TweenService:Create(Cont, TweenInfo.new(0.1), {Size = UDim2.new(1, 0, 0, 32)}):Play() end)
            end
            function TargetObj:CreateToggle(Text, Default, Callback)
                local Enabled = Default or false
                local Cont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 32)})
                RegisterThemeObj(Cont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = Cont, CornerRadius = UDim.new(0, 6)})
                local Str = Create("UIStroke", {Parent = Cont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(Str, "Color", "Stroke")
                local Lbl = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -50, 1, 0), Text = Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = NexusFlow.CurrentTheme.Text})
                RegisterThemeObj(Lbl, "TextColor3", "Text")
                local SwitchBg = Create("Frame", {Parent = Cont, Position = UDim2.new(1, -36, 0.5, -9), Size = UDim2.new(0, 30, 0, 18), BackgroundColor3 = Enabled and NexusFlow.CurrentTheme.Accent or Color3.fromRGB(50,50,50)})
                Create("UICorner", {Parent = SwitchBg, CornerRadius = UDim.new(1,0)})
                local Circle = Create("Frame", {Parent = SwitchBg, Position = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7), Size = UDim2.new(0, 14, 0, 14), BackgroundColor3 = Color3.fromRGB(255,255,255)})
                Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1,0)})
                local Btn = Create("TextButton", {Parent = Cont, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
                Btn.MouseButton1Click:Connect(function() Enabled = not Enabled Callback(Enabled) local TargetPos = Enabled and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7) local TargetCol = Enabled and NexusFlow.CurrentTheme.Accent or Color3.fromRGB(50,50,50) TweenService:Create(Circle, TweenInfo.new(0.2), {Position = TargetPos}):Play() TweenService:Create(SwitchBg, TweenInfo.new(0.2), {BackgroundColor3 = TargetCol}):Play() end)
            end
            function TargetObj:CreateSlider(Text, Min, Max, Default, Callback)
                local Value = Default or Min
                local Cont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 44)})
                RegisterThemeObj(Cont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = Cont, CornerRadius = UDim.new(0, 6)})
                local Str = Create("UIStroke", {Parent = Cont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(Str, "Color", "Stroke")
                local Lbl = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 5), Size = UDim2.new(1, -30, 0, 16), Text = Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = NexusFlow.CurrentTheme.Text})
                RegisterThemeObj(Lbl, "TextColor3", "Text")
                local ValLbl = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(1, -40, 0, 5), Size = UDim2.new(0, 30, 0, 16), Text = tostring(Value), Font = Enum.Font.GothamBold, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Right, TextColor3 = NexusFlow.CurrentTheme.Accent})
                RegisterThemeObj(ValLbl, "TextColor3", "Accent")
                local SliderBar = Create("Frame", {Parent = Cont, BackgroundColor3 = Color3.fromRGB(50,50,50), Position = UDim2.new(0, 10, 0, 28), Size = UDim2.new(1, -20, 0, 3)})
                Create("UICorner", {Parent = SliderBar, CornerRadius = UDim.new(1,0)})
                local Fill = Create("Frame", {Parent = SliderBar, BackgroundColor3 = NexusFlow.CurrentTheme.Accent, Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)})
                RegisterThemeObj(Fill, "BackgroundColor3", "Accent")
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})
                local Btn = Create("TextButton", {Parent = SliderBar, Size = UDim2.new(1,0,1,0), BackgroundTransparency = 1, Text = ""})
                local Dragging = false
                Btn.MouseButton1Down:Connect(function() Dragging = true end)
                UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then Dragging = false end end)
                UserInputService.InputChanged:Connect(function(input) if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local MousePos = UserInputService:GetMouseLocation().X local RelPos = MousePos - SliderBar.AbsolutePosition.X local Percent = math.clamp(RelPos / SliderBar.AbsoluteSize.X, 0, 1) Value = math.floor(Min + (Max - Min) * Percent) ValLbl.Text = tostring(Value) TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(Percent, 0, 1, 0)}):Play() Callback(Value) end end)
            end
            function TargetObj:CreateDropdown(Text, Options, Callback)
                local Dropped = false
                local DropCont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 32), ClipsDescendants = true})
                RegisterThemeObj(DropCont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = DropCont, CornerRadius = UDim.new(0, 6)})
                local Str = Create("UIStroke", {Parent = DropCont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(Str, "Color", "Stroke")
                local Btn = Create("TextButton", {Parent = DropCont, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 32), Text = "", AutoButtonColor = false})
                local Lbl = Create("TextLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 0), Size = UDim2.new(1, -30, 1, 0), Text = Text, Font = Enum.Font.GothamMedium, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = NexusFlow.CurrentTheme.Text})
                RegisterThemeObj(Lbl, "TextColor3", "Text")
                local Icon = Create("ImageLabel", {Parent = Btn, BackgroundTransparency = 1, Position = UDim2.new(1, -25, 0.5, -8), Size = UDim2.new(0, 16, 0, 16), Image = "rbxassetid://6031090990", ImageColor3 = NexusFlow.CurrentTheme.SubText})
                RegisterThemeObj(Icon, "ImageColor3", "SubText")
                local ListFrame = Create("ScrollingFrame", {Parent = DropCont, BackgroundTransparency = 1, Position = UDim2.new(0, 0, 0, 32), Size = UDim2.new(1, 0, 1, -32), CanvasSize = UDim2.new(0,0,0,0), ScrollBarThickness = 2})
                RegisterThemeObj(ListFrame, "ScrollBarImageColor3", "Accent")
                local listLayout = Create("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 4)})
                Create("UIPadding", {Parent = ListFrame, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), PaddingTop = UDim.new(0, 4)})
                local function RefreshList() for _,v in pairs(ListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for _, opt in pairs(Options) do local OptBtn = Create("TextButton", {Parent = ListFrame, BackgroundColor3 = NexusFlow.CurrentTheme.Main, Size = UDim2.new(1, 0, 0, 26), Text = opt, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = NexusFlow.CurrentTheme.SubText}) RegisterThemeObj(OptBtn, "BackgroundColor3", "Main") RegisterThemeObj(OptBtn, "TextColor3", "SubText") Create("UICorner", {Parent = OptBtn, CornerRadius = UDim.new(0, 4)}) OptBtn.MouseButton1Click:Connect(function() Dropped = false Lbl.Text = Text .. " : " .. opt Callback(opt) TweenService:Create(DropCont, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 32)}):Play() TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = 0}):Play() end) end ListFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y + 8) end RefreshList()
                Btn.MouseButton1Click:Connect(function() Dropped = not Dropped local TargetHeight = Dropped and math.min(130, listLayout.AbsoluteContentSize.Y + 40) or 32 TweenService:Create(DropCont, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, TargetHeight)}):Play() TweenService:Create(Icon, TweenInfo.new(0.3), {Rotation = Dropped and 180 or 0}):Play() end)
            end
            function TargetObj:CreateInput(Text, Placeholder, Callback)
                local Cont = Create("Frame", {Parent = Container, BackgroundColor3 = NexusFlow.CurrentTheme.Content, BackgroundTransparency = 0.2, Size = UDim2.new(1, 0, 0, 50)})
                RegisterThemeObj(Cont, "BackgroundColor3", "Content")
                Create("UICorner", {Parent = Cont, CornerRadius = UDim.new(0, 6)})
                local ContStroke = Create("UIStroke", {Parent = Cont, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.8})
                RegisterThemeObj(ContStroke, "Color", "Stroke")
                local Lbl = Create("TextLabel", {Parent = Cont, BackgroundTransparency = 1, Position = UDim2.new(0, 10, 0, 4), Size = UDim2.new(1, -20, 0, 14), Text = Text, Font = Enum.Font.GothamBold, TextSize = 10, TextXAlignment = Enum.TextXAlignment.Left, TextColor3 = NexusFlow.CurrentTheme.SubText})
                RegisterThemeObj(Lbl, "TextColor3", "SubText")
                local InputFrame = Create("Frame", {Parent = Cont, BackgroundColor3 = NexusFlow.CurrentTheme.Main, Position = UDim2.new(0, 8, 0, 22), Size = UDim2.new(1, -16, 0, 22)})
                RegisterThemeObj(InputFrame, "BackgroundColor3", "Main")
                Create("UICorner", {Parent = InputFrame, CornerRadius = UDim.new(0, 4)})
                local InputStroke = Create("UIStroke", {Parent = InputFrame, Color = NexusFlow.CurrentTheme.Stroke, Thickness = 1, Transparency = 0.5})
                RegisterThemeObj(InputStroke, "Color", "Stroke")
                local InputBox = Create("TextBox", {Parent = InputFrame, BackgroundTransparency = 1, Position = UDim2.new(0, 8, 0, 0), Size = UDim2.new(1, -16, 1, 0), Font = Enum.Font.GothamMedium, Text = "", PlaceholderText = Placeholder, TextSize = 11, TextColor3 = NexusFlow.CurrentTheme.Text, PlaceholderColor3 = NexusFlow.CurrentTheme.SubText, TextXAlignment = Enum.TextXAlignment.Left})
                RegisterThemeObj(InputBox, "TextColor3", "Text") RegisterThemeObj(InputBox, "PlaceholderColor3", "SubText")
                InputBox.Focused:Connect(function() TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = NexusFlow.CurrentTheme.Accent, Transparency = 0}):Play() end)
                InputBox.FocusLost:Connect(function(enter) TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = NexusFlow.CurrentTheme.Stroke, Transparency = 0.5}):Play() if enter then Callback(InputBox.Text) end end)
            end
        end

        CreateFunctions(LeftCol, Tab.Left)
        CreateFunctions(RightCol, Tab.Right)

        return Tab
    end
    
    function Win:LoadModule(Url)
        NotifyFunc("System", "Fetching Module...", 2)
        local Success, Result = pcall(function()
            return loadstring(game:HttpGet(Url))(Win)
        end)
        
        if Success then
            NotifyFunc("Success", "Module Loaded!", 2)
        else
            NotifyFunc("Error", "Failed to Load", 2)
            warn(Result)
        end
    end
    
    function Win:SetTheme(Name) UpdateAllThemes(Name) end
    function Win:Notify(Title, Text, Time) NotifyFunc(Title, Text, Time) end
    
    return Win
end

return NexusFlow
