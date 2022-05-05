
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Loader", "vanilla")
local path = "Variants/monk/"
local monk = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Monk", -- The name of the skin.
Sprite.load("monkSelect", path.."Select", 9, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("monkIdle", path.."Idle", 10, 7, 8),
	walk = Sprite.load("monkWalk", path.."walk", 8, 7, 8),
	jump = Sprite.load("monkJump", path.."jump", 1, 7, 8),
	shoot11 = Sprite.load("monkShoot1_1", path.."shoot1_1", 6, 7, 8),
	shoot12 = Sprite.load("monkShoot1_2", path.."shoot1_2", 6, 7, 8),
	shoot13 = Sprite.load("monkShoot1_3", path.."shoot1_3", 6, 7, 8),
	shoot14 = Sprite.load("monkShoot1_4", path.."shoot1_4", 6, 7, 8),
	shoot15 = Sprite.load("monkShoot1_5", path.."shoot1_5", 6, 7, 8),
	shoot2 = Sprite.load("monkShoot2", path.."shoot2", 8, 11, 8),
	shoot2AI = Sprite.load("monkShoot2AfterImage", path.."shoot2AI", 8, 11, 8),
	shoot3 = Sprite.load("monkShoot3", path.."shoot3", 6, 7, 12),
	shoot3AI = Sprite.load("monkShoot3Trail", path.."shoot3AI", 6, 7, 12),
	shoot41 = Sprite.load("monkShoot4_1", path.."shoot4_1", 10, 8, 7),
	shoot42 = Sprite.load("monkShoot4_2", path.."shoot4_2", 14, 12, 8),
},
Color.fromHex(0x3E7FC1)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.
local spark = Object.find("EfSparks")
local punch1 = Sound.find("ClayShoot1")
local punch2 = Sound.find("JanitorShoot4_2")
local punch3 = Sound.find("JanitorShoot1_2")
local mantraOrb = Sprite.load("monkOrb", path.."mantraOrb", 1, 3,3)
local hShoot = Sound.find("CowboyShoot1")

local mRock = Sprite.load("sprMRock", path.."efRock", 10, 8, 3)
local mWind = Sprite.load("sprMWind", path.."efWind", 10, 8, 3)
-- MarauderExplosion
par.mRock = ParticleType.new("mantraRock")
par.mRock:sprite(mRock, true, true, false)
par.mRock:life(60, 60)
par.mRock:gravity(0.0008, 90)

local skinName = "monk"
callback.register("onSkinInit", function(player, skin)
	if skin == monk then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		playerData.combo = 0
		playerData.eTarget = nil
		playerData.sTarget = {}
		playerData.sBreak = 0
		playerData.combMulti = 0
		playerData.combMax = 2
		player:getData().act = 0
		playerData.ePass = 0
		player:getData().coDel = 90
		playerData.baseSpeed = playerAc.pHmax
		playerData.moveMode = nil
		playerData.iDur = 0
		player:getData().r = 0
		
		playerData.adc = {}
		for i = 1,3 do
			playerData.adc[i] = {x =0,y = 0, active = false, life = 0}
		end
		
		playerData.adQ = 0
		playerData.pulse = 0
	end
end)

callback.register("onPlayerStep", function(player)
	if SurvivorVariant.getActive(player) == monk then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
			
		if 	player:getData().coDel > 0 then
			player:getData().coDel = player:getData().coDel -1
		else
			if playerData.combMulti > 0 then
				playerData.combMulti =  (playerData.combMulti -0.005)/(playerData.adQ+1)
			elseif  playerData.combMulti < 0 then
				 playerData.combMulti = 0
			end
		end
		if playerData.pulse > 0 then
			playerData.pulse = playerData.pulse-0.10
		else
			playerData.pulse = 1
		end
		for i = 1,3 do
			if playerData.adc[i].active == true then
				playerData.adc[i].life = playerData.adc[i].life+1
				playerData.adc[i].x = player.x+(16*math.cos(math.rad(playerData.adc[i].life)))
				playerData.adc[i].y = player.y+(4*math.sin(math.rad(playerData.adc[i].life)))
			end
		end
	end
end)

