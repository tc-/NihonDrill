
local M = {}

local lg = love.graphics
local kana = require("kana")
local util = require("util")
local color = require("color")
local images = require("images")

function M.draw_button_image(b, col, button_image, scalex, scaley)
	if scalex == nil or scaley == nil then
		if b.r == nil then
			scalex = b.w / button_image:getWidth()
			scaley = b.h / button_image:getHeight()
		else
			scalex = (b.r * 2) / button_image:getWidth()
			scaley = (b.r * 2) / button_image:getHeight()
		end
	end

	lg.setColor(col.r, col.g, col.b, col.a)
	if b.r == nil then
		lg.draw(button_image, b.x, b.y, 0, scalex, scaley)
	else
		lg.draw(button_image, b.x - b.r, b.y - b.r, 0, scalex, scaley)
	end

	return scalex, scaley
end

function M.draw_button(b, col, icon, icon_col, base_image, top_image, text, hover, text_size)
	local icon_scale = (b.h - 10) / icon:getWidth()
	local icon_w = icon:getWidth() * icon_scale

	local scalex, scaley = M.draw_button_image(b, col, base_image)

	lg.setColor(icon_col.r, icon_col.g, icon_col.b, 255)
	lg.draw(icon, b.x + 8, b.y + 6, 0, icon_scale, icon_scale)

	kana.draw_text(text, b.x + icon_w + ((b.w - icon_w) * 0.5), b.y + (b.h * 0.5), text_size, col)

	M.draw_button_image(b, col, top_image)
end

function M.draw_kana_button(b, col, base_image, top_image, kana_text, kana_text_size, text, text_size, hover, kana_type)
	local scalex, scaley = M.draw_button_image(b, col, base_image)

	kana.print_kana(kana_text, b.x + (kana_text_size *0.7), b.y + (kana_text_size * 0.6), kana_text_size, col, kana_type)
	kana.draw_text(text, b.x + (b.w * 0.5), b.y + b.h - (text_size * 0.4), text_size, col)

	M.draw_button_image(b, col, top_image, scalex, scaley)
end

function M.draw_vbutton_kana(b, col, base_image, top_image, vtext, vtext_size, htext, htext_size, hover, kana_type)
	local i, x, y
	local scalex, scaley

	scalex, scaley = M.draw_button_image(b, col, base_image)

	x = b.x + (b.w * 0.5) + 4
	y = b.y + (vtext_size * 0.5) + 4

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, b.x, b.y, 0, scalex, scaley)

	for i, g in ipairs(vtext) do
		kana.draw_glyph(kana_type, g, x, y, vtext_size, col)
		y = y + (vtext_size * 0.9)
	end

	kana.draw_text(htext, x, b.y + b.h - (htext_size * 0.8), htext_size, col)

	M.draw_button_image(b, col, top_image, scalex, scaley)
end

function M.draw_rbutton_kana(b, col, base_image, top_image, k, size, hover, kana_type)
	local i, x, y
	local scalex, scaley

	scalex, scaley = M.draw_button_image(b, col, base_image)

	x = b.x - b.r
	y = b.y - b.r

	kana.draw_glyph(kana_type, k, x + b.r, y + b.r, size, col)

	M.draw_button_image(b, col, top_image, scalex, scaley)
end

function M.draw_rbutton_text(b, col, base_image, top_image, text, size, hover)
	local i, x, y
	local scalex, scaley

	scalex, scaley = M.draw_button_image(b, col, base_image)

	x = b.x - b.r
	y = b.y - b.r

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, x, y, 0, scalex, scaley)

	kana.draw_text(text, x + b.r, y + b.r, size, col)

	M.draw_button_image(b, col, top_image, scalex, scaley)
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

