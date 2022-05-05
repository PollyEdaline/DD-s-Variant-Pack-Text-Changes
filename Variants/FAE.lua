local survivor = Survivor.find("Chirr", "starstorm")
local path = "Variants/Fae/"

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

pobj = setmetatable({}, { __index = function(t, k)
	return ParentObject.find(k)
end})

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

-- IsaDrone
function isaDrone(actor)
	if actor:get("name") and string.lower(actor:get("name")):find("drone") then -- lol
		return true
	else
		return false
	end
end

local FaeDust = Sprite.load("SFae_Dust", path.."fDust", 1, 18, 14)
local FaeBurst = Sprite.load("SFae_Burst", path.."faeSplosion", 6, 26, 67)
-- FaeDust
par.FaeDust = ParticleType.new("FaeDust")
par.FaeDust:sprite(FaeDust, true, true, false)
par.FaeDust:size(0.0002, 0.5, 0.005, 0.005)
par.FaeDust:life(60, 150)
par.FaeDust:direction(45, 145, 0, 1)
par.FaeDust:alpha(0.1, 0.6, 0)
par.FaeDust:angle(0, 360, 0.5, 0, true)
par.FaeDust:gravity(0.0008, 90)
par.FaeDust:color(Color.RED, Color.YELLOW,Color.BLUE)
par.FaeDust:additive(true)	
par.FaeDust:speed(0.5, 1, -0.015, -0.01)

local pExec = Sprite.load("rExe2c", path.."pExec", 10, 3, 2)
-- MarauderExplosion
par.rExec = ParticleType.new("rExecPar")
par.rExec:sprite(pExec, true, true, false)
par.rExec:life(60, 60)
par.rExec:gravity(0.0008, 90)

local sfaeSlam = Sound.load("sfaeSlam", path.."faeHeal")
local sfaeKill = Sound.load("sfaeKill", path.."faeXec")
local sfaeWindup = Sound.load("sfaeWindup", path.."faeCharge")
local sfaeDash1 = Sound.load("sfaeDash1", path.."FaeFly")
local sfaeDash2 = Sound.load("sfaeDash2", path.."faeWhoosh")
local sfaeDash3 = Sound.load("sfaeDash3", path.."faesSpin2")

local sfaeShoot1 = Sound.load("sfaeShoot", path.."faeShoot")

local actors = pobj.actors

local Fae = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Fae", -- The name of the skin.
Sprite.load("Fae", path.."Select", 18, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("FaeIdle", path.."Idle", 6, 9, 10),
	walk = Sprite.load("FaeWalk", path.."Walk", 6, 12, 10),
	jump_2 = Sprite.load("FaeJump", path.."Jump", 1, 9, 10),
	flight = Sprite.load("FaeFlight", path.."Flight", 1, 9, 10),
	wings = Sprite.load("FaeWings", path.."wings", 3, 10, 11),
	shoot1 = Sprite.load("FaeShoot1", path.."shoot1", 7, 9, 10),
	shoot2 = Sprite.load("FaeShoot2", path.."shoot2", 12, 24, 10),
	shoot3 = Sprite.load("FaeShoot3", path.."shoot3", 14, 9, 10),
	climb = Sprite.load("FaeClimb", path.."climb", 2, 5, 7),
	death = Sprite.load("FaeDie", path.."Death", 11, 23, 16),
	decoy = Sprite.load("FaeDecoy", path.."Decoy", 1, 9, 18),
},
Color.fromHex(0xE6FFEC)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.
local skinName = "F.A.E."
	SurvivorVariant.setInfoStats(Fae, {{"Strength", 3}, {"Whimsy", 8}, {"Mobility", 8}, {"Morality",3}, {"Unhinged", 9}, {"Chaos", 11}})
	SurvivorVariant.setDescription(Fae, "The &y&F.A.E.&!& Unit is a untested prototype reforestation unit. We aren't entirely sure what all it can do. It seems like it can grow plants around itself, even when it's deactivated.")
		
	Fae.endingQuote = "..and so it left, seeking new worlds to share its freedoms with."
local sprSkills = Sprite.load("FaeSkills", path.."Skill", 3, 0, 0)

	SurvivorVariant.setLoadoutSkill(Fae, "Playful Wisp",
	"Toss a bouncing flare, dealing &y&100% damage&!&. Hits the ground for &y&20% damage&!&.", sprSkills,1)
	SurvivorVariant.setLoadoutSkill(Fae, "Return to Midnight",
		"Dive forwards, dealing &y&110% damage&!&. Enemies under 30% HP turn into &g&Healing Shrubs&!& that passively heal around them." , sprSkills, 2)
	SurvivorVariant.setLoadoutSkill(Fae, "Dancing Plague",
		"Slam into the ground for &y&220% damage&!&, spreading &b&mist that confuses enemies&!&. &r&Detonates Healing Shrubs&!&, further spreading effects.", sprSkills, 3)



