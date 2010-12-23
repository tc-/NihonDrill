
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

local user = {
	level = 1, -- 1 -> 27
	alternatives = 4,
	kana_types = "", -- "hiragana" | "katakana" | "both"
	errors = {
		{ kana = "i", mixed_with = {"i"}, times = 2 }
	},
	correct = {
		{ kana = "e", times = 3 }
	},
	sound = true, -- http://thejapanesepage.com
}

local images = { }

local data = {
	util = util,
	kana = kana,
	status = status,
	user = user,
	images = images,
	views = views
}

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
	
	kana.init()
	
	images.sound = lg.newImage("images/sound.png")
	images.nosound = lg.newImage("images/nosound.png")

	for k, v in pairs(views) do
		print("load.init", k, v)
		v.init(data)
	end

	lg.setColor(0,0,0,255)
	lg.setBackgroundColor(0,150,200)
end

function love.update(dt)
	local mx, my = love.mouse.getPosition()

	local v = views[status.view]
	
	if v ~= nil then
		v.update(dt, mx, my)
	else
		
	end
	
	status.button = nil
	for i, b in pairs(status.buttons) do
		if util.point_within(mx, my, b.x, b.y, b.w, b.h) then
			status.button = b.name
			break
		end
	end
end

function love.draw()

	status.buttons = {}

	local col = nil
	local b = nil

	local v = views[status.view]
	if v ~= nil then
		v.draw()
	else
		
	end
end

function love.mousepressed(x, y, button)
	local v = views[status.view]
	if v ~= nil then
		v.mousepressed(x, y, button)
	else
		
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
end