function M.draw_page(text, title_col, page_col, icon)
	local title_col_dark = color.set_brightness(color.copy_color(title_col), -50)
	local title_col_light = color.set_brightness(color.copy_color(title_col), 100)

	M.draw_linear_gradient(0, 0, lg.getWidth(), 78, title_col, title_col_dark, 18)
	M.draw_linear_gradient(0, 81, lg.getWidth(), lg.getHeight() - 80, page_col, util.color(100, 100, 100), 90)
	lg.setColor(200,200,200)
	lg.rectangle("fill", 0, 79, lg.getWidth(), 2)
	kana.draw_text(text, 20, 16, 90, title_col_light, "tl")
	
	if icon ~= nil then
		local icon_scale = (70) / icon:getWidth()
		local icon_w = icon:getWidth() * icon_scale
		lg.setColor(255,255,255)
		lg.draw(icon, lg.getWidth() - icon_w - 5, 5, 0, icon_scale, icon_scale)
	end
	
	lg.setColor(title_col_light.r, title_col_light.g, title_col_light.b, 255)
	lg.draw(images.button_top, -18, -4, 0, 2.16, 0.8)
end

function M.draw_page_no_head(page_col)
	M.draw_linear_gradient(0, 0, lg.getWidth(), lg.getHeight(), page_col, util.color(100, 100, 100), 90)
end

function M.draw_back(hover)
	local col = color.get_hover_color(hover, "back")
	local b = { x = 10, y = lg.getHeight() - 58, w = 120, h = 48, name = "#back" }
	M.draw_button(b, col, images.back, color.back_icon, images.button_base, 
		images.button_top, "Back", hover, 50)
	return b
end


function M.make_part(img)
	local ret = { c = 0, sv = 0, cv = 0 }

	ret.img = img

	if math.random(0,1) == 1 then
		ret.x = -80
		ret.dx = math.random(20,60)
	else
		ret.x = lg.getWidth() + 80
		ret.dx = -math.random(20,60)
	end

	if math.random(0,1) == 1 then
		ret.y = -80
		ret.dy = math.random(20,60)
	else
		ret.y = lg.getWidth() + 80
		ret.dy = -math.random(20,60)
	end

	ret.s = math.random(1,3) * 0.1
	ret.cf = math.random(15,20)
	ret.cx = math.random(0,40) - 20
	ret.cy = math.random(0,40) - 20

	return ret
end

function M.update_part(p, dt)
	local f
	p.c = p.c + dt
	if p.c > math.pi * 2 then
		p.c = p.c - math.pi * 2
	end
	p.sv = math.sin(p.c) * p.cf
	p.cv = math.cos(p.c) * p.cf
	p.x = p.x + (p.dx * dt)
	p.y = p.y + (p.dy * dt)
end

function M.draw_part(p)
	lg.setColor(255, 255, 255, 50)
	lg.draw(p.img, p.x + (p.cv * p.cx), p.y + (p.sv * p.cy), 0, p.s, p.s)
end

function M.update_kana_parts(dt, parts, level, kana_types, num_parts)
	local w = lg.getWidth()
	local h = lg.getHeight()
	local remove = {}

	for i,v in pairs(parts) do
		M.update_part(v, dt)
		if (v.x < -140) or (v.x > w + 100) or (v.y < -140) or (v.y > h + 100) then
			table.insert(remove ,i)
		end
	end

	for k,v in pairs(remove) do
		table.remove(parts, v)
	end

	local kanas, img

	while #parts < num_parts do
		if kanas == nil then
			kanas = kana.all_test_kanas(level)
 		end
		if (kana_types == "hiragana") or ((kana_types == "both") and (math.random(0,1) == 1)) then
			img = kana.hiragana[kanas[math.random(1, #kanas)]].glyph
		else
			img = kana.katakana[kanas[math.random(1, #kanas)]].glyph
		end
		table.insert(parts, M.make_part(img))
	end
end

function M.update_credits_parts(dt, parts, num_parts)
	local w = lg.getWidth()
	local h = lg.getHeight()
	local remove = {}

	for i,v in pairs(parts) do
		M.update_part(v, dt)
		if (v.x < -140) or (v.x > w + 100) or (v.y < -140) or (v.y > h + 100) then
			table.insert(remove ,i)
		end
	end

	for k,v in pairs(remove) do
		table.remove(parts, v)
	end

	while #parts < num_parts do
		local part = M.make_part(images.credits)
		part.s = part.s * 2.0
		table.insert(parts, part)
	end
end

return M

