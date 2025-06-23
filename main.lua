local lol = {}

local function roundify(uiObject, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = uiObject
end

local function addPadding(uiObject, padding)
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, padding)
    pad.PaddingBottom = UDim.new(0, padding)
    pad.PaddingLeft = UDim.new(0, padding)
    pad.PaddingRight = UDim.new(0, padding)
    pad.Parent = uiObject
end

-- Anti crash bypass (optional)
pcall(function()
    for _, v in pairs(getgc(true)) do
        if pcall(function() return rawget(v, "indexInstance") end)
            and type(rawget(v, "indexInstance")) == "table"
            and rawget(v, "indexInstance")[1] == "kick" then
            v.tvk = {"kick", function() return game.Workspace:WaitForChild("") end}
        end
    end
end)

local gui = Instance.new("ScreenGui")
gui.Name = tostring(math.random(100000, 999999))
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui
getgenv().trdshowvotesgui = gui

local mainframe = Instance.new("Frame")
mainframe.Size = UDim2.new(.25, 0, 0, 0)
mainframe.Position = UDim2.new(.3, 0, .2)
mainframe.Active = true
mainframe.Draggable = true
mainframe.BackgroundColor3 = Color3.fromRGB(64, 0, 128) -- dark purple
mainframe.BorderColor3 = Color3.fromRGB(138, 43, 226) -- blue violet
mainframe.Parent = gui
roundify(mainframe, 16)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, .125, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
title.TextScaled = true
title.Text = "🍆TRD Votecount🍆"
title.Font = Enum.Font.SourceSansBold
title.Parent = mainframe

local constraint = Instance.new("UIAspectRatioConstraint")
constraint.AspectType = Enum.AspectType.ScaleWithParentSize
constraint.AspectRatio = 1.5
constraint.Parent = mainframe

local voteframe = Instance.new("ScrollingFrame")
voteframe.Position = UDim2.new(0, 0, .2, 0)
voteframe.Size = UDim2.new(.5, 0, .8, 0)
voteframe.BackgroundColor3 = Color3.fromRGB(75, 0, 130) -- indigo purple
voteframe.BorderColor3 = Color3.fromRGB(138, 43, 226)
voteframe.CanvasSize = UDim2.new(0, 0, 700, 0)
voteframe.ScrollBarThickness = 6
voteframe.Parent = mainframe
roundify(voteframe, 12)
addPadding(voteframe, 4)

local votelogframe = Instance.new("ScrollingFrame")
votelogframe.Position = UDim2.new(.5, 0, .2, 0)
votelogframe.Size = UDim2.new(.5, 0, .8, 0)
votelogframe.BackgroundColor3 = Color3.fromRGB(75, 0, 130) -- indigo purple
votelogframe.BorderColor3 = Color3.fromRGB(138, 43, 226)
votelogframe.CanvasSize = UDim2.new(0, 0, 1000, 0)
votelogframe.ScrollBarThickness = 6
votelogframe.Parent = mainframe
roundify(votelogframe, 12)
addPadding(votelogframe, 4)

local voteframedestroybutton = Instance.new("TextButton")
voteframedestroybutton.BackgroundColor3 = Color3.fromRGB(65, 0, 120) -- l purple
voteframedestroybutton.BorderColor3 = Color3.fromRGB(0, 255, 255) -- cyan
voteframedestroybutton.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
voteframedestroybutton.Size = UDim2.new(.25, 0, .15, 0)
voteframedestroybutton.Position = UDim2.new(.125, 0, 1.01, 0)
voteframedestroybutton.TextScaled = true
voteframedestroybutton.Text = "🗑"
voteframedestroybutton.Font = Enum.Font.SourceSansBold
voteframedestroybutton.Parent = mainframe
roundify(voteframedestroybutton, 8)

table.insert(lol, voteframedestroybutton.MouseButton1Click:Connect(function()
    for _, v in pairs(voteframe:GetChildren()) do
        if v:IsA("Frame") then v:Destroy() end
    end
end))

local votelogframedestroybutton = Instance.new("TextButton")
votelogframedestroybutton.BackgroundColor3 = Color3.fromRGB(65, 0, 120) -- l purple
votelogframedestroybutton.BorderColor3 = Color3.fromRGB(0, 255, 255) -- cyan
votelogframedestroybutton.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
votelogframedestroybutton.Size = UDim2.new(.25, 0, .15, 0)
votelogframedestroybutton.Position = UDim2.new(.625, 0, 1.01, 0)
votelogframedestroybutton.Text = "🗑"
votelogframedestroybutton.TextScaled = true
votelogframedestroybutton.Font = Enum.Font.SourceSansBold
votelogframedestroybutton.Parent = mainframe
roundify(votelogframedestroybutton, 8)

