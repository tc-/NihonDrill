local M = {}

local lg = love.graphics
local la = love.audio

local vocabulary = require("vocabulary")

local status = nil
local user = nil
local util = nil
local kana = nil
local color = nil

function M.init(data)
	print("vocoptions.init()", data)
	status = data.status
	user = data.user
	util = data.util
	kana = data.kana
	color = data.color
	
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

function M.update(dt, mx, my)
	
end

function M.mousepressed(x, y, button)

	local i
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

	kana.draw_text("Select what to practice.", 20, 20, 90, color.title, "tl")

	kana.draw_text("Vocabulary", 24, 70, 60, color.header, "tl")

	for i=1,#vocabulary.vocabularies,1 do
		local voc = vocabulary.vocabularies[i]

		selected = status.vocabulary == voc
		hover = status.button.name == voc.name
		col = color.get_highlight_color(selected, hover)
		b = { x = 50, y = 100 + (i * 32), w = 100, h = 30, name = voc.name }
		kana.draw_text(voc.name, b.x, b.y, 50, col, "tl")
		table.insert(status.buttons, b)
	end

	selected = status.vocabulary ~= nil
	hover = status.button.name == "hajime" and selected
	col = color.get_highlight_color(selected, hover)
	b = { x = lg.getWidth() - 160, y = lg.getHeight() - 80, w = 148, h = 70, name = "hajime" }
	kana.print_hiragana({"ha","ji","me"}, b.x + 24, b.y + 24, 48, col)
	kana.draw_text("start", b.x + 70, b.y + 64, 48, col)
	table.insert(status.buttons, b)

	kana.draw_text("Level", 390, 70, 60, color.header, "tl")

	if status.vocabulary ~= nil then
		local basex = 380
		local basey = 110
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

	col = color.get_hover_color(status.button.name == "#back")
	b = { x = 20, y = lg.getHeight() - 40, w = 70, h = 28, name = "#back" }
	kana.draw_text("Back", b.x, b.y, 50, col, "tl")
	table.insert(status.buttons, b)
end

return M


