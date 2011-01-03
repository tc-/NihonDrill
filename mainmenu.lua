
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil

local version = "v0.1*"

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
	if status.button.name == "vocabulary" then
		change_view("vocoptions")
	elseif status.button.name == "kana" then
		change_view("drilloptions")
	elseif status.button.name == "#back" then
		love.event.push('q')
	elseif status.button.name == "credits" then
		change_view("about")
	elseif status.button.name == "#test" then
		change_view("test")
	end
end

function M.draw()

	local col

	kana.draw_text("What do you want to train?", 20, 20, 90, util.color(80, 200, 255), "tl")

	if status.button.name == "vocabulary" then
		col = util.color(180, 255, 180)
	else
		col = util.color(70, 255, 100)
	end
	b = { x = 50, y = 100, w = 230, h = 60, name = "vocabulary" }
	kana.draw_text("Vocabulary", b.x, b.y, 80, col, "tl")
	table.insert(status.buttons, b)

	if status.button.name == "kana" then
		col = util.color(180, 255, 180)
	else
		col = util.color(70, 255, 100)
	end
	b = { x = 50, y = 200, w = 100, h = 60, name = "kana" }
	kana.draw_text("Kana", b.x, b.y, 80, col, "tl")
	table.insert(status.buttons, b)

	if status.button.name == "credits" then
		col = util.color(100, 200, 120)
	else
		col = util.color(80, 80, 120)
	end
	b = { x = lg.getWidth() - 100, y = lg.getHeight() - 40, w = 90, h = 28, name = "credits" }
	kana.draw_text("Credits", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)

	kana.draw_text(version, lg.getWidth() - 32, 2, 18, util.color(70, 70, 70), "tl")

	if status.button.name == "#back" then
		col = util.color(100, 200, 120)
	else
		col = util.color(80, 80, 120)
	end
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Quit", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)

	b = { x = lg.getWidth() - 20, y = lg.getHeight() - 20, w = 20, h = 20, name = "#test" }
	table.insert(status.buttons, b)
end

return M

