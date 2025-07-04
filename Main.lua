if game.PlaceId ~= 2809202155 then
    local Folder = Instance.new("Folder", workspace)
    Folder.Name = "Item_Spawns"
    local Folder2 = Instance.new("Folder", Folder)
    Folder2.Name = "Items"
end

local MapFolder = Instance.new("Folder", workspace)

for _, Part in workspace.Map:GetChildren() do
    task.spawn(function()
        Part.Parent = MapFolder
    end)
end

local Xenon = {Utils={}}
Xenon.__index = Xenon
Xenon.Utils.__index = Xenon.Utils


--// Shortened functions
local v3 = Vector3.new
local cf = CFrame.new
local hf = 1
--// V3 UI Library
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/9YwM8kt6"))()

--// Xenon V3 Library ;o
function Xenon.Utils.MakeUtilController(Settings)
    local Utils = {
        Tasks = {};
        Tweens = {};
        Services = {};
        States = {};
        Ints = {};
        Strings = {};
        Tables = {};
        Settings = Settings or {ConfigName = "XenonV3/XenonConfig.json"};
        LogFile = nil;
    }
    Utils.Services = setmetatable({}, {__index = function(self, service)
        if rawget(self, service) then return rawget(self, service) end
        local GotService = game:GetService(service)
        self[service] = GotService
        return self[service]
    end})
    return setmetatable(Utils, Xenon.Utils)
end

