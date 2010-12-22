
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

function all_words(level, voc)
	local t = {}

	for i=1,level,1 do
	
		for i1, k in ipairs(voc.levels[i]) do
			table.insert(t, k)
		end

	end

	return t
end

function next_question()
	local words = all_words(user.vocabulary_level, user.vocabulary)
	local alts = {}
	local word
	
	while #alts < user.alternatives do
		word = words[math.random(1, #words)]
		util.remove_object(words, word)
		table.insert(alts, word)
	end
	status.word = alts[math.random(1, #alts)]
	status.alternatives = alts
	
	if status.word == nil then
		print("status.word == nil")
	else
		print("status.word", status.word.eng)
	end
end

function M.show()
	next_question()
	status.submode = "answer"
end

function M.mousepressed(x, y, button)

	if status.submode == "answer" then
		if status.button == nil or status.button == "" then
			return
		end
	
		if status.button == status.word.eng then
			status.submode = "answer_correct"
			status.timeout = 1
		else
			status.submode = "answer_wrong"
		end
	else
		next_question()
		status.submode = "answer"
	end
end

function M.update(dt, mx, my)
	if status.submode == "answer_correct" then
		status.timeout = status.timeout - dt
		if status.timeout <= 0 then
			next_question()
			status.submode = "answer"
		end
	end
end

function M.draw()

	local b

	if status.submode == "answer" then
		lg.setBackgroundColor(0,150,200)
		col = util.color(140, 200, 255)
		
		kana.draw_text("What does this mean?", 20, 20, 90, util.color(80, 200, 255), "tl")
		
		if #status.word.kana < 10 then
			kana.print_kana(status.word.kana, 100, 120, 70, util.color(80, 200, 255), status.word.kana_type)
		else
			kana.print_kana(status.word.kana, 100, 120, 50, util.color(80, 200, 255), status.word.kana_type)
		end
		
		for i, alt in ipairs(status.alternatives) do
		
			if status.button == alt.eng then
				col = util.color(100, 200, 120)
			else
				col = util.color(70, 70, 100)
			end
			b = { x = 120, y = 130 + (i * 48), w = 200, h = 40, name = alt.eng }
			kana.draw_text(alt.eng, b.x, b.y, 50, col, "tl")
			table.insert(status.buttons, b)
		end
	elseif status.submode == "answer_correct" then
		lg.setBackgroundColor(50,255,100)
	elseif status.submode == "answer_wrong" then
		lg.setBackgroundColor(250,50,50)
	end
--	
--		for i, alt in ipairs(status.alternatives) do
--			local x, y = get_alternative_pos(i)
--		
--			if alt == status.hover then
--				col = util.color(140, 200, 255)
--			else
--				col = util.color(0, 40, 80)
--			end
--			kana.draw_glyph_bg(x, y, status.size / 1.5, col)
--			kana.draw_text(alt, x, y, status.size, col)
--		end
--	elseif status.submode == "answer_correct" then
--		lg.setBackgroundColor(50,255,100)
--		col = util.color(60, 60, 60)
--		kana.draw_glyph("hiragana", "ha", 100, 100, 100, col)
--		kana.draw_glyph("hiragana", "i", 100, 200, 100, col)
--		local w = lg.getWidth()
--		kana.draw_kana_romaji(status.kana_type, status.kana, w / 2, 300, 200, util.color(0, 120, 0))
--	elseif status.submode == "answer_wrong" then
--		lg.setBackgroundColor(250,50,50)
--		local w = lg.getWidth()
--		col = util.color(60, 60, 60)
--		kana.draw_glyph("hiragana", "da", 100, 100, 100, col)
--		kana.draw_glyph("hiragana", "me", 100, 200, 100, col)
--		kana.draw_kana_romaji(status.kana_type, status.kana, w / 2, 200, 200, util.color(50, 255, 50))
--		kana.draw_kana_romaji(status.kana_type, status.hover, w / 2, 450, 60, util.color(250, 200, 150))
--	end

--	if status.button == "sound" then
--		lg.setColor(180, 250, 255, 255);
--	else
--		lg.setColor(140, 200, 255, 50);
--	end

--	b = { x = lg.getWidth() - 60, y = lg.getHeight() - 60, w = 60, h = 48, name = "sound" }

--	if user.sound == true then
--		lg.draw(images.sound, b.x, b.y, 0, 0.4, 0.4)
--	else
--		lg.draw(images.nosound, lg.getWidth() - 60, lg.getHeight() - 60, 0, 0.4, 0.4)
--	end

--	table.insert(status.buttons, b)
end

return M

