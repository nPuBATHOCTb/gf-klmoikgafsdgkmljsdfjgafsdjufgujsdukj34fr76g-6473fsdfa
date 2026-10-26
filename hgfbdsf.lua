if getgenv().FAKE_DOX_LOADED then
    getgenv().FAKE_DOX_LOADED = false
    task.wait(0.2)
end
getgenv().FAKE_DOX_LOADED = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer
local PARENT = (gethui and gethui()) or game:GetService("CoreGui")

local Theme = {
    Background = Color3.fromRGB(8, 8, 8),
    Panel = Color3.fromRGB(12, 12, 12),
    Element = Color3.fromRGB(16, 16, 16),
    Text = Color3.fromRGB(210, 210, 210),
    DimText = Color3.fromRGB(110, 110, 115),
    Accent = Color3.fromRGB(255, 255, 255),
    Red = Color3.fromRGB(255, 60, 60),
    Green = Color3.fromRGB(60, 255, 120),
    Shadow = Color3.fromRGB(0, 0, 0)
}

local function new(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props or {}) do obj[k] = v end
    return obj
end

local function tween(obj, time, props)
    local t = TweenService:Create(obj, TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    t:Play()
    return t
end

local SHADOW_TEX = "rbxassetid://1316045217"

local gui = new("ScreenGui", { Name = "FakeDoxUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, Parent = PARENT })

local MENU_W, MENU_H = 650, 580
local CORNER = 4
local SHADOW_PADDING = 30
local HEADER_H = 40

local mainWrapper = new("Frame", {
    Parent = gui, Size = UDim2.fromOffset(MENU_W + SHADOW_PADDING*2, MENU_H + SHADOW_PADDING*2),
    Position = UDim2.new(0.5, -(MENU_W+SHADOW_PADDING*2)/2, 0.5, -(MENU_H+SHADOW_PADDING*2)/2),
    BackgroundTransparency = 1, BorderSizePixel = 0, ZIndex = 10,
})

local bodyShadow = new("ImageLabel", {
    Parent = mainWrapper, Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1,
    Image = SHADOW_TEX, ImageColor3 = Theme.Shadow, ImageTransparency = 0.2,
    ScaleType = Enum.ScaleType.Stretch, ZIndex = 9,
})

local root = new("Frame", {
    Parent = mainWrapper, Size = UDim2.fromOffset(MENU_W, MENU_H),
    Position = UDim2.fromOffset(SHADOW_PADDING, SHADOW_PADDING),
    BackgroundColor3 = Theme.Background, BorderSizePixel = 0, ClipsDescendants = true, ZIndex = 10,
})
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = root })
new("UIStroke", { Color = Color3.fromRGB(45, 45, 45), Thickness = 1, Transparency = 0, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = root })

local header = new("Frame", { Parent = root, Size = UDim2.new(1, 0, 0, HEADER_H), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, ZIndex = 11 })
new("TextLabel", { Parent = header, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(16, 0), BackgroundTransparency = 1, Text = "FAKE DOX | INTELLIGENCE v3", Font = Enum.Font.GothamBold, TextSize = 14, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 12 })
local closeBtn = new("TextButton", { Parent = header, Size = UDim2.fromOffset(40, 40), Position = UDim2.new(1, -40, 0, 0), BackgroundTransparency = 1, Text = "✕", Font = Enum.Font.Gotham, TextSize = 14, TextColor3 = Theme.DimText, AutoButtonColor = false, ZIndex = 12 })
new("Frame", { Parent = root, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.fromOffset(0, HEADER_H), BackgroundColor3 = Color3.fromRGB(30, 30, 30), BorderSizePixel = 0, ZIndex = 12 })

local content = new("Frame", { Parent = root, Size = UDim2.new(1, -24, 1, -(HEADER_H+24)), Position = UDim2.fromOffset(12, HEADER_H+12), BackgroundTransparency = 1, ZIndex = 11 })

local dragging, dragStart, startPos
header.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true dragStart = input.Position startPos = mainWrapper.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart mainWrapper.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local Names = {"Александр", "Дмитрий", "Максим", "Сергей", "Андрей", "Алексей", "Артем", "Илья", "Кирилл", "Михаил", "Никита", "Матвей", "Роман", "Егор", "Арсений", "Иван", "Денис", "Евгений", "Даниил", "Тимофей"}
local LastNames = {"Иванов", "Смирнов", "Кузнецов", "Попов", "Васильев", "Петров", "Соколов", "Михайлов", "Новиков", "Федоров", "Морозов", "Волков", "Алексеев", "Лебедев", "Семенов", "Егоров", "Павлов", "Козлов", "Степанов", "Николаев"}
local Patronymics = {"Александрович", "Дмитриевич", "Максимович", "Сергеевич", "Андреевич", "Алексеевич", "Артемович", "Ильич", "Кириллович", "Михайлович", "Никитич", "Матвеевич", "Романович", "Егорович", "Арсеньевич", "Иванович", "Денисович", "Евгеньевич", "Даниилович", "Тимофеевич"}
local Cities = {"Москва", "Санкт-Петербург", "Новосибирск", "Екатеринбург", "Казань", "Нижний Новгород", "Челябинск", "Самара", "Омск", "Ростов-на-Дону", "Уфа", "Красноярск", "Воронеж", "Пермь", "Волгоград"}
local Streets = {"Ленина", "Советская", "Мира", "Гагарина", "Пушкина", "Кирова", "Победы", "Комсомольская", "Центральная", "Школьная", "Садовая", "Лесная", "Октябрьская", "Партизанская", "Строителей"}
local Countries = {"Россия", "Беларусь", "Казахстан", "Украина"}
local Jobs = {"Безработный", "Студент", "Офисный работник", "Инженер", "Программист", "Водитель", "Курьер", "Продавец", "Охранник", "Менеджер", "Бухгалтер", "Врач", "Учитель", "Строитель", "Электрик"}
local BloodTypes = {"I (O)", "II (A)", "III (B)", "IV (AB)"}
local PhoneBrands = {"iPhone 14 Pro", "Samsung Galaxy S23", "Xiaomi 13", "Google Pixel 7", "OnePlus 11", "Huawei P60", "Realme GT"}
local CarBrands = {"Toyota Camry", "BMW X5", "Mercedes E-Class", "Audi A6", "Lada Vesta", "Kia Rio", "Hyundai Solaris", "Volkswagen Polo", "Skoda Octavia"}

local function rnd(t) return t[math.random(1, #t)] end

local function GenerateDox()
    local gender = math.random(1, 2) == 1 and "Мужской" or "Женский"
    local fName = rnd(Names)
    local lName = rnd(LastNames) .. (gender == "Женский" and "а" or "")
    local pName = rnd(Patronymics) .. (gender == "Женский" and "а" or "")
    
    local day = string.format("%02d", math.random(1, 28))
    local month = string.format("%02d", math.random(1, 12))
    local year = math.random(1980, 2008)
    
    local country = rnd(Countries)
    local city = rnd(Cities)
    local street = rnd(Streets)
    local house = math.random(1, 150)
    local apt = math.random(1, 300)
    
    local phone = string.format("+7 (%03d) %03d-%02d-%02d", math.random(900, 999), math.random(100, 999), math.random(10, 99), math.random(10, 99))
    local email = string.lower(fName) .. "." .. string.lower(lName) .. "@gmail.com"
    local passport = string.format("%04d %06d", math.random(1000, 9999), math.random(100000, 999999))
    local ip = string.format("%d.%d.%d.%d", math.random(1, 255), math.random(0, 255), math.random(0, 255), math.random(1, 255))
    local snils = string.format("%03d-%03d-%03d %02d", math.random(100, 999), math.random(100, 999), math.random(100, 999), math.random(10, 99))
    local inn = string.format("%012d", math.random(100000000000, 999999999999))
    local card = string.format("4276 %04d %04d %04d", math.random(1000, 9999), math.random(1000, 9999), math.random(1000, 9999))
    local job = rnd(Jobs)
    local blood = rnd(BloodTypes)
    local height = math.random(150, 200)
    local weight = math.random(50, 120)
    local phoneBrand = rnd(PhoneBrands)
    local carBrand = rnd(CarBrands)
    local carPlate = string.format("%s%03d%s%s", string.char(math.random(65, 90)), math.random(100, 999), string.char(math.random(65, 90)), string.char(math.random(65, 90)))

    local motherFName = rnd(Names) .. "а"
    local motherLName = lName
    local motherPName = rnd(Patronymics) .. "а"
    local motherAge = math.random(38, 60)
    local motherJob = rnd(Jobs)

    local fatherFName = rnd(Names)
    local fatherLName = lName
    local fatherPName = rnd(Patronymics)
    local fatherAge = math.random(40, 65)
    local fatherJob = rnd(Jobs)

    local text = string.format([[
══════════ ЛИЧНОЕ ДЕЛО ══════════
Имя: %s
Фамилия: %s
Отчество: %s
Пол: %s
Дата рождения: %s.%s.%s
Рост: %d см
Вес: %d кг
Группа крови: %s

══════════ АДРЕС ══════════
Страна: %s
Город: %s
Улица: %s
Дом: %d
Квартира: %d

══════════ КОНТАКТЫ ══════════
Телефон: %s
Email: %s
IP-адрес: %s
Устройство: %s

══════════ ДОКУМЕНТЫ ══════════
Паспорт: %s
СНИЛС: %s
ИНН: %s
Банковская карта: %s

══════════ РАБОТА И ТРАНСПОРТ ══════════
Должность: %s
Машина: %s
Номер машины: %s

══════════ СЕМЬЯ ══════════
Мать: %s %s %s
Возраст матери: %d
Работа матери: %s

Отец: %s %s %s
Возраст отца: %d
Работа отца: %s
    ]], fName, lName, pName, gender, day, month, year, height, weight, blood, country, city, street, house, apt, phone, email, ip, phoneBrand, passport, snils, inn, card, job, carBrand, carPlate, motherFName, motherLName, motherPName, motherAge, motherJob, fatherFName, fatherLName, fatherPName, fatherAge, fatherJob)
    
    return text
end

local playerList = {}
for _, p in ipairs(Players:GetPlayers()) do table.insert(playerList, p.Name) end

local currentPlayer = LP.Name
local doxText = ""

local playerDropdown = new("TextButton", { Parent = content, Size = UDim2.new(1, -10, 0, 36), Position = UDim2.fromOffset(5, 5), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 14 })
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = playerDropdown })
new("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1, Parent = playerDropdown })
new("TextLabel", { Parent = playerDropdown, Size = UDim2.new(1, -60, 1, 0), Position = UDim2.fromOffset(12, 0), BackgroundTransparency = 1, Text = "Target:", Font = Enum.Font.Gotham, TextSize = 12, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 15 })
local playerValLbl = new("TextLabel", { Parent = playerDropdown, Size = UDim2.new(0, 150, 1, 0), Position = UDim2.new(1, -160, 0, 0), BackgroundTransparency = 1, Text = currentPlayer, Font = Enum.Font.GothamBold, TextSize = 11, TextColor3 = Theme.Accent, TextXAlignment = Enum.TextXAlignment.Right, ZIndex = 15 })

local listFrame = new("Frame", { Parent = playerDropdown, Size = UDim2.new(1, 0, 0, #playerList * 26), Position = UDim2.new(0, 0, 1, 2), BackgroundColor3 = Color3.fromRGB(14, 14, 14), BorderSizePixel = 0, Visible = false, ZIndex = 100 })
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = listFrame })
new("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1, Parent = listFrame })
new("UIListLayout", { Parent = listFrame, Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder })
new("UIPadding", { PaddingTop = UDim.new(0, 2), Parent = listFrame })

for _, pName in ipairs(playerList) do
    local opt = new("TextButton", { Parent = listFrame, Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, Text = pName, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Theme.Text, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 101 })
    new("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = opt })
    opt.MouseEnter:Connect(function() tween(opt, 0.1, { BackgroundTransparency = 0.9, BackgroundColor3 = Theme.Accent }) end)
    opt.MouseLeave:Connect(function() tween(opt, 0.1, { BackgroundTransparency = 1 }) end)
    opt.MouseButton1Click:Connect(function() currentPlayer = pName playerValLbl.Text = pName listFrame.Visible = false end)
end
playerDropdown.MouseButton1Click:Connect(function() listFrame.Visible = not listFrame.Visible end)

local doxBox = new("TextBox", { Parent = content, Size = UDim2.new(1, -10, 1, -100), Position = UDim2.fromOffset(5, 50), BackgroundColor3 = Color3.fromRGB(10, 10, 10), BorderSizePixel = 0, Text = "", TextColor3 = Theme.Text, Font = Enum.Font.Code, TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Top, TextWrapped = true, MultiLine = true, ClearTextOnFocus = false, TextEditable = true, ZIndex = 14 })
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = doxBox })
new("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1, Parent = doxBox })
new("UIPadding", { PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), Parent = doxBox })

local genBtn = new("TextButton", { Parent = content, Size = UDim2.new(0.5, -8, 0, 36), Position = UDim2.new(0, 5, 1, -40), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Text = "GENERATE DOX", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Green, AutoButtonColor = false, ZIndex = 14 })
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = genBtn })
new("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1, Parent = genBtn })

local copyBtn = new("TextButton", { Parent = content, Size = UDim2.new(0.5, -8, 0, 36), Position = UDim2.new(0.5, 3, 1, -40), BackgroundColor3 = Theme.Element, BorderSizePixel = 0, Text = "COPY TO CLIPBOARD", Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Theme.Accent, AutoButtonColor = false, ZIndex = 14 })
new("UICorner", { CornerRadius = UDim.new(0, CORNER), Parent = copyBtn })
new("UIStroke", { Color = Color3.fromRGB(35, 35, 35), Thickness = 1, Parent = copyBtn })

genBtn.MouseButton1Click:Connect(function()
    genBtn.Text = "GENERATING..."
    task.wait(0.2)
    doxText = "Target: " .. currentPlayer .. "\n" .. GenerateDox()
    doxBox.Text = doxText
    genBtn.Text = "GENERATE DOX"
end)

copyBtn.MouseButton1Click:Connect(function()
    if doxText == "" then return end
    local success = false
    if setclipboard then success = pcall(setclipboard, doxText) end
    if not success and toclipboard then success = pcall(toclipboard, doxText) end
    if success then
        copyBtn.Text = "COPIED!"
        copyBtn.TextColor3 = Theme.Green
        task.wait(1.5)
        copyBtn.Text = "COPY TO CLIPBOARD"
        copyBtn.TextColor3 = Theme.Accent
    else
        copyBtn.Text = "MANUAL COPY (Ctrl+A)"
        copyBtn.TextColor3 = Theme.Red
        task.wait(2)
        copyBtn.Text = "COPY TO CLIPBOARD"
        copyBtn.TextColor3 = Theme.Accent
    end
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
