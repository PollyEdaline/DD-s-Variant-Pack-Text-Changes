local aTweaksEnabled = false 
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Acrid", "vanilla")
local path = "Variants/Runt/"
local Runt = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Runt", -- The name of the skin.
Sprite.load("RuntSelect", path.."Select", 17, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("RuntIdle", path.."Idle", 8, 21, 14),
	walk = Sprite.load("RuntWalk", path.."walk", 8, 21, 14),
	jump = Sprite.load("RuntJump", path.."jump", 1, 10, 14),
	shoot1_1 = Sprite.load("RuntShoot1_1", path.."shoot1_1", 8, 21, 14),
	shoot1_2 = Sprite.load("RuntShoot1_2", path.."shoot1_2", 8, 21, 14),
	shoot1_3 = Sprite.load("RuntShoot1_3", path.."shoot1_3", 8, 21, 14),
	shoot2 = Sprite.load("RuntShoot2", path.."shoot2", 10, 21, 14),
	shoot3 = Sprite.load("RuntShoot3", path.."shoot3", 5, 21, 14),
	shoot4 = Sprite.load("RuntShoot4", path.."shoot4", 10, 21, 14),
	shoot5 = Sprite.load("RuntShoot5", path.."shoot5", 10, 21, 14),
	death = Sprite.load("RuntDeath", path.."Death", 15, 12, 16),
	decoy = Sprite.load("RuntDecoy", path.."Decoy", 1, 9, 18),
	climb = Sprite.load("RuntClimb", path.."Climb",2, 9, 15),
},
Color.fromHex(0xd68e5c)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.

local sprjumpDustA = Sprite.load("runtJumpDust", path.."tankJumpDustSmall", 4, 21, 21)
local sprTox = Sprite.load("runtTox", path.."toxinExplo", 5, 16, 15)
local sprTrailA = Sprite.load("runtTrail", path.."acidTrail", 4, 7, 3)
local sprTrailB = Sprite.load("runtBubble", path.."acidBubble", 6, 7, 3)
local punch1 = Sound.find("FeralShoot1")
local punch2 = Sound.find("FeralShoot2")
local punch3 = Sound.find("JanitorShoot1_2")
local sprSkills = Sprite.load("RuntSkills", path.."Skill", 5, 0, 0)

SurvivorVariant.setInfoStats(Runt, {{"Strength", 7}, {"Durability", 3}, {"Hunger", 8}, {"Mobility", 8}, {"Difficulty", 5}, {"Intelligence", 9}})
SurvivorVariant.setDescription(Runt, "The &y&Runt&!& is an agressive, mobile hunter who, despite his stunted growth has adapted for agility, with his innate &y&Seccond Jump&!&, being capable of keeping hordes in check with &y&Stalk&!& and &y&Impale&!&, and controlling the field with &y&Prince's Dominance&!&.")

SurvivorVariant.setLoadoutSkill(Runt, "Scalding Claws",
		"&y&Slice for 135% Damage.&!& Third hit &y&Scalds&!&, dealing &g&40% stacking Damage over time.&!&", sprSkills,1)
SurvivorVariant.setLoadoutSkill(Runt, "Impale",
		"Stab with tail for &y&2x140% Damage. Stunning&!&. Second hit &y&Pulls enemies Nearer.&!&", sprSkills,2)
SurvivorVariant.setLoadoutSkill(Runt, "Prince's Dominance",
		"Coat the ground for with toxins for &y&20% Damage.&!& &g&Increases ally Attack Speed&!&", sprSkills,3)
SurvivorVariant.setLoadoutSkill(Runt, 		"Stalk",
		"Dash &r&rapidly between Enemies&!& for &y&100% Damage.&!& Inflicts a &g&corrosive toxin&!& for &y&60% Damage.&!&", sprSkills,4)
		
Runt.endingQuote = "..and so it left, Heritor of a Broken World."

callback.register("postLoad", function()
	if modloader.checkMod("awesomeTweaks") then
		aTweaksEnabled = true
	end
end)



local spark = Object.find("EfSparks")

local skinName = "Runt"

