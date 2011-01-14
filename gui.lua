
local M = {}

local lg = love.graphics
local kana = require("kana")
local util = require("util")
local color = require("color")
local images = require("images")

function M.draw_button(b, col, icon, icon_col, base_image, top_image, text, hover, text_size)
	local scalex = b.w / base_image:getWidth()
	local scaley = b.h / base_image:getHeight()
	local icon_scale = (b.h - 10) / icon:getWidth()
	local icon_w = icon:getWidth() * icon_scale

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, b.x, b.y, 0, scalex, scaley)

	lg.setColor(icon_col.r, icon_col.g, icon_col.b, 255)
	lg.draw(icon, b.x + 8, b.y + 6, 0, icon_scale, icon_scale)

	kana.draw_text(text, b.x + icon_w + ((b.w - icon_w) * 0.5), b.y + (b.h * 0.5), text_size, col)

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(top_image, b.x, b.y, 0, scalex, scaley)
end

function M.draw_kana_button(b, col, base_image, top_image, kana_text, kana_text_size, text, text_size, hover, kana_type)
	local scalex = b.w / base_image:getWidth()
	local scaley = b.h / base_image:getHeight()

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, b.x, b.y, 0, scalex, scaley)

	kana.print_kana(kana_text, b.x + (kana_text_size *0.7), b.y + (kana_text_size * 0.6), kana_text_size, col, kana_type)
	kana.draw_text(text, b.x + (b.w * 0.5), b.y + b.h - (text_size * 0.4), text_size, col)

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(top_image, b.x, b.y, 0, scalex, scaley)
end

function M.draw_vbutton_kana(b, col, base_image, top_image, vtext, vtext_size, htext, htext_size, hover, kana_type)
	local scalex = b.w / base_image:getWidth()
	local scaley = b.h / base_image:getHeight()
	local i, x, y

	x = b.x + (b.w * 0.5) + 4
	y = b.y + (vtext_size * 0.5) + 4

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, b.x, b.y, 0, scalex, scaley)

	for i, g in ipairs(vtext) do
		kana.draw_glyph(kana_type, g, x, y, vtext_size, col)
		y = y + (vtext_size * 0.9)
	end

	kana.draw_text(htext, x, b.y + b.h - (htext_size * 0.8), htext_size, col)

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(top_image, b.x, b.y, 0, scalex, scaley)
end

function M.draw_linear_gradient(x, y, w, h, scol, ecol, steps)
	local rd = (ecol.r - scol.r) / steps
	local gd = (ecol.g - scol.g) / steps
	local bd = (ecol.b - scol.b) / steps
	local ad = (ecol.a - scol.a) / steps
	local hd = h / steps
	
	for i = 0, steps do
		lg.setColor(scol.r + (rd * i), scol.g + (gd * i), scol.b + (bd * i), scol.a + (ad * i))
		lg.rectangle("fill", x, y + (i * hd), w, hd)
	end
end

function M.draw_page(text, title_col, page_col)
	local title_col_dark = color.set_brightness(color.copy_color(title_col), -50)
	local title_col_light = color.set_brightness(color.copy_color(title_col), 100)

	M.draw_linear_gradient(0, 0, lg.getWidth(), 78, title_col, title_col_dark, 18)
	M.draw_linear_gradient(0, 81, lg.getWidth(), lg.getHeight() - 80, page_col, util.color(100, 100, 100), 90)
	lg.setColor(200,200,200)
	lg.rectangle("fill", 0, 79, lg.getWidth(), 2)
	kana.draw_text(text, 20, 16, 90, title_col_light, "tl")
	lg.setColor(title_col_light.r, title_col_light.g, title_col_light.b, 255)
	lg.draw(images.button_top, -18, -4, 0, 2.16, 0.8)
end

function M.draw_back(hover)
	local col = color.get_hover_color(hover, "back")
	local b = { x = 10, y = lg.getHeight() - 58, w = 120, h = 48, name = "#back" }
	M.draw_button(b, col, images.back, color.back_icon, images.button_base, 
		images.button_top, "Back", hover, 50)
	return b
end

return M