callback.register("onSkinInit", function(player, skin)
	if skin == Fae then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		player:getModData("Starstorm").skin_skill1Override = true
		player:getModData("Starstorm").skin_skill2Override = true
		player:getModData("Starstorm").skin_skill3Override = true
		
		player:setSkill(1,
		"Playful Wisp",
		"Toss a bouncing flare, dealing 100% damage. Hits the ground for 20% damage.",
		sprSkills, 1,  15)
		
		player:setSkill(2,
		"Return to Midnight",
		"Dive forwards, dealing 110% damage. Enemies under 30% HP turn into Healing Shrubs that passively heal around them.",
		sprSkills, 2,  10* 60)
		
		player:setSkill(3,
		"Dancing Plague",
		"Slam into the ground for 220% damage, spreading mist that confuses enemies. Detonates Healing Shrubs, further spreading effects.",
		sprSkills, 3,  7* 60)
		
		player:getData().skin_onActivity = false
		player:getData().PullToggle = false
		playerData.lock = false
		playerData.lastXscaleFix = nil
		playerData.particleFlow = 8
		playerAc.pGravity1 = 0.25
		playerAc.pGravity2 = 0.15
		playerAc.pHmax = 1
		player:getData().Spawner = 10*60
	end
end)

-- Skills

local objFlare = Object.new("FaeFlare")
local mask = Sprite.load("SFae_flareMask", path.."orbMask", 1, 3, 3)
objFlare.sprite = Sprite.load("Fae_flare", path.."faeOrb", 6, 7, 11)
local kaboom = Sprite.load("Fae_Explo", path.."faeOrbExplode", 7, 12, 11)
objFlare.depth = -4
local enemies = ParentObject.find("enemies")

objFlare:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.team = "player"
	selfData.damage = 1.2
	selfData.life = 0.1
	selfData.bounces = 2
	selfData.vSpeed = 0.15
	selfData.speed = 3
	selfData.angleSpeed = math.random(-10, 10)
	self.spriteSpeed = math.random(10, 50) * 0.01
	selfData.range = 28
	self.mask = mask
	self:getData().hitEnemies = {}
end)
objFlare:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	local enemy = enemies:findNearest(self.x, self.y)
	local parent = self:getData().parent
	
	if self:collidesMap(self.x+(selfData.speed*self.xscale), self.y) then
		selfData.speed = selfData.speed *-1
	else
		self.x = self.x + selfData.dir* selfData.speed
	end
			
	if selfData.parent and selfData.parent:isValid() then
		local xr, yr = 10 * self.xscale, 12 * self.yscale
		for _, actor in ipairs(ParentObject.find("actors"):findAllRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
			if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) and not selfData.hitEnemies[enemy] then
				if misc.getOption("video.quality") > 1 then
					ParticleType.find("spark"):burst("middle", self.x, self.y, 2)
				end
				
				selfData.hitEnemies[enemy] = true
				local parent = selfData.parent
				for i = 0, parent:get("sp") do
					local damager = parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 1, sprSparks, nil)
					damager:set("skin_newDamager", 1)
					damager:set("direction", parent:getFacingDirection())
					damager:getModData("Starstorm")._chirrTag = true
					if i ~= 0 then
						damager:set("climb", i * 8)
					end
				end
			end
		end
	end
	
	if selfData.vSpeed > 0 then
		selfData.life = selfData.life + 0.1
	end
	
	self.y = self.y + selfData.vSpeed
	
	selfData.vSpeed = selfData.vSpeed + 0.05
	
	if selfData.vSpeed < 0 and self:collidesMap(self.x, self.y - 2) then
		selfData.vSpeed = selfData.vSpeed * -0.6
		for i = 1, 20 do
			if not self:collidesMap(self.x, self.y + i + 1) then
				self.y = self.y + i
				break
			end
		end
	elseif self:collidesMap(self.x, self.y) then
		local mult = math.abs(selfData.vSpeed) * 0.15
		--print(selfData.vSpeed * selfData.damage)
		for i = 1, 20 do
			if not self:collidesMap(self.x, self.y - i + 1) then
				self.y = self.y - i
				break
			end
		end

		if selfData.parent and selfData.parent:isValid() then
			if onScreen(self) then
				Sound.find("BoarExplosion"):play(1.5,0.75)
				ParticleType.find("FireworkSmoke"):burst("middle", self.x, self.y+4, 2)
				ParticleType.find("spark"):burst("middle", self.x, self.y+4, 1)
				ParticleType.find("Heal"):burst("middle", self.x, self.y+4, 4)
			end
			local bullet = selfData.parent:fireExplosion(self.x, self.y + 3, selfData.range / 32, selfData.range / 12, mult, sprSparks3)
			bullet:getData()._chirrTag = true
		else
			local bullet = misc.fireExplosion(self.x, self.y, selfData.range / 32, selfData.range / 12, selfData.damage * mult, selfData.team, sprSparks3)
			bullet:getData()._chirrTag = true
		end
		
		selfData.bounces = selfData.bounces - 1
		selfData.vSpeed = selfData.vSpeed * -0.8
		
		selfData.angleSpeed = math.random(-10, 10)
		self.spriteSpeed = math.random(10, 50) * 0.01
	end
	
	if selfData.bounces < 0 then
		

		local bullet = selfData.parent:fireExplosion(self.x, self.y + 3, selfData.range / 32, selfData.range / 12, 0.20, sprSparks3)
			bullet:getData()._chirrTag = true
			if onScreen(self) then
				Sound.find("BossSkill2"):play(2,0.4)
				local spark = Object.find("EfSparks")
				local eS = spark:create(self.x,self.y-6)
				eS.sprite = kaboom
				eS.spriteSpeed = 0.25
				eS.yscale = 1
				ParticleType.find("spark"):burst("middle", self.x, self.y+4, 1)
				ParticleType.find("Heal"):burst("middle", self.x, self.y+4, 4)
				
				misc.shakeScreen(1.5)
			end
			self:destroy()
	end
