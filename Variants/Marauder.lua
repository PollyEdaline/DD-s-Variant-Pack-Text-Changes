local survivor = Survivor.find("Executioner", "Starstorm")
local path = "Variants/Marauder/"

obj = setmetatable({}, { __index = function(t, k)
	return Object.find(k)
end})

par = setmetatable({}, { __index = function(t, k)
	return ParticleType.find(k)
end})

function contains(t, value)
	if t then
		for _, v in pairs(t) do
			if v == value then
				return true
			end
		end
		return false
	else
		return false
	end
end


local MarauderExplosion = Sprite.load("raidExplosion", path.."MarauderSplod", 6, 32, 26)
-- MarauderExplosion
par.MarauderExplosion = ParticleType.new("MarauderExplosion")
par.MarauderExplosion:sprite(MarauderExplosion, true, true, false)
par.MarauderExplosion:life(15, 30)
par.MarauderExplosion:angle(0, 360, 0.5, 0, true)
par.MarauderExplosion:gravity(0.0008, 90)

local MarauderExplosion2 = Sprite.load("MarauderExplosion2", path.."raidSlpod2", 6, 32, 26)
-- MarauderExplosion
par.MarauderExplosion2 = ParticleType.new("MarauderExplosion2")
par.MarauderExplosion2:sprite(MarauderExplosion2, true, true, false)
par.MarauderExplosion2:life(15, 30)
par.MarauderExplosion2:angle(0, 360, 0.5, 0, true)
par.MarauderExplosion2:gravity(0.0008, 90)

local rBullet = Sprite.load("rBullet2", path.."bulletPopup", 11, 8, 3)
-- MarauderExplosion
par.rBullet = ParticleType.new("rBulletPar")
par.rBullet:sprite(rBullet, true, true, false)
par.rBullet:life(60, 60)
par.rBullet:gravity(0.0008, 90)


