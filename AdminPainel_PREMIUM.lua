-- ============ ADMIN PANEL PREMIUM v1.0 ============
-- 🔐 LICENCIADO - USO RESTRITO
-- 💰 $99.99 USD / Mês

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local DataStoreService = game:GetService("DataStoreService")

-- ⭐ CONFIGURAÇÃO
local LICENSE_KEY = "ADMIN-PANEL-2026-PREMIUM-XXXXX"
local LICENSE_EMAIL = "suporte@seugame.com"
local HOTKEY = Enum.KeyCode.F10

local licenseStore = DataStoreService:GetDataStore("AdminPanel_Licenses")
local urlStore = DataStoreService:GetDataStore("AdminPanel_URLs")

-- ============ ENCURTADOR DE URL ============

local URLShortener = {}

if not _G.ShortenedURLs then
    _G.ShortenedURLs = {}
end

local function generateShortCode(length)
    length = length or 6
    local chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local code = ""
    
    for i = 1, length do
        local randomIndex = math.random(1, #chars)
        code = code .. string.sub(chars, randomIndex, randomIndex)
    end
    
    return code
end

function URLShortener.shorten(longURL)
    if not longURL or longURL == "" then
        return nil
    end
    
    local shortCode = generateShortCode(6)
    
    while _G.ShortenedURLs[shortCode] do
        shortCode = generateShortCode(6)
    end
    
    _G.ShortenedURLs[shortCode] = longURL
    
    pcall(function()
        urlStore:SetAsync("url_" .. shortCode, longURL)
    end)
    
    return shortCode
end

function URLShortener.shortenWithTinyURL(longURL, callback)
    local success, result = pcall(function()
        local encodedURL = HttpService:UrlEncode(longURL)
        return HttpService:GetAsync("http://tinyurl.com/api-create.php?url=" .. encodedURL)
    end)
    
    if success and callback then
        callback(result)
    end
end

function URLShortener.auto(longURL, callback)
    URLShortener.shortenWithTinyURL(longURL, function(result)
        if result then
            if callback then callback(result) end
            return
        end
        
        local shortCode = URLShortener.shorten(longURL)
        if callback then callback(shortCode) end
    end)
end

_G.URLShortener = URLShortener

-- ============ VALIDAÇÃO DE LICENÇA ============

local function checkLocalLicense(key)
    local success, data = pcall(function()
        return licenseStore:GetAsync("license_" .. key)
    end)
    
    if success and data and os.time() <= data.expiryDate then
        return true, data
    end
    
    return false, "Licença inválida"
end

local function validateLicense(key)
    print("\n════════════════════════════════")
    print("🔐 VALIDANDO LICENÇA...")
    print("════════════════════════════════\n")
    
    local isValid, licenseData = checkLocalLicense(key)
    
    if not isValid then
        print("❌ ERRO: " .. licenseData)
        print("📧 Contato: " .. LICENSE_EMAIL)
        print("════════════════════════════════\n")
        return false
    end
    
    print("✅ LICENÇA VÁLIDA!")
    print("👤 Proprietário: " .. licenseData.ownerName)
    print("📅 Vencimento: " .. os.date("%d/%m/%Y", licenseData.expiryDate))
    print("════════════════════════════════\n")
    
    return true, licenseData
end

-- ============ VERIFICAÇÃO INICIAL ============

local isLicenseValid, licenseInfo = validateLicense(LICENSE_KEY)

if not isLicenseValid then
    return
end

-- ============ SISTEMA DE ADMIN ============

local admins = licenseInfo.admins or {"Davi0910213"}
local isFlying = false
local flySpeed = 50
local flyConnection = nil
local viewingPlayer = nil
local selectedPlayerName = ""

local function isAdmin(username)
    for _, adminName in ipairs(admins) do
        if adminName == username then
            return true
        end
    end
    return false
end

-- ============ PAINEL GUI ============

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if not isAdmin(player.Name) then
    print("❌ Você não é admin!")
    return
end

print("✅ Painel carregando...\n")

-- Criar ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AdminPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 650)
mainFrame.Position = UDim2.new(0, 15, 0, 15)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
mainFrame.BorderSizePixel = 3
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
titleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "👑 ADMIN PANEL PREMIUM"
titleLabel.Parent = mainFrame

