
local M = {}

local autolevel_value_needed = 10

local lg = love.graphics
local la = love.audio

local util = require("util")
local kana = require("kana")
local images = require("images")
local color = require("color")
local gui = require("gui")

local status = nil
local user = nil

local function get_kana_stats(k, kana_type)
	local s = user.stats.kana[kana_type][k]
	if s == nil then
		s = { correct = 0, incorrect = 0 }
		user.stats.kana[kana_type][k] = s
	end
	return s
end

local function calc_autolevel(kana_type, value_needed)
	local num_practice = 0
	for l, level in ipairs(kana.layout) do
		for i, k in ipairs(level) do
			local s = get_kana_stats(k, kana_type)
			if (s.correct - s.incorrect) < value_needed then
				num_practice = num_practice + 1
			end
			if num_practice >= 3 then
				return l
			end
		end
	end
	return 27
end

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
	return (s1.val == s2.val and s1.incorrect < s2.incorrect) or (s1.val > s2.val)
end

local function next_question()
	local kanas
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
		if user.autolevel then
			local new_level = 1
			if user.kana_types == "both" then
				new_level = math.min(calc_autolevel("hiragana", autolevel_value_needed), calc_autolevel("katakana", autolevel_value_needed))
			elseif user.kana_types == "hiragana" then
				new_level = calc_autolevel("hiragana", autolevel_value_needed)
			elseif user.kana_types == "katakana" then
				new_level = calc_autolevel("katakana", autolevel_value_needed)
			end
			if new_level ~= user.level then
				set_level(new_level)
			end
		end
		print("Generating new queue", status.kana_type, "user.level", user.level)

		local tmp_stats = filter_needs_training(user.stats.kana[status.kana_type])
		local selection = kana.all_test_kanas(user.level)
		local num_all = util.num_keys(selection)

		-- Generate a table we can sort and sort it so that the kanas with the best
		-- stats are first.
		local sort_list = {}
		for k,v in pairs(tmp_stats) do
			table.insert(sort_list, {kana = k, val = v.correct - v.incorrect, incorrect = v.incorrect})
		end

		table.sort(sort_list, sort_by_correctness)

		-- Skip over the kanas with the best stats.
		local i = num_all - 6
		if num_all - i <= 2 then i = 2 end
		if i > 0 then
			print("skipping", i, "out of", num_all, "num left", num_all - i)
			for k, v in pairs(sort_list) do
				if i <= 0 then
					break
				end
				--print("skipping", v.kana, v.val)
				util.remove_object(selection, v.kana)
				i = i - 1
			end
		end

		-- Scramble and assign the new queue.
		status.kana_queue[status.kana_type] = util.scramble(selection)
	end

	kanas = kana.all_test_kanas(user.level)

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

function M.init(data)
	status = data.status
	user = data.user
end

local function reset_queue()
	status.kana_queue = {
		hiragana = {},
		katakana = {}
	}
end

