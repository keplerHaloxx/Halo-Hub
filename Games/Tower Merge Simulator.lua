-- * / Library Init \\--
local Rayfield, Window, CreateWindow, Notify, GetExploit = loadstring(game:HttpGet("https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Init.lua"))()
-- https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Init.lua

-- ! // Destory Old Library \\--
-- Rayfield:Destroy()
-- for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
-- 	if v.Name == "Rayfield-Old" then
-- 		v:Destroy()
-- 		print("Destoryed Rayfield-Old")
-- 	end
-- end

-- * // Tabs \\--
local Tabs = {
    ["Main"] = Window:CreateTab("Main", 4483362458),
	["Upgrades"] = Window:CreateTab("Upgrades", 4483362458),
	["Eggs"] = Window:CreateTab("Eggs", 4483362458),
	["Rebirths"] = Window:CreateTab("Rebirths", 4483362458),
}

local Funcs = {}
Funcs.GetPlot = function()
	local Plot
	local plr = game:GetService("Players").LocalPlayer
	for _, A_1 in next, Workspace:WaitForChild("Plots"):GetChildren() do
		if A_1:GetAttribute("owner") == plr.Name then
			Plot = A_1
			break
		end
	end
	return Plot
end

if Funcs.GetPlot() == nil then
	Notify("Waiting For Plot...", 2.5, {Ok = {Name = "Ok", Callback = function()end}})
	repeat task.wait(1) until Funcs.GetPlot() ~= nil
	Notify("Plot Found!", 2.5, {Ok = {Name = "Ok", Callback = function()end}})
end


-- * // Services \\--
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

-- * // Variables \\--
local Player = Players.LocalPlayer
local RemoteFunction = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Events"):WaitForChild("RemoteFunction")
local RemoteEvent = ReplicatedStorage.Assets.Events:WaitForChild("RemoteEvent")
local Obby_Finish = Workspace:WaitForChild("ObbyFinish")
local Plot = Funcs.GetPlot()
local Spaces = Plot:WaitForChild("Spaces")

local Executor = GetExploit()

Funcs.MergeTower = function()
	for _, A_1 in next, Spaces:GetChildren() do
		local Tower_1 = A_1:FindFirstChildOfClass("Model")
		if Tower_1 then
			local Level = Tower_1:GetAttribute("tower")
			for _, A_2 in next, Spaces:GetChildren() do
				local Tower_2 = A_2:FindFirstChildOfClass("Model")
				if Tower_2 and Tower_2 ~= Tower_1 and Tower_2:GetAttribute("tower") == Level then
					RemoteFunction:InvokeServer("combine tower", Tower_1, Tower_2)
					break
				end
			end
		end
	end
end

Funcs.Upgrade = function(val)	
	if val == "Spawn Speed" then
		ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("upgrade", "spawn_speed")
	elseif val == "Spawn Level" then
		ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("upgrade", "spawn_level")
	elseif val == "Shoot Speed" then
		ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("upgrade", "shoot_speed")
	elseif val == "Click Power" then
		ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("upgrade", "click_power")
	end
end


-- * // Genv's \\--
getgenv().AutoClick = false
getgenv().AutoObby = false
getgenv().AutoMerge = false
getgenv().AutoRebirth = false

getgenv().AutoUpgrade_SpawnSpeed = false
getgenv().AutoUpgrade_SpawnLevel = false
getgenv().AutoUpgrade_ShootSpeed = false
getgenv().AutoUpgrade_ClickPower = false

getgenv().AutoBuyEgg1 = false
getgenv().AutoBuyEgg2 = false
getgenv().AutoBuyEgg3 = false
getgenv().AutoBuyVoidEgg = false

getgenv().GemsAutoMerge = false
getgenv().GemsCashMulti = false
getgenv().GemsTowerDamage = false
getgenv().GemsMulti = false


-- * // ( Main ) Tab \\--
Tabs["Main"]:CreateParagraph({Title = "READ ME", Content = "If a keybind is set to Backspace then it's turned off."})

