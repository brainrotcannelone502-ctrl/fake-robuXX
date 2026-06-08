-- NOVO PROJETO: HUB DE SIMULAÇÃO VISUAL (ZERO REUSE)
-- Inspirado na interface da imagem image_979903.png

local Players = game:GetService("Players")
local Chat = game:GetService("Chat")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variaveis de seleção
local jogadorSelecionado = nil

-- Criar a Interface Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomSimHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game.CoreGui

-- Painel Principal (Igual ao estilo escuro/roxo da imagem)
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 480)
MainFrame.Position = UDim2.new(0.5, -160, 0.5, -240)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 10, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

-- Borda Arredondada do Painel
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Linha de Detalhe Roxo no topo
local TopLine = Instance.new("Frame")
TopLine.Size = UDim2.new(1, 0, 0, 4)
TopLine.BackgroundColor3 = Color3.fromRGB(100, 30, 200)
TopLine.BorderSizePixel = 0
TopLine.Parent = MainFrame

-- Título do HUB
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.6, 0, 0, 40)
Title.Position = UDim2.new(0.05, 0, 0, 5)
Title.Text = "Tsk FV - Sim"
Title.TextColor3 = Color3.fromRGB(200, 200, 200)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

-------------------------------------------------------------------
-- FUNÇÃO PARA ARRASTAR O HUB PELA TELA
-------------------------------------------------------------------
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
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
        update(input)
    end
end)

-------------------------------------------------------------------
-- SEÇÃO: LISTA DE JOGADORES (MINIMIZÁVEL COM SETAS)
-------------------------------------------------------------------
local ListContainer = Instance.new("Frame")
ListContainer.Size = UDim2.new(0.9, 0, 0, 120)
ListContainer.Position = UDim2.new(0.05, 0, 0, 45)
ListContainer.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
ListContainer.BorderSizePixel = 0
ListContainer.Parent = MainFrame

local ListCorner = Instance.new("UICorner")
ListCorner.CornerRadius = UDim.new(0, 6)
ListCorner.Parent = ListContainer

local PlayerListLabel = Instance.new("TextLabel")
PlayerListLabel.Size = UDim2.new(0.7, 0, 0, 25)
PlayerListLabel.Position = UDim2.new(0.05, 0, 0, 0)
PlayerListLabel.Text = "Selecione um Jogador:"
PlayerListLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
PlayerListLabel.Font = Enum.Font.SourceSans
PlayerListLabel.TextSize = 14
PlayerListLabel.TextXAlignment = Enum.TextXAlignment.Left
PlayerListLabel.BackgroundTransparency = 1
PlayerListLabel.Parent = ListContainer

-- Botão de Minimizar/Maximizar (Setas)
local ToggleListBtn = Instance.new("TextButton")
ToggleListBtn.Size = UDim2.new(0, 30, 0, 25)
ToggleListBtn.Position = UDim2.new(0.85, 0, 0, 0)
ToggleListBtn.Text = "▲"
ToggleListBtn.TextColor3 = Color3.fromRGB(100, 30, 200)
ToggleListBtn.Font = Enum.Font.SourceSansBold
ToggleListBtn.TextSize = 14
ToggleListBtn.BackgroundTransparency = 1
ToggleListBtn.Parent = ListContainer

local PlayerScrolling = Instance.new("ScrollingFrame")
PlayerScrolling.Size = UDim2.new(0.9, 0, 0, 85)
PlayerScrolling.Position = UDim2.new(0.05, 0, 0, 25)
PlayerScrolling.BackgroundTransparency = 1
PlayerScrolling.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrolling.ScrollBarThickness = 4
PlayerScrolling.Parent = ListContainer

local ListLayout = Instance.new("UIListLayout")
ListLayout.Padding = UDim.new(0, 4)
ListLayout.Parent = PlayerScrolling

-- Alternar tamanho da lista (Minimizar/Maximizar)
local listMinimizado = false
ToggleListBtn.MouseButton1Click:Connect(function()
    listMinimizado = not listMinimizado
    if listMinimizado then
        PlayerScrolling.Visible = false
        ListContainer.Size = UDim2.new(0.9, 0, 0, 25)
        ToggleListBtn.Text = "▼"
        -- Reajustar posições dos itens de baixo
        MainFrame.ContentContainer.Position = UDim2.new(0, 0, 0, 75)
    else
        PlayerScrolling.Visible = true
        ListContainer.Size = UDim2.new(0.9, 0, 0, 120)
        ToggleListBtn.Text = "▲"
        MainFrame.ContentContainer.Position = UDim2.new(0, 0, 0, 170)
    end
end)

