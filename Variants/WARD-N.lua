-- On-screen Function
function onScreen(instance)
    if instance and instance:isValid() then
        local camerax = camera.x + (camera.width / 2)
        local cameray = camera.y + (camera.height / 2)
        
        if camera then
            local w, h = graphics.getHUDResolution()
            if camerax - (w / 2) - 20 < instance.x and camerax + (w / 2) + 20 > instance.x
            and cameray - (h / 2) - 20 < instance.y and cameray + (h / 2) + 20 > instance.y then
                return true
            end
        end
    end
end

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

local bunkered = 0
local survivor = Survivor.find("Enforcer", "vanilla")

local skinName = "WARD-N" -- The name of the skin.
local path = "Variants/WARD-N/" -- The location of all files (relative).
-- This assigns the new skin we are creating to the variable "WARDN".
local WARDN = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Enforcer).
skinName, -- The name previously declared.
Sprite.load(skinName.."Select", path.."Select", 17, 2, 0), -- The Selection sprite.
{ -- This is a table containing all the used sprites by their keys, which depend on each survivor, can be left nil to not replace any sprites.
	idle_1 = Sprite.load(skinName.."Idle_1", path.."Idle_1", 1, 10, 14),
	idle_2 = Sprite.load(skinName.."Idle_2", path.."Idle_2", 3, 10, 14),
	walk_1 = Sprite.load(skinName.."Walk_1", path.."Walk_1", 8, 10, 14),
	walk_2 = Sprite.load(skinName.."Walk_2", path.."Walk_2", 6, 10, 14),
	jump = Sprite.load(skinName.."Jump", path.."Jump", 4, 11, 10),
	climb = Sprite.load(skinName.."Climb", path.."Climb", 2, 12, 15),
	death = Sprite.load(skinName.."Death", path.."Death", 9, 13, 19),
	decoy = Sprite.load(skinName.."Decoy", path.."Decoy", 1, 12, 10),
	
	shoot1_1 = Sprite.load(skinName.."Shoot1_1", path.."Shoot1_1", 8, 11, 14),
	shoot1_2 = Sprite.load(skinName.."Shoot1_2", path.."Shoot1_2", 8, 11, 14),
	shoot2_1 = Sprite.load(skinName.."Shoot2", path.."Shoot2", 20, 29, 14),
	shoot3_1 = Sprite.load(skinName.."Shoot3_1", path.."Shoot3_1", 8, 10, 14),
	shoot3_2 = Sprite.load(skinName.."Shoot3_2", path.."Shoot3_2", 8, 10, 14),
	shoot4_1 = Sprite.load(skinName.."Shoot4_1", path.."Shoot4_1", 6, 10, 14),
	shoot4_2 = Sprite.load(skinName.."Shoot4_2", path.."Shoot4_2", 23, 14, 14),
},
Color.fromHex(0x6c7977)) 
local sprSkills = Sprite.load("WARDN_SKILLS",path.."Skills",6,0,0)

local sShoot = Sound.load("RMORShoot1", path.."Shoot1")
local sShootOriginal = Sound.find("JanitorShoot1_2")
local sSlamOriginal = Sound.find("JanitorShoot4_2")
local sprSparks = Sprite.find("Sparks9r")
local rocketShoot = Sound.load("rocketShoot", path.."skill3b")
local punch = Sound.find("JanitorShoot1_1")
local bigBoom = Sound.find("MinerShoot4")

SurvivorVariant.setLoadoutSkill(WARDN, "GAS BOMB", "LAUNCH A PIERCING BOMB FOR &y&100% DAMAGE. EXPLODES FOR &y&250% DAMAGE.", sprSkills,0)
SurvivorVariant.setLoadoutSkill(WARDN, "PLOW", "JET THROUGH THE MASSES, DEALING 9x75% DAMAGE, , SLAM SHIELD FOR &y&100% DAMAGE. SCALES WITH SPEED.", sprSkills,2)
SurvivorVariant.setLoadoutSkill(WARDN, "BARRICADE", "ERECT AN ELECTRIC BARRICADE, SHOCKING RIOTERS FOR  &y&15x70% DAMAGE.", sprSkills,5)

