-- [[ CONFIGURAÇÕES INICIAIS & SERVIÇOS ]]
local Players = game:GetService("Players")
local TweetService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Previnir duplicação do menu na tela
if game:GetService("CoreGui"):FindFirstChild("Tsk_InteractionPanel") then
    game:GetService("CoreGui")["Tsk_InteractionPanel"]:Destroy()
end

-- [[ CRIAÇÃO DA INTERFACE VISUAL (ESTILO TSK ROXO) ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Tsk_InteractionPanel"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 350, 0, 450)
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25) -- Roxo bem escuro de fundo
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(80, 30, 140) -- Borda roxa neon suave
MainStroke.Thickness = 1.5
MainStroke.Parent = MainFrame

-- Título do Menu
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -40, 0, 40)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🔮 Tsk FV - Interaction Panel"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Botão Fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 28, 0, 28)
CloseBtn.Position = UDim2.new(1, -35, 0, 6)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 12
CloseBtn.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- Variável para guardar o jogador selecionado na lista
local JogadorSelecionado = nil

-- [[ SEÇÃO 1: LISTA DE JOGADORES (SCROLLING FRAME) ]]
local ListLabel = Instance.new("TextLabel")
ListLabel.Size = UDim2.new(1, -30, 0, 20)
ListLabel.Position = UDim2.new(0, 15, 0, 45)
ListLabel.Text = "Selecione um Alvo:"
ListLabel.TextColor3 = Color3.fromRGB(180, 160, 200)
ListLabel.Font = Enum.Font.GothamSemibold
ListLabel.TextSize = 11
ListLabel.TextXAlignment = Enum.TextXAlignment.Left
ListLabel.BackgroundTransparency = 1
ListLabel.Parent = MainFrame

local PlayerScroll = Instance.new("ScrollingFrame")
PlayerScroll.Size = UDim2.new(1, -30, 0, 110)
PlayerScroll.Position = UDim2.new(0, 15, 0, 65)
PlayerScroll.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
PlayerScroll.BorderSizePixel = 0
PlayerScroll.ScrollBarThickness = 4
PlayerScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScroll.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerScroll

-- Função para atualizar a lista de players em tempo real
local function AtualizarListaPlayers()
    for _, child in pairs(PlayerScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        local PBtn = Instance.new("TextButton")
        PBtn.Size = UDim2.new(1, -8, 0, 28)
        PBtn.BackgroundColor3 = (JogadorSelecionado == p) and Color3.fromRGB(90, 35, 160) or Color3.fromRGB(35, 28, 50)
        PBtn.Text = "  " .. p.DisplayName .. " (@" .. p.Name .. ")"
        PBtn.TextColor3 = Color3.fromRGB(230, 230, 230)
        PBtn.Font = Enum.Font.Gotham
        PBtn.TextSize = 11
        PBtn.TextXAlignment = Enum.TextXAlignment.Left
        PBtn.Parent = PlayerScroll
        Instance.new("UICorner").CornerRadius = UDim.new(0, 4)
        
        PBtn.MouseButton1Click:Connect(function()
            JogadorSelecionado = p
            AtualizarListaPlayers() -- Atualiza as cores para destacar a seleção
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
CustomTextBox.Size = UDim2.new(1, -30, 0, 35)
CustomTextBox.Position = UDim2.new(0, 15, 0, 185)
CustomTextBox.BackgroundColor3 = Color3.fromRGB(25, 18, 38)
CustomTextBox.Text = ""
CustomTextBox.PlaceholderText = "Escreva uma mensagem customizada aqui..."
CustomTextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
CustomTextBox.PlaceholderColor3 = Color3.fromRGB(120, 100, 140)
CustomTextBox.Font = Enum.Font.Gotham
CustomTextBox.TextSize = 12
CustomTextBox.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 6)

-- Botão para enviar o texto customizado escrito na caixa
local SendCustomBtn = Instance.new("TextButton")
SendCustomBtn.Size = UDim2.new(0, 70, 0, 25)
SendCustomBtn.Position = UDim2.new(1, -90, 0, 190)
SendCustomBtn.BackgroundColor3 = Color3.fromRGB(95, 45, 145)
SendCustomBtn.Text = "SEND"
SendCustomBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
SendCustomBtn.Font = Enum.Font.GothamBold
SendCustomBtn.TextSize = 10
SendCustomBtn.Parent = MainFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 4)

