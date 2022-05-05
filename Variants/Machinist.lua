-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Huntress", "vanilla")
local path = "Variants/machinist/"
local machinist = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Machinist", -- The name of the skin.
Sprite.load("machinistSelect", path.."Select", 15, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("machinistIdle", path.."Idle", 1, 5, 7),
	idlehalf = Sprite.load("machinistIdleHalf", path.."IdleHalf", 1,5, 7),
	idlehalfU = Sprite.load("machinistIdleHalfU", path.."IdleHalfUnarmed", 1,5, 7),
	walk = Sprite.load("machinistWalk", path.."Walk", 8, 6, 7),
	walkhalf = Sprite.load("machinistWalkHalf", path.."WalkHalf", 8, 6, 7),
	walkhalfU = Sprite.load("machinistWalkHalfU", path.."WalkHalfUnarmed", 8, 6, 7),
	jump = Sprite.load("machinistJump", path.."Jump", 1, 5, 7),
	climb = Sprite.load("machinistClimb", path.."Climb", 2, 5, 10),
	death = Sprite.load("machinistDeath", path.."Death", 8, 14, 3),
	decoy = Sprite.load("machinistDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("machinistShoot1", path.."Shoot1", 12, 7, 9),
	shoot2 = Sprite.load("machinistShoot2", path.."Shoot2", 12, 12, 10),
	shoot3 = Sprite.load("machinistShoot3", path.."shoot3", 5, 14, 7),
	shoot4 = Sprite.load("machinistShoot4", path.."Shoot4", 5, 7, 10),
	shoot4_1 = Sprite.load("machinistShoot4_1", path.."Shoot4_1", 8, 7, 9),
	shoot4_2 = Sprite.load("machinistShoot4_2", path.."Shoot4_2", 14, 11, 10),
	shoot4_3 = Sprite.load("machinistShoot4_3", path.."Shoot4_3", 14, 11, 15),
	shoot4_4 = Sprite.load("machinistShoot4_4", path.."Shoot4_4", 16, 11, 16),
	shoot4_5 = Sprite.load("machinistShoot4_5", path.."Shoot4_5", 14, 11, 10),
	shoot5 = Sprite.load("machinistShoot5", path.."Shoot5", 10, 15, 12),
	
	sPierce = Sprite.load("machinistPierce", path.."sPierce", 5,3, 9),
	noneHalf = Sprite.load("machinistnoneHalf", path.."noneHalf", 1,5, 7),
	jumpHalf = Sprite.load("machinistJumpHalf", path.."jumpHalf", 1, 5, 7),
	jumpHalfU = Sprite.load("machinistJumpHalfU", path.."jumpHalfUnarmed", 1, 5, 7),
	
	cleaver = Sprite.load("MachinistDshot", path.."Cleaver", 1, 5, 6),
	Drill = Sprite.load("Machinistrill", path.."machinistDrill", 3, 6, 9),
	drone = Sprite.load("MachinistDrone", path.."machinistDrone", 8,7, 14),
	droneShoot = Sprite.load("MachinistDrone_Shoot", path.."machinistDroneShoot", 8,7, 14),
	droneDie = Sprite.load("MachinistDrone_Die", path.."machinistDroneDie", 9,7, 14),
},

Color.fromHex(0xac3232)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.
machinist.forceApply = true

local sprSkills = Sprite.load("machinistSkills",path.."Skills",10,0,0)

local slamX = Sound.find("Smite")

local spark = Object.find("EfSparks")

local rocket = Object.find("EngiHarpoon")

local hShoot = Sound.find("CowboyShoot1")

local rLaunch = Sound.find("MissileLaunch")

local activat = Sound.find("JanitorShoot1_1")

local Pyre = Sound.load("machFlamethower", path.."fthrower")

local reload = Sound.find("Reload")
local snipe = Sound.find("SniperShoot3")

local skinName = "machinist"

SurvivorVariant.setInfoStats(machinist, {{"Strength", 5}, {"Social Skills", 0}, {"Versatility", 8}, {"Agility", 6}, {"Difficulty", 5}, {"Anxiety when Socializing", 9}})
SurvivorVariant.setDescription(machinist, "The &y&Machinist&!& is an agile, Versatile Jack-of-all-Trades, capable of utilizing her &y&Heavy Machinery&!& To adapt to different situations, and using her &y&Optic Drones&!& and &y&Overcharge&!& to deal damage from a safe distance.")

SurvivorVariant.setLoadoutSkill(machinist, "Hand Cannon",
		"Shoot a piercing shot for &y&130% damage.&!& &b&Piercing.&!& &r&Rapidly Degrades.&!& Triggers &b&Optic Mines.&!&", sprSkills,1)
SurvivorVariant.setLoadoutSkill(machinist, "Optic Mines",
		"Toss 3 mines that, &g&when triggered,&!& shoot at the tagged enemy for &y&150% Damage.&!&", sprSkills,2)
SurvivorVariant.setLoadoutSkill(machinist, "Overcharge",
		"Launch a &b&Batery Drone&!&, Zaps the &g&nearest enemy&!& for &y&25% Damage.&!& When zapping, &b&overcharges Optic Mines.&!&", sprSkills,3)
SurvivorVariant.setLoadoutSkill(machinist, 	"Heavy Weaponry",
		"Fire off a variety of &g&different Heavy weapons&!& from your trusty toolbelt. &y&Cast while holding down to change Tools!&!&", sprSkills,4)
		
	machinist.endingQuote = "..and so she left, The heat of her tools burning at her skin."	
callback.register("onSkinInit", function(player, skin)
	if skin == machinist then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		playerData.frames = 1
		
		player:getData().skin_onActivity = 0
		player:getData().oldX = player.x
		player:getData().queue = 1
		player:getData().phQ = 0
		player:getData().r = 0
		player:getData().vHeld = true
		player:survivorSetInitialStats(85, 13, 0.008)
		
		player:getData().xsFix = player.xscale
				player:setSkill(1,
		"Hand Cannon",
		"Shoot a piercing shot for 130% damage. Piercing Rapidly Degrades. Triggers Optic Mines." ,
		sprSkills, 1, 25)
		
		player:setSkill(2,
		"Optic Mines",
		"Toss 3 mines that, when triggered, shoot at the tagged enemy for 150% Damage." ,
		sprSkills, 2,  5* 60)
		
		player:setSkill(3,
		"Overcharge",
		"Launch a Batery Drone, Zaps the nearest enemy for 25% Damage. When zapping, overcharges Optic Mines." ,
		sprSkills, 3,  12*60)
		
		player:setSkill(4,
		"Heavy Weaponry: BARRAGE.",
		"Shoot a barrage of piercing shots for 5x150% Damage. Shots scale with attack Speed." ,
		sprSkills, 4,  9*60)
	end
end)
		
-- Delayed Shot Object
local objDShot = Object.new("Machinist_DelayShot")

objDShot.sprite = machinist.animations.cleaver
objDShot.depth = -1

objDShot:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().life = 60*10
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.speed = 6
	self:getData().eX = self.x
	self:getData().eY = self.y
	self:getData().tagged = nil
	self:getData().tic = false
	self:getData().oBonus = 0
end)

