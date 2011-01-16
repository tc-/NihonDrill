local M = {}

local lg = love.graphics
local la = love.audio

local vocabulary = require("vocabulary")

local util = require("util")
local kana = require("kana")
local images = require("images")
local color = require("color")
local gui = require("gui")

local status = nil
local user = nil

function M.init(data)
	print("vocoptions.init()", data)
	status = data.status
	user = data.user

	vocabulary.init()

	if status.vocabulary == nil then
		if user.vocabulary_name ~= nil then
			for i,v in ipairs(vocabulary.vocabularies) do
				if v.name == user.vocabulary_name then
					status.vocabulary = v
				end
			end
		end

		if status.vocabulary == nil then
			status.vocabulary = vocabulary.vocabularies[1]

			user.vocabulary_name = status.vocabulary.name
			user.vocabulary_level = 1
		end
	end
end

function M.show()
	print("vocoptions.show()")
end

local parts = {}

function M.update(dt, mx, my)
	gui.update_kana_parts(dt, parts, 11, "both", 16)
end

function M.mousepressed(x, y, button)
	local i

	set_parts_pos(parts, x - 16, y - 16)

	for i=1,#vocabulary.vocabularies,1 do
		local voc = vocabulary.vocabularies[i]
		if status.button.name == voc.name then
			status.vocabulary = voc
			user.vocabulary_name = status.vocabulary.name
			user.vocabulary_level = 1
		end
	end

	if status.button.name == "hajime" then
		if status.vocabulary ~= nil then
			change_view("voctrain")
		end
	elseif type(status.button.name) == "number" then
		user.vocabulary_level = status.button.name
	elseif status.button.name == "#back" then
		change_view("mainmenu")
	end
end

function M.draw()
	local i
	local col

	gui.draw_page("Select what to practice", util.color(0,100,10), util.color(0,0,0), images.vocabulary)

	kana.draw_text("Vocabulary", 24, 90, 60, color.header, "tl")

	for i=1,#vocabulary.vocabularies,1 do
		local voc = vocabulary.vocabularies[i]

		selected = status.vocabulary == voc
		hover = status.button.name == voc.name
		col = color.get_highlight_color(selected, hover)
		b = { x = 50, y = 110 + (i * 32), w = 100, h = 30, name = voc.name }
		kana.draw_text(voc.name, b.x, b.y, 50, col, "tl")
		table.insert(status.buttons, b)
	end

	-- Draw the start button.
	selected = status.vocabulary ~= nil
	hover = status.button.name == "hajime" and selected
	col = color.get_highlight_color(selected, hover)
	b = { x = lg.getWidth() - 170, y = lg.getHeight() - 90, w = 160, h = 80, name = "hajime" }
	gui.draw_kana_button(b, col, images.button_base, images.button_top, {"ha","ji","me"}, 46, "Start", 46, hover, "hiragana")
	table.insert(status.buttons, b)

	kana.draw_text("Level", 390, 90, 60, color.header, "tl")

	if status.vocabulary ~= nil then
		local basex = 380
		local basey = 130
		local cols = 5
		local colu = 0
		local row = 0

		for i=1,#status.vocabulary.levels,1 do
			if colu >= cols then
				colu = 0
				row = row + 1
			end
			colu = colu + 1
		
			b = { x = basex + (colu*48), y = basey + (row*48), w = 48, h = 48, name = i }

			selected = user.vocabulary_level == i
			hover = status.button.name == i
			col = color.get_highlight_color(selected, hover)
			kana.draw_text(i, b.x + 24, b.y + 24, 60, col)
			table.insert(status.buttons, b)
		end
	end

	-- Draw the back button.
	b = gui.draw_back(status.button.name == "#back")
	table.insert(status.buttons, b)

	for k,v in pairs(parts) do
		gui.draw_part(v)
	end
end

return M


