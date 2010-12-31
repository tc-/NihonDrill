local M = {}

local voc_files = { "jpfbp1" }

M.vocabularies = {}

function M.init()
	print("vocabulary.init()")
	for i, voc_file in ipairs(voc_files) do
		print("vocabulary.load", voc_file)
		local voc = require("voc/"..voc_file)
		if voc ~= nil then
			print("vocabulary.loaded", voc.name)
			table.insert(M.vocabularies, voc)
		else
			print("vocabulary.load failed", voc_file)
		end
	end
end

return M

