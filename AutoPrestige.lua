getgenv().standList = getgenv().standList or {
	["The World"] = true,
	["Star Platinum"] = true,
	["Star Platinum: The World"] = true,
	["Crazy Diamond"] = true,
	["King Crimson"] = true,
	["King Crimson Requiem"] = true
}

getgenv().waitUntilCollect = getgenv().waitUntilCollect or 0.5
getgenv().sortOrder = getgenv().sortOrder or "Asc"
getgenv().lessPing = getgenv().lessPing or false
getgenv().autoRequiem = getgenv().autoRequiem or true
getgenv().NPCTimeOut = getgenv().NPCTimeOut or 15
getgenv().HamonCharge = getgenv().HamonCharge or 90
getgenv().Webhook = getgenv().Webhook or ""
game:GetService("CoreGui").DescendantAdded:Connect(function(child)
	if child.Name == "ErrorPrompt" then
		local GrabError = child:FindFirstChild("ErrorMessage",true)
		repeat task.wait() until GrabError.Text ~= "Label"
		local Reason = GrabError.Text
		if Reason:match("kick") or Reason:match("You") or Reason:match("conn") or Reason:match("rejoin") then
			game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
		end
	end
end)

repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer and game.Players.LocalPlayer.Character

local LocalPlayer = game.Players.LocalPlayer
local Character = LocalPlayer.Character
repeat task.wait() until Character:FindFirstChild("RemoteEvent") and Character:FindFirstChild("RemoteFunction")
local RemoteFunction, RemoteEvent = Character.RemoteFunction, Character.RemoteEvent
local HRP = Character.PrimaryPart
local part
local dontTPOnDeath = true

local WebhookMod = 	loadstring(game:HttpGet("https://raw.githubusercontent.com/TamjeedSoftworksllc/Yba/refs/heads/main/WebhookModule"))()

function SendWebhook(Info)
	if getgenv().Webhook then
		local embedData = {
			Title = Info.Title or "YBA Auto Prestige",
			Description = Info.Description or "reality your stupid",
			Thumbnail = "https://media.discordapp.net/attachments/1157046525663399946/1383774038005907467/image.png?ex=6853f7ff&is=6852a67f&hm=d41eb661c6545bae2a36fbe944c27daf527b37f3b66cdf59dc385efac39fe6a5&=&format=webp&quality=lossless&width=596&height=624",
			Color = WebhookMod.colors.black,
			Footer = "Developed by TamjeedSoftworksLLC",
			Fields = {
				{
					name = "Player's Name:",
					value = "```"..tostring(LocalPlayer.Name).."```",
					inline = true
				},
				{
					name = "Player's UserId /",
					value = "```"..tostring(LocalPlayer.UserId).."```",
					inline = true
				},
				{
					name = "Exploit: ",
					value = "```"..tostring( (identifyexecutor and identifyexecutor()) or "Unsupported Exploit" ).."```",
					inline = true
				},
				{
					name = "Player's Profile:",
					value = "https://roblox.com/users/"..tostring(LocalPlayer.UserId).."/profile/",
					inline = true
				},
			}
		}

		WebhookMod.sendEmbed(getgenv().Webhook, embedData)
	else
		print("No webhook")
	end
end


SendWebhook({
	Description = LocalPlayer.Name .. " Started YBA Autofarm"
})


if LocalPlayer.PlayerStats.Level.Value == 50 then
	while true do
		print("Level 50, Auto prestige disabled")
		SendWebhook({
			Description = LocalPlayer.Name .. " Is already Level 50"
		})

		task.wait(9999999)
	end
end


if not LocalPlayer.PlayerGui:FindFirstChild("HUD") then
	print("I FOUND IT")
	local HUD = game:GetService("ReplicatedStorage").Objects.HUD:Clone()
	HUD.Parent = LocalPlayer.PlayerGui
end

print("I DID FOUND IT, MAYBE IT WILL WORK?")
RemoteEvent:FireServer("PressedPlay")

if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1") then
	LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen1"):Destroy()
