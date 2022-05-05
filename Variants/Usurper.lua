
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Commando", "vanilla")
local path = "Variants/Usurper/"
local Usurper = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Usurper", -- The name of the skin.
Sprite.load("UsurperSelect", path.."Select", 9, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("UsurperIdle", path.."Idle", 1, 6, 5),
	walk = Sprite.load("UsurperWalk", path.."Walk", 8, 5, 6),
	jump = Sprite.load("UsurperJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("UsurperClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("UsurperDeath", path.."Death", 19, 15, 20),
	decoy = Sprite.load("UsurperDecoy", path.."Decoy", 1, 9, 12),
	
	shoot1 = Sprite.load("UsurperShoot1", path.."Shoot1", 6, 6, 7),
	shoot2 = Sprite.load("UsurperShoot2", path.."Shoot2", 7, 8, 10),
	shoot2B = Sprite.load("UsurperShoot2Still", path.."shoot2B", 5, 6, 5),
	shoot3 = Sprite.load("UsurperShoot3", path.."Shoot3", 10, 6, 6),
	shoot4 = Sprite.load("UsurperShoot4_1", path.."Shoot4", 13, 20, 19),
	shoot5 = Sprite.load("UsurperShoot4_2", path.."Shoot5", 14, 21, 29),
},
Color.fromHex(0xf4f3b7)) 
local shoot4Shade = Sprite.load("UsurperShoot4B", path.."Shoot4B", 13, 20, 19)
local shoot5Shade = Sprite.load("UsurperShoot5B", path.."Shoot5B", 14, 21, 29)
local swordSpawn = Sound.find("Shield")
local swordSlash = Sound.find("SamuraiShoot1")
local windSlash = Sound.find("SamuraiShoot2")
local slamX = Sound.find("Smite")
local swordSlam = Sound.find("JanitorShoot1_2")
local sprShadeDash = Sprite.load("UsurperShade2", path.."Shoot3S", 9, 6, 6)
local sfxShadeS = Sound.find("BoarExplosion")
local sfxShadeB = Sound.load("shSlashSFX", path.."shadeA")
local sprSkills = Sprite.load("UsurperSkill1", path.."skills", 5, 0, 0)
local skillC = Sound.load("chargSFX", path.."skillC")

SurvivorVariant.setInfoStats(Usurper, {{"Strength", 7}, {"Vitality", 6}, {"Trauma", 9}, {"Agility", 5}, {"Difficulty", 4}, {"Regicide", 10}}) 


SurvivorVariant.setDescription(Usurper, "The &y&Usurper&!& is a soldier, hardened with experience and lacking humanity. Having stolen the powers of a greater being, he favors close quarters over distance") 
Usurper.endingQuote = "..and so he left, finding means to an end."

SurvivorVariant.setLoadoutSkill(Usurper, "Gilded Jacket", 
"Shoot through enemies for from &y&150% to 400%&!& damage based on &b&proximity&!&, knocking them back.", 
sprSkills,2)


SurvivorVariant.setLoadoutSkill(Usurper, "Transcendant Dive", 
"Roll forwards, storing an &b&Umbra&!& that &b&Counterattacks&!& for &y&300% Damage &!&plus&r& a portion of your missing health&!&.", 
sprSkills,3)

SurvivorVariant.setLoadoutSkill(Usurper, "Tyrant's Slash", "&b&Charge&!& and Slam down an apropriated sword for &y&500% - 2000% Damage.&!&", sprSkills,4)

callback.register("onSkinInit", function(player, skin) 
-- This callback activates once the player has selected a skin and started a game.
-- Always use this to check initialization of skins, do not use the "onPlayerInit" or "onGameStart" callbacks for this matter.
	if skin == Usurper then
		player:survivorSetInitialStats(115, 12, 0.01)
		local playerData = player:getData()
		player:getData().counter = nil
		player:getData().counterSpawn = false
		player:getData().slashArmor = nil

		
		player:getData().release = false
		player:getData().skin_skill3Override = true
		player:getData().skin_skill4Override = true
		player:getData().charge = 0
		player:getData().chargeTier = 0
		player:getData().Frame = 0
		player:getData().getFrame = 0
		player:setSkill(2,
		"Gilded Jacket" ,
		"Shoot through enemies for 150% to 400% damage based on proximity, knocking them back",
		sprSkills, 2, 3*60)
		
		player:setSkill(3,
		"Transcendant Dive",
		"Roll forwards, storing an umbra that counter-attacks for 300% damage + a portion of your missing health.",
		sprSkills, 3, 5*60)
		
		player:setSkill(4,
		"Tyrant's Slash",
		"Charge and Slam down an apropriated sword for 500%-2000% Damage.",
		sprSkills, 4, 6*60)
		
	end
end)

