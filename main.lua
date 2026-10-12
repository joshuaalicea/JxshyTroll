-- Jxshy Troll UI | Crimson Edition v3.3 (Auto Shift Lock Fly)
-- Supports PC & Mobile (Delta, Hydrogen, Codex, Arceus X, Vega)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- THEME
local crimson = Color3.fromRGB(220, 20, 60)
local crimsonDark = Color3.fromRGB(105, 10, 32)
local background = Color3.fromRGB(13, 13, 16)
local headerColor = Color3.fromRGB(23, 17, 21)
local card = Color3.fromRGB(31, 25, 29)
local white = Color3.fromRGB(245, 240, 243)
local muted = Color3.fromRGB(155, 140, 148)

local old = playerGui:FindFirstChild("JxshyTrollUI")
if old then old:Destroy() end

local function create(class, props, parent)
    local obj = Instance.new(class)
    for key, value in pairs(props) do
        obj[key] = value
    end
    obj.Parent = parent
    return obj
end

local function round(obj, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius or 8) }, obj)
end

local function tween(obj, duration, properties)
    local animation = TweenService:Create(obj, TweenInfo.new(duration, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), properties)
    animation:Play()
    return animation
end

-- GUI ROOT
local gui = create("ScreenGui", {
    Name = "JxshyTrollUI",
    ResetOnSpawn = false,
    DisplayOrder = 100,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, playerGui)

-- MAIN WINDOW
local window = create("Frame", {
    Name = "MainWindow",
    Size = UDim2.fromOffset(360, 390),
    Position = UDim2.new(0.5, -180, 0.5, -195),
    BackgroundColor3 = background,
    BorderSizePixel = 0,
    ClipsDescendants = true
}, gui)
round(window, 12)

local outline = create("UIStroke", {
    Color = crimson,
    Thickness = 1.4,
    Transparency = 0.15
}, window)

-- HEADER
local header = create("Frame", {
    Name = "Header",
    Size = UDim2.new(1, 0, 0, 53),
    BackgroundColor3 = headerColor,
    BorderSizePixel = 0
}, window)

local title = create("TextLabel", {
    Position = UDim2.fromOffset(12, 5),
    Size = UDim2.new(1, -65, 0, 25),
    BackgroundTransparency = 1,
    Text = "🩸 Jxshy Troll UI",
    TextColor3 = white,
    TextSize = 16,
    Font = Enum.Font.GothamBold,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local subtitle = create("TextLabel", {
    Position = UDim2.fromOffset(13, 29),
    Size = UDim2.new(1, -70, 0, 15),
    BackgroundTransparency = 1,
    Text = "CRIMSON EDITION  •  v3.3 SHIFT LOCK FLY",
    TextColor3 = crimson,
    TextSize = 9,
    Font = Enum.Font.GothamMedium,
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

local minimize = create("TextButton", {
    Position = UDim2.new(1, -38, 0, 10),
    Size = UDim2.fromOffset(27, 27),
    BackgroundColor3 = crimsonDark,
    Text = "—",
    TextColor3 = white,
    TextSize = 17,
    Font = Enum.Font.GothamBold,
    BorderSizePixel = 0,
    AutoButtonColor = false
}, header)
round(minimize, 7)

-- DRAGGING
local dragging, dragStart, startPosition
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPosition = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

-- BODY
local body = create("Frame", { Position = UDim2.fromOffset(9, 60), Size = UDim2.new(1, -18, 1, -69), BackgroundTransparency = 1 }, window)
local tabBar = create("Frame", { Size = UDim2.new(1, 0, 0, 32), BackgroundTransparency = 1 }, body)
create("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 4), SortOrder = Enum.SortOrder.LayoutOrder }, tabBar)

local tabNames = {"Movement", "Troll", "Visuals", "Player", "Settings"}
local pages, tabButtons = {}, {}

local content = create("Frame", { Position = UDim2.new(0, 0, 0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1, ClipsDescendants = true }, body)

for _, name in ipairs(tabNames) do
    local page = create("ScrollingFrame", {
        Name = name, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0,
        ScrollBarThickness = 3, ScrollBarImageColor3 = crimson, AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Visible = false
    }, content)
    create("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder }, page)
    create("UIPadding", { PaddingRight = UDim.new(0, 3), PaddingBottom = UDim.new(0, 4) }, page)
    pages[name] = page

    local tab = create("TextButton", {
        Name = name .. "Tab", Size = UDim2.new(0.2, -4, 1, 0), BackgroundColor3 = card, Text = name, TextColor3 = muted, TextSize = 9, Font = Enum.Font.GothamSemibold, BorderSizePixel = 0, AutoButtonColor = false
    }, tabBar)
    round(tab, 6)
    tabButtons[name] = tab

    tab.Activated:Connect(function()
        for tabName, targetPage in pairs(pages) do
            local active = tabName == name
            targetPage.Visible = active
            tween(tabButtons[tabName], 0.16, { BackgroundColor3 = active and crimson or card, TextColor3 = active and white or muted })
        end
    end)
end

local function addButton(tabName, label, callback)
    local button = create("TextButton", {
        Size = UDim2.new(1, -2, 0, 35), BackgroundColor3 = card, Text = "   " .. label, TextColor3 = white, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left, BorderSizePixel = 0, AutoButtonColor = false
    }, pages[tabName])
    round(button, 7)
    local edge = create("UIStroke", { Color = crimson, Thickness = 1, Transparency = 1 }, button)
    button.MouseEnter:Connect(function() tween(button, 0.13, {BackgroundColor3 = crimsonDark}); tween(edge, 0.13, {Transparency = 0.25}) end)
    button.MouseLeave:Connect(function() tween(button, 0.13, {BackgroundColor3 = card}); tween(edge, 0.13, {Transparency = 1}) end)
    button.Activated:Connect(function() callback(button) end)
    return button
end

local function addToggle(tabName, label, initial, callback)
    local enabled = initial or false
    local button
    local function update()
        button.Text = "   " .. label .. (enabled and "     [ ON ]" or "     [ OFF ]")
        tween(button, 0.16, {BackgroundColor3 = enabled and crimsonDark or card})
    end
    button = addButton(tabName, label, function() enabled = not enabled; update(); if callback then callback(enabled) end end)
    update()
    return { Set = function(val) enabled = val; update(); if callback then callback(val) end end }
end

local function addSlider(tabName, label, min, max, initial, callback)
    local value = initial
    local holder = create("Frame", { Size = UDim2.new(1, -2, 0, 56), BackgroundColor3 = card, BorderSizePixel = 0 }, pages[tabName])
    round(holder, 7)

    local titleLabel = create("TextLabel", { Position = UDim2.fromOffset(9, 5), Size = UDim2.new(1, -18, 0, 17), BackgroundTransparency = 1, Text = label .. ": " .. value, TextColor3 = white, TextSize = 11, Font = Enum.Font.GothamMedium, TextXAlignment = Enum.TextXAlignment.Left }, holder)
    local track = create("TextButton", { Position = UDim2.new(0, 9, 0, 34), Size = UDim2.new(1, -18, 0, 6), BackgroundColor3 = Color3.fromRGB(65, 48, 55), Text = "", BorderSizePixel = 0, AutoButtonColor = false }, holder)
    round(track, 4)

    local ratio = (value - min) / (max - min)
    local fill = create("Frame", { Size = UDim2.new(ratio, 0, 1, 0), BackgroundColor3 = crimson, BorderSizePixel = 0 }, track)
    round(fill, 4)
    local knob = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(ratio, 0, 0.5, 0), Size = UDim2.fromOffset(12, 12), BackgroundColor3 = white, BorderSizePixel = 0 }, track)
    round(knob, 6)

    local function update(input)
        local newRatio = math.clamp((input.Position.X - track.AbsolutePosition.X) / math.max(track.AbsoluteSize.X, 1), 0, 1)
        value = math.floor(min + (max - min) * newRatio)
        titleLabel.Text = label .. ": " .. value
        fill.Size = UDim2.new(newRatio, 0, 1, 0)
        knob.Position = UDim2.new(newRatio, 0, 0.5, 0)
        if callback then callback(value) end
    end

    local sliding = false
    track.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; update(input) end end)
    UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end end)
end

-- ==================== EXPLOIT STATES ====================

local flightEnabled, flightSpeed = false, 50
local noclipEnabled, infJumpEnabled = false, false
local spinHeadEnabled, rainbowCharEnabled = false, false
local fakeLagEnabled = false
local previousCameraMode

-- ==================== MOVEMENT TAB ====================

addToggle("Movement", "Smooth Fly Engine", false, function(state) 
    flightEnabled = state 
    local char = player.Character
    if char and char:FindFirstChildOfClass("Humanoid") then
        char:FindFirstChildOfClass("Humanoid").PlatformStand = state
    end

    if state then
        previousCameraMode = player.CameraMode
        player.CameraMode = Enum.CameraMode.LockFirstPerson
        -- Alternative shift lock lock behavior
        player.DevEnableMouseLock = true
    else
        if previousCameraMode then
            player.CameraMode = previousCameraMode
        else
            player.CameraMode = Enum.CameraMode.Classic
        end
    end
end)

addSlider("Movement", "Flight Speed", 10, 500, 50, function(val) flightSpeed = val end)
addSlider("Movement", "Walk Speed", 16, 500, 16, function(val)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character.Humanoid.WalkSpeed = val end
end)
addSlider("Movement", "Jump Power", 50, 500, 50, function(val)
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character.Humanoid.UseJumpPower = true
        player.Character.Humanoid.JumpPower = val
    end
end)
addToggle("Movement", "Infinite Jump", false, function(state) infJumpEnabled = state end)
addToggle("Movement", "Noclip", false, function(state) noclipEnabled = state end)
addToggle("Movement", "Low Gravity", false, function(state) Workspace.Gravity = state and 30 or 196.2 end)

-- ==================== TROLL TAB ====================

addToggle("Troll", "Exorcist Head Spin", false, function(state) spinHeadEnabled = state end)
addToggle("Troll", "Fake Lag / Desync", false, function(state) fakeLagEnabled = state end)

addButton("Troll", "TP to Random Player", function()
    local targets = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            table.insert(targets, p.Character.HumanoidRootPart)
        end
    end
    if #targets > 0 and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = targets[math.random(1, #targets)].CFrame * CFrame.new(0, 2, 0)
    end
end)

addButton("Troll", "Sit On Nearest Player", function()
    local char = player.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    
    local nearest, minDist = nil, math.huge
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (p.Character.HumanoidRootPart.Position - root.Position).Magnitude
            if dist < minDist then minDist = dist; nearest = p.Character.HumanoidRootPart end
        end
    end
    if nearest then
        root.CFrame = nearest.CFrame * CFrame.new(0, 2.5, 0)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Sit = true end
    end
end)

addButton("Troll", "360 Spin Character", function()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if root then
        task.spawn(function()
            for i = 1, 24 do
                root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(15), 0)
                task.wait(0.01)
            end
        end)
    end
end)

addButton("Troll", "Fake Death / Ragdoll Prank", function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
end)

addButton("Troll", "Screen Jumpscare Prank", function()
    local flash = create("Frame", {
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = crimson,
        ZIndex = 999
    }, gui)
    tween(flash, 0.4, {BackgroundTransparency = 1})
    task.delay(0.4, function() flash:Destroy() end)
end)

-- ==================== VISUALS TAB ====================

addToggle("Visuals", "Player Highlights (ESP)", false, function(state)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character then
            if state then
                local highlight = Instance.new("Highlight")
                highlight.Name = "JxshyESP"; highlight.FillColor = crimson; highlight.OutlineColor = white; highlight.Parent = p.Character
            else
                local h = p.Character:FindFirstChild("JxshyESP")
                if h then h:Destroy() end
            end
        end
    end
end)

addToggle("Visuals", "Rainbow Character", false, function(state) rainbowCharEnabled = state end)

addToggle("Visuals", "Fullbright Mode", false, function(state)
    Lighting.Brightness = state and 2 or 1
    Lighting.ClockTime = state and 14 or 12
    Lighting.GlobalShadows = not state
end)

addSlider("Visuals", "Field of View (FOV)", 70, 120, 70, function(val)
    camera.FieldOfView = val
end)

addButton("Visuals", "Infinite Zoom Distance", function()
    player.MaxZoomDistance = 100000
end)

-- ==================== PLAYER TAB ====================

addToggle("Player", "Anti-AFK Disconnect", false, function(state)
    if state then
        local gc = getconnections or get_signal_cons
        if gc then
            for _, v in pairs(gc(player.Idled)) do v:Disable() end
        end
    end
end)

addButton("Player", "Sit Down", function()
    local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.Sit = not hum.Sit end
end)

addButton("Player", "Reset Character", function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then player.Character.Humanoid.Health = 0 end
end)

addButton("Player", "Recenter Camera", function()
    if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        camera.CameraSubject = player.Character.Humanoid
    end
end)

-- ==================== SETTINGS TAB ====================

addButton("Settings", "Rejoin Server", function()
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, player)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end
end)

addButton("Settings", "Server Hop", function()
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if success and result and result.data then
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                break
            end
        end
    else
        TeleportService:Teleport(game.PlaceId, player)
    end
end)

addButton("Settings", "Copy Game JobId", function()
    if setclipboard then setclipboard(tostring(game.JobId)) end
end)

addButton("Settings", "Reset UI Position", function()
    tween(window, 0.25, {Position = UDim2.new(0.5, -180, 0.5, -195)})
end)

addButton("Settings", "Close UI", function()
    tween(window, 0.2, {Size = UDim2.fromOffset(290, 310), BackgroundTransparency = 1})
    task.delay(0.22, function() if gui.Parent then gui:Destroy() end end)
end)

-- ==================== SHIFT-LOCK FLY ENGINE ====================

RunService.RenderStepped:Connect(function(deltaTime)
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")

    if flightEnabled and root and hum then
        hum.PlatformStand = true
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero

        local camCF = camera.CFrame
        local moveDir = hum.MoveDirection
        
        local vertical = 0
        if UserInputService:IsKeyDown(Enum.KeyCode.E) then vertical = vertical + 1 end
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then vertical = vertical - 1 end

        local flyDir
        if moveDir.Magnitude > 0 or vertical ~= 0 then
            flyDir = (camCF.LookVector * (-moveDir.Z) + camCF.RightVector * moveDir.X + Vector3.new(0, vertical, 0)).Unit
        else
            flyDir = Vector3.zero
        end

        root.CFrame = CFrame.new(root.Position + flyDir * (flightSpeed * deltaTime), root.Position + camCF.LookVector)
    elseif not flightEnabled and hum and hum.PlatformStand then
        hum.PlatformStand = false
    end
end)

-- Noclip Loop
RunService.Stepped:Connect(function()
    if noclipEnabled and player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJumpEnabled and player.Character then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

-- Head Spin
RunService.RenderStepped:Connect(function()
    if spinHeadEnabled and player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head and head:FindFirstChild("Neck") then
            head.Neck.C0 = head.Neck.C0 * CFrame.Angles(0, math.rad(15), 0)
        end
    end
end)

-- Fake Lag Loop
RunService.Heartbeat:Connect(function()
    if fakeLagEnabled and player.Character then
        local root = player.Character:FindFirstChild("HumanoidRootPart")
        if root then
            root.Anchored = true
            task.wait(0.08)
            root.Anchored = false
        end
    end
end)

-- Rainbow Body
task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        if rainbowCharEnabled and player.Character then
            hue = (hue + 0.02) % 1
            local color = Color3.fromHSV(hue, 0.8, 1)
            for _, part in ipairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.Color = color end
            end
        end
    end
end)

-- MINIMIZE CONTROL
local minimized = false
minimize.Activated:Connect(function()
    minimized = not minimized
    if minimized then
        body.Visible = false
        tween(window, 0.22, {Size = UDim2.fromOffset(360, 53)})
        minimize.Text = "+"
    else
        tween(window, 0.25, {Size = UDim2.fromOffset(360, 390)})
        minimize.Text = "—"
        task.delay(0.08, function() if window.Parent and not minimized then body.Visible = true end end)
    end
end)

selectedTab = "Movement"
pages.Movement.Visible = true
tabButtons.Movement.BackgroundColor3 = crimson
tabButtons.Movement.TextColor3 = white

print("[Jxshy Troll UI] Crimson Edition v3.3 Shift Lock Fly loaded successfully!")