end

if LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen") then
	LocalPlayer.PlayerGui:FindFirstChild("LoadingScreen"):Destroy()
end

task.spawn(function()
	if game.Lighting:WaitForChild("DepthOfField", 10) then
		game.Lighting.DepthOfField:Destroy()
	end
end)

-- data
local Data = { }
local File = pcall(function()
	Data = game:GetService('HttpService'):JSONDecode(readfile("AutoPres3_"..LocalPlayer.Name..".txt"))
end)

if not File and LocalPlayer.PlayerStats.Level.Value ~= 50 then
	Data = {
		["Time"] = tick(),
		["Prestige"] = LocalPlayer.PlayerStats.Prestige.Value,
		["Level"] = LocalPlayer.PlayerStats.Level.Value
	}
	writefile("AutoPres3_"..LocalPlayer.Name..".txt", game:GetService('HttpService'):JSONEncode(Data))
end

-- start
local lastTick = tick()

local itemHook;
itemHook = hookfunction(getrawmetatable(game.Players.LocalPlayer.Character.HumanoidRootPart.Position).__index, function(p,i)
	if getcallingscript().Name == "ItemSpawn" and i:lower() == "magnitude" then
		return 0
	end
	return itemHook(p,i)
end)

local Hook;
Hook = hookmetamethod(game, '__namecall', newcclosure(function(self, ...)
	local args = {...}
	local namecallmethod =  getnamecallmethod()

	if namecallmethod == "InvokeServer" then
		if args[1] == "idklolbrah2de" then
			return "  ___XP DE KEY"
		end
	end

	return Hook(self, ...)
end))

--// Hop Func //--
local PlaceID = game.PlaceId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour

local HttpService = game:GetService("HttpService")

local function getGameName(placeId)
	local success, result = pcall(function()
		local url = "https://games.roblox.com/v1/games?placeIds=" .. tostring(placeId)
		local response = game:HttpGet(url)
		local data = HttpService:JSONDecode(response)
		return data.data[1].name
	end)

	if success and result then
		return result
	else
		warn("Failed to get game name:", result)
		return "Unknown"
	end
end

local function TPReturner()
	local Site;
	if foundAnything == "" then
		Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=' .. getgenv().sortOrder .. '&limit=100'))
	else
		Site = game.HttpService:JSONDecode(game:HttpGet('https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=' .. getgenv().sortOrder .. '&limit=100&cursor=' .. foundAnything))
	end

	local ID = ""
	if Site.nextPageCursor and Site.nextPageCursor ~= "null" and Site.nextPageCursor ~= nil then
		foundAnything = Site.nextPageCursor
	end

	local num = 0;
	for _,v in pairs(Site.data) do
		local Possible = true
		ID = tostring(v.id)
		if tonumber(v.maxPlayers) > tonumber(v.playing) then
			for _,Existing in pairs(AllIDs) do
				if num ~= 0 then
					if ID == tostring(Existing) then
						Possible = false
					end
				else
					if tonumber(actualHour) ~= tonumber(Existing) then
						local delFile = pcall(function()
							delfile("XenonAutoPres3ServerBlocker.json")
							AllIDs = {}
							table.insert(AllIDs, actualHour)
						end)
					end
				end
				num = num + 1
			end
			if Possible == true then
				table.insert(AllIDs, ID)
				task.wait()
				pcall(function()
					writefile("XenonAutoPres3ServerBlocker.json", game:GetService('HttpService'):JSONEncode(AllIDs))
					task.wait()


					SendWebhook({
						Title = "YBA Auto Prestige - Server Hop",
						Description = string.format(
							"%s teleported to server:\n\n• Server ID: `%s`\n• JobId: `%s`\n• Players: %d/%d\n\nJoin script:\n```lua\nTeleportService:TeleportToPlaceInstance(%d, '%s')\n```",
							LocalPlayer.Name,
							ID,
							game.JobId,
							v.playing,
							v.maxPlayers,
							PlaceID,
							ID
						),
					})
					game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceID, ID, game.Players.LocalPlayer)
				end)
				task.wait(4)
			end
		end
	end