callback.register("preHit", function(damager,hit)
	if hit and hit:isValid() then
		local parent = damager:getParent()
		local damagerAc = damager:getAccessor()
		local hitAc = hit:getAccessor()
		
		if damager:getData().scale then
			if parent:getAccessor().free == 1 then
				parent:getAccessor().pVspeed = damager:getData().bump *-1
			end
			punch3:play(1 + (parent:getData().combMulti/2),0.5)
			if parent:getData().combMulti <	parent:getData().combMax then
				parent:getData().combMulti = parent:getData().combMulti+damager:getData().scale
			end
			ParticleType.find("spark"):burst("middle", parent.x+(20*(parent.xscale)), parent.y, math.ceil(parent:getData().combMulti))
			damager:getData().scale = nil
			parent:getData().coDel = 120
		end
		if damager:getData().drone and parent:getData().adQ < 3 then
			if hit:get("hp") < hit:get("maxhp")/5+damager:get("damage") then
				parent:getData().adQ = parent:getData().adQ +1
				parent:getData().adc[parent:getData().adQ].active = true
				ParticleType.find("spark"):burst("middle", parent:getData().adc[parent:getData().adQ].x, parent:getData().adc[parent:getData().adQ].y, 3)
				damager:getData().drone = nil
				parent:getAccessor().invincible = 3030
				hit:set("hp",0)
			end
		end
		if damager:getData().shake then
			misc.shakeScreen(damager:getData().shake)
		end
		if damager:getData().bolt then
						local cShade = Color.fromHex(0xfbeba2)
						local lightning = obj.ChainLightning:create(parent.x, parent.y-10)
						lightning:set("damage", math.round(parent:getAccessor().damage * 0.10 ))
						lightning:set("bounce", damager:getData().bolt)
						lightning:set("team", parent:getAccessor().team)
						lightning:set("parent", parent.id)
						lightning:set("blend", cShade.gml)
		end
		if hit:getData().adQ and  hit:getData().adQ > 0 then
			local eS = spark:create(hit:getData().adc[hit:getData().adQ].x,hit:getData().adc[hit:getData().adQ].y)
			eS.sprite = spr.MarauderExplosion2
			eS.spriteSpeed = 0.2
			eS.yscale = -0.5
			eS.xscale = 0.5
			hit:getData().adc[hit:getData().adQ].active = false
			hit:getData().adQ = hit:getData().adQ-1
			hit:getAccessor().invincible = 3060
			damagerAc.damage = 0
		end
		
	end
end)

SurvivorVariant.setSkill(monk, 1, function(player)
	if player:get("activity") ~= 2.01 then
		if player:getData().ePass ~= 0 then
			player:getData().ePass = 0
			par.mRock:sprite(mRock, true, true, false)
			par.mRock:burst("middle", player.x, player.y-16, 1)
		end
		player:getData().combo = 2
		local combo = player:getData().combo
		player:getData().act = 0
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot11"), 0.24, true, true)
	end
end)

sur.Loader:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == monk and skill == 2 then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		playerAc.shield_dur = 0
		player:removeBuff(buff.burstSpeed2)
		Sound.find("BubbleShield"):stop()
		Sound.find("BubbleShield"):play(1.6,0.25)
		player:getData().coDel = 90
			for _, sprx in ipairs(obj.EfSparks:findAllRectangle(player.x - 6, player.y - 6, player.x + 6, player.y + 6)) do
				if sprx.sprite == spr.LoaderExplode then
					sprx:destroy()
					break
				end
			end
		if math.floor(player:get("activity")) == 1 then
			playerAc.activity_var1 = 30
			player:setAlarm(2, 1)
			player:setAlarm(3, -1)
		end
		
		if player:get("activity") ~= 2.01 and math.floor(player:get("activity")) ~= 1 then
			player:setAlarm(3, math.ceil((1 - player:get("cdr")) * (6 * 60)))	
			local index = 2
			local iindex = index + 0.01
			local sprite
			sprite = player:getAnimation("shoot2")
			local scaleSpeed = false
			local resetHSpeed = false
			local speed =  1
			player:getData().sBreak = 20
						
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

