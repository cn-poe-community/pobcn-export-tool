if not loadStatFile then
	dofile("statdesc.lua")
end
loadStatFile("stat_descriptions.txt")

local out = io.open("../../Data/Crucible.lua", "w")
out:write('-- This file is automatically generated, do not edit!\n')
out:write('-- Item data (c) Grinding Gear Games\n\nreturn {\n')
for crucible in dat("WeaponPassiveSkills"):Rows() do
	local stats, orders = describeMod(crucible.Mod)
	if #orders > 0 then
		out:write('\t["', crucible.Mod.Id, '"] = { ')
		if crucible.Mod.GenerationType == 31 then
			out:write('type = "Spawn", ')
		elseif crucible.Mod.GenerationType == 32 then
			out:write('type = "MergeOnly", ')
		end
		out:write('tier = ', crucible.Variant, ', ')
		out:write('"', table.concat(stats, '", "'), '", ')
		out:write('statOrderKey = "', table.concat(orders, ','), '", ')
		out:write('statOrder = { ', table.concat(orders, ', '), ' }, ')
		out:write('level = ', crucible.Mod.Level, ', group = "', crucible.Mod.Type.Id, '", ')
		out:write('nodeType = "', crucible.Type.Id, '", ')
		out:write('nodeLocation = { ', table.concat(crucible.NodeSpawnLocation, ', '), ' }, ')
		out:write('weightKey = { ')
		for _, tag in ipairs(crucible.Mod.SpawnTags) do
			out:write('"', tag.Id, '", ')
		end
		out:write('}, ')
		out:write('weightVal = { ', table.concat(crucible.Mod.SpawnWeights, ', '), ' }, ')
		out:write('weightMultiplierKey = { ')
		for _, tag in ipairs(crucible.Mod.GenerationWeightTags) do
			out:write('"', tag.Id, '", ')
		end
		out:write('}, ')
		out:write('weightMultiplierVal = { ', table.concat(crucible.Mod.GenerationWeightValues, ', '), ' }, ')
		if crucible.Mod.Tags[1] then
			out:write('tags = { ')
			for _, tag in ipairs(crucible.Mod.Tags) do
				out:write('"', tag.Id, '", ')
			end
			out:write('}, ')
		end
		out:write('modTags = { ', stats.modTags, ' }, ')
		out:write('},\n')
	else
		print("Mod '"..crucible.Mod.Id.."' has no stats")
	end
end
out:write('}')
out:close()

print("Crucible mods exported.")