end

local function Teleport()
	while task.wait() do
		pcall(function()
			if getgenv().lessPing then
				game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)

				game:GetService("TeleportService").TeleportInitFailed:Connect(function()
					SendWebhook({
						Description = "YBA Teleport Attempt",
					})
					game:GetService("TeleportService"):Teleport(2809202155, game:GetService("Players").LocalPlayer)
				end)

				repeat task.wait() until game.JobId ~= game.JobId
			end

			TPReturner()
			if foundAnything ~= "" then
				TPReturner()
			end
		end)
	end
end

part = Instance.new("Part")
part.Parent = workspace
part.Anchored = true
part.Size = Vector3.new(25,1,25)
part.Position = Vector3.new(500, 2000, 500)

--// Obtaining Stand/Farming items //--
local function findItem(itemName)
	local ItemsDict = {
		["Position"] = {},
		["ProximityPrompt"] = {},
		["Items"] = {}
	}

	for _,item in pairs(game:GetService("Workspace")["Item_Spawns"].Items:GetChildren()) do
		if item:FindFirstChild("MeshPart") and item.ProximityPrompt.ObjectText == itemName then
			if item.ProximityPrompt.MaxActivationDistance == 8 then
				table.insert(ItemsDict["Items"], item.ProximityPrompt.ObjectText)
				table.insert(ItemsDict["ProximityPrompt"], item.ProximityPrompt)
				table.insert(ItemsDict["Position"], item.MeshPart.CFrame)
			else
				print("FAKE?")
			end
		end
	end
	return ItemsDict
end

--count amount of items for checking if full of item
local function countItems(itemName)
	local itemAmount = 0

	for _,item in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
		if item.Name == itemName then
			itemAmount = itemAmount + 1;
		end
	end

	print(itemAmount)
	return itemAmount
end