-- [[ SEÇÃO 3: BOTÕES DE MENSAGENS RÁPIDAS (BALEÕES FALSOS) ]]
local GridFrame = Instance.new("Frame")
GridFrame.Size = UDim2.new(1, -30, 0, 80)
GridFrame.Position = UDim2.new(0, 15, 0, 230)
GridFrame.BackgroundTransparency = 1
GridFrame.Parent = MainFrame

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 100, 0, 35)
GridLayout.CellPadding = UDim2.new(0, 10, 0, 10)
GridLayout.Parent = GridFrame

local mensagensPredefinidas = {"tmjj", "obg mn", "confiavelll", "chegou msmm", "rpzd te amo pcr"}

-- Função principal para criar o balão na cabeça do player alvo (Local/Visual)
local function CriarBalaoDeFalaFalso(playerAlvo, texto)
    if not playerAlvo or not playerAlvo.Character or not playerAlvo.Character:FindFirstChild("Head") then return end
    if text == "" then return end

    local Head = playerAlvo.Character.Head
    
    -- Criando um BillboardGui acima da cabeça
    local Billboard = Instance.new("BillboardGui")
    Billboard.Size = UDim2.new(0, 180, 0, 50)
    Billboard.Adornee = Head
    Billboard.ExtentsOffset = Vector3.new(0, 2.5, 0) -- Posição acima da cabeça
    Billboard.AlwaysOnTop = true
    Billboard.Parent = Head
    
    local FrameBalao = Instance.new("Frame")
    FrameBalao.Size = UDim2.new(1, 0, 1, 0)
    FrameBalao.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    FrameBalao.Parent = Billboard
    Instance.new("UICorner").CornerRadius = UDim.new(0, 8)
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -10, 1, -10)
    TextLabel.Position = UDim2.new(0, 5, 0, 5)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = texto
    TextLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    TextLabel.Font = Enum.Font.GothamSemibold
    TextLabel.TextSize = 12
    TextLabel.TextWrapped = true
    TextLabel.Parent = FrameBalao
    
    -- Deletar o balão após 4 segundos automaticamente
    task.delay(4, function()
        Billboard:Destroy()
    end)
end

-- Gerando os botões rápidos na interface
for _, txt in pairs(mensagensPredefinidas) do
    local MBtn = Instance.new("TextButton")
    MBtn.BackgroundColor3 = Color3.fromRGB(35, 28, 50)
    MBtn.Text = txt
    MBtn.TextColor3 = Color3.fromRGB(190, 170, 210)
    MBtn.Font = Enum.Font.Gotham
    MBtn.TextSize = 11
    MBtn.Parent = GridFrame
    Instance.new("UICorner").CornerRadius = UDim.new(0, 6)
    
    MBtn.MouseButton1Click:Connect(function()
        if JogadorSelecionado then
            CriarBalaoDeFalaFalso(JogadorSelecionado, txt)
        end
    end)
end

-- Ação do botão SEND customizado
SendCustomBtn.MouseButton1Click:Connect(function()
    if JogadorSelecionado and CustomTextBox.Text ~= "" then
        CriarBalaoDeFalaFalso(JogadorSelecionado, CustomTextBox.Text)
        CustomTextBox.Text = "" -- Limpa a caixa
    end
end)

-- [[ SEÇÃO 4: BOTÕES DE EFEITOS (ROCKET & RAGDOLL VISUAL) ]]
local ActionFrame = Instance.new("Frame")
ActionFrame.Size = UDim2.new(1, -30, 0, 45)
ActionFrame.Position = UDim2.new(0, 15, 0, 325)
ActionFrame.BackgroundTransparency = 1
ActionFrame.Parent = MainFrame

local ActionLayout = Instance.new("UIHorizontalLayout")
ActionLayout.Padding = UDim.new(0, 15)
ActionLayout.Parent = ActionFrame

-- 🚀 BOTÃO ROCKET (Efeito Visual Local)
local RocketBtn = Instance.new("TextButton")
RocketBtn.Size = UDim2.new(0, 150, 1, 0)
RocketBtn.BackgroundColor3 = Color3.fromRGB(130, 35, 35)
RocketBtn.Text = "🚀 Rocket Target"
RocketBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
RocketBtn.Font = Enum.Font.GothamBold
RocketBtn.TextSize = 12
RocketBtn.Parent = ActionFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

