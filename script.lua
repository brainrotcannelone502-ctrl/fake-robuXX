-- [[ LK7 FAKE ROBUX - V45-Y TSK EDITION (SMOOTH ROCKET) ]] --
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local pGui = lp:WaitForChild("PlayerGui")

if pGui:FindFirstChild("LK7_V45_Y") then pGui.LK7_V45_Y:Destroy() end

local sg = Instance.new("ScreenGui", pGui)
sg.Name = "LK7_V45_Y"
sg.ResetOnSpawn = false

local selectedPlayer = lp
local listOpen = false

-- =========================================================
-- FUNÇÃO ROCKET (TÉCNICA 0.3 SPEED - ANTI-KICK)
-- =========================================================
local function applyRocket()
    local target = selectedPlayer
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = target.Character
        local hrp = char.HumanoidRootPart
        local hum = char:FindFirstChildOfClass("Humanoid")
        
        -- Efeito de Fogo
        local fire = Instance.new("Fire", hrp)
        fire.Size, fire.Heat = 12, 20
        
        if hum then hum.PlatformStand = true end
        
        local startTime = tick()
        local connection
        connection = RunService.Heartbeat:Connect(function()
            -- Sobe por 4 segundos a 0.3 de velocidade (Igual ao script que você mandou)
            if tick() - startTime < 4.0 then
                if hrp and hrp.Parent then
                    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0.3, 0)
                    hrp.Velocity = Vector3.new(0, 0, 0) -- Zera velocidade pra não dar kick
                end
            else
                connection:Disconnect()
                if fire then fire:Destroy() end
                
                -- Explosão apenas Visual
                local ex = Instance.new("Explosion", workspace)
                ex.Position = hrp.Position
                ex.BlastRadius = 0
                ex.BlastPressure = 0
                
                if hum then 
                    hum.Health = 0 
                    hum.PlatformStand = false
                end
            end
        end)
    end
end

-- FUNÇÃO CHAT
local function say(txt)
    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("Head") then
        game:GetService("Chat"):Chat(selectedPlayer.Character.Head, txt, "White")
    end
end

-- =========================================================
-- INTERFACE (PRETO PREMIUM)
-- =========================================================
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 330, 0, 580)
main.Position = UDim2.new(0.5, -165, 0.5, -290)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.Active = true; main.Draggable = true
Instance.new("UICorner", main)

-- TITULO
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, 0, 0, 45); title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "LK7 HUB - V45-Y PREMIUM"; title.TextColor3 = Color3.fromRGB(200, 200, 200)
title.Font = "GothamBold"; title.TextSize = 14; title.BackgroundTransparency = 1; title.TextXAlignment = "Left"

-- DROPDOWN COM SETA (v / ^)
local dropBtn = Instance.new("TextButton", main)
dropBtn.Size = UDim2.new(0.9, 0, 0, 40); dropBtn.Position = UDim2.new(0.05, 0, 0, 50)
dropBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30); dropBtn.Text = "  Selecionar Player v"
dropBtn.TextColor3 = Color3.fromRGB(180, 180, 180); dropBtn.TextXAlignment = "Left"; dropBtn.ZIndex = 10
Instance.new("UICorner", dropBtn)

local listFrame = Instance.new("ScrollingFrame", main)
listFrame.Size = UDim2.new(0.9, 0, 0, 150); listFrame.Position = UDim2.new(0.05, 0, 0, 95)
listFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25); listFrame.Visible = false; listFrame.ZIndex = 20
listFrame.ScrollBarThickness = 2; Instance.new("UICorner", listFrame)
local layout = Instance.new("UIListLayout", listFrame)

local function refreshList()
    for _, v in pairs(listFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", listFrame)
        b.Size = UDim2.new(1, 0, 0, 35); b.Text = "  " .. p.DisplayName
        b.BackgroundColor3 = Color3.fromRGB(30, 30, 35); b.TextColor3 = Color3.fromRGB(200, 200, 200)
        b.TextXAlignment = "Left"; b.ZIndex = 21; b.Font = "Gotham"; Instance.new("UICorner", b)
        b.MouseButton1Click:Connect(function()
            selectedPlayer = p; dropBtn.Text = "  Alvo: "..p.DisplayName.." ^"; listOpen = false; listFrame.Visible = false
        end)
    end
    listFrame.CanvasSize = UDim2.new(0, 0, 0, #Players:GetPlayers() * 37)
end

dropBtn.MouseButton1Click:Connect(function()
    listOpen = not listOpen; listFrame.Visible = listOpen
    dropBtn.Text = listOpen and "  Selecionar Player ^" or "  Selecionar Player v"
    if listOpen then refreshList() end
end)

-- MENSAGEM CUSTOM
local box = Instance.new("TextBox", main)
box.Size = UDim2.new(0.9, 0, 0, 40); box.Position = UDim2.new(0.05, 0, 0, 105)
box.BackgroundColor3 = Color3.fromRGB(25, 25, 30); box.PlaceholderText = "Sua mensagem..."
box.Text = ""; box.TextColor3 = Color3.fromRGB(200, 200, 200); Instance.new("UICorner", box)

local send = Instance.new("TextButton", main)
send.Size = UDim2.new(0.9, 0, 0, 35); send.Position = UDim2.new(0.05, 0, 0, 155)
send.BackgroundColor3 = Color3.fromRGB(65, 45, 185); send.Text = "ENVIAR MENSAGEM"
send.TextColor3 = Color3.fromRGB(230, 230, 230); send.Font = "GothamBold"; Instance.new("UICorner", send)
send.MouseButton1Click:Connect(function() if box.Text ~= "" then say(box.Text) box.Text = "" end end)

-- MENSAGENS RÁPIDAS
local grid = Instance.new("ScrollingFrame", main)
grid.Size = UDim2.new(0.9, 0, 0, 200); grid.Position = UDim2.new(0.05, 0, 0, 210)
grid.BackgroundTransparency = 1; grid.ScrollBarThickness = 0
local uigrid = Instance.new("UIGridLayout", grid)
uigrid.CellSize = UDim2.new(0.485, 0, 0, 30); uigrid.CellPadding = UDim2.new(0.03, 0, 0, 5)

local frases = {"Obrigado", "Vlw MN", "Tmj", "Vouch", "chegou msmm", "confiavel", "recomendo", "Valeu LK7"}
for _, f in pairs(frases) do
    local b = Instance.new("TextButton", grid)
    b.Text = f; b.BackgroundColor3 = Color3.fromRGB(50, 50, 60); b.TextColor3 = Color3.fromRGB(180, 180, 180)
    b.Font = "Gotham"; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() say(f) end)
end

-- ROCKET (USANDO A TÉCNICA DO SCRIPT QUE VOCÊ MANDOU)
local rocket = Instance.new("TextButton", main)
rocket.Size = UDim2.new(0.9, 0, 0, 40); rocket.Position = UDim2.new(0.05, 0, 1, -85)
rocket.BackgroundColor3 = Color3.fromRGB(45, 45, 50); rocket.Text = "🚀 ROCKET (0.3 SPEED)"
rocket.TextColor3 = Color3.fromRGB(230, 230, 230); rocket.Font = "GothamBold"; Instance.new("UICorner", rocket)
rocket.MouseButton1Click:Connect(applyRocket)

-- ROBUX
local robux = Instance.new("TextLabel", main)
robux.Size = UDim2.new(1, 0, 0, 30); robux.Position = UDim2.new(0, 0, 1, -30)
robux.Text = "Robux: 11284"; robux.TextColor3 = Color3.fromRGB(255, 215, 0); robux.BackgroundTransparency = 1