--uses item, use amount to specify what worthiness
local function useItem(aItem, amount)
	task.wait()
	local item = LocalPlayer.Backpack:WaitForChild(aItem, 5)

	if not item then
		Teleport()
	end

	task.wait(0.2)
	if amount then
		LocalPlayer.Character.Humanoid:EquipTool(item)
		LocalPlayer.Character:WaitForChild("RemoteFunction"):InvokeServer("LearnSkill",{["Skill"] = "Worthiness ".. amount,["SkillTreeType"] = "Character"})
		repeat item:Activate() task.wait() until LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
		task.wait(0.2)
		firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
		task.wait(0.2)
		firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.Options:WaitForChild("Option1").TextButton.MouseButton1Click)
		task.wait(0.2)
		firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
		task.wait(0.2)
		repeat task.wait() until LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.DialogueFrame.Frame.Line001.Container.Group001.Text == "You"
		task.wait(0.2)
		firesignal(LocalPlayer.PlayerGui:WaitForChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
		task.wait(0.2)
	end
end

--main function (entrypoint) of standfarm
local function attemptStandFarm()
	-- Check if LocalPlayer and Character are valid to avoid accessing undefined properties
	if not LocalPlayer or not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
		print("ERROR: LocalPlayer or Character is invalid.")
		return
	end

	-- Teleport the player to the designated position
	LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(500, 2010, 500)

	-- Check if the player has a valid stand (not "None")
	if LocalPlayer.PlayerStats and LocalPlayer.PlayerStats.Stand and LocalPlayer.PlayerStats.Stand.Value == "None" then
		print("DEBUG CHECK, USING MYSTERIOUS ARROW")
		useItem("Mysterious Arrow", "II")

		-- Wait until the player gets a stand (not "None")
		repeat task.wait(0.5) until LocalPlayer.PlayerStats.Stand.Value ~= "None"

		-- Check if standList exists and contains the player's stand
		if not getgenv().standList or not getgenv().standList[LocalPlayer.PlayerStats.Stand.Value] then
			print("DEBUG CHECK, USING ROKAKAKA")
			useItem("Rokakaka", "II")
		elseif getgenv().standList[LocalPlayer.PlayerStats.Stand.Value] then
			SendWebhook({
				Title = "YBA Auto Prestige You got" .. LocalPlayer.PlayerStats.Stand.Value,
				Description = "You got the Stand: " .. LocalPlayer.PlayerStats.Stand.Value,
			})

			dontTPOnDeath = true
			Teleport()
		end

		-- If the player already has a stand, check if it's valid
	elseif LocalPlayer.PlayerStats and LocalPlayer.PlayerStats.Stand and LocalPlayer.PlayerStats.Stand.Value ~= "None" then
		if not getgenv().standList or not getgenv().standList[LocalPlayer.PlayerStats.Stand.Value] then

			SendWebhook({
				Title = "YBA Auto Prestige Roka Attempt",
				Description = "Rokaing Stand " .. LocalPlayer.PlayerStats.Stand.Value,
			})

			print("DEBUG CHECK, USING ROKAKAKA TO CLEAR STAND")
			useItem("Rokakaka", "II")
		end
	end
end



--teleport not to get caught
local function getitem(item, itemIndex)
	local gotItem = false
	local timeout = getgenv().waitUntilCollect + 5

	if Character:FindFirstChild("SummonedStand") then
		if Character:FindFirstChild("SummonedStand").Value then
			RemoteFunction:InvokeServer("ToggleStand", "Toggle")
		end
	end

	LocalPlayer.Backpack.ChildAdded:Connect(function()
		gotItem = true
	end)

	task.spawn(function()
		while not gotItem do
			task.wait()
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = item["Position"][itemIndex] - Vector3.new(0,10,0)
		end
	end)

	task.wait(getgenv().waitUntilCollect)

	task.spawn(function()
		fireproximityprompt(item["ProximityPrompt"][itemIndex])

		local screenGui = LocalPlayer.PlayerGui:WaitForChild("ScreenGui",5)

		if not screenGui then
			return
		end

		local screenGuiPart = screenGui:WaitForChild("Part")
		for _, button in pairs(screenGuiPart:GetDescendants()) do
			if button:FindFirstChild("Part") then
				if button:IsA("ImageButton") and button:WaitForChild("Part").TextColor3 == Color3.new(0, 1, 0) then
					repeat
						firesignal(button.MouseEnter)
						firesignal(button.MouseButton1Up)
						firesignal(button.MouseButton1Click)
						firesignal(button.Activated)
						task.wait()
					until not LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
				end
			end
		end
	end)

	task.spawn(function()
		for i=timeout, 1, -1 do
			task.wait(1)
		end

		if not gotItem then
			gotItem = true
			return
		end
	end)


	while not gotItem do
		task.wait()
	end
end

--farm item with said name and amount
local function farmItem(itemName, amount)
	local items = findItem(itemName)
	local amountFirst = countItems(itemName) == amount

	for itemIndex, _ in pairs(items["Position"]) do
		if countItems(itemName) == amount or amountFirst then
			print("SUCCESSFULLY BROKE")
			break
		else
			getitem(items, itemIndex)
		end
	end

	return true
end

--// End Dialogue Func //--
local function endDialogue(NPC, Dialogue, Option)
	local dialogueToEnd = {
		["NPC"] = NPC,
		["Dialogue"] = Dialogue,
		["Option"] = Option
	}
	RemoteEvent:FireServer("EndDialogue", dialogueToEnd)
end

--// End Storyline Dialogue Func //--
local function storyDialogue()
	local Quest =
		{
			["Storyline"] = {"#1", "#1", "#1", "#2", "#3", "#3", "#3", "#4", "#5", "#6", "#7", "#8", "#9", "#10", "#11", "#11", "#12", "#14"},
			["Dialogue"] = {"Dialogue2", "Dialogue6", "Dialogue6", "Dialogue3", "Dialogue3", "Dialogue3", "Dialogue6", "Dialogue3", "Dialogue5", "Dialogue5", "Dialogue5", "Dialogue4", "Dialogue7", "Dialogue6", "Dialogue8", "Dialogue11", "Dialogue3", "Dialogue2"}
		}

	for counter = 1, 18, 1 do
		RemoteEvent:FireServer("EndDialogue", {["NPC"] = "Storyline".. " " .. Quest["Storyline"][counter],["Dialogue"] = Quest["Dialogue"][counter],["Option"] = "Option1"})
	end
end

local function killNPC(npcName, playerDistance, dontDestroyOnKill, extraParameters)
	print("DEBUG CHECK 1", npcName, playerDistance, dontDestroyOnKill, extraParameters)

	local NPC = workspace.Living:WaitForChild(npcName,getgenv().NPCTimeOut)
	local beingTargeted = true
	local doneKilled = false
	local deadCheck

	if not NPC then
		Teleport()
	end

	local function setStandMorphPosition()
		pcall(function()
			if LocalPlayer.PlayerStats.Stand.Value == "None" then
				HRP.CFrame = NPC.HumanoidRootPart.CFrame - Vector3.new(0, 5, 0)
				return
			end

			if not Character:FindFirstChild("SummonedStand").Value or not Character:FindFirstChild("StandMorph") then
				RemoteFunction:InvokeServer("ToggleStand", "Toggle")
				return
			end

			Character.StandMorph.PrimaryPart.CFrame = NPC.HumanoidRootPart.CFrame + NPC.HumanoidRootPart.CFrame.lookVector * -1.1
			HRP.CFrame = Character.StandMorph.PrimaryPart.CFrame + Character.StandMorph.PrimaryPart.CFrame.lookVector - Vector3.new(0, playerDistance, 0)

			if not Character:FindFirstChild("FocusCam") then
				local FocusCam = Instance.new("ObjectValue", Character)
				FocusCam.Name = "FocusCam"
				FocusCam.Value = Character.StandMorph.PrimaryPart
			end

			if Character:FindFirstChild("FocusCam") and Character.FocusCam.Value ~= Character.StandMorph.PrimaryPart then
				Character.FocusCam.Value = Character.StandMorph.PrimaryPart
			end
		end)
	end

	local function HamonCharge()
		if not Character:FindFirstChild("Hamon") then
			return
		end

		if Character.Hamon.Value <= getgenv().HamonCharge then
			RemoteFunction:InvokeServer("AssignSkillKey", {["Type"] = "Spec",["Key"] = "Enum.KeyCode.L",["Skill"] = "Hamon Breathing"})
			Character.RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.L})
		end
	end

	local function BlockBreaker()
		if not NPC or NPC.Parent == nil then
			return
		end

		if game:GetService("CollectionService"):HasTag(NPC, "Blocking") then
			RemoteEvent:FireServer("InputBegan", {["Input"] = Enum.KeyCode.R})
		elseif NPC.Humanoid.Health <= 1 then
			task.spawn(function()
				task.wait(5)
				if NPC then
					RemoteFunction:InvokeServer("Attack", "m1")
				end
			end)
		elseif NPC.Humanoid.Health >= 1 then
			RemoteFunction:InvokeServer("Attack", "m1")
		end
	end


	deadCheck = LocalPlayer.PlayerGui.HUD.Main.DropMoney.Money.ChildAdded:Connect(function(child)
		local number = tonumber(string.match(child.Name,"%d+"))

		if number and NPC then
			doneKilled = true

			deadCheck:Disconnect()

			if not dontDestroyOnKill then
				NPC:Destroy()
			end
		end
	end)

	while beingTargeted do
		task.wait()
		if not NPC:FindFirstChild("HumanoidRootPart") then
			deadCheck:Disconnect()
			beingTargeted = false
		end

		if extraParameters then
			extraParameters()
		end

		task.spawn(setStandMorphPosition)
		task.spawn(HamonCharge)
		task.spawn(BlockBreaker)
	end


	print(doneKilled)
	return doneKilled