RocketBtn.MouseButton1Click:Connect(function()
    local alvo = JogadorSelecionado
    if not alvo or not alvo.Character or not alvo.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local HRP = alvo.Character.HumanoidRootPart
    
    -- Criar Rastro de Fogo Fino
    local Attachment = Instance.new("Attachment")
    Attachment.Parent = HRP
    
    local Fire = Instance.new("Fire")
    Fire.Size = 4
    Fire.Heat = 9
    Fire.SecondaryColor = Color3.fromRGB(255, 100, 0)
    Fire.Parent = HRP
    
    -- Mover para cima usando Tweens de forma suave (Localmente)
    local AlturaAlvo = HRP.Position + Vector3.new(0, 120, 0)
    local TweenInfoRocket = TweenInfo.new(2.5, Enum.EasingStyle.QuadIn)
    local TweenRocket = TweetService:Create(HRP, TweenInfoRocket, {CFrame = CFrame.new(AlturaAlvo)})
    
    TweenRocket:Play()
    
    -- Quando chegar lá em cima, explode
    TweenRocket.Completed:Connect(function()
        Fire:Destroy()
        Attachment:Destroy()
        
        -- Criar Explosão Visual na tela
        local Explosion = Instance.new("Explosion")
        Explosion.Position = HRP.Position
        Explosion.BlastRadius = 0 -- Garante que não empurre nada de verdade (puramente visual)
        Explosion.Parent = workspace
    end)
end)

-- 🩻 BOTÃO RAGDOLL LOCAL (Deixa seu próprio boneco duro no chão)
local RagdollBtn = Instance.new("TextButton")
RagdollBtn.Size = UDim2.new(0, 155, 1, 0)
RagdollBtn.BackgroundColor3 = Color3.fromRGB(45, 95, 145)
RagdollBtn.Text = "🩻 Ragdoll (Local)"
RagdollBtn.TextColor3 = Color3.fromRGB(220, 240, 255)
RagdollBtn.Font = Enum.Font.GothamBold
RagdollBtn.TextSize = 12
RagdollBtn.Parent = ActionFrame
Instance.new("UICorner").CornerRadius = UDim.new(0, 8)

local RagdollAtivado = false
local ConexaoRagdoll = nil

RagdollBtn.MouseButton1Click:Connect(function()
    local Char = LocalPlayer.Character
    if not Char or not Char:FindFirstChild("Humanoid") or not Char:FindFirstChild("HumanoidRootPart") then return end
    local Hum = Char.Humanoid
    
    RagdollAtivado = not RagdollAtivado
    
    if RagdollAtivado then
        RagdollBtn.BackgroundColor3 = Color3.fromRGB(95, 145, 45) -- Fica verde indicando ativo
        RagdollBtn.Text = "🩻 Ativo (Clique p/ Sair)"
        
        -- Configura o estado físico local para simular o corpo "duro e mole" ao mesmo tempo
        Hum.PlatformStand = true
        
        -- Força o boneco a tombar aplicando uma pequena rotação e mantendo os membros fixos
        Char.HumanoidRootPart.Velocity = Char.HumanoidRootPart.CFrame.LookVector * 10
        
        -- Loop local para desativar animações oficiais enquanto estiver caído
        ConexaoRagdoll = RunService.RenderStepped:Connect(function()
            if Char:FindFirstChild("Animate") then
                Char.Animate.Disabled = true
            end
            for _, limb in pairs(Char:GetChildren()) do
                if limb:IsA("BasePart") and limb.Name ~= "HumanoidRootPart" then
                    limb.CanCollide = true -- Evita atravessar o chão completamente
                end
            end
        end)
    else
        -- Desativa o efeito e levanta o seu personagem
        RagdollBtn.BackgroundColor3 = Color3.fromRGB(45, 95, 145)
        RagdollBtn.Text = "🩻 Ragdoll (Local)"
        
        Hum.PlatformStand = false
        if ConexaoRagdoll then
            ConexaoRagdoll:Disconnect()
            ConexaoRagdoll = nil
        end
        if Char:FindFirstChild("Animate") then
            Char.Animate.Disabled = false
        end
        -- Pequeno reset na física para ele levantar imediatamente
        Hum:ChangeState(Enum.HumanoidStateType.GettingUp)
    end
end)

-- [[ SEÇÃO 5: SISTEMA DE ARRASTAR O PAINEL (MOBILE COMPATIBLE) ]]
local dragging, dragInput, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
