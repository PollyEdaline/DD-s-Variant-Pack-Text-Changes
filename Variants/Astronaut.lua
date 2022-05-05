
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Miner", "vanilla")
local path = "Variants/Astronaut/"
local Astro = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Astronaut", -- The name of the skin.
Sprite.load("AstronautSelect", path.."Select", 16, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("AstroIdle", path.."Idle", 1, 12, 6),
	walk = Sprite.load("AstroWalk", path.."Walk", 8, 13, 6),
	jump = Sprite.load("AstroJump", path.."jump", 1, 13, 7),
	climb = Sprite.load("AstroClimb", path.."climb", 2, 6, 12),
	death = Sprite.load("AstroDeath", path.."Death", 9, 16, 26),
	hover = Sprite.load("AstroHover", path.."hover", 4, 13, 7),
	decoy = Sprite.load("AstroDecoy", path.."Decoy", 1, 16, 18),
	
	shoot1A = Sprite.load("AstroShootG", path.."shoot1A", 5, 13, 10),
	shoot1B = Sprite.load("AstroShootF", path.."shoot1B", 5, 18, 12),
	shootSide = Sprite.load("AstroShootSide", path.."shoot2A", 6, 33, 14),
	shootUp = Sprite.load("AstroShootUp", path.."shoot2B", 6, 17, 14),
	shootDown = Sprite.load("AstroShootDown", path.."shoot2C", 6, 17, 71),
	shootAngleU = Sprite.load("AstroShootAngleUp", path.."shoot2D", 6, 17, 16),
	shootAngleD = Sprite.load("AstroShootAngleDown", path.."shoot2E", 6, 17, 29),
	shoot3 = Sprite.load("AstroShoot3", path.."shoot3", 9, 22, 23),
	shoot4 = Sprite.load("AstroShoot4", path.."shoot4", 3, 11, 15),
	
},
Color.fromHex(0xe8871c)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.
local sprSkills = Sprite.load("astroSkills", path.."skills", 6, 0, 0)
local sprFuelBar = Sprite.load("astroFuel", path.."astroBar", 1, 0, 0)
local enemies = ParentObject.find("enemies")
local bar = Object.find("CustomBar")
local sBoom = Sound.find("JanitorShoot4_2")
local slamX = Sound.find("Smite")
local sShoot = Sound.find("CowboyShoot1")
local sndError = Sound.find("Error")
local enemies = ParentObject.find("enemies")
local sfxToss = Sound.find("BoarExplosion")
local windSlash = Sound.find("SamuraiShoot2")
local beat = Sound.find("SamuraiShoot1")
local skillC = Sound.load("holdSFX", path.."skillC")


SurvivorVariant.setDescription(Astro, "The &b&Astronaut&!& is a frail, aerial fighter that utilizes careful management of &b&Fuel&!& to unleash devastating near-endless combos of damage from above. Stockpile &b&Fuel&!& with &y&Ignition&!&, and soar into the stars with &y&Gravity Well&!&!") 
Astro.endingQuote = "..and so she left, lost within the stars once more."

SurvivorVariant.setLoadoutSkill(Astro, "Ignition" ,
		"Shoot a condensed blast of energy for &y&130% damage&!&. Restores &b&Fuel&!& on hit.",
sprSkills,1)
SurvivorVariant.setLoadoutSkill(Astro, "Condensed Avionics", 
		"Dash in any direction for up to &y&4x70% damage&!&. Dash downwards to slam the ground, &y&increasing damage based on height&!&.", 
sprSkills,2)
SurvivorVariant.setLoadoutSkill(Astro,"From Above" ,
		"Slam down from the air. When you hit the ground, spin upwards, dealing up to &y&6x65% damage&!&. Restores &b&Fuel&!& on hit.",
sprSkills,3)
SurvivorVariant.setLoadoutSkill(Astro, "Gravity Well" ,
		"Summon a Vacuum Drone that absorbs enemies with a gravity well. When it expires, it slams down for &y&600% damage&!&.", sprSkills,4)
		
