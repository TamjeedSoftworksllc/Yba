getgenv().waitUntilCollect = 0.2 --Change this if ur getting kicked a lot
getgenv().sortOrder = "Asc" --desc for less players, asc for more
getgenv().lessPing = false --turn this on if u want lower ping servers, cant guarantee you will see same people using script, and data error 1
getgenv().Webhook = "" 
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
--if not getrawmetatable or not getcallingscript or not hookfunction or not hookmetamethod or not getnamecallmethod or not newcclosure or not fireproximitypromt or not firesignal then
--	game:GetService("Players").LocalPlayer:Kick("Your exploit doesn't support the necessary functions")
--	return
--end
local WebhookMod = 	loadstring(game:HttpGet("https://raw.githubusercontent.com/TamjeedSoftworksllc/Yba/refs/heads/main/WebhookModule"))()

function SendWebhook(Info)
	if getgenv().Webhook then
		local embedData = {
			Title = Info.Title or "YBA Auto Lucky Arrow",
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
		print("no webhook")
	end
end


SendWebhook({
	Description = LocalPlayer.Name .. " Started YBA Lucky Arrow Autofarm"
})
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

local lastItemFoundTick = tick()

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

				lastItemFoundTick = tick() -- Reset timer if item exists
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
			itemAmount += 1;
		end
	end

	print(itemAmount)
	return itemAmount
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
local function collectAndSell(toolName, amount)
	farmItem(toolName, amount)
	LocalPlayer.Character.Humanoid:EquipTool(LocalPlayer.Backpack:FindFirstChild(toolName))
	endDialogue("Merchant", "Dialogue5", "Option2")
end
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

task.spawn(function()
	while true do
		for i,v in game.Players:GetPlayers() do 
			if v:IsInGroup(3194064) then
				SendWebhook({
					Description = "Player in game thats in YBA's group, Serverhopping",
				})
				Teleport()
			end
		end
			collectAndSell("Mysterious Arrow", 25)
			collectAndSell("Rokakaka", 25)
			collectAndSell("Stone Mask")
			collectAndSell("Zeppeli's Hat",10)
			collectAndSell("Dio's Diary",10)
			collectAndSell("Diamond", 10)
			collectAndSell("Steel Ball", 10)
			collectAndSell("Quinton's Glove", 10)
			collectAndSell("Pure Rokakaka", 10)
			collectAndSell("Ribcage Of The Saint's Corpse", 10)
			collectAndSell("Ancient Scroll", 10)
			collectAndSell("Clackers", 10)
			collectAndSell("Caesar's headband", 10)

		if tick() - lastItemFoundTick >= 10 then
			SendWebhook({
				Description = "No items found for 10s. Server hopping...",
			})
			Teleport()
		end

		task.wait(1)
	end
end)