function Xenon.Utils:Beautify(String)
    local Str = String
    for i = 3, #Str do
        local Char = Str:sub(i, i)
        local PrevChar = Str:sub(i-1, i-1)
        local PrevChar2 = Str:sub(i-2, i-2)
        if (PrevChar2 == ":" and PrevChar == "[") or (PrevChar2 == '"' and PrevChar == ",") or (PrevChar2 == "[" and PrevChar == "[") then
            local StrPart1 = Str:sub(1, i-1)
            local StrPart2 = "    " .. Char .. Str:sub(i+1, #Str)
            Str = StrPart1 .. StrPart2
        end
    end
    --[[Str = Str:gsub("{", "{\n")
    Str = Str:gsub("%[", "[\n")
    Str = Str:gsub("%],", "\n],")
    Str = Str:gsub(",", ",\n")
    Str = Str:gsub("}", "\n}")--]]
    return Str
end

function Xenon.Utils:Log(Text)
    if self.LogFile == nil then
        local num = 0
        repeat num = num + 1 until isfile("XenonV3/Logs/XenonV3_ScriptLog_" .. num .. ".txt") == false
        self.LogFile = "XenonV3/Logs/XenonV3_ScriptLog_" .. num .. ".txt"
        writefile(self.LogFile, "")
    end
    appendfile(self.LogFile, Text .. "\n")
end

function Xenon.Utils:GetLogPath()
    return self.LogFile
end

function Xenon.Utils:MakeFolder()
	if isfolder("XenonV3") == false then 
        makefolder("XenonV3")
    end
    if isfolder("XenonV3/Logs") == false then 
        makefolder("XenonV3/Logs")
    end
end

function Xenon.Utils:ConvertConfig(Config)
    local RepTable = Config
    for i,v in pairs(RepTable) do
        for ValName, ValueTable in pairs(v) do
            if ValueTable["Value"] ~= nil then
                local Val = ValueTable.Value
                ValueTable["Value"] = nil
                ValueTable[1] = Val
            end
        end
    end
    return RepTable
end

function Xenon.Utils:ReadData()
	self:MakeFolder()
    local Data;
    local Success, Error = pcall(function()
        Data = self.Services.HttpService:JSONDecode(readfile(self.Settings.ConfigName))
    end);
    Data = Data or loadstring(game:HttpGet("https://pastebin.com/raw/XXkRbtKN"))()
    return {
        Data = Data;
        Success = Success;
        Error = Error;
        LoadData = function()
            self:AddValues(self:ConvertConfig(Data))
            self:SaveConfig();
        end;
    }
end

function Xenon.Utils:WriteData(Data)
	self:MakeFolder()
    local StringData = self.Services.HttpService:JSONEncode(Data)
    local Success, Error = pcall(function()
        writefile(self.Settings.ConfigName, StringData)
    end)
    return Success, Error
end

function Xenon.Utils:DeleteData()
    if isfile(self.Settings.ConfigName) then
        delfile(self.Settings.ConfigName)
    end
end

function Xenon.Utils:AddValues(Values)
    for key, value in pairs(Values) do
        if key:lower() == "int" then
            for i,v in pairs(Values[key]) do
                self.Ints[i] = (type(v) == "number" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
            end
        end
        if key:lower() == "state" then
            for i,v in pairs(Values[key]) do
                self.States[i] = (type(v) == "boolean" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
            end
        end
        if key:lower() == "string" then
            for i,v in pairs(Values[key]) do
                self.Strings[i] = (type(v) == "string" and {["Value"] = v, ["SaveValue"] = false} or type(v) == "table" and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]})
            end
        end
        if key:lower() == "table" then
            for i,v in pairs(Values[key]) do
                self.Tables[i] = ((v["SaveValue"] and v["SaveValue"] == true) and {["Value"] = v[1], ["SaveValue"] = v["SaveValue"]} or {["Value"] = v, ["SaveValue"] = false})
            end
        end
    end
end

function Xenon.Utils:GetInt(Value)
    if self.Ints[Value] then
        return self.Ints[Value].Value
    end
    return
end

function Xenon.Utils:GetString(Value)
    if self.Strings[Value] then
        return self.Strings[Value].Value
    end
    return
end

function Xenon.Utils:GetState(Value)
    if self.States[Value] then
        return self.States[Value].Value
    end
    return
end

function Xenon.Utils:GetTable(Value)
    if self.Tables[Value] then
		
        return self.Tables[Value].Value
    end
    return {}
end

function Xenon.Utils:SetInt(Value, NewValue)
    if self.Ints[Value] then
        self.Ints[Value].Value = NewValue
    end
end

function Xenon.Utils:SetString(Value, NewValue)
    if self.Strings[Value] then
        self.Strings[Value].Value = NewValue
    end
end

function Xenon.Utils:SetState(Value, NewValue)
    if self.States[Value] then
        self.States[Value].Value = NewValue
    end
end

function Xenon.Utils:SetTable(Value, NewValue)
    if self.Tables[Value] then
        self.Tables[Value].Value = NewValue
    end
end

function Xenon.Utils:ChangeTable(Value, TableIndex, NewValue)
    if self.Tables[Value] then
        self.Tables[Value].Value[TableIndex] = NewValue
    end
end

function Xenon.Utils:InsertTable(Value, InsertedValue)
    if self.Tables[Value] then
        table.insert(self.Tables[Value].Value, InsertedValue)
    end
end

function Xenon.Utils:RemoveTable(Value, RemovedValue)
    if self.Tables[Value] then
        table.remove(self.Tables[Value].Value, table.find(self.Tables[Value].Value, RemovedValue))
    end
end

function Xenon.Utils:FindTable(Value, TableIndex)
    return table.find(self.Tables[Value].Value, TableIndex)
end

function Xenon.Utils:SaveConfig()
    local ScrapedTable = {Int={};State={};String={};Table={}}
    for i,v in pairs(self.Ints) do
        if v.SaveValue == true then
            ScrapedTable.Int[i] = v
        end
    end
    for i,v in pairs(self.States) do
        if v.SaveValue == true then
            ScrapedTable.State[i] = v
        end
    end
    for i,v in pairs(self.Strings) do
        if v.SaveValue == true then
            ScrapedTable.String[i] = v
        end
    end
    for i,v in pairs(self.Tables) do
        if v.SaveValue == true then
            ScrapedTable.Table[i] = v
        end
    end
    return self:WriteData(ScrapedTable)
end

function Xenon.Utils:GetService(Service)
    return self.Services[Service]
end

function Xenon.Utils:GetPlayer()
    return self.Services.Players.LocalPlayer
end

function Xenon.Utils:GetCharacter()
    return self:GetPlayer().Character or self:GetPlayer().CharacterAdded:Wait()
end

function Xenon.Utils:GetHumanoid()
    local Character = self:GetCharacter()
    if Character then
        return Character:FindFirstChildWhichIsA("Humanoid")
    end
end

function Xenon.Utils:GetHRP()
    local Character = self:GetCharacter()
    if Character then
        return Character:FindFirstChild("HumanoidRootPart")
    end
end

function Xenon.Utils:GetRoot()
    local Character = self:GetCharacter()
    if Character then
        return Character:FindFirstChild("LowerTorso"):FindFirstChild("Root")
    end
end

function Xenon.Utils:GetHorse()
    local Name = self:GetPlayer().Name
    if workspace:FindFirstChild(Name .."'s Horse") ~= nil then
        return workspace:FindFirstChild(Name .."'s Horse")
    else
        return nil
    end
end

function Xenon.Utils:HasProperty(Part, Property)
    local Success = pcall(function() 
        local a = Part[Property]
    end)
    
    return (Success and true or false)
end

function Xenon.Utils:Compare(A, B)
    local InsidesA, InsidesB = A:GetChildren(), B:GetChildren()
    local CompareableProperties = {"Color", "Reflectance", "MeshId", "TextureID", "Size", "Anchored", "CanCollide", "Transparency"}

    for i,v in pairs(InsidesB) do
        if v:IsA("ClickDetector") then
            InsidesB[i] = nil
        elseif v:IsA("Model") then
            for i,v in pairs(v:GetChildren()) do
                    table.insert(InsidesB, v)
            end
        end
    end
    for i,v in pairs(InsidesA) do
        if v:IsA("ClickDetector") then
            InsidesB[i] = nil
        elseif v:IsA("Model") then
            for i,v in pairs(v:GetChildren()) do
                    table.insert(InsidesA, v)
            end
        end
    end
    for _, CompareItem in pairs(InsidesA) do
            for _, CompareItem2 in pairs(InsidesB) do
                    local GoodProps = 0
                    local TotalProps = 0
                    for _, Prop in pairs(CompareableProperties) do
                        if self:HasProperty(CompareItem, Prop) and self:HasProperty(CompareItem2, Prop) then
                            if CompareItem[Prop] == CompareItem2[Prop] then
                                    GoodProps = GoodProps + 1
                            end
                            TotalProps = TotalProps + 1
                        end
                    end 
                    if TotalProps > 0 and GoodProps == TotalProps then
                        return true
                    end
            end
        end
    return false
end

function Xenon.Utils:Identify(Item)
    repeat task.wait() until Item:FindFirstChildWhichIsA("ProximityPrompt")
    for i,v in pairs(Item:GetChildren()) do
        if v:IsA("ProximityPrompt") and v.MaxActivationDistance > 0 then
            return v.ObjectText
        end
    end

    return "Invalid Item"
end

function Xenon.Utils:WaitTillBackpackLoaded()
    local Backpack = self:GetPlayer().Backpack
    local BackpackCount = #Backpack:GetChildren()
    local StartCheck = tick()
    while true do 
        task.wait() 
        if tick() - StartCheck >= 0.1 and BackpackCount == #Backpack:GetChildren() then
            break
        elseif BackpackCount ~= #Backpack:GetChildren() then
            BackpackCount = #Backpack:GetChildren();
            StartCheck = tick()
        end
    end
    return
end

function Xenon.Utils:CountItem(Item)
    self:WaitTillBackpackLoaded();
    local Backpack = self:GetPlayer().Backpack
    local Count = 0
    for i, v in pairs(Backpack:GetChildren()) do
        if v.Name == Item then
            Count = Count + 1
        end
    end

    local Char = self:GetCharacter()
    if Char and Char:FindFirstChildWhichIsA("Tool") and Char:FindFirstChildWhichIsA("Tool").Name == Item then
        Count += 1
    end
    return Count
end

function Xenon.Utils:Has2X()
    if game:GetService("MarketplaceService"):UserOwnsGamePassAsync(self:GetPlayer().UserId, 14597778) then
        return true
    end
    return false
end

function Xenon.Utils:IsMax(Item) 
    local Max = {
        ["Diamond"] = 30,
        ["Gold Coin"] = 45,
        ["Mysterious Arrow"] = 25,
        ["Pure Rokakaka"] = 10,
        ["Rokakaka"] = 25,
        ["Stone Mask"] = 10,
        ["Rib Cage of The Saint's Corpse"] = 10,
        ["Steel Ball"] = 10,
        ["Ancient Scroll"] = 10,
        ["Dio's Diary"] = 10,
        ["Caesar's Headband"] = 10,
        ["Christmas Present"] = 45,
        ["Quinton's Glove"] = 10,
        ["Lucky Arrow"] = 10
    }
    if self:Has2X() then
        for i,v in pairs(Max) do
            Max[i] = v * 2
        end
    end
    --self:WaitTillBackpackLoaded()
    return self:CountItem(Item) >= Max[Item]
end

function Xenon.Utils:Freeze(State)
    local Character = self:GetCharacter()
    if Character and Character.Humanoid then
        Character.Humanoid.WalkSpeed = (State == true and 0 or 16)
    end
end

function Xenon.Utils:Teleport(CF, Offset)
    local Character = self:GetCharacter()
    local FinalCF;
    if typeof(CF) == "Vector3" then
        FinalCF = cf(CF)
    else
        FinalCF = CF
    end

    if Character and Character.PrimaryPart then
        Character.PrimaryPart.CFrame = FinalCF + (Offset and Offset or v3(0, 0, 0))
    end
end

function Xenon.Utils:GetDistance(Part)
    local Character = self:GetCharacter()
    local HRP = Character and Character:FindFirstChild("HumanoidRootPart")
    if Character and HRP then
        return math.round(math.abs((HRP.Position-Part.Position).Magnitude))
    end
    return 0
end

function Xenon.Utils:AddToQueue(Item)
    local IdentifiedItem = self:Identify(Item)

    if IdentifiedItem ~= "Invalid Item" then
        repeat task.wait() until Item:FindFirstChild("ProximityPrompt")
        local ItemData = {CFrame = Item.PrimaryPart.CFrame, ItemName = IdentifiedItem, ItemModel = Item}
        Item.Name = IdentifiedItem 
        
        local ESPPart = Instance.new("Part", workspace)
        ESPPart.Name = IdentifiedItem
        ESPPart.CFrame = ItemData.CFrame
        ESPPart.Anchored = true
        ESPPart.CanCollide = false
        ESPPart.Transparency = 1

        local Billboard = Instance.new("BillboardGui", ESPPart)
        Billboard.AlwaysOnTop = true
        Billboard.Size = UDim2.new(8, 0, 2, 0)
        Billboard.StudsOffset = Vector3.new(0, 2, 0)
        Billboard.ClipsDescendants = false
        Billboard.Name = "XenonESP"
        Billboard.Enabled = false

        local ESPLabel = Instance.new("TextLabel", Billboard)
        ESPLabel.Size = UDim2.new(0, 100, 0, 100)
        ESPLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
        ESPLabel.BackgroundTransparency = 1
        ESPLabel.AnchorPoint = Vector2.new(0.5, 0.5)
        ESPLabel.Text = IdentifiedItem
        ESPLabel.TextColor3 = Color3.new(1, 1, 1)
        ESPLabel.TextStrokeTransparency = 0

        if self:GetState("Item Notify") == true and table.find(self:GetTable("Items"), IdentifiedItem) then
            Library:Notification("Item Spawned", ("A new item has spawned: " .. IdentifiedItem), 4, {
                    [1] = {
                        Text = "Teleport";
                        Callback = function()
                            local Character = self:GetCharacter()
                            if Character then
                                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                                    if HRP then
                                        HRP.CFrame = ItemData.CFrame
                                    end
                            end
                        end
                    };
                    [2] = {
                        Text = "Collect";
                        Callback = function()
                            self:Collect(Item)  
                        end
                    };
            })
        end

        if IdentifiedItem == "Lucky Arrow" then
            local NewSound = Instance.new("Sound")
            NewSound.Parent = self:GetService("ReplicatedStorage")
            NewSound.SoundId = "rbxassetid://6753175234"
            NewSound.Volume = 10
            NewSound:Play()
            NewSound.Ended:Wait()
            NewSound:Destroy()
        end

        task.spawn(function()
            while task.wait(0.1) do
                    if Item.Parent == workspace.Item_Spawns.Items and Item.PrimaryPart then
                        if table.find(self:GetTable("Items"), IdentifiedItem) and self:GetState("Item ESP") == true then
                            Billboard.Enabled = true
                            ESPLabel.Text = IdentifiedItem .. " (" .. self:GetDistance(Item.PrimaryPart) .. "m)"
                        else
                            Billboard.Enabled = false
                        end
                    else
                        ESPPart:Destroy()
                        break
                    end
            end
            return
        end)
        self:ChangeTable("Queue", Item:FindFirstChild("ProximityPrompt"), ItemData)
    end
end

function Xenon.Utils:Click(Button, Manual)
    for i, v in pairs(getconnections(Button.MouseButton1Click)) do
        if Manual then
            v.Function()
        else
            v:Fire()
        end
    end
end

function Xenon.Utils:LearnSkills(Skills)
    if workspace.Living:FindFirstChild(self:GetPlayer().Name) and workspace.Living:FindFirstChild(self:GetPlayer().Name):FindFirstChild("RemoteFunction") then
        for i,v in pairs(Skills) do
            local Arguments = {	
                    [1] = "LearnSkill",
                    [2] = {
                        ["Skill"] = v,
                        ["SkillTreeType"] = "Character",
                    }
            }

            workspace.Living:WaitForChild(self:GetPlayer().Name, 15).RemoteFunction:InvokeServer(unpack(Arguments))
        end
    end
end

function Xenon.Utils:UseRoka()
    local AmountOfRoka = self:CountItem("Rokakaka")
    if not self:GetPlayer().Backpack:FindFirstChild("Rokakaka") then
        return
    end
    
    if self:GetPlayer().PlayerStats.Stand.Value == "None" then
        return
    end

    if not self:GetCharacter() then
        return 
    end

    if not self:GetPlayer().Character:FindFirstChild("Rokakaka") then
        self:GetHumanoid():EquipTool(self:GetPlayer().Backpack:FindFirstChild("Rokakaka"))
    end
    
    repeat
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
        task.wait(0.05)
    until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui")
    
    if self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui") then
        repeat
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
            task.wait(0.05)
        until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
        
        local Eat = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
        repeat task.wait() until Eat.Visible
            
        local Dial = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame
            
        self:Click(Eat.TextButton, true)
            
        repeat task.wait() until not Dial.Parent
    end	
    Library:Notification("Roka Count", "Rokas left: "..AmountOfRoka-1, 3)
    self:GetPlayer().CharacterAdded:Wait()
end

function Xenon.Utils:UseArrow()
    local AmountOfArrow = self:CountItem("Mysterious Arrow")
    if not self:GetPlayer().Backpack:FindFirstChild("Mysterious Arrow") then
        return
    end
    
    if self:GetPlayer().PlayerStats.Stand.Value ~= "None" then
        return
    end

    if not self:GetCharacter() then
        return 
    end

    if not self:GetPlayer().Character:FindFirstChild("Mysterious Arrow") then
        self:GetHumanoid():EquipTool(self:GetPlayer().Backpack:FindFirstChild("Mysterious Arrow"))
    end

    repeat
        game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
        task.wait(0.05)
    until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui")

    if self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui") then
        repeat
            game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
            task.wait(0.05)
        until self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")

        local Eat = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
        repeat task.wait() until Eat.Visible
            
        local Dial = self:GetPlayer().PlayerGui:FindFirstChild("DialogueGui").Frame
            
        self:Click(Eat.TextButton, true)
            
        repeat task.wait() until not Dial.Parent
    end
    self:GetPity()
    Library:Notification("Arrow Count", "Arrows left: "..AmountOfArrow-1, 3)
end

function Xenon.Utils:GetPity()
    local Pity = (self:GetPlayer().PlayerStats.PityCount.Value .. " (" .. (self:GetPlayer().PlayerStats.PityCount.Value*0.04) + 1 .. "%)")
    self:SetString("Pity", Pity)
    return Pity
end

function Xenon.Utils:UseRib()
    local AmountOfRib = self:CountItem("Rib Cage of The Saint's Corpse")
    local Arguments = {
        [1] = "EndDialogue",
        [2] = {
            ["NPC"] = "Rib Cage of The Saint's Corpse",
            ["Option"] = "Option1",
            ["Dialogue"] = "Dialogue2"
        }
    }
    
    self:GetCharacter().RemoteEvent:FireServer(unpack(Arguments))
    Library:Notification("Rib Count", "Ribs left: "..AmountOfRib-1, 3)
end

function Xenon.Utils:Stats()
    repeat task.wait() until self:GetCharacter()
    repeat task.wait() until self:GetCharacter():FindFirstChild("RemoteEvent")
    local Skills = {
        "Agility I",
        "Agility II",
        "Agility III",
        "Worthiness I"
    }

    if self:GetState("Rib Farm") == true or self:GetState("Rib Shiny Farm") == true then
        table.insert(Skills, #Skills+1, "Worthiness II")
        table.insert(Skills, #Skills+1, "Worthiness III")
        table.insert(Skills, #Skills+1, "Worthiness IV")
        table.insert(Skills, #Skills+1, "Worthiness V")
    end

    self:LearnSkills(Skills)
end 

function Xenon.Utils:HasStand()
    if self:GetPlayer().PlayerStats.Stand.Value == "None" then
        return false
    else
        return true
    end
end

function Xenon.Utils:HasShiny()
    local Character = self:GetCharacter()
    local ShinyThing;

    if Character and Character:FindFirstChild("RemoteFunction") then
        ShinyThing = Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand")
    end
    if ShinyThing == "None" or ShinyThing == nil then
        return false
    else
        return true
    end
end

function Xenon.Utils:CheckShiny()
    local Character = self:GetCharacter()
    if not Character:FindFirstChild("RemoteFunction") then Character:WaitForChild("RemoteFunction") end
    if Character and Character:FindFirstChild("RemoteFunction") then
	--print(Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand"))
        return Character.RemoteFunction:InvokeServer("ReturnStandSkin", "Stand")
    else 
        return
    end
end

function Xenon.Utils:CheckStand()
    return self:GetPlayer().PlayerStats.Stand.Value
end

function Xenon.Utils:Collect(Item)
    local Character = self:GetCharacter()
    local OldCF = cf(v3(0, 0, 0))
    local Start = tick()

    self:AddTask("C_Clip", self:GetService("RunService").Stepped:Connect(function()
        local Char = self:GetCharacter()
        if Char then
            for _, v in pairs(Char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = false
                end
            end
        end
    end))
    self:Log("Xenon:C_Clip: Added task.")

    if Character then
        local HRP = Character:FindFirstChild("HumanoidRootPart")
        if HRP and Item and Item.PrimaryPart and Item.PrimaryPart.CFrame then
            OldCF = HRP.CFrame
            HRP.CFrame = Item.PrimaryPart.CFrame - v3(0, 10, 0)
            task.wait(0.3)
            repeat 
                    fireproximityprompt(Item:FindFirstChild("ProximityPrompt"))
                    if Item and Item.Parent == workspace.Item_Spawns.Items and Character and HRP then
                        HRP.CFrame = Item.PrimaryPart.CFrame - v3(0, 10, 0)
                    end
                    task.wait()
            until Item.Parent ~= workspace.Item_Spawns.Items or tick()-Start >= 3.5
            task.wait(0.6)
            HRP.CFrame = OldCF
        end
    end
    self:DisconnectTask("C_Clip")
    self:Log("Xenon:C_Clip: Removed Task.")
end

function Xenon.Utils:FarmItems(List)
    for Prompt, Item in pairs(self:GetTable("Queue")) do
        local ItemName = Item.ItemName
        if table.find(List, ItemName) and not self:IsMax(ItemName) then
            xpcall(function()
                    self:Collect(Item.ItemModel)
            end, function(err)
                    warn("[Xenon Error : Collect]:", err)
                    warn("[Xenon Traceback]:", debug.traceback())
                    self:DisconnectTask("C_Clip")
            end)
        end
    end
end

function Xenon.Utils:AddTask(TaskName, Task)
    if not self.Tasks[TaskName] then
        self.Tasks[TaskName] = Task
    end
    return Task
end

function Xenon.Utils:IsTaskRunning(TaskName)
    if self.Tasks[TaskName] then
        return self.Tasks[TaskName].Connected
    else
        warn("[Xenon Warning]: Task does not exist!")
        return
    end
end

function Xenon.Utils:DisconnectTask(TaskName)
    if self:IsTaskRunning(TaskName) then
        self.Tasks[TaskName]:Disconnect()
        self.Tasks[TaskName] = nil
    end
end

function Xenon.Utils:IsSBR()
    if game.PlaceId == 4643697430 then
        return true
    else
        return false
    end
end

function Xenon.Utils:SearchPlayer(Name)
    local ClosestMatch = nil
    local ClosestLetters = 0
    for i,v in pairs(workspace.Living:GetChildren()) do
        local matched_letters = 0
        for i = 1, #Name do
            if string.sub(Name:lower(), 1, i) == string.sub(v.Name:lower(), 1, i) then
                    matched_letters = i
            end
        end
        if matched_letters > ClosestLetters then
            ClosestLetters = matched_letters
            ClosestMatch = v
        end
    end
    return ClosestMatch
end

function Xenon.Utils:SendWebhook(webhook, msg, title)
    local webhookcheck = (identifyexecutor and identifyexecutor() or "Unsupported exploit")

    local url = webhook

    local data;
    data = {
        ["embeds"] = {
            {
                    ["title"] = title,
                    ["description"] = msg,
                    ["type"] = "rich",
                    ["color"] = tonumber(0x7269ff),
            }
        }
    }

    repeat task.wait() until data
    local newdata = game:GetService("HttpService"):JSONEncode(data)


    local headers = {
        ["Content-Type"] = "application/json"
    }
    local request = http_request or request or HttpPost or syn.request or http.request
    local abcdef = {Url = url, Body = newdata, Method = "POST", Headers = headers}
    request(abcdef)
end

function Xenon.Utils:Censor(string)
    local Censored = (string.sub(string, 1, 2))

    for i = 1, #string-2 do
        Censored = Censored.."*"
    end

    return Censored
end

function Xenon.Utils:GetQuest(NPC)
    local DialogueName = NPC:FindFirstChild("Dialogue")
    local Character = self:GetCharacter()
    if DialogueName and Character and Character:FindFirstChild("RemoteEvent") then
        DialogueName = DialogueName.Value
        local Event = Character:FindFirstChild("RemoteEvent")

        for i = 1, 10 do
            Event:FireServer("EndDialogue", {
                    ["NPC"] = DialogueName;
                    ["Option"] = "Option1";
                    ["Dialogue"] = "Dialogue" .. i
            })
            Event:FireServer("EndDialogue", {
                    ["NPC"] = DialogueName;
                    ["Dialogue"] = "Dialogue" .. i
            })
        end --// No clue what is what
        self:SetState("CompletedQuest", false)
    end
end

function Xenon.Utils:EquipStand()
    local Character = self:GetCharacter()

    if Character and Character:FindFirstChild("RemoteFunction") and not Character:FindFirstChild("SummonedStand").Value then
        local RemoteFunc = Character:FindFirstChild("RemoteFunction")
        RemoteFunc:InvokeServer("ToggleStand", "Toggle")
    end
end

function Xenon.Utils:UseMove(Move)
    Move = Move
    if Move == string.lower("m1") or Move == string.lower("m2") then
        local Char = self:GetCharacter()
        if Char and Char:FindFirstChild("RemoteFunction") then
            Char:FindFirstChild("RemoteFunction"):InvokeServer("Attack", Move)
        end
    end
    if typeof(Move) == "Enum" then
        local Char = self:GetCharacter()
        if Char and Char:FindFirstChild("RemoteEvent") then
            Char:FindFirstChild("RemoteEvent"):FireServer("InputBegan", {
                    ["Input"] = Move
            })
        end
    end
end

function Xenon.Utils:Kill(Enemy)
    getgenv().FocusCam = nil
    local OldPos = self:GetHRP().CFrame
    local EnemyHRP = Enemy:FindFirstChild("HumanoidRootPart")
    local EnemyHumanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
    local EnemyHealth = Enemy:FindFirstChild("Health")

    if Enemy and EnemyHRP and EnemyHumanoid and EnemyHealth and EnemyHealth.Value > 0 then
        while (Enemy and EnemyHealth and EnemyHealth.Value > 0 and EnemyHRP and EnemyHumanoid) do
            if (self:GetState("Quest Farm") == false and self:GetState("NPC Farm") == false) then 
                    break
            end
            if self:GetState("CompletedQuest") == true and self:GetState("Quest Farm") == true then
                    break
            end

            EnemyHRP = Enemy:FindFirstChild("HumanoidRootPart")
            EnemyHumanoid = Enemy:FindFirstChildWhichIsA("Humanoid")
            EnemyHealth = Enemy:FindFirstChild("Health") --// Testing reassignment
            if not Enemy or not EnemyHRP or not EnemyHumanoid or not EnemyHealth or EnemyHealth.Value <= 0 then
                    task.wait(0.21532133425432)
                    break
            end

            local Character = self:GetCharacter();
            if Character and Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChildWhichIsA("Humanoid").Health > 0 then
                    if self:CheckStand() ~= "None" then
                        self:EquipStand();
                    end

                    if Character:FindFirstChild("FocusCam") == nil then
                        FocusCam = Instance.new("ObjectValue", Character)
                        FocusCam.Name = "FocusCam"
                        FocusCam.Value = EnemyHRP
                    else
                        local FocusCam = Character:FindFirstChild("FocusCam")
                        FocusCam.Value = EnemyHRP
                    end

                    if self:CheckStand() ~= "None" then
                        Character.StandMorph.PrimaryPart.CFrame = EnemyHRP.CFrame - EnemyHRP.CFrame.LookVector * 1.1 -- stand behind npc
                        Character.PrimaryPart.CFrame = Character.StandMorph.PrimaryPart.CFrame + Character.StandMorph.PrimaryPart.CFrame.LookVector * math.random(-3,-2) + Vector3.new(0,-35,0) 
                    else
                        Character.PrimaryPart.CFrame = EnemyHRP.CFrame - EnemyHRP.CFrame.LookVector * 2.3
                    end
                    
                    if EnemyHumanoid.Sit == true then
                        local Prediction = EnemyChar.PrimaryPart.Velocity * Util:GetInt("Prediction Strength") 
                        Stand.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame + Prediction
                    end
                    task.spawn(function()
                            self:UseMove("m1")
                        --self:UseMove(Enum.KeyCode.E)
                        --for i = 1, 3 do
                            --  self:UseMove("m1")
                        --end
                        --self:UseMove(Enum.KeyCode.R)
                    end)
            elseif Character and Character:FindFirstChildWhichIsA("Humanoid") and Character:FindFirstChildWhichIsA("Humanoid").Health <= 0 then
                    self:GetPlayer().CharacterAdded:Wait()
            end
            task.wait()
        end
        task.wait(2)
        local Char = self:GetCharacter()
        if Char and Char:FindFirstChild("HumanoidRootPart") then
            Char:FindFirstChild("HumanoidRootPart").CFrame = OldPos
        end
        pcall(function()
            FocusCam:Destroy()
        end)
    else
        task.wait(0.1)
    end
end

function Xenon.Utils:GetStroke()
    StrokeDir = 180
    local Anim = "6926086304"
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A)) then
        StrokeDir = 90
        Anim = "6926086567"
    end
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D)) and StrokeDir == 180 then
        StrokeDir = -90
        Anim = "6926086883"
    end
        
    if (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W)) and StrokeDir == 180 then
        StrokeDir = 0
        Anim = "6926086032"
    end
        
    return StrokeDir, Anim
end

function Xenon.Utils:ReplaceReset()
    local NewEvent = Instance.new("BindableEvent")
    NewEvent.Event:Connect(function()
        local Char = self:GetCharacter()

        if Char and Char:FindFirstChild("RemoteEvent") then
            Char.RemoteEvent:FireServer("Reset", {Anchored = false}, "XENON_ON_TOP");
        end
    end)
    self:GetService("StarterGui"):SetCore("ResetButtonCallback", NewEvent)
end

function Xenon.Utils:Outline(Chars)
    local Highlight = Instance.new("Highlight", self:GetService("CoreGui").GayESP)
    
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.Adornee = Chars
    Highlight.FillColor = Color3.fromRGB(255, 255, 255)
    Highlight.FillTransparency = 1
    Highlight.FillTransparency = 1
end

function Xenon.Utils:LabelChar(Chars)
    local BGui = Instance.new("BillboardGui", self:GetService("CoreGui").GayESP)
    local Frame = Instance.new("Frame", BGui)
    local TextLabel = Instance.new("TextLabel", Frame)
    
    BGui.Adornee = Chars:WaitForChild("Head")
    BGui.StudsOffset = Vector3.new(0, 3, 0)
    BGui.AlwaysOnTop = true
    
    BGui.Size = UDim2.new(4, 0, 0.5, 0)
    Frame.Size = UDim2.new(1, 0, 1, 0)
    TextLabel.Size = UDim2.new(1, 0, 1, 0)
    
    Frame.BackgroundTransparency = 1
    TextLabel.BackgroundTransparency = 1
    
    TextLabel.Text = Chars.Name
    TextLabel.Font = Enum.Font.Ubuntu
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextScaled = false
end

local Util = Xenon.Utils.MakeUtilController()
local XenonConfig = Util:ReadData():LoadData()

Util:Log("Xenon Debug - Passed Functions")
--// Preload Api ----
getgenv().XenApi = Util
Util:Log("Xenon Debug - Preloaded API")
--[[ Load Captcha Bypass
Util:GetPlayer().PlayerGui.ChildAdded:Connect(function(Child)
    local Start = tick()
    if Child.Name == "ScreenGui" then
        repeat task.wait() until (Child:FindFirstChild("Part") and Child:FindFirstChild("Part"):FindFirstChildWhichIsA("Frame").Visible == true) or (tick()-Start > 5)
        for i,v in pairs(Child:GetDescendants()) do
            if v.Parent:IsA("ImageButton") and v:IsA("TextLabel") and v.TextColor3 == Color3.fromRGB(0, 255, 0) then 
                    firesignal(v.Parent.MouseEnter)
                    for i,v in pairs(getconnections(v.Parent.MouseButton1Click)) do
                        v.Function()
                    end
            end
        end
    end
end)--]]

--Util:Log("Xenon Debug - Item Captcha Bypassed")

game.Lighting.ChildAdded:Connect(function(Child)
    if Child:IsA("Blur") then
        Child:Destroy()
    end
end)

Util:Log("Xenon Debug - Screen Fix")

--// Preload Hooks ------------------------------------------------------------------------------------------------------------------------------------
local HookStart = tick()

local OldNewIndex;
OldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, Key, Value, ...)
    if Key == "WalkSpeed" then
        Util:ChangeTable("Cache", "Speed", Value)

        if Util:GetState("Speed") == true then
            return OldNewIndex(self, Key, Util:GetInt("Speed"), ...)
        end
    end

    if Key == "JumpPower" then
        Util:ChangeTable("Cache", "Jump", Value)

        if Util:GetState("Jump") == true then
            return OldNewIndex(self, Key, Util:GetInt("Jump"), ...)
        end
    end

    --[[if Key == "MoveDirection" then
        Util:ChangeTable("Cache", "MoveDirection", Value)
    end]]

    return OldNewIndex(self, Key, Value, ...)
end))

