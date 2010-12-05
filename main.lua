
local lg = love.graphics
local la = love.audio

local util = require("util")
local kana = require("kana")

local levels = {
	{  1,  2,  3,  4 },
	{  5,  6,  7,  8 },
	{  9, 10, 11, 12 },
	{ 13, 14, 15, 16 },
	{ 17, 18, 19, 20 },
	{ 21, 22, 23, 24 },
	{ 25, 26, 27 },
}

local status = {
	mode = "select_type", --"drill",
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

local images = { }

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

function next_question()
	status.kana, status.alternatives, status.kana_type = kana.generate_question(user.level, status.kana, user.alternatives, user.kana_types)
end

function set_level(l)
	user.level = l
	user.alternatives = 3 + l
	if user.alternatives > 9 then
		user.alternatives = 9
	end
end

function love.load()
	math.randomseed(os.time())
	
	kana.init()
	
	images.sound = lg.newImage("images/sound.png")
	images.nosound = lg.newImage("images/nosound.png")
	
	next_question()

	lg.setColor(0,0,0,255)
	lg.setBackgroundColor(0,150,200)
end

function get_alternative_pos(index)
	local angle = ((math.pi*2) / #status.alternatives) * (index - 1)
	local x = status.x + math.cos(angle) * (status.size * 1.3)
	local y = status.y - math.sin(angle) * (status.size * 1.3)
	return x, y
end

function love.update(dt)
	local mx, my = love.mouse.getPosition()
	
	if status.mode == "drill" then
		if status.submode == "answer" then
			status.hover = nil

			for i, alt in ipairs(status.alternatives) do
				local x,y = get_alternative_pos(i)
				
				if util.distance_to(x, y, mx, my) <= status.size * 0.4 then
					status.hover = alt
					break
				end
			end
		elseif status.submode == "answer_correct" then
			status.timeout = status.timeout - dt
			if status.timeout <= 0 then
				next_question()
				status.submode = "answer"
			end
		end
		
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

	if status.mode == "drill" then
		if status.submode == "answer" then
			lg.setBackgroundColor(0,150,200)
			col = util.color(140, 200, 255)
			kana.draw_glyph_bg(status.x, status.y, status.size, col)
			kana.draw_glyph(status.kana_type, status.kana, status.x, status.y, status.size, col)
			
			for i, alt in ipairs(status.alternatives) do
				local x, y = get_alternative_pos(i)
				
				if alt == status.hover then
					col = util.color(140, 200, 255)
				else
					col = util.color(0, 40, 80)
				end
				kana.draw_glyph_bg(x, y, status.size / 1.5, col)
				kana.draw_text(alt, x, y, status.size, col)
			end
		elseif status.submode == "answer_correct" then
			lg.setBackgroundColor(50,255,100)
			col = util.color(60, 60, 60)
			kana.draw_glyph("hiragana", "ha", 100, 100, 100, col)
			kana.draw_glyph("hiragana", "i", 100, 200, 100, col)
			local w = lg.getWidth()
			kana.draw_kana_romaji(status.kana_type, status.kana, w / 2, 300, 200, util.color(0, 120, 0))
		elseif status.submode == "answer_wrong" then
			lg.setBackgroundColor(250,50,50)
			local w = lg.getWidth()
			col = util.color(60, 60, 60)
			kana.draw_glyph("hiragana", "da", 100, 100, 100, col)
			kana.draw_glyph("hiragana", "me", 100, 200, 100, col)
			kana.draw_kana_romaji(status.kana_type, status.kana, w / 2, 200, 200, util.color(50, 255, 50))
			kana.draw_kana_romaji(status.kana_type, status.hover, w / 2, 450, 60, util.color(250, 200, 150))
		end
		
		if status.button == "sound" then
			lg.setColor(180, 250, 255);
		else
			lg.setColor(140, 200, 255);
		end
		
		if user.sound == true then
			lg.draw(images.sound, lg.getWidth() - 60, lg.getHeight() - 60, 0, 0.4, 0.4)
		else
			lg.draw(images.nosound, lg.getWidth() - 60, lg.getHeight() - 60, 0, 0.4, 0.4)
		end
	elseif status.mode == "select_type" then
		
		kana.draw_text("Select what to practice.", 290, 30, 90, util.color(80, 200, 255))
		
		kana.draw_text("Syllabaries", 160, 80, 70, util.color(80, 200, 255))
		
		if user.kana_types == "hiragana" or user.kana_types == "both" then
			if status.button == "hiragana" then
				col = util.color(180, 255, 180)
			else
				col = util.color(70, 255, 100)
			end
		else
			if status.button == "hiragana" then
				col = util.color(100, 200, 120)
			else
				col = util.color(70, 70, 100)
			end
		end
		local b = { x = 50, y = 100, w = 100, h = 440, name = "hiragana" }
		kana.draw_glyph("hiragana", "hi", b.x + 50, b.y + 50, 100, col)
		kana.draw_glyph("hiragana", "ra", b.x + 50, b.y + 150, 100, col)
		kana.draw_glyph("hiragana", "ga", b.x + 50, b.y + 250, 100, col)
		kana.draw_glyph("hiragana", "na", b.x + 50, b.y + 350, 100, col)
		kana.draw_text("hiragana", b.x + 50, b.y + 420, 40, col)
		table.insert(status.buttons, b)
		
		if user.kana_types == "katakana" or user.kana_types == "both" then
			if status.button == "katakana" then
				col = util.color(180, 255, 180)
			else
				col = util.color(70, 255, 100)
			end
		else
			if status.button == "katakana" then
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
		elseif status.button == "hajime" then
			col = util.color(180, 255, 180)
		else
			col = util.color(70, 255, 100)
		end
		b = { x = lg.getWidth() - 160, y = lg.getHeight() - 80, w = 148, h = 70, name = "hajime" }
		print_hiragana({"ha","ji","me"}, b.x + 24, b.y + 24, 48, col)
		kana.draw_text("start", b.x + 70, b.y + 64, 48, col)
		table.insert(status.buttons, b)
		
		kana.draw_text("Level", 520, 80, 70, util.color(80, 200, 255))
		local basex = 400
		local basey = 80
		for i,row in ipairs(levels) do
			
			for i2,l in ipairs(row) do
				b = { x = basex + (i2*48), y = basey + (i*48), w = 48, h = 48, name = l }
				
				if status.button == l then
					col = util.color(70, 255, 100)
				else
					col = util.color(70, 70, 100)
				end
				
				if user.level == l then
					if status.button == l then
						col = util.color(180, 255, 180)
					else
						col = util.color(70, 255, 100)
					end
				else
					if status.button == l then
						col = util.color(100, 200, 120)
					else
						col = util.color(70, 70, 100)
					end
				end
				
				kana.draw_text(l, b.x + 24, b.y + 24, 60, col)
				table.insert(status.buttons, b)
			end
			
		end
--		lg.setColor(255, 0, 0, 50)
--		lg.rectangle("fill", b.x, b.y, b.w, b.h)
	end
end

function love.mousepressed(x, y, button)
	if status.mode == "drill" then
		if status.submode == "answer" then
			if status.hover ~= nil then
				if status.hover == status.kana then
					status.submode = "answer_correct"
					status.timeout = 1
					la.play(kana.sounds[status.kana])
				else
					status.submode = "answer_wrong"
					la.play(kana.sounds[status.kana])
				end
			end
		else
			next_question()
			status.submode = "answer"
		end
		
		if status.button == "sound" then
			if user.sound == true then
				user.sound = false
			else
				user.sound = true
			end
		end
	elseif status.mode == "select_type" then
		if status.button == "hiragana" then
			if user.kana_types == "" then
				user.kana_types = "hiragana"
			elseif user.kana_types == "katakana" then
				user.kana_types = "both"
			elseif user.kana_types == "both" then
				user.kana_types = "katakana"
			elseif user.kana_types == "hiragana" then
				user.kana_types = ""
			end
		elseif status.button == "katakana" then
			if user.kana_types == "" then
				user.kana_types = "katakana"
			elseif user.kana_types == "hiragana" then
				user.kana_types = "both"
			elseif user.kana_types == "both" then
				user.kana_types = "hiragana"
			elseif user.kana_types == "katakana" then
				user.kana_types = ""
			end
		elseif status.button == "hajime" then
			if user.kana_types ~= "" then
				status.mode = "drill"
				next_question()
				status.submode = "answer"
			end
		elseif type(status.button) == "number" then
			set_level(status.button)
		end
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

