
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil
local color = nil

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

	-- Draw the heading.
	kana.draw_text("Select what to practice.", 290, 30, 90, color.title)

	kana.draw_text("Syllabaries", 70, 60, 70, color.header, "tl")

	-- Draw the Hiragana button.
	
	selected = user.kana_types == "hiragana" or user.kana_types == "both"
	hover = status.button.name == "hiragana"
	col = color.get_highlight_color(selected, hover)
	b = { x = 50, y = 100, w = 100, h = 440, name = "hiragana" }
	kana.draw_glyph("hiragana", "hi", b.x + 50, b.y + 50, 100, col)
	kana.draw_glyph("hiragana", "ra", b.x + 50, b.y + 150, 100, col)
	kana.draw_glyph("hiragana", "ga", b.x + 50, b.y + 250, 100, col)
	kana.draw_glyph("hiragana", "na", b.x + 50, b.y + 350, 100, col)
	kana.draw_text("hiragana", b.x + 50, b.y + 420, 40, col)
	table.insert(status.buttons, b)

	-- Draw the Katakana button.
	selected = user.kana_types == "katakana" or user.kana_types == "both"
	hover = status.button.name == "katakana"
	col = color.get_highlight_color(selected, hover)
	b = { x = 200, y = 100, w = 100, h = 440, name = "katakana" }
	kana.draw_glyph("katakana", "ka", b.x + 50, b.y + 50, 100, col)
	kana.draw_glyph("katakana", "ta", b.x + 50, b.y + 150, 100, col)
	kana.draw_glyph("katakana", "ka", b.x + 50, b.y + 250, 100, col)
	kana.draw_glyph("katakana", "na", b.x + 50, b.y + 350, 100, col)
	kana.draw_text("katakana", b.x + 50, b.y + 420, 40, col)
	table.insert(status.buttons, b)

	-- Draw the start button.
	selected = user.kana_types ~= ""
	hover = status.button.name == "hajime" and selected
	col = color.get_highlight_color(selected, hover)
	b = { x = lg.getWidth() - 160, y = lg.getHeight() - 80, w = 148, h = 70, name = "hajime" }
	kana.print_hiragana({"ha","ji","me"}, b.x + 24, b.y + 24, 48, col)
	kana.draw_text("start", b.x + 70, b.y + 64, 48, col)
	table.insert(status.buttons, b)

	-- Draw the levels.
	local basex = 360
	local basey = 70

	kana.draw_text("Level", basex, 60, 70, util.color(80, 200, 255), "tl")
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
	lg.setColor(180, 255, 180)
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
	col = color.get_hover_color(status.button.name == "#back")
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Back", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)
end

return M


