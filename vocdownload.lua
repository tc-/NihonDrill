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

local remote_voc_list = nil

function M.init(data)
	print("vocdownload.init()", data)
	status = data.status
	user = data.user
end

function M.show()
	print("vocdownload.show()")
	if remote_voc_list == nil then
		remote_voc_list = vocabulary.get_server_voc_list()
	end
	
--	local voc = vocabulary.download_voc({ id="Colors" })
--	
--	if voc ~= nil then
--		table.insert(vocabulary.vocabularies, voc)
--	end
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
		change_view("vocoptions")
	end
end

function M.draw()
	local i, col, b, selected, hover

	gui.draw_page("Download online vocabularies", util.color(0,100,10), util.color(0,0,0), images.vocabulary)

	kana.draw_text("Vocabulary", 24, 90, 60, color.header, "tl")

	for i, voc in ipairs(remote_voc_list) do
		selected = status.vocabulary == voc
		hover = status.button.name == voc.name
		col = color.get_highlight_color(selected, hover)
		b = { x = 50, y = 110 + (i * 32), w = 100, h = 30, name = voc.name }
		kana.draw_text(voc.name, b.x, b.y, 50, col, "tl")
		table.insert(status.buttons, b)
	end

	hover = status.button.name == "#download"
	col = color.get_hover_color(hover, "alt")
	b = { x = lg.getWidth() - 270, y = lg.getHeight() - 68, w = 260, h = 60, name = "#download" }
	gui.draw_button(b, col, images.download, color.back_icon, images.button_base, 
		images.button_top, "Download", hover, 50)
	table.insert(status.buttons, b)

	-- Draw the back button.
	b = gui.draw_back(status.button.name == "#back")
	table.insert(status.buttons, b)

	for k,v in pairs(parts) do
		gui.draw_part(v)
	end
end

return M

