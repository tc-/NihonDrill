
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil

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
end

function M.show()
	print("drilloptions.show()")
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
		set_level(status.button.name)
	elseif status.button.name == "#back" then
		change_view("mainmenu")
	end
end

function M.draw()

	local b, col
	
	kana.draw_text("Select what to practice.", 290, 30, 90, util.color(80, 200, 255))
	
	kana.draw_text("Syllabaries", 160, 80, 70, util.color(80, 200, 255))
	
	if user.kana_types == "hiragana" or user.kana_types == "both" then
		if status.button.name == "hiragana" then
			col = util.color(180, 255, 180)
		else
			col = util.color(70, 255, 100)
		end
	else
		if status.button.name == "hiragana" then
			col = util.color(100, 200, 120)
		else
			col = util.color(70, 70, 100)
		end
	end
	b = { x = 50, y = 100, w = 100, h = 440, name = "hiragana" }
	kana.draw_glyph("hiragana", "hi", b.x + 50, b.y + 50, 100, col)
	kana.draw_glyph("hiragana", "ra", b.x + 50, b.y + 150, 100, col)
	kana.draw_glyph("hiragana", "ga", b.x + 50, b.y + 250, 100, col)
	kana.draw_glyph("hiragana", "na", b.x + 50, b.y + 350, 100, col)
	kana.draw_text("hiragana", b.x + 50, b.y + 420, 40, col)
	table.insert(status.buttons, b)
	
	if user.kana_types == "katakana" or user.kana_types == "both" then
		if status.button.name == "katakana" then
			col = util.color(180, 255, 180)
		else
			col = util.color(70, 255, 100)
		end
	else
		if status.button.name == "katakana" then
			col = util.color(100, 200, 120)
		else
			col = util.color(70, 70, 100)
		end
	end
	b = { x = 200, y = 100, w = 100, h = 440, name = "katakana" }
	kana.draw_glyph("katakana", "ka", b.x + 50, b.y + 50, 100, col)
	kana.draw_glyph("katakana", "ta", b.x + 50, b.y + 150, 100, col)
	kana.draw_glyph("katakana", "ka", b.x + 50, b.y + 250, 100, col)
	kana.draw_glyph("katakana", "na", b.x + 50, b.y + 350, 100, col)
	kana.draw_text("katakana", b.x + 50, b.y + 420, 40, col)
	table.insert(status.buttons, b)
	
	if user.kana_types == "" then
		col = util.color(70, 70, 100)
	elseif status.button.name == "hajime" then
		col = util.color(180, 255, 180)
	else
		col = util.color(70, 255, 100)
	end
	b = { x = lg.getWidth() - 160, y = lg.getHeight() - 80, w = 148, h = 70, name = "hajime" }
	kana.print_hiragana({"ha","ji","me"}, b.x + 24, b.y + 24, 48, col)
	kana.draw_text("start", b.x + 70, b.y + 64, 48, col)
	table.insert(status.buttons, b)
	
	kana.draw_text("Level", 520, 80, 70, util.color(80, 200, 255))
	local basex = 360
	local basey = 80
	for i,row in ipairs(levels) do
		
		for i2,l in ipairs(row) do
			b = { x = basex + (i2*48), y = basey + (i*48), w = 48, h = 48, name = l }
			
			if user.level == l then
				if status.button.name == l then
					col = util.color(180, 255, 180)
				else
					col = util.color(70, 255, 100)
				end
			else
				if status.button.name == l then
					col = util.color(100, 200, 120)
				else
					col = util.color(70, 70, 100)
				end
			end
			
			kana.draw_text(l, b.x + 24, b.y + 24, 60, col)
			table.insert(status.buttons, b)
		end
		
	end
	lg.setColor(180, 255, 180)
	local img = get_level_image(user.level)
	lg.draw(img, lg.getWidth() - 180, 140)

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