-- ! Auto Merge
Tabs["Main"]:CreateSection("Auto Merge")
local AutoMergeToggle = Tabs["Main"]:CreateToggle({
	Name = "🕑 Auto Merge",
	CurrentValue = getgenv().AutoMerge,
	Flag = "AutoMergeToggle",
	Callback = function(Value)
		getgenv().AutoMerge = Value
	end,
})

local AutoMergeBind = Tabs["Main"]:CreateKeybind({
	Name = "🕑 Auto Merge Bind",
	CurrentKeybind = "Backspace",
	HoldToInteract = false,
	Flag = "AutoMergeBind",
	Callback = function()end,
})

AutoMergeBind.Callback = function()
	if AutoMergeBind.CurrentKeybind ~= "Backspace" then
		getgenv().AutoMerge = not getgenv().AutoMerge
		AutoMergeBind:Set(getgenv().AutoMerge)
	end
end

task.spawn(function()
	while true and task.wait(.1) do
		if getgenv().AutoMerge == true then
			Funcs.MergeTower()
		end
	end
end)

-- ! Auto Click
Tabs["Main"]:CreateSection("Auto Click")
local AutoClickToggle = Tabs["Main"]:CreateToggle({
	Name = "🕑 Auto Click",
	CurrentValue = getgenv().AutoClick,
	Flag = "AutoClickToggle",
	Callback = function(Value)
		getgenv().AutoClick = Value
	end,
})

local AutoClickBind = Tabs["Main"]:CreateKeybind({
	Name = "🕑 Auto Click Bind",
	CurrentKeybind = "Backspace",
	HoldToInteract = false,
	Flag = "AutoClickBind",
	Callback = function()end,
})

AutoClickBind.Callback = function()
	if AutoClickBind.CurrentKeybind ~= "Backspace" then
		getgenv().AutoClick = not getgenv().AutoClick
		AutoClickToggle:Set(getgenv().AutoClick)
	end
end

task.spawn(function()
	while true and task.wait() do
		if getgenv().AutoClick == true then
			RemoteEvent:FireServer("click")
		end
	end
end)


-- ! Auto Obby
Tabs["Main"]:CreateSection("Auto Complete Obby")

local CooldownLabel = Tabs["Main"]:CreateLabel("Cooldown: Ready!")
task.spawn(function()
	while true and task.wait() do
		if string.match(Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text, "Unlocks in") then
			if Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text:split(" ")[4] ~= nil and Workspace.ObbyWalls.Part.SurfaceGui.Enabled == true then
				CooldownLabel:Set("Cooldown: " .. tostring(Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text:split(" ")[3]) .. " " .. tostring(Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text:split(" ")[4]))
			elseif Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text:split(" ")[4] == nil and Workspace.ObbyWalls.Part.SurfaceGui.Enabled == true then
				CooldownLabel:Set("Cooldown: " .. tostring(Workspace.ObbyWalls.Part.SurfaceGui.TextLabel.Text:split(" ")[3]))
			elseif Workspace.ObbyWalls.Part.SurfaceGui.Enabled == false then
				CooldownLabel:Set("Cooldown: Ready!")
			else
				CooldownLabel:Set("Cooldown: Unknown")
			end
		else
			CooldownLabel:Set("Cooldown: Ready!")
		end
	end
end)

local AutoObbyToggle = Tabs["Main"]:CreateToggle({
	Name = "🕑 Auto Obby",
	CurrentValue = getgenv().AutoObby,
	Flag = "AutoObbyToggle",
	Callback = function(Value)
		getgenv().AutoObby = Value
	end,
})

local AutoObbyBind = Tabs["Main"]:CreateKeybind({
	Name = "🕑 Auto Obby Bind",
	CurrentKeybind = "Backspace",
	HoldToInteract = false,
	Flag = "AutoObbyBind",
	Callback = function()end,
})

AutoObbyBind.Callback = function()
	if AutoObbyBind.CurrentKeybind ~= "Backspace" then
		getgenv().AutoObby = not getgenv().AutoObby
		AutoObbyBind:Set(getgenv().AutoClick)
	end
end

task.spawn(function()
	while true and task.wait(1) do
		if getgenv().AutoObby == true then
			local Primary = Player.Character and Player.Character.PrimaryPart
			if Primary then
				firetouchinterest(Primary, Obby_Finish, 0)
				firetouchinterest(Primary, Obby_Finish, 1)
			end
		end
	end
end)

