
local M = {}

local util = require("util")

local lg = love.graphics
local la = love.audio

M.hiragana = { }
M.katakana = { }

M.layout = {
	{   "a",   "i",   "u",   "e",   "o" },
	{  "ka",  "ki",  "ku",  "ke",  "ko" },
	{  "sa", "shi",  "su",  "se",  "so" },
	{  "ta", "chi", "tsu",  "te",  "to" },
	{  "na",  "ni",  "nu",  "ne",  "no" },
	{  "ha",  "hi",  "fu",  "he",  "ho" },
	{  "ma",  "mi",  "mu",  "me",  "mo" },
	{  "ya",         "yu",         "yo" },
	{  "ra",  "ri",  "ru",  "re",  "ro" },
	{  "wa",                       "wo" },
	{                 "n"               },
	
	{  "ga",  "gi",  "gu",  "ge",  "go" },
	{  "za",  "ji",  "zu",  "ze",  "zo" },
	{  "da",  "di",  "du",  "de",  "do" },
	{  "ba",  "bi",  "bu",  "be",  "bo" },
	{  "pa",  "pi",  "pu",  "pe",  "po" },
	
	{ "kya",        "kyu",        "kyo" },
	{ "sha",        "shu",        "sho" },
	{ "cha",        "chu",        "cho" },
	{ "nya",        "nyu",        "nyo" },
	{ "hya",        "hyu",        "hyo" },
	{ "mya",        "myu",        "myo" },
	{ "rya",        "ryu",        "ryo" },
	
	{ "gya",        "gyu",        "gyo" },
	{  "ja",         "ju",         "jo" },
	{ "bya",        "byu",        "byo" },
	{ "pya",        "pyu",        "pyo" }
}

M.special = {
	["~"] = { str = "cont" },
	["-"] = { str = "long" },
	["?"] = { str = "q" },
}

M.sounds = { }


function M.all_test_kanas(level)
	local t = {}

	for i, set in ipairs(M.layout) do

		if level < i then
			break;
		end

		for i1, k in ipairs(set) do
			table.insert(t, k)
		end

	end

	return t
end

function M.generate_question(level, last, num_alt, user_kana_types)
	local kanas = M.all_test_kanas(level)
	local selected = kanas[math.random(1, #kanas)]
	while selected == last do
		selected = kanas[math.random(1, #kanas)]
	end
	
	util.remove_object(kanas, selected)
	
	local i = 0
	local alts = { }
	while i < num_alt - 1 do
		print("#kanas", #kanas)
		local alt = kanas[math.random(1, #kanas)]
		util.remove_object(kanas, alt)
		table.insert(alts, alt)
		i = i + 1
	end
	
	local pos = math.random(1, num_alt)
	table.insert(alts, pos, selected)
	
	local kana_type = user_kana_types
	if user_kana_types == "both" then
		if math.random(1,2) == 1 then
			kana_type = "hiragana"
		else
			kana_type = "katakana"
		end
	end
	
	return selected, alts, kana_type
end

function M.init()

	for i, row in ipairs(M.layout) do
		for n, k in ipairs(row) do
			if k ~= nil then
				print("love.load", k)
				M.hiragana[k] = {}
				M.katakana[k] = {}
				M.hiragana[k].glyph = lg.newImage("images/hiragana/"..k..".png")
				M.katakana[k].glyph = lg.newImage("images/katakana/"..k..".png")
				M.sounds[k] = la.newSource("sound/"..k..".mp3", "static")
			end
		end
	end
	
	for k, v in pairs(M.special) do
		print("love.load special", v.str)
		v.glyph = lg.newImage("images/special/"..v.str..".png")
	end
	
end

function M.draw_glyph_bg(x, y, size, col)
	lg.setColor(col.r, col.g, col.b, 40)
	lg.circle("fill", x, y, size / 1.6, size * 0.4)
	lg.setColor(col.r, col.g, col.b, 80)
	lg.setLineWidth(3)
	lg.circle("line", x, y, size / 1.6, size * 0.4)
end

function M.draw_glyph(kana_type, glyph, x, y, size, col, auto_scaling)
	local img = M[kana_type][glyph]
	size = size or 100

	if auto_scaling == nil then
		auto_scaling = true
	end

	if img == nil then
		img = M.special[glyph]
		if img ~= nil then
			img = img.glyph
		end
	else
		img = img.glyph
	end
	
	if img ~= nil then
		lg.setColor(0,0,0,100)
		local scale
		if auto_scaling == true then
			scale = size / img:getWidth()
		else
			scale = size / img:getHeight()
		end
		lg.draw(img, x - (size / 2) + (size * 0.04), y - ((img:getHeight() * scale) / 2) - (size * 0.04), 0, scale, scale, 0.5, 0.5)
		lg.setColor(col.r, col.g, col.b)
		lg.draw(img, x - (size / 2), y - ((img:getHeight() * scale) / 2), 0, scale, scale, 0.5, 0.5)
	end
end

function M.draw_text(text, x, y, size, col, align)

	align = align or "c"
	local len = string.len(text)
	if len == 0 then
		return
	end

	size = size * 0.5
	local f = util.get_font(math.floor(size))
	lg.setFont(f)

	local w = f:getWidth(text)
	local h = f:getHeight()

	lg.setColor(0,0,0,100)
	if align == "c" then
		lg.print(text, x - (w * 0.5) + (h * 0.04), y - (h * 0.64))
		lg.setColor(col.r, col.g, col.b)
		lg.print(text, x - (w * 0.5), y - (h * 0.6))
	elseif align == "tl" then
		lg.print(text, x + (size * 0.04), y - (size * 0.04))
		lg.setColor(col.r, col.g, col.b)
		lg.print(text, x, y)
	end
end

function M.draw_kana_romaji(kana_type, kana, x, y, size, col)
	M.draw_glyph_bg(x, y, size * 1.5, col)
	M.draw_glyph(kana_type, kana, x, y - (size * 0.4), size, col)
	M.draw_text(kana, x, y + (size * 0.6), size, col)
end

function M.print_hiragana(text, x, y, size, col)
	M.print_kana(text, x, y, size, col, "hiragana")
end

function M.print_kana(text, x, y, size, col, kana_type)
	r = r or 0
	g = g or 0
	b = b or 0
	for i, k in ipairs(text) do
		M.draw_glyph(kana_type, k, x, y, size, col, false)
		if (string.len(k) > 2 and k ~= "shi" and k ~= "chi" and k ~= "tsu") or k == "ja" or k == "ju" or k == "jo" then
			x = x + (size * 1.5)
		else
			x = x + size
		end
	end
end

function M.draw_table(kana_type, basex, basey, size, selected)
	
	local text_size = size / 5
	local buttons = { }
	
	for ri, row in ipairs(M.layout) do
		
		for ci, l in ipairs(row) do
			
			b = { x = basex + (i2*48), y = basey + (i*48), w = 48, h = 48, name = l }

			if user.level == l then
				if status.button == l then
					col = util.color(180, 255, 180)
				else
					col = util.color(70, 255, 100)
				end
			else
				if status.button == l then
					col = util.color(100, 200, 120)
				else
					col = util.color(70, 70, 100)
				end
			end
			
			if kana_type == "romaji" then
				M.draw_text(l, b.x + 24, b.y + 24, 60, col)
			else
				M.draw_glyph(kana_type, l, b.x, b.y, text_size, col)
			end
			table.insert(buttons, b)
		
		end
		
	end
	
	return buttons
end

return M