-- ScrollingFrame
local scrollFrame = Instance.new("ScrollingFrame")
scrollFrame.Size = UDim2.new(1, -10, 1, -70)
scrollFrame.Position = UDim2.new(0, 5, 0, 55)
scrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
scrollFrame.BorderSizePixel = 0
scrollFrame.ScrollBarThickness = 8
scrollFrame.Parent = mainFrame

local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollFrame

-- Função para criar botão
local function createButton(parent, text, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -10, 0, 35)
    button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.TextSize = 12
    button.Font = Enum.Font.Gotham
    button.Text = text
    button.BorderColor3 = Color3.fromRGB(255, 165, 0)
    button.BorderSizePixel = 2
    button.Parent = parent
    
    button.MouseButton1Click:Connect(callback)
    
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 80)
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    end)
end

-- ============ BOTÕES ============

createButton(scrollFrame, "👥 Listar Jogadores", function()
    print("\n=== JOGADORES ===")
    for _, p in ipairs(Players:GetPlayers()) do
        print("👤 " .. p.Name)
    end
    print("================\n")
end)

createButton(scrollFrame, "🚀 Voar", function()
    isFlying = not isFlying
    
    if isFlying then
        local camera = workspace.CurrentCamera
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bodyVelocity.Parent = camera
        
        local velocityRef = bodyVelocity
        
        flyConnection = RunService.RenderStepped:Connect(function()
            if isFlying and velocityRef and velocityRef.Parent then
                local direction = Vector3.new(0, 0, 0)
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    direction = direction + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    direction = direction - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    direction = direction - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    direction = direction + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    direction = direction + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    direction = direction - Vector3.new(0, 1, 0)
                end
                
                if direction.Magnitude > 0 then
                    direction = direction.Unit
                end
                
                velocityRef.Velocity = direction * flySpeed
            end
        end)
        
        print("✅ Voar ativado!")
    else
        if flyConnection then
            flyConnection:Disconnect()
        end
        print("❌ Voar desativado!")
    end
end)

createButton(scrollFrame, "💀 Matar", function()
    if selectedPlayerName == "" then
        print("❌ Selecione um jogador!")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayerName)
    if targetPlayer and targetPlayer.Character then
        local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Health = 0
            print("✅ " .. selectedPlayerName .. " morreu!")
        end
    end
end)

createButton(scrollFrame, "🚫 Banir", function()
    if selectedPlayerName == "" then
        print("❌ Selecione um jogador!")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayerName)
    if targetPlayer then
        targetPlayer:Kick("Banido do servidor")
        print("✅ " .. selectedPlayerName .. " foi banido!")
    end
end)

createButton(scrollFrame, "👁️ Ver Visão", function()
    if selectedPlayerName == "" then
        print("❌ Selecione um jogador!")
        return
    end
    
    local targetPlayer = Players:FindFirstChild(selectedPlayerName)
    if targetPlayer and targetPlayer.Character then
        viewingPlayer = targetPlayer
        print("✅ Vendo: " .. selectedPlayerName)
    end
end)

createButton(scrollFrame, "🔌 Parar de Ver", function()
    viewingPlayer = nil
    if player.Character then
        workspace.CurrentCamera.CFrame = player.Character.Head.CFrame
    end
    print("❌ Visão normalizada!")
end)

