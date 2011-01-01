
local M = {}

local lg = love.graphics
local la = love.audio

local status = nil
local user = nil
local util = nil
local kana = nil
local images = nil

local function filter_needs_training(stats)
	local ret = {}
	for k, s in pairs(stats) do
		if s.correct > s.incorrect then
			ret[k] = s
		end
	end
	return ret
end

function sort_by_correctness(s1, s2)
	return s1.val > s2.val
end

local function next_question()
	local kanas = kana.all_test_kanas(user.level)
	local alts = {}
	local k
	
	-- Set the kana type of this question.
	status.kana_type = user.kana_types
	if user.kana_types == "both" then
		if math.random(1,2) == 1 then
			status.kana_type = "hiragana"
		else
			status.kana_type = "katakana"
		end
	end
	
	if #status.kana_queue[status.kana_type] == 0 then
		-- Queue is empty so we need to generate a new one.
		local tmp_stats = filter_needs_training(user.stats.kana[status.kana_type])
		local selection = kana.all_test_kanas(user.level)
		local num_all = util.num_keys(selection)
		
		-- Generate a table we can sort and sort it so that the kanas with the best
		-- stats are first.
		local sort_list = {}
		for k,v in pairs(tmp_stats) do
			table.insert(sort_list, {kana = k, val = v.correct - v.incorrect})
		end

		table.sort(sort_list, sort_by_correctness)

		-- Skip the 70% with the best stats.
		local i = num_all * 0.7
		for k, v in pairs(sort_list) do
			if i <= 0 then
				break
			end
			--print("skipping", v.kana, v.val)
			util.remove_object(selection, v.kana)
			i = i - 1
		end
		
		-- Scramble and assign the new queue.
		status.kana_queue[status.kana_type] = util.scramble(selection)
	end
	
	-- Generate the alternatives.
	while #alts < user.alternatives - 1 do
		k = kanas[math.random(1, #kanas)]
		util.remove_object(kanas, k)
		table.insert(alts, k)
	end
	status.kana = status.kana_queue[status.kana_type][1]
	if util.contains(alts, status.kana) then
		k = kanas[math.random(1, #kanas)]
		table.insert(alts, k)
	else
		table.insert(alts, math.random(1, #alts), status.kana)
	end

	util.remove_object(status.kana_queue[status.kana_type], status.kana)
	status.alternatives = alts

	assert(status.kana ~= nil, "status.kana == nil")
end

local function get_alternative_pos(index)
	local angle = ((math.pi*2) / #status.alternatives) * (index - 1)
	local x = status.x + math.cos(angle) * (status.size * 1.3)
	local y = status.y - math.sin(angle) * (status.size * 1.3)
	return x, y
end

local function get_kana_stats(k, kana_type)
	local s = user.stats.kana[kana_type][k]
	if s == nil then
		s = { correct = 0, incorrect = 0 }
		user.stats.kana[kana_type][k] = s
	end
	return s
end

function M.init(data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	images = data.images
end

function M.show()
	status.kana_queue = {
		hiragana = {},
		katakana = {}
	}
	next_question()
	status.submode = "answer"
end

function M.mousepressed(x, y, button)
	if status.submode == "answer" then
		if status.button.alt ~= nil then
			if status.button.name == status.kana then
				status.submode = "answer_correct"
				status.timeout = 1

				status.answer_kana = status.button.name

				local s = get_kana_stats(status.kana, status.kana_type)
				s.correct = s.correct + 1
				
				if user.sound == true then
					la.play(kana.sounds[status.kana])
				end
			else
				-- Add the kana the user answered incorrectly to the queue.
				table.insert(status.kana_queue, status.kana)
				table.insert(status.kana_queue, status.button.name)

				status.answer_kana = status.button.name

				local s = get_kana_stats(status.kana, status.kana_type)
				s.incorrect = s.incorrect + 1

				status.submode = "answer_wrong"
				if user.sound == true then
					la.play(kana.sounds[status.kana])
				end
			end
		end
		
		if status.button.name == "#back" then
			change_view("drilloptions")
		end
	else
		next_question()
		status.submode = "answer"
	end
	
	if status.button.name == "sound" then
		if user.sound == true then
			user.sound = false
		else
			user.sound = true
		end
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
		kana.draw_glyph_bg(status.x, status.y, status.size, col)
		kana.draw_glyph(status.kana_type, status.kana, status.x, status.y, status.size, col)
	
		for i, alt in ipairs(status.alternatives) do
			local x, y = get_alternative_pos(i)
			b = { x = x, y = y, r = status.size * 0.4, name = alt, alt = i }
			table.insert(status.buttons, b)
			
			if alt == status.button.name then
				col = util.color(140, 200, 255)
			else
				col = util.color(0, 40, 80)
			end
			kana.draw_glyph_bg(x, y, status.size / 1.5, col)
			kana.draw_text(alt, x, y, status.size, col)
		end
		
		if status.button.name == "#back" then
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
		kana.draw_kana_romaji(status.kana_type, status.answer_kana, w / 2, 450, 60, util.color(250, 200, 150))
	end

	if status.button.name == "sound" then
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
end

return M

