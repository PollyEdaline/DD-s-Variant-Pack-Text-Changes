local survivor = Survivor.find("Baroness", "Starstorm")
local path = "Variants/Courrier/"
pobj = setmetatable({}, { __index = function(t, k)
	return ParentObject.find(k)
end})

local buff_Slow = Buff.find("slow")
--credit to Katana Zero for the SfX
local Courier = SurvivorVariant.new(
survivor,
"Courier",
Sprite.load("CourierSelect", path.."Select", 16, 2, 0),
{
	idle_1 = Sprite.load("CourierIdle", path.."idle", 3, 5, 5),
	walk_1 = Sprite.load("Courier_Walk", path.."walk", 8, 5, 5),
	jump_1 = Sprite.load("Courier_Jump", path.."jump", 1, 6, 5),
	climb = Sprite.load("Courier_Climb", path.."climb", 2, 5, 6),
	death = Sprite.load("Courier_Death", path.."death", 8, 30, 8),
	decoy = Sprite.load("Courier_Decoy", path.."decoy", 1, 9, 10),
	
	idle_2 = Sprite.load("Courier_Idle_Bike", path.."idleBike", 1, 12, 5),
	walk_2 = Sprite.load("Courier_Walk_Bike", path.."walkBike", 8, 18, 8),
	jump_bike = Sprite.load("Courier_Jump_Bike", path.."jumpBike", 1, 13, 8),
	bclimb = Sprite.load("bike_Climb", path.."wallClimb", 8, 7, 19),
	
	shoot1_1A = Sprite.load("Courier_Shoot1", path.."shoot1_1A", 7, 6, 14),
	shoot1_1B = Sprite.load("Courier_Shoot1Reload", path.."shoot1_1B", 7, 6, 10),
	shoot1_2 = Sprite.load("Courier_Spin", path.."shoot1_2", 7, 17, 8),
	shoot2_1 = Sprite.load("Courier_toss", path.."shoot2A", 5, 5, 5),
	shoot2_2 = Sprite.load("Courier_Dash", path.."shoot2B", 19, 21, 17),
	shoot3_1 = Sprite.load("Courier_mount", path.."shoot3a", 8, 17, 13),
	shoot3_2 = Sprite.load("Courier_unmount", path.."shoot3b", 7, 6, 6),
	shoot4_1 = Sprite.load("Courier_point", path.."shoot4a", 12, 6, 6),
	shoot4_2 = Sprite.load("Courier_barrage", path.."shoot4b", 15, 17, 17),
},
Color.fromHex(0x6c7977)) 
local sprSkills = Sprite.load("Courier_Skills", path.."skills", 9, 0, 0)
local sprPlasmae = Sprite.load("Courier_plasma", path.."fyre", 6, 4, 8)
local sprVehicleMask = Sprite.load("Courier_VehicleMask", path.."vehicleMask", 1, 6, 5)
local sndSlashy1 = Sound.find("SamuraiShoot1")
local sprSplash = Sprite.load("Splash", path.."splash", 4, 8, 5)
local sndShoot1 = Sound.find("CowboyShoot1")
local skillA = Sound.load("spinSFX", path.."skillA")
local skillB = Sound.load("launchSFX", path.."skillB")
local skillC = Sound.load("windSFX", path.."skillC")
local sSkill3a = Sound.load("Courier_Shoot3A", path.."skill3a")
local sSkill3b = Sound.load("Courier_Shoot3B", path.."skill3b")
local sprPlasplode = Sprite.load("plas", path.."plas", 5, 21, 16)
local sprBarrage = Sprite.load("bar", path.."Barraged", 4, 17, 49)
local sndEnergy1 = Sound.find("GuardDeath")
local sndReload = Sound.find("CowboyShoot4_1")
local shoot4_1b = Sprite.load("shoot4_1b", path.."shoot4aIdle", 1, 6, 6)
local shoot4_1c = Sprite.load("shoot4_1c", path.."shoot4aWalk", 8, 5, 5)
local shoot4_1d = Sprite.load("shoot4_1d", path.."shoot4aJump", 1, 6, 6)