local OldIndex;
OldIndex = hookmetamethod(game, "__index", newcclosure(function(self, Key, ...)
    if Key == "WalkSpeed" then
        return Util:GetTable("Cache").Speed
    end
    if Key == "JumpPower" then
        return Util:GetTable("Cache").Jump
    end
    --[[if Key == "MoveDirection" then
        return Vector3.new(0,0,0)
    end]]
    if Util:GetState("Anti Vamp Burn") == true and Key == "ClockTime" then
        return 0
    end
    return OldIndex(self, Key, ...)
end))

Util:Log("Xenon Debug - Passed WS/Jump Hook")

local OldNamecallTP;
OldNamecallTP = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
    local Arguments = {...}
    local Method =  getnamecallmethod()
        
    if Method == "InvokeServer" and Arguments[1] == "idklolbrah2de" then
        return "  ___XP DE KEY"
    end

    if (Method == "FireServer" or Method == "InvokeServer" or Method == "InvokeClient") and Arguments[1] == "Reset" and Arguments[3] ~= "XENON_ON_TOP" then
        return wait(9e9) 
    end
        
    return OldNamecallTP(self, ...)
end))

Util:Log("Xenon Debug - Passed TP Hook")


--[[hookfunction(workspace.Raycast, function() -- noclip bypass
    return
end)]]

local functionLibrary = require(game.ReplicatedStorage:WaitForChild('Modules').FunctionLibrary)
local old = functionLibrary.pcall

functionLibrary.pcall = function(...)
    local f = ...

    if type(f) == 'function' and #getupvalues(f) == 11 then 
        return
    end
    
    return old(...)
end

--// Anti AFK

pcall(function()
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end)
end)

Util:Log("Xenon Debug - Enabled Anti AFK")

--// Rejoin on kick

local Prompt = game:GetService("CoreGui"):FindFirstChild("promptOverlay", true)
Prompt.ChildAdded:Connect(function(Child)
    if typeof(Child) == "Instance" and Child.Name == "ErrorPrompt" and Child.ClassName == "Frame" then
        local Error = Child:FindFirstChild("ErrorMessage", true)
        repeat task.wait() until Error.Text ~= "Label"
        if Error.Text:find("kick") or Error.Text:find("conn") or Error.Text:find("rejoin") then
            task.wait(1)
            game:GetService("TeleportService"):Teleport(2809202155, Util:GetPlayer())
        end
    end
end)

Util:Log("Xenon Debug - Enabled Auto-Rejoin on Kick")
--// Reset fix

Util:ReplaceReset(); --// Incase it doesn't detect characteradded on join
Util:GetPlayer().CharacterAdded:Connect(function()
    Util:ReplaceReset();
end)

Util:Log("Xenon Debug - Replaced Reset")

--// Logs
Util:Log(("-"):rep(150) .. "\nDo not send this log file to anyone apart from Xenon owners or developers in case of an error/bug in order to keep your account safe!\n[Xenon Log]: Loaded Hooks/Misc functions in: " .. tick()-HookStart .. "s")
Util:Log("[Xenon Log]: Username: " .. Util:GetPlayer().Name .. " - UserId: " .. Util:GetPlayer().UserId .. " - Log Path: " .. Util:GetLogPath())
Util:Log("[Xenon Log]: User Config: " .. Util:GetService("HttpService"):JSONEncode(Util:ReadData().Data))

Util:Log("Xenon Debug - Ran Execution Logfile")
--// Skip Loading Screen

if not Util:IsSBR() then
    Util:Log("Xenon Debug - Loading HUD")

    if not Util:GetPlayer().PlayerGui:FindFirstChild("HUD") then
        local HUD = game:GetService("ReplicatedStorage").Objects.HUD:Clone()
        HUD.Parent = Util:GetPlayer().PlayerGui
    end

    Util:GetCharacter():WaitForChild("RemoteEvent"):FireServer("PressedPlay")

    pcall(function()
        Util:GetPlayer().PlayerGui:FindFirstChild("LoadingScreen1"):Destroy()
    end)   

    task.wait(.5)

    pcall(function()
        Util:GetPlayer().PlayerGui:FindFirstChild("LoadingScreen"):Destroy()
    end)

    Util:Log("Xenon Debug - Skipped Loading Screen")
    Util:Log("[Xenon Log]: Skipped Loading Screen")

    pcall(function()
        workspace.LoadingScreen.Song.Playing = false
    end)

    pcall(function()
        for i,v in pairs(game.Lighting:GetChildren()) do
            if v.Name == "DepthOfField" then
                v.Enabled = false
            end
        end
    end)

    Util:Log("Xenon Debug - Passed Loading Screen Checks")
elseif Util:IsSBR() then
    Util:GetPlayer().PlayerGui.Chat.Frame.ChatChannelParentFrame.Visible = true
    Util:GetPlayer().PlayerGui.Chat.Frame.ChatChannelParentFrame.Position = UDim2.new(0,0,0,-156)
    Util:GetPlayer().PlayerGui.Chat.Frame.Position = UDim2.new(0,0,1,95)
end

Util:Log("Xenon Debug - Passed SBR Check")

--// Load item magnitude hook

local Char = Util:GetCharacter()

if Char and Char.PrimaryPart and Util:IsSBR() == false then
    local OldIndexItem;
    OldIndexItem = hookfunction(getrawmetatable(Util:GetHRP().Position).__index, function(self, key)
        if getcallingscript().Name == "ItemSpawn" and key:lower() == "magnitude" then
            return 0
        end

        return OldIndexItem(self, key)
    end)
end

Util:Log("Xenon Debug - Passed Item Hook")

--// Queue
if not Util:IsSBR() and game.PlaceId ~= 5290908008 then
    Util:Log(("-"):rep(35) .. "ITEM QUEUE" .. ("-"):rep(105))
    for i,v in pairs(workspace.Item_Spawns.Items:GetChildren()) do
        Util:AddToQueue(v)
        Util:Log("[Xenon Queue]: Added " .. v.Name .. " to the item queue")
    end
    
    workspace.Item_Spawns.Items.ChildAdded:Connect(function(Child)
        Util:AddToQueue(Child)
    end)
    
    Util:Log(("-"):rep(150))
end

Util:Log("Xenon Debug - Added Items to Queue")
-------------------------------------------------------------------------------------------------------------------------------------------------------

Util:AddValues{
    ["Int"] = {
        ["Speed"] = 16;
        ["Jump"] = 50;
        ["FlySpeed"] = 0.5;
        ["TSDelay"] = 0.8;

        ["Item Collection Delay"] = 0.6;

        ["Pity Amount"] = 20;

        ["Prediction Strength"] = 0.5;
        ["Stand Attach Distance"] = 2.5;
        
        ["SBR_Delay_1"] = 5;
        ["SBR_Delay_2"] = 5;
        ["SBR_Delay_3"] = 5;
        ["SBR_Delay_4"] = 5;
        ["SBR_Delay_5"] = 5;
        ["SBR_Delay_Hide"] = 5;

        ["InfTick"] = tick();
        ["InfDelay"] = 1;
        ["DashPower"] = 50;
    };
    ["State"] = {
        ["Speed"] = false;
        ["Jump"] = false;
        ["God Mode"] = false;
        
        ["Anti Vamp Burn"] = false;

        ["Item ESP"] = false;
        ["Item Notify"] = false;
        
        ["Stand Farm"] = false;
        ["Rib Farm"] = false;
        ["Shiny Farm"] = false;
        ["Rib Shiny Farm"] = false;
        ["Safe Farm"] = false;
        ["Use Redeemed"] = false;
        ["Keep any shiny"] = false;
        ["Arrow Pity Farm"] = false;
        ["Rib Pity Farm"] = false;

        ["Auto Choose Quest"] = false;
        ["Quest Farm"] = false;

        ["NPC Farm"] = false;

        ["HidePlayerList"] = false;

        ["Waiting"] = false;
        ["CompletedQuest"] = true;

        ["Auto Sprinting"] = false;

        ["View Stand"] = false;
        ["Follow Stand"] = false;

        ["Auto Sell"] = false;

        ["Use_Horse_ASBR"] = false;

        ["Infinite Dash"] = false;
    };
    ["String"] = {
        ["Stand"] = "";
        ["Shiny"] = "";
        ["Chosen Player"] = "";
        ["Chosen NPC"] = "";
        ["Target NPC"] = "";
        ["Pity"] = "";
        ["Quest"] = "";
        ["TrollingPlayer"] = "";
    };
    ["Table"] = {
        AnimsList = {};
        Poses = {};
        AnimsBlacklist = {"Ice Skating", "Stunned", "StandAppear", "StandDisappear"};
        Queue = {};
        AllPlayers = {};
        AllNPCs = {};
        ShinyToggles = {};
        ItemSellToggles = {};
        ChosenItemsToSell = {};
        ParsedQuests = {};
        AllMods = {"UzuKee", "BLOODTARO", "Dxscape", "Myst_Ari", "eurycIea", "v_cks", "ezguap", "Tsuzutou", "ReferToWithered", "Illus0", "Pyreiz", "VoidedFlame", "ROUXABOUT", "mixeriiiiiing", "MichDrajo", "hayst4", "ElmoNYC", "Core_CorruptionF", "Brillcake", "AxionTheRevenant", "sammyj0n", "ViveLesPatat", "Zimvasion", "vertiify", "redfoxP", "cakesucker05", "00kamiMio", "itscanii", "SirDeviloper", "0nkka", "Ramdharam", "Olliebutheskenny", "cswag_code", "TwoGio", "KoleRTX2", "Wilpuri", "remendyy", "SpaceNuggies", "CrimsonBeheIit", "warycoolio"};
        AllItems = {"Christmas Present", "Mysterious Arrow", "Pure Rokakaka", "Rokakaka", "Diamond", "Lucky Arrow", "Lucky Stone Mask", "Dio's Diary", "Steel Ball", "Rib Cage of The Saint's Corpse", "Stone Mask", "Gold Coin", "Quinton's Glove", "Ancient Scroll"};
        AllStands = {"Whitesnake", "Stone Free", "Star Platinum", "The World", "Crazy Diamond", "Killer Queen", "Gold Experience", "King Crimson", "Silver Chariot", "Hermit Purple", "The Hand", "Purple Haze", "Cream", "Hierophant Green", "Magician's Red", "White Album", "Aerosmith", "Six Pistols", "Beach Boy", "Mr. President", "Sticky Fingers", "Anubis", "Red Hot Chili Pepper", "Scary Monsters", "The World Alternate Universe", "D4C", "Tusk ACT 1", "Soft & Wet"};
        AllShinys = {
            "Action-Figure Platinum",
            "Actually Red Hot Chili Pepper",
            "Aerosmith Over Heaven",
            "All-Starsnake",
            "Anti-Umbral",
            "Asuna",
            "Biblically Accurate Experience",
            "Blade Of The Exile",
            "Casull",
            "Charmy Green",
            "Chromo",
            "Comic Venom",
            "Cracked World",
            "Crazy Ruby",
            "Crazy Idol",
            "Creeper Queen",
            "D4She",
            "Devil4c",
            "Deimos Queen",
            "Deimos Snake",
            "Eldritch Hierophant",
            "Elizabeth Liones",
            "Elucidator & Dark Repulser",
            "Emperor",
            "Emperor OVA",
            "Female The Hand",
            "Frozone",
            "Glock-18",
            "Glock-18 Fade",
            "Gold Platinum",
            "Golden Frieza",
            "Gold & Wet",
            "Headhunter",
            "Heaven Spirit",
            "Tentacle Black",
            "Tentacle Purple",
            "Tentacle Yellow",
            "Holly's Sickness",
            "Jade Peace",
            "Jaguar Platinum",
            "Kanshou & Bakuya",
            "Kikoku",
            "Killer Reveal",
            "King of The End",
            "Linked Sword",
            "Luffy Gear 4",
            "Magellan",
            "Magician's Red: Over Heaven",
            "Manga Crimson",
            "Megumin",
            "Mintsnake",
            "Misaka Mikoto",
            "Mr. Joestar",
            "Ms. Aerosmith",
            "Neon Ascension",
            "Neo World",
            "Nerf Jolt",
            "Nocturne",
            "Nonosama Bo",
            "ODM Gear",
            "OVA Silver Chariot",
            "Old President",
            "Pinky Fingers",
            "Queen Crimson",
            "Rock Unleashed",
            "Sakura",
            "Shadow Killer Queen",
            "Shadow The World",
            "Sorcerer's Ember",
            "Spider-Man",
            "Sasageyo",
            "Star Platinum OVA",
            "Star Striped Eagle",
            "Star Waifu",
            "Stone Platinum",
            "The Other Hand",
            "The Waifu v2",
            "The Waifu: Alternate Universe",
            "The World: Greatest High",
            "The World 2",
            "The World OVA",
            "The World Ultimate",
            "Toy Sticky Fingers",
            "Tsunade",
            "Uber Spy",
            "Whisper",
            "Vanilla Ice Cream",
            "Venom",
            "Vinegar Crimson",
            "Virus Vessel",
            "Jack-O-Platinum",
            "Ghost World",
            "Crazy Overseer",
            "Tyrant Crimson",
            "Jester Crimson",
            "Vexus Crimson",
            "Pumpkin Patch",
            "Cornsnake",
            "Crimson Mist",
            "Dead Experience",
            "Undead Hand",
            "Undead Flare",
            "Bloodthirster"
        };
        AllTeleports = {
            ["Newbie Giorno"] = CFrame.new(1, 0, -697);
            ["Train Station Side 1"] = CFrame.new(-214, 0, 18);
            ["Train Station Side 2"] = CFrame.new(-265, -30, -447);
            ["Pizza Place"] = CFrame.new(113, 6, 71);
            ["The Arcade"] = CFrame.new(255, 5, -239);
            ["The Cafe"] = CFrame.new(-544, -25, -174);
            ["Diavolo"] = CFrame.new(1126, 116, -129);
            ["Dio P3"] = CFrame.new(-44, 0, -973);
            ["Jotaro P3"] = CFrame.new(182, -25, 578);
            ["Jotaro P6"] = CFrame.new(784, -42, 144);
            ["Tallest Peak"] = CFrame.new(-237, 284, 305);
            ["Hamon Merchant"] = CFrame.new(421, 8, -287);
            ["Boxing Merchant"] = CFrame.new(281, 0, 101);
            ["Pluck Merchant"] = CFrame.new(125, -27, 438);
            ["Heaven Dimension"] = CFrame.new(8553, -479, 8154);
            ["Arrowsmith"] = CFrame.new(-667, 16, -299);
            ["Cosmetics Merchants"] = CFrame.new(512, 2, 22);
            ["Leaky Eye Luca"] = CFrame.new(-382, 0, -711);
            ["Chad"] = CFrame.new(-121, -24, 524);
            ["Brad the Bat Merchant"] = CFrame.new(-14, -0, -286);
            ["Dracula"] = CFrame.new(-420, -34, -75);
            ["Kars"] = CFrame.new(264, -33, 112);
            ["Homeless Man Jill"] = CFrame.new(-142, -31, -577);
            ["Vampire Room"] = CFrame.new(391, -31, -166);
            ["Enrico Pucci"] = CFrame.new(917, 34, -17);
            ["Safe Spot"] = CFrame.new(-452, -20, 206);
        };
        QuestInfo = {
            ["Officer Sam [Lvl. 1+]"] = {
                    Enemy = "Thug";
            };
            ["Deputy Bertrude [Lvl. 10+]"] = {
                    Enemy = "Corrupt Police";
            };
            ["Homeless Man Jill [Lvl. 15+]"] = {
                    Item = "Gold Coin";
                    Amount = 10;
            };
            ["Dracula [Lvl. 20+]"] = {
                    Enemy = "Zombie Henchman";
            };
            ["William Zeppeli [Lvl. 25+]"] = {
                    Enemy = "Vampire";
            };
            ["Doppio [Lvl. 30+]"] = {
                    Enemy = "Dio";
            };
            ["Dio [Lvl. 35+]"] = {
                    Enemy = "Jotaro";
            };
        };
        Cache = {
            ["Speed"] = 16;
            ["Jump"] = 50;
            --["MoveDirection"] = Vector3.new(0,0,0)
            ["Waypoint"] = nil;
            ["Spawnpoint"] = nil;
        };
        CachedAssets = {};
        Keybinds = {
            ["Fly"] = {
                ["Keybind"] = Enum.KeyCode.RightShift;
                ["Function"] = function(Fired)
                    if Util:IsTaskRunning("FlyLoop") == nil then
                        Util:GetTable("CachedAssets")["FlyToggle"]:UpdateAsset(true)
                    else
                        Util:GetTable("CachedAssets")["FlyToggle"]:UpdateAsset(false)
                    end
                end
            }
        }
    };
}