end)

local objBush = Object.new("FaeShrub")
local sprBush = Sprite.load("Bush", path.."shrub", 1, 9, 14)
local sprBushSpawn = Sprite.load("BushSpawn", path.."shrubSpawn", 8, 9, 23)
objBush.sprite = sprBushSpawn
objBush.depth = 0



objBush:addCallback("create", function(self)--barricade spawn
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().spawned = false
	self:getData().life = 60*30
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.damage = 0.7
	self:getData().acc = 0
	self.spriteSpeed = 0.20
	self:getData().queue = 7
	self:getData().radius = 64
	self:getData().dying = false
	self:getData().detonate = false
end)

objBush:addCallback("step", function(self)--barricade Stepcode
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	local selfData = self:getData()
	local hasHit = false
	local playerAc = parent:getAccessor()
	selfData.life = selfData.life - 1
	local radius = self:getData().radius
	
	
	if self:getData().spawned == false and self.subimage > 7.5 then
		self.sprite = sprBush
		self:getData().spawned = true
	end
		local n = 0
		while not self:collidesMap(self.x, self.y+1) and n < 150 do
			self.y = self.y+1
			n = n + 1
		end
	--collision of plants
	if self:collidesMap(self.x, self.y) then
		
		
		if not self:collidesMap(self.x - 4, self.y) then
			self.x = self.x - 4
		elseif not self:collidesMap(self.x + 4, self.y) then
			self.x = self.x + 4
		end
		
	elseif not self:collidesMap(self.x, self.y + 1) then
		selfData.acc = selfData.acc + 0.1
		self.y = self.y + selfData.acc
	end
		if selfData.life % 32 == 0 and onScreen(self) then
			par.FaeDust:burst("middle", self.x, self.y, 1)
		end
		
		if selfData.life % 2 == 0 and onScreen(self) then
			ParticleType.find("Radioactive"):burst("middle", self.x-radius+math.random(radius*2), self.y-radius+math.random(radius*2), 1)
		end
		
	--particle Effects for Plants
	if self:getData().detonate == true then
		local Plague = selfData.parent:fireExplosion(self.x, self.y + 3, 5, 5, 3.2, FaeBurst)
		Plague:getData().confuse = true
		if onScreen(self) then
			local n = 0
			while n < 10 do
				par.FaeDust:burst("middle", self.x-8+math.random(16), self.y-8+math.random(16), 1)
				n = n+1
			end
			ParticleType.find("spark"):burst("middle", self.x, self.y, 5)
			local m = 0
			while m < 20 do
				ParticleType.find("Radioactive"):burst("middle", self.x-radius+math.random(radius*2), self.y-radius+math.random(radius*2), 1)
				m = m+1
			end
		end
		selfData.life = 0
		
		for _, actor in ipairs(actors:findAllEllipse(self.x - radius, self.y - radius, self.x + radius, self.y + radius)) do
			if actor:get("team") == parent:get("team") then
				if not actor:get("dead") or actor:get("dead") == 0 then 
					par.Heal:burst("above", actor.x, actor.y-5, 5, Color.DAMAGE_HEAL)
					local dif = actor:get("maxhp") - actor:get("hp")
					local heal = (actor:get("maxhp") * 0.10)
					actor:set("hp", actor:get("hp") + heal)
					if dif > 0 then
						local circle = obj.EfCircle:create(actor.x, actor.y)
						circle:set("radius", 10)
						circle:set("rate", 5)
						circle.blendColor = Color.DAMAGE_HEAL
					end
					if not isa(actor, "PlayerInstance") then
						actor:setAlarm(6, math.max(360, actor:getAlarm(6)))
					end
				end
			end
		end
	end
	
	--Healing over time
	if selfData.life % 60 == 0 then
		for _, actor in ipairs(actors:findAllEllipse(self.x - radius, self.y - radius, self.x + radius, self.y + radius)) do
			if actor:get("team") == parent:get("team") then
				if not actor:get("dead") or actor:get("dead") == 0 then 
					par.Heal:burst("above", actor.x, actor.y-5, 2, Color.DAMAGE_HEAL)
					local dif = actor:get("maxhp") - actor:get("hp")
					local heal = (actor:get("maxhp") * 0.05)
					actor:set("hp", actor:get("hp") + heal)
					if dif > 0 then
						local circle = obj.EfCircle:create(actor.x, actor.y)
						circle:set("radius", 5)
						circle:set("rate", 3)
						circle.blendColor = Color.DAMAGE_HEAL
					end
					if not isa(actor, "PlayerInstance") then
						actor:setAlarm(6, math.max(360, actor:getAlarm(6)))
					end
				end
			end
		end
	end
	--KILL	
	if selfData.life == 0 or selfData.queue <= 0 then
		self:destroy()
	end
	
end)