SurvivorVariant.setLoadoutSkill(Courier, "Exhaust", "Eject a piercing, super-heated burst of plasma from your battery for &y&425% damage. Needs to be &b&manually recharged&!&.", sprSkills,1)
SurvivorVariant.setLoadoutSkill(Courier, "Expedited Shipping", "Ignite and toss your battery, exploding for &y&65% damage on impact&!&. Leaves a slowing field that &y&ignites for 300% damage&!&. &y&Recharging&!& resets the cooldown.", sprSkills,4)
SurvivorVariant.setLoadoutSkill(Courier, "Plasmacycle", "Teleport your trusty plasmacycle to you. &b&Increases movement speed&!&, and allows you to &b&drive up walls&!&. Activate again to &y&leap off the plasmacycle&!&.", sprSkills,6)
SurvivorVariant.setLoadoutSkill(Courier, "Plasma Barrage", "Weaponize the thrust from your plasmacycle, launching a barrage of plasma shots for &y&4x600% damage.", sprSkills,7)

SurvivorVariant.setInfoStats(Courier, {{"Speed", 10}, {"Reliability", 8}, {"Mobility", 9}, {"Heat", 7}, {"Recklessness", 8}, {"Height", 2}}) 
SurvivorVariant.setDescription(Courier, "The &y&Courier&!& is a mobile survivor that thrives on the black market. Her &y&Plasmacycle&!& can be used for offense, ejecting plasma when she fires. She may be on the shorter end, but her skills are unparalelled.")

Courier.endingQuote = "..and so she left, delivery still ahead of schedule."
callback.register("onSkinInit", function(player, skin) 
	if skin == Courier then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		player:getModData("Starstorm").skin_skill1Override = true
		player:getModData("Starstorm").skin_skill2Override = true
		player:getModData("Starstorm").skin_skill3Override = true
		player:getModData("Starstorm").skin_skill4Override = true
		
		playerData.animTimer = 1
		playerData.wallJumpCount = 0
		playerData.bikeSpawn = true
		playerData.bikeSpawnType = 0
		playerData.rev = 0
		playerData.revCont = 0
		player:getData().spn = false
		playerData.release = false
		playerData.wallJumpTimer = 0
		playerData.wallJumpSpeed = playerAc.pHmax/1.15
		player:setAnimation("shoot1", player:getAnimation("shoot1_1A"))
		playerData.reloading = false
		playerData.barrage = 0
		playerData.Frame = 0
		playerData.getFrame = 0
		playerData.skillXcd = 0
		playerData.skillCcd = 0
		playerData.animChanged = false
		
		
		player:survivorSetInitialStats(95, 12, 0.01)
		--skills
		player:setSkill(1,
		"Exhaust",
		"Eject a piercing, super-heated burst of plasma from your battery for 425% damage. Needs to be manually recharged.",
		sprSkills, 1, 30)
		
		player:setSkill(2,
		"Expedited Shipping",
		"Ignite and toss your battery, exploding for 65% damage on impact. Leaves a slowing field that ignites for 300% damage. Recharging resets the cooldown.",
		sprSkills, 4,  6* 60)
		
		player:setSkill(4,
		"Plasma Barrage",
		"Weaponize the thrust from your plasmacycle, launching a barrage of plasma shots for 4x600% damage.",
		sprSkills, 7,  8* 60)
	end
end)

--explosive
local sprCase = Sprite.load("Case", path.."Case", 4, 7, 5)
local objCase = Object.new("tossedCase")
local sBoom = Sound.find("Smite")

objCase.sprite = sprCase
objCase.depth = 0


objCase:addCallback("create", function(self)--Case, what Spawns the Barricade
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	self.mask =sprBulletMask
	self:getData().life = 60*5
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.damage = 0.55
	self:getData().acc = 0
	self.spriteSpeed = 0.25
	selfData.vSpeed = -2
	selfAc.speed = 1.5
	selfData.angleSpeed = math.random(-10, 10)
	self.spriteSpeed = 0.25
	selfData.bState = 0
end)