WARDN.endingQuote = "..and so it left, core directive broken and forgotten."


SurvivorVariant.setInfoStats(WARDN, {{"STRENGTH", 8}, {"EFFICIENCY", 10}, {"DURABILITY", 8}, {"AGILITY", 4}, {"MOBILITY", 10}, {"MERCY", 0}}) 

SurvivorVariant.setDescription(WARDN, "The &y&WARD-N&!& unit is an autonomous machine capable of calmly subduing even the most dangerous of riots alone. it might be slow but it's hardy armor and fierce firepower will return entire cities to peace in unrivaled time.") 

--skin Init
callback.register("onSkinInit", function(player, skin) 
	if skin == WARDN then
		player:getData().skin_replacesSound = sShootOriginal
		
		player:set("armor", player:get("armor") +15)
		player:set("pHmax", player:get("pHmax") - 0.2)
		player:getData().skin_skill1Override = true
		player:getData().skin_skill2Override = true
		player:survivorSetInitialStats(110, 11.5, 0.0095)
		--skills
		player:setSkill(1,
		"GAS BOMB",
		"LAUNCH A PIERCING BOMB FOR &y&100% DAMAGE. EXPLODES FOR 250% DAMAGE.",
		sprSkills, 1, 40)
		player:setSkill(2,
		"PLOW",
		"JET THROUGH THE MASSES, DEALING 9x75% DAMAGE, FINISHING OFF AT A SINGLE 100% DAMAGE SHIELD-SLAM.",
		sprSkills, 2,  7* 60)
		player:setSkill(4,
		"BARRICADE",
		"ERECT AN ELECTRIC BARRICADE, SHOCKING RIOTERS FOR A MAXIMUM OF 300x70% DAMAGE.",
		sprSkills, 5,  15* 60)

	end
end)

survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == WARDN then
		player:setSkill(4,
		"'PEPPER' SPRAY",
		"SET GROUND ABLAZE, STUNNING, SLOWING, AND DAMAGING FOR 500x70%. IGNITES.",
		sprSkills, 6,  15* 60)
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == WARDN then
		player:survivorLevelUpStats(-1, 0.1, 0, 0) 
	end
end)

-- Bullet Object
local objBullet = Object.new("R-MORBullet")
local sprBullet = Sprite.load("R-MORMissile", path.."Bullet", 3, 16, 9)
local sprBulletMask = Sprite.load("R-MORMissileMask", path.."BulletMask", 1, 7, 5)
local sprBulletExplosion = Sprite.load("R-MORExplosion", path.."Explosion", 6, 27, 28)
local sExplosion = Sound.load("RMORExplosion", path.."Explosion")
local enemies = ParentObject.find("enemies")
local sBoom = Sound.find("ExplosiveShot")
local sPunch = Sound.find("JanitorShoot1_1")
local sbBoom = Sound.find("Smite")

objBullet.sprite = sprBullet
objBullet.depth = 0