SurvivorVariant.setInfoStats(Astro, {{"Strength", 8}, {"Vitality", 4}, {"Claustrophobia", 7}, {"Agility", 8}, {"Difficulty", 6}, {"Patience", 0}}) 

callback.register("onSkinInit", function(player, skin) 
	if skin == Astro then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		
		player:survivorSetInitialStats(80, 11.5, 0.0065)
		
		playerAc.armor = playerAc.armor - 30
		player:getData().awaitingGroundImpact = nil
		playerData.fuel = 100
			
		playerData.yInput = 0
		playerData.inWell = false
		playerData.wellGrav = false
		playerData.refuelCounter = 0
		playerData.xInput = 0
		playerData.preYscale = 1
		player:getData().skin_skill2Override = true
		playerData.hitEnemies = {}
		playerData.fall = 0
		player:getData().wingStep = 1
		playerData.maxCharge = 1
		playerData.armorGain = false
		playerData.iFrameDecay = 0
		playerData.iFrameDecayDel = 10
		playerAc.pGravity2 = 0.15
		player:getData().air = 0
		player:setSkill(1,
		"Ignition" ,
		"Shoot a condensed blast of energy for 130% damage. Restores and shoots faster with Fuel.",
		sprSkills, 1, 65)
		player:setSkill(2,
		"Condensed Avionics" ,
		"Dash in any direction for up to 4x70% damage, as long as you have Fuel. Dash downwards to slam the ground, increasing damage based on height.",
		sprSkills, 2, 5*60)
		player:setSkill(3,
		"From Above" ,
		"Slam down from the air. When you hit the ground, spin upwards, dealing up to 6x65% damage. Restores Fuel on hit.",
		sprSkills, 3, 9*60)
				player:setSkill(4,
		"Gravity Well" ,
		"Summon a Vacuum Drone that absorbs enemies with a gravity well. When it expires, it slams down for 600% damage.",
		sprSkills, 4, 20*60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Astro then
		player:survivorLevelUpStats(0.2, 0, 0.005, 0.007)
	end
end)
	--sync resource gained
local packetRGain
local function RGain(rNumber,owner)
	local ownerData = owner:getData()
	ownerData.fuel = (rNumber)
    packetRGain:sendAsHost("all", nil, rNumber, owner:getNetIdentity())
end

packetRGain = net.Packet("packetRGain", function(_,rNumber,owner)
  -- packet to call the function on clients
  RGain(rNumber,owner:resolve())
end)

callback.register("preHit", function(damager, hit)
	if damager:getData().rGain and net.host then
		local parent = damager:getParent()
		if parent and parent:isValid() then
			local parentAc = parent:getAccessor()
			if parent:getData().fuel and parent:getData().fuel < 100 then
					RGain(parent:getData().fuel + damager:getData().rGain, parent)
			end
			ParticleType.find("spark"):burst("middle", parent.x + parent.xscale * 22, parent.y, 2)
		end
	end
end)


-- Gravity Well Object
local objWell = Object.new("Astro_well")
local sWell = Sprite.load("Astro_Well", path.."well", 4, 12, 9)
local fallWell = Sprite.load("Astro_WellFall", path.."crashSpeed", 1, 0, 11)
local fallMask = Sprite.load("Astro_WellMask", path.."fallMask", 1, 0, 26)
local wellBoom = Sprite.load("Astro_WellBoom", path.."crashExpo", 4, 34, 45)
objWell.sprite = sWell
objWell.depth = 13

objWell:addCallback("create", function(well)
	local mineAc = well:getAccessor()
	well:set("team", "player")
	well:getData().life = 8*60
	well:getData().timer = 0
	well:getData().counter = 0
	well:getData().acc = 0
	well:getData().initspeed = 4
	well.spriteSpeed = 0.2
	well:getData().vSpeed = 4
	well:getData().resty = well.y
	well:getData().hSpeed = 0
	well:getData().state = false
	well.mask = fallMask
end)
function sign(number)
    return number > 0 and 1 or (number == 0 and 0 or -1)
end
survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Astro then
		player:setSkill(4,
		"Gravity Field" ,
		"Summon three Vacuum Drones that absorb enemies with gravity wells. When they expires, they slams down for &y&600% damage&!& each.",
		sprSkills, 5, 20*60)
	end
end)

