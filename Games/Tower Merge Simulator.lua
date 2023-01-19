-- * / Library Init \\--
local Rayfield, Window, CreateWindow, Notify, GetExploit, SetReExecuteLink = loadstring(game:HttpGet("https://pastebin.com/raw/Gy60XQyf"))()
-- https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Init.lua

-- ! // Destory Old Library \\--
-- Rayfield:Destroy()
-- for i,v in pairs(game:GetService("CoreGui"):GetChildren()) do
-- 	if v.Name == "Rayfield-Old" then
-- 		v:Destroy()
-- 		print("Destoryed Rayfield-Old")
-- 	end
-- end

SetReExecuteLink("https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Games/Tower%20Merge%20Simulator.lua")

-- * // Tabs \\--
local Tabs = {
    ["Main"] = Window:CreateTab("Main", 4483362458)
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

repeat task.wait(1)
	Notify("Waiting For Plot", 2.5, {Ok = {Name = "Ok", Callback = function()end}})
until Funcs.GetPlot() ~= nil


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


-- // Genv's \\--
getgenv().AutoClick = false
getgenv().AutoObby = false
getgenv().AutoMerge = false

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
	while true and task.wait(5) do
		if getgenv().AutoObby == true then
			local Primary = Player.Character and Player.Character.PrimaryPart
			if Primary then
				firetouchinterest(Primary, Obby_Finish, 0)
				firetouchinterest(Primary, Obby_Finish, 1)
			end
		end
	end
end)