local parSmoke = ParticleType.find("smoke")
objBullet:addCallback("create", function(self)--bullet Stepcode
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().life = 35
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.speed = 4.5
	selfAc.damage = 2.25
	self.spriteSpeed = 0.20
end)
objBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local enemy = enemies:findNearest(self.x, self.y)
	local parent = self:getData().parent
	
	if selfData.direction == 0 then
		self.xscale = 1
	else
		self.xscale = -1
	end
		
		
	if selfData.parent and selfData.parent:isValid() then
		local xr, yr = 10 * self.xscale, 12 * self.yscale
		for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
			if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) and not selfData.hitEnemies[enemy] then
				if misc.getOption("video.quality") > 1 then
					ParticleType.find("spark"):burst("middle", self.x, self.y, 4)
				end
				
				selfData.hitEnemies[enemy] = true
				local parent = selfData.parent
				for i = 0, parent:get("sp") do
					local damager = parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 1, sprSparks, nil)
					damager:set("skin_newDamager", 1)
					damager:set("direction", parent:getFacingDirection())
					if i ~= 0 then
						damager:set("climb", i * 8)
					end
				end
			end
		end
	end
	if enemy then
		if selfData.parent and self:collidesWith(enemy, self.x, self.y) and enemy:get("team") ~= selfData.parent:get("team") and not contains(selfData.hitEnemies, enemy.id) then

		end
	end
	if self:getData().life == 0 or Stage.collidesPoint(self.x, self.y) then
		sExplosion:play(1 + math.random() * 0.2, 0.7)
		misc.shakeScreen(2)
		if parent then
			for i = 0, parent:get("sp") do
				explosion = parent:fireExplosion(self.x, self.y, 33 / 19, 30 / 4, selfAc.damage, sprBulletExplosion, sprSparks)
				explosion:set("direction", parent:getFacingDirection())
				explosion:set("skin_newDamager", 1)
				explosion:set("knockback", 5)
				explosion:set("knockback_direction",self.xscale)
				self:getData().life = 0
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
			
		if misc.getOption("video.quality") > 1 then
			ParticleType.find("spark"):burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		self:getData().life = self:getData().life - 1
		selfAc.speed = selfAc.speed / 1.075
	end
end)




--BarricadeCode

local sprOrbs = Sprite.load("Orbs", path.."Orbs", 3, 6, 4)
local objOrbs = Object.new("barOrbs")
objOrbs.sprite = sprOrbs
objOrbs.depth = 0

local objBarricade = Object.new("elecBarricade")
local sprBarricade = Sprite.load("Barricade", path.."electricField", 6, 16, 33)
local sprBarricadeLoad = Sprite.load("BarricadeSpawn", path.."fieldSummon", 8, 16, 33)
local sprBarricadeMask = Sprite.load("BarricadeMask", path.."fieldMask", 1, 14, 33)
local sprBarricadeDie = Sprite.load("BarricadDie", path.."electricFieldDie", 6, 16, 33)
objBarricade.sprite = sprBarricadeLoad
objBarricade.depth = 0

objOrbs:addCallback("create", function(self)--orbs, what Spawns the Barricade
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	self.mask =sprBulletMask
	self:getData().life = 90
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.damage = 0.7
	self:getData().acc = 0
	self.spriteSpeed = 0.25
	selfData.vSpeed = -2
	selfAc.speed = 1.5
	selfData.angleSpeed = math.random(-10, 10)
	self.spriteSpeed = math.random(10, 50) * 0.01
end)

objOrbs:addCallback("step",function(self)--orb rotate and stepcode
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.direction == 0 then
		self.xscale = 1
	else
		self.xscale = -1
	end
	
	self.angle = self.angle + selfData.angleSpeed
	if selfData.vSpeed > 0 then
		selfData.life = selfData.life + 0.1
	end
	
	self.y = self.y + selfData.vSpeed
	selfData.vSpeed = selfData.vSpeed + 0.1
	
	if self:collidesMap(self.x, self.y+4) and selfData.vSpeed > 0 then 
		selfData.life = 0
	end
	
	if selfData.life == 0 then
		sBoom:play(1 + math.random() * 0.2, 0.7)
		misc.shakeScreen(2)
		if parent then
			for i = 0, parent:get("sp") do
				explosion = parent:fireExplosion(self.x, self.y, 33 / 19, 30 / 4, selfAc.damage, nil, sprSparks)
				explosion:set("direction", parent:getFacingDirection())
				explosion:set("skin_newDamager", 1)
				explosion:set("knockback", 5)
				self:getData().life = 0
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
		local bullet = objBarricade:create(self.x, self.y+8)
			bullet:getData().parent = selfData.parent
			bullet:set("skin_newDamager", 1)
			bullet:set("skin_noFakeDamage", 1)
		if misc.getOption("video.quality") > 1 then
			ParticleType.find("spark"):burst("middle", self.x, self.y, 6)
		end
		
		self:destroy()
		
	end
	
end)





