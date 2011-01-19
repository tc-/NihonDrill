local M = {}

local http = require("socket.http")
local util = require("util")

local voc_base_url = "http://localhost/"

M.vocabularies = {}

local function run_untrusted(untrusted_code)
	local untrusted_function, message = loadstring(untrusted_code)
	if not untrusted_function then return nil, message end
	setfenv(untrusted_function, {})
	return pcall(untrusted_function)
end

function M.validate_voc(voc, voc_id)
	local new_voc = {}
	if voc == nil then return false, "Voc is nil" end
	if type(voc) ~= "table" then return false, "Voc is not a table" end

	if voc.id == nil then return false, "Voc missing id" end
	if voc_id ~= nil and voc.id ~= voc_id then return false, "Ids does not correspond!" end
	if voc.name == nil then return false, "Voc missing name" end
	if voc.version == nil then return false, "Voc missing version" end
	if voc.author == nil then return false, "Voc missing author" end
	if voc.voc_type == nil then return false, "Voc missing voc_type" end
	new_voc.id = voc.id
	new_voc.name = voc.name
	new_voc.version = voc.version
	new_voc.author = voc.author
	new_voc.voc_type = voc.voc_type

	if voc.levels == nil then return false, "Voc missing levels" end
	if type(voc.levels) ~= "table" then return false, "Voc levels is not a table" end
	if #voc.levels <= 0 then return false, "Voc levels is empty" end
	new_voc.levels = {}

	for li, level in ipairs(voc.levels) do
		if level == nil then return false, "Level "..li.." is nil" end
		if type(level) ~= "table" then return false, "Level "..li.." is not a table" end
		if #level <= 0 then return false, "Level "..li.." is empty" end

		local new_level = {}

		for wi, word in ipairs(level) do
			if word == nil then return false, "Word "..wi.." in level "..li.." is nil" end
			if type(word) ~= "table" then return false, "Word "..wi.." in level "..li.." is not a table" end
			
			if word.kana == nil then return false, "Word "..wi.." in level "..li.." is missing kana param" end
			if word.eng == nil then return false, "Word "..wi.." in level "..li.." is missing eng param" end
			if word.kana_type == nil then return false, "Word "..wi.." in level "..li.." is missing kana_type param" end
			
			table.insert(new_level, { kana = word.kana, eng = word.eng, kana_type = word.kana_type })
		end
		table.insert(new_voc.levels, new_level)
	end

	return true, new_voc
end

function M.get_server_voc_list()
	local b, c = http.request(voc_base_url.."nihondrill/vocabularies.txt")
	local list
	print("get_server_voc_list", b, c)
	
	if b ~= nil and c == 200 then
		list = {}
		local lines = util.split(b, "\n")
		for li, line in ipairs(lines) do
			print("get_server_voc_list", "line", line)
			local params = util.split(line, ";;")
			if #params >= 5 then
				table.insert(list, { id = params[1], version = params[2], name = params[3], author = params[4], voc_type = params[5]})
			end
		end
	end

	return list
end

function M.download_voc(voc)
	local b, c = http.request(voc_base_url.."nihondrill/"..(voc.id)..".voc")
	local ret
	print("download_voc", b, c)

	if b ~= nil and c == 200 then
		local rc, res = run_untrusted(b)
		if rc then
			rc, res = M.validate_voc(res, voc.id)
			if rc then
				ret = res
			else
				print("download_voc", "validate_voc", rc, res)
			end
		else
			print("download_voc", "run", res)
		end
	end

	return ret
end

function M.init()
	print("vocabulary.init()")
	
	local voc_files = require("voc/vocindex")
	
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