objDShot:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.parent and selfData.parent:isValid() then
		local parent = selfData.parent
		self.angle = self.angle + 10
		if selfAc.speed > 0 then 
			selfAc.speed = selfAc.speed -0.5
		elseif selfAc.speed < 0 then
			selfAc.speed = 0
		end
		
		if (selfData.life == 0 or (selfData.tagged and selfData.tagged:isValid())) and self:getData().tic == false then
			selfData.life = math.random(5,25)
			self:getData().tic = true
		end
	
		if selfData.life %30 == 0 and selfData.oBonus > 0 then
			local c = Object.find("EfCircle"):create(self.x, self.y)
			c:set("radius", 0.01+selfData.oBonus*2)
			c.blendColor = Color.fromHex(0x9cffff)
		end
		
		if self:getData().tagged and selfData.tagged:isValid() then
			self:getData().eX = self:getData().tagged.x
			self:getData().eY = self:getData().tagged.y
		end
		if selfData.life == 0 and selfData.tic == true then
		

		
			local shoot = Color.fromHex(0x9cffff)
			local targett =  parent:getFacingDirection()
				targett = posToAngle(self.x,self.y,self:getData().eX,self:getData().eY)
				if onScreen(self) then
					misc.shakeScreen(2)
					slamX:play(2 + math.random() * 0.3,0.7)
					ParticleType.find("spark"):burst("middle", self:getData().eX, self:getData().eY, 2)
				end
			
			local bullet = parent:fireBullet(self.x, self.y, targett, 500, 1.5+self:getData().oBonus, nil, DAMAGER_BULLET_PIERCE)
			addBulletTrail(bullet, shoot, 2+math.min(selfData.oBonus,6), 50, false, true)
			
			
			self:destroy()
		else
			selfData.life = selfData.life - 1
		end
	end