local buffWyvern = Buff.new("runtBuff")
buffWyvern.sprite = Sprite.load("Runt_Buff", path.."buff", 1, 9, 9)
buffWyvern:addCallback("start", function(actor)
	actor:set("attack_speed", actor:get("attack_speed") + 0.5)
end)
buffWyvern:addCallback("end", function(actor)
	actor:set("attack_speed", actor:get("attack_speed") - 0.5)
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Runt then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		playerData.cBuff = buffWyvern
		playerData.combo = 0
		playerData.eTarget = nil
		playerData.sTarget = {}
		playerData.sBreak = 0
		playerData.combMulti = 0
		player:getData().act = 0
		playerAc.z_released = 0
		playerData.baseSpeed = playerAc.pHmax
		playerData.moveMode = nil
		playerData.doubleJumped = false
		playerData.eTarget = nil
		playerData.sTarget = {}
		playerData.sDraw1 = 0
		playerData.sDraw2 = 0
		playerData.x = player.x
		playerData.y = player.y
		playerData.sQ = 0
		playerData.act = 0
		
		player:survivorSetInitialStats(100, 12, 0.01)
		
		player:setSkill(1,
		"Scalding Claws",
		"Slice for 135% Damage. Third hit Scalds, dealing 40% Damage over time.",
		sprSkills, 1, 30)
		
		player:setSkill(2,
		"Impale",
		"Stab with tail for 2x140% Damage. Stunning. Second hit Pulls enemies Nearer.",
		sprSkills, 2, 5*60)
		
		player:setSkill(3,
		"Prince's Dominance",
		"Launch an explosive toxin that coats the ground for 20% Damage. Increases ally Attack Speed",
		sprSkills, 3, 15*60)
		
		player:setSkill(4,
		"Stalk",
		"Dash rapidly between Enemies for 100% Damage. Inflicts a corrosive toxin for 60% Damage.",
		sprSkills, 4, 10*60)
		
		
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Runt then
		player:survivorLevelUpStats(-10, 0.1, 0, 0)
	end
end)

--melt
local objAcid = Object.new("RuntAcidPuddle")  sBoom = Sound.find("Smite")

objAcid.sprite = sprTrailA
objAcid.depth = 0

objAcid:addCallback("create", function(self)--Acid puddle
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	self.subimage = math.ceil(math.random(4))
	self.mask =sprBulletMask
	self:getData().life = 60*8
	self:getData().team = "player"
	selfAc.damage = 0.20
	self:getData().acc = 0
	self.spriteSpeed = 0
	selfData.spriteSpeed = math.random(6)
	selfData.hitRateMax = 45
	selfData.hitRate = selfData.hitRateMax
	
	local en = 0
	while not self:collidesMap(self.x, self.y-4 ) and en < 800 do
		self.y = self.y +1 
		en = en + 1
	end
	
	while self:collidesMap(self.x, self.y-4) and en < 80 do
		self.y = self.y -1
		en = en + 1
	end
end)

objAcid:addCallback("step",function(self)--Acid puddle Boiling

	local selfAc = self:getAccessor()
	local selfData = self:getData()
	if selfData.life > 0 then
		selfData.life = selfData.life -1
	end
	local parent = selfData.parent
	if parent and parent:isValid() then
		selfData.spriteSpeed = selfData.spriteSpeed + 0.15
		if selfData.hitRate > 0 then
			selfData.hitRate = selfData.hitRate -(1*parent:getAccessor().attack_speed)
		else
			ParticleType.find("Heal"):burst("middle", self.x+(math.random(-7,7)), self.y, 1)
			local bullet = parent:fireExplosion(self.x, self.y-2, 0.3, 1, selfAc.damage, nil, Sprite.find("Bite1"))
			selfData.hitRate = selfData.hitRateMax
		end
		
		local aFind = ParentObject.find("actors"):findAllRectangle(self.x-7, self.y+3, self.x+7, self.y-3)
		for _, aactor in ipairs(aFind) do
			if aactor:get("team") == parent:get("team") and not isaDrone(aactor) then
				aactor:applyBuff(buffWyvern, 5)
			end
		end
	end
	if selfData.life <= 0 then
		self:destroy()
	end
end)