-- * // ( Upgrades ) Tab \\--

local function AddStuff(Tab, DisplayName, Name, Genv, CreateButton, ButtonName, Callback)

	if CreateButton == true then
		Tabs[Tab]:CreateButton({
			Name = ButtonName or DisplayName,
			Interact = "",
			Callback = function()
				Callback()
			end,
		})
	end
	local Toggle = Tabs[Tab]:CreateToggle({
		Name = tostring(DisplayName),
		CurrentValue = getgenv()[Genv],
		Flag = tostring(Name .. "Toggle"),
		Callback = function(Value)
			getgenv()[Genv] = Value
		end,
	})
	
	local Bind = Tabs[Tab]:CreateKeybind({
		Name = DisplayName .. " Bind",
		CurrentKeybind = "Backspace",
		HoldToInteract = false,
		Flag = tostring(Name .. "Bind"),
		Callback = function()end,
	})
	
	Bind.Callback = function()
		if Bind.CurrentKeybind ~= "Backspace" then
			getgenv()[Genv] = not getgenv()[Genv]
			Toggle:Set(getgenv()[Genv])
		end
	end
	
	task.spawn(function()
		while true and task.wait() do
			if getgenv()[Genv] == true then
				Callback()
			end
		end
	end)

	return Toggle, Bind
end

-- ? Spawn Speed
Tabs["Upgrades"]:CreateSection("Spawn Speed")

local SpawnSpeedAmount = Tabs["Upgrades"]:CreateLabel("Amount Needed: ???")
AddStuff("Upgrades", "🕑 Auto Upgrade SpawnSpeed", "AutoUpgradeSpawnSpeed", "AutoUpgrade_SpawnSpeed", true, "Upgrade SpawnSpeed", function()
	Funcs.Upgrade("Spawn Speed")
end)

-- ? Spawn Level
Tabs["Upgrades"]:CreateSection("Spawn Level")

local SpawnLevelAmount = Tabs["Upgrades"]:CreateLabel("Amount Needed: ???")
AddStuff("Upgrades", "🕑 Auto Upgrade SpawnLevel", "AutoUpgradeSpawnLevel", "AutoUpgrade_SpawnLevel", true, "Upgrade SpawnLevel", function()
	Funcs.Upgrade("Spawn Level")
end)

-- ? Shoot Speed
Tabs["Upgrades"]:CreateSection("Shoot Speed")

local ShootSpeedAmount = Tabs["Upgrades"]:CreateLabel("Amount Needed: ???")
AddStuff("Upgrades", "🕑 Auto Upgrade ShootSpeed", "AutoUpgradeShootSpeed", "AutoUpgrade_ShootSpeed", true, "Upgrade ShootSpeed", function()
	Funcs.Upgrade("Shoot Speed")
end)

-- ? Click Power
Tabs["Upgrades"]:CreateSection("Click Power")

local ClickPowerAmount = Tabs["Upgrades"]:CreateLabel("Amount Needed: ???")
AddStuff("Upgrades", "🕑 Auto Upgrade ClickPower", "AutoUpgradeClickPower", "AutoUpgrade_ClickPower", true, "Upgrade ClickPower", function()
	Funcs.Upgrade("Click Power")
end)

-- ? Cash Labels
task.spawn(function()
	local CashPlace = Plot.CashBoard.SurfaceGui.Frame

	while true and task.wait() do
		SpawnSpeedAmount:Set("Amount Needed: " .. CashPlace.spawn_speed.Upgrade.Cost.Cost.Text)
		SpawnLevelAmount:Set("Amount Needed: " .. CashPlace.spawn_level.Upgrade.Cost.Cost.Text)
		ShootSpeedAmount:Set("Amount Needed: " .. CashPlace.shoot_speed.Upgrade.Cost.Cost.Text)
		ClickPowerAmount:Set("Amount Needed: " .. CashPlace.click_power.Upgrade.Cost.Cost.Text)
	end
end)


-- * // ( Eggs ) Tab \\--