end)

-- drill Shot Object
local objDrill = Object.new("Machinist_Drill")

objDrill.sprite = machinist.animations.Drill
objDrill.depth = -1

objDrill:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().life = 60*2
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	self:getData().tagged = nil
	self:getData().Hook = nil
	self:getData().tic = false
	self.spriteSpeed = 0.2
end)

objDrill:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local Hook = self:getData().Hook

	if selfData.parent and selfData.parent:isValid() then
		if selfData.life % 15 == 0 then
			local bullet = selfData.parent:fireExplosion(self.x, self.y, 0.5, 0.5, 0.5, Sprite.find("Sparks4"), sprSparks7)
			bullet:set("max_hit_number", 1)
			Sound.find("Drill"):play(1.5,0.5)
		end
		
		if selfData.Hook and selfData.Hook:isValid() then
			self.x = Hook.x-(5*self.xscale)
			self.y = Hook.y
		end
		
		if selfData.life <= 0 or (not selfData.Hook or not selfData.Hook:isValid())then
			 selfData.parent:fireExplosion(self.x, self.y, 1.3, 2, 4.5, Sprite.find("ChefOilFire"), Sparks7)
			 Sound.find("DroneDeath"):play(1.5,0.5)
			self:destroy()
		else
			selfData.life = selfData.life - 1
		end
	end
end)


--Drone Machine Zapper
local oDrone = Object.new("Machinist_Drone")

oDrone.sprite = machinist.animations.drone
oDrone.depth = -1

oDrone:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().life = 60*10
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.speed = 1.5
	self:getData().tagged = nil
	self.spriteSpeed = 0.2
	self:getData().die = false
	self:getData().x1 = {x = self.x, y = self.y}
	self:getData().x2 = {x = self.x, y = self.y}
	self:getData().tX = {x = self.x, y = self.y}
	self:getData().shoot = 0
	self:getData().s = false
	self:getData().dT = nil
	self:getData().erad = 64
	self:getData().eS = 0
end)

