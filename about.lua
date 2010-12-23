
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
	if status.button == "#back" then
		change_view("mainmenu")
	end
end

function M.update(dt, mx, my)
end

function M.draw()

	local b, col

	lg.setBackgroundColor(0,150,200)
	col = util.color(140, 200, 255)
	
	kana.draw_text("Credits", 20, 20, 90, util.color(80, 200, 255), "tl")
	
	kana.draw_text("Programming", 30, 80, 70, util.color(80, 255, 85), "tl")
	kana.draw_text("Tommy Carlsson (tommyc@lavabit.com)", 60, 130, 50, util.color(70, 70, 70), "tl")

	kana.draw_text("Ideas and insperation", 30, 200, 70, util.color(80, 255, 85), "tl")
	kana.draw_text("Timothy and Rhawnie Carlsson", 60, 250, 50, util.color(70, 70, 70), "tl")

	kana.draw_text("Other", 30, 310, 70, util.color(80, 255, 85), "tl")
	kana.draw_text("Tuffy Font: Thatcher Ulrich (http://tulrich.com/fonts/)", 60, 360, 50, util.color(70, 70, 70), "tl")
	kana.draw_text("Sound files: http://thejapanesepage.com/", 60, 390, 50, util.color(70, 70, 70), "tl")

	-- Font Tuffy http://tulrich.com/fonts/ Thatcher Ulrich
	-- Sound http://thejapanesepage.com/
	
	if status.button == "#back" then
		col = util.color(100, 200, 120)
	else
		col = util.color(80, 80, 120)
	end
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Back", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)
end

return M