-------------------------------------------------------------------
-- CONTAINER PARA AS FUNÇÕES (MENSAGENS, RAGDOLL, ROCKET)
-------------------------------------------------------------------
local ContentContainer = Instance.new("Frame")
ContentContainer.Name = "ContentContainer"
ContentContainer.Size = UDim2.new(1, 0, 1, -170)
ContentContainer.Position = UDim2.new(0, 0, 0, 170)
ContentContainer.BackgroundTransparency = 1
ContentContainer.Parent = MainFrame

-- Título Mensagens
local MsgTitle = Instance.new("TextLabel")
MsgTitle.Size = UDim2.new(0.9, 0, 0, 20)
MsgTitle.Position = UDim2.new(0.05, 0, 0, 0)
MsgTitle.Text = "MENSAGENS FALSAS (CHAT BUBBLE)"
MsgTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
MsgTitle.Font = Enum.Font.SourceSansBold
MsgTitle.TextSize = 12
MsgTitle.TextXAlignment = Enum.TextXAlignment.Left
MsgTitle.BackgroundTransparency = 1
MsgTitle.Parent = ContentContainer

-- Grid para os 5 botões de frases
local GridFrame = Instance.new("Frame")
GridFrame.Size = UDim2.new(0.9, 0, 0, 100)
GridFrame.Position = UDim2.new(0.05, 0, 0, 25)
GridFrame.BackgroundTransparency = 1
GridFrame.Parent = ContentContainer

local GridLayout = Instance.new("UIGridLayout")
GridLayout.CellSize = UDim2.new(0, 90, 0, 35)
GridLayout.CellPadding = UDim2.new(0, 8, 0, 8)
GridLayout.Parent = GridFrame

local frases = {"obgg", "chegou msmm", "tmj mn", "confiavel de mais", "rpzd"}

-- Título Ações Críticas
local ActionTitle = Instance.new("TextLabel")
ActionTitle.Size = UDim2.new(0.9, 0, 0, 20)
ActionTitle.Position = UDim2.new(0.05, 0, 0, 135)
ActionTitle.Text = "EFEITOS VISUAIS LOCAIS"
ActionTitle.TextColor3 = Color3.fromRGB(150, 150, 150)
ActionTitle.Font = Enum.Font.SourceSansBold
ActionTitle.TextSize = 12
ActionTitle.TextXAlignment = Enum.TextXAlignment.Left
ActionTitle.BackgroundTransparency = 1
ActionTitle.Parent = ContentContainer

-- Botão Ragdoll
local RagdollBtn = Instance.new("TextButton")
RagdollBtn.Size = UDim2.new(0, 135, 0, 40)
RagdollBtn.Position = UDim2.new(0.05, 0, 0, 160)
RagdollBtn.BackgroundColor3 = Color3.fromRGB(45, 15, 75)
RagdollBtn.Text = "RAGDOLL"
RagdollBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RagdollBtn.Font = Enum.Font.SourceSansBold
RagdollBtn.TextSize = 14
RagdollBtn.Parent = ContentContainer

local RagdollCorner = Instance.new("UICorner")
RagdollCorner.CornerRadius = UDim.new(0, 5)
RagdollCorner.Parent = RagdollBtn

-- Botão Rocket
local RocketBtn = Instance.new("TextButton")
RocketBtn.Size = UDim2.new(0, 135, 0, 40)
RocketBtn.Position = UDim2.new(0.52, 0, 0, 160)
RocketBtn.BackgroundColor3 = Color3.fromRGB(120, 20, 50)
RocketBtn.Text = "ROCKET"
RocketBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RocketBtn.Font = Enum.Font.SourceSansBold
RocketBtn.TextSize = 14
RocketBtn.Parent = ContentContainer

local RocketCorner = Instance.new("UICorner")
RocketCorner.CornerRadius = UDim.new(0, 5)
RocketCorner.Parent = RocketBtn

