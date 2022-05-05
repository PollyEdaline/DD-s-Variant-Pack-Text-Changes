local survivor = Survivor.find("Pyro", "Starstorm")
local path = "Variants/Bard/"

local Bard = SurvivorVariant.new(
survivor,
"Bard",
Sprite.load("BardSelect", path.."Select", 16, 2, 0),
{
	idle = Sprite.load("BardIdle", path.."idle", 1, 5, 5),
	idleHalf = Sprite.load("BardIdleH", path.."idleHalf", 1, 5, 5),
	walk = Sprite.load("Bard_Walk", path.."walk", 8, 5, 5),
	walkHalf = Sprite.load("Bard_WalkH", path.."walkHalf", 8, 5, 5),
	jump = Sprite.load("Bard_Jump", path.."jump", 1, 6, 5),
	jumpHalf = Sprite.load("Bard_JumpH", path.."jumpHalf", 1, 6, 5),
	msBar = Sprite.load("Bard_Bar", path.."jamBar", 2, 14, 10),
	shoot1 = Sprite.load("BardShoot1", path.."shoot1", 7, 5, 5),
	shoot2E1 = Sprite.load("BardShootExplode1", path.."shoot2E1", 7, 26, 27),
	shoot2E2 = Sprite.load("BardShootExplode2", path.."shoot2E2", 7, 26, 27),
	shoot2E3 = Sprite.load("BardShootExplode3", path.."shoot2E3", 7, 26, 27),
	shoot2 = Sprite.load("BardShoot2", path.."shoot2_1", 5, 5, 5),
},
Color.fromHex(0x6c7977)) 

local spark = Object.find("EfSparks")
local sprSkills = Sprite.load("bard_Skills", path.."skills", 5, 0, 0)
local sBardSkill1_1 = Sound.load("BardSkill1_1", path.."Guitar1")
local sBardSkill1_2 = Sound.load("BardSkill1_2", path.."Guitar2")
local sBardSkill2 = Sound.load("BardSkill2", path.."Guitar3")
callback.register("onSkinInit", function(player, skin) 
	if skin == Bard then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		
		player:setAnimation("_walk", player:getAnimation("walk"))
		player:setAnimation("_idle", player:getAnimation("idle"))
		player:setAnimation("_jump", player:getAnimation("jump"))
		
		player:getModData("Starstorm").skin_skill1Override = true
		player:getModData("Starstorm").skin_skill2Override = true
		player:getModData("Starstorm").skin_skill3Override = true
		player:getModData("Starstorm").skin_skill4Override = true
		
		player:setSkill(2, "Supressive Fire", "Ignite at a closer range for 80% damage and high knockback. Consumes heat.",
		sprSkills, 2, 5*60)
		
		playerData.eS = 0
		playerData.ms = 0
		playerData.act = 0
		playerData.maxms = 100
		playerData.sFrames = 0
		playerData.watt = 0
		playerData.stripQ = 5
	end
end)



local function shootJam(player, range, damage, spr, ispr, index)
	local data = player:getData()
	if not player:collidesMap(player.x + 8 * player.xscale, player.y) and player:get("disable_ai") == 0 then
		local laserTurbine = player:countItem(it.LaserTurbine)
		if laserTurbine > 0 then
			player:set("turbinecharge", player:get("turbinecharge") + 0.9 * laserTurbine)
			if player:get("turbinecharge") >= 100 then
				player:set("turbinecharge", 0)
				misc.fireExplosion(player.x, player.y, 600 / 19, 20 / 4, player:get("damage") * 20, player:get("team"))
				obj.EfLaserBlast:create(player.x, player.y)
				sfx.GuardDeath:play(0.7)
			end
		end

		for i = 0, player:get("sp") do
			if data.ms > 25 then
				ParticleType.find("spark"):burst("middle", player.x, player.y, math.ceil(data.ms /50))
			end
			local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection(), range, damage * player:get("attack_speed"), ispr, DAMAGER_BULLET_PIERCE)
			bullet:set("fire", 1)
			if index == 1 and data.ms >= data.maxms * 0.7 then
				bullet:set("knockback", 1)
			elseif index == 2 then
				bullet:set("knockback", 4)
				local damagex = damage
				if data.ms >= data.maxms * 0.7 then
					damagex = damagex * 1.5
					bullet:set("damage", bullet:get("damage") * 1.5)
					bullet:set("damage_fake", bullet:get("damage_fake") * 1.8)
				end
			end
			if i ~= 0 then
				bullet:set("climb", i * 8)
			end
		end
	end
end