table.insert(lol, votelogframedestroybutton.MouseButton1Click:Connect(function()
    for _, v in pairs(votelogframe:GetChildren()) do
        if v:IsA("TextLabel") then v:Destroy() end
    end
end))

local voteframesort = Instance.new("UIGridLayout")
voteframesort.CellSize = UDim2.new(0.3, 0, 0.00025, 0)
voteframesort.CellPadding = UDim2.new(0, 0, 0, 0)
voteframesort.Parent = voteframe

local votelogframesort = Instance.new("UIListLayout")
votelogframesort.Parent = votelogframe

local playerFrames = {}
local function highlightTopVoted()
    local maxVotes = -1
    local topPlayer = nil
    for name, data in pairs(playerFrames) do
        local votes = tonumber(data.voteLabel.Text) or 0
        if votes > maxVotes then
            maxVotes = votes
            topPlayer = name
        end
    end
    for name, data in pairs(playerFrames) do
        if name == topPlayer then
            data.nameLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- hot pink
        else
            data.nameLabel.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
        end
    end
end

local votingfolder = game.ReplicatedStorage.Season.Voting
table.insert(lol, votingfolder.Players.ChildAdded:Connect(function(plr)
    local plrname = plr.Name
    if game.ReplicatedStorage.Season:FindFirstChild("Players") and game.ReplicatedStorage.Season.Players:FindFirstChild(plrname) then
        plrname = game.ReplicatedStorage.Season.Players[plrname].Value
    end
    local votes = plr:WaitForChild("Votes", math.huge)
    local frame = Instance.new("Frame")
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    frame.BackgroundTransparency = 0.99
    roundify(frame, 6)

    local plrnametext = Instance.new("TextLabel")
    plrnametext.BackgroundTransparency = 1
    plrnametext.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
    plrnametext.TextScaled = true
    plrnametext.Size = UDim2.new(1, 0, .6, 0)
    plrnametext.Position = UDim2.new(0, 0, .6, 0)
    plrnametext.Text = plrname
    roundify(plrnametext, 4)

    local votetext = Instance.new("TextLabel")
    votetext.BackgroundTransparency = 1
    votetext.TextColor3 = Color3.fromRGB(255, 72, 128) -- pink
    votetext.TextStrokeTransparency = 0
    votetext.TextScaled = true
    votetext.Size = UDim2.new(1, 0, .6, 0)
    votetext.Text = tostring(votes.Value)

    plrnametext.Parent = frame
    votetext.Parent = frame
    frame.Name = plrname
    frame.Parent = voteframe

    playerFrames[plrname] = {
        frame = frame,
        nameLabel = plrnametext,
        voteLabel = votetext
    }

    table.insert(lol, votes:GetPropertyChangedSignal("Value"):Connect(function()
        votetext.Text = tostring(votes.Value)
        highlightTopVoted()
    end))

    highlightTopVoted()
end))

table.insert(lol, votingfolder.Votes.ChildAdded:Connect(function(vote)
    local whovoted = vote.Value
    local votedfor = vote.Name
    if game.ReplicatedStorage.Season.Players:FindFirstChild(whovoted) then
        whovoted = game.ReplicatedStorage.Season.Players[whovoted].Value
    end
    if game.ReplicatedStorage.Season.Players:FindFirstChild(votedfor) then
        votedfor = game.ReplicatedStorage.Season.Players[votedfor].Value
    end
    local text = Instance.new("TextLabel")
    text.Name = whovoted
    text.Size = UDim2.new(1, 0, 0.00006)
    text.BackgroundTransparency = 1
    text.TextScaled = true
    text.TextColor3 = Color3.fromRGB(0, 255, 255) -- cyan
    text.TextStrokeTransparency = 0
    text.Text = whovoted .. " 📍 " .. votedfor
    text.Parent = votelogframe
end))

function deletegui()
    gui:Destroy()
    for _, v in pairs(lol) do
        v:Disconnect()
    end
end

getgenv().trdshowvotesdeletefunc = deletegui

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "TRD UI",
    Text = "Loaded like a Bratz doll 💋"
})
