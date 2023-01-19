local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/UI-Interface/CustomFIeld/main/RayField.lua'))()
local Player = game:GetService("Players").LocalPlayer

local Window = Rayfield:CreateWindow({
	Name = "Halo Hub",
	LoadingTitle = "🎮 " .. game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name .. " 🎮",
	LoadingSubtitle = "By Haloxx",
	ConfigurationSaving = {
		Enabled = true,
		FolderName = "Halo Hub",
		FileName = game.PlaceId.. "-".. Player.Name
	}
})

repeat task.wait() until Window

local function Notify(Message, Duration, Buttons)
	Rayfield:Notify({
		Title = "🪴 Halo Hub",
		Content = Message,
		Duration = Duration or 5,
		Image = 4483362458,
		Actions = Buttons,
	})
end

local exLink
local function SetReExecuteLink(link)
    exLink = tostring(link)
end


local function GetExploit()
	return
		(secure_load and "Sentinel") or
		(is_sirhurt_closure and "Sirhurt") or
		(pebc_execute and "ProtoSmasher") or
		(KRNL_LOADED and "Krnl") or
		(WrapGlobal and "WeAreDevs") or
		(isvm and "Proxo") or
		(shadow_env and "Shadow") or
		(jit and "EasyExploits") or
		(getscriptenvs and "Calamari") or
		(unit and not syn and "Unit") or
		(OXYGEN_LOADED and "Oxygen U") or
		(IsElectron and "Electron") or
		(IS_COCO_LOADED and "Coco") or
		(IS_VIVA_LOADED and "Viva") or
		(syn and is_synapse_function and not is_sirhurt_closure and not pebc_execute and "Synapse") or
		("Other")
end

local function CreateWindow()
    task.delay(1.5, function()
        local Universal = Window:CreateTab("Universal", 4483362458)
        
        Universal:CreateSection("AFKing")

        Universal:CreateToggle({
            Name = "🚫 Anti-AFK",
            Info = "Prevents Roblox's anti-afk from kicking you.\n(Doesn't work for games with their own anti-afk)",
            CurrentValue = false,
            Flag = "Universal-AntiAFK",
            Callback = function(Value)	end,
        })

        local VirtualUser = game:GetService("VirtualUser")
        Player.Idled:Connect(function()
            if Rayfield.Flags["Universal-AntiAFK"].CurrentValue then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)

        local AutoRejoin = Universal:CreateToggle({
            Name = "🔁 Auto Rejoin",
            Info = "Doesn't completely load game until you tab in",
            CurrentValue = false,
            Flag = "Universal-AutoRejoin",
            Callback = function(Value)
                if Value then
                    repeat task.wait() until game.CoreGui:FindFirstChild('RobloxPromptGui')

                    local lp,po,ts = game:GetService('Players').LocalPlayer,game.CoreGui.RobloxPromptGui.promptOverlay,game:GetService('TeleportService')

                    po.ChildAdded:connect(function(a)
                        if Rayfield.Flags["Universal-AutoRejoin"].CurrentValue and a.Name == 'ErrorPrompt' then
                            while true do
                                ts:Teleport(game.PlaceId)
                                task.wait(2)
                            end
                        end
                    end)
                end
            end,
        })

        local queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
        local avail
        if queueteleport then
            avail = ""
        else
            avail = " (UNSUPPORTED EXECUTOR!)"
        end

        Universal:CreateToggle({
			Name = "📶 Auto Re-Execute" .. avail,
			CurrentValue = false,
			Flag = "Universal-AutoRe-Execute",
			Callback = function(Value)
				if Value then
					if queueteleport then
						queueteleport('loadstring(game:HttpGet("' .. exLink .. '"))()')
					end
				end
			end,
		})

        Universal:CreateSection("Safety")

        local GroupId = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Creator.CreatorTargetId

        Universal:CreateToggle({
            Name = "🚪 Leave Upon Staff Join",
            Info = "Kicks you if a player above the group role 1 joins/is in the server.",
            CurrentValue = false,
            Flag = "Universal-AutoLeave",
            Callback = function(Value)
                if Value then
                    for i,v in pairs(game.Players:GetPlayers()) do
                        pcall(function()
                            if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
                                AutoRejoin:Set(false)
                                Player:Kick("Detected Staff (Player above group rank 1)")
                            end
                        end)
                    end
                end
            end,
        })

        game:GetService("Players").PlayerAdded:Connect(function(v)
            if Rayfield.Flags["Universal-AutoLeave"].CurrentValue then
                pcall(function()
                    if v:IsInGroup(GroupId) and v:GetRankInGroup(GroupId) > 1 then
                        AutoRejoin:Set(false)
                        Player:Kick("Detected Staff (Player above group rank 1)")
                    end
                end)
            end
        end)

        Universal:CreateSection("Rejoining")

        Universal:CreateButton({
            Name = "🔃 Rejoin",
            Info = "Rejoins your current server",
            Callback = function()
                game:GetService("TeleportService"):Teleport(game.PlaceId, Player)
            end,
        })

        Universal:CreateSection("Server Hopping")

        local function ServerHop()
            local Http = game:GetService("HttpService")
            local TPS = game:GetService("TeleportService")
            local Api = "https://games.roblox.com/v1/games/"

            local _place,_id = game.PlaceId, game.JobId
            local _servers = Api.._place.."/servers/Public?sortOrder=Desc&limit=100"

            local function ListServers(cursor)
                local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
                return Http:JSONDecode(Raw)
            end

            local Next; repeat
                local Servers = ListServers(Next)
                for i,v in next, Servers.data do
                    if v.playing < v.maxPlayers and v.id ~= _id then
                        local s,r = pcall(TPS.TeleportToPlaceInstance,TPS,_place,v.id,Player)
                        if s then break end
                    end
                end

                Next = Servers.nextPageCursor
            until not Next
        end

        Universal:CreateButton({
            Name = "🔂 One-Time Server Hop",
            Callback = function()
                ServerHop()
            end,
        })

        Universal:CreateToggle({
            Name = "🔁 Server Hop",
            Info = "Automatically server hops after the interval.",
            CurrentValue = false,
            Flag = "Universal-ServerHop",
            Callback = function(Value)	end,
        })

        Universal:CreateSlider({
            Name = "⏲ Server Hop Intervals",
            Info = "Sets the interval in seconds for the Server Hop.",
            Range = {5, 600},
            Increment = 1,
            CurrentValue = 5,
            Flag = "Universal-ServerhopIntervals",
            Callback = function(Value)	end,
        })

        task.spawn(function()
            while task.wait(Rayfield.Flags["Universal-ServerhopIntervals"].CurrentValue) do
                if Rayfield.Flags["Universal-ServerHop"].CurrentValue then
                    ServerHop()
                end
            end
        end)

        Universal:CreateSection("Other")
        Universal:CreateButton({
            Name = "🗑️ Destory UI",
            Callback = function()
                Rayfield:Destroy()
            end,
        })
        
        Rayfield:LoadConfiguration()
    end)
end

CreateWindow()

return Rayfield, Window, CreateWindow, Notify, GetExploit, SetReExecuteLink
-- local Rayfield, Window, CreateWindow, Notify, GetExploit, SetReExecuteLink = loadstring(game:HttpGet("https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Init.lua"))()
