local ReplFirst = game:GetService("ReplicatedFirst");
local ReplStorage = game:GetService("ReplicatedStorage");
local Scripts = game:GetService("ServerScriptService");
local Players = game:GetService("Players");
local Http = game:GetService("HttpService");

local DS2 = Scripts:FindFirstChild("DataStore2") and require(Scripts.DataStore2) or error("DataStore2 module not found");
DS2.Combine("DATA", "cash", "bag", "settings", "meta")

Players.PlayerAdded:Connect(function(plr)

	local cashStore = DS2("cash", plr)
	local bagStore = DS2("bag", plr)
	local pSettings = DS2("settings", plr)
	local metaData = DS2("meta", plr)

	----------------------------------------

	--Load leaderstats/board

	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"

	local cash = Instance.new("NumberValue")
	cash.Name = "Money"
	cash.Value = cashStore:Get(100)
	cash.Parent = leaderstats

	leaderstats.Parent = plr

	----------------------------------------

	--Load in-game data

	local gameData = Instance.new("Folder")
	gameData.Name = "gameData"

	local bagData :{data: number, capacity: number}= bagStore:Get({data = 0, capacity = 20})
	local bag = Instance.new("NumberValue")
	bag.Name = "Bag"
	bag.Value = bagData.data
	bag.Parent = gameData
	bag.Changed:Connect(function(value)
		bagData.data = bagData.data + value
		bagStore:Set(bagData)
	end)

	local settingsFolder = Instance.new("Folder")
	settingsFolder.Name = "Settings"

	type defaultSettings = {
		musicVolume: number
	}
	local userSettings :defaultSettings= pSettings:Get({musicVolume = 100})
	for k,v in userSettings do
		local setting = Instance.new("StringValue")
		setting.Name = k
		setting.Value = type(v) == "table" and Http:JSONEncode(v) or v
		setting.Parent = settingsFolder
	end

	settingsFolder.Parent = plr

	gameData.Parent = plr

end)