objCase:addCallback("step",function(self)--Toss that Case
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local parent = selfData.parent
	if parent and parent:isValid() then
		if selfData.direction == 0 then
			self.xscale = 1
		else
			self.xscale = -1
		end
		
		
		if selfData.bState == 0 then
			self.y = self.y + selfData.vSpeed
			selfData.vSpeed = selfData.vSpeed + 0.1
		end
		
		if self:collidesMap(self.x, self.y-3) and selfData.vSpeed < 0 then
			selfData.vSpeed = 0
		elseif self:collidesMap(self.x, self.y+4) and selfData.vSpeed > 0 and selfData.bState == 0 then 
			selfData.bState = 1
			selfAc.speed = 0
		end
		
		if selfData.bState == 1 then
			self.visible = false
			selfData.bState = 2
			if onScreen(self) then
				misc.shakeScreen(3)
				sBoom:play()
			end
			if parent then
				for i = 0, parent:get("sp") do
					explosion = parent:fireExplosion(self.x, self.y, 33 / 19, 30 / 4, selfAc.damage, sprPlasplode, sprSparks)
					explosion:set("direction", parent:getFacingDirection())
					explosion:set("skin_newDamager", 1)
					explosion:set("knockback", 3)
					explosion:set("stun", 1)
					if i ~= 0 then
						explosion:set("climb", i * 8)
					end
				end
			end
				for i = -3, 3 do
					local xx = i * 5
					local fTrail = Object.find("FireTrail"):create(self.x + xx, self.y - 20)
					fTrail:setAlarm(1, selfData.life)
					fTrail:set("parent", parent.id)
					fTrail:set("damage", parent:get("damage") * 0.65)
					fTrail.sprite = sprPlasmae
				end
				local range = 40
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
					if actor:get("team") ~= parent:get("team") then
						DOT.applyToActor(actor, DOT_FIRE, parent:get("damage") * 0.25, 3, "PlasmaHeat", false)
					end
				end
			if misc.getOption("video.quality") > 1 then
				ParticleType.find("spark"):burst("middle", self.x, self.y, 3)
			end
			
		end
		if selfData.bState == 2 then
			local range = 40
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
				if actor:get("team") ~= parent:get("team") then
					actor:applyBuff(buff_Slow, 10)
				end
			end
			selfData.life = selfData.life - 1
			if selfData.life <= 0 then
				self:destroy()
			end
		end
	end
end)

--Barrage
local sprBarCrosshair = Sprite.load("bCross", path.."lockOnPoint", 4, 8, 16)
local objBarCrosshair = Object.new("BarrageCrosshair")
local sprBarMask = Sprite.load("barMask",path.."lockMask",1,2,2)
objBarCrosshair.sprite = sprBarCrosshair
objBarCrosshair.depth = -2500


objBarCrosshair:addCallback("create", function(self)--Spawn of the barrage
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	self.mask =sprBulletMask
	self:getData().life = 0
	self:getData().range = 0
	self:getData().team = "player"
	self:getData().phase = 0
	selfAc.damage = 2
	
	self:getData().acc = 0
	self.spriteSpeed = 0.25
	self:getData().sType = 0
	self.mask = sprBarMask
	selfData.timeCounter = 0
	selfData.shotCounter = 0
	selfData.tracked = false
end)

objBarCrosshair:addCallback("step",function(self)--Crosshair and barrage
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local parent = selfData.parent
	local aSpeed = parent:getAccessor().attack_speed
	if selfData.parent and selfData.parent:isValid() then
		if selfData.direction == 0 then
			self.xscale = 1
		else
			self.xscale = -1
		end
		selfData.timeCounter = selfData.timeCounter + aSpeed
		
		if (selfData.timeCounter >= 10 and selfData.shotCounter > 0) or (selfData.timeCounter >= 60 and selfData.shotCounter == 0)then
			selfData.shotCounter = selfData.shotCounter + 1 
			selfData.timeCounter = 0
			if onScreen(self) then
				misc.shakeScreen(5)
				sBoom:play(1.3 + math.random())
			end
			if selfData.sType == 0 then
				self.visible = false
			end
			if misc.getOption("video.quality") > 1 then
				ParticleType.find("spark"):burst("middle", self.x, self.y, 3)
			end
			local explosion = parent:fireExplosion(self.x+(math.random(20)-math.random(20)), self.y-3, 1.75, 6.5, 3, sprBarrage, sprSparks)
					explosion:set("direction", parent:getFacingDirection())
					explosion:set("angle", (math.random(45)-math.random(45)))
					explosion:set("skin_newDamager", 1)
					explosion:set("knockup", explosion:get("knockup")+2)
					explosion:set("stun", 0.2)
		end
		
		if (parent:get("activity") ~= 4) then
			selfData.tracked = true
		end
		
		if selfData.tracked == false then
			self.x = parent.x + (50 *(self.xscale))
			local n = 0
			while not self:collidesMap(self.x, self.y + 2) and n < 150 do
				self.y = self.y + 2
				n = n + 1
			end
		end
		
		if selfData.shotCounter == 4*(1+parent:get("scepter")) then
			self:destroy()
		end
	end
end)

