
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil

function M.init(data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	images = data.images
end

function M.show()

end

function M.mousepressed(x, y, button)
	if status.button.name == "#back" then
		change_view("mainmenu")
	end
end

function M.update(dt, mx, my)
end

function M.draw()

	local b, col

	lg.setBackgroundColor(0,150,200)
	col = util.color(220, 220, 255)
	
	kana.draw_table("hiragana", 20, 20, 580, 540, 26, col, util.color(100, 160, 200), util.color(180, 200, 255), util.color(80, 140, 255), {})
	
	if status.button.name == "#back" then
		col = util.color(100, 200, 120)
	else
		col = util.color(80, 80, 120)
	end
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Back", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)
end

return M

