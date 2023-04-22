-- Dat View
--
-- Class: GGPK Data
-- GGPK Data
--
local ipairs = ipairs
local t_insert = table.insert

local function scanDir(directory, extension)
	local i = 0
	local t = { }
	local pFile = io.popen('dir "'..directory..'" /b')
	for filename in pFile:lines() do
		--ConPrintf("%s\n", filename)
		if extension then
			if filename:match(extension) then
				i = i + 1
				t[i] = filename
			else
				--ConPrintf("No Files Found matching extension '%s'", extension)
			end
		else
			i = i + 1
			t[i] = filename
		end
	end
	pFile:close()
	return t
end

-- Path can be in any format recognized by the extractor at oozPath, ie,
-- a .ggpk file or a Steam Path of Exile directory
local GGPKClass = newClass("GGPKData", function(self, path, datPath)
	if datPath then
		self.oozPath = datPath:match("\\$") and datPath or (datPath .. "\\")
	else
		self.path = path
		self.temp = io.popen("cd"):read('*l')
		self.oozPath = self.temp .. "\\ggpk\\"
		self:ExtractFiles()
	end

	self.dat = { }
	self.txt = { }

	if USE_DAT64 then
		self:AddDat64Files()
	else
		self:AddDatFiles()
	end
end)

function GGPKClass:ExtractFiles()
	local datList, txtList, itList = self:GetNeededFiles()
	
	local fileList = ''
	for _, fname in ipairs(datList) do
		if USE_DAT64 then
			fileList = fileList .. '"' .. fname .. '64" '
		else
			fileList = fileList .. '"' .. fname .. '" '
		end
	end
	for _, fname in ipairs(txtList) do
		fileList = fileList .. '"' .. fname .. '" '
	end
	for _, fname in ipairs(itList) do
		fileList = fileList .. '"' .. fname .. '" '
	end
	
	local cmd = 'cd ' .. self.oozPath .. ' && bun_extract_file.exe extract-files "' .. self.path .. '" . ' .. fileList
	ConPrintf(cmd)
	os.execute(cmd)
end

function GGPKClass:AddDatFiles()
	local datFiles = scanDir(self.oozPath .. "Data\\Simplified Chinese\\", '%w+%.dat$')
	for _, f in ipairs(datFiles) do
		local record = { }
		record.name = f
		local rawFile = io.open(self.oozPath .. "Data\\Simplified Chinese\\" .. f, 'rb')
		record.data = rawFile:read("*all")
		rawFile:close()
		--ConPrintf("FILENAME: %s", fname)
		t_insert(self.dat, record)
	end
end

function GGPKClass:AddDat64Files()
	local datFiles = scanDir(self.oozPath .. "Data\\Simplified Chinese\\", '%w+%.dat64$')
	for _, f in ipairs(datFiles) do
		local record = { }
		record.name = f
		local rawFile = io.open(self.oozPath .. "Data\\Simplified Chinese\\" .. f, 'rb')
		record.data = rawFile:read("*all")
		rawFile:close()
		--ConPrintf("FILENAME: %s", fname)
		t_insert(self.dat, record)
	end
end