objWell:addCallback("step", function(well)
	local wellAc = well:getAccessor()
	local parent = well:getData().parent
	well:getData().life = well:getData().life -1
	
	if well:getData().hSpeed ~= 0 then
		well.x = well.x+well:getData().hSpeed
		well:getData().hSpeed = well:getData().hSpeed - (sign(well:getData().hSpeed))
		
	end
	
	if well:getData().vSpeed == 0 and well:getData().state == false then
		well:getData().resty = well.y
	end
	
	if well:getData().vSpeed > 0 and well:getData().state == false then
		if not well:collidesMap(well.x, well.y-well:getData().vSpeed) then
			well.y = well.y-well:getData().vSpeed
		end
		well:getData().vSpeed = well:getData().vSpeed - 0.1
	end
	if well:getData().life % 30 == 0 then
		beat:play(0.01 + math.random() * 0.3,0.2)
		if well:getData().life < 120 then
			ParticleType.find("Fire4"):burst("middle", well.x, well.y, 2)
		end
	end
	if well:getData().state == false then
		for _, actor in ipairs(ParentObject.find("actors"):findAllEllipse(well.x - 77, well.y - 120, well.x + 77, well.y + 130)) do
					local dis = distance(actor.x, actor.y, well.x, well.y)
					local speed = math.max((99 - dis) * 0.15, 3 * parent:get("attack_speed"))
					
					if actor:get("team") ~= well:get("team") and not actor:isBoss() then
						actor.x = math.approach(actor.x, well.x, speed/7.5)
						actor.y = math.approach(actor.y, well.y, speed/7.5)
						
						if actor:isClassic() then
							local n = 0
							if well:getData().state == false then
								actor:getAccessor().pVspeed = 0
							else 
								actor:getAccessor().pVspeed = 8
							end
							while actor:collidesMap(actor.x, actor.y) and n < 30 do
								actor.y = actor.y -1
								n = n + 1
							end
							n = 0
							while actor:collidesMap(actor.x - 1, actor.y) and n < 30 do
								actor.x = actor.x + 1
								n = n + 1
							end
							n = 0
							while actor:collidesMap(actor.x + 1, actor.y) and n < 30 do
								actor.x = actor.x - 1
								n = n + 1
							end
						end
					end
				end
			end
	if well:getData().life <= 0 then
		if well:getData().state == false then
			well:getData().vSpeed = - 3
			well:getData().state = true
			skillC:play(1.5 + math.random() * 0.3)
		end
	end
	
	if well:getData().state == true then
			well.y = well.y + well:getData().vSpeed
		well:getData().vSpeed = well:getData().vSpeed + 0.3
		if well:getData().vSpeed > 0 and well.y > well:getData().resty then 
			well.sprite = fallWell
			local n = 0
			while not well:collidesMap(well.x, well.y ) and n < 150 do
					well.y = well.y + 2
					n = n + 1
			end
			local damager = parent:fireExplosion(well.x, well.y, 2, 2, 6*((parent:get("scepter")/3)+1), wellBoom, nil)
				damager:set("stun", 1)
				if onScreen(well) then
					misc.shakeScreen(6)
					slamX:play(1.5 + math.random() * 0.3,0.7)
				end
				ParticleType.find("spark"):burst("middle", well.x, well.y, 6)
				ParticleType.find("Rubble2"):burst("middle",well.x, well.y, 5)
				well:destroy()
		end
	end
end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == Astro then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		local br = bar:findNearest(player.x, player.y)
		if br then
			br:destroy()
		end
		if (math.floor(playerAc.activity) == 2 or  math.floor(playerAc.activity) == 3) and playerData.armorGain == false then
			playerAc.armor = playerAc.armor +90
			playerData.armorGain = true
		end
		
		if math.floor(playerAc.activity) ~= 2 and math.floor(playerAc.activity) ~= 3 and playerData.armorGain == true then
			playerAc.armor = playerAc.armor -90
			playerData.armorGain = false
		end
		local nearWell = objWell:findNearest(player.x, player.y)
		if NearWell then
			if not nearWell:isValid() then
				playerData.inWell = false
			end
		end
		if nearWell then
			local dis = distance(player.x, player.y, nearWell.x, nearWell.y)
		
			if dis < 80 and nearWell:isValid() then
				playerData.inWell = true
			end
			if  dis > 80 or not nearWell:isValid() then
				playerData.inWell = false
			end

		end
		if not nearWell then
			playerData.inWell = false
		end
		if playerData.awaitingGroundImpact then
			if playerData.awaitingGroundImpact > 0 then
				playerData.awaitingGroundImpact = playerData.awaitingGroundImpact - 1
			end
			if playerData.awaitingGroundImpact < 1 or playerAc.free == 0 then
				playerData.awaitingGroundImpact = nil
			end
			
		end
		
		if math.floor(playerAc.activity) ~= 2 then
			playerData.yInput = 0
			playerData.xInput = 0
			playerData.fall = 0
		end
		if playerData.fuel > 100 then
			playerData.fuel = 100
		end
		if playerData.fuel < 0 then
			playerdataFuel = 0
		end
		
		if (player:get("free") ~= 1 or playerAc.activity == 30) and playerData.fuel < 100 then
			if playerData.refuelCounter < 45 then
				playerData.refuelCounter = playerData.refuelCounter + 1
			else
				playerData.fuel = playerData.fuel + 0.2
			end
		end
		
		if (playerAc.activity >= 1 and playerAc.activity < 5 )then
			playerData.refuelCounter = 0
		end
		
		if playerAc.activity == 0 and playerAc.free == 0 then
			if playerData.iFrameDecayDel > 0 then
				playerData.iFrameDecayDel= playerData.iFrameDecayDel-1
			else
				playerData.iFrameDecay = 0
			end
		end
			
		if player:get("free") == 1 and player:get("activity") ~= 30 and math.floor(player:get("activity")) ~= 2 then
			if player:get("moveUpHold") == 1 and playerData.fuel > 0 then
				if playerData.inWell == false then
					playerData.fuel = playerData.fuel - 0.15
				end
				if not playerData.flightBonus then
					
					playerData.flightBonus = true
					
					player:set("pHmax", player:get("pHmax") + 0.9)
				end
				
				playerData.wingStep = playerData.wingStep + (0.07 * (player:get("pHmax") + player:get("pVmax")))
				if playerData.inWell == false then
					if player:get("pVspeed") > 0 then
						player:set("pVspeed", player:get("pVspeed") - 0.07)
					end
					player:set("pVspeed", math.max(player:get("pVspeed"), -6))
				else
					player:set("pVspeed", player:get("pVspeed") - 0.17)
					player:set("pVspeed", math.min(player:get("pVspeed"), 1))
				end
				if playerData.wingStep >= 4 then
					playerData.wingStep = 1
				end
			else
				if playerData.flightBonus then
					playerData.flightBonus = nil
					player:set("pHmax", player:get("pHmax") - 0.9)
				end
			end
		else
			if playerData.flightBonus then
				playerData.flightBonus = nil
				player:set("pHmax", player:get("pHmax") - 0.9)
			end
		end
		if playerData.maxCharge < 1 and player:get("free") ~= 1 and math.floor(playerAc.activity) ~= 2 then
			playerData.maxCharge = 1
			player:activateSkillCooldown(2)
		end
	end
end)

