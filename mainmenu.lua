
local M = {}

local lg = love.graphics
local la = love.audio
local gui = require("gui")

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil
local color = nil

local version = nil

function M.init(data)
	print("mainmenu.init()", data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	images = data.images
	color = data.color
	version = data.version
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
	elseif status.button.name == "#fullscreen" then
		set_fullscreen_mode(not user.fullscreen)
	end
end

function M.draw()
	local col, img
	gui.draw_page("What do you want to practice?", util.color(0,110,255), color.alt_hover)

	-- Draw the Vocabulary button.
	col = color.get_hover_color(status.button.name == "vocabulary", "button")
	b = { x = 100, y = 160, w = 386 * 0.8, h = 128 * 0.8, name = "vocabulary" }
	gui.draw_button(b, col, images.vocabulary, color.default_icon, images.button_base, 
		images.button_top, "Vocabulary", status.button.name == "vocabulary", 68)
	table.insert(status.buttons, b)

	-- Draw the Kana button.
	col = color.get_hover_color(status.button.name == "kana", "button")
	b = { x = 100, y = 320, w = 386 * 0.8, h = 128 * 0.8, name = "kana" }
	gui.draw_button(b, col, images.kanadrill, color.default_icon, images.button_base, 
		images.button_top, "Kana", status.button.name == "kana", 100)
	table.insert(status.buttons, b)

	-- Draw the Credits button.
	col = color.get_hover_color(status.button.name == "credits", "credits")
	b = { x = lg.getWidth() - 170, y = lg.getHeight() - 58, w = 160, h = 48, name = "credits" }
	gui.draw_button(b, col, images.credits, color.default_icon, images.button_base, 
		images.button_top, "Credits", status.button.name == "credits", 50)
	table.insert(status.buttons, b)

	-- Draw the version number.
	kana.draw_text(version, lg.getWidth() - 32, 2, 18, util.color(70, 70, 70), "tl")

	-- Draw the fullscreen toggle button.
	if user.fullscreen then
		img = images.windowed
	else
		img = images.fullscreen
	end

	if status.button.name == "#fullscreen" then
		lg.setColor(255, 255, 255, 255)
	else
		lg.setColor(164, 164, 164, 255)
	end
	b = { x = lg.getWidth() - 50, y = 20, w = 48, h = 48, name = "#fullscreen" }
	lg.draw(img, b.x, b.y, 0, 0.7, 0.7)
	table.insert(status.buttons, b)

	col = color.get_hover_color(status.button.name == "#back", "quit")
	b = { x = 10, y = lg.getHeight() - 58, w = 120, h = 48, name = "#back" }
	gui.draw_button(b, col, images.quit, color.default_icon, images.button_base, 
		images.button_top, "Quit", status.button.name == "#back", 50)
	table.insert(status.buttons, b)

	b = { x = lg.getWidth() - 20, y = lg.getHeight() - 20, w = 20, h = 20, name = "#test" }
	table.insert(status.buttons, b)
end

return M

