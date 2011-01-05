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
		local f = lg.newFont(size, "Tuffy.ttf") -- http://tulrich.com/fonts/ Thatcher Ulrich
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

function M.contains(t, o)
	if t[o] ~= nil then
		return true
	end

	for k,v in pairs(t) do
		if v == o then
			return true
		end
	end
	return false;
end

function M.scramble(t)
	local t2 = {}
	local pos
	while #t > 0 do
		pos = math.random(1,#t)
		table.insert(t2, t[pos]);
		table.remove(t, pos)
	end
	return t2
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

function M.indent(s, ind)
	local ret = ""
	for i=0,ind do
		ret = ret.."\t"
	end
	return ret..s
end

local function serialize_indent(o, i)
	if type(o) == "number" then
		return o
	elseif type(o) == "string" then
		return string.format("%q", o)
	elseif type(o) == "boolean" then
		if o then
			return "true"
		else
			return "false"
		end
	elseif type(o) == "table" then
	
		local has_table = false
		for k,v in pairs(o) do
			if type(v) == "table" then
				has_table = true
				break
			end
		end
	
		local tnl, ind
		if has_table then
			tnl = "\n"
			ind = M.indent("", i + 1)
		else
			tnl = " "
			ind = ""
		end
		
		local ret = "{"..tnl
		for k,v in pairs(o) do
			local k2 = k
			if type(k) == "string" then
				k2 = "[\""..k2.."\"]"
			end
			ret = ret..ind..k2.." = "..serialize_indent(v, i + 1)..","..tnl
		end

		if has_table then
			ret = ret..M.indent("}", i)
		else
			ret = ret.."}"
		end
		return ret
	else
		error("cannot serialize a " .. type(o))
	end
end

function M.serialize(o)
	return serialize_indent(o, 0)
end

function M.print_table(t)
	if t ~= nil then
		local i = 0
		for k,v in pairs(t) do
			print(k, "=>", v)
			i = i + 1
		end
		if i == 0 then
			print("empty")
		end
	else
		print("nil")
	end
end

function M.num_keys(t)
	local i = 0
	for k,v in pairs(t) do
		i = i + 1
		--print(k, v)
	end
	return i
end

return M