objBarricade:addCallback("create", function(self)--barricade spawn
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().spawned = false
	self:getData().life = 60*5
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.damage = 0.7
	self:getData().acc = 0
	self.spriteSpeed = 0.25
	self:getData().dying = false
end)

objBarricade:addCallback("step", function(self)--barricade Stepcode
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	local selfData = self:getData()
	local hasHit = false
	local playerAc = parent:getAccessor()
	selfData.life = selfData.life - 1
	
	local n = 0
		while not self:collidesMap(self.x, self.y+1) and n < 150 do
			self.y = self.y+1
			n = n + 1
		end
	if self:collidesMap(self.x, self.y) then
		if not self:collidesMap(self.x, self.y + 7) then
			self.y = self.y + 7
		elseif not self:collidesMap(self.x - 4, self.y) then
			self.x = self.x - 4
		elseif not self:collidesMap(self.x + 4, self.y) then
			self.x = self.x + 4
		end
	elseif not self:collidesMap(self.x, self.y + 1) then
		selfData.acc = selfData.acc + 0.1
		self.y = self.y + selfData.acc
	end
	
	if self:getData().spawned == false and self.subimage > 7.5 then
		self.sprite = sprBarricade
		self:getData().spawned = true
	end
	
	if selfData.life % 4 == 0 and hasHit == false then
		local bullet = parent:fireExplosion(self.x, self.y, 1, 1, selfAc.damage*(playerAc.scepter + 1), nil, sprMuSparks2)
			bullet:set("stun", 0.25*(playerAc.scepter + 1))
			bullet:set("knockback", -10)
			bullet:set("knockup", bullet:get("knockup")+2)
			hasHit = true
	else 
		hasHit = false
	end
	if selfData.life == 0 and selfData.dying == false then
		self.subimage = 1
		selfData.life = 24
		self.sprite = sprBarricadeDie
		selfData.dying = true
	end
	if selfData.dying == true and  selfData.life == 0 then
		self:destroy()
	end
end)


--what if fire?
local objFireField = Object.new("objfireField")--spawn and sprites
local sprFireZone = Sprite.load("fireyZone", path.."fireField", 6, 21, 40)
local sprFireFieldSpawn = Sprite.load("fireFieldSpawn", path.."fireFieldSpawn", 7, 50, 70)
local sprFireFieldBoom = Sprite.load("fireFieldBoom", path.."fireExplosion", 7, 50, 69)
local sprfireMask = Sprite.load("fireMask", path.."fireMask", 1, 18, 40)
local sprFireZoneDie = Sprite.load("fireyZoneDie", path.."fireFieldDie", 6, 21, 55)

objFireField.sprite = sprFireFieldSpawn
objFireField.depth = 0

objFireField:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprfireMask
	self:getData().spawned = false
	self:getData().life = 60*7
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.damage = 0.75
	self:getData().acc = 0
	self.spriteSpeed = 0.25
	self:getData().dying = false
end)

--fireField Step Code
objFireField:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	local selfData = self:getData()
	local hasHit = false
	local playerAc = parent:getAccessor()
	selfData.life = selfData.life - 1
	
	if self:collidesMap(self.x, self.y) then
		if not self:collidesMap(self.x, self.y + 7) then
			self.y = self.y + 7
		elseif not self:collidesMap(self.x - 4, self.y) then
			self.x = self.x - 4
		elseif not self:collidesMap(self.x + 4, self.y) then
			self.x = self.x + 4
		end
	elseif not self:collidesMap(self.x, self.y + 1) then
		selfData.acc = selfData.acc + 0.1
		self.y = self.y + selfData.acc
	end
	
	if self:getData().spawned == false and self.subimage > 7.5 then
		self.sprite = sprFireZone
	end
	
	if selfData.life % 3 == 0 and hasHit == false then --Fire Tics
		local fireBurn = parent:fireExplosion(self.x, self.y, 1.1, 1, selfAc.damage*playerAc.scepter, nil, sprMuSparks2)
			fireBurn:set("stun", 0.5*playerAc.scepter)
			fireBurn:set("knockback", -9)
			fireBurn:set("slow", playerAc.scepter * 2)
			DOT.addToDamager( fireBurn, DOT_FIRE, (self:getData().parent:get("damage")/2)*playerAc.scepter, 5*playerAc.scepter, "fieldBurn", false )--DoT
			fireBurn:set("knockup", fireBurn:get("knockup")+2)
			hasHit = true
	else 
		hasHit = false
	end
	if selfData.life == 0 and selfData.dying == false then
		self.subimage = 1
		selfData.life = 24
		self.sprite = sprFireZoneDie
		selfData.dying = true
	end
	if selfData.dying == true and  selfData.life == 0 then
		self:destroy()
	end