SurvivorVariant.setSkill(monk, 3, function(player)
				par.mRock:sprite(mWind, true, true, false)
			par.mRock:burst("middle", player.x, player.y-16, 1)
	player:getData().act = 0
	player:getData().ePass = 1
	player:getData().sBreak = 20
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.22, false, false)
	player:getData().eTarget = nil
end)
sur.Loader:addCallback("useSkill", function(player, skill)
	
	if SurvivorVariant.getActive(player) == monk then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		for _, obj in ipairs (obj.ConsRod:findMatching("parent", player.id)) do
			obj:destroy()
			sfx.JanitorShoot1_1:stop()
		end
		
		
		if math.floor(player:get("activity")) ~= 4 and player:getAlarm(5) <= 0 then
			player:setAlarm(5, -1)
			player:set("activity",4)

		end
		
		if player:get("activity") ~= 4.01 and math.floor(player:get("activity")) ~= 1 then
			player:setAlarm(5, math.ceil((1 - player:get("cdr")) * (6 * 60)))
			
			local index = 4
			local iindex = index + 0.01
			local sprite
			local speed = 0.25
			if player:getData().ePass == 0 then
				sprite = player:getAnimation("shoot41")
				speed = 0.20
			elseif player:getData().ePass == 1 then
				player:getData().r = math.abs(2 * player:getAccessor().attack_speed)
				sprite = player:getAnimation("shoot42")
				speed = 0.30
			end			
			
			local scaleSpeed = true
			local resetHSpeed = true
			
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
SurvivorVariant.setSkill(monk, 4, function(player)
	if player:getData().ePass == 0 then
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot41"), 0.15, true, true)
	elseif player:getData().ePass == 1 then 
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot42"), 0.30, true, true)
		player:getData().r = math.abs(2 * player:getAccessor().attack_speed)
	end
end)
sur.Loader:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == monk then
		for _, obj in ipairs (obj.ConsRod:findMatching("parent", player.id)) do
			obj:destroy()
		end
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData= player:getData()
	
	if SurvivorVariant.getActive(player) == monk then
		if skill == 1 then
		
			local combo = player:getData().combo
			if math.floor(player.subimage) == 3 and player:getData().act == 0 then
			
				if playerAc.free == 0 then
					local xs = playerAc.moveRight-playerAc.moveLeft
					
					playerAc.pHspeed = (5 * xs)
				end
				player:getData().act = 1
				local punch = player:fireExplosion(player.x+(14*player.xscale), player.y, 0.7, 2.3, 0.50+playerData.combMulti, nil, sprSparks7)
				punch:getData().scale = 0.05
				punch:getData().bump = 2
				punch:set("knockback", 0.1)
				punch:set("knockback_direction",player.xscale)
				if player:getData().combo == 6 then
					punch:getData().scale = 0.1
					misc.shakeScreen(2)
				end
				if player:getData().combo < 6 then punch1:play(1 + (player:getData().combMulti/1.2)) else punch2:play(1 + (1.3+player:getData().combMulti/1.2),0.25) end
			else
					playerAc.pHspeed = 0
			end
			
			if math.floor(player.subimage) > 3 then
				player:getData().act = 0
				if math.floor(player.subimage) >= 3 and player:getData().combo <= 5 then
					player:getAccessor().activity_var1 = player:getAccessor().activity_var1+1
					if player.subimage > 5 then
						player.subimage = 5
						image_speed = 0
					end
				end
				
				if playerAc.activity_var1 > 20 or (player:getData().combo == 5 and player.subimage > 5) then
					playerAc.activity = 0
					playerAc.activity_type = 0
				elseif ((playerAc.z_skill > 0 and playerAc.z_released > 0) or playerAc.force_z > 0) and player:getData().combo <= 5 then
					
					playerAc.z_released = 0
					
					if combo == 1 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot11"), 0.24, true, true)
					elseif combo == 2 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot12"), 0.24, true, true)
					elseif combo == 3 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot13"), 0.24, true, true)
					elseif combo == 4 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot14"), 0.24, true, true)
					elseif combo == 5 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot15"), 0.24, true, true)
					end
					player:getData().combo = player:getData().combo+1
					player.subimage = 1
					player:getAccessor().image_speed = (0.3 * playerAc.attack_speed)
					player:getAccessor().activity_var1 = 0
				end
				
			end
		end
		if skill == 2 then
			player.spriteSpeed = 0.3
			if playerData.sBreak > 0 then
				playerData.sBreak = playerData.sBreak - 1
					if playerData.sBreak%3 == 0 then
						local efTrail = Object.find("EfTrail"):create(player.x , player.y)
							efTrail.sprite = monk.animations.shoot2AI
							efTrail.subimage = player.subimage
							efTrail.depth = player.depth+1
						end
			end
			player:getAccessor().invincible = 3090
			playerAc.pHspeed = playerAc.pHmax*3*player.xscale*-1
			if player.subimage > 7 then
				 playerAc.activity = 0
                 playerAc.activity_type = 0
				 player:getData().skin_onActivity = 0
			end
		end
		if skill == 3 then
		
			local eTarget = player:getData().eTarget
			playerData.sBreak = playerData.sBreak - 1
			local xx = 0
			local yy = 0
			if math.floor(player.subimage) == 1 and player:getData().act == 0 then
				player:getData().eTarget =	enemyFindNearestRange(player.x,player.y-32,player.x+(200*player.xscale),player.y+16,player.x,player.y,player,200)
					player:getData().sTarget = {x = player.x+(50*player.xscale),y = player.y}
					player:getData().act = 1
				end
				
				if math.floor(player:getData().act) == 1 then
					if (eTarget and eTarget:isValid()) then
						xx = eTarget.x
						yy = eTarget.y
					else
						xx = playerData.sTarget.x
						yy = playerData.sTarget.y
					end
				end
				if math.floor(player.subimage) > 1 then
					
					local dist = distance(player.x,player.y,xx,yy)
					
					if dist > 8 and playerData.sBreak > 0 and math.floor(player:getData().act) == 1 then
						local theta = math.atan2(yy - player.y,xx - player.x)
						if player:getData().act == 1 then
							player:getData().act = 1.1
							playerAc.pVspeed = -2
						end
						player:getAccessor().invincible = 3060
						local vel = math.cos(theta)
						playerAc.pHspeed = (vel)*dist/6
						
						if playerData.sBreak%3 == 0 then
						local cShade = Color.fromHex(0xfcff8b)
						local efTrail = Object.find("EfTrail"):create(player.x , player.y)
							efTrail.sprite = monk.animations.shoot3AI
							efTrail.subimage = player.subimage
							efTrail.depth = player.depth+1
							efTrail:set("blend", cShade.gml)
						end
						
						if math.floor(player.subimage) >=4 then
							player.subimage = 4
						end
					end
					
					if (dist <= 8 or playerData.sBreak <= 0) and  math.floor(player:getData().act) == 1 then
						player:getData().act = 2
					end
					if math.floor(player.subimage) >= 5 and player:getData().act == 2 then
						local punch = player:fireExplosion(player.x, player.y, 0.8, 2.3, 0.50+playerData.combMulti, nil, sprSparks7)
						punch:getData().scale = 0.1
						punch:getData().bump = 3
						punch:set("stun",1)
						punch:getData().shake = 3		
						punch:getData().bolt = 2
						player:getData().act = 3						
						player:getData().eTarget = nil
						player:getData().sTarget = nil
					end
			end
		end
		if skill == 4 then
			if player:getData().ePass == 0 then
				if relevantFrame == 5 then
					local n = 0
					while not player:collidesMap(player.x+player.xscale, player.y-1) and n < 64 do
						n = n+1
						player.x = player.x+player.xscale
					end					
					local punch = player:fireExplosion(player.x-((player.xscale*n)/2), player.y, 3, 2.3, 0.50+playerData.combMulti, Sprite.find("EfSlash2"), sprSparks7)
					punch:getData().scale = 0.15
					punch:set("knockback", 3)
					punch:set("knockback_direction",player.xscale)
					punch:getData().drone = true
					punch:set("stun", 0.5)
					misc.shakeScreen(2)
					local sbBoom = Sound.find("Smite")
					sbBoom:play()
					ParticleType.find("Rubble1"):burst("middle", player.x+(8*(player.xscale)), player.y+4, math.floor(playerData.combMulti*10))
				end
				if relevantFrame == 6 then
					playerAc.pHspeed = 0
				end
				if player.subimage > 9 then
					 playerAc.activity = 0
					 playerAc.activity_type = 0
					 player:getData().skin_onActivity = 0
				end
			elseif player:getData().ePass == 1 then
					local xs = playerAc.moveRight-playerAc.moveLeft
					
					playerAc.pHspeed = ((playerAc.pHmax/2)* xs)
					player:getData().coDel = 90
					local subimg = math.floor(player.subimage)
					if (subimg >= 4 and player:getData().skin_onActivity == 0) or (subimg >= 7 and player:getData().skin_onActivity == 1) then 
						player:getData().skin_onActivity = player:getData().skin_onActivity+1
						hShoot:play(1.3 + math.random() * 0.7,0.6)
						
						local punch = player:fireExplosion(player.x, player.y-3, 1.5, 1, 0.50+playerData.combMulti, nil, sprSparks7)
						punch:getData().scale = 0.05
						punch:set("knockback", 0)
						punch:getData().bump = 3
					end
					
					if subimg >= 9 and player:getData().skin_onActivity == 2 and playerData.r > 0 then
						player.subimage = 4
						player:getData().skin_onActivity =0 
						playerData.r = playerData.r-1
					end
				if player.subimage > 13 then
					 playerAc.activity = 0
					 playerAc.activity_type = 0
					 player:getData().skin_onActivity = 0
				end
			end
		end
	end
end)

