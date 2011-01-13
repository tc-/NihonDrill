
local M = {}

local lg = love.graphics
local kana = require("kana")

function M.draw_button(b, col, icon, icon_col, base_image, top_image, text, hover, text_size)
	local scalex = b.w / base_image:getWidth()
	local scaley = b.h / base_image:getHeight()
	local icon_scale = (b.h - 10) / icon:getWidth()
	local icon_w = icon:getWidth() * icon_scale

	lg.setColor(col.r, col.g, col.b, 255)
	lg.draw(base_image, b.x, b.y, 0, scalex, scaley)

	lg.setColor(icon_col.r, icon_col.g, icon_col.b, 255)
	lg.draw(icon, b.x + 12, b.y + 4, 0, icon_scale, icon_scale)

	kana.draw_text(text, b.x + icon_w + ((b.w - icon_w) * 0.5), b.y + (b.h * 0.5), text_size, col)

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

return M