oDrone:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.parent and selfData.parent:isValid() then
		local parent = selfData.parent
		if selfAc.speed > 0 then 
			selfAc.speed = selfAc.speed -0.1
		elseif selfAc.speed < 0 then
			selfAc.speed = 0
		end
		if selfData.s == true and self.subimage > 7 then
			self.sprite = machinist.animations.drone
			self.subimage = 1
			selfData.s = false
		end

		if selfData.shoot <= -8 and selfData.life > 0 and selfData.s == false then
			selfData.s = true
			self:getData().shoot = 3
			local target = ParentObject.find("enemies"):findEllipse(self.x-selfData.erad, self.y-selfData.erad, self.x+selfData.erad, self.y+selfData.erad)
			if target and target:isValid() then
				self:getData().dT = target
				selfData.tX = { x = target.x, y = target.y}
			end
			selfData.x1 = setRadius(self.x,self.y, 32,math.random(360))
			selfData.x2 = setRadius(self.x,self.y, 128,math.random(360))
			
			local c = Object.find("EfCircle"):create(self.x, self.y)
				c:set("radius", selfData.erad)
				if self:getData().eS > 0 then
					c.blendColor = Color.fromHex(0xe65344)
				else
					c.blendColor = Color.fromHex(0x9cffff)
				end
			if self:getData().dT and self:getData().dT:isValid() then
				self.sprite = machinist.animations.droneShoot
				self.subimage = 1
				local bullet = parent:fireExplosion(selfData.tX.x, selfData.tX.y-10, 1, 1, 0.5, nil, sprSparks7)
				local lightning = obj.ChainLightning:create(selfData.tX.x, selfData.tX.y-10)
					lightning:set("damage", math.round(parent:getAccessor().damage * 0.25 ))
					lightning:set("bounce", 2+parent:getAccessor().scepter)
					lightning:set("team", parent:getAccessor().team)
					lightning:set("parent", parent.id)
					
				for _, dorb in ipairs(objDShot:findAllEllipse(self.x-selfData.erad, self.y-selfData.erad, self.x+selfData.erad, self.y+selfData.erad)) do
					dorb:getData().oBonus = dorb:getData().oBonus + 0.10
				end
			end
		end
		if selfData.shoot > -15 then
			self:getData().shoot = self:getData().shoot - (0.25*(self:getData().eS+1)* parent:getAccessor().attack_speed)
		end
		
		if self:getData().die == true and self.subimage > 8 then
			self:destroy()
		end
		
		if selfData.life == 0  and self:getData().die == false then					
			self:getData().die = true
			
			self.sprite = machinist.animations.droneDie
			self.subimage = 1
		else
			selfData.life = selfData.life - 1
		end
	end
end)

callback.register("preHit", function(damager,hit)
	if hit and hit:isValid() then
		local parent = damager:getParent()
		local damagerAc = damager:getAccessor()
		local hitAc = hit:getAccessor()
		
		if damager:getData().drill then
			local dril = objDrill:create(hit.x,hit.y)
			dril.xscale = parent.xscale
			dril:getData().Hook = hit
			dril:getData().parent = parent
			damager:getData().drill = nil
		end
		if damager:getData().tag then
			for _, hed in ipairs(objDShot:findAll()) do
				if hed:getData().parent == damager:getData().parent then
					hed:getData().tagged = hit
					damager:getData().tag = nil
				end
			end	
			
		end
	end
end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == machinist then
		if math.floor(player:getAccessor().activity) ~= 3 or player:getAccessor().c_skill ~= 1 then
			player:getData().oldX = player.x
			
			if player:getData().phQ > 0 and player:getAccessor().activity == 0 then
				player:getAccessor().pHmax = player:getAccessor().pHmax+(player:getData().phQ*3)
				player:getData().phQ = 0
			end
		end
	end
end)

survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == machinist then
		player:setSkill(3,
		"Return to Midnight",
		"Dive forwards, dealing 80% damage to enemies. Turns enemies under 33% Health into Shrubs that passively heal." ,
		sprSkills, 10,  12*60)
	end
					player:setSkill(4,
				"Return to Midnight",
				"Dive forwards, dealing 80% damage to enemies. Turns enemies under 33% Health into Shrubs that passively heal." ,
				sprSkills, 3+playerData.queue,  9*60)
end)
SurvivorVariant.setSkill(machinist, 1, function(player)
		playerData = player:getData()
		local playerAc = player:getAccessor()
		
		player:getData().skin_onActivity = 0
		SurvivorVariant.activityState2(player, 1.1, player:getAnimation("shoot1"), 0.2, true, true)
		
end)

SurvivorVariant.setSkill(machinist, 2, function(player)
		playerData = player:getData()
		player:getData().skin_onActivity = 0
		SurvivorVariant.activityState2(player, 2.1, player:getAnimation("shoot2"), 0.2, true, true)
end)