--autoBike

--BikeCode
local objBike = Object.new("elecBike")
local sprBike = Sprite.load("Bike", path.."idleSbike", 1, 12, 4)
local sprBikeLoad = Sprite.load("BikeSpawn", path.."bikeSpawn", 8, 17, 13)
local sprWheelie = Sprite.load("BikeSoloWheel", path.."shootSoloa", 11,  20, 16)
local sprSpeen = Sprite.load("sprSoloSpin", path.."shootSoloB", 7, 17, 13)
local sprBarrageB = Sprite.load("cBike_barrage", path.."shoot4Bike", 15, 17, 17)
objBike.sprite = sprBikeLoad
objBike.depth = 0

objBike:addCallback("create", function(self)--BikeSpawn
	local selfAc = self:getAccessor()
	self.mask = sprVehicleMask
	self:getData().spawned = false
	self:getData().life = 60*5
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	self:getData().acc = 0
	self:getData().barrager = 0
	self.spriteSpeed = 0.25
	self:getData().dying = false
	self:getData().state = 0
	self:getData().Frame = 0
	self:getData().getFrame = 0
	self.spriteSpeed = 0.25
end)

objBike:addCallback("step", function(self)--bikeCode
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
		if parent:getData().barrage then
			selfData.barrager = parent:getData().barrage
			self:getData().state = 3
		end
		if self:getData().state == 1 then
			if self.sprite ~=  sprSpeen then
				self.sprite =  sprSpeen
			end		
			if self:getData().getFrame > 1 and self:getData().getFrame < 6 then
				local bullet = parent:fireExplosion(self.x, self.y, 1.2, 1, 1.25, nil, sprMuSparks2)
				bullet:set("knockup", 1)
				self:getData().getFrame = -1
			end
			if math.floor(self.subimage)  == 7 then
				self:getData().state = 0
				self.sprite = sprBike
			end
		end
		
		if self:getData().state == 3 then
			if self.sprite ~=  sprBarrageB then
				self.sprite =  sprBarrageB
			end		
			if self:getData().getFrame == 5 or self:getData().getFrame == 9 or self:getData().getFrame == 7 or self:getData().getFrame == 11 then
				if onScreen(self) then
					misc.shakeScreen(2)
					sndEnergy1:play(1.3 + math.random() * 0.3,0.5)
				end
			end
			if math.floor(self.subimage)  > 12 then
				if selfData.barrager > 0 then
					self.subimage = 5
					selfData.barrager = selfData.barrager - 1
				elseif math.floor(self.subimage)  == 15 then
					self:getData().state = 0
					self.sprite = sprBike
				end
			end
			if math.floor(self.subimage)  == 15 then
				self:getData().state = 0
				self.sprite = sprBike
			end
		end
		if self:getData().state == 2 then
			ParticleType.find("FireIce"):burst("middle", self.x, self.y+math.random(5)-math.random(5), 1)
			
			if not self:collidesMap(self.x + parent:getAccessor().pHmax * self.xscale*3,self.y) then
				if math.floor(self.subimage) < 8 then
					self.x = self.x + (parent:getAccessor().pHmax *self.xscale)*3
				end
			end
			if self:getData().getFrame ~= -1 then
				local bullet = parent:fireExplosion(self.x, self.y, 1.2, 1, 1.15, nil, sprMuSparks2)
				bullet:set("stun", 0.2)
				bullet:set("knockup", bullet:get("knockup")+2)
				self:getData().getFrame = -1
			end
			if self.sprite ~= sprWheelie then
				self.sprite = sprWheelie
			end
			if math.floor(self.subimage) == 8 then
				self.x = self.x + (parent:getAccessor().pHmax *self.xscale)*2
			end
			if math.floor(self.subimage) == 9 then
				self.x = self.x + (parent:getAccessor().pHmax *self.xscale)*1.5
			end
			if math.floor(self.subimage) == 10 then
				self.x = self.x + (parent:getAccessor().pHmax *self.xscale)*1.25
			end
			if math.floor(self.subimage)  == 11 then
			
				self:getData().state = 1
				self.sprite = sprSpeen
			end
		end
		
		if parent:getData().spn == true  and self:getData().state ~= 3 then
			if self:getData().state ~= 1 then
				skillA:play(1 + math.random() * 0.3,0.8)
				self:getData().state = 1
			end
		end
		
		if self:collidesMap(self.x, self.y) then
			if not self:collidesMap(self.x, self.y + 2) then
				self.y = self.y + 2
			elseif not self:collidesMap(self.x - 4, self.y) then
				self.x = self.x - 4
			elseif not self:collidesMap(self.x + 4, self.y) then
				self.x = self.x + 4
			end
		elseif not self:collidesMap(self.x, self.y + 1) then
			selfData.acc = selfData.acc + 0.1
			self.y = self.y + selfData.acc
		end
		if Stage.collidesPoint(self.x, self.y) then
		self.y = self.y-1
		end
		if self:getData().spawned == false and self.subimage > 7.5 then
			self.sprite = sprBike
			self:getData().spawned = true
		end
		
		if selfData.life == 0 and selfData.dying == false then
			self.subimage = 1
			selfData.life = 24
			selfData.dying = true
		end
		
		if self:getData().getFrame ~= -1 then
			self:getData().getFrame = -1
		end
		
				if parent:getData().bikeSpawn == true or parent:getModData("Starstorm").vehicle then
			self:destroy()
		end
	end
end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == Courier then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		if playerData.animChanged == true then
			if player:get("activity") ~= 4 then
				 playerData.animChanged = false
			end
		end
		--walClimb Code
		if playerAc.moveUp == 1 and playerData.wallJumpCount == 1 and playerData.wallJumpTimer > 0 then
			playerAc.pVspeed = -4
			playerData.wallJumpCount = 2
		end
		if playerAc.free == 0 then
			playerData.wallJumpTimer = 40
			playerData.wallJumpSpeed = playerAc.pHmax
		end
		
		if player:getData().spn == true then
			player:getData().spn = false
		end
		--spawns the bike whenever called.
		if playerData.bikeSpawn == true then
			playerData.bikeSpawn = false
			sSkill3b:play(1 + math.random() *0.3)
			local sY
			if playerData.bikeSpawnType == 0 then sy = 0
			else
			sy = 3
			end
			local bullet = objBike:create(player.x, player.y+sy)
			bullet.xscale = player.xscale
			bullet:getData().parent = player
			bullet:getData().direction = player:getFacingDirection()
			
			if playerData.bikeSpawnType == 1 then
				bullet.sprite = sprBike
				bullet:getData().spawned = true
				playerData.bikeSpawnType = 0 
				
			elseif playerData.bikeSpawnType == 2 then
				bullet.sprite = sprWheelie
				bullet:getData().spawned = true
				bullet:getData().state = 2
				skillB:play(1 + math.random() * 0.4,0.6)
				playerData.bikeSpawnType = 0
				
			end
			
		end
		if (playerData.barrage and not player:getModData("Starstorm").vehicle) or playerData.barrage == 0 then
			playerData.barrage = nil 
		end
		if player:getModData("Starstorm").vehicle then
			if playerData.wallJumpCount >= 0 then
				if playerAc.free == 0 then
					 playerData.wallJumpCount = 0
				end
			end
			if ((playerAc.moveLeft == 1 and player.xscale < 0) or (playerAc.moveRight == 1 and player.xscale > 0)) and player:collidesMap(player.x+(12*player.xscale),player.y) then
			player:setAnimation("jump_2", player:getAnimation("bclimb"))
				
				if playerData.wallJumpTimer > 0 then
					playerData.wallJumpTimer = playerData.wallJumpTimer - 1
				else
					playerData.wallJumpSpeed = playerData.wallJumpSpeed-0.05
				end
				playerAc.pVspeed = playerData.wallJumpSpeed*-1
				if playerData.wallJumpCount ~= 1 then 
					playerData.wallJumpCount = 1
				end
			else
			player:setAnimation("jump_2", player:getAnimation("jump_bike"))
			end
			player:setAnimation("shoot1", player:getAnimation("shoot1_2"))
		end
	end
end)
survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == Courier then
		player:setSkill(4,
		"Daredevil",
		"Weaponize the thrust from your plasmacycle, launching a barrage of plasma shots for 8x600% damage.",
		sprSkills, 9,  7* 60)
	end