SurvivorVariant.setSkill(Astro, 1, function(player)--spamM1
	if player:get("free") ~= 1 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1A"), 0.25, true, true)
		player:getData().air = 0
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1B"), 0.25, true, true)
		player:getData().air = 16
	end
end)
SurvivorVariant.setSkill(Astro, 2, function(player)--Angle the Shot
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	local cost = 20
	playerData.iFrameDecayDel = 10
	playerData.iFrameDecay = playerData.iFrameDecay+5
	playerAc.invincible = 40-math.min(playerData.iFrameDecay,40)
	if playerData.maxCharge <= 0 and playerData.fuel <= 0 then 
		sndError:play()
		player:activateSkillCooldown(2)
		playerData.maxCharge = 1
		ParticleType.find("Fire4"):burst("middle", player.x, player.y, 2)
	end

	if playerData.fuel <= 0 then
		playerData.maxCharge = playerData.maxCharge -1
	end
	
	if playerData.fuel > 0 then
		if playerData.fuel >= cost then
		playerData.fuel = playerData.fuel - cost
		else 
			playerData.fuel = 0
			playerData.maxCharge = playerData.maxCharge -1
			ParticleType.find("Fire4"):burst("middle", player.x, player.y, 2)
		end
	end

	
	
	if input.checkControl("down", player) == input.HELD and input.checkControl("up", player) ~= input.HELD then
		playerData.yInput = -1
		
	elseif input.checkControl("down", player) ~= input.HELD and input.checkControl("up", player) == input.HELD then
		playerData.yInput = 1
	end
	
	if input.checkControl("left", player) == input.HELD or input.checkControl("right", player) == input.HELD then
		playerData.xInput = 1
	end
	
	if playerData.yInput == 0 then
		SurvivorVariant.activityState(player, 2, player:getAnimation("shootSide"), 0.23, false, false)
		
	elseif playerData.yInput ~= 0 and playerData.xInput == 0 then

		if playerData.yInput > 0 then		
			SurvivorVariant.activityState(player, 2, player:getAnimation("shootUp"), 0.23, false, false)
		elseif  not player:collidesMap(player.x, player.y + 2) then
			SurvivorVariant.activityState(player, 2, player:getAnimation("shootDown"), 0.23, false, false)
		end
		
	elseif playerData.yInput ~= 0 and playerData.xInput == 1 then
	
		if playerData.yInput > 0 then
			SurvivorVariant.activityState(player, 2, player:getAnimation("shootAngleU"), 0.23, false, false)
		elseif not player:collidesMap(player.x, player.y + 2) then
			SurvivorVariant.activityState(player, 2, player:getAnimation("shootAngleD"), 0.23, false, false)
		end
	end
	if playerData.yInput == -1 and player:collidesMap(player.x, player.y + 2) then SurvivorVariant.activityState(player, 2, player:getAnimation("shootSide"), 0.20, false, false) end
end)