function lerp(pos1, pos2, perc)
    return (1-perc)*pos1 + perc*pos2 -- Linear Interpolation
end

callback.register("preHit", function(damager,hit)
	if hit and hit:isValid() then
		local parent = damager:getParent()
		local damagerAc = damager:getAccessor()
		if damager:getData().range then
			
			local dropOffStart = damager:getParent().x+(20*parent.xscale)
			
			local dropOffEnd = damager:getParent().x+(80*parent.xscale)
			
			local distance = math.abs(hit.x - parent.x)
			
			distance = math.max(distance,20)
			
			distance = math.min(distance,80)
			
			local normal = ((distance-20)/(60))*-1
			
			local dmg_multi = normal+1.5
			
			local damage = damager:get("damage")*dmg_multi
			damager:set("damage",  damage) 
			damager:set("damage_fake", damage)
		end
		
		if hit:getData().counter then
			if SurvivorVariant.getActive(hit) == Usurper then
				hit:getData().counter = nil
				hit:getData().counterSpawn = true
				damagerAc.damage = 0
				hit:getAccessor().invincible = 60
			end
		end
	end
end)

local sprRWind = Sprite.load("RendingLightSprite",path.."RWind",8,15,16)

local objSpecial = Object.new("objSpecial")
local sprShade = Sprite.load("Umbra", path.."commandoumbra", 13, 21, 20)

objSpecial.sprite = sprShade
objSpecial.depth = 0

objSpecial:addCallback("create", function(self)--shadeSpawn
	local selfAc = self:getAccessor()
	self.mask = sprVehicleMask
	self:getData().spawned = false
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	self:getData().spAlt = nil
	selfAc.speed = 0
	self:getData().life = 180
	self.spriteSpeed = 0.25
	self:getData().Frame = 0
	self:getData().getFrame = 0
	self.spriteSpeed = 0.25
end)