local Marauder = SurvivorVariant.new(
survivor,
"Marauder",
Sprite.load("MarauderSelect", path.."Select", 16, 2, 0),
{		idle = Sprite.load("Marauder", path.."Idle", 1, 8, 6),
		jump = Sprite.load("MarauderJump", path.."Jump", 1, 9, 11),
		walk = Sprite.load("MarauderWalk", path.."Walk", 8, 8, 11),
		climb = Sprite.load("MarauderClimb", path.."Climb", 2, 6, 7),
		shoot1_1 = Sprite.load("MarauderShoot1_1", path.."Shoot1_1", 6, 22, 15),
		shoot1_2 = Sprite.load("MarauderShoot1_2", path.."Shoot1_2", 7, 22, 15),
		shoot1_3 = Sprite.load("MarauderShoot1_3", path.."Shoot1_3", 8, 24, 15),
		shoot2_1 = Sprite.load("MarauderShoot2_1", path.."Shoot2_1", 6, 13, 15),
		shoot2_2 = Sprite.load("MarauderShoot2_2", path.."Shoot2_2", 7, 13, 15),
		shoot3 = Sprite.load("MarauderShoot3", path.."Shoot3", 12, 10, 10),
		shoot4_1 = Sprite.load("MarauderShoot4A", path.."Shoot4", 6, 16, 15),
		shoot5_1 = Sprite.load("MarauderShoot4A2", path.."Shoot4_2", 6, 16, 15),
		death = Sprite.load("MarauderDeath", path.."Death", 10, 37, 21),
		decoy = Sprite.load("MarauderDecoy", path.."Decoy", 1, 9, 18),
		
}, Color.fromHex(0xFC4E45))
	SurvivorVariant.setInfoStats(Marauder, {{"Strength", 8}, {"Vitality", 8}, {"Mobility", 7}, {"Valor",9}, {"Difficulty", 6}, {"Wisdom", 1}})
	SurvivorVariant.setDescription(Marauder, "The Marauder is a relentless, reckless fighter. Armed with a gunblade, he is capable of dealing massive bursts of damage at close range with &y&Crescent Edge&!& and &y&Burst Break&!&, and closing distance with &y&Sonic Shock&!&.")
		
	Marauder.endingQuote = "..and so he left, arms forever trembling from recoil."
	local skillC = Sound.load("chargedSFX", path.."skillC")
	local sShoot2 = Sound.load("MarauderShoot1", path.."Shoot2")
	local bigBoom = Sound.find("ExplosiveShot")
	local sShoot3Charge = Sound.find("HuntressShoot3")
	
	local sprSkills2 = Sprite.load("MarauderSkills_2", path.."skillsCount", 4, 0, 0)
	local sprSkills3 = Sprite.load("MarauderSkills_3", path.."skillsCount2", 4, 0, 0)
	local shoot4_C = Sprite.load("MarauderShoot4C", path.."Shoot4C", 7, 16, 16)
	local shoot4_C2 = Sprite.load("MarauderShoot4C2", path.."Shoot4C2", 7, 16, 16)
	local sprSparks = Sprite.find("Sparks9r")
	local sprSkills = Sprite.load("MarauderSkill", path.."Skill", 6, 0, 0)
	
	SurvivorVariant.setLoadoutSkill(Marauder, "Crescent Edge", "Slash a gunblade for &y&120% damage&!&. &r&Land the third hit of the combo to gain 1 Ammunition&!&.", sprSkills,1)
	SurvivorVariant.setLoadoutSkill(Marauder, "Burst Break", "Shoot a projectile that explodes for &y&175% damage&!&. &r&Requires Ammunition&!&.", sprSkills, 2)
	SurvivorVariant.setLoadoutSkill(Marauder, "Savage Dive", "Dash forward for &y&120% damage&!&. Getting hit grants invulnerability and &b&overcharges&!& &y&Burst Break&!&.", sprSkills, 3)
	SurvivorVariant.setLoadoutSkill(Marauder, "Sonic Shock", "Fire your gunblade into the ground for &y&250% damage&!&. The recoil &b&sends you upwards&!&.", sprSkills, 4)
	
	callback.register("onSkinInit", function(player, skin)
		if skin == Marauder then
			local playerAc = player:getAccessor()
			player:setAnimation("shoot1", Marauder.animations.shoot1_1)
			player:getData().MarauderCounter = nil
			player:getData().chargedBullets = 1
			player:getData().overCharge = 0
			player:getData().cd2 = 0
			player:getData().hitEnemies = {}
			player:getData().MarauderCount = 0
			player:getData().MarauderCountTimer = 90
			player:getData().skin_onActivity = false
			
			playerAc.ionBullets = 1
			
			player:getModData("Starstorm").skin_skill1Override = true
			player:getModData("Starstorm").skin_skill2Override = true
			player:getModData("Starstorm").skin_skill3Override = true
			player:getModData("Starstorm").skin_skill4Override = true
		
			player:set("pHmax", player:get("pHmax") + 0.1)

			player:survivorSetInitialStats(125, 12, 0.02)
			player:setSkill(1,
			"Crescent Edge", "Slash a gunblade for 120% damage. Land the third hit of the combo to gain 1 Ammunition",
			sprSkills, 1, 15)
			
			player:setSkill(2,
			"Burst Break", "Shoot a projectile that explodes for 175% damage. Requires Ammunition.",
			sprSkills, 2, 15 * 60)
			
			player:setSkill(3,
			"Savage Dive", "Dash forward for 120% damage. Getting hit grants invulnerability and overcharges Burst Break.",
			sprSkills, 4, 6 * 60)
			
			player:setSkill(4,
			"Sonic Shock", "Fire your gunblade into the ground for 250% damage. The recoil sends you upwards.",
			sprSkills, 5, 7 * 60)
		end
	end)
	
survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == Marauder then
		player:setSkill(4,
		"Azure Sonic Shock", "Fire your gunblade into the ground for 3x150% damage. The recoil sends you upwards.",
			sprSkills, 6, 7 * 60)
	end