-------------------------------------------------------------------
-- LÓGICA DE ATUALIZAÇÃO DA LISTA DE JOGADORES
-------------------------------------------------------------------
local function atualizarLista()
    for _, child in pairs(PlayerScrolling:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    for _, p in pairs(Players:GetPlayers()) do
        local PBtn = Instance.new("TextButton")
        PBtn.Size = UDim2.new(1, -10, 0, 25)
        PBtn.BackgroundColor3 = (jogadorSelecionado == p) and Color3.fromRGB(100, 30, 200) or Color3.fromRGB(40, 35, 50)
        PBtn.Text = p.Name .. (p == LocalPlayer and " (Você)" or "")
        PBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        PBtn.Font = Enum.Font.SourceSans
        PBtn.TextSize = 14
        PBtn.Parent = PlayerScrolling
        
        local PCorner = Instance.new("UICorner")
        PCorner.CornerRadius = UDim.new(0, 4)
        PCorner.Parent = PBtn
        
        PBtn.MouseButton1Click:Connect(function()
            jogadorSelecionado = p
            atualizarLista()
        end)
    end
    PlayerScrolling.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(atualizarLista)
Players.PlayerRemoving:Connect(atualizarLista)
atualizarLista()

-------------------------------------------------------------------
-- EXECUÇÃO DA FUNÇÃO 1: BALÃO DE FALA ORIGINAL DO ROBLOX
-------------------------------------------------------------------
for _, textoFrase in pairs(frases) do
    local FBtn = Instance.new("TextButton")
    FBtn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    FBtn.Text = textoFrase
    FBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    FBtn.Font = Enum.Font.SourceSans
    FBtn.TextSize = 12
    FBtn.Parent = GridFrame
    
    local FCorner = Instance.new("UICorner")
    FCorner.CornerRadius = UDim.new(0, 4)
    FCorner.Parent = FBtn
    
    FBtn.MouseButton1Click:Connect(function()
        if jogadorSelecionado and jogadorSelecionado.Character and jogadorSelecionado.Character:FindFirstChild("Head") then
            -- Renderiza o balão de fala nativo do Roblox diretamente acima da cabeça do alvo
            Chat:Chat(jogadorSelecionado.Character.Head, textoFrase, Enum.ChatColor.White)
        end
    end)
end

-------------------------------------------------------------------
-- EXECUÇÃO DA FUNÇÃO 2: RAGDOLL LOCAL
-------------------------------------------------------------------
RagdollBtn.MouseButton1Click:Connect(function()
    if jogadorSelecionado and jogadorSelecionado.Character then
        local char = jogadorSelecionado.Character
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if humanoid then
            -- Deixa o boneco rígido simulando queda
            humanoid.PlatformStand = true
            
            -- Aplica uma força física simulada localmente para desequilibrar
            local root = char:FindFirstChild("HumanoidRootPart")
            if root then
                root.Velocity = root.CFrame.LookVector * 5 + Vector3.new(0, -2, 0)
                -- Cria um giro no próprio eixo para dar o efeito de corpo mole caindo duro
                root.RotVelocity = Vector3.new(math.random(-5,5), 0, math.random(-5,5))
            end
        end
    end
end)

-------------------------------------------------------------------
-- EXECUÇÃO DA FUNÇÃO 3: ROCKET LOCAL COM ANIMAÇÕES
-------------------------------------------------------------------
RocketBtn.MouseButton1Click:Connect(function()
    if jogadorSelecionado and jogadorSelecionado.Character then
        local char = jogadorSelecionado.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        
        if root and humanoid then
            humanoid.PlatformStand = true
            
            -- Efeito leve de fogo (Local)
            local fumaçaFogo = Instance.new("Fire")
            fumaçaFogo.Size = 4
            fumaçaFogo.Heat = 10
            fumaçaFogo.Parent = root
            
            -- Animação de subida rígida (Tween local)
            local subidaInfo = TweenInfo.new(2.5, Enum.EasingStyle.QuadIn)
            local alvoCFrame = root.CFrame * CFrame.new(0, 150, 0)
            local subidaTween = TweenService:Create(root, subidaInfo, {CFrame = alvoCFrame})
            
            subidaTween:Play()
            
            subidaTween.Completed:Connect(function()
                -- Interromper fogo
                fumaçaFogo:Destroy()
                
                -- Animação de explosão Visual (Local)
                local expVis = Instance.new("Explosion")
                expVis.BlastRadius = 0 -- 0 para garantir que não cause dano real no jogo, apenas visual
                expVis.Position = root.Position
                expVis.Parent = game.Workspace
                
                -- Se for o próprio jogador, permite cair de volta após um tempo
                task.wait(0.5)
                humanoid.PlatformStand = false
            end)
        end
    end
end)