objSpecial:addCallback("step", function(self)--ShadeCode
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	local selfData = self:getData()
	local hasHit = false
	if parent and parent:isValid() then	
	local playerAc = parent:getAccessor()
		if self:getData().Frame ~= math.floor(self.subimage) then
			self:getData().Frame = math.floor(self.subimage)
			self:getData().getFrame = math.floor(self.subimage)
		end
		
		if not selfData.spAlt then 
			
			if self:getData().getFrame == 1 then
				sfxShadeS:play(1.4 + math.random() * 0.3)
			end
			if self:getData().getFrame == 5 then
				sfxShadeB:play(1.6 + math.random() * 0.3)
				local explosion = parent:fireExplosion(self.x, self.y, 1.75, 1.25, 3 + math.abs((self:getData().sDamage*6)) , nil, sprSparks)
					explosion:set("skin_newDamager", 1)
					explosion:set("knockup", explosion:get("knockup")+2)
					explosion:set("stun", 0.25)
					if onScreen(self) then
						misc.shakeScreen(2) 
					end
			end
		else
			for _, actor in ipairs(ParentObject.find("actors"):findAllEllipse(self.x - 55, self.y - 55, self.x + 55, self.y + 55)) do
				local dis = distance(actor.x, actor.y, self.x, self.y)
				local speed = math.min((60 - dis) * 0.05, 0.75 * parent:get("attack_speed"))
				
				if actor:get("team") ~= parent:get("team") and not actor:isBoss() then
					actor.x = math.approach(actor.x, self.x, speed)
					actor.y = math.approach(actor.y, self.y, speed)
					if actor:isClassic() then
						local n = 0
						while actor:collidesMap(actor.x, actor.y) and n < 20 do
							actor.y = actor.y - 1
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
			if selfData.life > 0 then
			selfData.life = selfData.life-1
			end
			if selfAc.speed > 0 then
			selfAc.speed = selfAc.speed - 0.12
			end
			if selfAc.speed < 0 then 
			selfAc.speed = selfAc.speed + 0.12
			end
			
			if (self:getData().getFrame) == 3 or (self:getData().getFrame)  == 5 or (self:getData().getFrame)  == 7 or (self:getData().getFrame) == 1 then
				local explosion = parent:fireExplosion(self.x, self.y, 1.25, 1.25, 1+(parent:get("scepter")/2), nil, sprSparks)
				explosion:set("knockback", 0)
				windSlash:play(0.1 + math.random() * 0.3,0.25)
			end
	
		end
			if (self:getData().getFrame == 13) or selfData.life <= 0 then
			self:destroy()
			end
		if self:getData().getFrame ~= -1 then
			self:getData().getFrame = -1
		end
	end

end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == Usurper then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		
		local hpPercent = ( playerAc.hp - playerAc.maxhp)
		local hpPercentMissing = (math.abs(hpPercent) / math.abs(playerAc.maxhp))
		
		if playerData.counter then
			player:activateSkillCooldown(3)
			if playerData.counter % 8 == 0 and playerData.counter < 2*60 then
				ParticleType.find("Assassin"):burst("middle", player.x+(math.random(8)-math.random(8)), player.y+(math.random(8)-math.random(8)) ,1)
				ParticleType.find("PixelDust"):burst("middle", player.x+(math.random(8)-math.random(8)), player.y+(math.random(8)-math.random(8)), 1)
			end
		end
		if math.floor(playerAc.activity) ~= 4 and playerData.slashArmor then
			playerData.slashArmor = nil
			playerAc.armor = playerAc.armor - 30
		end
		if playerData.counterSpawn == true then
			local bullet = objSpecial:create(player.x, player.y)
					bullet:getData().parent = player
					bullet.xscale = player.xscale
					bullet:getData().sDamage = hpPercentMissing
			
			local c = Object.find("EfCircle"):create(player.x, player.y)
			c:set("radius", 5)
			c.blendColor = Color.BLACK
			playerData.counterSpawn = false
		end
		
		if playerData.counter then
			if playerData.counter > 0 then
				playerData.counter = playerData.counter - 1
			else
				playerData.counter = nil
			end
		end
	end
end)

survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == Usurper then
		player:setSkill(4,
		"Slicing Luminesence",
		"Slash upwards with your sword for 700% Damage, and sumon a projectile that deals 100% Damage rapidly.",
		sprSkills, 5,  6* 60)
	end
end)

SurvivorVariant.setSkill(Usurper, 2, function(player)--
	  SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
end)

SurvivorVariant.setSkill(Usurper, 3, function(player)
	-- X skill
	if input.checkControl("down", player) == input.HELD then
		SurvivorVariant.activityState(player, 3.1, player:getAnimation("shoot2B"), 0.25, true, true)
	else
	SurvivorVariant.activityState(player,3, player:getAnimation("shoot3"), 0.2, false, false)
	end
	
end)