function GGPKClass:GetNeededFiles()
	local datFiles = {
		"Data/Stats.dat",
		"Data/StatSemantics.dat",
		"Data/VirtualStatContextFlags.dat",
		"Data/BaseItemTypes.dat",
		"Data/WeaponTypes.dat",
		"Data/ArmourTypes.dat",
		"Data/ShieldTypes.dat",
		"Data/Flasks.dat",
		"Data/ComponentCharges.dat",
		"Data/ComponentAttributeRequirements.dat",
		"Data/PassiveSkills.dat",
		"Data/PassiveSkillTypes.dat",
		"Data/PassiveSkillStatCategories.dat",
		"Data/PassiveSkillMasteryGroups.dat",
		"Data/PassiveSkillMasteryEffects.dat",
		"Data/PassiveTreeExpansionJewelSizes.dat",
		"Data/PassiveTreeExpansionJewels.dat",
		"Data/PassiveJewelSlots.dat",
		"Data/PassiveTreeExpansionSkills.dat",
		"Data/PassiveTreeExpansionSpecialSkills.dat",
		"Data/Mods.dat",
		"Data/ModType.dat",
		"Data/ModDomains.dat",
		"Data/ModGenerationType.dat",
		"Data/ModFamily.dat",
		"Data/ModAuraFlags.dat",
		"Data/ActiveSkills.dat",
		"Data/ActiveSkillTargetTypes.dat",
		"Data/ActiveSkillType.dat",
		"Data/AlternateSkillTargetingBehaviours.dat",
		"Data/Ascendancy.dat",
		"Data/ClientStrings.dat",
		"Data/ItemClasses.dat",
		"Data/SkillTotems.dat",
		"Data/SkillTotemVariations.dat",
		"Data/SkillMines.dat",
		"Data/Essences.dat",
		"Data/EssenceType.dat",
		"Data/Characters.dat",
		"Data/BuffDefinitions.dat",
		"Data/BuffCategories.dat",
		"Data/BuffTemplates.dat",
		"Data/BuffVisuals.dat",
		"Data/BuffVisualSets.dat",
		"Data/BuffVisualSetEntries.dat",
		"Data/BuffVisualsArtVariations.dat",
		"Data/BuffVisualOrbs.dat",
		"Data/BuffVisualOrbTypes.dat",
		"Data/BuffVisualOrbArt.dat",
		"Data/GenericBuffAuras.dat",
		"Data/AddBuffToTargetVarieties.dat",
		"Data/HideoutNPCs.dat",
		"Data/NPCs.dat",
		"Data/CraftingBenchOptions.dat",
		"Data/CraftingItemClassCategories.dat",
		"Data/CraftingBenchUnlockCategories.dat",
		"Data/CraftingBenchSortCategories.dat",
		"Data/MonsterVarieties.dat",
		"Data/MonsterResistances.dat",
		"Data/MonsterTypes.dat",
		"Data/DefaultMonsterStats.dat",
		"Data/SkillGems.dat",
		"Data/GrantedEffects.dat",
		"Data/GrantedEffectsPerLevel.dat",
		"Data/ItemExperiencePerLevel.dat",
		"Data/EffectivenessCostConstants.dat",
		"Data/StatInterpolationTypes.dat",
		"Data/Tags.dat",
		"Data/GemTags.dat",
		"Data/ItemVisualIdentity.dat",
		"Data/AchievementItems.dat",
		"Data/MultiPartAchievements.dat",
		"Data/PantheonPanelLayout.dat",
		"Data/AlternatePassiveAdditions.dat",
		"Data/AlternatePassiveSkills.dat",
		"Data/AlternateTreeVersions.dat",
		"Data/GrantedEffectQualityTypes.dat",
		"Data/GrantedEffectQualityStats.dat",
		"Data/GrantedEffectGroups.dat",
		"Data/AegisVariations.dat",
		"Data/CostTypes.dat",
		"Data/PassiveJewelRadii.dat",
		"Data/SoundEffects.dat",
		"Data/MavenJewelRadiusKeystones.dat",
		"Data/TableCharge.dat",
		"Data/GrantedEffectStatSets.dat",
		"Data/GrantedEffectStatSetsPerLevel.dat",
		"Data/MonsterMapDifficulty.dat",
		"Data/MonsterMapBossDifficulty.dat",
		"Data/ReminderText.dat",
		"Data/Projectiles.dat",
		"Data/AnimateWeaponUniques.dat",
		"Data/ItemExperienceTypes.dat",
		"Data/WeaponPassiveSkills.dat",
		"Data/WeaponPassiveSkillTypes.dat",
		"Data/WeaponPassiveTreeBalancePerItemLevel.dat",
		"Data/WeaponPassiveTreeUniqueBaseTypes.dat",
		"Data/CrucibleTags.dat",
		"Data/FlavourText.dat",
		"Data/ModSellPriceTypes.dat",
	}
	local datFilesCn = {
		"Data/Simplified Chinese/Stats.dat",
		"Data/Simplified Chinese/StatSemantics.dat",
		"Data/Simplified Chinese/VirtualStatContextFlags.dat",
		"Data/Simplified Chinese/BaseItemTypes.dat",
		"Data/Simplified Chinese/WeaponTypes.dat",
		"Data/Simplified Chinese/ArmourTypes.dat",
		"Data/Simplified Chinese/ShieldTypes.dat",
		"Data/Simplified Chinese/Flasks.dat",
		"Data/Simplified Chinese/ComponentCharges.dat",
		"Data/Simplified Chinese/ComponentAttributeRequirements.dat",
		"Data/Simplified Chinese/PassiveSkills.dat",
		"Data/Simplified Chinese/PassiveSkillTypes.dat",
		"Data/Simplified Chinese/PassiveSkillStatCategories.dat",
		"Data/Simplified Chinese/PassiveSkillMasteryGroups.dat",
		"Data/Simplified Chinese/PassiveSkillMasteryEffects.dat",
		"Data/Simplified Chinese/PassiveTreeExpansionJewelSizes.dat",
		"Data/Simplified Chinese/PassiveTreeExpansionJewels.dat",
		"Data/Simplified Chinese/PassiveJewelSlots.dat",
		"Data/Simplified Chinese/PassiveTreeExpansionSkills.dat",
		"Data/Simplified Chinese/PassiveTreeExpansionSpecialSkills.dat",
		"Data/Simplified Chinese/Mods.dat",
		"Data/Simplified Chinese/ModType.dat",
		"Data/Simplified Chinese/ModDomains.dat",
		"Data/Simplified Chinese/ModGenerationType.dat",
		"Data/Simplified Chinese/ModFamily.dat",
		"Data/Simplified Chinese/ModAuraFlags.dat",
		"Data/Simplified Chinese/ActiveSkills.dat",
		"Data/Simplified Chinese/ActiveSkillTargetTypes.dat",
		"Data/Simplified Chinese/ActiveSkillType.dat",
		"Data/Simplified Chinese/AlternateSkillTargetingBehaviours.dat",
		"Data/Simplified Chinese/Ascendancy.dat",
		"Data/Simplified Chinese/ClientStrings.dat",
		"Data/Simplified Chinese/ItemClasses.dat",
		"Data/Simplified Chinese/SkillTotems.dat",
		"Data/Simplified Chinese/SkillTotemVariations.dat",
		"Data/Simplified Chinese/SkillMines.dat",
		"Data/Simplified Chinese/Essences.dat",
		"Data/Simplified Chinese/EssenceType.dat",
		"Data/Simplified Chinese/Characters.dat",
		"Data/Simplified Chinese/BuffDefinitions.dat",
		"Data/Simplified Chinese/BuffCategories.dat",
		"Data/Simplified Chinese/BuffTemplates.dat",
		"Data/Simplified Chinese/BuffVisuals.dat",
		"Data/Simplified Chinese/BuffVisualSets.dat",
		"Data/Simplified Chinese/BuffVisualSetEntries.dat",
		"Data/Simplified Chinese/BuffVisualsArtVariations.dat",
		"Data/Simplified Chinese/BuffVisualOrbs.dat",
		"Data/Simplified Chinese/BuffVisualOrbTypes.dat",
		"Data/Simplified Chinese/BuffVisualOrbArt.dat",
		"Data/Simplified Chinese/GenericBuffAuras.dat",
		"Data/Simplified Chinese/AddBuffToTargetVarieties.dat",
		"Data/Simplified Chinese/HideoutNPCs.dat",
		"Data/Simplified Chinese/NPCs.dat",
		"Data/Simplified Chinese/CraftingBenchOptions.dat",
		"Data/Simplified Chinese/CraftingItemClassCategories.dat",
		"Data/Simplified Chinese/CraftingBenchUnlockCategories.dat",
		"Data/Simplified Chinese/CraftingBenchSortCategories.dat",
		"Data/Simplified Chinese/MonsterVarieties.dat",
		"Data/Simplified Chinese/MonsterResistances.dat",
		"Data/Simplified Chinese/MonsterTypes.dat",
		"Data/Simplified Chinese/DefaultMonsterStats.dat",
		"Data/Simplified Chinese/SkillGems.dat",
		"Data/Simplified Chinese/GrantedEffects.dat",
		"Data/Simplified Chinese/GrantedEffectsPerLevel.dat",
		"Data/Simplified Chinese/ItemExperiencePerLevel.dat",
		"Data/Simplified Chinese/EffectivenessCostConstants.dat",
		"Data/Simplified Chinese/StatInterpolationTypes.dat",
		"Data/Simplified Chinese/Tags.dat",
		"Data/Simplified Chinese/GemTags.dat",
		"Data/Simplified Chinese/ItemVisualIdentity.dat",
		"Data/Simplified Chinese/AchievementItems.dat",
		"Data/Simplified Chinese/MultiPartAchievements.dat",
		"Data/Simplified Chinese/PantheonPanelLayout.dat",
		"Data/Simplified Chinese/AlternatePassiveAdditions.dat",
		"Data/Simplified Chinese/AlternatePassiveSkills.dat",
		"Data/Simplified Chinese/AlternateTreeVersions.dat",
		"Data/Simplified Chinese/GrantedEffectQualityTypes.dat",
		"Data/Simplified Chinese/GrantedEffectQualityStats.dat",
		"Data/Simplified Chinese/GrantedEffectGroups.dat",
		"Data/Simplified Chinese/AegisVariations.dat",
		"Data/Simplified Chinese/CostTypes.dat",
		"Data/Simplified Chinese/PassiveJewelRadii.dat",
		"Data/Simplified Chinese/SoundEffects.dat",
		"Data/Simplified Chinese/MavenJewelRadiusKeystones.dat",
		"Data/Simplified Chinese/TableCharge.dat",
		"Data/Simplified Chinese/GrantedEffectStatSets.dat",
		"Data/Simplified Chinese/GrantedEffectStatSetsPerLevel.dat",
		"Data/Simplified Chinese/MonsterMapDifficulty.dat",
		"Data/Simplified Chinese/MonsterMapBossDifficulty.dat",
		"Data/Simplified Chinese/ReminderText.dat",
		"Data/Simplified Chinese/Projectiles.dat",
		"Data/Simplified Chinese/AnimateWeaponUniques.dat",
		"Data/Simplified Chinese/ItemExperienceTypes.dat",
		"Data/Simplified Chinese/WeaponPassiveSkills.dat",
		"Data/Simplified Chinese/WeaponPassiveSkillTypes.dat",
		"Data/Simplified Chinese/WeaponPassiveTreeBalancePerItemLevel.dat",
		"Data/Simplified Chinese/WeaponPassiveTreeUniqueBaseTypes.dat",
		"Data/Simplified Chinese/CrucibleTags.dat",
		"Data/Simplified Chinese/FlavourText.dat",
		"Data/Simplified Chinese/ModSellPriceTypes.dat",
	}
	local txtFiles = {
		"Metadata/StatDescriptions/passive_skill_aura_stat_descriptions.txt",
		"Metadata/StatDescriptions/passive_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/active_skill_gem_stat_descriptions.txt",
		"Metadata/StatDescriptions/advanced_mod_stat_descriptions.txt",
		"Metadata/StatDescriptions/aura_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/banner_aura_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/beam_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/brand_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/buff_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/curse_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/debuff_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/secondary_debuff_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/gem_stat_descriptions.txt",
		"Metadata/StatDescriptions/minion_attack_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/minion_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/minion_spell_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/minion_spell_damage_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/monster_stat_descriptions.txt",
		"Metadata/StatDescriptions/offering_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/single_minion_spell_skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/skillpopup_stat_filters.txt",
		"Metadata/StatDescriptions/skill_stat_descriptions.txt",
		"Metadata/StatDescriptions/stat_descriptions.txt",
		"Metadata/StatDescriptions/variable_duration_skill_stat_descriptions.txt",
	}
	local itFiles = {
		"Metadata/Items/Quivers/AbstractQuiver.it",
		"Metadata/Items/Rings/AbstractRing.it",
		"Metadata/Items/Belts/AbstractBelt.it",
		"Metadata/Items/Flasks/AbstractUtilityFlask.it",
		"Metadata/Items/Jewels/AbstractJewel.it",
		"Metadata/Items/Flasks/CriticalUtilityFlask.it",
		"Metadata/Items/Flasks/AbstractHybridFlask.it",
		"Metadata/Items/Flasks/AbstractManaFlask.it",
		"Metadata/Items/Weapons/TwoHandWeapons/Staves/AbstractWarstaff.it",
		"Metadata/Items/Weapons/OneHandWeapons/OneHandMaces/AbstractSceptre.it",
		"Metadata/Items/Weapons/OneHandWeapons/OneHandSwords/AbstractOneHandSwordThrusting.it",
		"Metadata/Items/Weapons/OneHandWeapons/Claws/AbstractClaw.it",
		"Metadata/Items/Armours/Shields/AbstractShield.it",
		"Metadata/Items/Weapons/TwoHandWeapons/Bows/AbstractBow.it",
		"Metadata/Items/Weapons/TwoHandWeapons/FishingRods/AbstractFishingRod.it",
		"Metadata/Items/Weapons/TwoHandWeapons/TwoHandMaces/AbstractTwoHandMace.it",
		"Metadata/Items/Armours/Boots/AbstractBoots.it",
		"Metadata/Items/Jewels/AbstractAbyssJewel.it",
		"Metadata/Items/Armours/BodyArmours/AbstractBodyArmour.it",
		"Metadata/Items/Armours/AbstractArmour.it",
		"Metadata/Items/Weapons/OneHandWeapons/Daggers/AbstractRuneDagger.it",
		"Metadata/Items/Weapons/TwoHandWeapons/Staves/AbstractStaff.it",
		"Metadata/Items/Weapons/TwoHandWeapons/TwoHandAxes/AbstractTwoHandAxe.it",
		"Metadata/Items/Weapons/OneHandWeapons/OneHandAxes/AbstractOneHandAxe.it",
		"Metadata/Items/Weapons/TwoHandWeapons/TwoHandSwords/AbstractTwoHandSword.it",
		"Metadata/Items/Weapons/OneHandWeapons/OneHandMaces/AbstractOneHandMace.it",
		"Metadata/Items/Armours/Gloves/AbstractGloves.it",
		"Metadata/Items/Weapons/OneHandWeapons/Daggers/AbstractDagger.it",
		"Metadata/Items/Weapons/OneHandWeapons/OneHandSwords/AbstractOneHandSword.it",
		"Metadata/Items/Amulets/AbstractAmulet.it",
		"Metadata/Items/Flasks/AbstractLifeFlask.it",
		"Metadata/Items/Weapons/OneHandWeapons/Wands/AbstractWand.it",
		"Metadata/Items/Armours/Helmets/AbstractHelmet.it",
		"Metadata/Items/Flasks/AbstractFlask.it",
		"Metadata/Items/Weapons/TwoHandWeapons/AbstractTwoHandWeapon.it",
		"Metadata/Items/Item.it",
		"Metadata/Items/Weapons/OneHandWeapons/AbstractOneHandWeapon.it",
		"Metadata/Items/Equipment.it",
		"Metadata/Items/Weapons/AbstractWeapon.it",
	}
	return datFilesCn, txtFiles, itFiles
end
