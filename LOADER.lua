local Games = {
  [11523066819] = "https://raw.githubusercontent.com/xvhHaloxx/Halo-Hub/main/Games/Tower%20Merge%20Simulator.lua" -- Tower Merge Simulator
}

if Games[game.PlaceId] then
	loadstring(game:HttpGet(Games[game.PlaceId]))()
else
	game.StarterGui:SetCore("SendNotification", {
	    Title = "Halo Hub";
	    Text = "Game not supported";
	    Duration = 10;
    })
end