local AutoSprintToggle;
local SBRTeleports;
pcall(function()
    SBRTeleports = {
        ["Stage 1 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("1").CFrame,
        ["Stage 2 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("2").CFrame,
        ["Stage 3 Barrier"] = workspace:FindFirstChild("Barriers"):FindFirstChild("3").CFrame,
        ["Stage 4 Barrier"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("Start").CFrame,
        ["Normal Hide"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("NYCBridge"):FindFirstChild("Bridge"):FindFirstChild("Bridge"):FindFirstChild("MeshPart").CFrame,
        ["Finish Hide"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("Start").CFrame - Vector3.new(0,30,0),
        ["Finish Line Barrier"] = workspace:FindFirstChild("Map"):FindFirstChild("NYC Bridge"):FindFirstChild("End_Line").CFrame + Vector3.new(0,100,0)
    };
end)

Util:Log("Xenon Debug - Passed Values")
--// Mod Check (998)

game.Players.PlayerAdded:Connect(function(plr)
    if Util:FindTable("AllMods", plr.Name) then
        Util:GetPlayer():Kick("Spotted a mod, rejoining..")
    end
end)

task.spawn(function()
    for _, plr in pairs(game.Players:GetPlayers()) do
        if Util:FindTable("AllMods", plr.Name) then
            Util:GetPlayer():Kick("Spotted a mod, rejoining..")
        end
    end
end)

Util:Log("Xenon Debug - Added Mod-Check")

if (Util:GetPlayer().PlayerGui:FindFirstChild("LoadingScreen") == nil) and not Util:GetService("CollectionService"):HasTag(Util:GetPlayer(), "PressedPlay") then
    Util:GetCharacter().RemoteEvent:FireServer("PressedPlay")
end

Util:Log("Xenon Debug - Bypassed Game Mechs")

--// Lib (999)
local Lib = Library.CreateLib()

--// Tabs (1000 for ctrl + f)
local Credits = Lib:Tab("Credits", 6026568227)
local Player = Lib:Tab("Player", 6023426915)
local Autofarms;
if not Util:IsSBR() then
    Autofarms = Lib:Tab("Autofarms", 6031360365)
end
local Teleports = Lib:Tab("Teleports", 6035190846)
local Misc = Lib:Tab("Misc", 6022668951)

Util:Log("Xenon Debug - Created all Tabs")

--// Credits (1001 for ctrl + f)
local Credits_Developers = Credits:Section("Developers")
local Credits_Info = Credits:Section("Info")

Credits_Developers:Label("Main Developer: enxquity")
Credits_Developers:Label("Co-Developer: _vez0")
Credits_Developers:Label("UI Designer: enxquity")
Credits_Developers:Label("Extra Features: _scep. & crtrz")

Credits_Info:Label("Version: v3.2.6a")
Credits_Info:Label("Exploit: " .. (identifyexecutor and identifyexecutor() or "Unsupported exploit"))
Credits_Info:Button("Copy Discord", function()
    Library:Notification("Copied", "The discord link was set to your clipboard. Paste it in your browser, discord joins, or any message to be able to join.", 3)
end, "Copies discord to your clipboard, use CTRL + V in join servers.")
    
Util:Log("[Xenon Task]: Loaded Credits Tab")

Util:Log("Xenon Debug - Finished Credits Tab")

--// Player (1002 for ctrl + f) VEZ DONT LIE U FUCKING LOVE THIS U MAKE ALL UR SCRIPTS BASED OFF PLAYER
local Player_CModifications = Player:Section("Character Modifications")
local Player_Combat = Player:Section("Pvp/Combat")

--// Speed (1003)
local SpeedToggle = Player_CModifications:Toggle("Speed", false, function(State)
    Util:SetState("Speed", State)
end, "Toggles the speed changer")

Player_CModifications:Slider("Speed", 16, 500, Util:GetInt("Speed"), function(Num)
    Util:SetInt("Speed", Num)
end, false, "Changes your speed if your speed changer is on")

--// Jump (1004)
Player_CModifications:Toggle("Jump", false, function(State)
    Util:SetState("Jump", State)
end, "Toggles the jump changer")

Player_CModifications:Slider("Jump", 50, 1000, Util:GetInt("Jump"), function(Num)
    Util:SetInt("Jump", Num)
end, false, "Changes your jump if your speed changer is on")

Player_CModifications:Toggle("Control Stand (Godmode/Invis)", false, function(State)
    if State then
        local RunService = game:GetService("RunService")
        local CurrentCharacter = Util:GetCharacter()
        local HRP = Util:GetHRP()
        local Humanoid = Util:GetHumanoid()
        local RemoteFunc = CurrentCharacter:FindFirstChild("RemoteFunction")
        if not CurrentCharacter:FindFirstChild("StandMorph") then
            RemoteFunc:InvokeServer("ToggleStand", "Toggle")
        end

        repeat task.wait() until CurrentCharacter:FindFirstChild("StandMorph")

        local StandMorph = Util:GetCharacter().StandMorph
        local StandHumanoid = StandMorph.AnimationController
        local TempStore = Instance.new("Folder", game.ReplicatedStorage)
        TempStore.Name = "TempStorage"

        Library:Notification("Control Stand", "Now controlling stand!", 5)

        local Camera = workspace.CurrentCamera
        CameraValue = Instance.new("ObjectValue", StandMorph.Parent); 
        CameraValue.Name = "FocusCam"
        CameraValue.Value = StandHumanoid

        for i,v in pairs(CurrentCharacter:GetChildren()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end

        Util:AddTask("JumpSignal", Humanoid:GetPropertyChangedSignal("Jump"):Connect(function()
            if Humanoid.Jump then
                StandHumanoid.Jump = true
            end

            task.wait()
        end))

        for i,v in pairs(workspace.Locations:GetChildren()) do
            if v.Name == "Naples' Sewers" then
                v.Parent = TempStore
            end
        end

        Util:AddTask("StandTPLoop", RunService.Heartbeat:Connect(function()
            local MoveDirection = Camera.CFrame:VectorToObjectSpace(Humanoid.MoveDirection)
            StandHumanoid:Move(MoveDirection, true)

            if not StandMorph then
                RemoteFunc:InvokeServer("ToggleStand", "Toggle")
            end

            HRP.CFrame = StandMorph:FindFirstChild("HumanoidRootPart").CFrame - Vector3.new(0,36,0)

            task.wait()
        end))

        StandMorph.PrimaryPart.StandAttach:FindFirstChild("AlignOrientation").Enabled = false
        StandMorph.PrimaryPart.StandAttach:FindFirstChild("AlignPosition").Enabled = false

        for i,v in pairs(StandMorph.Parent:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("UnionOperation") then
                game:GetService("PhysicsService"):SetPartCollisionGroup(v, "Players")
            end
        end
    else
        local CurrentCharacter = Util:GetCharacter()
        local RemoteFunc = CurrentCharacter:FindFirstChild("RemoteFunction")
        local StandMorph = CurrentCharacter:FindFirstChild("StandMorph")
        if not StandMorph then
            RemoteFunc:InvokeServer("ToggleStand", "Toggle")
        end
        local StandPos = StandMorph:FindFirstChild("HumanoidRootPart").CFrame

        for i,v in pairs(game.ReplicatedStorage.TempStorage:GetChildren()) do
            if v.Name == "Naples' Sewers" then
                v.Parent = workspace.Locations
            end
        end

        Util:DisconnectTask("StandTPLoop")
        Util:DisconnectTask("JumpSignal")
        CurrentCharacter:FindFirstChild("HumanoidRootPart").CFrame = StandPos
        CurrentCharacter.FocusCam:Destroy()
        RemoteFunc:InvokeServer("ToggleStand", "Toggle")
        Library:Notification("Control Stand", "Stopped controlling stand!", 5)
    end
end, "Allows you to pilot any stand and gives you godmode and invis")

Player_CModifications:Slider("Control Stand Walkspeed", 0, 125, 2, function(Num)
    Util:GetCharacter():WaitForChild("StandMorph", 3).AnimationController.WalkSpeed = Num
end, false, "changes your stand walkspeed")

--[[Player_CModifications:Toggle("Godmode", false, function(State)
    Util:SetState("God Mode", State)

    if Util:GetState("God Mode") == true then
        SpeedToggle:UpdateAsset(true)
        AutoSprintToggle:UpdateAsset(true)
        Library:Notification("epik yba haxx", "Godmode has been enabled", 5)
        Util:AddTask("RemoveHealthText", workspace.IgnoreInstances.ChildAdded:Connect(function(child)
            task.wait()
            if child.Name == "Part" then
                child:Destroy()
            end
        end))

        Util:AddTask("Godmode", Util:GetPlayer().Character.Humanoid.HealthChanged:Connect(function(val)
            Util:GetCharacter().RemoteEvent:FireServer("Poison", {Duration = math.huge, TotalDamage = math.huge})
        end))

        Util:AddTask("SpoofHealth", Util:GetService("RunService").Heartbeat:Connect(function()
            if Util:GetPlayer().PlayerGui:FindFirstChild("HUD") then
                Util:GetPlayer().PlayerGui.HUD.Main.Indicators.Bars.Health.Size = UDim2.new(0.638530254, 0, 0.475938797, 0)
            end
        end))
    else
        SpeedToggle:UpdateAsset(false)
        AutoSprintToggle:UpdateAsset(false)
        Library:Notification("Godmode", "Resetting Character", 5)
        Util:DisconnectTask("Godmode")
        Util:DisconnectTask("SpoofHealth")
        task.wait(0.2)
        Util:DisconnectTask("RemoveHealthText")
        Util:GetHumanoid().Health = 0
    end
end, "toggles infinite hp")]]

Util:ChangeTable("CachedAssets", "FlyToggle", Player_CModifications:Toggle("Player Fly", false, function(State)
    if State == true then
        Library:Notification("Player Fly", "Fly enabled!", 5)
        local Keys_Pressed = {
            ["W"] = 0;
            ["A"] = 0;
            ["S"] = 0;
            ["D"] = 0;
        }

        local Key_Info = {
            ["W"] = {
                    ["Operator"] = "+";
                    ["Direction"] = "LookVector";
            };
            ["A"] = {
                    ["Operator"] = "-";
                    ["Direction"] = "RightVector";
            };
            ["S"] = {
                    ["Operator"] = "-";
                    ["Direction"] = "LookVector";
            };
            ["D"] = {
                    ["Operator"] = "+";
                    ["Direction"] = "RightVector";
            };
        }
        
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local RunService = game:GetService("RunService")
        local TweenService = game:GetService("TweenService")
        
        local function GetKeyFromEnum(enum)
            return enum.KeyCode.Name
        end
        
        local function GetMass(Model)
            local Mass = 0;
            for i,v in pairs(Model:GetDescendants()) do
                    if v:IsA("BasePart") then Mass = Mass + v:GetMass() end
            end
            return Mass;
        end
        
        local function Math(Operator, A, B)
            if Operator == "-" then return A-B elseif Operator == "+" then return A+B end
        end

        if UIS:IsKeyDown(Enum.KeyCode.W) then
            Keys_Pressed["W"] = 1;
        elseif UIS:IsKeyDown(Enum.KeyCode.A) then
            Keys_Pressed["A"] = 1;
        elseif UIS:IsKeyDown(Enum.KeyCode.S) then
            Keys_Pressed["S"] = 1;
        elseif UIS:IsKeyDown(Enum.KeyCode.D) then
            Keys_Pressed["D"] = 1;
        end
        
        Util:AddTask("FlyThingy", UIS.InputBegan:Connect(function(Key, Typing)
            if Typing then return end
            
            local Key_String = GetKeyFromEnum(Key)
            if Keys_Pressed[Key_String] then
                    Keys_Pressed[Key_String] = 1
            end
        end))
        
        Util:AddTask("FlyThingy2", UIS.InputEnded:Connect(function(Key, Typing)
            if Typing then return end
            
            local Key_String = GetKeyFromEnum(Key)
            if Keys_Pressed[Key_String] then
                    Keys_Pressed[Key_String] = 0
            end
        end))
        
        Util:AddTask("FlyLoop", Util:GetService("RunService").RenderStepped:Connect(function()
            if Util:GetHorse() == nil or Util:GetHorse().Seat.Occupant ~= Util:GetCharacter().Humanoid then
                    Util:GetHumanoid().WalkSpeed = 0; Util:GetHumanoid().JumpPower = 0;
                    Util:GetHRP().CFrame = CFrame.new(Util:GetHRP().Position, Util:GetHRP().Position + workspace.CurrentCamera.CFrame.LookVector)
                    local CharacterMass = GetMass(Util:GetCharacter())
                    
                    local Velocity = Vector3.new(0, CharacterMass/workspace.Gravity, 0) --// Lets try not to decend
                    for i,v in pairs(Keys_Pressed) do
                        if v == 0 then
                        else
                            Velocity = Math(Key_Info[i].Operator, Velocity, Util:GetHRP().CFrame[Key_Info[i].Direction] * (Util:GetInt("FlySpeed")*25) * CharacterMass)
                        end
                    end
                    
                    Util:GetHRP().Velocity = Velocity
            elseif Util:GetHorse() ~= nil and Util:GetHorse().Seat.Occupant == Util:GetCharacter().Humanoid then
                    Util:GetHorse().Humanoid.WalkSpeed = 0; Util:GetHorse().Humanoid.JumpPower = 0; Util:GetHorse().Speed.Value = 0;
                    Util:GetHorse().PrimaryPart.CFrame = CFrame.new(Util:GetHorse().PrimaryPart.Position, Util:GetHorse().PrimaryPart.Position + workspace.CurrentCamera.CFrame.LookVector)
                    local CharacterMass = GetMass(Util:GetHorse())
                    
                    local Velocity = Vector3.new(0, CharacterMass/workspace.Gravity, 0) --// Lets try not to decend
                    for i,v in pairs(Keys_Pressed) do
                        if v == 0 then
                        else
                            Velocity = Math(Key_Info[i].Operator, Velocity, Util:GetHorse().PrimaryPart.CFrame[Key_Info[i].Direction] * (Util:GetInt("FlySpeed")*25) * CharacterMass)
                        end
                    end
                    
                    Util:GetHorse().PrimaryPart.Velocity = Velocity
            end
        end))
    else
        Library:Notification("Player Fly", "Fly disabled!", 5)
        Util:DisconnectTask("FlyLoop")
        Util:Disconnect("FlyThingy")
        Util:Disconnect("FlyThingy2")
        Util:GetHumanoid().WalkSpeed = 16
    end
end))

Player_CModifications:Slider("Fly Speed", 0.1, 1, Util:GetInt("FlySpeed"), function(Num)
    Util:SetInt("FlySpeed", Num)
end, true, "changes fly speed")

Player_CModifications:Button("Reset Character", function()
    Util:GetHumanoid().Health = 0
    Library:Notification("kys", "keep yourself safe!", 3)
end, "Resets your character")

AutoSprintToggle = Player_CModifications:Toggle("Auto Sprint", false, function(State)
    Util:SetState("Auto Sprinting", State)

    while Util:GetState("Auto Sprinting") == true and Util:GetCharacter() do task.wait()
        if Util:GetCharacter().RemoteFunction:InvokeServer("ReturnSprint").IsSprinting ~= true then
            Util:GetCharacter().RemoteFunction:InvokeServer("ToggleSprinting")
        end
    end
end, "Toggles auto sprint")

Player_Combat:Toggle("Anti Vamp Burn", false, function(State)
    Util:SetState("Anti Vamp Burn", State)
    Util:GetCharacter().RemoteEvent:FireServer("VampireBurnOff")
end, "Turns on anti vamp burn")

Player_Combat:Toggle("Anti Rock Trap", false, function(State)
    if State == true then
        Util:AddTask("RocksThing", workspace.IgnoreInstances.ChildAdded:Connect(function(child)
            if child.Name == "Rocks" then    
                    for i,v in pairs(workspace.IgnoreInstances.Rocks:GetChildren()) do
                        if string.find(v.Name, "Rock") then
                            v.Size = Vector3.new(0,0,0)
                            Util:GetCharacter().UpperTorso.Anchored = false
                        end
                    end
            end
        end))
    else
        Util:DisconnectTask("RocksThing")
    end
end, "Turns on anti rock trap")

--[[Player_Combat:Toggle("Anti Time Stop (patched currently)", false, function(State)
    if State then
        Util:AddTask("AntiTS", Util:GetCharacter().ChildAdded:Connect(function(child)
            if child.Name == "InTimeStop" then
            child:Destroy() 
            end
        end))
    else
        Util:DisconnectTask("AntiTS")
    end
end, "Turns on anti time stop")]]

Player_Combat:Toggle("Anti-Timestop", false, function(State)
	if State then
        local oldpos = Util:GetHRP().CFrame
		Util:AddTask("AntiTS", workspace.Living.DescendantAdded:Connect(function(Descendant)
			if Descendant.Name == "TimeStopping" then
				if Util:GetPlayer():DistanceFromCharacter(workspace.Living[tostring(Descendant.Parent)].HumanoidRootPart.Position) < 25 then
					oldpos = Util:GetHRP().CFrame
					task.wait(0.1)

					Util:GetHRP().CFrame += Vector3.new(800,1000,500)

					task.wait(Util:GetInt("TSDelay"))

					Util:GetHRP().CFrame = oldpos
				else
					return
				end
			end
		end))
	else
        Util:DisconnectTask("AntiTS")
	end
end, "Turns on Anti-Timestop")

Player_Combat:Slider("Anti-Timestop Delay", 0, 0.8, Util:GetInt("TSDelay"), function(Value)
	Util:SetInt("TSDelay", Value)
end, true, "How long to wait before teleporting back!")

Player_Combat:Toggle("Anti Bleed/Fire/Poison", false, function(State)
    if State then
        Util:AddTask("AntiEffects", game.CollectionService.TagAdded:Connect(function(Tag)
            if Tag == "AntiHeal" then
                Util:GetPlayer().Character.RemoteEvent:FireServer("StopPoison")
                Util:GetPlayer().Character.RemoteEvent:FireServer("StopBleed")
                Util:GetPlayer().Character.RemoteEvent:FireServer("StopFire")
            end
        end))
    else
        Util:DisconnectTask("AntiEffects")
    end
end, "Turns on anti Bleed/Fire/Poison")

Player_Combat:Toggle("Player ESP", false, function(State)
    if State == true then
        local Folder = Instance.new("Folder", Util:GetService("CoreGui"))
        Folder.Name = "GayESP"

        for i,v in pairs(Util:GetService("Players"):GetPlayers()) do
                if v ~= Util:GetPlayer() then
                    Util:AddTask("Chr", v.CharacterAdded:Connect(function(Chars)
                        Util:Outline(Chars)
                        Util:LabelChar(Chars)
                    end))
                
                    if v.Character then
                        Util:Outline(v.Character)
                        Util:LabelChar(v.Character)
                    end
                end
        end

        Util:AddTask("Chr2", Util:GetService("Players").PlayerAdded:Connect(function(Player)
                Player.CharacterAdded:Connect(function(Chars)
                    Util:Outline(Chars)
                    Util:LabelChar(Chars)
                end)
        end))
    else
        Util:GetService("CoreGui").GayESP:Destroy()
        Util:DisconnectTask("Chr")
        Util:DisconnectTask("Chr2")
    end
end, "turns on name esp for players")

Util:Log("Xenon Debug - Passed Player Tab Load")

--// Autofarm (1006 for ctrl + f)
if not Util:IsSBR() then -- dont mind this
local Autofarms_ItemFarm = Autofarms:Section("Item Farm Settings")
local Autofarms_Items = Autofarms:Section("Items")

--// Item farm (1007)
Autofarms_ItemFarm:Toggle("Item ESP", false, function(State)
    Util:SetState("Item ESP", State)
end, "Toggles Item ESP")

Autofarms_ItemFarm:Toggle("Item Notification", false, function(State)
    Util:SetState("Item Notify", State)
end, "Toggles notifications when an items spawns")

Autofarms_ItemFarm:Slider("Collection Delay", 0.2, 3, 0.6, function(Value)
    Util:SetInt("Item Collection Delay", Value)
end, true, "Changes the delay before picking up an item.")

Autofarms_ItemFarm:Toggle("Item Farm", Util:GetState("Item Farming"), function(State)
    Util:SetState("Item Farming", State)
    Util:SaveConfig();

    if State == true then
        local ItemCachedCharacter = {} --// Temporary
        Util:AddTask("ItemClip", Util:GetService("RunService").Stepped:Connect(function()
            local Char = Util:GetCharacter()
            if Char then
                    if #ItemCachedCharacter == 0 then
                        for _, v in pairs(Char:GetDescendants()) do
                            if v:IsA("BasePart") then
                                    table.insert(ItemCachedCharacter, v)  
                            end
                        end
                    end
                    for _, v in pairs(ItemCachedCharacter) do
                        v.CanCollide = false    
                    end
            end
        end))
    else
        Util:DisconnectTask("ItemClip")
    end

    while Util:GetState("Item Farming") == true do task.wait()
        for Prompt, Item in pairs(Util:GetTable("Queue")) do
            local PickupStart = tick()
            local Character = Util:GetCharacter()
            local ItemCFrame = Item.CFrame
            local ItemName = Item.ItemName
            

            if Util:GetState("Item Farming") == false then
                    break
            end

            if not table.find(Util:GetTable("Items"), ItemName) then
                    continue
            end

            local StartTime = tick()
            if Item.ItemModel.Parent ~= nil and Character and Character:FindFirstChild("HumanoidRootPart") and Util:IsMax(ItemName) == false and table.find(Util:GetTable("Items"), ItemName) then
                    Util:ChangeTable("Cache", "OldPosition", Character.PrimaryPart.CFrame)
                    repeat 
                        task.wait()
                        Character.PrimaryPart.CFrame = Item.ItemModel.PrimaryPart.CFrame - (v3(0, 10, 0))
                    until tick() - StartTime >= Util:GetInt("Item Collection Delay")
                    repeat
                        task.wait()
                        if Item.ItemModel and Item.ItemModel.Parent == workspace.Item_Spawns.Items then 
                            Character.PrimaryPart.CFrame = (Item.ItemModel.PrimaryPart.CFrame - (v3(0, 10, 0)))
                        end
                        pcall(function()
                            workspace.CurrentCamera.CFrame = CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, Item.ItemModel.PrimaryPart.CFrame.Position)
                            Prompt.RequiresLineOfSight = false
                            Prompt.HoldDuration = 0
                            Prompt.MaxActivationDistance = 30
                        end)
                        fireproximityprompt(Prompt)
                    until Item.ItemModel.Parent ~= workspace.Item_Spawns.Items or tick()-PickupStart >= 5
                    repeat task.wait()
                        if Item.ItemModel and Item.ItemModel.Parent == workspace.Item_Spawns.Items then 
                            Character.PrimaryPart.CFrame = (Item.ItemModel.PrimaryPart.CFrame - (v3(0, 10, 0)))
                        end
                    until Item.ItemModel.Parent ~= workspace.Item_Spawns.Items or tick()-PickupStart >= 3.5
                    Util:ChangeTable("Queue", Prompt, nil)

                    if Character and Character:FindFirstChild("HumanoidRootPart") then
                        Character.PrimaryPart.CFrame = Util:GetTable("Cache")["OldPosition"]
                    end
            end
        end
    end
    Util:DisconnectTask("ItemClip")
end, "Toggles item farm")

--// Item Toggles (1008)

for i,v in pairs(Util:GetTable("AllItems")) do
    Autofarms_Items:Toggle(v, (table.find(Util:GetTable("Items"), v) ~= nil and true or false) , function(State)
        if State == true then
            if not table.find(Util:GetTable("Items"), v) then
                    Util:InsertTable("Items", v)
            end
        else
            if table.find(Util:GetTable("Items"), v) then
                    Util:RemoveTable("Items", v)
            end
        end
        Util:SaveConfig();
    end, ("Adds " .. v .. " to the item farming list."))
end

Util:Log("Xenon Debug - Passed Item Section")
--// Autofarm (1010 for ctrl + f)
local Autofarms_StandFarm = Autofarms:Section("Stand Farm Settings")
local Autofarms_Stands = Autofarms:Section("Stands")

Autofarms_StandFarm:Toggle("Arrow Pity Farm", false, function(State)
    Util:SetState("Arrow Pity Farm", State)
    if State then
        Library:Notification("Warning", "For this to work you must turn on Stand Farm", 10)
    end
end, "toggle arrow pity farm")

Autofarms_StandFarm:Toggle("Rib Pity Farm", false, function(State)
    Util:SetState("Rib Pity Farm", State)
    if State then
        Library:Notification("Warning", "For this to work you must turn on Rib Farm", 10)
    end
end, "toggle rib pity farm")

Autofarms_StandFarm:Slider("Pity Amount (1 Pity = 0.04)", 20, 125, 20, function(Value)
    Util:SetInt("Pity Amount", Value)
    print("Set pity to:", (Value * 0.04) + 1 .."%")
end, false, "Pity to farm to")

StandRedeemedFarm = Autofarms_StandFarm:Toggle("Use Redeemed Items", false, function(State)
    Util:SetState("Use Redeemed", State)
end, "use redeemed roka/arrow")

Autofarms_StandFarm:Toggle("Keep any shiny", false, function(State)
    Util:SetState("Keep any shiny", State)
end, "keep any shiny while stand farming")

Autofarms_StandFarm:Toggle("Stand Farm", Util:GetState("Stand Farming"), function(State)
    Util:SetState("Stand Farming", State)

    if Util:GetState("Stand Farming") == true then
        local HRP = Util:GetHRP()
        if HRP then
            HRP.CFrame = CFrame.new(-324, -32, 47)
        end

        if not Util:IsTaskRunning("SafeFarm") then
            Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                    task.wait(0.15)
                    Char.PrimaryPart.CFrame = CFrame.new(-324, -32, 47)
            end))
        end
    else
        Util:DisconnectTask("SafeFarm")
    end

    if Util:GetState("Arrow Pity Farm") == false then
        while Util:GetState("Stand Farming") == true do task.wait()
            if Util:CountItem("Mysterious Arrow") == 0 or Util:CountItem("Rokakaka") == 0 then
                Util:FarmItems{
                    "Rokakaka";
                    "Mysterious Arrow";
                }
            end

            if Util:GetState("Use Redeemed") == true and (Util:CountItem("Redeemed Mysterious Arrow") == 0 or Util:CountItem("Redeemed Rokakaka") == 0) then
                    StandRedeemedFarm:UpdateAsset(false)
            end

            if (Util:HasStand() == true and Util:FindTable("Stands", Util:CheckStand()) and Util:GetState("Stand Farming") == true) or (Util:HasStand() and Util:GetState("Keep any shiny") == true and Util:HasShiny()) then --// They got a stand they wanted?
                if Util:GetState("Waiting") == false then --// They haven't been notified before?
                    Library:Notification("You have the stand you wanted!", Util:CheckStand(), 6)
                    Util:SetState("Waiting", true) --// They now have been notified
                    continue
                else
                    continue
                end
            end

            Util:SetState("Waiting", false)

            if Util:HasStand() == true and Util:FindTable("Stands", Util:CheckStand()) == nil and Util:GetState("Stand Farming") == true then
                if Util:GetState("Use Redeemed") == true then
                    Util:UseRedeemedRoka()
                else
                    Util:UseRoka()
                end

                repeat task.wait() until Util:GetCharacter() and Util:GetCharacter():FindFirstChild("RemoteEvent")
            end

            if Util:HasStand() == false and Util:GetState("Stand Farming") == true then
                Util:Stats()
                if Util:GetState("Use Redeemed") == true then
                    Util:UseRedeemedArrow()
                else
                    Util:UseArrow()
                end

                repeat task.wait() until Util:HasStand() == true
            end
        end
    else
        while (Util:GetState("Stand Farming") == true and Util:GetState("Arrow Pity Farm")) == true do task.wait()
            if Util:CountItem("Mysterious Arrow") == 0 or Util:CountItem("Rokakaka") == 0 then
                Util:FarmItems{
                    "Rokakaka";
                    "Mysterious Arrow";
                }
            end

            if Util:HasStand() == true and Util:GetPlayer().PlayerStats.Pity.Value ~= Util:GetInt("Pity Amount") and Util:GetState("Arrow Pity Farm") == true then
                    if Util:GetState("Use Redeemed") == true then
                        Util:UseRedeemedRoka()
                    else
                        Util:UseRoka()
                    end

                    repeat task.wait() until Util:GetCharacter() and Util:GetCharacter():FindFirstChild("RemoteEvent")
            end

            if Util:HasStand() == false and Util:GetState("Stand Farming") == true then
                    Util:Stats()
                    if Util:GetState("Use Redeemed") == true then
                        Util:UseRedeemedArrow()
                    else
                        Util:UseArrow()
                    end

                    repeat task.wait() until Util:HasStand() == true
            end

            if Util:GetPlayer().PlayerStats.Pity.Value == Util:GetInt("Pity Amount") then
                    Util:GetPlayer():Kick("Reached Pity Amount")
            end
        end
    end
end, "Farms wanted stands for you") 

Autofarms_StandFarm:Toggle("Rib Farm", Util:GetState("Rib Farming"), function(State)
    Util:SetState("Rib Farm", State)

    if Util:GetState("Rib Farm") == true then
        Util:GetHRP().CFrame = CFrame.new(-324, -32, 47)

        if not Util:IsTaskRunning("SafeFarm") then
            Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                    task.wait(0.15)
                    Char.PrimaryPart.CFrame = CFrame.new(-324, -32, 47)
            end))
        end
    else
        Util:DisconnectTask("SafeFarm")
    end

    if Util:GetState("Rib Pity Farm") == false then
        while Util:GetState("Rib Farm") == true do task.wait()
            if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
                    Util:FarmItems{
                        "Rib Cage of The Saint's Corpse";
                    }
            end
            
            if Util:HasStand() == true and Util:FindTable("Stands", Util:CheckStand()) then
                    if Util:GetState("Waiting") == false then --// They haven't been notified before?
                        Library:Notification("You have the stand you wanted!", Util:CheckStand(), 6)
                        Util:SetState("Waiting", true) --// They now have been notified
                        continue
                    else
                        continue
                    end
            end
            Util:SetState("Waiting", false) --// They now have been notified

            if Util:GetState("Rib Farm") == true then
                    Util:Stats()
                    Util:UseRib()
            end
        end
    else
        while Util:GetState("Rib Farm") == true and Util:GetState("Rib Pity Farm") == true do task.wait()
            if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
                    Util:FarmItems{
                        "Rib Cage of The Saint's Corpse";
                    }
            end

            if Util:GetPlayer().PlayerStats.Pity.Value ~= Util:GetInt("Pity Amount") and Util:GetState("Rib Farm") == true then
                    Util:Stats()
                    Util:UseRib()
            end
            
            if Util:GetPlayer().PlayerStats.Pity.Value == Util:GetInt("Pity Amount") then
                    Util:GetPlayer():Kick("Reached Pity Amount")
            end
        end
    end
end, "Farms wanted rib stand for you")

for i,v in pairs(Util:GetTable("AllStands")) do
    Autofarms_Stands:Toggle(v, (table.find(Util:GetTable("Stands"), v) ~= nil and true or false) , function(State)
        if State == true then
            if not table.find(Util:GetTable("Stands"), v) then
                Util:InsertTable("Stands", v)
            end
        else
            if table.find(Util:GetTable("Stands"), v) then
                Util:RemoveTable("Stands", v)
            end
        end
        Util:SaveConfig();
    end, ("Adds " .. v .. " to the stand farming list."))
end

Util:Log("Xenon Debug - Passed Stand Farm Section")
--// Autofarm (1020 for ctrl + f)
local Autofarms_ShinyFarm = Autofarms:Section("Shiny Farm Settings")
local Autofarms_Shinys = Autofarms:Section("Shinys")

Autofarms_ShinyFarm:Toggle("Shiny Farm", Util:GetState("Shiny Farming"), function(State)
    Util:SetState("Shiny Farming", State)
    Util:SaveConfig();

    if Util:GetState("Shiny Farming") == true then
        Util:GetHRP().CFrame = CFrame.new(-324, -32, 47)
        print("teleported to safe spot for shiny farm")

        if not Util:IsTaskRunning("SafeFarm") then
            Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                task.wait(0.325)
                Char.PrimaryPart.CFrame = CFrame.new(-324, -32, 47)
                print("teleported to safe spot for shiny farm")
            end))
        end
    else
        Util:DisconnectTask("SafeFarm")
    end
    print("starting shinyfarm loop..")
    while Util:GetState("Shiny Farming") == true do task.wait(0.1)
        warn("Waiting state:", Util:GetState("Waiting"))
        warn("Has Stand:", Util:HasStand())
        --print("Pity:", Util:GetPlayer().PlayerStats.Pity.Value == 0)
        local nig, ger = pcall(function()
            warn("Has Shiny:", Util:HasShiny(), Util:CheckShiny())
            warn("ENabrled Shiny:", Util:FindTable("ShinyToggles", Util:CheckShiny()))
        end)
        print("shinyfrm debug", nig, ger)
        if Util:CountItem("Mysterious Arrow") == 0 or Util:CountItem("Rokakaka") == 0 then
            Util:FarmItems{
                "Rokakaka";
                "Mysterious Arrow";
                "Lucky Arrow"
            }
        end

        if Util:GetState("Use Redeemed") == true and (Util:CountItem("Redeemed Mysterious Arrow") == 0 or Util:CountItem("Redeemed Rokakaka") == 0) then
            StandRedeemedFarm:UpdateAsset(false)
        end

        if Util:FindTable("ShinyToggles", Util:CheckShiny()) then
            for _, Instance in Util:GetPlayer().PlayerGui.HUD.Main.Frames.Stands.ScrollingFrame:GetChildren() do
                if Instance:FindFirstChild("TextLabel") then
                    if string.find(Instance.TextLabel.Text, "None") then
                        Util:GetCharacter().RemoteEvent:FireServer("SwapStand", tostring(Instance.Name))
                        Util:GetPlayer().CharacterAdded:Wait()
                    else
						print("breaking loop due to having wanted shiny")
                        break
                    end
                end
            end

            continue 
        end

        if Util:HasStand() == true and (Util:HasShiny() == true and Util:FindTable("ShinyToggles", Util:CheckShiny()) ~= nil) then --// They got a stand they wanted?
            print("got wanted shiny, checking for wait and sending webhook.")
            if Util:GetState("Waiting") == false then --// They haven't been notified before?
                Library:Notification("You have the shiny you wanted!", Util:CheckShiny(), 3)
                if not Util:GetState("Disable Xenon Logs") then
                    Util:SendWebhook(getgenv().Webhook, "Username: `" .. Util:Censor(Util:GetPlayer().Name) .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                    Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                else
                    Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                end
                print("attemped to send webhook")
                Util:SetState("Waiting", true) --// They now have been notified
                print("attemping to swap to empty stand slot")
                for _, Instance in Util:GetPlayer().PlayerGui.HUD.Main.Frames.Stands.ScrollingFrame:GetChildren() do
                    if Instance:FindFirstChild("TextLabel") then
                        if string.find(Instance.TextLabel.Text, "None") then
                            Util:GetCharacter().RemoteEvent:FireServer("SwapStand", tostring(Instance.Name))
                            Util:GetPlayer().CharacterAdded:Wait()
                        else
							print("got wanted shiny and have no slots left, breaking loop")
							break
                        end
                    end
                end
            else
                continue
            end
        end
        print("starting waiting roka")
        if Util:GetState("Shiny Farming") == true then
            Util:SetState("Waiting", false)
        end

        warn("BEFORE ROKA ATTEMPT Waiting state:", Util:GetState("Waiting"))
        warn("BEFORE ROKA ATTEMPT WaitingHas Stand:", Util:HasStand())
        --print("Pity:", Util:GetPlayer().PlayerStats.Pity.Value == 0)
        local nig, ger = pcall(function()
            warn("BEFORE ROKA ATTEMPT Waiting Has Shiny:", Util:HasShiny(), Util:CheckShiny())
            warn("BEFORE ROKA ATTEMPT Waiting ENabrled Shiny:", Util:FindTable("ShinyToggles", Util:CheckShiny()))
        end)
        print("before roka", nig, ger)
        print("passed waiting roka")
        if (Util:HasStand() == true and (Util:HasShiny() == true and Util:FindTable("ShinyToggles", Util:CheckShiny()) == nil)) or (Util:HasStand() == true and (Util:HasShiny() == false)) then
            print("roka #1")
            task.spawn(function()
				local gay, sex = pcall(function()
					if Util:CheckShiny() ~= "None" and Util:CheckShiny() ~= "nil" then
                        Library:Notification("You have an unwanted shiny!", Util:CheckShiny(), 3)
                        if not Util:GetState("Disable Xenon Logs") then
                            Util:SendWebhook(getgenv().Webhook, "Username: `" .. Util:Censor(Util:GetPlayer().Name) .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained an unwanted Shiny!")
                            Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained an unwanted Shiny!")
                        else
                            Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained an unwanted Shiny!")
                        end
                    end
                end)
                print(gay,sex)
            end)
            print("roka #2")
            if Util:GetState("Use Redeemed") == true then
                Util:UseRedeemedRoka()
                print("roka '#3")
            else
                Util:UseRoka()
                print("roka#3")
            end
            print("roka # 4")
            repeat task.wait() until Util:GetCharacter() and Util:GetCharacter():FindFirstChild("RemoteEvent")
            continue
        end

        print("moving on to using arrows..")
        if Util:HasStand() == false and Util:GetState("Shiny Farming") == true and Util:CountItem("Mysterious Arrow") >= 1 then
            print("setting skill tree points..")
            Util:Stats()
            if Util:GetState("Use Redeemed") == true then
                Util:UseRedeemedArrow()
            else
                Util:UseArrow()
                print("YEURRRR")
            end
            print("HIYA BABEY")
            repeat task.wait() until Util:HasStand() == true 
            print("NOOOROR")
            continue
        end
        print("if this print is shown, script failed to use an arrow.")
    end
end, "Farms wanted shinys for you")

Autofarms_ShinyFarm:Toggle("Rib Shiny Farm", false, function(State)
    Util:SetState("Rib Shiny Farm", State)

    if Util:GetState("Rib Shiny Farm") == true then
        Util:GetHRP().CFrame = CFrame.new(-324, -32, 47)

        if not Util:IsTaskRunning("SafeFarm") then
            Util:AddTask("SafeFarm", Util:GetPlayer().CharacterAdded:Connect(function(Char)
                    task.wait(0.15)
                    Char.PrimaryPart.CFrame = CFrame.new(-324, -32, 47)
            end))
        end
    else
        Util:DisconnectTask("SafeFarm")
    end

    while Util:GetState("Rib Shiny Farm") == true do task.wait()
        if Util:CountItem("Rib Cage of The Saint's Corpse") == 0 then
            Util:FarmItems{
                    "Rib Cage of The Saint's Corpse";
            }
        end
        
        if Util:HasStand() == true and Util:FindTable("ShinyToggles", Util:CheckShiny()) then
            if Util:GetState("Waiting") == false then --// They haven't been notified before?
                    Library:Notification("You have the shiny you wanted!", Util:CheckShiny(), 3)
                    if not Util:GetState("Disable Xenon Logs") then
                        Util:SendWebhook(getgenv().Webhook, "Username: `" .. Util:Censor(Util:GetPlayer().Name) .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                        Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                    else
                        Util:SendWebhook(Util:GetString("Webhook"), "Username: `" .. Util:GetPlayer().Name .. "`\nShiny: `" .. Util:CheckShiny() .. "`\nPity: `" .. Util:GetString("Pity") .. "`", "Xenon V3 (Private) - Obtained a Shiny!")
                    end
                    Util:SetState("Waiting", true) --// They now have been notified
                    continue
            else
                    continue
            end
        end
        Util:SetState("Waiting", false) --// They now have been notified

        if Util:GetState("Rib Shiny Farm") == true then
            Util:Stats()
            Util:UseRib()

            repeat task.wait() until Util:HasStand() == true 
            continue
        end
    end
end, "Toggles rib shiny farm")

Autofarms_Shinys:Button("Enable all shinys", function()
    local ShinyToggles = Util:GetTable("ShinyToggles")
    for i,v in pairs(ShinyToggles) do
        task.wait()
        v:UpdateAsset(true)
    end
end, "Toggles all shinys on")

Autofarms_Shinys:Button("Disable all shinys", function()
    print("Clicked")
    local ShinyToggles = Util:GetTable("ShinyToggles")
    for i,v in pairs(ShinyToggles) do
        task.wait()
        v:UpdateAsset(false)
    end
end, "Toggles all shinys off")

for i,v in pairs(Util:GetTable("AllShinys")) do
    Util:InsertTable("ShinyToggles", Autofarms_Shinys:Toggle(v, (table.find(Util:GetTable("Shinys"), v) ~= nil and true or false) , function(State)
        if State == true then
            if not table.find(Util:GetTable("Shinys"), v) then
                Util:InsertTable("Shinys", v)
            end
        else
            if table.find(Util:GetTable("Shinys"), v) then
                Util:RemoveTable("Shinys", v)
            end
        end
        Util:SaveConfig();
    end, ("Adds " .. v .. " to the shiny farming list.")))
end
Util:Log("Xenon Debug - Passed Shiny Farm Section")

--// Quest farm (1021 for ctrl + f)
local Autofarms_QuestFarm = Autofarms:Section("Quest Farm")

--// Gotta parse the quests
Util:Log("Xenon Debug - Parsing Quests")
while true do
    local Children = #workspace.Dialogues:GetChildren()
    if Children >= 56 then
        break
    end
    task.wait(1)
end
for i,v in pairs(workspace.Dialogues:GetChildren()) do
    if v.Name ~= "Abbacchio's Partner [Lvl 15+]" and v.Name ~= "Darius, The Executioner [Lvl. 20+]" and v.Name ~= "Pucci [Lvl. 40+]" and v.Name ~= "Kars [Lvl. 30+]" then
        local NameLowered = string.lower(v.Name)
        local Found = string.find(NameLowered, "lvl")

        if Found then
            Util:InsertTable("ParsedQuests", v.Name)
        end
    end
end
Util:Log("Xenon Debug - Parsed Quests")

local CurrentQuest = Autofarms_QuestFarm:Label("Quest Selected:", Util:GetString("Quest"))

Autofarms_QuestFarm:Dropdown("Quest", Util:GetTable("ParsedQuests"), function(SelectedQuest)
    Util:SetString("Quest", SelectedQuest)
    CurrentQuest:UpdateAsset("Quest Selected: " .. Util:GetString("Quest"))
end, "Choose a quest from the list")

Autofarms_QuestFarm:Toggle("Auto Choose", false, function(State)
Util:SetState("Auto Choose Quest", State)
    while Util:GetState("Auto Choose Quest") == true do
        local LastHighest = 0
        local LastQuest;
        for i,v in pairs(Util:GetTable("ParsedQuests")) do
        if v == "Homeless Man Jill [Lvl. 15+]" then
            continue
        end
    
        local PlayerLevel = Util:GetPlayer().PlayerStats.Level.Value
        local ParsedName = v:gsub("%D", "") --// Replaces everything apart from digits with ""
        ParsedName = tonumber(ParsedName)
        
        if ParsedName <= PlayerLevel and ParsedName >= LastHighest then
            LastHighest = ParsedName
            LastQuest = v
        end
        end
        Util:SetString("Quest", (LastQuest ~= nil and LastQuest or "No available quest found"))
        CurrentQuest:UpdateAsset("Quest Selected: " .. Util:GetString("Quest"))
    
        task.wait(3)
    end
end, "Automatically chooses the best quest for you")

Util:Log("Xenon Debug - Passed Auto Choose Quests")
Autofarms_QuestFarm:Toggle("Quest Farm", false, function(State)
    Util:SetState("Quest Farm", State)

    Util:AddTask(Util:GetPlayer().PlayerGui.HUD.ChildAdded:Connect(function(Child)
        if Child.Name == "QuestCompleted" then
            Util:SetState("CompletedQuest", true)
        end
    end))
    
    while Util:GetState("Quest Farm") == true do
        if Util:GetState("CompletedQuest") == true then
            Util:GetQuest(workspace.Dialogues:FindFirstChild(Util:GetString("Quest")))
        end
        local EnemyName = Util:GetTable("QuestInfo")[Util:GetString("Quest")]["Enemy"]
        if EnemyName then
            for i,v in pairs(workspace.Living:GetChildren()) do
                    if Util:GetPlayer().PlayerStats.QuestProgress.Value >= Util:GetPlayer().PlayerStats.QuestMaxProgress.Value then
                        Util:SetState("CompletedQuest", true)
                        break
                    end
                    if v.Name == EnemyName then
                        local S, F = pcall(function()
                            Util:Kill(v)
                        end)
                        if F then
                            warn("[Xenon] Kill function experienced an error; but was handled by xenon -", F)
                        end
                    end
            end
        else
            Util:GetQuest(workspace.Dialogues:FindFirstChild(Util:GetString("Quest")))
            local Item = Util:GetTable("QuestInfo")[Util:GetString("Quest")].Item
            local Amount = Util:GetTable("QuestInfo")[Util:GetString("Quest")].Amount

            local CurrentAmount = Util:CountItem(Item)
            if CurrentAmount < Amount then
                    for i,v in pairs(workspace.Item_Spawns.Items:GetChildren()) do
                        if v.Name == Item then
                            Util:Collect(v)
                        end
                        if Util:CountItem(Item) >= Amount then
                            break
                        end
                    end
            end
            Util:GetQuest(workspace.Dialogues:FindFirstChild(Util:GetString("Quest")))
        end
        task.wait()
    end
end, "Toggles quest farming")

Util:Log("Xenon Debug - Passed Quest Section")
--// Quest farm (1022 for ctrl + f)
local Autofarms_NpcFarm = Autofarms:Section("NPC Farm")

local TP_C;
TP_C = Autofarms_NpcFarm:Dropdown("NPCs Dropdown", Util:GetTable("AllNPCs"), function(SelectedNPC)
    Util:SetString("Target NPC", SelectedNPC)
end, "Select npc to teleport to")

-- ADD NPCS TO TABLE
for i,v in pairs(workspace.Living:GetChildren()) do
    if v:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", v.Name) == nil then
        Util:InsertTable("AllNPCs", v.Name)
        TP_C:UpdateAsset(Util:GetTable("AllNPCs"))
        Util:Log("Xenon:3040: Added NPC to table (" .. v.Name .. ")")
    elseif v:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", v.Name) ~= nil then
        --Util:Log("Xenon:3042: (Above ID 1023) - Attempt to add NPC that already exists in table")
    end
end

workspace.Living.ChildAdded:Connect(function(child)
    if child:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", child.Name) == nil then
        Util:InsertTable("AllNPCs", child.Name)
        TP_C:UpdateAsset(Util:GetTable("AllNPCs"))
        Util:Log("Xenon:3051: Added NPC to table (" .. child.Name .. ")")
    elseif child:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", child.Name) ~= nil then
        --Util:Log("Xenon:3053: (Above ID 1023) - Attempt to add NPC that already exists in table")
    end
end)
Util:Log("Xenon Debug - Added NPCs to Table")

Autofarms_NpcFarm:Toggle("Farm NPCs", false, function(State)
    Util:SetState("NPC Farm", State)

    while Util:GetState("NPC Farm") == true do
        local EnemyName = Util:GetString("Target NPC")
        for i,v in pairs(workspace.Living:GetChildren()) do
            if v.Name == EnemyName then
                    local S, F = pcall(function()
                        Util:Kill(v)
                    end)
                    if F then
                        warn("[Xenon] Kill function experienced an error; but was handled by xenon -", F)
                    end
            end
        end  
        task.wait()
    end
end)

end -- dont mind this
Util:Log("Xenon Debug - Passed Quest Farm Section")
--// Stand Info (1023 for ctrl + f)
-- dont mind this vvvvv 
if not Util:IsSBR() then
    local Autofarms_StandInfo = Autofarms:Section("Stand Info")

    local PityLabel = Autofarms_StandInfo:Label("Not Loaded")
    local StandLabel = Autofarms_StandInfo:Label("Not Loaded")
    local ShinyLabel = Autofarms_StandInfo:Label("Not Loaded")

    task.spawn(function()
        while task.wait(1) do
            local S,F = pcall(function()
                local Pity = ( "Pity: " .. Util:GetPlayer().PlayerStats.PityCount.Value .. " (" .. (Util:GetPlayer().PlayerStats.PityCount.Value*0.04) + 1 .. "%)" )
                local Stand = ( "Stand: " .. Util:GetPlayer().PlayerStats.Stand.Value )
                local Shiny = ( "Shiny: " .. (Util:CheckShiny() == nil and "No Stand" or Util:CheckShiny()) )
                PityLabel:UpdateAsset(Pity)
                StandLabel:UpdateAsset(Stand)
                ShinyLabel:UpdateAsset(Shiny)
            end)
            if not S then
                warn("[Xenon] Stand info had an error, but it was handled -", F)
            end
        end
    end)
end -- dont mind this
Util:Log("Xenon Debug - Passed Stand Info Section")
--// Teleports (1030 for ctrl + f)
local Teleports_Players = Teleports:Section("Teleports (Players)")
local Teleports_NPCs;
local Teleports_Places;
if not Util:IsSBR() then
    Teleports_NPCs = Teleports:Section("Teleports (NPCs)")
    Teleports_Places = Teleports:Section("Teleports (Places)")
end

Util:Log("Xenon Debug - Created Teleports Sections")

--// Player Teleports
local TP_A;
TP_A = Teleports_Players:Dropdown("Players Dropdown", Util:GetTable("AllPlayers"), function(SelectedPlayer)
    Util:SetString("Chosen Player", SelectedPlayer)
end, "Select player to teleport to")

for i,v in pairs(Util:GetService("Players"):GetPlayers()) do
    Util:InsertTable("AllPlayers", v.Name)
    TP_A:UpdateAsset(Util:GetTable("AllPlayers"))
end

Util:GetService("Players").ChildAdded:Connect(function(child)
    if not child:IsA("Player") then return end
    Util:InsertTable("AllPlayers", child.Name)
    TP_A:UpdateAsset(Util:GetTable("AllPlayers"))
end)

Util:GetService("Players").ChildRemoved:Connect(function(child)
    if not child:IsA("Player") then return end
    Util:RemoveTable("AllPlayers", child.Name)
    TP_A:UpdateAsset(Util:GetTable("AllPlayers"))
end)

Util:Log("Xenon Debug - Added Players to Table")

Teleports_Players:Button("Teleport to Player", function()
    Util:GetHRP().CFrame = Util:GetService("Players"):FindFirstChild(Util:GetString("Chosen Player")).Character.PrimaryPart.CFrame
end, "Teleport to player you selected")

--// NPC Teleports
local TP_B;
if not Util:IsSBR() then
TP_B = Teleports_NPCs:Dropdown("NPCs Dropdown", Util:GetTable("AllNPCs"), function(SelectedNPC)
    Util:SetString("Chosen NPC", SelectedNPC)
end, "Select npc to teleport to")

-- ADD NPCS TO TABLE
for i,v in pairs(workspace.Living:GetChildren()) do
    if v:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", v.Name) == nil then
        Util:InsertTable("AllNPCs", v.Name)
        TP_B:UpdateAsset(Util:GetTable("AllNPCs"))
        Util:Log("Xenon:3040: Added NPC to table (" .. v.Name .. ")")
    elseif v:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", v.Name) ~= nil then
        Util:Log("Xenon:3042: (Above ID 1023) - Attempt to add NPC that already exists in table")
    end
end

workspace.Living.ChildAdded:Connect(function(child)
    if child:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", child.Name) == nil then
        Util:InsertTable("AllNPCs", child.Name)
        TP_B:UpdateAsset(Util:GetTable("AllNPCs"))
        Util:Log("Xenon:3051: Added NPC to table (" .. child.Name .. ")")
    elseif child:FindFirstChild("Spawn") and Util:FindTable("AllNPCs", child.Name) ~= nil then
        Util:Log("Xenon:3053: (Above ID 1023) - Attempt to add NPC that already exists in table")
    end
end)
Util:Log("Xenon Debug - Added NPCs to Table")
Teleports_NPCs:Button("Teleport to NPC", function()
    local NPC = workspace.Living:FindFirstChild(Util:GetString("Chosen NPC"))
    if NPC then
        Util:GetHRP().CFrame = NPC.PrimaryPart.CFrame
    end
end, "Teleport to npc you selected")

--// Add teleports from table
for place, cframe in pairs(Util:GetTable("AllTeleports")) do
    Teleports_Places:Button(place, function()
        Util:GetHRP().CFrame = cframe
    end, "Teleport to: "..place)
end

end -- dont mind this
Util:Log("Xenon Debug - Added Teleports from Table")
        
--// Misc Tab (1041 for ctrl +f)
local Misc_SBRSettings;
local Misc_SBR;
local Misc_SBRHorse;
local Misc_SBRPTP;
local Misc_SBRHTP;
if Util:IsSBR() then
    Misc_SBRSettings = Misc:Section("SBR Settings")
    Misc_SBR = Misc:Section("SBR")
    Misc_SBRHorse = Misc:Section("SBR Horse Settings")
    Misc_SBRPTP = Misc:Section("SBR Player TPs")
    Misc_SBRHTP = Misc:Section("SBR Horse TPs")
end
local Misc_Webhooks = Misc:Section("Webhooks")
local Misc_Weather = Misc:Section("Weather")
local Misc_Map = Misc:Section("Map")
local Misc_Other = Misc:Section("Other")
local Misc_Waypoints = Misc:Section("Waypoint")
local Misc_Dash = Misc:Section("Dash")
local Misc_Specs = Misc:Section("Buy Specs")
local Misc_Arcade = Misc:Section("Arcade")
local Misc_Items = Misc:Section("Items")
local Misc_Sell = Misc:Section("Item Sell")
local Misc_Keybinds = Misc:Section("Keybinds")
local Misc_Trolling = Misc:Section("Trolling")
local Misc_Animations = Misc:Section("Animations")

local WaypointStatus = Misc_Waypoints:Label("Waypoint: None")

Util:Log("Xenon Debug - Created Misc Sections")

Misc_Webhooks:Toggle("Disable Xenon Logs", Util:GetState("Disable Xenon Logs"), function(State)
    Util:SetState("Disable Xenon Logs", State)
    Util:SaveConfig();
end, "Disables from logging to xenon server")

Misc_Webhooks:TextBox("Webhook", function(Text)
    Util:SetString("Webhook", Text)
    Util:SaveConfig();
end, "Webhook to log to")

Misc_Waypoints:Button("Set Waypoint", function()
    local Char = Util:GetCharacter()
    if Char and Char.PrimaryPart then
        Util:ChangeTable("Cache", "Waypoint", Char.PrimaryPart.CFrame) 
        WaypointStatus:UpdateAsset("Waypoint: " .. tostring(math.round(Char.PrimaryPart.Position.X)) .. ", " .. tostring(math.round(Char.PrimaryPart.Position.Y)) .. ", " .. tostring(math.round(Char.PrimaryPart.Position.Z)))
    end
end, "Sets your waypoint to your current position.")

Misc_Waypoints:Button("Go to waypoint", function()
    local Char = Util:GetCharacter()
    if Util:GetTable("Cache")["Waypoint"] ~= nil and Char and Char.PrimaryPart then
        Char.PrimaryPart.CFrame = Util:GetTable("Cache")["Waypoint"]
    end
end, "Teleports you to your current waypoint")

local SpawnpointStatus = Misc_Waypoints:Label("Spawnpoint: Default")

Misc_Waypoints:Button("Set Spawnpoint", function()
    local Char = Util:GetCharacter()
    if Char and Char.PrimaryPart then
        Util:ChangeTable("Cache", "Spawnpoint", Char.PrimaryPart.CFrame) 
        SpawnpointStatus:UpdateAsset("Spawnpoint: " .. tostring(math.round(Char.PrimaryPart.Position.X)) .. ", " .. tostring(math.round(Char.PrimaryPart.Position.Y)) .. ", " .. tostring(math.round(Char.PrimaryPart.Position.Z)))
        Util:AddTask("Spawnpoint", Util:GetPlayer().CharacterAdded:Connect(function(Chara)
            task.wait(0.15)
            Chara.PrimaryPart.CFrame = Util:GetTable("Cache")["Spawnpoint"]
        end))
    end
end, "Sets your waypoint to your current position.")

Misc_Waypoints:Button("Reset Spawnpoint", function()
    Util:DisconnectTask("Spawnpoint")
    Util:ChangeTable("Cache", "Spawnpoint", nil)
    SpawnpointStatus:UpdateAsset("Spawnpoint: Default")
end, "Resets your spawn point to default spawns.")

Misc_Trolling:Dropdown("Player", Util:GetTable("AllPlayers"), function(Player)
    Util:SetString("TrollingPlayer", Player)
end, "Choose player to use troll features on.")

game.Players.PlayerAdded:Connect(function() Misc_Trolling:UpdateAsset(Util:GetTable("AllPlayers")) end)
game.Players.PlayerRemoving:Connect(function() Misc_Trolling:UpdateAsset(Util:GetTable("AllPlayers")) end)
Util:Log("Xenon Debug - Passed Misc Trolling Asset Update")
Misc_Trolling:Label("Stand Trolling")

if Util:IsSBR() then
    Misc_Trolling:Button("Insta Kill Player (One-time use)", function(thing)
        if thing then
            local Target = workspace.Living:FindFirstChild(Util:GetString("TrollingPlayer"))
            for i = 1,10,1 do
                task.wait(0.1)
                Util:GetHorse().HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame
            end
            if Util:GetHorse().Seat.Occupant == Target.Humanoid then
                task.wait(.5)
                Util:GetHorse().HumanoidRootPart.CFrame = Util:GetHorse().HumanoidRootPart.CFrame + Vector3.new(0,-155,0)
                task.wait(2)
                Util:GetHorse().Seat:Destroy()
            else
                print("Unable to pickup target", Target)
            end
        else
            print("Enabled:", thing, "Target:", workspace.Living:FindFirstChild(Util:GetString("TrollingPlayer")))
        end
    end, "insta kill someone (can only use once)")
end

Misc_Trolling:Toggle("Stand Attach", false, function(State)
    if State == true then
        Util:AddTask("StandAttach", Util:GetService("RunService").RenderStepped:Connect(function()
            local Char = Util:GetCharacter()
            local EnemyChar = workspace.Living:FindFirstChild(Util:GetString("TrollingPlayer"))
            if Char and EnemyChar then
                    local Stand = Char:FindFirstChild("StandMorph")
                    if Stand then
                        Stand.HumanoidRootPart.StandAttach.AlignPosition.MaxForce = 9e9 --// Instant animations

                        local Prediction = EnemyChar.PrimaryPart.Velocity * Util:GetInt("Prediction Strength") 

                        if Prediction == Vector3.new(0, 0, 0) then
                            Stand.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame + EnemyChar.PrimaryPart.CFrame.LookVector * Util:GetInt("Stand Attach Distance")
                            Stand.HumanoidRootPart.CFrame =  CFrame.lookAt(Stand.HumanoidRootPart.Position, EnemyChar.PrimaryPart.Position)
                        else
                            Stand.HumanoidRootPart.CFrame = EnemyChar.PrimaryPart.CFrame + Prediction
                            Stand.HumanoidRootPart.CFrame =  CFrame.lookAt(Stand.HumanoidRootPart.Position, EnemyChar.PrimaryPart.Position)
                        end

                        if Util:GetState("Follow Stand") == true then
                            Char.PrimaryPart.CFrame = Stand.HumanoidRootPart.CFrame - Vector3.new(0, 25, 0)
                        end

                        if Util:GetState("View Stand") == true then
                            if Char:FindFirstChild("FocusCam") == nil then
                                    local FocusCam = Instance.new("ObjectValue", Char)
                                    FocusCam.Name = "FocusCam"
                                    FocusCam.Value = EnemyChar.PrimaryPart
                            else
                                    local FocusCam = Char:FindFirstChild("FocusCam")
                                    FocusCam.Value = EnemyChar.PrimaryPart
                            end
                        else
                            if Char:FindFirstChild("FocusCam") then
                                    Char:FindFirstChild("FocusCam"):Destroy()
                            end
                        end
                    end
            end
        end))
    else
        Util:DisconnectTask("StandAttach")
        local Char = Util:GetCharacter()
        if Char then
            local FocusCam = Char:FindFirstChild("FocusCam")
            if FocusCam then
                    FocusCam:Destroy()
            end
            Char.PrimaryPart.CFrame += Vector3.new(0, 25, 0)
        end
    end
end, "Attach stand to player")

Misc_Trolling:Slider("Stand Attach Distance", 0, 3.5, Util:GetInt("Stand Attach Distance"), function(Value)
    Util:SetInt("Stand Attach Distance", Value)
end, true, "Distance of stand from enemy when standing still (varies per stand)")

Misc_Trolling:Slider("Prediction Strength", 0, 0.5, Util:GetInt("Prediction Strength"), function(Value)
    Util:SetInt("Prediction Strength", Value)
end, true, "Strength of prediction")

Misc_Trolling:Toggle("Follow Stand", false, function(State)
    Util:SetState("Follow Stand", State)
    if State == false and Util:IsTaskRunning("StandAttach") then
        local Char = Util:GetCharacter()
        if Char then
            Char.PrimaryPart.CFrame += Vector3.new(0, 25, 0)
        end
    end
end, "Follow the stand while trolling")

Misc_Trolling:Toggle("View Stand", false, function(State)
    Util:SetState("View Stand", State)
end, "View the stand while trolling")

Misc_Weather:Toggle("No Fog", false, function(State)
    if State == true then
        game.Lighting.FogStart = 1000000
        Util:AddTask("No Fog", game.Lighting:GetPropertyChangedSignal("FogStart"):Connect(function()
            game.Lighting.FogStart = 1000000
        end))
        game.Lighting.FogStart = 1000000
    else
        Util:DisconnectTask("No Fog")
        game.Lighting.FogStart = 15
    end
end, "Removes fog")

Misc_Weather:Button("Set Night", function()
    game.Lighting.ClockTime = 0
end, "set to night")

Misc_Weather:Toggle("Always Night", false, function(State)
    if State == true then
        game.Lighting.ClockTime = 0
        Util:AddTask("ClockChangeNight", game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            game.Lighting.ClockTime = 0
        end))
        game.Lighting.ClockTime = 0
    else
        Util:DisconnectTask("ClockChangeNight")
    end
end, "Makes it always night")

Misc_Weather:Button("Set Day", function()
    game.Lighting.ClockTime = 12
end, "set to night")

Misc_Weather:Toggle("Always Day", false, function(State)
    if State == true then
        game.Lighting.ClockTime = 12
        Util:AddTask("ClockChangeDay", game.Lighting:GetPropertyChangedSignal("ClockTime"):Connect(function()
            game.Lighting.ClockTime = 12
        end))
        game.Lighting.ClockTime = 12
    else
        Util:DisconnectTask("ClockChangeDay")
    end
end, "Makes it always day")

local function Notify(St1, St2)
    Library:Notification(St1, St2, 3)
end

Misc_Map:Toggle("No-Clip", false, function(State)
    if State == true then
		local NoClipCache = {}
		Util:AddTask("No-Clip", Util:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
				if #NoClipCache == 0 then
                    for _, Part in Util:GetCharacter():GetChildren() do
                        if Part:IsA("BasePart") or Part:IsA("UnionOperation") then
                            table.insert(NoClipCache, Part)
                        end 
                    end
                end

                for _, Part in NoClipCache do
                    Part.CanCollide = false
                end
            end)
        end))
    else
		Util:DisconnectTask("No-Clip")
    end
end, "Enables noclip (or disables)")

