
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Bandit", "vanilla")
local path = "Variants/countess/"
local countess = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"countess", -- The name of the skin.
Sprite.load("countessSelect", path.."Select", 9, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("countessIdle", path.."Idle", 1, 13, 14),
	walk = Sprite.load("Walk_1", path.."Walk", 8, 17, 16),
	walk_2 = Sprite.load("Walk_2", path.."Walk2", 16, 12, 16),
	
},
Color.fromHex(0x3E7FC1)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.

local skinName = "countess"
callback.register("onSkinInit", function(player, skin)
	if skin == countess then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		playerData.baseSpeed = playerAc.pHmax
		playerData.moveMode = nil
	end
end)
callback.register("onPlayerStep", function(player)
	if skin == countess then 
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if playerAc.pHmax >= 2 and not playerData.moveMode then
			playerData.moveMode = true
			player:setAnimation("walk", player:getAnimation("walk_2"))
		elseif playerAc.pHmax < 2 and playerData.moveMode then 
			player:setAnimation("walk_2", player:getAnimation("walk"))
			playerData.moveMode = nil
		end
	end
end)