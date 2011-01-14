
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil
local color = nil
local gui = require("gui")

local levels = {
	{  1,  2,  3,  4 },
	{  5,  6,  7,  8 },
	{  9, 10, 11, 12 },
	{ 13, 14, 15, 16 },
	{ 17, 18, 19, 20 },
	{ 21, 22, 23, 24 },
	{ 25, 26, 27 },
}

local loaded_level_image_no = -1
local loaded_level_image = nil

local function get_level_image(l)
	if loaded_level_image_no ~= l then
		loaded_level_image_no = l
		loaded_level_image = lg.newImage("images/levels/level_"..l..".png")
	end
	return loaded_level_image
end

function set_level(l)
	user.level = l
	user.alternatives = 3 + l
	if user.alternatives > 9 then
		user.alternatives = 9
	end
end

function M.init(data)
	print("drilloptions.init()", data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	images = data.images
	color = data.color
end

function M.show()
	print("drilloptions.show()")
	if user.autolevel == nil then
		user.autolevel = true
	end
end

function M.update(dt, mx, my)
	
end

function M.mousepressed(x, y, button)
	if status.button.name == "hiragana" then
		if user.kana_types == "" then
			user.kana_types = "hiragana"
		elseif user.kana_types == "katakana" then
			user.kana_types = "both"
		elseif user.kana_types == "both" then
			user.kana_types = "katakana"
		elseif user.kana_types == "hiragana" then
			user.kana_types = ""
		end
	elseif status.button.name == "katakana" then
		if user.kana_types == "" then
			user.kana_types = "katakana"
		elseif user.kana_types == "hiragana" then
			user.kana_types = "both"
		elseif user.kana_types == "both" then
			user.kana_types = "hiragana"
		elseif user.kana_types == "katakana" then
			user.kana_types = ""
		end
	elseif status.button.name == "hajime" then
		if user.kana_types ~= "" then
			change_view("drill")
		end
	elseif type(status.button.name) == "number" then
			user.autolevel = false
			set_level(status.button.name)
	elseif status.button.name == "#autolevel" then
		if user.autolevel then
			user.autolevel = false
		else
			user.autolevel = true
		end
	elseif status.button.name == "#back" then
		change_view("mainmenu")
	end
end

function M.draw()
	local b, col, hover, seleted

	gui.draw_page("Select what to practice", util.color(0,100,10), util.color(0,0,0))

	kana.draw_text("Syllabaries", 70, 90, 70, color.drill_opt_header, "tl")

	-- Draw the Hiragana button.
	selected = user.kana_types == "hiragana" or user.kana_types == "both"
	hover = status.button.name == "hiragana"
	col = color.get_highlight_color(selected, hover)
	b = { x = 20, y = 140, w = 140, h = 380, name = "hiragana" }
	gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"hi","ra","ga","na"}, 86, "Hiragana", 40, hover, "hiragana")
	table.insert(status.buttons, b)

	-- Draw the Katakana button.
	selected = user.kana_types == "katakana" or user.kana_types == "both"
	hover = status.button.name == "katakana"
	col = color.get_highlight_color(selected, hover)
	b = { x = 170, y = 140, w = 140, h = 380, name = "katakana" }
	gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"ka","ta","ka","na"}, 86, "Katakana", 40, hover, "katakana")
	table.insert(status.buttons, b)

	-- Draw the start button.
	selected = user.kana_types ~= ""
	hover = status.button.name == "hajime" and selected
	col = color.get_highlight_color(selected, hover)
	b = { x = lg.getWidth() - 170, y = lg.getHeight() - 90, w = 160, h = 80, name = "hajime" }
	gui.draw_kana_button(b, col, images.button_base, images.button_top, {"ha","ji","me"}, 46, "Start", 46, hover, "hiragana")
	table.insert(status.buttons, b)

	-- Draw the levels.
	local basex = 360
	local basey = 90

	kana.draw_text("Level", basex, 90, 70, color.drill_opt_header, "tl")
	for i,row in ipairs(levels) do
		for i2,l in ipairs(row) do
			b = { x = basex + (i2*48) - 48, y = basey + (i*48), w = 48, h = 48, name = l }

			selected = user.level == l and not user.autolevel
			hover = status.button.name == l
			col = color.get_highlight_color(selected, hover)
			kana.draw_text(l, b.x + 24, b.y + 24, 60, col)
			table.insert(status.buttons, b)
		end
	end

	-- Draw level help image.
	lg.setColor(180, 255, 180, 127)
	local img
	if not user.autolevel then
		img = get_level_image(user.level)
	else
		img = get_level_image(27)
	end
	lg.draw(img, lg.getWidth() - 200, 140)

	--Draw the auto level checkbox.
	if user.autolevel then
		img = images.checked
	else
		img = images.unchecked
	end
	selected = user.autolevel
	hover = status.button.name == "#autolevel"
	col = color.get_highlight_color(selected, hover)
	b = { x = basex, y = basey + (#levels * 48) + 64, w = 180, h = 32, name = "#autolevel" }
	lg.draw(img, b.x, b.y, 0, 0.5, 0.5)
	kana.draw_text("Auto level", b.x + 40, b.y, 50, col, "tl")
	table.insert(status.buttons, b)

	-- Draw the back button.
	b = gui.draw_back(status.button.name == "#back")
	table.insert(status.buttons, b)
end

return M