Misc_Map:Button("Destroy Map", function()
    for i,v in workspace.Folder:GetDescendants() do
        if v:IsA("BasePart") and not v:IsDescendantOf(workspace.Folder.Roads) and not v:IsDescendantOf(workspace.Folder.Terrain) and not v:IsDescendantOf(workspace.Folder.ParkingGarage) and not v:IsDescendantOf(workspace.Folder.Prison_Bridge) and v.Name ~= "Sewer_Ladders_Part" and not v:IsDescendantOf(workspace.Folder.IMPORTANT.OceanFloor) and v.Name ~= "Ocean" and v.Name ~= "Sidewalk_1" and v.Name ~= "Sidewalk_2" and v.Material ~= "Cobblestone" and v.Name ~= "Stairs" and not string.find(v.Name, "Rails") and v.Name ~= "TrainStation_Walkway" and v.Name ~= "TrainStation_Platform" and v.Name ~= "Park_Path" and v.Name ~= "Gravel" and v.Name ~= "Grass" and v.Name ~= "Rock" and v.Name ~= "LowerStairs" and v.Name ~= "UpperStairs" and v.Name ~= "Truss" and not string.find(v.Name, "Grass") and v.Name ~= "Stairs_Step" and not v:IsDescendantOf(workspace.Folder.Prison["Prison_Rails"]) and not v:IsDescendantOf(workspace.Folder.Prison["Prison_Stairs"]) and not v:IsDescendantOf(workspace.Folder.Prison["Prison_Flooring"]) and v.Name ~= "Prison_TopStaircase" and v.Name ~= "Prison_BottomStaircase" and v.Name ~= "Prison_Wall" and v.Name ~= "City_Building_Planks" and v.Name ~= "TrainStation_Under_Brick" and v.Name ~= "TrainStation_Steps" and v.Name ~= "WallPiece_2" and v.Name ~= "Arcade_Interior_Stair" then
            v.Size = Vector3.new(0,0,0)
        end
    end

    Notify("Finished Map Delete Process", "Deleted Map")
end, "deletes map")