sur.Huntress:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == machinist and skill == 3 then
		if player:get("activity") ~= 3.01 then
			player:setAlarm(4, math.ceil((1 - player:get("cdr")) * (12 * 60)))
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			local index = 3
			local iindex = index + 0.1
			local sprite
			sprite = player:getAnimation("shoot3")
			local scaleSpeed = false
			local resetHSpeed = false
			local speed = 0.25
			if playerAc.dead == 0 then
				playerAc.activity = iindex
				playerAc.activity_type = 1
				playerAc.image_index2 = 1
				playerData.variantSkillUse = {index = index, sprite = sprite, speed = speed, scaleSpeed = scaleSpeed, resetHSpeed = resetHSpeed}--, frame = 1}
				
				player.sprite = sprite
				player.subimage = 1
				
				if resetHSpeed and playerAc.free == 0 then
					playerAc.pHspeed = 0
				end
			end
		end

	end
end)

SurvivorVariant.setSkill(machinist, 3, function(player)
		playerData = player:getData()
		local playerAc = player:getAccessor()
		
		player:getData().skin_onActivity = 0
		for _, hed in ipairs(spark:findAll()) do
				hed:destroy()
		end	
		Sound.find("HuntressShoot3"):stop()
		player.x = player:getData().oldX
		
		local d = 1
		local e = 0
		if player:getAccessor().image_xscale2 < 0 then
				d = -1
				e = 180
		end
		
		local summon = oDrone:create(player.x, player.y - 3)
			summon:set("direction", 90)
			summon:getData().parent = player
			summon:getData().team = playerAc.team
			summon.xscale = player:getAccessor().image_xscale2
			if playerAc.scepter > 0 then
				summon:getData().erad = 64+(32*(playerAc.scepter+1))
				summon:getData().eS = playerAc.scepter
			end
		activat:play(1.5,0.6)
end)

SurvivorVariant.setSkill(machinist, 4, function(player)
		playerData = player:getData()
		player:getData().skin_onActivity = 0
		
		if player:getAccessor().ropeDown == 1  then
			
			player:getData().skin_onActivity = 0
			SurvivorVariant.activityState2(player, 4.1, machinist.animations.shoot4_1, 0.2, true, true)
			
			playerData.frames = 8
			player:setAlarm(5,60)
			reload:play(1.5 + math.random() * 0.7,0.4)
			ParticleType.find("spark"):burst("middle", player.x, player.y, 2)
			if player:getData().queue < 4 then
				if playerData.queue == 1 then
					player:setSkill(4,
					"Heavy Weaponry: DETONATE.",
					"Launch a mine that embeds itself onto an enemy, exploding for 500% Damage." ,
					sprSkills, 5,  9*60)
				elseif playerData.queue == 2 then
					player:setSkill(4,
					"Heavy Weaponry: PIERCE.",
					"Launch an Energized Bolt, piercing for 300% Damage." ,
					sprSkills, 6,  9*60)
				elseif playerData.queue == 3 then
					player:setSkill(4,
					"Heavy Weaponry: IGNITE.",
					"Rapidly deal fire damage, for 60% Damage+20% over time. Hold to Prolong the Fire." ,
					sprSkills, 7,  9*60)
				end
				
				player:getData().queue = playerData.queue+1
			else
				player:getData().queue = 1
				player:setSkill(4,
				"Heavy Weaponry: BARRAGE.",
				"Shoot a barrage of piercing shots for 5x150% Damage. Shots scale with attack Speed." ,
				sprSkills, 4,  9*60)
			end
			if net.host then
				syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "queue", player:getData().queue)
			else
				hostSyncInstanceData:sendAsClient(player:getNetIdentity(), "queue", playerData.queue)
			end
		else
			if player:getData().queue  == 1 then
				player:getData().r = math.abs(5 * player:getAccessor().attack_speed)
				player:getData().skin_onActivity = 0
				SurvivorVariant.activityState2(player, 4.2, machinist.animations.shoot4_2, 0.2, true, true)
				playerData.frames = 14
			elseif player:getData().queue == 2 then
				player:getData().skin_onActivity = 0
				SurvivorVariant.activityState2(player, 4.3, machinist.animations.shoot4_3, 0.2, true, true)
				playerData.frames = 14
			elseif player:getData().queue == 3 then
				player:getData().skin_onActivity = 0
				SurvivorVariant.activityState2(player, 4.4, machinist.animations.shoot4_4, 0.2, true, true)
				playerData.frames = 16
			elseif player:getData().queue == 4 then
				player:getData().skin_onActivity = 0
				SurvivorVariant.activityState2(player, 4.5, machinist.animations.shoot4_5, 0.2, true, true)
				playerData.frames = 14
				player:getData().r = 180
				player:getData().vHeld = true
				player:getData().xsFix = player.xscale
				player:getAccessor().pHmax = player:getAccessor().pHmax/4
				player:getData().phQ = player:getAccessor().pHmax
			end
		end