createButton(scrollFrame, "🔗 Encurtar URL", function()
    local dialog = Instance.new("ScreenGui")
    dialog.Parent = playerGui
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 180)
    frame.Position = UDim2.new(0.5, -200, 0.5, -90)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderColor3 = Color3.fromRGB(255, 165, 0)
    frame.BorderSizePixel = 3
    frame.Parent = dialog
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    title.TextColor3 = Color3.fromRGB(0, 0, 0)
    title.Text = "🔗 ENCURTAR URL"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.Parent = frame
    
    local input = Instance.new("TextBox")
    input.Size = UDim2.new(0.9, 0, 0, 40)
    input.Position = UDim2.new(0.05, 0, 0.25, 0)
    input.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.PlaceholderText = "Cole a URL longa"
    input.BorderColor3 = Color3.fromRGB(255, 165, 0)
    input.BorderSizePixel = 2
    input.Parent = frame
    
    local resultLabel = Instance.new("TextLabel")
    resultLabel.Size = UDim2.new(0.9, 0, 0, 30)
    resultLabel.Position = UDim2.new(0.05, 0, 0.5, 0)
    resultLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    resultLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    resultLabel.TextSize = 10
    resultLabel.Font = Enum.Font.GothamMonospace
    resultLabel.Text = "Resultado aqui"
    resultLabel.Parent = frame
    
    local shortenBtn = Instance.new("TextButton")
    shortenBtn.Size = UDim2.new(0.4, 0, 0, 35)
    shortenBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
    shortenBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
    shortenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    shortenBtn.Text = "ENCURTAR"
    shortenBtn.Font = Enum.Font.GothamBold
    shortenBtn.BorderColor3 = Color3.fromRGB(0, 200, 150)
    shortenBtn.BorderSizePixel = 2
    shortenBtn.Parent = frame
    
    shortenBtn.MouseButton1Click:Connect(function()
        local url = input.Text
        if url ~= "" then
            resultLabel.Text = "⏳ Processando..."
            
            URLShortener.auto(url, function(shortURL)
                if shortURL then
                    resultLabel.Text = "✅ " .. tostring(shortURL)
                else
                    resultLabel.Text = "❌ Erro"
                end
            end)
        end
    end)
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0.4, 0, 0, 35)
    closeBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Text = "FECHAR"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderColor3 = Color3.fromRGB(255, 100, 100)
    closeBtn.BorderSizePixel = 2
    closeBtn.Parent = frame
    
    closeBtn.MouseButton1Click:Connect(function()
        dialog:Destroy()
    end)
end)

createButton(scrollFrame, "❌ Fechar", function()
    mainFrame.Visible = false
end)

-- ============ SELEÇÃO DE JOGADOR ============

local playerLabel = Instance.new("TextLabel")
playerLabel.Size = UDim2.new(1, -10, 0, 20)
playerLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
playerLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
playerLabel.TextSize = 11
playerLabel.Font = Enum.Font.GothamBold
playerLabel.Text = "👥 JOGADOR"
playerLabel.Parent = scrollFrame

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -10, 0, 30)
inputBox.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
inputBox.PlaceholderText = "Digite nome"
inputBox.BorderColor3 = Color3.fromRGB(255, 165, 0)
inputBox.BorderSizePixel = 1
inputBox.Parent = scrollFrame

local confirmButton = Instance.new("TextButton")
confirmButton.Size = UDim2.new(1, -10, 0, 30)
confirmButton.BackgroundColor3 = Color3.fromRGB(0, 150, 100)
confirmButton.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmButton.Text = "✓ CONFIRMAR"
confirmButton.Font = Enum.Font.GothamBold
confirmButton.BorderColor3 = Color3.fromRGB(0, 200, 150)
confirmButton.BorderSizePixel = 2
confirmButton.Parent = scrollFrame

local selectedLabel = Instance.new("TextLabel")
selectedLabel.Size = UDim2.new(1, -10, 0, 20)
selectedLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
selectedLabel.TextSize = 10
selectedLabel.Font = Enum.Font.Gotham
selectedLabel.Text = "❌ Nenhum selecionado"
selectedLabel.Parent = scrollFrame

-- ============ FUNÇÃO DE SELEÇÃO ============

local function selectPlayer()
    local inputText = inputBox.Text:match("^%s*(.-)%s*$")
    
    if inputText == "" then return end
    
    local targetPlayer = Players:FindFirstChild(inputText)
    if targetPlayer then
        selectedPlayerName = targetPlayer.Name
        selectedLabel.Text = "✅ " .. selectedPlayerName
        selectedLabel.TextColor3 = Color3.fromRGB(0, 255, 100)
        inputBox.Text = ""
    else
        selectedLabel.Text = "❌ Não encontrado"
        selectedLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
end

confirmButton.MouseButton1Click:Connect(selectPlayer)
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then selectPlayer() end
end)

-- ============ VISÃO DE OUTRO JOGADOR ============

RunService.RenderStepped:Connect(function()
    if viewingPlayer and viewingPlayer.Character then
        local hrp = viewingPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            workspace.CurrentCamera.CFrame = hrp.CFrame + hrp.CFrame.LookVector * 5
        end
    end
end)

-- ============ HOTKEY ============

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == HOTKEY then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

print("✅ Admin Panel carregado!")
print("📌 Pressione F10 para abrir\n")
