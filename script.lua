-- [[ CONFIGURAÇÕES INICIAIS & SERVIÇOS ]]
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer

-- Previnir duplicação do menu na tela
if game:GetService("CoreGui"):FindFirstChild("Tsk_InteractionPanel_PC_v3") then
    game:GetService("CoreGui")["Tsk_InteractionPanel_PC_v3"]:Destroy()
end

-- [[ CRIAÇÃO DA INTERFACE VISUAL ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Tsk_InteractionPanel_PC_v3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 360, 0, 540)
MainFrame.Position = UDim2.new(0.5, -180, 0.5, -270)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MainFrame.ClipsDescendants = true -- Garante que os botões somem ao minimizar
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(85, 35, 145)
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Barra de Título (Sempre visível para arrastar e controlar)
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -75, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔮 Tsk FV - PC Interaction Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

-- Botão Fechar (X)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 26, 0, 26)
CloseBtn.Position = UDim2.new(1, -35, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(190, 45, 45)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 11
CloseBtn.Parent = TitleBar
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- [[ NOVO: BOTÃO MINIMIZAR (-) ]]
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
MinimizeBtn.Position = UDim2.new(1, -66, 0, 7)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(65, 30, 115)
MinimizeBtn.Text = "-"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextSize = 14
MinimizeBtn.Parent = TitleBar
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

local Minimizado = false
MinimizeBtn.MouseButton1Click:Connect(function()
    Minimizado = not Minimizado
    
    local TamanhoAlvo
    if Minimizado then
        TamanhoAlvo = UDim2.new(0, 360, 0, 40) -- Encolhe deixando só a barra do topo
        MinimizeBtn.Text = "+"
    else
        TamanhoAlvo = UDim2.new(0, 360, 0, 540) -- Volta para o tamanho original completo
        MinimizeBtn.Text = "-"
    end
    
    -- Transição suave ao minimizar/expandir
    local InfoAnimacao = TweenInfo.new(0.3, Enum.EasingStyle.QuadOut)
    TweenService:Create(MainFrame, InfoAnimacao, {Size = TamanhoAlvo}):Play()
end)

local JogadorSelecionado = nil

-- [[ SEÇÃO 1: LISTA DE JOGADORES ]]
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -30, 0, 20)
ListLabel.Position = UDim2.new(0, 15, 0, 45)
ListLabel.Text = "Selecione um Alvo no Servidor:"
ListLabel.TextColor3 = Color3.fromRGB(185, 165, 205)
ListLabel.Font = Enum.Font.GothamSemibold
ListLabel.TextSize = 11
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.BackgroundTransparency = 1
ListLabel.Parent = MainFrame

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -30, 0, 120)
PlayerScroll.Position = UDim2.new(0, 15, 0, 65)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(23, 16, 35)
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 6
PlayerScroll.ScrollBarImageColor3 = Color3.fromRGB(85, 35, 145)
PlayerScroll.ScrollingDirection = Enum.ScrollingDirection.Y
PlayerScroll.Active = true
PlayerScroll.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 5)
ListLayout.Parent = PlayerScroll

ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 10)
end)

local function AtualizarListaPlayers()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        local PBtn = Instance.new("TextButton")
        PBtn.Size = UDim2.new(1, -10, 0, 28)
        PBtn.BackgroundColor3 = (JogadorSelecionado == p) and Color3.fromRGB(95, 40, 165) or Color3.fromRGB(33, 25, 45)
        PBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
        PBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
        PBtn.Font = Enum.Font.Gotham
        PBtn.TextSize = 11
        PBtn.TextXAlignment = Enum.TextXAlignment.Left
        PBtn.Parent = PlayerScroll
        Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
        
        PBtn.MouseButton1Click:Connect(function()
            JogadorSelecionado = p
            AtualizarListaPlayers()
        end)
    end
end
AtualizarListaPlayers()
Players.PlayerAdded:Connect(AtualizarListaPlayers)
Players.PlayerRemoving:Connect(function(p)
    if JogadorSelecionado == p then JogadorSelecionado = nil end
    AtualizarListaPlayers()
end)

