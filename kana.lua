
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
	["xtsu"] = { str = "xtsu" },
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
	for i, k in ipairs(text) do
	
		if k ~= string.upper(k) then
			M.draw_glyph(kana_type, k, x, y, size, col, false)
			if (string.len(k) > 2 and k ~= "shi" and k ~= "chi" and k ~= "tsu" and k ~= "xtsu") or k == "ja" or k == "ju" or k == "jo" then
				x = x + (size * 1.5)
			else
				x = x + size
			end
		else
			M.draw_text(k, x, y, size * 2.0, col)
			x = x + (size * 1.0)
		end
	end
end

function M.draw_table2(kana_type, basex, basey, size, selected)
	
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

function M.draw_table(kana_type, x, y, w, h, size, text_col, bg_col, frame_col, bg_sel_col, selected)
	
	local sw = w * 0.5
	local cw = w - sw - 10
	local posx = x
	local posy = y
	local buttons = {}
	
	selected = selected or {}
	
	for i, row in ipairs(M.layout) do
	
		local incnum = 1
		local kw = sw / 5
		local kh = h / 17
		
		if i >= 1 and i <= 11 then
			posy = y + ((i - 1) * kh);
			posx = x
			if i == 8 then
				incnum = 2
			elseif i == 10 then
				incnum = 4
			end
		elseif i >= 12 and i <= 16 then
			posy = y + ((i - 1) * kh) + kh;
			posx = x
		else
			kw = cw / 3
			posx = x + w - cw
			if i <= 22 then
				posy = y + ((i - 16) * kh);
			elseif i == 23 then
				posy = y + ((i - 14) * kh);
			elseif i >= 24 and i <= 25 then
				posy = y + ((i - 12) * kh);
			elseif i >= 26 and i <= 27 then
				posy = y + ((i - 11) * kh);
			end
		end
		
		for i2, glyph in ipairs(row) do
			b = { x = posx, y = posy, w = kw, h = kh, name = "kana_"..glyph }
			table.insert(buttons, b)
			
			if selected[glyph] ~= nil then
				lg.setColor(bg_sel_col.r, bg_sel_col.g, bg_sel_col.b, bg_sel_col.a)
			else
				lg.setColor(bg_col.r, bg_col.g, bg_col.b, bg_col.a)
			end
			lg.rectangle("fill", posx, posy, kw - 1, kh - 1)
			
			M.draw_glyph(kana_type, glyph, posx + (kw * 0.23), posy + (kh * 0.5), size, text_col, false)
			M.draw_text(glyph, posx + (kw * 0.56), posy + (size * 0.3), size, text_col, "tl")
			
			lg.setLineWidth(1)
			lg.setColor(frame_col.r, frame_col.g, frame_col.b, frame_col.a)
			lg.rectangle("line", posx, posy, kw - 1, kh - 1)

			posx = posx + (kw * incnum)
		end
	end
	
	return buttons
end

return M




