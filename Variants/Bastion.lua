
local survivor = Survivor.find("Enforcer", "vanilla")

local skinName = "Bastion" -- The name of the variant.
local path = "Variants/Bastion/" -- The location of all files (relative to the first folder).

-- This assigns the new skin we are creating to the variable "newSkin".
local newSkin = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Enforcer).
skinName, -- The name previously declared.
Sprite.load(skinName.."Select", path.."Select", 18, 2, 0),
{
	idle_1 = Sprite.load(skinName.."Idle_1", path.."Idle_1", 1, 9, 10),
	idle_2 = Sprite.load(skinName.."Idle_2", path.."Idle_2", 1, 10, 21),
	walk_1 = Sprite.load(skinName.."Walk_1", path.."Walk_1", 8, 9, 9),
	walk_2 = Sprite.load(skinName.."Walk_2", path.."Walk_2", 8, 6, 10),
	jump = Sprite.load(skinName.."Jump", path.."Jump", 1, 9, 11),
	climb = Sprite.load(skinName.."Climb", path.."Climb", 2, 5, 8),
	death = Sprite.load(skinName.."Death", path.."Death", 5, 12, 8),
	decoy = Sprite.load(skinName.."Decoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load(skinName.."Shoot1_1", path.."Shoot1_1", 6, 8, 15),
	shoot1_2 = Sprite.load(skinName.."Shoot1_2", path.."Shoot1_2", 6, 7, 15),
	shoot2_1 = Sprite.load(skinName.."Shoot2", path.."Shoot2", 14, 7, 10),
	shoot3_1 = Sprite.load(skinName.."Shoot3_1", path.."Shoot3_1", 8, 5, 10),
	shoot3_2 = Sprite.load(skinName.."Shoot3_2", path.."Shoot3_2", 6, 5, 10),
},
Color.fromHex(0xCEB9A5))

newSkin.endingQuote = "..and so he left, carrying the weight of his actions." -- Custom ending quote. Not obligatory

SurvivorVariant.setInfoStats(newSkin, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 6}, {"Difficulty", 2}, {"Accuracy", 4}}) 

SurvivorVariant.setDescription(newSkin, "The &y&Bastion&!& is a highly militarized warrior who won't let anything get in his path") 
-- We set the description of the skin, can use color formatting. Also not obligatory.

local sprSkills = Sprite.load(skinName.."Skills", path.."Skills", 2, 0, 0) -- Loading our skills sprite.

SurvivorVariant.setLoadoutSkill(newSkin, "Grenade", "Throw a grenade that &y&explodes on impact for 120% damage.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(newSkin, "Assault", "Fire a gun rapidly dealing &y&4x130% damage.", sprSkills, 2)

callback.register("onSkinInit", function(player, skin) 
-- This callback activates once the player has selected a skin and started a game.
-- Always use this to check initialization of skins, do not use the "onPlayerInit" or "onGameStart" callbacks for this matter.
	if skin == newSkin then
		-- Since the callback passes the player's selected skin, we compare that to the skin we just made and check if it is the same.
		-- If it is, then we set whatever we want for initialization.
		player:set("armor", player:get("armor") + 5) -- Like for example we can add 5 armor so we begin with 5 extra armor.
		player:set("pHmax", player:get("pHmax") - 0.1) -- Same can be done for any other variable, like the horizontal speed here, which we are decreasing by 0.05.
		
		player:survivorSetInitialStats(110, 12, 0.01) -- This is ModLoader's method for setting initial stats, by doing it here we override the original ones. 
		-- (First value is health, second is damage, third is hp regeneration per second).
		
		player:setSkill(1,
		"Grenade",
		"Throw a grenade that explodes on impact for 120% damage.",
		sprSkills, 1, 50)
		player:setSkill(2,
		"Assault",
		"Fire a gun rapidly dealing 4x130% damage.",
		sprSkills, 2, 3 * 60)
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == newSkin then
		player:survivorLevelUpStats(2, 0, -0.0005, 0)
		-- Each level, the variant gains 2 additional hp, on top of base Enforcer's 34 hp per level.
		-- It also gets -0.0005 less regen than base Enforcer's 0.002 (for a total of 0.0015).
		-- Other level up stats are unchanged from base enforcer.
	end
end)

-- Here we're gonna set up the skills we're changing.
-- The first argument is our variant.
-- The second argument is the skill index.
-- The third argument is the function that occurs when the skill is activated.
SurvivorVariant.setSkill(newSkin, 1, function(player)
	-- When the player activates the first skill we are initializing the activity.
	-- Since enforcer can have two states we check for the "bunker" variable, which tells us whether enforcer is shielded or not.
	if player:get("bunker") == 0 then
		-- If not shielded...
		
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
		-- This is the equivalent of the player:survivorActivityState method used for custom survivors.
		-- We're setting the skill to the activity value of 1, using the first shoot1 sprite, with a speed of 0.2, with att. speed scaling and horizontal speed resetting.
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.25, true, true)
		-- Ditto but with the second shoot1 sprite, as we're shielded in this case.
	end
end)
SurvivorVariant.setSkill(newSkin, 2, function(player)
	-- For the second skill we're not going to care about the shield state:
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
end)