-- [[ SEÇÃO 2: CAIXA DE TEXTO CUSTOMIZADA ]]
local CustomTextBox = Instance.new("TextBox")
CustomTextBox.Size = UDim2.new(1, -110, 0, 32)
CustomTextBox.Position = UDim2.new(0, 15, 0, 200)
CustomTextBox.BackgroundColor3 = Color3.fromRGB(23, 16, 35)
CustomTextBox.Text = ""
CustomTextBox.PlaceholderText = " Mensagem customizada..."
CustomTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomTextBox.PlaceholderColor3 = Color3.fromRGB(110, 95, 130)
CustomTextBox.Font = Enum.Font.Gotham
CustomTextBox.TextSize = 11
CustomTextBox.TextXAlignment = Enum.TextXAlignment.Left
CustomTextBox.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

local SendCustomBtn = Instance.new("TextButton")
SendCustomBtn.Size = UDim2.new(0, 80, 0, 32)
SendCustomBtn.Position = UDim2.new(1, -95, 0, 200)
SendCustomBtn.BackgroundColor3 = Color3.fromRGB(95, 40, 165)
SendCustomBtn.Text = "SEND"
SendCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendCustomBtn.Font = Enum.Font.GothamBold
SendCustomBtn.TextSize = 11
SendCustomBtn.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 5)

-- [[ SEÇÃO 3: BOTÕES DE MENSAGENS RÁPIDAS ]]
local GridFrame = Instance.new("Frame")
GridFrame.Size = UDim2.new(1, -30, 0, 80)
GridFrame.Position = UDim2.new(0, 15, 0, 250)
GridFrame.BackgroundTransparency = 1
GridFrame.Parent = MainFrame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 102, 0, 32)
GridLayout.CellPadding = UDim2.new(0, 11, 0, 10)
GridLayout.Parent = GridFrame

local mensagensPredefinidas = {"tmjj", "obg mn", "confiavelll", "chegou msmm", "rpzd te amo pcr"}

local function CriarBalaoDeFalaFalso(playerAlvo, texto)
    if not playerAlvo or not playerAlvo.Character or not playerAlvo.Character:FindFirstChild("Head") then return end
    local Head = playerAlvo.Character.Head
    
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(0, 180, 0, 45)
    Billboard.Adornee = Head
    Billboard.ExtentsOffset = Vector3.new(0, 2.5, 0)
    Billboard.AlwaysOnTop = true
    Billboard.Parent = Head
    
    local FrameBalao = Instance.new("Frame")
    FrameBalao.Size = UDim2.new(1, 0, 1, 0)
    FrameBalao.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FrameBalao.Parent = Billboard
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -10, 1, -10)
    TextLabel.Position = UDim2.new(0, 5, 0, 5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = texto
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextSize = 11
    TextLabel.TextWrapped = true
    TextLabel.Parent = FrameBalao
    
    task.delay(4, function() Billboard:Destroy() end)
end

for _, txt in pairs(mensagensPredefinidas) do
    local MBtn = Instance.new("TextButton")
    MBtn.BackgroundColor3 = Color3.fromRGB(33, 25, 45)
    MBtn.Text = txt
    MBtn.TextColor3 = Color3.fromRGB(195, 175, 215)
    MBtn.Font = Enum.Font.Gotham
    MBtn.TextSize = 11
    MBtn.Parent = GridFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 5)
    
    MBtn.MouseButton1Click:Connect(function()
        if JogadorSelecionado then CriarBalaoDeFalaFalso(JogadorSelecionado, txt) end
    end)
end

SendCustomBtn.MouseButton1Click:Connect(function()
    if JogadorSelecionado and CustomTextBox.Text ~= "" then
        CriarBalaoDeFalaFalso(JogadorSelecionado, CustomTextBox.Text)
        CustomTextBox.Text = ""
    end
end)

