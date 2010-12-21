
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil

function M.init(data)
	print("mainmenu.init()", data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
end

function M.update(dt, mx, my)
	
end

function M.show()
	print("mainmenu.show()")
end

function M.mousepressed(x, y, button)
	if status.button == "vocabulary" then
		change_view("vocoptions")
	elseif status.button == "kana" then
		change_view("drilloptions")
	end
end

function M.draw()

	local col
	
	kana.draw_text("What do you want to train?", 310, 30, 90, util.color(80, 200, 255))
	
	--kana.draw_text("Vocabulary", 160, 80, 70, util.color(80, 200, 255))
	
	if status.button == "vocabulary" then
		col = util.color(180, 255, 180)
	else
		col = util.color(70, 255, 100)
	end
	b = { x = 50, y = 100, w = 230, h = 60, name = "vocabulary" }
	kana.draw_text("Vocabulary", b.x, b.y, 80, col, "tl")
	table.insert(status.buttons, b)
	
	if status.button == "kana" then
		col = util.color(180, 255, 180)
	else
		col = util.color(70, 255, 100)
	end
	b = { x = 50, y = 200, w = 100, h = 60, name = "kana" }
	kana.draw_text("Kana", b.x, b.y, 80, col, "tl")
	table.insert(status.buttons, b)
	
end

return M

