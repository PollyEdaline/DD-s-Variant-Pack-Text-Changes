
-- This finds the survivor we are going to make a skin of and assigns it to the survivor variable.
local survivor = Survivor.find("Seraph", "starstorm")
local path = "Variants/keeper/"
local keeper = SurvivorVariant.new(
survivor, -- The survivor object we are adding the skin to (in this case, Commando).
"Keeper", -- The name of the skin.
Sprite.load("keeperSelect", path.."Select", 9, 2, 0), -- The Selection sprite.
{
	idle = Sprite.load("keeperIdle", path.."Idle", 7, 12, 12),
	walk = Sprite.load("keeperWalk", path.."walk", 8, 11, 12),
	jump = Sprite.load("keeperJump", path.."jump", 1, 12, 12),
},
Color.fromHex(0x3E7FC1)) -- The color of the skin in the selection menu, can be left "nil" to use the survivor's default color.

local skinName = "keeper"
callback.register("onSkinInit", function(player, skin)
	if skin == keeper then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		player:set("armor", player:get("armor") +15)
		player:set("pHmax", player:get("pHmax") - 0.2)
		playerData.baseSpeed = playerAc.pHmax
		playerData.moveMode = nil
	end
end)
callback.register("onPlayerStep", function(player)
	if skin == keeper then 
		local playerAc = player:getAccessor()

	end
end)