Misc_Other:Toggle("Hide own name", false, function(state)
    local Plr = Util:GetPlayer()
    
    if state == true then 
        Plr.PlayerGui.HUD.Playerlist[Plr.Name].PlayerName.Text = "???"
    else
        Plr.PlayerGui.HUD.Playerlist[Plr.Name].PlayerName.Text = Plr.DisplayName
    end
end, "Hides your name")

Misc_Other:Toggle("Hide all player names", false, function(state)
    local Plr = Util:GetPlayer()

    if state then
        for i,v in pairs(game.Players:GetPlayers()) do
            Plr.PlayerGui.HUD.Playerlist[v.Name].PlayerName.Text = "???"
            if v.Character then
                    v.Character.Humanoid.DisplayDistanceType = "None"
            end
        end

        Util:AddTask("HideAll", game.Players.ChildAdded:Connect(function(child)
            task.wait(2)
            if child.Character and child.Character:FindFirstChild("Humanoid") then
                    child.Character.Humanoid.DisplayDistanceType = "None"
            end
        end))
    else
        for i,v in pairs(game.Players:GetPlayers()) do
            Plr.PlayerGui.HUD.Playerlist[v.Name].PlayerName.Text = v.Name
            if v.Character then
                    v.Character.Humanoid.DisplayDistanceType = "Viewer"
            end
        end

        Util:DisconnectTask("HideAll")
    end
end, "Hides all players names")