objBush:addCallback("draw", function(self)
	local selfData = self:getData()
	if self:getData().spawned == true then
		graphics.color(Color.DAMAGE_HEAL)
		graphics.alpha(0.08 + math.sin(selfData.life * 0.03) * 0.1)
		graphics.circle(self.x, self.y, 64, true)
	end
end)

callback.register("preHit", function(damager,hit)
	if hit and hit:isValid() then
		local parent = damager:getParent()
		local damagerAc = damager:getAccessor()
		local hitAc = hit:getAccessor()
		
		if damager:getData().Transform and parent and parent:isValid() then
			if hit:get("hp") < hit:get("maxhp")/3+damager:get("damage") then
				hit:set("hp",0)
				sfaeKill:play(1.3 + math.random() * 0.2)
				local bush = objBush:create(hit.x,hit.y)
				bush:getData().parent = parent
				for _, Bush in ipairs(objBush:findAll()) do
					if Bush:getData().parent == parent then
						Bush:getData().queue = Bush:getData().queue-1
					end
					parent:getData().Spawner = 10*60
				end
			end
		end
		
		if damager:getData().confuse then
			hit:applyBuff(Buff.find("noteam", "Starstorm"), 60*3)
		end
	end
end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == Fae then 
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		
		if syncControlRelease(player, "ability1") then
			playerData.lock = false
		end
		
		if playerData.lock == true then
			if playerData.lastXscaleFix ~= player.xscale then
				player.xscale = playerData.lastXscaleFix 
			end
		end
		if player:getData().Spawner > 0 then
		
			player:getData().Spawner = player:getData().Spawner -1
		else
			local n = 0
			local na = math.random(64)
			local nb = math.random(-64)
			

			while not player:collidesMap(player.x+n, player.y) and n < na do
				n = n + 1
			end
			
			while not player:collidesMap(player.x-n, player.y) and n > nb do
				n = n - 1
			end
			
			local ne = 0
			while not player:collidesMap(player.x+n, player.y +2+ ne) and n < 150 do
				ne = ne + 1
				n = n + 1
			end
			
			local bush = objBush:create(player.x+n,player.y+2+ne)
			bush:getData().parent = player
			for _, Bush in ipairs(objBush:findAll()) do
				if Bush:getData().parent == player then
					Bush:getData().queue = Bush:getData().queue-1
				end
			end
			player:getData().Spawner = 15*60
		end
		playerData.particleFlow = playerData.particleFlow - 1
		if playerData.particleFlow <= 0 and onScreen(player) then
			playerData.particleFlow = 8
			ParticleType.find("Radioactive"):burst("middle", player.x, player.y, 1)
		end
	end
end)

	SurvivorVariant.setSkill(Fae, 1, function(player)
		playerData = player:getData()
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.15, true, true)
		if playerData.lock == false then
			playerData.lock = true
			playerData.lastXscaleFix = player.xscale
		end
	end)
	
	SurvivorVariant.setSkill(Fae, 2, function(player)
		playerData = player:getData()
		SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.2, false, false)
		player:getData().skin_onActivity = false
		player:getAccessor().pVspeed = -2
	end)
	
	SurvivorVariant.setSkill(Fae, 3, function(player)
		playerData = player:getData()
		player:getData().skin_onActivity = false
		SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.2, true, true)
		player:getAccessor().pVspeed = -4
	end)

	callback.register("onSkinSkill", function(player, skill, relevantFrame)
		if SurvivorVariant.getActive(player) == Fae then
			local playerAc = player:getAccessor()
			if skill == 1 then
			
				local moving = false
				if player:get("free") ~= 1 then
					if playerAc.moveRight == 1 then
						playerAc.pHspeed = playerAc.pHmax/3
						moving = true
					elseif playerAc.moveLeft == 1 then
						playerAc.pHspeed = -playerAc.pHmax/3
						moving = true
					end
				end
				
				if relevantFrame == 3 then
					local slash = objFlare:create(player.x + player.xscale * 3, player.y -1)
					slash:getData().dir = player.xscale
					slash.xscale = player.xscale
					slash:getData().parent = player
					slash:getData().speed = math.abs(playerAc.pHspeed)+2
					slash:getData().team = player:get("team")
					
					if onScreen(player) then
						sfaeShoot1:play(1 + math.random() * 0.2)
					end
				end
			end
			
			if skill == 2 then
				if relevantFrame == 1 then
					if onScreen(player) then
						sfaeDash1:play(1.1 + math.random() * 0.2)
					end
				end
				
				if relevantFrame == 3 then
					if onScreen(player) then
						sfaeDash2:play(1.5 + math.random() * 0.2)
						sfaeDash3:play(1 + math.random() * 0.2)
					end
				end
				if relevantFrame > 2  and relevantFrame < 10 then
					player:getData().skin_onActivity = true
					local spin = player:fireExplosion(player.x, player.y, 9 / 19, 9 / 4, 1.1, sprSparks, nil)
					spin:set("stun", spin:get("stun") + 1.5)
					spin:set("knockback_direction",player.xscale*-1)
					spin:getData().Transform = true
					if onScreen(player) then
						ParticleType.find("Smoke5"):burst("middle", player.x, player.y+5-math.random(10), 1)
					end
				end
				if relevantFrame == 10 then
					player:getData().skin_onActivity = false 
				end
				if player:getData().skin_onActivity == true then
					playerAc.invincible = 8
					playerAc.pHspeed = playerAc.pHmax*3*player.xscale
					playerAc.pVspeed = 5
				end
			end
			
			if skill == 3 then
				
				if relevantFrame == 1 then
					if onScreen(player) then
						sfaeWindup:play(1.1 + math.random() * 0.2)
					end
				end
				if relevantFrame == 6 then
					player:getData().skin_onActivity = false
					local n = 0
					while not player:collidesMap(player.x, player.y + 2) and n < 150 do
						player.y = player.y + 2
						n = n + 1
					end
				end
				
				if relevantFrame == 7 then
					for _, Bush in ipairs(objBush:findAll()) do
						if Bush:getData().parent == player then
							Bush:getData().detonate = true
						end
					end
					local Plague = player:fireExplosion(player.x, player.y + 5, 3, 3, 2.2, FaeBurst)
					Plague:getData().confuse = true
						if onScreen(player) then
							local n = 0
							while n < 8 do
								par.FaeDust:burst("middle", player.x-8+math.random(16), player.y-8+math.random(16), 1)
								n = n+1
							end
							ParticleType.find("spark"):burst("middle", player.x, player.y, 5)
							local m = 0
							while m < 10 do
								ParticleType.find("Radioactive"):burst("middle", player.x-64+math.random(128), player.y-64+math.random(128), 1)
								m = m+1
							end
						end
					if onScreen(player) then
						misc.shakeScreen(10)
						sfaeSlam:play(1.5 + math.random() * 0.2)
					end
				end
			end
		end
	end)
