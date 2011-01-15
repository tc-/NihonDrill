
local M = {}


function M.get_highlight_color(is_selected, is_hovering, variant)
	variant = variant or "text"
	if is_selected then
		if is_hovering then
			return M.variants[variant].hover
		else
			return M.variants[variant].active
		end
	else
		if is_hovering then
			return M.variants[variant].disabled_hover
		else
			return M.variants[variant].disabled
		end
	end
end

function M.get_hover_color(is_hovering, variant)
	variant = variant or "text"
	if is_hovering then
		return M.variants[variant].hover
	else
		return M.variants[variant].active
	end
end

function M.set_brightness(col, delta)
	col.r = col.r + delta
	col.g = col.g + delta
	col.b = col.b + delta
	if delta > 0 then
		if col.r > 255 then col.r = 255 end
		if col.g > 255 then col.g = 255 end
		if col.b > 255 then col.b = 255 end
	else
		if col.r < 0 then col.r = 0 end
		if col.g < 0 then col.g = 0 end
		if col.b < 0 then col.b = 0 end
	end
	return col
end

function M.copy_color(col)
	return { r = col.r, g = col.g, b = col.b, a = col.a }
end

function M.init(util)
	M.active = util.color(70, 255, 100)
	M.hover = util.color(180, 255, 180)
	M.disabled = util.color(70, 70, 100)
	M.disabled_hover = util.color(100, 200, 120)
	M.drill_opt_header = util.color(140, 140, 140)
	M.header = util.color(140, 140, 140)
	M.title = util.color(80, 200, 255)
	M.default_icon = util.color(255, 255, 255)

	M.credits = util.color(255, 220, 0)

	M.back_icon = util.color(140, 200, 255)

	M.credits_what = util.color(140, 100, 0)
	M.credits_name = util.color(200, 180, 0)

	M.alt = util.color(80, 130, 200)
	M.alt_hover = util.color(140, 200, 255)
	M.alt_disabled = util.color(20, 20, 20)
	M.alt_disabled_hover = util.color(10, 50, 90)

	M.alt_question = util.color(140, 200, 255)
	M.level_ind = util.color(140, 200, 255)

	M.variants = {}
	M.variants.text = {}
	M.variants.text.active = M.active
	M.variants.text.hover = M.hover
	M.variants.text.disabled = M.disabled
	M.variants.text.disabled_hover = M.disabled_hover

	M.variants.alt = {}
	M.variants.alt.active = M.alt
	M.variants.alt.hover = M.alt_hover
	M.variants.alt.disabled = M.alt_disabled
	M.variants.alt.disabled_hover = M.alt_disabled_hover

	M.variants.button = {}
	M.variants.button.active = M.alt_hover
	M.variants.button.hover = util.color(200, 240, 255)
	M.variants.button.disabled = M.alt_disabled
	M.variants.button.disabled_hover = M.alt_disabled_hover

	M.variants.quit = {}
	M.variants.quit.active = util.color(60, 60, 80)
	M.variants.quit.hover = util.color(255, 80, 80)

	M.variants.credits = {}
	M.variants.credits.active = util.color(60, 60, 80)
	M.variants.credits.hover = M.credits

	M.variants.back = {}
	M.variants.back.active = util.color(60, 60, 80)
	M.variants.back.hover = util.color(100, 100, 150)

	M.kanatable = {}
	M.kanatable.text = util.color(60, 60, 80)
	M.kanatable.bg = util.color(100, 160, 200)
	M.kanatable.frame = util.color(180, 200, 255)
	
	M.kanatable.text_sel = util.color(220, 220, 255)
	M.kanatable.bg_sel = util.color(80, 140, 255)
	M.kanatable.frame_sel = util.color(140, 255, 180)
	
	M.kanatable.text_hover = util.color(255, 255, 255)
	M.kanatable.bg_hover = util.color(100, 170, 255)
	M.kanatable.frame_hover = util.color(255, 255, 255)
end

return M