Misc_Other:Toggle("Steal dropped money", true, function(State)
    if State and Util:GetCharacter() and Util:GetHRP() then
        for i,v in pairs(workspace:GetChildren()) do
            if v:IsA("MeshPart") and v.Name == "Money" then
                    task.wait(0.1)
                    repeat task.wait()
                        v.CFrame = Util:GetHRP().CFrame
                    until workspace:FindFirstChild("Money") == nil
            end
        end

        Util:AddTask("Money Thing", workspace.ChildAdded:Connect(function(Child)
            if Child.Name == "Money" then
                    task.wait(0.55)
                    repeat task.wait()
                        Child.CFrame = Util:GetHRP().CFrame
                    until workspace:FindFirstChild("Money") == nil
            end
        end))
    else
        Util:DisconnectTask("Money Thing")
    end
end, "Steals players dropped money")

Misc_Other:Slider("Field Of View", 10, 120, 70, function(Value)
    workspace.Camera.FieldOfView = Value
end, false, "change camera fov")

Misc_Other:Button("Reset Field Of View", function()
    workspace.Camera.FieldOfView = 70
end, "resets camera fov")

Misc_Other:Button("Buy Mysterious Bow ($500)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Mysterious Bow Seller", ["Dialogue"] = "Dialogue4", ["Option"] = "Option1"})
end, "buys mysterious bow")

Misc_Other:Button("Buy Pizza ($50)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Pizza", ["Option"] = "Option1", ["Dialogue"] = "Dialogue2"}, 1, 2)
end, "buys pizza")

Misc_Other:Button("Buy Tea ($50)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Cafe", ["Option"] = "Option1", ["Dialogue"] = "Dialogue2"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Rokakaka ($1,750)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Rokakaka"}, 1, 2)

end, "buys tea")

Misc_Other:Button("Buy Mysterious Arrow ($500)", function()
     Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Mysterious Arrow"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Lucky Arrow ($50,000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Lucky Arrow"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy DIO's Diary ($5,000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x DIO's Diary"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Rib Cage ($2,250)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Rib Cage of The Saint's Corpse"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Left Arm ($10,000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Left Arm of The Saint's Corpse"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Pelvis ($30,000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Pelvis of The Saint's Corpse"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Heart ($30,000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Heart of The Saint's Corpse"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Buy Pure Rokakaka ($2500)", function()
    Util:GetCharacter().RemoteEvent:FireServer("PurchaseShopItem", {["ItemName"] = "1x Pure Rokakaka"}, 1, 2)
end, "buys tea")

Misc_Other:Button("Jesus Dialogue", function()
    Util:GetCharacter().RemoteEvent:FireServer("PromptTriggered", game.ReplicatedStorage.NewDialogue.Jesus)
end, "Opens Jesus dialogue.")

Misc_Other:Button("Halloween Jack Dialogue", function()
    Util:GetCharacter().RemoteEvent:FireServer("PromptTriggered", game.ReplicatedStorage.NewDialogue:FindFirstChild("Halloween Event"))
end, "Opens Jesus dialogue.")


Misc_Dash:Toggle("Infinite Dash", false, function(State)
    Util:SetState("Infinite Dash", State)

    local DashAnims = Instance.new("Folder", workspace)
    if Util:GetState("Infinite Dash") == true then
        Util:AddTask("InfDash", game:GetService("UserInputService").InputBegan:Connect(function(Input, GameProcessed)
            if GameProcessed then return end

            if Input.KeyCode == Enum.KeyCode[Util:GetPlayer().PlayerStats.DashKey.Value] and (tick()-Util:GetInt("InfTick")) >= Util:GetInt("InfDelay") then
                    Util:SetInt("InfTick", tick())
                    if not Util:GetPlayer().Character then return end
                    local Dir, Anim_ = Util:GetStroke();
                    local Anim = Instance.new("Animation", DashAnims) Anim.Name = "YBA_AntiCheat_Bypass_REAL" Anim.AnimationId = "rbxassetid://"..Anim_
                    local Anim2 = Util:GetHumanoid():LoadAnimation(Anim)
                    Anim2:Play()
                    GAYPENIS = Instance.new("BodyVelocity", Util:GetHRP())
                    GAYPENIS.Velocity = (Util:GetHRP().CFrame * CFrame.Angles(0, math.rad(Dir), 0)).lookVector * Util:GetInt("DashPower")
                    GAYPENIS.MaxForce = Vector3.new(55555,1000,55555)
                    game:GetService("Debris"):AddItem(GAYPENIS, 0.25)
            end
        end))
    else
        Util:DisconnectTask("InfDash")
    end
end, "toggles custom dash")

Misc_Dash:Slider("Dash Power", 10, 1000, 50, function(Value)
    Util:SetInt("DashPower", Value)
end, false, "set dash power")

Misc_Dash:Slider("Dash Delay", 0, 3.5, 1, function(Value)
    Util:SetInt("InfDelay", Value)
end, true, "set dash delay")

Misc_Specs:Button("Buy Hamon ($15000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Jonathan", ["Option"] = "Option1"})
end, "Buys Hamon fighting style")

