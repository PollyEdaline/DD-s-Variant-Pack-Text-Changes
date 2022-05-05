-- SET UP
-- Temporary callbacks
local tcallbacks = {onStep = {}, preStep = {}, postStep = {}, onDraw = {}, onHUDDraw = {}, preHUDDraw = {}, onPlayerHUDDraw = {}, onStageEntry = {}, onPlayerStep = {}, postPlayerStep = {}, onPlayerDraw = {}, onPlayerDrawBelow = {}, onPlayerDrawAbove = {}, onFire = {}, onFireSetProcs = {}, onHit = {}, preHit = {}, onImpact = {}, onNPCDeath = {}, onNPCDeathProc = {}, onDamage = {}, onActorStep = {}}

tcallback = {}
tcallback.register = function(name, func)
	--log(name, func)
	tcallbacks[name][func] = true
end
tcallback.unregister = function(name, func)
	tcallbacks[name][func] = nil
end

callback.register("onGameEnd", function()
	for callbackName, c in pairs(tcallbacks) do
		for e, _ in pairs(c) do
			tcallbacks[callbackName][e] = nil
		end
	end
	collectgarbage("collect")
end)
callback.register("onGameStart", function() --fallback in case onGameEnd doesn't trigger
	for callbackName, c in pairs(tcallbacks) do
		for e, _ in pairs(c) do
			tcallbacks[callbackName][e] = nil
		end
	end
end)

call = {onStep = {}, postStep = {}, onDraw = {}, onHUDDraw = {}, preHUDDraw = {}, onStageEntry = {}, onPlayerStep = {}, onPlayerDraw = {}, onFire = {}, onFireSetProcs = {}, onHit = {}, preHit = {}, onImpact = {}, onNPCDeath = {}, onNPCDeathProc = {}}
callback.register("postLoad", function()
	for callbackName, element in pairs(call) do
		callback.register(callbackName, function(a1, a2, a3, a4)
			for _, callb in pairs(element) do
				callb(a1, a2, a3, a4)
			end
		end)
	end
	for callbackName, element in pairs(tcallbacks) do
		callback.register(callbackName, function(a1, a2, a3, a4, a5)
			for callb, _ in pairs(element) do
				--print(callb)
				callb(a1, a2, a3, a4, a5)
			end
		end)
	end
end)

-- Resources

ar = setmetatable({}, { __index = function(t, k)
	return Artifact.find(k)
end})

buff = setmetatable({}, { __index = function(t, k)
	return Buff.find(k)
end})

obj = setmetatable({}, { __index = function(t, k)
	return Object.find(k)
end})

it = {}
for _, item in ipairs(Item.findAll("Vanilla")) do
	it[item:getName():gsub(" ", ""):gsub("'", "")] = item
end

itp = setmetatable({}, { __index = function(t, k)
	return ItemPool.find(k)
end})

pobj = setmetatable({}, { __index = function(t, k)
	return ParentObject.find(k)
end})

par = setmetatable({}, { __index = function(t, k)
	return ParticleType.find(k)
end})

sfx = setmetatable({}, { __index = function(t, k)
	local sound = Sound.find(k)
	return sound:getRemap() or sound
end})

spr = setmetatable({}, { __index = function(t, k)
	return Sprite.find(k)
end})

stg = {}
for _, stage in ipairs(Stage.findAll("Vanilla")) do
	stg[stage:getName():gsub(" ", "")] = stage
end

sur = {}
for _, survivor in ipairs(Survivor.findAll("Vanilla")) do
	sur[survivor:getName():gsub("-", "")] = survivor
end

dif = setmetatable({}, { __index = function(t, k)
	return Difficulty.find(k)
end})

elt = setmetatable({}, { __index = function(t, k)
	return EliteType.find(k)
end})

int = {}
for _, interactable in ipairs(Interactable.findAll("Vanilla")) do
	int[interactable:getName():gsub("-", "")] = interactable
end

mcard = {}
for _, monsterCard in ipairs(MonsterCard.findAll("Vanilla")) do
	mcard[monsterCard:getName():gsub("-", "")] = monsterCard
end

mlog = {}
for _, monsterLog in ipairs(MonsterLog.findAll("Vanilla")) do
	mlog[monsterLog:getName():gsub("-", "")] = monsterLog
end

rm = {}
for _, room in ipairs(Room.findAll("Vanilla")) do
	rm[room:getName():gsub("-", "")] = room
end

