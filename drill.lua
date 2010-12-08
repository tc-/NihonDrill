
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil

local function next_question()
	status.kana, status.alternatives, status.kana_type = kana.generate_question(user.level, status.kana, user.alternatives, user.kana_types)
end

local function get_alternative_pos(index)
	local angle = ((math.pi*2) / #status.alternatives) * (index - 1)
	local x = status.x + math.cos(angle) * (status.size * 1.3)
	local y = status.y - math.sin(angle) * (status.size * 1.3)
	return x, y
end

function M.init(data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	images = data.images
end

function M.show()
	next_question()
	status.submode = "answer"
end

function M.mousepressed(x, y, button)
	if status.submode == "answer" then
		if status.hover ~= nil then
			if status.hover == status.kana then
				status.submode = "answer_correct"
				status.timeout = 1
				if user.sound == true then
					la.play(kana.sounds[status.kana])
				end
			else
				status.submode = "answer_wrong"
				if user.sound == true then
					la.play(kana.sounds[status.kana])
				end
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
end

function M.update(dt, mx, my)
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

function M.draw()
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
		lg.setColor(180, 250, 255, 255);
	else
		lg.setColor(140, 200, 255, 50);
	end

	b = { x = lg.getWidth() - 60, y = lg.getHeight() - 60, w = 60, h = 48, name = "sound" }

	if user.sound == true then
		lg.draw(images.sound, b.x, b.y, 0, 0.4, 0.4)
	else
		lg.draw(images.nosound, lg.getWidth() - 60, lg.getHeight() - 60, 0, 0.4, 0.4)
	end

	table.insert(status.buttons, b)

--		lg.setColor(255, 0, 0, 50)
--		lg.rectangle("fill", b.x, b.y, b.w, b.h)
end

return M

