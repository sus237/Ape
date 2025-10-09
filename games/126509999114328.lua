local plrs = game:GetService("Players")
local cam = workspace.CurrentCamera
local uis = game:GetService("UserInputService")
local lplr = plrs.LocalPlayer
local character = lplr.Character
local root = character and character:FindFirstChild("HumanoidRootPart")
local Lighting = game:GetService("Lighting")

local run = function(func) func() end
local cloneref = cloneref or function(obj) return obj end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local inputService = cloneref(game:GetService('UserInputService'))

local lplr = playersService.LocalPlayer
local vape = shared.vape
local entitylib = vape.Libraries.entity
local sessioninfo = vape.Libraries.sessioninfo

local function notif(...)
	return vape:CreateNotification(...)
end