objAcid:addCallback("draw",function(self)
		graphics.drawImage{
		image = sprTrailB,
		x = self.x,
		y = self.y,
		xscale = self.xscale,
		subimage = self:getData().spriteSpeed,
		alpha = 1,
		}
end)

callback.register("onPlayerStep", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if SurvivorVariant.getActive(player) == Runt then
		if playerData.doubleJumped == false and playerAc.moveUp == 1 and playerAc.free == 1 then
			if 	playerAc.jump_count > 0 then jump_count = 0 end
				playerData.doubleJumped = true
				playerAc.pVspeed = -3
				local eS = spark:create(player.x,player.y-5)
				eS.sprite = sprjumpDustA
				eS.spriteSpeed = 0.2
				eS.yscale = -0.25
				eS.xscale = 0.25
		end
		
		if playerData.doubleJumped == true and playerAc.free == 0 then
			playerData.doubleJumped = false
		end
	end
end)

survivor:addCallback("scepter", function(player)--when you get the scepter
	if SurvivorVariant.getActive(player) == Runt then
		player:setSkill(4,
		"Maim",
		"Dash rapidly between Enemies for 100% Damage. Inflicts a Stacking corrosive toxin for 60% Damage.",
		sprSkills, 4, 10*60)
	end
end)

SurvivorVariant.setSkill(Runt, 1, function(player)
	player:getData().combo = 1
	local playerAc = player:getAccessor()
	local combo = player:getData().combo
	player:getData().act = 0
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.22, true, true)
	playerAc.z_released = 0
	
end)

SurvivorVariant.setSkill(Runt, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.20, true, true)
end)


SurvivorVariant.setSkill(Runt, 3, function(player)
	player:getData().resetSkillFix = true
	player:removeBuff(buff.poisonTrail)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
end)

SurvivorVariant.setSkill(Runt, 4, function(player)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.22, true, true)
	if player:get("scepter") > 0 then
		player:getData().sQ = 4+(player:get("scepter"))
	else
		player:getData().sQ = 3
	end
	player:getData().act = 0
	player:getData().sDraw1 = 1
	player:getData().sDraw2 = 0
end)

sur.Acrid:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == Runt and skill == 3 then
		if player:get("activity") ~= 3.01 then
			player:setAlarm(4, math.ceil((1 - player:get("cdr")) * (15 * 60)))
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			local index = 3
			local iindex = index + 0.01
			local sprite = Runt.animations.shoot3
			local scaleSpeed = true
			local resetHSpeed = true
			local speed = 0.25
			if playerAc.dead == 0 then
				playerAc.activity = iindex
				playerAc.activity_type = 1
				
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

sur.Acrid:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == Runt then
		if player:getData().resetSkillFix and player.subimage >= player.sprite.frames then
			player:set("activity", 0)
			player:set("activity_type", 0)
			player:getData().resetSkillFix = nil
		end
	end
end)