end)

--Shield-based Drawing Code
callback.register("onPlayerDraw", function(player)
	if SurvivorVariant.getActive(player) == WARDN then
		if 	player:get("bunker") == 0 then
			player:setAnimation("idle", WARDN.animations.idle_1)
			player:setAnimation("walk", WARDN.animations.walk_1)
			player:setAnimation("shoot1", WARDN.animations.shoot1_1)
		else
			player:setAnimation("idle", WARDN.animations.idle_2)
			player:setAnimation("walk", WARDN.animations.walk_2)
			player:setAnimation("shoot1", WARDN.animations.shoot1_2)
		end
		player:setAnimation("shoot2", WARDN.animations.shoot2_1)
	end
end)


local reverseGrip = false--Detects wether or not the player is pulling back for the Dash
callback.register("onPlayerStep", function(player)
	local playerAc = player:getAccessor()
	if player:get("bunker") == 0 then
		bunkered = false
	else
		playerAc.walk_speed_coeff = 1
		bunkered = true
	end
	if (input.checkControl("left", player) == input.HELD and player.xscale > 0) or (input.checkControl("right", player) == input.HELD and player.xscale < 0)then
		reverseGrip = true;
	else
		reverseGrip = false;
	end
end)
--Bunker Animations
SurvivorVariant.setSkill(WARDN, 1, function(player)
	if player:get("bunker") == 0 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.2, true, true)
	end
end)

SurvivorVariant.setSkill(WARDN, 2, function(player)
	-- X skill
	SurvivorVariant.activityState(player,2, player:getAnimation("shoot2"), 0.2, false, false)
end)

SurvivorVariant.setSkill(WARDN, 4, function(player)--Complicated Scepter Boogaloo
    if player:get("scepter") > 0 then
        if player:get("free") == 1 then
            SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4_1"), 0.25, true, true)
        else
            SurvivorVariant.activityState(player, 4.2, player:getAnimation("shoot4_2"), 0.25, true, true)
        end
    else
        SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4_1"), 0.25, true, true)
    end
end)