end)
SurvivorVariant.setSkill(Courier, 1, function(player)
	if not player:getModData("Starstorm").vehicle then
		player:getData().spn = true
		if  player:getData().reloading == false then
			player:setAnimation("shoot1", player:getAnimation("shoot1_1A"))
			SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.20, true, true)
			player:getData().reloading = true
						
			player:setSkill(1,
				"Cooldown",
				"Cool the battery down.",
				sprSkills, 2, 30)
		else
			player:setAnimation("shoot1", player:getAnimation("shoot1_1B"))
			SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.20, true, true)
			player:getData().reloading = false
			player:setSkill(1,
			"Exhaust",
			"Eject a piercing, super-heated burst of plasma from your battery for 425% damage. Needs to be manually recharged.",
			sprSkills, 1, 30)
		end
	end
end)
SurvivorVariant.setSkill(Courier, 2, function(player)
	if player:getModData("Starstorm").vehicle then
		local playerData = player:getData()
		playerData.release = false
		playerData.rev = 0
		playerData.revCont = 0
	end
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
		
	if SurvivorVariant.getActive(player) == Courier then
		if player:getModData("Starstorm").vehicle == false then
			if skill == 1 then
				if playerData.reloading == true then
					if relevantFrame == 1 then
						if onScreen(player) then
							misc.shakeScreen(3)
							sndEnergy1:play(1.2 + math.random() * 0.3,0.5)
							sndShoot1:play(1.2 + math.random() * 0.3,0.5)
						end
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 75, 4.25, sprSplash, DAMAGER_BULLET_PIERCE)
						bullet:set("max_hit_number", 3)
						bullet:set("knockback", 2.5)
					end
				else
					if relevantFrame == 1 then
						playerData.reloading = false
						player:setAlarm(3,0.25)
						sndReload:play(1.3 + math.random() * 0.2)
					end
				end
			elseif skill == 2 then
				if relevantFrame == 3 then
					playerData.reloading = true
					player:setSkill(1,
						"Cooldown",
						"Cool the battery down.",
						sprSkills, 2, 30)
					for i = 0, playerAc.sp do --Toss Crate
						local bullet = objCase:create(player.x, player.y)
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
				--Stationary Barrage
			elseif skill == 4 then
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax/1.5
					moving = true
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax/1.5
					moving = true
				end
				
				if relevantFrame == 1 then
					playerData.barrage = player:get("scepter")
				end
				if relevantFrame == 2 then
					for i = 0, playerAc.sp do --Summon Crosshair
						local bullet = objBarCrosshair:create(player.x, player.y)
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
			end
		elseif player:getModData("Starstorm").vehicle == true then
			if skill == 1 then
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax/2
					moving = true
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax/2
					moving = true
				end
				if relevantFrame >2 and relevantFrame < 5 then
					if relevantFrame == 3 then
						skillA:play(1 + math.random() * 0.3,0.8)
					end
					ParticleType.find("spark"):burst("middle", player.x+(16*(player.xscale)), player.y, 2)
					for i = 0, player:get("sp") do
						local bullet = player:fireExplosion(player.x + player.xscale * 18, player.y, 1.1, 2, 0.75, nil, sprSparks7)
						bullet:set("max_hit_number", 5)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif skill == 2 then--wind up and charge wheelie
				if syncControlRelease(player, "ability2") then
					playerData.release = true
				end
				
				if playerData.release == false then
				player:activateSkillCooldown(2)
				playerAc.pHspeed = 0
					if playerData.rev < 60 then
						playerData.rev = math.round(playerData.rev + (0.5*playerAc.attack_speed))
						player.spriteSpeed = 0.25
						if playerData.rev % 5 == 0 then
							ParticleType.find("spark"):burst("middle", player.x-(8*(player.xscale)), player.y+3, 1)
						end
					else
						playerData.rev = 60
						playerData.revCont = playerData.revCont+1
							if playerData.revCont % 10 == 0 then
								ParticleType.find("spark"):burst("middle", player.x-(8*(player.xscale)), player.y+3, 2)
								ParticleType.find("Rubble2"):burst("middle", player.x-(8*(player.xscale)), player.y+3, 1)
								ParticleType.find("Fire4"):burst("middle", player.x-(8*(player.xscale)), player.y+3, 1)
							end
						player.spriteSpeed = 0.5
					end
					if player.subimage > 5 then
						player.subimage = 1
					end
					if math.floor(player.subimage) == 2 and relevantFrame ~= 2 then 
						skillC:play(1.2 + math.random() * playerData.rev/30,0.7)
						relevantFrame = 2
					end
				elseif playerData.release == true then
					ParticleType.find("FireIce"):burst("middle", player.x, player.y+math.random(5)-math.random(5), 1)
					if player.subimage < 8 then
						if onScreen(player) then
							skillB:play(1 + math.random() *playerData.rev/30,0.6)
							
							misc.shakeScreen(4)
						end
						player.subimage = 8
						local bullet = player:fireExplosion(player.x, player.y, 1.2, 2, math.max(1,playerData.rev/30), nil, sprSparks7)
						bullet:set("knockup", bullet:get("knockup") + playerData.rev/30)
						bullet:set("knockback_direction",player.xscale)
						bullet:set("stun", 0.2)
					end
					playerAc.pHspeed = playerAc.pHmax*math.max(1,playerData.rev/30)*player.xscale
					if relevantFrame > 8 and relevantFrame < 19 then
						for i = 0, player:get("sp") do
							local bullet = player:fireExplosion(player.x, player.y, 1.2, 2, math.max(0.15,playerData.rev/20), nil, sprSparks7)
							bullet:set("max_hit_number", 5)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						bullet:set("knockup", bullet:get("knockup") + playerData.rev/30)
						bullet:set("knockback_direction",player.xscale)
						bullet:set("stun", 0.2)
						end
					end
				end
				--mobile crosshair
			elseif skill == 4 then
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax/2
					moving = true
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax/2
					moving = true
				end
				if input.checkControl("ability1", player) == input.PRESSED then
					player.subimage = 0
					player:getAccessor().z_skill = 1
				end

				if relevantFrame == 1 then
					playerData.barrage = player:get("scepter")
					for i = 0, playerAc.sp do --spawn crosshair
						local bullet = objBarCrosshair:create(player.x, player.y+3)
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
				if playerData.Frame ~= math.floor(player.subimage) then
					playerData.Frame = math.floor(player.subimage)
					playerData.getFrame = math.floor(player.subimage)
				end
				if playerData.getFrame == 5 or  playerData.getFrame == 9 or  playerData.getFrame == 7 or  playerData.getFrame ==11 then
					if onScreen(player) then
						misc.shakeScreen(2)
						sndEnergy1:play(1.4 + math.random() * 0.3,0.5)
					end
				end
				
				if relevantFrame > 12 then
					if playerData.barrage then
						player.subimage = 5
						relevantFrame = 0
						playerData.barrage = playerData.barrage - 1
					end
				end
				if playerData.getFrame ~= -1 then
					playerData.getFrame = -1
				end
			end
		end
		if skill == 3 then
			if player:getModData("Starstorm").vehicle == true then
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax/1.5
					moving = true
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax/1.5
					moving = true
				end
			else
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax
					moving = true
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax
					moving = true
				end
			end
			if relevantFrame == 1 then
				
				local playerMdata = player:getModData("Starstorm")
				if player:getModData("Starstorm").vehicle == true then
				playerData.skillXcd = player:getAlarm(3) 	
				player:setAlarm(3, playerData.skillCcd )
					if input.checkControl("down", player) == input.HELD then
						playerAc.pVspeed = -2
					else
						playerAc.pVspeed = -5
					end
					player:getModData("Starstorm").vehicle = false
					playerAc.pspeed = playerAc.pHmax * player.xscale
					player.mask = Sprite.find("PMask")
					player:set("pHmax", player:get("pHmax") - playerMdata._SpeedBoost)
					if input.checkControl("down", player) ~= input.HELD then
						playerData.bikeSpawnType = 2
						skillC:play(1.2 + math.random() * playerData.rev/30,0.7)
					else
						playerData.bikeSpawnType = 1
					end
					playerData.bikeSpawn = true
					playerAc.canrope = 1
					--if playerData.lastSpeed then
						--playerAc.pHmax = playerData.lastSpeed
						--playerData.lastSpeed = nil
					--end
					playerAc.walk_speed_coeff = 1
					
					player:setSkill(1,
					"Exhaust",
					"Eject a piercing, super-heated burst of plasma from your battery for 425% damage. Needs to be manually recharged.",
					sprSkills, 1, 30)
					player:setSkill(2,
					"Expedited Shipping",
					"Ignite and toss your battery, exploding for 65% damage on impact. Leaves a slowing field that ignites for 300% damage. Recharging resets the cooldown.",
					sprSkills, 4,  5* 60)

					player:setSkill(3, "Plasmacycle", "Teleport your trusty plasmacycle to you. Increases movement speed, and allows you to drive up walls. Activate again to leap off the plasmacycle.",
					sprSkills, 6, 60)
				else
					
					if input.checkControl("down", player) == input.HELD then
						playerData.bikeSpawn = true
						player.subimage = 0
					else
						sSkill3a:play(1 + math.random() *0.3)
						playerData.skillCcd = player:getAlarm(3) 	
						player:setAlarm(3, playerData.skillXcd )
						
						player:getData().reloading = false
						player:getModData("Starstorm").vehicle = true
						player.mask = sprVehicleMask
						
						player:set("pHmax", player:get("pHmax") + playerMdata._SpeedBoost)
						playerAc.canrope = 0
						playerAc.walk_speed_coeff = 0.4 * (1.7 / playerMdata._SpeedBoost)
						
						player:setSkill(1, "Burning Drift", "Weaponize the plasmacycle's momentum, slamming enemies with the rear wheel for 2x75% damage.",
						sprSkills, 3, 5)
						
						player:setSkill(2, "Burnout", "Anchor the plasmacycle to the ground and charge up speed. Release to charge forward for up to 5x300% damage.",
						sprSkills, 5, 5*50)
						
						player:setSkill(3, "Heelclick", "Leap off the plasmacycle, launching it forward for 110% damage.",
						sprSkills, 8, 5 * 60)
					end
				end
			end
		end
	end