callback.register("preHit", function(damager,hit)
	if hit and hit:isValid() then
		local parent = damager:getParent()
		local damagerAc = damager:getAccessor()
		local hitAc = hit:getAccessor()
		
		
		if damager:getData().tag and hit:getData().var ~= damager:getData().tag then
			hit:getData().var = damager:getData().tag
			damager:getData().tag = nil
		end
		
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if SurvivorVariant.getActive(player) == Runt then
		
		if skill == 1 then
			if syncControlRelease(player, "ability1") then
				playerAc.z_released = 1
			end
			
			local combo = player:getData().combo
			if math.floor(player.subimage) == 4 and player:getData().act == 0 then
			
				if playerAc.free == 0 then
					local xs = playerAc.moveRight-playerAc.moveLeft
					
					playerAc.pHspeed = (4 * xs)
				end
				
				player:getData().act = 1
				
				if player:getData().combo < 3 then
					local punch = player:fireExplosion(player.x+(14*player.xscale), player.y+10, 1.35, 3, 1.3, nil, Sprite.find("Bite1"))
					punch1:play(0.4+math.random(0.25))
				elseif player:getData().combo == 3 then
					local bullet = player:fireExplosion(player.x+(20*player.xscale), player.y, 1.7, 0.6, 1.3, nil, Sprite.find("EfFirey"))
						DOT.addToDamager(bullet, DOT_FIRE, player:get("damage")* 0.4, 15, "runtFire", true)
					if onScreen(player) then
						misc.shakeScreen(2)
						punch2:play(1.2)
					end
				end
			elseif math.floor(player.subimage) > 4 then
				playerAc.pHspeed = 0
			end
			
			if math.floor(player.subimage) > 5 then
				player:getData().act = 0
				if math.floor(player.subimage) >= 5 and player:getData().combo <= 3 then
					player:getAccessor().activity_var1 = player:getAccessor().activity_var1+1
					if player.subimage > 7 then
						player.subimage = 7
						image_speed = 0
					end
				end
				
				if playerAc.activity_var1 > 15 or (player:getData().combo == 5 and player.subimage > 5) then
					playerAc.activity = 0
					playerAc.activity_type = 0
				elseif ((playerAc.z_skill > 0) or playerAc.force_z > 0) and player:getData().combo < 3 then
					
					if playerAc.moveRight-playerAc.moveLeft ~= 0 then
						player.xscale = playerAc.moveRight-playerAc.moveLeft
					end
					if combo == 1 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.22, true, true)
					elseif combo == 2 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_3"), 0.22, true, true)
					end
					player:getData().combo = player:getData().combo+1
					player.subimage = 1
					player:getAccessor().activity_var1 = 0
					
					if net.host then
						syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "activity", playerAc.activity)
						syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "activity_var1", activity_var1)
						syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "combo", player:getData().combo)
						syncInstanceField:sendAsHost(net.ALL, nil, player:getNetIdentity(), "subimage", player.subimage)
						syncInstanceField:sendAsHost(net.ALL, nil, player:getNetIdentity(), "sprite", player.sprite)
					else
						hostSyncInstanceVar:sendAsClient(player:getNetIdentity(), "activity", playerAc.activity)
						hostSyncInstanceVar:sendAsClient(player:getNetIdentity(), "activity_var1", 0)
						hostSyncInstanceData:sendAsClient(player:getNetIdentity(), "combo", player:getData().combo)
						hostSyncInstanceField:sendAsClient(player:getNetIdentity(), "subimage", player.subimage)
						hostSyncInstanceField:sendAsClient(player:getNetIdentity(), "sprite", player.sprite)
					end
				end	
			end
		end
		if skill == 2 then
			if relevantFrame == 4 then
				punch2:play(0.9+math.random(0.25))
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 50, 1.4, Sprite.find("Sparks11"), DAMAGER_BULLET_PIERCE)
					bullet:set("knockback", 0)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			if relevantFrame  == 8 then
				punch2:play(1.1+math.random(0.25))
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x+(24*player.xscale), player.y, 2, 0.6, 1.4, Sprite.find("EfSlash2"),Sprite.find("Sparks1") )
					bullet:set("knockback_direction",player.xscale*-1)
					bullet:set("knockback", bullet:get("knockback")+6)
					
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		if skill == 3 then
			playerAc.invincible = 30
			if relevantFrame == 3 then
				local eY = player.y
				local en = 0
				while not player:collidesMap(player.x+(5*player.xscale), eY +1 ) and en < 200 do
					eY = eY +1 
					en = en + 1
				end
				
				local bullet = player:fireExplosion(player.x+(5*player.xscale), eY, 1.5, 2, 1.6, sprTox,Sprite.find("EfFirey"))
				
				if onScreen(player) then
					punch2:play(0.6)
					misc.shakeScreen(2)
				end
				for i = -3, 3 do
					local xx = i * 14
					local fTrail = objAcid:create(player.x + xx, eY)
					fTrail:getData().parent = player
				end
				
				bullet.spriteSpeed = 0.2
				
				local n = 0
					while not player:collidesMap(player.x, player.y -1 ) and n < 27 do
						player.y = player.y - 1 
						n = n + 1
					end
					
				playerAc.pVspeed = -4
			end
		end
		if skill == 4 then
			playerAc.pVspeed = 0
			if playerData.sDraw1 > 0 then playerData.sDraw1 = playerData.sDraw1-0.05 end
			if playerData.sDraw2 > 0 then playerData.sDraw2 = playerData.sDraw2-0.05 end
			playerAc.invincible = 30
			if math.floor(player.subimage) > 5 then
				playerData.x = player.x
				playerData.y = player.y
				
				playerData.sDraw2 = 1
				
				local xx = 0
				local yy = 0
				if player:getData().act == 0 then
				player:getData().eTarget = enemyFindNearestRangeMatching(player.x-(100),player.y-60,player.x+(100),player.y+90,player.x,player.y,player,200,player.id)
					player:getData().sTarget = {x = player.x+(32*player.xscale),y = player.y}
					player:getData().act = 1
				end
					
				if math.floor(player:getData().act) == 1 then
					if (player:getData().eTarget and player:getData().eTarget:isValid()) then
						xx = player:getData().eTarget.x
						yy = player:getData().eTarget.y
					else
						xx = playerData.sTarget.x
						yy = playerData.sTarget.y
					end
				end
					
				local n = 0 
						
					local dist = distance(player.x,player.y,xx,yy)	
					while dist > 3 and n < 200 and math.floor(player:getData().act) == 1 do
						dist = distance(player.x,player.y,xx,yy)	
						local theta = math.atan2(yy - player.y,xx - player.x)
							
						local velx = math.cos(theta)
						local vely = math.sin(theta)
						if not player:collidesMap(player.x+((velx)*dist/4),player.y+((vely)*dist/4)) then
							player.x = player.x+((velx)*dist/4)
							player.y = player.y+((vely)*dist/4)
						end
						n = n+1	
					end
						
					if (dist <= 3 or playerData.sBreak <= 0) and  math.floor(player:getData().act) == 1 then
						player:getData().act = 2
					end
						
				end
						
				if math.floor(player.subimage) >= 6 and player:getData().act == 2 then

						if player:get("scepter") > 0 then
							local punch = player:fireExplosion(player.x, player.y, 0.8, 2.3, 1, Sprite.find("EfSlash2"), Sprite.find("EfPoison5"))
							punch:set("stun",0.25)	
							DOT.addToDamager(punch, DOT_CORROSION, player:get("damage")* 0.6*(player:get("scepter")+1), 15, "runtToxin", true)
							punch:getData().tag = player.id
						else
							local punch = player:fireExplosion(player.x, player.y, 0.8, 2.3, 1, Sprite.find("EfSlash2"), Sprite.find("EfPoison3"))
							punch:set("stun",0.5)	
							DOT.addToDamager(punch, DOT_CORROSION, player:get("damage")* 0.6, 15, "runtToxin", false)
							punch:getData().tag = player.id
						end
						
						player:getData().act = 3						
						player:getData().eTarget = nil
						player:getData().sTarget = nil
						player:getData().sQ = player:getData().sQ - 1
						if onScreen(player) then
							punch1:play(0.8+math.random(0.25))
							misc.shakeScreen(2)
						end
				end	
				if math.floor(player.subimage) >= 8 then
						player:getData().sDraw1 = 0
						player:getData().sDraw2 = 0
					if player:getData().sQ > 0 then
						player.subimage = 5
						player:getData().act = 0
					else
						local aFind = ParentObject.find("actors"):findAll()
						for _, aactor in ipairs(aFind) do
							if aactor:getData().var == player.id then
								aactor:getData().var = nil
							end
						end
					end
				end
			end
	end
end)

callback.register("onPlayerDraw", function(player)
	local playerData = player:getData()
	if SurvivorVariant.getActive(player) == Runt then
		if playerData.sDraw1 > 0 then
			graphics.color(Color.fromHex(0xcdffbf))
			graphics.circle(player.x, player.y, 100*playerData.sDraw1, true)
		end
		if playerData.sDraw2 > 0 then
			graphics.color(Color.fromHex(0xf39d71))
			graphics.line(playerData.x,playerData.y,player.x,player.y,3*playerData.sDraw2)
		end
	end
	
end)