-- [[ SEÇÃO 4: BOTÕES ROCKET & RAGDOLL VISUAL ]]
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(1, -30, 0, 40)
ActionFrame.Position = UDim2.new(0, 15, 0, 360)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = MainFrame

local ActionLayout = Instance.new("UIHorizontalLayout")
ActionLayout.Padding = UDim.new(0, 10)
ActionLayout.Parent = ActionFrame

-- Rocket
local RocketBtn = Instance.new("TextButton")
RocketBtn.Size = UDim2.new(0, 160, 1, 0)
RocketBtn.BackgroundColor3 = Color3.fromRGB(135, 35, 35)
RocketBtn.Text = "🚀 Rocket Target"
RocketBtn.TextColor3 = Color3.fromRGB(255, 225, 225)
RocketBtn.Font = Enum.Font.GothamBold
RocketBtn.TextSize = 11
RocketBtn.Parent = ActionFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

RocketBtn.MouseButton1Click:Connect(function()
    local alvo = JogadorSelecionado
    if not alvo or not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
    local HRP = alvo.Character.HumanoidRootPart
    
    local Fire = Instance.new("Fire")
    Fire.Size = 3
    Fire.Heat = 8
    Fire.Parent = HRP
    
    local AlturaAlvo = HRP.Position + Vector3.new(0, 100, 0)
    local TweenInfoRocket = TweenInfo.new(2, Enum.EasingStyle.QuadIn)
    local TweenRocket = TweenService:Create(HRP, TweenInfoRocket, {CFrame = CFrame.new(AlturaAlvo)})
    
    TweenRocket:Play()
    TweenRocket.Completed:Connect(function()
        Fire:Destroy()
        local Explosion = Instance.new("Explosion")
        Explosion.Position = HRP.Position
        Explosion.BlastRadius = 0
        Explosion.Parent = workspace
    end)
end)

-- Ragdoll
local RagdollBtn = Instance.new("TextButton")
RagdollBtn.Size = UDim2.new(0, 160, 1, 0)
RagdollBtn.BackgroundColor3 = Color3.fromRGB(45, 95, 145)
RagdollBtn.Text = "🩻 Ragdoll (Local)"
RagdollBtn.TextColor3 = Color3.fromRGB(225, 240, 255)
RagdollBtn.Font = Enum.Font.GothamBold
RagdollBtn.TextSize = 11
RagdollBtn.Parent = ActionFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

local RagdollAtivado = false
local ConexaoRagdoll = nil

RagdollBtn.MouseButton1Click:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") then return end
    local Hum = Char.Humanoid
    
    RagdollAtivado = not RagdollAtivado
    
    if RagdollAtivado then
        RagdollBtn.BackgroundColor3 = Color3.fromRGB(95, 145, 45)
        RagdollBtn.Text = "🩻 Ativo"
        Hum.PlatformStand = true
        
        ConexaoRagdoll = RunService.RenderStepped:Connect(function()
            if Char:FindFirstChild("Animate") then Char.Animate.Disabled = true end
        end)
    else
        RagdollBtn.BackgroundColor3 = Color3.fromRGB(45, 95, 145)
        RagdollBtn.Text = "🩻 Ragdoll (Local)"
        Hum.PlatformStand = false
        if ConexaoRagdoll then ConexaoRagdoll:Disconnect() ConexaoRagdoll = nil end
        if Char:FindFirstChild("Animate") then Char.Animate.Disabled = false end
        Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

-- [[ SEÇÃO 5: SISTEMA DE ARRASTO RECONHECIDO NO PC ]]
local Dragging = false
local DragInput, DragStart, StartPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        Dragging = true
        DragStart = input.Position
        StartPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                Dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        DragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == DragInput and Dragging then
        local Delta = input.Position - DragStart
        MainFrame.Position = UDim2.new(
            StartPos.X.Scale, 
            StartPos.X.Offset + Delta.X, 
            StartPos.Y.Scale, 
            StartPos.Y.Offset + Delta.Y
        )
    end
end)
