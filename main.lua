repeat task.wait() until game:IsLoaded()

local vape
local loadstring = function(...)
	local res, err = loadstring(...)
	if err and vape then
		pcall(function()
			vape:CreateNotification('Ape', 'Failed to load : '..err, 30, 'alert')
		end)
	end
	return res
end

local queue_on_teleport = queue_on_teleport 
	or (syn and syn.queue_on_teleport) 
	or (fluxus and fluxus.queue_on_teleport) 
	or function() end

local isfile = isfile or function(file)
	local suc, res = pcall(function()
		return readfile(file)
	end)
	return suc and res ~= nil and res ~= ''
end

local cloneref = cloneref or function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))

if identifyexecutor then
	if table.find({'Argon', 'Wave'}, ({identifyexecutor()})[1]) then
		getgenv().setthreadidentity = nil
	end
	
	if table.find({'Xeno','xeno'}, ({identifyexecutor()})[1]) then
		local coreGui = game:GetService("CoreGui")
		local robloxGui = coreGui:WaitForChild("RobloxGui", 10)
		if robloxGui then
			robloxGui:WaitForChild("Modules", 10)
			local modules = robloxGui:FindFirstChild("Modules")
			if modules then
				modules:WaitForChild("Common", 5)
				modules:WaitForChild("Locales", 5)
				modules:WaitForChild("AbuseReport", 5)
			end
		end
	end
end

if shared.vape then shared.vape:Uninject() end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet('https://raw.githubusercontent.com/sus237/Ape/'..readfile('newvape/profiles/commit.txt')..'/'..select(1, path:gsub('newvape/', '')), true)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

local function finishLoading()
	vape.Init = nil
	vape:Load()
	task.spawn(function()
		repeat
			vape:Save()
			task.wait(10)
		until not vape.Loaded
	end)

	local teleportedServers
	vape:Clean(playersService.LocalPlayer.OnTeleport:Connect(function()
		if (not teleportedServers) and (not shared.VapeIndependent) then
			teleportedServers = true
			local teleportScript = [[
				shared.vapereload = true
				if shared.VapeDeveloper then
					loadstring(readfile('newvape/loader.lua'), 'loader')()
				else
					loadstring(game:HttpGet('https://raw.githubusercontent.com/sus237/ape/'..readfile('newvape/profiles/commit.txt')..'/loader.lua', true), 'loader')()
				end
			]]
			if shared.VapeDeveloper then
				teleportScript = 'shared.VapeDeveloper = true\n'..teleportScript
			end
			if shared.VapeCustomProfile then
				teleportScript = 'shared.VapeCustomProfile = "'..shared.VapeCustomProfile..'"\n'..teleportScript
			end
			vape:Save()
			queue_on_teleport(teleportScript)
		end
	end))

	if not shared.vapereload then
		if not vape.Categories then return end
		if vape.Categories.Main.Options['GUI bind indicator'].Enabled then
			pcall(function()
				vape:CreateNotification('Finished Loading', vape.VapeButton and 'Press the button in the top right to open GUI' or 'Press '..table.concat(vape.Keybind, ' + '):upper()..' to open GUI', 5)
			end)
		end
	end
end

if not isfile('newvape/profiles/gui.txt') then
	writefile('newvape/profiles/gui.txt', 'new')
end

local gui = readfile('newvape/profiles/gui.txt')

if not isfolder('newvape/assets/'..gui) then
	makefolder('newvape/assets/'..gui)
end

vape = loadstring(downloadFile('newvape/guis/'..gui..'.lua'), 'gui')()
shared.vape = vape

if not shared.VapeIndependent then
	loadstring(downloadFile('newvape/games/universal.lua'), 'universal')()

	local gameFilePath = 'newvape/games/'..game.PlaceId..'.lua'
	if isfile(gameFilePath) then
		local contents = readfile(gameFilePath)
		if vape.LoadGameConfig then
			vape:LoadGameConfig(contents)
		else
			shared.GameConfig = contents
		end
	else
		if not shared.VapeDeveloper then
			local suc, res = pcall(function()
				return game:HttpGet('https://raw.githubusercontent.com/sus237/Ape/'..readfile('newvape/profiles/commit.txt')..'/games/'..game.PlaceId..'.lua', true)
			end)
			if suc and res ~= '404: Not Found' then
				if vape.LoadGameConfig then
					vape:LoadGameConfig(res)
				else
					shared.GameConfig = res
				end
			end
		end
	end

	finishLoading()
else
	vape.Init = finishLoading
	return vape
end
