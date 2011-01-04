
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

function M.init(util)
	M.active = util.color(70, 255, 100)
	M.hover = util.color(180, 255, 180)
	M.disabled = util.color(70, 70, 100)
	M.disabled_hover = util.color(100, 200, 120)
	M.header = util.color(80, 200, 255)
	M.title = util.color(80, 200, 255)

	M.alt = util.color(0, 40, 80)
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

