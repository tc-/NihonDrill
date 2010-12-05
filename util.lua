local M = { }

local lg = love.graphics

local fonts = { }

function M.color(cr, cg, cb)
	return { r = cr, g = cg, b = cb }
end

function M.get_font(size)
	if fonts[size] ~= nil then
		return fonts[size]
	else
		local f = lg.newFont(size)
		fonts[size] = f
		return f
	end
end

function M.remove_object(t, o)
	for i,v in ipairs(t) do
		if v == o then
			table.remove(t, i)
		end
	end
end

function M.distance_to(x1, y1, x2, y2)
	local dist = math.sqrt( math.pow(x2 - x1, 2) + math.pow(y2 - y1, 2) )
	return dist
end

function M.point_within(px, py, ax, ay, w, h)
	if px >= ax and px <= ax+w and py >= ay and py <= ay+h then
		return true
	else
		return false
	end
end

return M

