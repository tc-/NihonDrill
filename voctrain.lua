
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

local function all_words(level, voc, specific_level_only)
	local t = {}

	if specific_level_only ~= true then
		for i=1,level,1 do

			for i1, k in ipairs(voc.levels[i]) do
				table.insert(t, k)
			end

		end
	else
		for i1, k in ipairs(voc.levels[level]) do
				table.insert(t, k)
		end
	end
	return t
end

local function next_question()
	local words = all_words(user.vocabulary_level, user.vocabulary, false)
	local alts = {}
	local word
	
	if #status.word_queue == 0 then
		status.word_queue = util.scramble(all_words(user.vocabulary_level, user.vocabulary, false))
	end
	
	while #alts < user.alternatives - 1 do
		word = words[math.random(1, #words)]
		util.remove_object(words, word)
		table.insert(alts, word)
	end
	status.word = status.word_queue[1] --alts[math.random(1, #alts)]
	if util.contains(alts, status.word) then
		word = words[math.random(1, #words)]
		table.insert(alts, word)
	else
		table.insert(alts, math.random(1, #alts), status.word)
	end

	util.remove_object(status.word_queue, status.word)
	status.alternatives = alts

	if status.word == nil then
		print("status.word == nil")
	else
--		print("status.word", status.word.eng)
	end
end

function M.show()
	user.alternatives = 5
	status.word_queue = all_words(user.vocabulary_level, user.vocabulary, true)
	next_question()
	status.submode = "answer"
end

function M.mousepressed(x, y, button)

	if status.submode == "answer" then
		if status.button == nil or status.button == "" then
			return
		end
		
		if status.button == "#back" then
			change_view("vocoptions")
		else
			if status.button == status.word.eng then
				status.submode = "answer_correct"
				status.timeout = 1
			else
				status.submode = "answer_wrong"
			end
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

	local b, col

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
			b = { x = 120, y = 130 + (i * 48), w = 800, h = 40, name = alt.eng }
			kana.draw_text(alt.eng, b.x, b.y, 50, col, "tl")
			table.insert(status.buttons, b)
		end
		
		if status.button == "#back" then
			col = util.color(100, 200, 120)
		else
			col = util.color(80, 80, 120)
		end
		b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
		kana.draw_text("Back", b.x, b.y, 50, col, "tl")
		table.insert(status.buttons, b)
			
	elseif status.submode == "answer_correct" then
		lg.setBackgroundColor(50,255,100)
		col = util.color(60, 60, 60)
		kana.draw_glyph("hiragana", "ha", lg.getWidth() - 100, lg.getHeight() - 200, 100, col)
		kana.draw_glyph("hiragana", "i", lg.getWidth() - 100, lg.getHeight() - 100, 100, col)
		
		col = util.color(0, 120, 0)
		if #status.word.kana < 10 then
			kana.print_kana(status.word.kana, 100, 120, 70, col, status.word.kana_type)
		else
			kana.print_kana(status.word.kana, 100, 120, 50, col, status.word.kana_type)
		end
		
		kana.draw_text(status.word.eng, 120, 160, 50, col, "tl")
		
	elseif status.submode == "answer_wrong" then
		lg.setBackgroundColor(250,50,50)
		col = util.color(60, 60, 60)
		kana.draw_glyph("hiragana", "da", lg.getWidth() - 100, lg.getHeight() - 200, 100, col)
		kana.draw_glyph("hiragana", "me", lg.getWidth() - 100, lg.getHeight() - 100, 100, col)
		
		col = util.color(50, 255, 50)
		if #status.word.kana < 10 then
			kana.print_kana(status.word.kana, 100, 120, 70, col, status.word.kana_type)
		else
			kana.print_kana(status.word.kana, 100, 120, 50, col, status.word.kana_type)
		end
		
		kana.draw_text(status.word.eng, 120, 160, 50, col, "tl")
	end
end

return M