end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	local sSwap = machinist.animations
	
	local image_xscale2 = playerAc.image_xscale2
	if SurvivorVariant.getActive(player) == machinist then
		local subimg = math.floor(playerAc.image_index2)
		
		if skill == 1.1 then
			playerAc.image_index2 = playerAc.image_index2+(0.20 * playerAc.attack_speed)
			
			local direc = 0
			if image_xscale2 < 0 then
				direc = 180
			end
			
			if subimg >= 1 and player:getData().skin_onActivity == 0 then 
				player:getData().skin_onActivity = 1
				Sound.find("Bullet2"):play(1 + math.random() * 0.7)
				
				local bullet = player:fireBullet(player.x+(5*player.xscale), player.y, direc, 200, 1.3, Sprite.find("Sparks10r"), DAMAGER_BULLET_PIERCE)
				bullet:set("damage_degrade",0.85)
				bullet:getData().tag = true
				bullet:getData().parent = player
				addBulletTrail(bullet, Color.WHITE, 2, 25, false, true)
			end
			if (math.floor(playerAc.image_index2)) >=11 then
				  playerAc.activity = 0
                  playerAc.activity_type = 0
				  player:getData().skin_onActivity = 0
			end
			playerAc.sprite_jump = machinist.animations.jumpHalf.id
		end
		
		if skill == 2.1 then
			playerAc.image_index2 = playerAc.image_index2+(0.20 * playerAc.attack_speed)
			local d = 1
			local e = 0
			if player:getAccessor().image_xscale2 < 0 then
				d = -1
				e = 180
			end
			if subimg >= 3 then
				playerAc.invincible = 15
				if player:getData().skin_onActivity == 0 then 
					
					player:getData().skin_onActivity = 1
					player:getAccessor().pVspeed = -3
					Sound.find("Bullet2"):play(1 + math.random() * 0.2)
					
					local summon = objDShot:create(player.x, player.y - 3)
						summon:set("direction", e + (45*d))
						summon:getData().parent = player
						summon:getData().team = playerAc.team
				end
			end
			
			if player:getAccessor().pVspeed > 0 then
				player:getAccessor().pVspeed = 0
			end
			
			if subimg >= 6 and player:getData().skin_onActivity == 1 then 
				player:getData().skin_onActivity = 2
				Sound.find("Bullet2"):play(1.25 + math.random() * 0.2)
				
				local summon = objDShot:create(player.x, player.y - 3)
					summon:set("direction", e)
					summon:getData().parent = player
					summon:getData().team = playerAc.team
			end
			
			if subimg >= 9 and player:getData().skin_onActivity == 2 then 
				player:getData().skin_onActivity = 3
				Sound.find("Bullet2"):play(1.5 + math.random() * 0.2)
				
				local summon = objDShot:create(player.x, player.y - 3)
					summon:set("direction", e-(45*d))
					summon:getData().parent = player
					summon:getData().team = playerAc.team
			end
			
			
			playerAc.sprite_jump = machinist.animations.noneHalf.id
			playerAc.sprite_idle = machinist.animations.noneHalf.id
			playerAc.sprite_walk = machinist.animations.noneHalf.id
			
			if (math.floor(playerAc.image_index2)) >=11 or playerAc.activity == 30 then
				  playerAc.activity = 0
                  playerAc.activity_type = 0
				  player:getData().skin_onActivity = 0
			end
		end
		
		if math.floor(skill) == 3 then
			playerAc.image_index2 = playerAc.image_index2+(0.22)
			playerAc.invincible = 30
			playerAc.pHspeed = playerAc.pHmax*2.5*player.xscale
			
			playerAc.sprite_jump = machinist.animations.noneHalf.id
			playerAc.sprite_idle = machinist.animations.noneHalf.id
			playerAc.sprite_walk = machinist.animations.noneHalf.id
			
			if playerAc.image_index2 >= 5 then
				  playerAc.activity = 0
                  playerAc.activity_type = 0
				  player:getData().skin_onActivity = 0
			end
			
		end
		
		if math.floor(skill) == 4 then
			playerAc.image_index2 = playerAc.image_index2+(0.20 * playerAc.attack_speed)
			if subimg == 1 then
				if skill == 4.1 then
					if net.host then
						syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "activity", playerAc.activity)
						syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "image_index2", playerAc.image_index2)
					else
						hostSyncInstanceVar:sendAsClient(player:getNetIdentity(), "activity", playerAc.activity)
						hostSyncInstanceVar:sendAsClient(player:getNetIdentity(), "image_index2", playerAc.image_index2)
					end
				end
			end
			if skill > 4.1  then
				if skill == 4.2 then
					if subimg >= 7 and player:getData().skin_onActivity == 0 then 
						player:getData().skin_onActivity = 1
						hShoot:play(1.3 + math.random() * 0.7,0.6)
						
						local bullet = player:fireBullet(player.x+(5*player.xscale), player.y+5, player:getFacingDirection(), 600, 1.5, sSwap.sPierce, DAMAGER_BULLET_PIERCE)
						bullet:set("damage_degrade",0.85)
						bullet:getData().parent = player
					end
					
					if subimg >= 8 and player:getData().skin_onActivity == 1 and playerData.r > 0 then
						playerAc.image_index2 = 6
						player:getData().skin_onActivity =0 
						playerData.r = playerData.r-1
					end
				end
				
				if skill == 4.3 then
					if subimg >= 6 and player:getData().skin_onActivity == 0 then 
						player:getData().skin_onActivity = 1
						snipe:play(2 + math.random() * 0.7,0.6)
						
						local bullet = player:fireBullet(player.x+(5*player.xscale), player.y+5, player:getFacingDirection(), 300, 0.25, nil,nil)
							bullet:getData().parent = player
							bullet:getData().drill = true
							addBulletTrail(bullet, Color.BROWN, 8, 30, false, true)
							if onScreen(player) then
							misc.shakeScreen(2)
							snipe:play(2 + math.random() * 0.3,0.53)
							ParticleType.find("spark"):burst("middle", player.x+(4*player.xscale), player.y, 8)
							end
					end
				end
			
				if skill == 4.4 then
					if subimg >= 6 and player:getData().skin_onActivity == 0 then 
						player:getData().skin_onActivity = 1
						snipe:play(2 + math.random() * 0.7,0.6)
						
						local bullet = player:fireBullet(player.x+(5*player.xscale), player.y+5, player:getFacingDirection(), 600, 2.5, sSwap.sPierce, DAMAGER_BULLET_PIERCE)
							bullet:set("damage_degrade",-0.25)
							bullet:getData().parent = player
							if onScreen(player) then
								misc.shakeScreen(5)
								snipe:play(1.5 + math.random() * 0.3,0.5)
								ParticleType.find("spark"):burst("middle", player.x+(4*player.xscale), player.y, 6)
							end
							addBulletTrail(bullet, Color.RED, 5, 40, false, true)
					end
				end
				
				if skill == 4.5 then
					if syncControlRelease(player, "ability4") or player:getData().r <= 0 then
						player:getData().vHeld = false
					else
						player:activateSkillCooldown(4)
					end
					
					player:getData().r = player:getData().r -1
					if subimg >=7 and subimg <= 10 and not Pyre:isPlaying()then
						Pyre:play(1.2 + math.random() * 0.2, 1	)
					end
					
					if subimg >= 7 and player:getData().skin_onActivity == 0 then 
						player:getData().skin_onActivity = 1
						local bullet = player:fireExplosion(player.x+(26*player:getAccessor().image_xscale2), player.y, 1, 0.4, 0.6, nil, Sprite.find("Sparks11"))
						DOT.addToDamager(bullet, DOT_FIRE, player:get("damage")* 0.1, 20, "mach_fire", true)
					end
					
					if subimg >= 10 and player:getData().skin_onActivity == 1 and player:getData().vHeld == true then
						playerAc.image_index2 = 7
						player:getData().skin_onActivity =0 
					end
					
					if subimg >= 10 and player:getData().vHeld == false then
						Pyre:stop()
					end
				end
				
				if playerAc.pVspeed < 0 then
					playerAc.pVspeed = 0
				end
				if (math.floor(playerAc.image_index2)) < playerData.frames -1 and skill < 4.5 then
					player:getAccessor().image_xscale2 = player.xscale
					playerAc.activity_type = 5
					playerAc.sprite_jump = machinist.animations.noneHalf.id
					playerAc.sprite_idle = machinist.animations.noneHalf.id
					playerAc.sprite_walk = machinist.animations.noneHalf.id
				else
					playerAc.sprite_jump = machinist.animations.jumpHalfU.id
					playerAc.sprite_idle = machinist.animations.idlehalfU.id
					playerAc.sprite_walk = machinist.animations.walkhalfU.id
				end
			end
			
			
			if (math.floor(playerAc.image_index2)) >= playerData.frames -1 then
				player.sprite = machinist.animations.idle
				playerAc.sprite_jump = machinist.animations.jumpHalf.id
				playerAc.sprite_idle = machinist.animations.idlehalf.id
				playerAc.sprite_walk = machinist.animations.walkhalf.id
				  playerAc.activity = 0
                  playerAc.activity_type = 0
				  player:getData().skin_onActivity = 0
				
			end
		end
	end