Misc_Specs:Button("Buy Boxing ($10000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Quinton", ["Option"] = "Option1"})
end, "Buys Boxing fighting style")

Misc_Specs:Button("Buy Boxing Gloves ($1000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue1", ["NPC"] = "Boxing Gloves", ["Option"] = "Option1"})
end, "Buys Boxing Gloves")

Misc_Specs:Button("Buy Spin ($10000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Gyro", ["Option"] = "Option1"})
end, "Buys Spin fighting style")

Misc_Specs:Button("Buy Vamp ($10000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Elder Vampire Roomy", ["Option"] = "Option1"})
end, "Buys Vampire fighting style")

Misc_Specs:Button("Buy Pluck ($10000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue5", ["NPC"] = "Uzurashi", ["Option"] = "Option1"})
end, "Buys Pluck fighting style")

Misc_Specs:Button("Buy Sword ($1000)", function()
    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["Dialogue"] = "Dialogue1", ["NPC"] = "Pluck", ["Option"] = "Option1"})
end, "Buys Sword")

Misc_Arcade:Toggle("Auto Arcade", false, function(State)
    if State then
        Util:AddTask("AutoArcade", Util:GetService("RunService").RenderStepped:Connect(function()
            if Util:GetPlayer().PlayerGui:FindFirstChild("RollingItem") == nil then
                    Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Item Machine", ["Option"] = "Option1", ["Dialogue"] = "Dialogue1"})
            end
            task.wait(1)
    end))
    else
        Util:DisconnectTask("AutoArcade")
    end     
end)

Misc_Items:Button("Use Arrow", function()
    local Skills = {"Agility I", "Agility II", "Agility III", "Worthiness I"}
    Util:LearnSkills(Skills)
    Util:UseArrow()
end, "uses a mysterious arrow")

Misc_Items:Button("Collect Arrows", function()
    Util:FarmItems{"Mysterious Arrow"}
end, "collects mysterious arrows")

Misc_Items:Button("Use Rokakaka", function()
    Util:UseRoka()
end, "uses a rokakaka")

Misc_Items:Button("Collect Rokakakas", function()
    Util:FarmItems{"Rokakaka"}
end, "collects rokakakas")

Misc_Items:Button("Use Rib Cage", function()
    local Skills = {"Agility I", "Agility II", "Agility III", "Worthiness I", "Worthiness II", "Worthiness III", "Worthiness IV", "Worthiness V"}
    Util:LearnSkills(Skills)
    Util:UseRib()
end, "uses a rib cage of the saint's corpse")

Misc_Items:Button("Collect Rib Cages", function()
    Util:FarmItems{"Rib Cage of the Saint's Corpse"}
end, "collects rib cage of the saint's corpse")

Misc_Sell:Button("Sell selected items 1 time", function()
    for i,v in pairs(Util:GetTable("ChosenItemsToSell")) do
        Util:GetHumanoid():EquipTool(Util:GetPlayer().Backpack:FindFirstChild(v))
        Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {NPC = "Merchant", Option = "Option1", Dialogue = "Dialogue5"})
    end
end, "auto sells selected items once")

Misc_Sell:Toggle("Auto Sell", false, function(State)
    Util:SetState("Auto Sell", State)

    while Util:GetState("Auto Sell") == true do task.wait()
        for i,v in pairs(Util:GetTable("ChosenItemsToSell")) do
			if not Util:GetPlayer().Backpack:FindFirstChild(v) then continue end
            
            Util:GetHumanoid():EquipTool(Util:GetPlayer().Backpack:FindFirstChild(v))
            Util:GetCharacter().RemoteEvent:FireServer("EndDialogue", {NPC = "Merchant", Option = "Option1", Dialogue = "Dialogue5"})
            task.wait()
        end
    end
end, "auto sells all selected items")

Misc_Sell:Button("Select all items", function()
    local ItemToggles = Util:GetTable("ItemSellToggles")
    for i,v in pairs(ItemToggles) do
        task.wait()
        v:UpdateAsset(true)
    end
end, "Toggles all items on")

Misc_Sell:Button("Unselect all items", function()
    print("Clicked")
    local ItemToggles = Util:GetTable("ItemSellToggles")
    for i,v in pairs(ItemToggles) do
        task.wait()
        v:UpdateAsset(false)
    end
end, "Toggles all items off")

for i,v in pairs(Util:GetTable("AllItems")) do
    Util:InsertTable("ItemSellToggles", Misc_Sell:Toggle(v, (table.find(Util:GetTable("ChosenItemsToSell"), v) ~= nil and true or false) , function(State)
        if State == true then
            if not table.find(Util:GetTable("ChosenItemsToSell"), v) then
                Util:InsertTable("ChosenItemsToSell", v)
            end
        else
            if table.find(Util:GetTable("ChosenItemsToSell"), v) then
                Util:RemoveTable("ChosenItemsToSell", v)
            end
        end
        Util:SaveConfig();
    end, ("Adds " .. v .. " to the item selling list.")))
end

for KeybindName, Data in pairs(Util:GetTable("Keybinds")) do
    Misc_Keybinds:Keybind(KeybindName, Data.Keybind, function(NewKeybind)
    Data.Function()
    end, "A changeable keybind")
end
Util:Log("Xenon Debug - Passed Keybind Section")
if Util:IsSBR() then
    Misc_SBRSettings:Toggle("Player ESP", false, function(State)
        if State == true then
            local Folder = Instance.new("Folder", Util:GetService("CoreGui"))
            Folder.Name = "GayESP"

            for i,v in pairs(Util:GetService("Players"):GetPlayers()) do
                    if v ~= Util:GetPlayer() then
                        Util:AddTask("Chr", v.CharacterAdded:Connect(function(Chars)
                            Util:Outline(Chars)
                            Util:LabelChar(Chars)
                        end))
                    
                        if v.Character then
                            Util:Outline(v.Character)
                            Util:LabelChar(v.Character)
                        end
                    end
            end

            Util:AddTask("Chr2", Util:GetService("Players").PlayerAdded:Connect(function(Player)
                    Player.CharacterAdded:Connect(function(Chars)
                        Util:Outline(Chars)
                        Util:LabelChar(Chars)
                    end)
            end))
        else
            Util:GetService("CoreGui").GayESP:Destroy()
            Util:DisconnectTask("Chr")
            Util:DisconnectTask("Chr2")
        end
    end, "turns on name esp for players")

    Misc_SBRSettings:Toggle("Use Horse for Auto SBR", false, function(State)
        Util:SetState("Use_Horse_ASBR", State)
    end, "use horse for auto sbr instead of player")

    Misc_SBRSettings:Slider("TP to 1st Barrier Delay", 1,60,5, function(Value)
        Util:SetInt("SBR_Delay_1", Value)
    end, false, "Set delay for TPing to 1st Stage")

    Misc_SBRSettings:Slider("TP to 2nd Barrier", 1,60,5, function(Value)
        Util:SetInt("SBR_Delay_2", Value)
    end, false, "Set delay for TPing to 2nd Stage")

    Misc_SBRSettings:Slider("TP to 3rd Barrier", 1,60,5, function(Value)
        Util:SetInt("SBR_Delay_3", Value)
    end, false, "Set delay for TPing to 3rd Stage")

    Misc_SBRSettings:Slider("TP to Last Barrier", 1,60,5, function(Value)
        Util:SetInt("SBR_Delay_4", Value)
    end, false, "Set delay for TPing to Last Barrier")

    Misc_SBRSettings:Slider("TP to End", 1,20,5, function(Value)
        Util:SetInt("SBR_Delay_5", Value)
    end, false, "Set delay for TPing to end")

    Misc_SBRSettings:Slider("Hide Delay", 1, 10, 5, function(Value)
        Util:SetInt("SBR_Delay_Hide", Value)
    end, false, "Set delay for hide after touch barrier")

    Misc_SBR:Toggle("Auto SBR", false, function(State)
        local Horse = Util:GetHorse()
        local HRP = Util:GetHRP()
        if Util:GetState("Use_Horse_ASBR") == true then
            HRP = Util:GetHorse().HumanoidRootPart
        else
            local HRP = Util:GetHRP()
        end

        if State then -- Hide vvv
            HRP.CFrame = SBRTeleports["Normal Hide"] -- Wait for SBR to start vvv
            repeat task.wait() until workspace.Barrier:FindFirstChild("StartBarrier") == nil -- Wait until tp to stage 1 vvv

            task.wait(Util:GetInt("SBR_Delay_1")) -- TP to Stage 1 Barrier vvv
            HRP.CFrame = SBRTeleports["Stage 1 Barrier"] -- Wait until hide vvv
            task.wait(Util:GetInt("SBR_Delay_Hide"))
            HRP.CFrame = SBRTeleports["Normal Hide"] -- Wait for Stage 1 to open vvv
            repeat task.wait() until workspace.Barriers:FindFirstChild("1") == nil -- Wait until tp to stage 2 vvv

            task.wait(Util:GetInt("SBR_Delay_2")) -- TP to Stage 2 Barrier vvv
            HRP.CFrame = SBRTeleports["Stage 2 Barrier"] -- Wait until hide vvv
            task.wait(Util:GetInt("SBR_Delay_Hide"))
            HRP.CFrame = SBRTeleports["Normal Hide"] -- Wait for Stage 2 to open vvv
            repeat task.wait() until workspace.Barriers:FindFirstChild("2") == nil -- Wait until tp to stage 3 vvv

            task.wait(Util:GetInt("SBR_Delay_3")) -- TP to Stage 3 Barrier vvv
            HRP.CFrame = SBRTeleports["Stage 3 Barrier"] -- Wait until hide vvv
            task.wait(Util:GetInt("SBR_Delay_Hide")) 
            HRP.CFrame = SBRTeleports["Normal Hide"]-- Wait for Stage 3 to open vvv
            repeat task.wait() until workspace.Barriers:FindFirstChild("3") == nil -- Wait until tp to stage 4 vvv

            task.wait(Util:GetInt("SBR_Delay_4")) -- TP to Stage 4 Barrier vvv
            HRP.CFrame = SBRTeleports["Stage 4 Barrier"] -- Wait until hide vvv
        
            task.wait(Util:GetInt("SBR_Delay_Hide"))
            repeat task.wait()
                HRP.CFrame = SBRTeleports["Finish Hide"]
            until workspace.Barriers:FindFirstChild("4") == nil
            task.wait(Util:GetInt("SBR_Delay_5")) -- TP to end vvv
            HRP.CFrame = SBRTeleports["Stage 4 Barrier"]
            
            task.wait(Util:GetInt("SBR_Delay_Hide"))
            HRP.CFrame = SBRTeleports["Finish Hide"]
        end
    end)

    Misc_SBR:Toggle("Red Barrier No-Clip", false, function(State)
        if State then
            pcall(function()
                    for i,v in pairs(workspace.Barrier:GetChildren()) do
                        v.CanCollide = false
                    end

                    for i,v in pairs(workspace.Barriers:GetChildren()) do
                        v.CanCollide = false
                    end
            end)
        else
            pcall(function()
                    for i,v in pairs(workspace.Barrier:GetChildren()) do
                        v.CanCollide = true
                    end

                    for i,v in pairs(workspace.Barriers:GetChildren()) do
                        v.CanCollide = true
                    end
            end)
        end
    end)

    Misc_SBRHorse:Slider("Horse WalkSpeed", 0,120,0, function(Value)
        Util:GetHorse().Humanoid.WalkSpeed = Value
    end, false, "Set horse speed")

    Misc_SBRHorse:Slider("Horse JumpPower", 0,100,0, function(Value)
        Util:GetHorse().Humanoid.JumpPower = Value
        
        pcall(function()
            Util:DisconnectTask("HJP")
        end)
        
        Util:AddTask("HJP", game:GetService("UserInputService").InputBegan:connect(function(inputObject, gameProcessedEvent)
            if inputObject.KeyCode == Enum.KeyCode.Space then
                workspace[Util:GetPlayer().Name .."'s Horse"].Humanoid.Jump = true
            end
        end))
    end, false, "Set horse speed")

    for place, cframe in pairs(SBRTeleports) do
        Misc_SBRPTP:Button(place, function()
            Util:GetHRP().CFrame = cframe
        end, "Teleport to: "..place)
    end

    Misc_SBRPTP:Button("Teleport to Horse", function(State)
        if State then
            Util:GetHRP().CFrame = Util:GetHorse().HumanoidRootPart.CFrame
        end
    end, "teleport to your horse")

    for place, cframe in pairs(SBRTeleports) do
        Misc_SBRHTP:Button(place, function()
            Util:GetHorse().PrimaryPart.CFrame = cframe
        end, "Teleport to: "..place)
    end

    Misc_SBRHTP:Button("Teleport Horse to you", function(State)
        if State then
            Util:GetHorse().PrimaryPart.CFrame = Util:GetHRP().CFrame
        end
    end, "teleports your horse to you")
end
Util:Log("Xenon Debug - Passing Pressed Play Check")
if not Util:IsSBR() then
    Util:GetCharacter():WaitForChild("RemoteEvent"):FireServer("PressedPlay")  
end
Util:Log("Xenon Debug - Passed Press Play Check")
-- animations add to table
for i,v in pairs(game.ReplicatedStorage.Anims:GetDescendants()) do
    if v:IsA("Animation") and not Util:FindTable("AnimsBlacklist", v.Name) and v.Parent.Name ~= "Poses" then
        Util:InsertTable("AnimsList", v.Name)
    end
end

for i,v in pairs(game.ReplicatedStorage.Anims.Poses:GetChildren()) do
    if v:IsA("Animation") then
        Util:InsertTable("Poses", v.Name)
    end
end
Util:Log("Xenon Debug - Added Anims to Table")
local DontTouch = Instance.new("Part", workspace)
DontTouch.Transparency = 1
DontTouch.Anchored = true
DontTouch.CanCollide = false
DontTouch.Name = "AnticheatBypass"
Util:Log("Xenon Debug - Passed ACB")
local CurrentAnim = Misc_Animations:Label("Current animation: " .. "None")

Misc_Animations:TextBox("Search animation", function(Text)
    local AnimID = 0
    for i,v in pairs(game.ReplicatedStorage.Anims:GetDescendants()) do
        if v:IsA("Animation") and string.find(v.Name, Text) then
            AnimID = v.AnimationId
            CurrentAnim:UpdateAsset("Current animation: " .. v.Name)
            break
        end
    end
    local Anim = Instance.new("Animation", workspace.AnticheatBypass); Anim.Name = "YBA_AnticheatDetection"; Anim.AnimationId = AnimID
    local Anim2 = Util:GetHumanoid():LoadAnimation(Anim)
    Anim2:Play()
end, "Search wanted animation")

Misc_Animations:Dropdown("Stand & Spec Animations", Util:GetTable("AnimsList"), function(SelectedAnimation)
    local AnimID = 0
    for i,v in pairs(game.ReplicatedStorage.Anims:GetDescendants()) do
        if v:IsA("Animation") and v.Name == SelectedAnimation then
            AnimID = v.AnimationId
            CurrentAnim:UpdateAsset("Current animation: " .. v.Name)
            break
        end
    end

    local Anim = Instance.new("Animation", workspace.AnticheatBypass); Anim.Name = "YBA_AnticheatDetection"; Anim.AnimationId = AnimID
    local Anim2 = Util:GetHumanoid():LoadAnimation(Anim)
    Anim2:Play()
end, "Stand & Spec Animations")

Misc_Animations:Dropdown("Poses", Util:GetTable("Poses"), function(SelectedAnimation)
    local AnimID = 0
    for i,v in pairs(game.ReplicatedStorage.Anims.Poses:GetChildren()) do
        if v:IsA("Animation") and v.Name == SelectedAnimation then
            AnimID = v.AnimationId
            CurrentAnim:UpdateAsset("Current animation: " .. v.Name)
            break
        end
    end

    local Anim = Instance.new("Animation", workspace.AnticheatBypass); Anim.Name = "YBA_AnticheatDetection"; Anim.AnimationId = AnimID
    local Anim2 = Util:GetHumanoid():LoadAnimation(Anim)
    Anim2:Play()
end, "Poses")

Misc_Animations:Button("Stop Animations", function()
    for i,v in pairs(Util:GetHumanoid():GetPlayingAnimationTracks()) do
        v:Stop()
    end

    for i,v in pairs(workspace.AnticheatBypass:GetChildren()) do
        if v.Name == "YBA_AnticheatDetection" then
            v:Destroy()
        end
    end
end, "Stop playing animations")

pcall(function()
    Util:GetPlayer().PlayerGui.Chat.Frame.Visible = true
end)
Util:Log("Xenon Debug - Attempted to fix chat")

game:GetService("CoreGui").XenonV3Lib.TabHolder.Status.Label.Text = "Status: Loaded!"

--- xenon on top