local acted = 0
callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == WARDN then
		if skill == 1. then
			if relevantFrame == 1 then
				acted = 0
			end
			if relevantFrame == 2 and acted == 0 then
				player:getData().skin_stopSound = 1
				acted = 1
			end
			if relevantFrame == 3 and not player:getData().skin_onActivity and acted == 1 then
				misc.shakeScreen(2)
				player:getData().skin_onActivity = true
				sShoot:play()
				for i = 0, playerAc.sp do
					local bullet = objBullet:create(player.x + (5 * player.xscale), player.y + (i * 8))
					bullet:getData().parent = player
					bullet:getData().direction = player:getFacingDirection()
					bullet:set("direction", player:getFacingDirection() + (i * 10))
					bullet:set("skin_newDamager", 1)
					bullet:set("skin_noFakeDamage", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				acted = 2
				
			elseif relevantFrame ~= 6 then
				player:getData().skin_onActivity = nil
			end
		elseif skill == 2 then
			-- Thrust attack Code
			if bunkered == true then
				playerAc.pHmax = playerAc.pHmax + 0.7
				playerAc.bunker = 0
				player:activateSkillCooldown(3)
				bunkered = false
				player:setSkillIcon(3, sprSkills, 3)
			end
			
			if relevantFrame == 1 then
				playerAc.invincible = 35
				local hasPlayed = 0
				player:getData().skin_onActivity = true
				player:getData().skin_stopSound = 1
			end
			if relevantFrame > 3 and relevantFrame < 12 and skin_lastRelevant ~= relevantFrame then
				local bullet = player:fireExplosion(player.x+(12*( player.xscale*-1)), player.y, 2, 1.3, 0.75*(math.abs(playerAc.pHmax )+1), nil, sprMuSparks2)
				if reverseGrip == false then
					bullet:set("knockback", 7.5)
				else
					bullet:set("knockback", 3)
				end
				bullet:set("knockup", bullet:get("knockup") + 2)
				bullet:set("knockback_direction",player.xscale)
				bullet:set("stun", 0.2)
				if misc.getOption("video.quality") > 1 then
					ParticleType.find("spark"):burst("middle", player.x+(8*(player.xscale)), player.y+8, 1)
					parSmoke:burst("middle", player.x, player.y-2, 1)
				end
				player:getData().skin_lastRelevant = relevantFrame
			end
			if relevantFrame == 4 and hasPlayed ~= 1 then
				rocketShoot:play()
				hasPlayed = 1

			end
			if relevantFrame > 3 and relevantFrame < 8 then
				if misc.getOption("video.quality") > 1 then
					ParticleType.find("spark"):burst("middle", player.x+(8*(player.xscale)), player.y+8, 1)
					parSmoke:burst("middle", player.x, player.y-2, 1)
				end
			end
			--Neik dont look, skip to 620
			--Controll of his speed when at max
			if reverseGrip ==  false then
				if relevantFrame > 3 and relevantFrame < 7 then
					playerAc.pHspeed = playerAc.pHmax * 6 * player.xscale
				elseif relevantFrame == 7 then
					playerAc.pHspeed = playerAc.pHmax * 4 * player.xscale	
				elseif relevantFrame == 8 then
					playerAc.pHspeed = playerAc.pHmax * 3 * player.xscale	
				elseif relevantFrame == 9 then
					playerAc.pHspeed = playerAc.pHmax * 2 * player.xscale
				elseif relevantFrame == 10 then
					playerAc.pHspeed = playerAc.pHmax * 1.5 * player.xscale
				elseif relevantFrame == 11 then
					playerAc.pHspeed = playerAc.pHmax * 1.15 * player.xscale
				elseif relevantFrame > 11 and playerAc.free == 0 then
					playerAc.pHspeed = playerAc.pHspeed / 1.025
				end
			else 
				if relevantFrame > 3 and relevantFrame < 5 then
					playerAc.pHspeed = playerAc.pHmax * 3 * player.xscale
				elseif relevantFrame > 5 and playerAc.free == 0 then
					playerAc.pHspeed = playerAc.pHspeed / 2.15
				end
			end
			if relevantFrame >= 13 then
				if hasPlayed ~= 2 then				
					sSlamOriginal:play()
					hasPlayed = 2
					for i = 0, playerAc.sp do
						misc.shakeScreen(4)
						--Shield Bash
						local bullet = player:fireExplosion(player.x+(8*( player.xscale*-1)), player.y, 1.34, 1.2, math.abs(playerAc.pHmax/1.5)+1, nil, sprMuSparks2)
						bullet:set("skin_setSpark", sprSparks.id)
						if reverseGrip == false then 
							bullet:set("knockback", bullet:get("knockback") + 6)
						else
							bullet:set("knockback", bullet:get("knockback") + 3)
						end
						bullet:set("knockback_direction",player.xscale)
						bullet:set("knockup", bullet:get("knockup") + 4)
						bullet:set("stun", bullet:get("stun") + 0.5)
						bullet:set("skin_newDamager", 1)
						bullet:set("skin_noFakeDamage", 1)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
					if misc.getOption("video.quality") > 1 then
						if player:get("free") == 1 then
							ParticleType.find("spark"):burst("middle", player.x, player.y, 4)
						end
					end
				end
			end
			if relevantFrame >= 19 then
				player:getData().skin_onActivity = nil
			end
			
		--Zap and Punch
		elseif skill == 4 then
			if relevantFrame == 3 and not player:getData().skin_onActivity then
				misc.shakeScreen(4)
				player:getData().skin_onActivity = true
				sShoot:play()
				for i = 0, playerAc.sp do --spawn Orbs
					local bullet = objOrbs:create(player.x, player.y)
					bullet:getData().parent = player
					bullet:getData().direction = player:getFacingDirection()
					bullet:set("direction", player:getFacingDirection() + (i * 10))
					bullet:set("skin_newDamager", 1)
					bullet:set("skin_noFakeDamage", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			if relevantFrame >= 4 then
				player:getData().skin_onActivity = nil
			end
		elseif skill == 4.2 then		
			playerAc.pHspeed = 0
			if playerAc.pVspeed < 0 then
				playerAc.pVspeed = 0
			end
			if relevantFrame == 1 and not player:getData().skin_onActivity then
				local hasPlayed = 0
				playerAc.invincible = 30
				player:getData().skin_onActivity = true
			end
			if relevantFrame == 3 and hasPlayed ~=1 then
				sPunch:play()
				hasPlayed = 1
			end
			if relevantFrame == 10 and hasPlayed ~=2 then
				sbBoom:play()
				hasPlayed = 2
				misc.shakeScreen(10)
				--create Firefield
				for i = 0, playerAc.sp do
					local bullet = objFireField:create(player.x+(8*(player.xscale)), player.y+3)
					bullet:getData().parent = player
					bullet:getData().direction = player:getFacingDirection()
					bullet:set("direction", player:getFacingDirection() + (i * 10))
					bullet:set("skin_newDamager", 1)
					bullet:set("skin_noFakeDamage", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				--explosion visuals and effects
				local boom = player:fireExplosion(player.x+(8*( player.xscale)), player.y+9, 2, 2, 0.8, sprFireFieldBoom, sprMuSparks2)
				boom:set("knockup", boom:get("knockup") + 4)
				boom:set("knockup", boom:get("knockup") + 4)
				boom:set("stun", boom:get("stun") + 2)
				boom:set("skin_newDamager", 1)
				boom:set("slow", playerAc.scepter * 2)
				boom:set("skin_noFakeDamage", 1)
				ParticleType.find("spark"):burst("middle", player.x+(8*(player.xscale)), player.y+3, 4)
				ParticleType.find("Rubble1"):burst("middle", player.x+(8*(player.xscale)), player.y+3, 8)
				ParticleType.find("Rubble2"):burst("middle", player.x+(8*(player.xscale)), player.y+3, 8)
				ParticleType.find("Fire4"):burst("middle", player.x+(8*(player.xscale)), player.y+3, 8)
			end
			if relevantFrame == 22 then
				player:getData().skin_onActivity = nil
			end
		end
	end
end)

--callback to fix his Xscale when Shielded
callback.register("onPlayerStep", function(player)
    if SurvivorVariant.getActive(player) == WARDN then
        local playerData = player:getData()
        if player:get("bunker") == 0 then
            player:setAnimation("walk", WARDN.animations.walk_1)
            player:setAnimation("shoot1", WARDN.animations.shoot1_1)
            playerData.lastXscaleFix = nil
        else
            if playerData.lastXscaleFix then
                if playerData.lastXscaleFix ~= player.xscale then
                    player.xscale = playerData.lastXscaleFix
                end
            else
                playerData.lastXscaleFix = player.xscale
            end
            player:setAnimation("walk", WARDN.animations.walk_2)
            player:setAnimation("shoot1", WARDN.animations.shoot1_2)
            if player:get("activity") == 0 then
                player:set("activity_type", 4)
            end
        end
        player:setAnimation("shoot2", WARDN.animations.shoot2_1)
    end
end)