SurvivorVariant.setSkill(Usurper, 4, function(player)
		if player:get("scepter") > 0 then
			SurvivorVariant.activityState(player,4.1, player:getAnimation("shoot5"), 0.2, false, true)
		else
		SurvivorVariant.activityState(player,4, player:getAnimation("shoot4"), 0.2, false, true)
		end
		player:getData().charge = 0
		player:getData().chargeTier = 0
		player:getData().Frame = 0
		player:getData().getFrame = 0
		player:getData().release = false
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if SurvivorVariant.getActive(player) == Usurper then
		if skill == 2 then
			if relevantFrame == 1 then
				if onScreen(player) then
					Sound.find("Bullet2"):play()
					misc.shakeScreen(4)
				end
				local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 300, 4, Sprite.find("Sparks2"), DAMAGER_BULLET_PIERCE)
				bullet:getData().range = true
			end
		end
		
		if skill == 3 then
			player:getData().counter = 2*60
			if relevantFrame > 1 then
				playerAc.pHspeed = playerAc.pHmax*2*player.xscale
				local efTrail = Object.find("EfTrail"):create(player.x , player.y)
				efTrail.sprite = sprShadeDash
				efTrail.subimage = player.subimage-1
				efTrail.xscale = player.xscale
			end
		end
		if skill == 3.1 then
			player:getData().counter = 2*60
		end
		
		if skill == 4 then
			if syncControlRelease(player, "ability4") then
				playerData.release = true
			end
			
			if relevantFrame == 1 then
				player:getData().skin_onActivity = true
				if not playerData.slashArmor then
					playerData.slashArmor = true
					playerAc.armor = playerAc.armor + 30
				end
			end
			
			if playerData.release == false then
				if player.subimage > 6.5 then
					player.subimage = 5
				end
				if player:getData().charge < 60 then 
					player:getData().charge = player:getData().charge + player:getAccessor().attack_speed
				else
					playerData.chargeTier = -1
					playerData.release = true
				end
				if player:getData().charge >= 40 and player:getData().chargeTier < 3 then
					player:getData().charge = 0
					player:getData().chargeTier = player:getData().chargeTier + 1
					local c = Object.find("EfCircle"):create(player.x, player.y)
					local efTrail = Object.find("EfTrail"):create(player.x , player.y)
					efTrail.sprite = shoot4Shade
					efTrail.subimage = player.subimage
					efTrail.depth = player.depth-1
					
						if player:getData().chargeTier == 1 then
							c:set("radius", 2)
							c.blendColor = Color.YELLOW
							efTrail.xscale = player.xscale*1.25
							efTrail.yscale = player.yscale*1.25
							efTrail.blendColor = Color.YELLOW
							if onScreen(player) then
								skillC:play(0.6 + math.random() * 0.3)
							end
						elseif player:getData().chargeTier == 2 then
							c:set("radius", 4)
							c.blendColor = Color.RED
							efTrail.xscale = player.xscale*1.5
							efTrail.yscale = player.yscale*1.5
							efTrail.blendColor = Color.RED
							if onScreen(player) then
								skillC:play(0.8 + math.random() * 0.3)
							end
						elseif player:getData().chargeTier == 3 then
							c:set("radius", 6)
							c.blendColor = Color.WHITE
							efTrail.xscale = player.xscale*2
							efTrail.yscale = player.yscale*2
							efTrail.blendColor = Color.WHITE
							if onScreen(player) then
								misc.shakeScreen(1)
								skillC:play(1 + math.random() * 0.3)
								ParticleType.find("spark"):burst("middle", player.x, player.y+4, 2)
							end
						elseif player:getData().chargeTier == -1 then
							c:set("radius", 1)
							c.blendColor = Color.BLACK
							efTrail.xscale = player.xscale
							efTrail.yscale = player.yscale
							efTrail.blendColor = Color.BLACK
							if onScreen(player) then
								misc.shakeScreen(1)
								skillC:play(0.1)
								ParticleType.find("spark"):burst("middle", player.x, player.y+4, 2)
							end
						end
				end
			end
			if relevantFrame == 2 then
				swordSpawn:play(1.2 + math.random() * 0.3)
			end
			if relevantFrame == 8 then
				swordSlash:play(1.1 + math.random() * 0.3)
			end
			if relevantFrame == 9 then
				local n = 0
				while not player:collidesMap(player.x, player.y + 2) and n < 150 do
					player.y = player.y + 2
					n = n + 1
				end
				if player:getData().chargeTier > 2 then
					slamX:play(1.3 + math.random() * 0.3,0.7)
				end
					if onScreen(player) then
						swordSlam:play(1.9 + math.random() * 0.3,0.7)
						misc.shakeScreen(2*playerData.chargeTier)
					end
				for i = 0, player:get("sp") do
					local bullet = player:fireExplosion(player.x+8, player.y, 1.5, 2, math.max (5*(1.25*player:getData().chargeTier),5), nil, sprSparks7)
					bullet:set("max_hit_number", 5)
					bullet:set("knockup", bullet:get("knockup") + 3)
					bullet:set("knockback_direction",player.xscale)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				if player:get("free") == 0 then
					ParticleType.find("spark"):burst("middle", player.x+(27*(player.xscale)), player.y+5, math.max(3,3*player:getData().chargeTier))
					ParticleType.find("Rubble2"):burst("middle", player.x+(27*(player.xscale)), player.y+5, math.max(2,2*player:getData().chargeTier))
				end
			end
		end
		if skill == 4.1 then
			if syncControlRelease(player, "ability4") then
				playerData.release = true
			end
			if playerData.release == false then
				if player.subimage > 6.5 then
					player.subimage = 5
				end
				if player:getData().charge < 60 then 
					player:getData().charge = player:getData().charge + player:getAccessor().attack_speed
				else
					playerData.chargeTier = 1 
					playerData.release = true
				end
				if player:getData().charge >= 40 and player:getData().chargeTier < 3 then
					player:getData().charge = 0
					player:getData().chargeTier = player:getData().chargeTier + 1
					local c = Object.find("EfCircle"):create(player.x, player.y)
					local efTrail = Object.find("EfTrail"):create(player.x , player.y)
					efTrail.sprite = shoot5Shade
					efTrail.subimage = player.subimage
					efTrail.depth = player.depth-1
					
						if player:getData().chargeTier == 1 then
							c:set("radius", 2)
							c.blendColor = Color.YELLOW
							efTrail.xscale = player.xscale*1.25
							efTrail.yscale = player.yscale*1.25
							efTrail.blendColor = Color.YELLOW
							skillC:play(0.6 + math.random() * 0.3)
						
						elseif player:getData().chargeTier == 2 then
							c:set("radius", 4)
							c.blendColor = Color.RED
							efTrail.xscale = player.xscale*1.5
							efTrail.yscale = player.yscale*1.5
							efTrail.blendColor = Color.RED
							skillC:play(0.8 + math.random() * 0.3)
							
						elseif player:getData().chargeTier == 3 then
							c:set("radius", 6)
							c.blendColor = Color.WHITE
							efTrail.xscale = player.xscale*2
							efTrail.yscale = player.yscale*2
							efTrail.blendColor = Color.WHITE
							if onScreen(player) then
								misc.shakeScreen(1)
								skillC:play(1 + math.random() * 0.3)
							end
							ParticleType.find("spark"):burst("middle", player.x, player.y+4, 2)
						end
				end
			end
			
			if relevantFrame == 1 then
				if not playerData.slashArmor then
					playerData.slashArmor = true
					playerAc.armor = playerAc.armor + 30
				end
			end
			if relevantFrame == 2 then
				swordSpawn:play(1.2 + math.random() * 0.3)
			end
			if relevantFrame == 7 then
				swordSlash:play(1.1 + math.random() * 0.3)
			end
			if relevantFrame < 8 and playerAc.pVspeed > 0.5 then
				playerAc.pVspeed = 0.5
			end
			if relevantFrame == 8 then
				playerAc.pVspeed = -4
				if player:getData().chargeTier > 2 then
					slamX:play(1.3 + math.random() * 0.3,0.7)
				end
				if onScreen(player) then
					swordSlam:play(3 + math.random() * 0.3,0.7)
					misc.shakeScreen(playerData.chargeTier)
				end
				for i = 0, player:get("sp") do
					local slice = objSpecial:create(player.x, player.y)
					slice:getData().parent = player
					slice.xscale = player.xscale
					slice:set("direction", player:getFacingDirection())
					slice:getData().speed = 15
					slice:getData().spAlt = true
					slice:set("speed",3.5)
					slice.sprite = sprRWind
					
					local bullet = player:fireExplosion(player.x+8, player.y, 1.5, 2, math.max(5*(1.25*player:getData().chargeTier),5), nil, sprSparks7)
					bullet:set("max_hit_number", 5)
					bullet:set("knockup", bullet:get("knockup") + 3)
					bullet:set("knockback_direction",player.xscale)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end

				end
				if player:get("free") == 0 then
					ParticleType.find("spark"):burst("middle", player.x+(27*(player.xscale)), player.y+5, 5)
				end
			end
		end
	end
end)