SurvivorVariant.setSkill(Astro, 3, function(player)--speeny
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
	playerData.vault= nil
	playerAc.pVspeed = -5
	if player:get("free") ~= 1 then
		player:getData().air = 0
	else
		player:getData().awaitingGroundImpact = 300
		player:getData().air = 1
	end
end)

SurvivorVariant.setSkill(Astro, 4, function(player)--speeny
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	player:set("pVspeed", -1)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if SurvivorVariant.getActive(player) == Astro then
		
		if skill == 1 then
			playerAc.pHspeed = player.xscale*-1.5
		local cost = 15
			if relevantFrame == 1 then
				if player:getData().air > 0 then 
						playerAc.pVspeed = -3.5
					end
				if playerData.fuel > 0 then 
					player:setAlarm(2,0)
					
					if playerData.fuel >= cost then
						playerData.fuel = playerData.fuel - cost
					else
					local dmg = 1.4
					if player:getData().air > 0 then
						dmg = 2
					end
						ParticleType.find("Fire4"):burst("middle", player.x, player.y, 2)
						playerData.fuel = 0
					end
					
					
					local efTrail = Object.find("EfTrail"):create(player.x-(5*player.xscale), player.y)
						efTrail.sprite = player.sprite
						efTrail.subimage = player.subimage
						efTrail.depth = player.depth+1
						efTrail.xscale = player.xscale*1.2
						efTrail.yscale = player.yscale*1.2
						efTrail.blendColor = Color.RED
				else 
					sndError:play()
					playerData.fuel = 0
				end
				
				sShoot:play()
				local damager = player:fireExplosion(player.x+16*player.xscale, player.y+ player:getData().air, 1.5, 1.5, 1.3)
				if player:getData().air > 0 then
					damager:getData().rGain = cost-1
				else
					damager:getData().rGain = cost+3
				end
			end
		end
		if skill == 2 then
			ParticleType.find("FireIce"):burst("middle", player.x-(4), player.y, 1)
			if relevantFrame == 3 then
				sBoom:play(1.6 + math.random() * 0.3,0.4)
			end
			if playerData.yInput ~= -1 and playerAc.pVspeed > 0 then
				playerAc.pVspeed = 0
			end
			if relevantFrame > 2 then
				
				if relevantFrame == 3 and  playerData.yInput == -1 and playerData.xInput == 0 then
					slamX:play(1.3 + math.random() * 0.3,0.7)
					while not player:collidesMap(player.x, player.y + 2) and playerData.fall < 300 do
						player.y = player.y + 2
						ParticleType.find("FireIce"):burst("middle", player.x-(5*player.xscale), player.y, 1)
						playerData.fall = playerData.fall + 1
					end
					
					if playerData.fall > 0 and player:collidesMap(player.x, player.y + 2) then
					
						if playerData.fall > 10 then
							local damager = player:fireExplosion(player.x, -10, 2.5, 10, math.max(3, math.ceil(1*playerData.fall/10)), nil, nil)
							damager:set("knockback", 3)
							damager:set("stun", 1)
							damager:getData().rGain = playerData.fall/3
							if onScreen(player) then
								ParticleType.find("spark"):burst("middle", player.x, player.y+5, math.max(2, math.ceil(1*playerData.fall/10)))
								ParticleType.find("Rubble2"):burst("middle", player.x, player.y+5, math.max(2,math.ceil(1*playerData.fall/10)))
								misc.shakeScreen(6)
							end
						end
					end
				end
				if relevantFrame > 4 then
					if playerData.fall > 0 and player:collidesMap(player.x, player.y + 2) then
							player.subimage = 6
					end
				end
				
				if playerData.yInput ~= 0 and playerData.xInput == 0 then
					playerAc.pVspeed = playerAc.pHmax*3*playerData.yInput*-1
				end
				
				if (playerData.yInput == 0) then	
					playerAc.pHspeed = playerAc.pHmax*4*player.xscale
				end
				
				if playerData.xInput == 1 and (playerData.yInput ~= 0) then	
					playerAc.pHspeed = playerAc.pHmax*2.5*player.xscale
					playerAc.pVspeed = playerAc.pHmax*2.5*playerData.yInput*-1
				end
				
				local damager = player:fireExplosion(player.x, player.y, 2, 2, 0.7, nil, nil)
					damager:set("knockback", 3)
			end
		end
		if skill == 3 then
			if player:get("free") ~= 1 then
				relevantFrame = 3 
				player.subimage = 3
				player:getData().air = 0
				playerAc.pVspeed = -0.5
				playerData.vault = true
			end
			
			if playerAc.moveRight == 1 and not player:collidesMap(player.x + playerAc.pHmax, player.y) and playerAc.pHspeed < playerAc.pHmax then
				playerAc.pHspeed = playerAc.pHmax/2
			elseif playerAc.moveLeft == 1 and not player:collidesMap(player.x - playerAc.pHmax, player.y) and playerAc.pHspeed > -playerAc.pHmax then
				playerAc.pHspeed = (playerAc.pHmax*-1)/2
			end
			if player:getData().air == 1 then
				if not playerData.vault then
					relevantFrame = 2 
					player.subimage = 2
					local enemy = enemies:findNearest(player.x, player.y)
					local xr, yr = 12, 12
					for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - xr, player.y - yr, player.x + xr, player.y + yr)) do
						if actor:get("team") ~= playerData.team and player:collidesWith(actor, player.x, player.y) and not playerData.hitEnemies[enemy] then
							if misc.getOption("video.quality") > 1 then
								ParticleType.find("spark"):burst("middle", player.x, player.y, 4)
							end
							playerData.vault = true
							playerData.maxCharge = 1
							player:getData().air = 0
							relevantFrame =3
							player.subimage = 3
							playerAc.pVspeed = -0.1
							player:setAlarm(2,0)
							player:setAlarm(3,0)
							if onScreen(player) then
								misc.shakeScreen(4)
								slamX:play(2 + math.random() * 0.3,0.7)
							end
							for i = 0, player:get("sp") do
								local damager = player:fireExplosion(player.x, player.y, 9 / 19, 9 / 4, 2, wellBoom, nil)
								damager:set("skin_newDamager", 1)
								damager:set("direction", player:getFacingDirection())
								damager:set("stun", 0.5)
								if i ~= 0 then
									damager:set("climb", i * 8)
								end
							end
						end
					end
				end
			end
			if relevantFrame > 3 then
				windSlash:play(1 + math.random() * 0.3,0.25)
				playerAc.pVspeed = relevantFrame/-2.5
				local damager = player:fireExplosion(player.x, player.y, 2, 2, 0.2, sprSparks, nil)
									damager:getData().rGain = 2
				local damager = player:fireExplosion(player.x, player.y, 2, 2, 0.5, sprSparks, nil)
									damager:getData().rGain = 5
				damager:set("knockup", damager:get("knockup") + 4)
				damager:set("stun", 0.5)
			end
		end
		if skill == 4 then
			if relevantFrame == 1 then
			local well = objWell:create(player.x, player.y)
			well:getData().parent = player
			well.depth = player.depth-1
			if input.checkControl("down", player) == input.HELD then
				well:getData().vSpeed =  0
			end
			sfxToss:play(1.6 + math.random() * 0.3)
				if player:get("scepter") > 0 then
					local well = objWell:create(player.x, player.y)
					well:getData().parent = player
					well.depth = player.depth-1
					well:getData().hSpeed =  11
					if input.checkControl("down", player) == input.HELD then
						well:getData().vSpeed =  0
					end
					local well = objWell:create(player.x, player.y)
					well:getData().parent = player
					well.depth = player.depth-1
					well:getData().hSpeed = -11
					if input.checkControl("down", player) == input.HELD then
						well:getData().vSpeed =  0
					end
				end
			end
		end
	end
