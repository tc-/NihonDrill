
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

function M.show()
end

function M.mousepressed(x, y, button)
	if status.button.name == "#back" then
		change_view("mainmenu")
	end
end

local parts = {}

function M.update(dt, mx, my)
	gui.update_credits_parts(dt, parts, 16)
end

function M.draw()
	local b
	local basey = 100
	gui.draw_page("Credits", color.credits, util.color(0, 0, 0), images.credits)

	for k,v in pairs(parts) do
		gui.draw_part(v)
	end

	kana.draw_text("Programming", 30, basey, 70, color.credits_what, "tl")
	kana.draw_text("Tommy Carlsson (tommyc@lavabit.com)", 60, basey + 50, 50, color.credits_name, "tl")

	kana.draw_text("Ideas and insperation", 30, basey + 100, 70, color.credits_what, "tl")
	kana.draw_text("Timothy and Rhawnie Carlsson", 60, basey + 150, 50, color.credits_name, "tl")

	kana.draw_text("Other", 30, basey + 200, 70, color.credits_what, "tl")
	kana.draw_text("Tuffy Font: Thatcher Ulrich (http://tulrich.com/fonts/)", 60, basey + 250, 50, color.credits_name, "tl")
	kana.draw_text("Sound files: http://thejapanesepage.com/", 60, basey + 300, 50, color.credits_name, "tl")

	b = gui.draw_back(status.button.name == "#back")
	table.insert(status.buttons, b)
end

return M