callback.register("onPlayerDrawBelow", function(player)
	if SurvivorVariant.getActive(player) == monk then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		for i = 1,3 do
			if playerData.adc[i].active == true then
				if playerData.adc[i].life % 360 > 180 and playerData.adc[i].life % 360 < 360 then
					graphics.drawImage{
					image = mantraOrb,
					x = playerData.adc[i].x,
					xscale = player.xscale,
					yscale = player.yscale,
					y = playerData.adc[i].y,
					subimage = 1,
					alpha = 1}
					graphics.color(Color.WHITE)
					graphics.line(playerData.adc[i].x,playerData.adc[i].y,player.x,player.y,(playerData.adc[i].life % 64) / 32)
				end
			end
			
		end
	end
end)

callback.register("onPlayerDraw", function(player)
	if SurvivorVariant.getActive(player) == monk then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		for i = 1,3 do
			if playerData.adc[i].active == true then
				if playerData.adc[i].life % 360 >= 0 and playerData.adc[i].life % 360 <= 180 then
					graphics.drawImage{
					image = mantraOrb,
					x = playerData.adc[i].x,
					xscale = player.xscale,
					yscale = player.yscale,
					y = playerData.adc[i].y,
					subimage = 1,
					alpha = 1}
					graphics.color(Color.WHITE)
					graphics.line(playerData.adc[i].x,playerData.adc[i].y,player.x,player.y,(playerData.adc[i].life % 64) / 32)
				end
			end
		end
		
		if playerAc.invincible > 0 then
			local cShade = Color.fromHex(0x080f0e)
			graphics.drawImage{
				image = player.sprite,
				x = player.x,
				xscale = (playerData.pulse+0.5)*player.xscale,
				yscale = (playerData.pulse+0.5)*player.yscale,
				y = player.y,
				subimage = player.subimage,
				color = cShade,
				alpha = 0.5}
		end
		if playerData.combMulti > 0.25 then
			if playerData.combMulti < playerData.combMax then
				graphics.color(Color.WHITE)
			else
				graphics.color(Color.RED)
			end
			local cStat = math.floor(playerData.combMulti*1000)/1000
			graphics.print("+"..tostring(math.floor(cStat*100)).."%", math.floor(player.x), math.floor(player.y-25),graphics.FONT_SMALL, graphics.ALIGN_MIDDLE, graphics.ALIGN_BOTTOM)
		end
	end
end)
	