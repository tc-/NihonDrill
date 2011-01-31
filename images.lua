
local M = {}

local lg = love.graphics

function M.init()
	M.sound = lg.newImage("images/sound.png")
	M.nosound = lg.newImage("images/nosound.png")

	M.checked = lg.newImage("images/checked.png")
	M.unchecked = lg.newImage("images/unchecked.png")

	M.fullscreen = lg.newImage("images/fullscreen.png")
	M.windowed = lg.newImage("images/windowed.png")

	M.button_base = lg.newImage("images/button_base.png")
	M.button_top = lg.newImage("images/button_top.png")

	M.vbutton_base = lg.newImage("images/vbutton_base.png")
	M.vbutton_top = lg.newImage("images/vbutton_top.png")

	M.rbutton_base = lg.newImage("images/rbutton_base.png")
	M.rbutton_top = lg.newImage("images/rbutton_top.png")

	M.levels = lg.newImage("images/levels/level_27.png")

	-- 128x128 icons.
	M.kanadrill = lg.newImage("images/kanadrill.png")
	M.vocabulary = lg.newImage("images/vocabulary.png")

	-- 64x64 icons.
	M.quit = lg.newImage("images/quit.png")
	M.credits = lg.newImage("images/credits.png")
	M.arrow = lg.newImage("images/arrow.png")
	M.back = M.arrow
	M.download = lg.newImage("images/download.png")
end


return M