end 

local function checkPrestige(level, prestige)
	if (level == 35 and prestige == 0) or (level == 40 and prestige == 1) or (level == 45 and prestige == 2) then
		local newPrestige = prestige + 1

		SendWebhook({
			Title = "YBA Auto Prestige Prestige Attempt",
			Description = "@everyone " .. LocalPlayer.Name .. " Prestiged to Prestige " .. newPrestige,
		})
		endDialogue("Prestige", "Dialogue2", "Option1")
		return true
	else
		return false
	end
end

local function allocateSkills() --this should allocate the destructive shit stuff
	task.spawn(function()
		RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power V",["SkillTreeType"] = "Stand"})
		RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power IV",["SkillTreeType"] = "Stand"})
		RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power III",["SkillTreeType"] = "Stand"})
		RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power II",["SkillTreeType"] = "Stand"})
		RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Destructive Power I",["SkillTreeType"] = "Stand"})

		if LocalPlayer.PlayerStats.Spec.Value == "Hamon (William Zeppeli)" then
			RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Hamon Punch V",["SkillTreeType"] = "Spec"})
			RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Lung Capacity V", ["SkillTreeType"] = "Spec"})
			RemoteFunction:InvokeServer("LearnSkill", {["Skill"] = "Breathing Technique V",["SkillTreeType"] = "Spec"})
		end
	end)