end)

		
	callback.register("onPlayerStep", function(player)
			if SurvivorVariant.getActive(player) == Marauder then
			local playerData = player:getData()
			
			if playerData.chargedBullets > 3 then
				playerData.chargedBullets = 3
			end
			if playerData.chargedBullets < 0 then
				playerData.chargedBullets = 0
			end
			
			if player:getAlarm(3) == 0 and playerData.chargedBullets == 0 then
				playerData.chargedBullets = 1
			end
			if player:getData().MarauderCountTimer > 0 then
				player:getData().MarauderCountTimer = player:getData().MarauderCountTimer -1
			else
				if player:getData().MarauderCount > 0 then
				 player:getData().MarauderCount = 0
				end	
			end
			
			if playerData.chargedBullets > 0 and player:getAlarm(3) > 0 then
				player:setAlarm(3,0)

			end
			if playerData.chargedBullets > 0 and playerData.chargedBullets < 3 then
				if player:getData().cd2 <  15 * 60 then
					player:getData().cd2 = player:getData().cd2 +1
				else 
					player:getData().chargedBullets = player:getData().chargedBullets + 1
					player:getData().cd2 = 0
				end
			end
			if playerData.overCharge > 0 then
			player:setSkill(2,
			"Azure Burst Break", "Shoot a projectile that explodes for 3x175% damage. Requires Ammunition.",
			sprSkills, 3, 15 * 60)
			else
			player:setSkill(2,
			"Burst Break", "Shoot a projectile that explodes for 175% damage. Requires Ammunition.",
			sprSkills, 2, 15 * 60)
			end
			if playerData.MarauderCounter then
				if playerData.MarauderCounter > 0 then
					playerData.MarauderCounter = playerData.MarauderCounter - 1
				else
					playerData.MarauderCounter = nil
				end
			end
		end
	end)
	
	local MarauderSlash = Object.new("MarauderSlash")
	MarauderSlash.sprite = Sprite.load("MarauderShoot1B", path.."Shoot1B", 4, 16, 9)
	MarauderSlash.depth = -8
	MarauderSlash:addCallback("create", function(self)
		local selfData = self:getData()
		selfData.life = 15
		
		selfData.direction = 0
		selfData.speed = 4
		selfData.team = "player"
		selfData.hitList = {}
		self.spriteSpeed = 0.2
		self.yscale = 1.25
	end)
	
	MarauderSlash:addCallback("step", function(self)
		local selfData = self:getData()
		if selfData.life > 0 then
			selfData.life = selfData.life - 1
			self.x = self.x + selfData.direction * selfData.speed
			
			self.yscale = self.yscale - 0.0085
			self.xscale = selfData.direction
			
			--if self:collidesMap(self.x + selfData.direction, self.y) then
			--	selfData.life = 0
			--end
			self.alpha = selfData.life * 0.1
			
			local xr, yr = 10, 50
			if selfData.parent and selfData.parent:isValid() then
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
					if actor:get("team") ~= selfData.team and not selfData.hitList[actor] then
						if actor:collidesWith(self, actor.x, actor.y) then
							selfData.hitList[actor] = true
							local b = selfData.parent:fireBullet(actor.x + (selfData.direction * -1), actor.y, actor:getFacingDirection(), 2, 1.3, sprSparks)
							b:set("specific_target", actor.id)
							b:set("bleed", 0.8)
						end
					end
				end
			end
		else
			self:destroy()
		end
	end)
	
	
	
	local MarauderDetonate = Object.new("MarauderDetonate")
	MarauderDetonate.depth = -8
		
	MarauderDetonate:addCallback("create", function(self)
		local selfData = self:getData()
		selfData.life = 15
		
		selfData.direction = 0
		selfData.speed = 4
		selfData.team = "player"
		selfData.hitList = {}
		self.yscale = 1.25
	end)
	
	MarauderDetonate:addCallback("step", function(self)
		local selfData = self:getData()
		local parent = selfData.parent
		if selfData.life > 0 then
			selfData.life = selfData.life - 1
			
			if selfData.parent and selfData.parent:isValid() then
				if selfData.life % 5 == 0 then 
					if onScreen(player) then
						misc.shakeScreen(4)
						local e = math.random(32)
						bigBoom:play(1 + math.random() * 0.7)
						par.MarauderExplosion2:burst("middle", self.x-16+e, self.y-16+e, 1)
						ParticleType.find("spark"):burst("middle", self.x-16+e, self.y-16+e, 6)
					end
					local explosion = parent:fireExplosion(self.x, self.y, 1.25, 1.25, 1.25, nil, nil)
				end
			end
		else
			self:destroy()
		end
	end)
	
	callback.register("preHit", function(damager,hit)
		if hit and hit:isValid() then
			local parent = damager:getParent()
			local damagerAc = damager:getAccessor()
			
			if damager:getData().MarauderAmmoPlus then
				if parent:getData().chargedBullets < 3 then
					par.rBullet:burst("middle", parent.x, parent.y-32, 1)
					parent:getData().chargedBullets = parent:getData().chargedBullets + 1
				end
			end
			if damager:getData().burst then
				
				if damager:getData().burst == 1 then
				local explosion = parent:fireExplosion(hit.x, hit.y, 1.25, 1.25, 1.75, nil, nil)
					if onScreen(player) then
					misc.shakeScreen(4)
						local e = math.random(8)
						par.MarauderExplosion:burst("middle", hit.x-4+e, hit.y-4+e, 1)
						
						ParticleType.find("spark"):burst("middle", hit.x-4+e, hit.y-4+e, 4)
						bigBoom:play(1 + math.random() * 0.7)
					end
				else
					local explosion2 = MarauderDetonate:create(hit.x, hit.y)
					explosion2:getData().parent = parent
				end
			end

			if hit:getData().MarauderCounter then
				hit:getData().MarauderCounter = nil
				damagerAc.damage = 0
				if hit:getData().chargedBullets < 3 then
					hit:getData().chargedBullets = hit:getData().chargedBullets + 1
				end
				
				hit:getAccessor().invincible = 25
				skillC:play()
				hit:getData().cd2 = 0
				hit:getData().overCharge = 1
			end
		end
	end)
	
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == Marauder then
			player:survivorLevelUpStats(3, 0, 0.002, 3)
		end
	end)

	
	SurvivorVariant.setSkill(Marauder, 1, function(player)
		player:getData().MarauderCountTimer = 90
		if player:getData().MarauderCount == 0 then
			player:setAnimation("shoot1", Marauder.animations.shoot1_1)
			SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_1"), 0.2, true, true)
		elseif player:getData().MarauderCount == 1 then
			player:setAnimation("shoot1", Marauder.animations.shoot1_2)
			SurvivorVariant.activityState(player, 1.2, player:getAnimation("shoot1_2"), 0.2, true, true)
		elseif player:getData().MarauderCount == 2 then
			player:setAnimation("shoot1", Marauder.animations.shoot1_3)
			SurvivorVariant.activityState(player, 1.3, player:getAnimation("shoot1_3"), 0.2, true, true)	
		end
	end)
	
	SurvivorVariant.setSkill(Marauder, 2, function(player)
		local playerData = player:getData()
		
		if player:getData().overCharge == 0 then
			player:setAnimation("shoot2", Marauder.animations.shoot2_1)
			SurvivorVariant.activityState(player, 2.1, player:getAnimation("shoot2_1"), 0.20, true, true)
			playerData.chargedBullets = playerData.chargedBullets -1
			if playerData.chargedBullets > 0 then
				player:setAlarm(3,0)
			end
		else
			player:getData().overCharge = player:getData().overCharge -1
			
			player:setAnimation("shoot2", Marauder.animations.shoot2_2)
			SurvivorVariant.activityState(player, 2.2, player:getAnimation("shoot2_2"), 0.20, true, true)
			playerData.chargedBullets = playerData.chargedBullets -1
			if playerData.chargedBullets > 0 then
				player:setAlarm(3,0)
			end
		end
		player:getData().cd2 = 0
	end)
	
	SurvivorVariant.setSkill(Marauder, 3, function(player)
		SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, false, false)
		player:getAccessor().pHspeed = 0
		player:getData().skin_onActivity = false
	end)
	
	SurvivorVariant.setSkill(Marauder, 4, function(player)
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4_1"), 0.2, false, false)
	end)
	
	SurvivorVariant.setSkill(Marauder, 5, function(player)
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4_1"), 0.2, false, false)
	end)