-- ? Get Eggs Amount
local eggsAmount = {}
for i,v in pairs (game:GetService("ReplicatedStorage").Game.Eggs:GetChildren()) do
	local mods = require(v:FindFirstChildOfClass("ModuleScript"))
	local formatter = require(game:GetService("ReplicatedStorage").Assets.Modules.Functions.Format)

	if mods.currency == "Cash" then
		eggsAmount[v.Name] = formatter.Short(mods.cost)
	end
end

-- ? Egg 1
Tabs["Eggs"]:CreateSection("Egg 1")

Tabs["Eggs"]:CreateLabel("Amount Needed: " .. eggsAmount["Egg1"])
AddStuff("Eggs", "🕑 Auto Buy Egg1", "AutoBuyEgg1", "AutoBuyEgg1", true, "Buy Egg1", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("purchase egg", "Egg1", false)
end)

-- ? Egg 2
Tabs["Eggs"]:CreateSection("Egg 2")

Tabs["Eggs"]:CreateLabel("Amount Needed: " .. eggsAmount["Egg2"])
AddStuff("Eggs", "🕑 Auto Buy Egg2", "AutoBuyEgg2", "AutoBuyEgg2", true, "Single Buy", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("purchase egg", "Egg2", false)
end)


-- * // ( Rebirths ) Tab \\--

local playerStats = {}
playerStats["Cash"] = ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("Get Stats", Player)["Cash"]
playerStats["Rebirths"] = ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("Get Stats", Player)["Rebirth"]
playerStats["Gems"] = ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("Get Stats", Player)["Gems"]


Tabs["Rebirths"]:CreateSection("Rebirthing")
Tabs["Rebirths"]:CreateLabel("You have " .. playerStats["Rebirths"] .. " rebirths")
AddStuff("Rebirths", "🕑 Auto Rebirth", "AutoRebirth", "AutoRebirth", true, "Single Rebirth", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("rebirth")
end)

Tabs["Rebirths"]:CreateSection("Gem Shop")
Tabs["Rebirths"]:CreateLabel("You have " .. playerStats["Gems"] .. " gems")

-- ? Gems | Auto Merge
Tabs["Rebirths"]:CreateSection("Auto Merge")
Tabs["Rebirths"]:CreateLabel("Cost: " .. Plot.RebirthBoard.SurfaceGui.Frame.GemShop.Content.auto_merge.Cost.Cost.Cost.Text .. " gems")
AddStuff("Rebirths", "🕑 Auto Buy (Gems) Auto Merge", "GemsAutoMerge", "GemsAutoMerge", true, "Single Buy", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("rebirth")
end)

-- ? Gems | Cash Multiplier
Tabs["Rebirths"]:CreateSection("Cash Multiplier")
Tabs["Rebirths"]:CreateLabel("Cost: " .. Plot.RebirthBoard.SurfaceGui.Frame.GemShop.Content.cash_multiplier.Cost.Cost.Cost.Text .. " gems")
AddStuff("Rebirths", "🕑 Auto Buy (Gems) Cash Multiplier", "GemsCashMulti", "GemsCashMulti", true, "Single Buy", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("rebirth")
end)

-- ? Gems | Tower Damage
Tabs["Rebirths"]:CreateSection("Tower Damage")
Tabs["Rebirths"]:CreateLabel("Cost: " .. Plot.RebirthBoard.SurfaceGui.Frame.GemShop.Content.tower_damage.Cost.Cost.Cost.Text .. " gems")
AddStuff("Rebirths", "🕑 Auto Buy (Gems) Tower Damage", "GemsTowerDamage", "GemsTowerDamage", true, "Single Buy", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("rebirth")
end)

-- ? Gems | Gem Multiplier
Tabs["Rebirths"]:CreateSection("Gem Multiplier")
Tabs["Rebirths"]:CreateLabel("Cost: " .. Plot.RebirthBoard.SurfaceGui.Frame.GemShop.Content.gem_multiplier.Cost.Cost.Cost.Text .. " gems")
AddStuff("Rebirths", "🕑 Auto Buy (Gems) Gem Multiplier", "GemsMulti", "GemsMulti", true, "Single Buy", function()
	ReplicatedStorage.Assets.Events.RemoteFunction:InvokeServer("rebirth")
end)





Rayfield:LoadConfiguration()