function M.show()
	reset_queue()
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
		elseif status.button.name == "#answer" then
			status.submode = "show_answer"
			table.insert(status.kana_queue, status.kana)
		elseif status.button.name == "#level_up" then
			if user.level < 27 then
				user.autolevel = false
				set_level(user.level + 1)
				reset_queue()
			end
		elseif status.button.name == "#level_down" then
			if user.level > 1 then
				user.autolevel = false
				set_level(user.level - 1)
				reset_queue()
			end
		end
		
		if status.button.name == "#back" then
			change_view("drilloptions")
		end
	elseif status.submode == "show_answer" then
		if status.button.name == "#back" then
			next_question()
			status.submode = "answer"
		elseif status.button.name == "#switch_type" then
			if status.kana_type == "hiragana" then
				status.kana_type = "katakana"
			else
				status.kana_type = "hiragana"
			end
		elseif kana.is_kana(status.button.name) then
			if user.sound == true then
				la.play(kana.sounds[status.button.name])
			end
		end
	else
		next_question()
		status.submode = "answer"
	end
	
	if status.button.name == "#sound" then
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
	local b, col, selected, hover, scalex, scaley, img
	local center = lg.getWidth() * 0.5

	if status.submode == "answer" then
		gui.draw_page_no_head(util.color(0,150,200))

		-- Draw the question kana.
		b = { x = status.x, y = status.y, r = status.size * 0.7, name = "#question" }
		gui.draw_rbutton_kana(b, util.color(130,180,255), images.rbutton_base, images.rbutton_top, status.kana, status.size, false, status.kana_type)

		-- Draw the alternatives.
		for i, alt in ipairs(status.alternatives) do
			local x, y = get_alternative_pos(i)
			b = { x = x, y = y, r = status.size * 0.44, name = alt, alt = i }
			table.insert(status.buttons, b)
			col = color.get_hover_color(alt == status.button.name, "alt")
			gui.draw_rbutton_text(b, col, images.rbutton_base, images.rbutton_top, alt, status.size * 0.7, alt == status.button.name)
		end

		-- Draw the level selector down.
		b = { x = 10, y = 10, w = 100, h = 48, name = "#level_down" }
		selected = user.level > 1
		hover = status.button.name == "#level_down" and selected
		col = color.get_highlight_color(selected, hover, "alt")
		scalex, scaley = gui.draw_button_image(b, col, images.button_base)
		kana.draw_glyph("hiragana", "<", b.x + 18, b.y + 24, 32, col)
		gui.draw_button_image(b, col, images.button_top, scalex, scaley)
		b.w = b.w - 60
		table.insert(status.buttons, b)

		-- Draw the level selector up.
		b = { x = 72, y = 10, w = 100, h = 48, name = "#level_up" }
		selected = user.level < 27
		hover = status.button.name == "#level_up" and selected
		col = color.get_highlight_color(selected, hover, "alt")
		gui.draw_button_image(b, col, images.button_base)
		kana.draw_glyph("hiragana", ">", b.x + 22 + 60, b.y + 24, 32, col)
		gui.draw_button_image(b, col, images.button_top)
		b.w = b.w - 60
		b.x = b.x + 60
		table.insert(status.buttons, b)

		-- Draw the level indicator.
		b = { x = 92, y = 50, r = 50 }
		scalex, scaley = gui.draw_button_image(b, color.level_ind, images.rbutton_base)
		kana.draw_text(user.level, 90, 40, 80, color.level_ind)
		kana.draw_text("level", 90, 64, 24, color.level_ind)
		if user.autolevel then
			kana.draw_text("auto", 90, 16, 24, color.level_ind)
		end
		gui.draw_button_image(b, color.level_ind, images.rbutton_top, scalex, scaley)

		-- Draw the show answer button.
		col = color.get_hover_color(status.button.name == "#answer", "alt")
		b = { x = lg.getWidth() - 40, y = 40, r = status.size * 0.5, name = "#answer" }
		scalex, scaley = gui.draw_button_image(b, col, images.rbutton_base)
		gui.draw_button_image(b, col, images.kanadrill, nil, nil, 0.56)
		gui.draw_button_image(b, col, images.rbutton_top, scalex, scaley)
		table.insert(status.buttons, b)

		-- Draw the back button.
		b = gui.draw_back(status.button.name == "#back")
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
	elseif status.submode == "show_answer" then
		local kanas = kana.all_test_kanas(user.level)

		gui.draw_page_no_head(util.color(0,40,100))

		status.buttons = kana.draw_table(status.kana_type, 140, 40, 580, 540, 26, color.kanatable, kanas, status.button.name)

		col = color.title
		if status.kana_type == "hiragana" then
			col = color.get_highlight_color(true, false, "alt")
			b = { x = 10, y = 70, w = 120, h = 380, name = "hiragana" }
			gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"hi","ra","ga","na"}, 86, "Hiragana", 40, hover, "hiragana")

			col = color.get_hover_color(status.button.name == "#switch_type")
			b = { x = lg.getWidth() - 340, y = 10, w = 250, h = 48, name = "#switch_type" }
			gui.draw_button(b, col, kana.katakana.ka.glyph, color.default_icon, images.button_base, 
				images.button_top, "Show Katakana", status.button.name == "#switch_type", 50)
			table.insert(status.buttons, b)
		elseif status.kana_type == "katakana" then
			col = color.get_highlight_color(true, false, "alt")
			b = { x = 10, y = 70, w = 120, h = 380, name = "katakana" }
			gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"ka","ta","ka","na"}, 86, "Katakana", 40, hover, "katakana")

			col = color.get_hover_color(status.button.name == "#switch_type")
			b = { x = lg.getWidth() - 340, y = 10, w = 250, h = 48, name = "#switch_type" }
			gui.draw_button(b, col, kana.katakana.ka.glyph, color.default_icon, images.button_base, 
				images.button_top, "Show Hiragana", status.button.name == "#switch_type", 50)
			table.insert(status.buttons, b)
		end
		
		-- Draw the back button.
		b = gui.draw_back(status.button.name == "#back")
		table.insert(status.buttons, b)
	end

	b = { x = lg.getWidth() - 58, y = lg.getHeight() - 58, w = 48, h = 48, name = "#sound" }
	if status.button.name == "#sound" then
		lg.setColor(60, 100, 255, 255);
	else
		lg.setColor(60, 100, 255, 25);
	end
	if user.sound == true then
		lg.draw(images.sound, b.x, b.y, 0, 0.8, 0.8)
	else
		lg.draw(images.nosound, b.x, b.y, 0, 0.8, 0.8)
	end
	table.insert(status.buttons, b)
end

return M