callback.register("onPlayerStep", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Bard then
		if playerData.ms > 0 then
			playerData.ms = math.approach(playerData.ms, 0, 0.08)
		end
		if syncControlRelease(player, "ability1") then
			playerAc.z_skill = 0
		end
		if playerAc.z_skill == 1 and playerAc.activity == 0 then
			if not playerData._scz then
				playerData._scz = player.xscale
				playerAc.pHmax = playerAc.pHmax - 0.4
				player:setAnimation("walk", player:getAnimation("walkHalf"))
				player:setAnimation("idle", player:getAnimation("idleHalf"))
				player:setAnimation("jump", player:getAnimation("jumpHalf"))
			else
				player.xscale = playerData._scz
			end
			if not sBardSkill1_1:isPlaying() and not sBardSkill1_2:isPlaying() then
				local eN = math.ceil(math.random(2))
				if eN == 1 then
					sBardSkill1_1:play(1 + math.random() * 0.005, 1)
				else
					sBardSkill1_2:play(1 + math.random() * 0.005, 1)
				end
			end
			playerData.sFrames = playerData.sFrames + (0.25 * playerAc.attack_speed)
			if playerAc.z_skill == 1 then
				playerData.ms = math.approach(playerData.ms, playerData.maxms, 0.4 * playerAc.attack_speed)
			else
				playerData.ms = math.approach(playerData.ms, 0, 0.5)
			end
		else
			if playerData._scz then
				playerData._scz = nil
				playerAc.pHmax = playerAc.pHmax + 0.4
				sBardSkill1_1:stop()
				playerData.sFrames = 0
				sBardSkill1_2:stop()
				player:setAnimation("walk", player:getAnimation("_walk"))
				player:setAnimation("idle", player:getAnimation("_idle"))
				player:setAnimation("jump", player:getAnimation("_jump"))
			end
		end
	end
end)

callback.register("onPlayerDeath", function(player)
	if SurvivorVariant.getActive(player) == Bard then
		if player:get("z_skill") == 1 then
			sBardSkill1_1:stop()
			sBardSkill1_2:stop()
		end
	end
end)

SurvivorVariant.setSkill(Bard, 1, function(player)
	shootJam(player, math.random(50, 60), 0.25, nil, nil, skill)
end)
-- Skills
survivor:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Bard then
		if playerAc.activity == 0 then
			local cd = true
			if skill == 2 then
				player:survivorActivityState(2.01, player:getAnimation("shoot2"), 0.15, true, true)
				playerAc.x_skill = 1
				playerData.act = 0
				if playerData.ms < 33 then
					 playerData.watt = 0
					 playerData.ms = 0
				elseif playerData.ms >= 33 and playerData.ms < 66 then
					 playerData.watt = 1
					 playerData.ms = playerData.ms-33
				elseif playerData.ms >= 66 then 
					 playerData.watt = 2
					 playerData.ms = playerData.ms-33
				end
			end
		end
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData= player:getData()
	
	if SurvivorVariant.getActive(player) == Bard then
		if skill == 2 then
		 	
		end
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 2.01 then
		if relevantFrame == 3 and playerData.act == 0 then
			playerData.act = 1
			local n = 0
			sBardSkill2:play(1 + ((playerData.watt-1)*0.05), 0.9)
			
			local boom = player:fireExplosion(player.x+(30*player.xscale), player.y+4, 1.5, 1.2, 1.6, nil,nil)
				misc.shakeScreen(playerData.ms/15)
			while n < 2 do
				n = n+1
				local punch = spark:create(player.x+(30*player.xscale), player.y+4)
				punch.spriteSpeed = 0.20
				if playerData.watt == 0 then
					punch.sprite = player:getAnimation("shoot2E1")
				elseif  playerData.watt == 1 then
					punch.sprite = player:getAnimation("shoot2E2")
				elseif  playerData.watt == 2 then
					boom:set("stun", 1)
					punch.sprite = player:getAnimation("shoot2E3")
				end
				
				
				local e = math.ceil(math.random(3))
				if e == 1 then 
					punch.xscale = 1 
				else
					punch.xscale = -1 
				end
					
				if n == 1 then
					
					punch.yscale = 1
				else
					punch.yscale = -1
				end
			end
		end
	end
end)


callback.register("onPlayerDraw", function(player)
	for _, player in ipairs(misc.players) do
		if SurvivorVariant.getActive(player) == Bard and player:get("dead") == 0 then
			local playerData = player:getData()
			
			if playerData.ms > 0 then
				local sub = 1
				if playerData.ms >= playerData.maxms * 0.7 then
					sub = 2
				end
				
				local yy = player.y + 11
				
				graphics.drawImage{
					image = player:getAnimation("msBar"),
					subimage = sub,
					x = player.x,
					y = yy,
				}
				
				graphics.alpha(1)
				graphics.color(Color.BLACK)
				local xx = player.x - 12 + (25 * (playerData.ms / playerData.maxms)) 
				
				local xxx = player.x + 12
				graphics.rectangle(xx, yy-2, xxx, yy + 3, false)
				
			end
			
			if player:get("z_skill") == 1 and player:get("activity") < 2 then 
			
				graphics.drawImage{
				image = player:getAnimation("shoot1"),
				x = player.x,
				y = player.y,
				xscale =  player.xscale,
				yscale = player.yscale,
				subimage = playerData.sFrames,
				}
			end
		end
	end
end)