end)
callback.register("onPlayerDraw", function(player)
	if SurvivorVariant.getActive(player) == Courier then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		local playerMdata = player:getModData("Starstorm")
		if (player:get("activity") == 4 and player:getModData("Starstorm").vehicle == false) or playerData.animChanged == true then
			local sprite
			local invertAnim
			local overrideDir
			local overrideAnim
			if playerData.animChanged == false then
				playerData.animChanged = true
			end
			if (player.xscale > 0 and playerAc.pHspeed < 0) or (player.xscale < 0 and playerAc.pHspeed > 0) then
				invertAnim = -1
			else
				invertAnim = 1
			end
			if playerAc.free == 0 then
				if playerAc.moveRight == 1 or playerAc.moveLeft ==  1 then
					if sprite ~= shoot4_1c then
						sprite = shoot4_1c
					end
					playerData.animTimer = playerData.animTimer + 0.25 *math.abs(playerAc.pHspeed)*invertAnim
				else
					sprite = shoot4_1b
				end
			else
				sprite = shoot4_1d
			end
		if playerAc.swiftSkateboard and playerAc.swiftSkateboard > 0 then
			overrideAnim = 1
		end
		if sprite then
			graphics.drawImage{
				image = sprite,
				x = player.x,
				y = player.y,
				xscale =  player.xscale,
				yscale = player.yscale,
				subimage = playerData.animTimer,
				color = player.blendColor,
				alpha = player.alpha,
				angle = player.angle
				}
			end
		end
	end
end)