end

local function autoStory()
	local questPanel = LocalPlayer.PlayerGui.HUD.Main.Frames.Quest.Quests
	local repeatCount = 0
	allocateSkills()

	if LocalPlayer.PlayerStats.Level.Value >= 25 and LocalPlayer.PlayerStats.Prestige.Value >= 1 and LocalPlayer.Backpack:FindFirstChild("Requiem Arrow") and (LocalPlayer.PlayerStats.Stand.Value == "King Crimson" or LocalPlayer.PlayerStats.Stand.Value == "Star Platinum") then
		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(500, 2010, 500)
		local oldStand = LocalPlayer.PlayerStats.Stand.Value
		useItem("Requiem Arrow", "V")
		repeat task.wait() until LocalPlayer.PlayerStats.Stand.Value ~= oldStand
		autoStory()
	end


	if LocalPlayer.PlayerStats.Spec.Value == "None" and LocalPlayer.PlayerStats.Level.Value >= 25 then
		local function collectAndSell(toolName, amount)
			farmItem(toolName, amount)
			LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(toolName))
			endDialogue("Merchant", "Dialogue5", "Option2")
		end

		if not LocalPlayer.Backpack:FindFirstChild("Zeppeli's Hat") then

			task.wait(60)
			farmItem("Zeppeli's Hat", 1)
		end

		if LocalPlayer.PlayerStats.Money.Value <= 10000 then
			print("WHERE DID THE MONEY GO FOR HAMON?")
			collectAndSell("Mysterious Arrow", 25)
			collectAndSell("Rokakaka", 25)
			collectAndSell("Diamond", 10)
			collectAndSell("Steel Ball", 10)
			collectAndSell("Quinton's Glove", 10)
			collectAndSell("Pure Rokakaka", 10)
			collectAndSell("Ribcage Of The Saint's Corpse", 10)
			collectAndSell("Ancient Scroll", 10)
			collectAndSell("Clackers", 10)
			collectAndSell("Caesar's headband", 10)
		end

		if LocalPlayer.Backpack:FindFirstChild("Zeppeli's Hat") then

			LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild("Zeppeli's Hat"))
			game.Players.LocalPlayer.Character.RemoteEvent:FireServer("PromptTriggered", game.ReplicatedStorage.NewDialogue:FindFirstChild("Lisa Lisa"))
			repeat
				game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
				task.wait(0.05)
			until game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui")
			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui") then
				repeat
					game:GetService("VirtualInputManager"):SendMouseButtonEvent(0,8,0, true, nil, 1)
					task.wait(0.05)
				until game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
			end
			firesignal(game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options.Option1.TextButton.MouseButton1Click)
			repeat
				firesignal(game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
				task.wait(0.05)
			until game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1") then
				firesignal(game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options.Option1.TextButton.MouseButton1Click)
			end
			repeat
				firesignal(game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.ClickContinue.MouseButton1Click)
				task.wait(0.05)
			until game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1")
			if game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options:FindFirstChild("Option1") then
				firesignal(game.Players.LocalPlayer.PlayerGui:FindFirstChild("DialogueGui").Frame.Options.Option1.TextButton.MouseButton1Click)
			end
			task.wait(10)
			autoStory()
		else
			Teleport()
		end
	end

	while #questPanel:GetChildren() < 2 and repeatCount < 1000 do
		if not questPanel:FindFirstChild("Take down 3 vampires") then

			lastTick = tick()
			endDialogue("William Zeppeli", "Dialogue4", "Option1")
		end

		LocalPlayer.QuestsRemoteFunction:InvokeServer({[1] = "ReturnData"})
		storyDialogue()
		task.wait(0.01)
		repeatCount = repeatCount + 1
	end


	if repeatCount >= 1000 then
		Teleport()
	end

	if questPanel:FindFirstChild("Help Giorno by Defeating Security Guards") then
		print('SECURITY GUARD')

		if killNPC("Security Guard", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif not getgenv().standList[LocalPlayer.PlayerStats.Stand.Value] and LocalPlayer.PlayerStats.Level.Value >= 3 and dontTPOnDeath then
		print('NO STAND?')
		task.wait(5)

		farmItem("Rokakaka", 25)
		farmItem("Mysterious Arrow", 25)
		farmItem("Zeppeli's Hat", 1)

		if countItems("Mysterious Arrow") >= 25 and countItems("Mysterious Arrow") >= 25 then
			print("MAX ARROW AND ROKA, GOT")
			print("ATTEMPTING TO STAND FARM")
			dontTPOnDeath = false
			attemptStandFarm()
		else
			Teleport()
		end

	elseif questPanel:FindFirstChild("Defeat Leaky Eye Luca") and getgenv().standList[LocalPlayer.PlayerStats.Stand.Value] then
		print("LEAKY EYE LUCA")

		if killNPC("Leaky Eye Luca", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif questPanel:FindFirstChild("Defeat Bucciarati") then
		print("BUCCIARATI")


		if killNPC("Bucciarati", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif questPanel:FindFirstChild("Collect $5,000 To Cover For Popo's Real Fortune") then
		print("WAH WAH I DONT HAVE ENOUGH MONEY")
		if LocalPlayer.PlayerStats.Money.Value < 5000 then

			local function collectAndSell(toolName, amount)
				if countItems(toolName) <= amount then
					farmItem(toolName, amount)
					Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(toolName))
					endDialogue("Merchant", "Dialogue5", "Option2")
					storyDialogue()
					autoStory()
				end

				if LocalPlayer.PlayerStats.Money.Value < 5000 then
					storyDialogue()
					autoStory()
				end
			end
			task.wait(10)
			collectAndSell("Mysterious Arrow", 25)
			collectAndSell("Rokakaka", 25)
			collectAndSell("Diamond", 10)
			collectAndSell("Steel Ball", 10)
			collectAndSell("Quinton's Glove", 10)
			collectAndSell("Pure Rokakaka", 10)
			collectAndSell("Ribcage Of The Saint's Corpse", 10)
			collectAndSell("Ancient Scroll", 10)
			collectAndSell("Clackers", 10)
			collectAndSell("Caesar's headband", 10)
		end
		autoStory()

	elseif questPanel:FindFirstChild("Defeat Fugo And His Purple Haze") then
		print("FUGO")

		if killNPC("Fugo", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif questPanel:FindFirstChild("Defeat Pesci") then
		print("PESCI")

		if killNPC("Pesci", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif questPanel:FindFirstChild("Defeat Ghiaccio") then
		print("GHIACCIO")
		if killNPC("Ghiaccio", 15) then
			task.wait(1)
			storyDialogue()
			autoStory()
		else
			autoStory()
		end

	elseif questPanel:FindFirstChild("Defeat Diavolo") then
		killNPC("Diavolo", 15)
		endDialogue("Storyline #14", "Dialogue7", "Option1")
		if Character:WaitForChild("Requiem Arrow", 5) then
			LocalPlayer.Character.Humanoid.Health = 0
			Teleport()
		else
			autoStory()
		end
	elseif LocalPlayer.PlayerStats.Level.Value == 50 then
    if Character:FindFirstChild("FocusCam") then
        Character.FocusCam:Destroy()
    end

    local storyLineCosmetics = {
        ["Narancia's Hair"] = true,
        ["Trish's Hair"] = true,
        ["Mista's Hat"] = true,
        ["Giorno's Hair"] = true,
        ["Fugo's Hair"] = true,
        ["Abbacchio's Hair"] = true,
        ["Diavolo's Hair"] = true
    }

    local scrollingFrame = LocalPlayer.PlayerGui.HUD.Main.Frames.Cosmetics.Frame.ScrollingFrame

    for _, v in ipairs(scrollingFrame:GetChildren()) do
        if storyLineCosmetics[v.Name] then
            v:Destroy()
        else
            local quantity = v:GetAttribute("Quantity")
            if quantity and typeof(quantity) == "number" then
                for i = 1, quantity do
                    local args = {
                        "RemoveCosmetic",
                        tostring(v)
                    }
                    Character:WaitForChild("RemoteEvent"):FireServer(unpack(args))
                end
            end
        end
    end

    pcall(function()
        delfile("AutoPres3_"..LocalPlayer.Name..".txt")
    end)
	elseif questPanel:FindFirstChild("Take down 3 vampires") and LocalPlayer.PlayerStats.Spec.Value ~= "None" and LocalPlayer.PlayerStats.Level.Value >= 25 and LocalPlayer.PlayerStats.Level.Value ~= 50 then
		getgenv().HamonCharge = 10
		local function vampire()
			LocalPlayer.Character.PrimaryPart.CFrame = workspace.Living:FindFirstChild("Vampire").HumanoidRootPart.CFrame - Vector3.new(0, 15, 0)
			if not questPanel:FindFirstChild("Take down 3 vampires") then
				if (tick() - lastTick) >= 5 then

					lastTick = tick()
				end
				endDialogue("William Zeppeli", "Dialogue4", "Option1")
			end
		end

		killNPC("Vampire", 15, false, vampire)
		autoStory()

	elseif LocalPlayer.PlayerStats.Level.Value == 50 then
		if Character:FindFirstChild("FocusCam") then
			Character.FocusCam:Destroy()
			pcall(function()
				delfile("AutoPres3_"..LocalPlayer.Name..".txt")
			end)
		end
	end
end

task.spawn(function()
	while task.wait(3) do
		if checkPrestige(LocalPlayer.PlayerStats.Level.Value, LocalPlayer.PlayerStats.Prestige.Value) then
			print("Prestiged")
			Teleport()
		elseif LocalPlayer.PlayerStats.Level.Value == 50 then
			if not Character:FindFirstChild("FocusCam") then
				Character.FocusCam:Destroy()
				break
			end
		else
			print("not able to prestige yet")
		end
	end
end)

game.Workspace.Living.ChildAdded:Connect(function(character)
	if character.Name == LocalPlayer.Name then
		if LocalPlayer.PlayerStats.Level.Value == 50 then
			print("didnt reconnect")
		else
			if dontTPOnDeath then
				Teleport()
			else
				attemptStandFarm()
			end
		end
	end
end)

LocalPlayer.PlayerStats.Level:GetPropertyChangedSignal("Value"):Connect(function()

end)

LocalPlayer.CharacterAdded:Connect(function()
	task.wait(1)
	for _, child in pairs(LocalPlayer.Character:GetDescendants()) do
		if child:IsA("BasePart") and child.CanCollide == true then
			child.CanCollide = false
		end
	end
end)

hookfunction(workspace.Raycast, function() -- noclip bypass
	return
end)

autoStory()