end)

callback.register("onPlayerDraw", function(player)
	local playerData = player:getData()
	if SurvivorVariant.getActive(player) == Astro then
		if player:get("free") == 1 and player:get("activity") ~= 30 then
			if player:get("moveUpHold") == 1 and playerData.fuel > 0 then
				graphics.drawImage{
					image = player:getAnimation("hover"),
					x = player.x,
					y = player.y,
					xscale = player.xscale,
					yscale = player.yscale,
					color = player.blendColor,
					alpha = player.alpha,
					angle = player.angle,
					subimage = playerData.wingStep
				}
			end
		end
		local astroColor = Color.fromHex(0xcbdbfc)
		graphics.color(astroColor)
		graphics.rectangle(player.x-20, player.y+10, player.x-20+(math.floor(playerData.fuel/2.5)), player.y+13, false)
			graphics.drawImage{
			image = sprFuelBar,
			x = player.x-22,
			y = player.y+10,
			xscale =  1,
			yscale = 1,
			subimage = 1,
			color = player.blendColor,
			alpha = 1,
			angle = 0
			}
			
	end
end)

callback.register("onPlayerDrawBelow", function(player)
	if SurvivorVariant.getActive(player) == Astro then
		for _, well in ipairs(objWell:findAll()) do
			local wellAc = well:getAccessor()
			if well:getData().parent == player then
				if well:getData().drawCounter and well:getData().state == false then
					well:getData().drawCounter = well:getData().drawCounter + 0.1
						graphics.alpha((0.3 * math.sin(well:getData().drawCounter)) + 0.4)
						graphics.color(Color.fromHex(0x474656))
						local size = 77
						graphics.circle(well.x, well.y, size, false)
						graphics.color(Color.fromHex(0x50676f))
						graphics.alpha((0.6 * math.sin(well:getData().drawCounter)) + 0.4)
						local size = math.atan(-well:getData().drawCounter % math.pi) * 77
						graphics.circle(well.x, well.y, size, true)

				else 
					well:getData().drawCounter = 0
				end
			end
		end
	end
end)