
local M = {}

local lg = love.graphics
local la = love.audio

local util = require("util")
local kana = require("kana")
local images = require("images")
local color = require("color")
local gui = require("gui")

local status = nil
local user = nil

function M.init(data)
	status = data.status
	user = data.user
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
	local words = all_words(user.vocabulary_level, status.vocabulary, false)
	local alts = {}
	local word
	
	if #status.word_queue == 0 then
		status.word_queue = util.scramble(all_words(user.vocabulary_level, status.vocabulary, false))
	end
	
	if #words < user.alternatives then
		user.alternatives = #words
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
	status.word_queue = all_words(user.vocabulary_level, status.vocabulary, true)
	next_question()
	status.submode = "answer"
end

function M.mousepressed(x, y, button)

	if status.submode == "answer" then
		if status.button.name == nil or status.button.name == "" then
			return
		end
		
		if status.button.name == "#back" then
			change_view("vocoptions")
		else
			if status.button.name == status.word.eng then
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
		gui.draw_page("What does this mean?", util.color(0,110,255), util.color(140, 200, 255), images.vocabulary)

		if #status.word.kana < 10 then
			kana.print_kana(status.word.kana, 100, 120, 70, util.color(250,250,250), status.word.kana_type)
		else
			kana.print_kana(status.word.kana, 100, 120, 50, util.color(250,250,250), status.word.kana_type)
		end

		for i, alt in ipairs(status.alternatives) do
			if status.button.name == alt.eng then
				col = util.color(100, 200, 120)
			else
				col = util.color(70, 70, 100)
			end
			b = { x = 120, y = 130 + (i * 48), w = 800, h = 40, name = alt.eng }
			kana.draw_text(alt.eng, b.x, b.y, 50, col, "tl")
			table.insert(status.buttons, b)
		end
		
		-- Draw the back button.
		b = gui.draw_back(status.button.name == "#back")
		table.insert(status.buttons, b)
	elseif status.submode == "answer_correct" then
		gui.draw_page_no_head(util.color(50,255,100))

		col = color.get_highlight_color(true, false)
		b = { x = lg.getWidth() - 150, y = lg.getHeight() - 250, w = 140, h = 240, name = "hai" }
		gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"ha","i"}, 100, "", 40, hover, "hiragana")

		col = util.color(0, 120, 0)
		if #status.word.kana < 10 then
			kana.print_kana(status.word.kana, 100, 120, 70, col, status.word.kana_type)
		else
			kana.print_kana(status.word.kana, 100, 120, 50, col, status.word.kana_type)
		end
		
		kana.draw_text(status.word.eng, 120, 160, 50, col, "tl")
		
	elseif status.submode == "answer_wrong" then
		gui.draw_page_no_head(util.color(255,50,50))

		local w = lg.getWidth()
		col = color.get_highlight_color(true, true, "quit")
		b = { x = lg.getWidth() - 150, y = lg.getHeight() - 250, w = 140, h = 240, name = "dame" }
		gui.draw_vbutton_kana(b, col, images.vbutton_base, images.vbutton_top, {"da","me"}, 100, "", 40, hover, "hiragana")

		col = color.get_hover_color(false, "back")
		b = { x = 10, y = lg.getHeight() - 74, w = 300, h = 64, name = "#back" }
		gui.draw_button(b, col, images.back, color.default_icon, images.button_base, 
			images.button_top, "Click to continue", false, 50)
		
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

