
local lg = love.graphics
local la = love.audio

local util = require("util")
local kana = require("kana")

local views = {}

views.drill = require("drill")
views.drilloptions = require("drilloptions")
views.vocoptions = require("vocoptions")
views.mainmenu = require("mainmenu")
views.voctrain = require("voctrain")
views.about = require("about")
views.test = require("test")

local status = {
	view = "mainmenu", --"drill",
	submode = "answer",
	timeout = 1,
	kana_type = "katakana",
	kana = "ka",
	alternatives = {"ka", "shi", "u", "e", "se"},
	lastmode = "none",
	hover = "ka",
	x = 380,
	y = 280,
	size = 140,
	button = nil,
	buttons = { }
}

local default_user = {
	level = 1,
	alternatives = 4,
	kana_types = "", -- "hiragana" | "katakana" | "both"
	sound = true, -- http://thejapanesepage.com
	stats = {
		kana = {
			hiragana = {},
			katakana = {}
		},
		voc = {}
	}
}

local user

local images = { }

local color = {}

local data = {
	util = util,
	kana = kana,
	status = status,
	user = user,
	images = images,
	color = nil,
	views = views
}

function color.get_highlight_color(col_type, is_selected, is_hovering)
	if is_selected then
		if is_hovering then
			return color.hover
		else
			return color.active
		end
	else
		if is_hovering then
			return color.disabled_hover
		else
			return color.disabled
		end
	end
end

function change_view(new_view)
	status.view = new_view
	status.submode = nil
	
	local v = views[status.view]
	
	if v ~= nil then
		v.show()
	end
end

function love.load()
	math.randomseed(os.time())

	love.filesystem.setIdentity("NihonDrill")

	color = require("color")
	color.init(util)
	data.color = color

	if love.filesystem.exists("user.lua") then
		local chunk = love.filesystem.load("user.lua")
		local ok, result = pcall(chunk)
		if not ok then
			print("love.load failed to load user data", result)
			user = default_user
		else
			print("love.load loaded user data", "data does not contain all keys")
			util.print_table(result)
			user = result
			data.user = user
		end
	else
		user = default_user
	end

	data.user = user

	kana.init()

	images.sound = lg.newImage("images/sound.png")
	images.nosound = lg.newImage("images/nosound.png")
	images.checked = lg.newImage("images/checked.png")
	images.unchecked = lg.newImage("images/unchecked.png")

	for k, v in pairs(views) do
		print("load.init", k, v)
		v.init(data)
	end

	lg.setColor(0,0,0,255)
	lg.setBackgroundColor(0,150,200)
end

function love.update(dt)
	local mx, my = love.mouse.getPosition()

	status.button = nil
	for i, b in pairs(status.buttons) do
		if b.r == nil then
			-- Rectangular button
			if util.point_within(mx, my, b.x, b.y, b.w, b.h) then
				status.button = b
				break
			end
		else
			-- Circle button
			if util.distance_to(b.x, b.y, mx, my) <= b.r then
				status.button = b
				break
			end
		end
	end
	
	if status.button == nil then
		status.button = {}
	end
	
	local v = views[status.view]
	if v ~= nil then
		v.update(dt, mx, my)
	else
		change_view("mainmenu")
	end
end

function love.draw()

	status.buttons = {}

	if status.button == nil then
		status.button = {}
	end

	local col = nil
	local b = nil

	local v = views[status.view]
	if v ~= nil then
		v.draw()
	else
		change_view("mainmenu")
	end
end

function love.mousepressed(x, y, button)
	local v = views[status.view]

	if status.button == nil then
		status.button = {}
	end

	if v ~= nil then
		v.mousepressed(x, y, button)
	else
		change_view("mainmenu")
	end
end

function love.mousereleased(x, y, button)
end

function love.keypressed(key, unicode)
end

function love.keyreleased(key, unicode)
end

function love.focus(f)
end

function love.quit()
	local data = "return "..util.serialize(user)
	--print(data)
	love.filesystem.write("user.lua", data)
end