local objGrenade = Object.find("CowboyDynamite", "Vanilla") -- We're going to use Bandit's X grenade object, so we need to find it.
local sprSparks = Sprite.find("Sparks1", "Vanilla") -- Bullet impact sprite.
local sfxShoot1 = Sound.find("RiotGrenade", "Vanilla") -- Grenade fire sound.
local sfxShoot2 = Sound.find("Bullet2", "Vanilla") -- Bullet fire sound.

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	-- This callback is the equivalent of the "onSkill" custom survivor callback.
	if SurvivorVariant.getActive(player) == newSkin then
		-- As it is a global callback, it triggers for every variant so we have to check this is OUR variant.
		
		if skill == 1 then
			if relevantFrame == 1 then
				if not player:survivorFireHeavenCracker(1.2) then -- Heaven Cracker proc
					for i = 0, player:get("sp") do -- Shattered Mirror proc
						local grenade = objGrenade:create(player.x, player.y)
						grenade:set("direction", player:getFacingDirection() + 25 * player.xscale)
						grenade:set("speed", 4)
						grenade:set("parent", player.id)
						grenade:set("team", player:get("team"))
						grenade:set("damage", 1.2) -- (120% damage)
						sfxShoot1:play(1.4 + math.random() * 0.2)
					end
				end
			end
		elseif skill == 2 then
			if relevantFrame == 4 or relevantFrame == 6 or relevantFrame == 8 or relevantFrame == 10 then
				player:fireBullet(player.x, player.y, player:getFacingDirection(), 300, 1.3, sprSparks)
				sfxShoot2:play(0.9 + math.random() * 0.2)
			end
		end
	end
end)

-- The following is a fix for Enforcer skinning.
-- Without it you might experience a few sprite and turning glitches ONLY ON ENFORCER.
-- Hopefully this will not be needed in future version but as 1.9.3 it still is.
callback.register("onPlayerDraw", function(player)
	if SurvivorVariant.getActive(player) == newSkin then
		local playerData = player:getData()
		if player:get("bunker") == 0 then
			player:setAnimation("idle", newSkin.animations.idle_1)
			player:setAnimation("walk", newSkin.animations.walk_1)
			player:setAnimation("shoot1", newSkin.animations.shoot1_1)
			playerData.lastXscaleFix = nil
		else
			if playerData.lastXscaleFix then
				if playerData.lastXscaleFix ~= player.xscale then
					player.xscale = playerData.lastXscaleFix
				end
			else
				playerData.lastXscaleFix = player.xscale
			end
			player:setAnimation("idle", newSkin.animations.idle_2)
			player:setAnimation("walk", newSkin.animations.walk_2)
			player:setAnimation("shoot1", newSkin.animations.shoot1_2)
			if player:get("activity") == 0 then
				player:set("activity_type", 4)
			end
		end
		player:setAnimation("shoot2", newSkin.animations.shoot2_1)
	end
end)