end)

callback.register("onPlayerDraw", function(player)
	if SurvivorVariant.getActive(player) == machinist then
		local playerAc = player:getAccessor()
		if playerAc.activity == 0 or playerAc.activity == 30 then
			playerAc.sprite_jump = machinist.animations.jump.id
			playerAc.sprite_idle = machinist.animations.idle.id
			playerAc.sprite_walk = machinist.animations.walk.id
			playerAc.sprite_index2 = machinist.animations.noneHalf.id
		end
		
		for _, dron in ipairs(oDrone:findAll()) do
			if dron:getData().parent == player then
				dd = dron:getData()
				
				if dd.dT and dd.dT:isValid() then
					local n2 = 0
					local darkRed = Color.fromHex(0xffcdcd)
					--= math.ceil(point_distance(self.x,self.y,x,y)/2.5)
					local n2Max = 25
					while n2 <= n2Max do
						
						local b = bezier_Point_Find(n2/n2Max,dron.x,dron.y,dd.x1.x,dd.x1.y,dd.x2.x,dd.x2.y,dd.tX.x,dd.tX.y)
						local b2 = bezier_Point_Find((n2+1)/n2Max,dron.x,dron.y,dd.x1.x,dd.x1.y,dd.x2.x,dd.x2.y,dd.tX.x,dd.tX.y)
						if n2 < n2Max-1 then
							if dd.shoot > 0 then
								graphics.color(darkRed)
								graphics.line(b[0],b[1],b2[0],b2[1],dd.shoot*1.5)
								
								for _, dorb in ipairs(objDShot:findAllEllipse(dron.x-dd.erad, dron.y-dd.erad, dron.x+dd.erad, dron.y+dd.erad)) do
									graphics.color(Color.fromHex(0x9cffff))
									graphics.line(dorb.x,dorb.y,dron.x,dron.y,dd.shoot)
								end
							end
						end
						n2 = n2+1
					end	
				end
			end
		end	
	end
end)