local enemies = ParentObject.find("enemies")
	callback.register("onSkinSkill", function(player, skill, relevantFrame)
		if SurvivorVariant.getActive(player) == Marauder then
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if skill == 1.1 then
				if relevantFrame == 1 then
					
					player:getData().MarauderCount = 1
				elseif relevantFrame == 3 then
					if player:get("free") ~= 1 then
						playerAc.pHspeed = playerAc.pHmax*4*player.xscale
					else
						playerAc.pHspeed = playerAc.pHmax*2*player.xscale
					end
					sShoot2:play(2 + math.random() * 0.2,0.7)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 10, player.y, 27 / 19, 10 / 4, 1.3, nil, sprSparks1)
						bullet:getData().pushSide = 1.2 * player.xscale
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				
			elseif skill == 1.2 then
				if relevantFrame == 1 then
					player:getData().MarauderCount = 2
				elseif relevantFrame == 3 then
					if player:get("free") ~= 1 then
						playerAc.pHspeed = playerAc.pHmax*4*player.xscale
					else
						playerAc.pHspeed = playerAc.pHmax*2*player.xscale
					end
					sShoot2:play(2 + math.random() * 0.2,0.7)
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + player.xscale * 10, player.y, 27 / 19, 10 / 4, 1.3, nil, sprSparks1)
						bullet:getData().pushSide = 1.2 * player.xscale
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif skill == 1.3 then
				if relevantFrame == 1 then
					player:getData().MarauderCount = 0
				elseif relevantFrame == 3 then
					local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 32, 0.8, shoot4_C )
					bullet:getData().MarauderAmmoPlus = 1
					if player:get("free") ~= 1 then
						playerAc.pHspeed = playerAc.pHmax*4*player.xscale
					else
						playerAc.pHspeed = playerAc.pHmax*2*player.xscale
					end
					sShoot2:play(0.9 + math.random() * 0.2)
					
					local slash = MarauderSlash:create(player.x + player.xscale * 3, player.y + 6)
					slash:getData().direction = player.xscale
					slash:getData().parent = player
					slash:getData().team = player:get("team")
				end
			elseif skill == 2.1 then
				if relevantFrame == 2 then
					playerAc.pHspeed = playerAc.pHmax*4*player.xscale*-1
				end
				
				if relevantFrame == 1 then
					Sound.find("Bullet2"):play(1 + math.random() * 0.7)
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 200, 0.3, shoot4_C )
						bullet:getData().burst = 1
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif skill == 2.2 then
				if relevantFrame == 2 then
					playerAc.pHspeed = playerAc.pHmax*6*player.xscale*-1
				end
				if relevantFrame == 1 then
					Sound.find("Bullet2"):play(1 + math.random() * 0.7)
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 200, 0.6, shoot4_C2 )
						bullet:getData().burst = 2
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				
			elseif skill == 3 then
				player:getData().MarauderCounter = 20
				local enemy = enemies:findNearest(player.x, player.y)
				
				if relevantFrame == 7 then
					player:getData().skin_onActivity = true
					Sound.find("Boss1Shoot1"):play(1.3 + math.random() * 0.2)
				end
				
				if relevantFrame > 6 and relevantFrame < 11 then
						
								
					playerAc.pHspeed = playerAc.pHmax*4*player.xscale
				end
				if relevantFrame == 11 then
					player:getData().skin_onActivity = false
					playerAc.pHspeed = 0
				end
				if player:getData().skin_onActivity == true then
					local xr, yr = 10 * player.xscale, 12 * player.yscale
					for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(player.x - xr, player.y - yr, player.x + xr, player.y + yr)) do
						if actor:get("team") ~= "player" and player:collidesWith(actor, player.x, player.y) and not player:getData().hitEnemies[enemy] then
							if misc.getOption("video.quality") > 1 then
								ParticleType.find("spark"):burst("middle", player.x, player.y, 2)
							end
									
							playerData.hitEnemies[enemy] = true
							local parent = player
							for i = 0, parent:get("sp") do
								local damager = parent:fireExplosion(player.x, player.y, 9 / 19, 9 / 4, 1.2, sprSparks, nil)
								damager:set("skin_newDamager", 1)
								damager:set("stun", damager:get("stun")+1)
								damager:set("direction", parent:getFacingDirection())
								damager:getModData("Starstorm")._chirrTag = true
								if i ~= 0 then
									damager:set("climb", i * 8)
									end
							end
						end
					end
				end
			elseif skill == 4 then
			
				if relevantFrame == 1 then
					playerAc.pVspeed = -4.3
					
					if player:get("scepter") > 0 then
						local explosion3 = MarauderDetonate:create(player.x, player.y)
						explosion3:getData().parent = player
						explosion3:getData().life = 10+(5*player:get("scepter"))
					else
						par.MarauderExplosion:burst("middle", player.x+6*player.xscale, player.y, 1)
						Sound.find("Bullet2"):play()
						for i = 0, playerAc.sp do
							bigBoom:play(0.8 + math.random() * 0.7)
							local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 50, 2.5, sprSparks, DAMAGER_BULLET_PIERCE)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				end
				
				if relevantFrame > 0 then
					playerAc.pHspeed = playerAc.pHmax*2.2*player.xscale*-1
				end
			end
		end
	end)
	
	
	callback.register("onPlayerHUDDraw", function(player, x, y)
		if SurvivorVariant.getActive(player) == Marauder then
			local bullets = player:getData().chargedBullets
			if player:getData().overCharge < 1 then
			graphics.drawImage{
				image = sprSkills2,
				subimage = bullets + 1,
				y = y - 11,
				x = x + 18 + 5
			}
			else
			graphics.drawImage{
				image = sprSkills3,
				subimage = bullets + 1,
				y = y - 11,
				x = x + 18 + 5
			}
			end
		end
	end)