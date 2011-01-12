
local M = {}

local lg = love.graphics
local la = love.audio

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

	kana.draw_text("What do you want to train?", 20, 20, 90, color.title, "tl")

	col = color.get_hover_color(status.button.name == "vocabulary", "button")
	b = { x = 100, y = 160, w = 386 * 0.8, h = 128 * 0.8, name = "vocabulary" }

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(images.button_base, b.x, b.y, 0, 0.8, 0.8)

	if status.button.name == "vocabulary" then
		lg.setColor(240, 250, 255, 255)
		lg.draw(images.kanadrill, b.x + 4, b.y + 4, 0, 0.8, 0.8)
	else
		lg.setColor(180, 200, 255, 255)
		lg.draw(images.kanadrill, b.x + 10, b.y + 6, 0, 0.7, 0.7)
	end
	kana.draw_text("Vocabulary", b.x + 100, b.y + 26, 70, col, "tl")

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(images.button_top, b.x, b.y, 0, 0.8, 0.8)
	table.insert(status.buttons, b)

	col = color.get_hover_color(status.button.name == "kana", "button")
	b = { x = 100, y = 310, w = 386 * 0.8, h = 128 * 0.8, name = "kana" }

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(images.button_base, b.x, b.y, 0, 0.8, 0.8)

	if status.button.name == "kana" then
		lg.setColor(240, 250, 255, 255)
		lg.draw(images.kanadrill, b.x + 4, b.y + 4, 0, 0.8, 0.8)
	else
		lg.setColor(180, 200, 255, 255)
		lg.draw(images.kanadrill, b.x + 10, b.y + 6, 0, 0.7, 0.7)
	end
	kana.draw_text("Kana", b.x + 130, b.y + 20, 100, col, "tl")

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(images.button_top, b.x, b.y, 0, 0.8, 0.8)
	table.insert(status.buttons, b)

	col = color.get_highlight_color(false, status.button.name == "credits")
	b = { x = lg.getWidth() - 100, y = lg.getHeight() - 40, w = 90, h = 28, name = "credits" }
	kana.draw_text("Credits", b.x, b.y, 50, col, "tl")
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

	col = color.get_hover_color(status.button.name == "#back")
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Quit", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)

	b = { x = lg.getWidth() - 20, y = lg.getHeight() - 20, w = 20, h = 20, name = "#test" }
	table.insert(status.buttons, b)
end

return M

