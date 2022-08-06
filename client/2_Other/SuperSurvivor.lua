require "2_Other/SuperSurvivorPresetSpawns"
require "2_Other/SuperSurvivorDebug"

---@type SuperSurvivor
SuperSurvivor = {}
SuperSurvivor.__index = SuperSurvivor

SurvivorVisionCone = 0.90

--- SPAWN ---
--- Spawns a new survivor
---@param isFemale boolean
---@param square square
---@return SuperSurvivor
function SuperSurvivor:new(isFemale,square)
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"new")

	---@type SuperSurvivor
	local o = {}	
	setmetatable(o, self)
	self.__index = self
	
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.WaitTicks = 0
	o.AtkTicks = 2
	o.TriggerHeldDown = false
	o.player = o:spawnPlayer(square, isFemale)
	o.userName = TextDrawObject.new()
	o.userName:setAllowAnyImage(true);
	o.userName:setDefaultFont(UIFont.Small);
	o.userName:setDefaultColors(255, 255, 255, 255);
	o.userName:ReadString(o.player:getForname())
	
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
	
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckDoorTicks = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.BravePoints = 0
	o.Shirt = nil
	o.Pants = nil
	o.WasOnScreen = false
	
	o.PathingCounter = 0
	o.GoFindThisCounter = 0
	o.SpokeToRecently = {}
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end
	
	o:setBravePoints(SuperSurvivorBravery)
	local Dress = "RandomBasic"
	
	if(o.player:getPerkLevel(Perks.FromString("Aiming")) >= 3) then 
		local innerresult = ZombRand(1, 6)
		if(innerresult == 1) then
			Dress = "Preset_MarinesCamo"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.M16A3")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 2) then
			Dress = "Preset_ArmyCamo"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.SCARL")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 3) then
			Dress = "Preset_Army"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.M4A1")
			else
				o:giveWeapon("Base.AssaultRifle")
			end
		elseif(innerresult == 4) then
			Dress = "Preset_Guard"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.G18")
			else
				o:giveWeapon("Base.Pistol3")
			end
		else
			Dress = "Preset_Police"
			if(isModEnabled("Brita")) then
				o:giveWeapon("Brita.G18")
			else
				o:giveWeapon("Base.Pistol3")
			end
		end
	elseif(o.player:getPerkLevel(Perks.FromString("Doctor")) >= 3) then
		Dress = "Preset_Doctor"	
	elseif(o.player:getPerkLevel(Perks.FromString("Cooking")) >= 3) then
		Dress = "Preset_Chef"		
	elseif(o.player:getPerkLevel(Perks.FromString("Farming")) >= 3) then
		Dress = "Preset_Farmer"		
	end
		
	o:SuitUp(Dress)
	
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"new")
	return o
end

--- Spawns a new survivor from a load file
---@param ID any
---@param square square
---@return SuperSurvivor
function SuperSurvivor:newLoad(ID,square)
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"newLoad")
	
	---@type SuperSurvivor
	local o = {}
	setmetatable(o, self)
	self.__index = self
		
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.WaitTicks = 0
	o.AtkTicks = 2
	o.TriggerHeldDown = false
	o.player = o:loadPlayer(square,ID)
	o.userName = TextDrawObject.new()
	o.userName:setAllowAnyImage(true);
	o.userName:setDefaultFont(UIFont.Small);
	o.userName:setDefaultColors(255, 255, 255, 255);
	o.userName:ReadString(o.player:getForname())
	
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
		
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckDoorTicks = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.BravePoints = 0
	o.Shirt = nil
	o.Pants = nil
	o.WasOnScreen = false
	
	o.GoFindThisCounter = 0
	o.PathingCounter = 0
	o.SpokeToRecently = {}
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end

	o:setBravePoints(SuperSurvivorBravery)
	
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"newLoad")
	return o
end

--- Spawns a pre-set survivor
---@param player player
---@return SuperSurvivor
function SuperSurvivor:newSet(player)
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"newSet")
	
	---@type SuperSurvivor
	local o = {}	
	setmetatable(o, self)
	self.__index = self
		
	o.AttackRange = 0.5
	o.UsingFullAuto = false
	o.DebugMode = false
	o.NumberOfBuildingsLooted = 0
	o.GroupBraveryBonus = 0
	o.GroupBraveryUpdatedTicks = 0
	o.AmmoTypes = {}
	o.AmmoBoxTypes = {}
	o.LastGunUsed = nil
	o.LastMeleUsed = nil
	o.roundChambered = nil
	o.TriggerHeldDown = false
	o.TicksSinceSpoke = 0
	o.JustSpoke = false
	o.SayLine1 = ""
	
	o.GoFindThisCounter = 0
	o.PathingCounter = 0
	o.player = player
	o.WaitTicks = 0
	o.AtkTicks = 2
	o.LastSurvivorSeen = nil
	o.LastMemberSeen = nil
	o.TicksAtLastDetectNoFood = 0
	o.NoFoodNear = false
	o.TicksAtLastDetectNoWater = 0
	o.NoWaterNear = false
	o.GroupRole = ""
	o.seenCount = 0
	o.dangerSeenCount = 0
	o.MyTaskManager = TaskManager:new(o)
	o.LastEnemeySeen = false
	o.Reducer = ZombRand(1,100)
	o.Container = false
	o.Room = false
	o.Building = false
	o.WalkingPermitted = true
	o.TargetBuilding = nil
	o.TargetSquare = nil
	o.Tree = false
	o.LastSquare = nil
	o.TicksSinceSquareChanged = 0
	o.StuckDoorTicks = 0
	o.StuckCount = 0
	o.EnemiesOnMe = 0
	o.BaseBuilding = nil
	o.SquareWalkToAttempts = {}
	o.SquaresExplored = {}
	o.SpokeToRecently = {}
	o.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do o.SquareContainerSquareLooteds[LootTypes[i]] = {} end
	
	o:setBravePoints(SuperSurvivorBravery)
	
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"newSet")
	return o
end

function SuperSurvivor:spawnPlayer(square, isFemale)
	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"spawnPlayer")
	local BuddyDesc
	if(isFemale == nil) then
		BuddyDesc = SurvivorFactory.CreateSurvivor();
	else 		
		BuddyDesc = SurvivorFactory.CreateSurvivor(nil, isFemale);
	end
	
	SurvivorFactory.randomName(BuddyDesc);
	
	local Z = 0;
	if(square:isSolidFloor()) then 
		Z = square:getZ() 
	end

	local Buddy = IsoPlayer.new(getWorld():getCell(),BuddyDesc,square:getX(),square:getY(),Z)
	logSurvivorPosition(Buddy)
	
	Buddy:setSceneCulled(false)
	Buddy:setBlockMovement(true)
	Buddy:setNPC(true);

	Buddy:getStats():setHunger((ZombRand(10)/100))
	Buddy:getStats():setThirst((ZombRand(10)/100))

	-- required perks ------------
	for i=0, 4 do
		Buddy:LevelPerk(Perks.FromString("Strength"));
	end
	for i=0, 2 do
		Buddy:LevelPerk(Perks.FromString("Sneak"));
	end
	for i=0, 3 do
		Buddy:LevelPerk(Perks.FromString("Lightfoot"));
	end
	--for i=0, 2 do
	--	Buddy:LevelPerk(Perks.FromString("Aiming")); -- counter act the fact they have to load now and fire at slower rate
	--end
	
	-- random perks -------------------
	local level = ZombRand(9,14);
	local count = 0;
	while(count < level) do
		local aperk = Perks.FromString(getAPerk())
		if(aperk ~= nil) and (tostring(aperk) ~= "MAX") then 
			Buddy:LevelPerk(aperk) 
		end
		count = count + 1;
	end
	--
	logSurvivorPerks(Buddy)

	local traits = Buddy:getTraits()
	
	Buddy:getTraits():add("Inconspicuous")
	Buddy:getTraits():add("Outdoorsman")
	Buddy:getTraits():add("LightEater")
	Buddy:getTraits():add("LowThirst")
	Buddy:getTraits():add("FastHealer")
	Buddy:getTraits():add("Graceful")
	Buddy:getTraits():add("IronGut")
	Buddy:getTraits():add("Lucky")
	Buddy:getTraits():add("KeenHearing")
	
	-- achievements mod compatibility to stop errors--------
	if(Buddy:getModData().ThingsIDropped == nil) then 
		Buddy:getModData().ThingsIDropped = {} 
	end
	if(Buddy:getModData().CheckPointCounts == nil) then 
		Buddy:getModData().CheckPointCounts = {} 
	end
	if(Buddy:getModData().KilledWithCounts == nil) then 
		Buddy:getModData().KilledWithCounts = {} 
	end	
	if(Buddy:getModData().ThingsIDid == nil) then
		Buddy:getModData().ThingsIDid = {}
	end
	if(Buddy:getModData().ThingsIAte == nil) then
		Buddy:getModData().ThingsIAte = {}
	end
	if(Buddy:getModData().ThingsICrafted == nil) then
		Buddy:getModData().ThingsICrafted = {}
	end
	-- achievements mod compatibility to stop errors--------END
	Buddy:getModData().bWalking = false
	Buddy:getModData().isHostile = false	
	Buddy:getModData().RWP = SuperSurvivorGetOptionValue("SurvivorFriendliness")
	Buddy:getModData().AIMode = "Random Solo"
	
	ISTimedActionQueue.clear(Buddy)

	local namePrefix = ""
	local namePrefixAfter = ""
	if(Buddy:getPerkLevel(Perks.FromString("Doctor")) >= 3) then 
		namePrefix = getName("DoctorPrefix_Before") 
		namePrefixAfter = getName("DoctorPrefix_After") 
	end
	if(Buddy:getPerkLevel(Perks.FromString("Aiming")) >= 5) then 
		namePrefix = getName("SD_VeteranPrefix_Before") 
		namePrefixAfter = getName("VeteranPrefix_After") 
		
	end
	if(Buddy:getPerkLevel(Perks.FromString("Farming")) >= 3) then 
		namePrefix = getName("FarmerPrefix_Before") 
		namePrefixAfter = getName("FarmerPrefix_After") 
	end
	
	local nameToSet
	if(Buddy:getModData().Name == nil) then
		if Buddy:isFemale() then
			nameToSet = getRandomName("GirlNames")	
		else
			nameToSet = getRandomName("BoyNames")			
		end		
	else
		nameToSet = Buddy:getModData().Name
	end
	nameToSet = namePrefix .. nameToSet .. namePrefixAfter
	
	Buddy:setForname(nameToSet);
	Buddy:setDisplayName(nameToSet);
	
	Buddy:getStats():setHunger((ZombRand(10)/100))
	Buddy:getStats():setThirst((ZombRand(10)/100))
	
	Buddy:getModData().Name = nameToSet
	Buddy:getModData().NameRaw = nameToSet
	
	local desc = Buddy:getDescriptor()
	desc:setForename(nameToSet)
	desc:setSurname("")

	logSurvivorValues(SurvivorDebugEnum.Spawn ,"survivor name", nameToSet)

	logSurvivorFunction(SurvivorDebugEnum.Spawn ,"spawnPlayer")
	return Buddy

end
--- END SPAWN ---

--- RESET ---
--- reset all the exploration tables
---@return void
function SuperSurvivor:resetAllTables()
	self.SpokeToRecently = {}
	self.SquaresExplored = {}
	self.resetWalkToAttempts()
	self.resetContainerSquaresLooted()
end
--- END RESET ---

--- BASIC NEEDS --- 
--- Checks if the survivor is hungry
---@return boolean
function SuperSurvivor:isHungry()
	return (self.player:getStats():getHunger() > 0.15) 	
end
--- Checks if the survivor is very hungry
---@return boolean
function SuperSurvivor:isVHungry()
	return (self.player:getStats():getHunger() > 0.40) 	
end
--- Checks if the survivor is starving
---@return boolean
function SuperSurvivor:isStarving()
	return (self.player:getStats():getHunger() > 0.75) 	
end
--- Checks if the survivor is thirsty
---@return boolean
function SuperSurvivor:isThirsty()
	return (self.player:getStats():getThirst() > 0.15) 	
end
--- Checks if the survivor is very thirsty
---@return boolean
function SuperSurvivor:isVThirsty()
	return (self.player:getStats():getThirst() > 0.40) 	
end
--- Checks if the survivor is dying of thirst
---@return boolean
function SuperSurvivor:isDyingOfThirst()
	return (self.player:getStats():getThirst() > 0.75) 	
end

--- Checks if the survivor is dead
---@return boolean
function SuperSurvivor:isDead()
	return (self.player:isDead()) 	
end

--- Gets the filth value of a survivor
---@return number returns the blood + dirty level of the survivor
function SuperSurvivor:getFilth()
	local filth = 0.0
	for i=0, BloodBodyPartType.MAX:index()-1 do
		filth = filth + self.player:getVisual():getBlood(BloodBodyPartType.FromIndex(i));
	end
	
	local inv = self.player:getInventory()
	local items = inv:getItems();
	if(items) then
		for i=1, items:size()-1 do
			local item = items:get(i)
			local bloodAmount = 0
			local dirtAmount = 0
			if instanceof(item, "Clothing") then
				if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
					local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
					for j=0, coveredParts:size()-1 do
						local thisPart = coveredParts:get(j)
						bloodAmount = bloodAmount + item:getBlood(thisPart)
					end
				end
				dirtAmount = dirtAmount + item:getDirtyness()
			elseif instanceof(item, "Weapon") then
				bloodAmount = bloodAmount + item:getBloodLevel()
			end
			filth = filth + bloodAmount + dirtAmount
		end
	end

	return filth
end

--- Gets food from a survivor's inventory or bag
---@return food returns the best food item found or nil if has nothing inside the survivor inventory
function SuperSurvivor:getFood()	
	local inv = self.player:getInventory()
	local bag = self:getBag()

	if FindAndReturnFood(inv) ~= nil then 
		return FindAndReturnBestFood(inv, nil)
	elseif (inv ~= bag) and (FindAndReturnFood(bag) ~= nil) then 
		return FindAndReturnBestFood(bag, nil)
	end

	return nil 
end
--- Checks if the survivor has food in its inventory
---@return boolean
function SuperSurvivor:hasFood()	
	return (self:getFood() ~= nil)
end

--- Gets water from a survivor's inventory or bag
---@return water returns any water item found or nil if has nothing inside the survivor inventory
function SuperSurvivor:getWater()	
	local inv = self.player:getInventory()
	local bag = self:getBag()

	if FindAndReturnWater(inv) ~= nil then 
		return FindAndReturnWater(inv)
	elseif (inv ~= bag) and (FindAndReturnWater(bag) ~= nil) then 
		return FindAndReturnWater(bag)
	end

	return nil 
end
--- Checks if the survivor has water in its inventory
---@return boolean
function SuperSurvivor:hasWater()	
	return (self:getWater() ~= nil)
end

--- Triggers the ISTakeWaterAction task
---@param waterObject worldobject
---@return void
function SuperSurvivor:DrinkFromObject(waterObject) -- TODO: move to TaskManager ? maybe?
	self:Speak(getActionText("Drinking"))
	if not waterObject:getSquare() or not luautils.walkAdj(self.player, waterObject:getSquare()) then
		return
	end
	local waterAvailable = waterObject:getWaterAmount()
	local waterNeeded = math.min(math.ceil(self.player:getStats():getThirst() * 10), 10)
	local waterConsumed = math.min(waterNeeded, waterAvailable)
	ISTimedActionQueue.add(ISTakeWaterAction:new(self.player, nil, waterConsumed, waterObject, (waterConsumed * 10) + 15));
end
--- END BASIC NEEDS ---

--- BASES ---
--- Sets the base building
---@param building building
function SuperSurvivor:setBaseBuilding(building)	
	self.BaseBuilding = building
end
--- gets the base building
---@return building
function SuperSurvivor:getBaseBuilding()	
	return self.BaseBuilding
end

--- Checks if the current survivor is inside of the group's base
---@return boolean returns true if the survivor is inside of the base
function SuperSurvivor:isInBase()
	if(self:getGroupID() == nil) then 
		return false
	else
		local group = SSGM:Get(self:getGroupID())
		if(group) then
			return group:IsInBounds(self:Get())
		end
	end
	return false
end

--- gets the center square of the group's base
---@return square returns the center square or nil if the group is nil
function SuperSurvivor:getBaseCenter()
	if(self:getGroupID() == nil) then 
		return nil
	else
		local group = SSGM:Get(self:getGroupID())
		if(group) then
			return group:getBaseCenter()
		end
	end
	return nil
end

--- Checks if the current building
---@param building building
function SuperSurvivor:isTargetBuildingClaimed(building)
	if(SafeBase) then 
		local tempsquare = getRandomBuildingSquare(building)
		if (tempsquare ~= nil) then
			local tempgroup = SSGM:GetGroupIdFromSquare(tempsquare)
			if(tempgroup ~= -1 and tempgroup ~= self:getGroupID()) then 
				return true 
			end
		end
	end

	return false
end
--- END BASES ---

--- GROUPS --- 
--- sets the group role of the survivor
---@param toValue string
---@return void
function SuperSurvivor:setGroupRole(toValue) -- todo: Maybe recieve strings like : "Job_Worker" and get it from getJobText()
	self.player:getModData().GroupRole = toValue
end

--- gets the group role of the survivor
---@return groupRole
function SuperSurvivor:getGroupRole()
	return self.player:getModData().GroupRole
end

--- gets the survivor's group id
---@return SuperSurvivorGroup returns the group id or nil if the survivor is groupless
function SuperSurvivor:getGroup()
	local gid = self:getGroupID()
	if(gid ~= nil) then 		
		return SSGM:Get(gid) 
	end
	return nil
end
--- sets the group id for the survivor
---@param toValue number
---@return void
function SuperSurvivor:setGroupID(toValue)
	self.player:getModData().Group = toValue
end
--- gets the survivor's group id
---@return number returns the group id or nil if the survivor is groupless
function SuperSurvivor:getGroupID()
	return self.player:getModData().Group
end

--- gets the bravery bonus of a survivor for being in a group every 5 ticks
--- the amount of bonus is determined by the amount of group member next to the survivor
--- this function uses update ticks (5)
---@return integer returns the bravery bonus or zero if is groupless
function SuperSurvivor:getGroupBraveryBonus()
	if(self.GroupBraveryUpdatedTicks % 5 == 0) then
		if(self:getGroupID() == nil) then 
			return 0 
		end

		local group = SSGM:Get(self:getGroupID())
		if(group) then 
			self.GroupBraveryBonus = group:getMembersThisCloseCount(12, self:Get()) 
		else 
			self.GroupBraveryBonus = 0 
		end
	else
		self.GroupBraveryUpdatedTicks = self.GroupBraveryUpdatedTicks + 1
	end

	return self.GroupBraveryBonus
end

--- checks if other survivor belongs to the current survivors group
--- TODO : change name to "isInMyGroup"
---@param thisGuy table any survivor
---@return boolean 
function SuperSurvivor:isInGroup(thisGuy) 
	if(self:getGroupID() == nil) then 
		return false
	elseif(thisGuy:getModData().Group == nil) then 
		return false
	elseif (thisGuy:getModData().Group == self:getGroupID()) then 
		return true
	else 
		return false 
	end
end
--- checks if a survivor is groupless 
---@param thisGuy any
---TODO : use a self reference
---@return boolean returns true if the survivor belongs to any group
function SuperSurvivor:isGroupless(thisGuy) 
	if(thisGuy:getModData().Group == nil) then 
		return false
	else 
		return true 
	end
end
--- ENDGROUPS --- 

--- POSITION ---
--- gets the x position
---@return integer
function SuperSurvivor:getX()
	return self.player:getX()
end
--- gets the y position
---@return integer
function SuperSurvivor:getY()
	return self.player:getY()
end
--- gets the z position
---@return integer
function SuperSurvivor:getZ()
	return self.player:getZ()
end
--- gets the current square
---@return square
function SuperSurvivor:getCurrentSquare()
	return self.player:getCurrentSquare()
end
---  END POSITION ---

--- NAME ---
--- gets the current survivor name
---@return string
function SuperSurvivor:getName()
	return self.player:getModData().Name
end
--- redraws the current survivor name
---@return void
function SuperSurvivor:refreshName()
	if(self.player:getModData().Name ~= nil) then 
		self:setName(self.player:getModData().Name) 
	end
end

--- sets and display the current survivor name
---@param nameToSet string
---@return void
function SuperSurvivor:setName(nameToSet)
	
	local desc = self.player:getDescriptor()
	desc:setForename(nameToSet)
	desc:setSurname("")	

	self.player:setForname(nameToSet);
	self.player:setDisplayName(nameToSet);

	if(self.userName) then 
		self.userName:ReadString(nameToSet) 
	end
	
	self.player:getModData().Name = nameToSet
	self.player:getModData().NameRaw = nameToSet
end
--- renders the current survivor name if SurvivorName options is enabled
---@return void
function SuperSurvivor:renderName()

		if (not self.userName) or ((not self.JustSpoke) and ((not self:isInCell()) or (self:Get():getAlpha() ~= 1.0) or getSpecificPlayer(0)==nil or (not getSpecificPlayer(0):CanSee(self.player)))) then 
			return false 
		end
		
		if(self.JustSpoke == true) and (self.TicksSinceSpoke == 0) then
			self.TicksSinceSpoke = 250	
			
			if (Option_Display_Survivor_Names == 1) then
				self.userName:ReadString(self.SayLine1)
			end			
			if (Option_Display_Survivor_Names == 2) then
				self.userName:ReadString(self.player:getForname() .."\n" .. self.SayLine1)
			end
			
		elseif(self.TicksSinceSpoke > 0) then
			self.TicksSinceSpoke = self.TicksSinceSpoke - 1
			if(self.TicksSinceSpoke == 0) then
				if (Option_Display_Survivor_Names == 1) then
					self.userName:ReadString("");
				end				
				if (Option_Display_Survivor_Names == 2) then
					self.userName:ReadString(self.player:getForname() );
				end
				self.JustSpoke = false
				self.SayLine1 = ""
			end	
		end
			
		local sx = IsoUtils.XToScreen(self:Get():getX(), self:Get():getY(), self:Get():getZ(), 0);
		local sy = IsoUtils.YToScreen(self:Get():getX(), self:Get():getY(), self:Get():getZ(), 0);
		sx = sx - IsoCamera.getOffX() - self:Get():getOffsetX();
		sy = sy - IsoCamera.getOffY() - self:Get():getOffsetY();

		sy = sy - 128

		sx = sx / getCore():getZoom(0)
		sy = sy / getCore():getZoom(0)

		sy = sy - self.userName:getHeight()

		self.userName:AddBatchedDraw(sx, sy, true)

end
--- END NAME ---

--- DIALOGUE ---
--- Sets that the survivor spoke recently with another survivor
---@param playerID any
---@return void
function SuperSurvivor:SpokeTo(playerID)
	self.SpokeToRecently[playerID] = true
end
--- checks if the survivor has recently spoke to another survivor
---@param playerID any
---@return boolean
function SuperSurvivor:getSpokeTo(playerID)
	if(self.SpokeToRecently[playerID] ~= nil) then 
		return true
	else 
		return false
	end
end

--- checks if the survivor is speaking
---@return boolean
function SuperSurvivor:isSpeaking()
	if(self.JustSpoke) or (self.player:isSpeaking()) then 
		return true
	else 
		return false 
	end
end
--- Speaks a dialogue text
---@param text string
---@return void
function SuperSurvivor:Speak(text)
	if(SpeakEnabled) then
		self.SayLine1 = text
		self.JustSpoke = true
		self.TicksSinceSpoke = 0	
	end
end

--- Speaks an action text if enabled
---@param text string
---@return void
function SuperSurvivor:RoleplaySpeak(text)
	if(SuperSurvivorGetOptionValue("RoleplayMessage") == 1) then
		if(text:match('^\*(.*)\*$')) then 
			self.SayLine1 = text
		else
			self.SayLine1 = "*".. text .. "*"
		end

		self.JustSpoke = true
		self.TicksSinceSpoke = 0	
	end
end
--- END DIALOGUE ---

--- AI ---

--- Sets the AI mode of a survivor
---@param toValue AIMode
---@return void
function SuperSurvivor:setAIMode(toValue)
	self.player:getModData().AIMode = toValue
end
--- Gets the AI mode of a survivor
---@return AIMode
function SuperSurvivor:getAIMode()
	return self.player:getModData().AIMode
end

--- Sets if the current survivor is hostile
--- Shows its name in Red if ShowHostileColor is enabled
---@param toValue boolean 
---@return void
function SuperSurvivor:setHostile(toValue)
	if (Option_Display_Hostile_Color == 2) then	
		if(toValue) then	
			self.userName:setDefaultColors(128,128, 128, 255);
			self.userName:setOutlineColors(180,0, 0,255);
		else		
			self.userName:setDefaultColors(255,255, 255, 255);
			self.userName:setOutlineColors(0,0, 0,255);	
		end
	end
	
	self.player:getModData().isHostile = toValue
	
	if(ZombRand(2) == 1) then 
		self.player:getModData().isRobber = true
	end
end

--- sets the Brave Points of a survivor
---@param toValue integer
---@return void
function SuperSurvivor:setBravePoints(toValue)
	self.player:getModData().BravePoints = toValue
end
--- gets the Brave Points of a survivor
---@return integer
function SuperSurvivor:getBravePoints()
	if(self.player:getModData().BravePoints ~= nil) then 
		return self.player:getModData().BravePoints
	else 
		return 0 
	end
end

function SuperSurvivor:getModData()
	return self.player:getModData()
end

--- gets survivor's Task Manager
---@return TaskManager
function SuperSurvivor:getTaskManager()
	return self.MyTaskManager	
end

--- gets the task that the survivor is executing
---@return any TODO: document Tasks
function SuperSurvivor:getCurrentTask()
	return self:getTaskManager():getCurrentTask()
end

--- checks if a survivor is too scared to fight
--- It depends of enemies attacking, injuries, group members near by and weapons  
---@return boolean returns true if the scary level is bigger than Brave Points
function SuperSurvivor:isTooScaredToFight()
	if (self.EnemiesOnMe >= 3) then
		return true
	elseif (self.dangerSeenCount > 0 and (self:HasMultipleInjury() or not self:hasWeapon())) then 
		return true
	else
		local base = 2
		if(self:hasWeapon() and self:hasWeapon():getMaxDamage() > 0.1) then 
			base = base + 1 
		end

		if(self:usingGun()) then 
			base = base + 2 
		end

		base = base - self.EnemiesOnMe;
		if(self:HasInjury()) then 
			base = base - 1 
		end

		base = base + self:getBravePoints() + self:getGroupBraveryBonus()
		return (self.dangerSeenCount > (base)) 
	end
end
--- END AI ---

--- MOVEMENT ---

--- gets if walking is permitted for the current survivor
---@return boolean
function SuperSurvivor:isWalkingPermitted()
	return self.WalkingPermitted
end
--- sets if walking is permitted for the current survivor
---@param toValue boolean
---@return void
function SuperSurvivor:setWalkingPermitted(toValue)
	self.WalkingPermitted = toValue
end

--- sets if the survivor is sneaking
---@param toValue boolean
---@return void
function SuperSurvivor:setSneaking(toValue)
	if self.player ~= nil then
		self.player:setSneaking(toValue)
	end
end

--- checks if the survivor is sneaking
--- todo: change to isSneaking
---@return boolean
function SuperSurvivor:getSneaking() 
	return self.player:getModData().Sneaking
end

--- sets if the survivor is running
---@param toValue boolean
---@return void
function SuperSurvivor:setRunning(toValue)
	
	 if((self.player:NPCGetRunning() ~= true) and (self.player:NPCGetRunning() ~= false)) then
		self:DebugSay("Somehow Running wasn't true OR false... It was NULL. (why?) Reference Number SR_0001_001")
		return
	 end

	if(self.player:NPCGetRunning() ~= toValue) then
		self.player:NPCSetRunning(toValue)
		--self.player:setNPC(true)
		--print("setRunning "..tostring(toValue))
		--self.player:setPathfindRunning(toValue)
		--self.player:setForceRun(toValue)
		--self.player:setRunning(toValue)
		self.player:NPCSetJustMoved(toValue)
		--self.player:getModData().Running = toValue;
		--self.player:getModData().bWalking = toValue;
	
		--self.player:setSprinting(toValue);
		--self.player:setForceSprint(toValue);
	end
	
end

--- checks if the survivor is running
---@return boolean
function SuperSurvivor:getRunning() --todo: change to isRunning
	return self.player:getModData().Running
end

--- Checks if the first or the next Task is Follow
---@return boolean returns true if the current task or the next one from TaskManager is follow
function SuperSurvivor:needToFollow()
	local Task = self:getTaskManager():getTask()
	if(Task) then 
		if(Task.Name == "Follow" and Task:needToFollow()) then 
			return true 	
		end
	end

	Task = self:getTaskManager():getThisTask(1)
	if(Task ~= nil) then 	
		if(Task.Name == "Follow" and Task:needToFollow()) then 
			return true 
		end
	end
	return false
end

--- sets the route id
---@param routeid integer
---@return void
function SuperSurvivor:setRouteID(routeid)
	self.player:getModData().RouteID = routeid
end

--- gets the route id
---@return integer
function SuperSurvivor:getRouteID()
	if(self.player:getModData().RouteID == nil) then 
		return 0
	else 
		return self.player:getModData().RouteID 
	end
end

--- calculates the speed based in fractures
---@param bodypart any
---@return integer
function SuperSurvivor:calcFractureInjurySpeed(bodypart)
	local b = 0.4;
	if (bodypart:getFractureTime() > 10.0) then
		b = 0.7;
	end
	if (bodypart:getFractureTime() > 20.0) then
		b = 1.0;
	end
	if (bodypart:getSplintFactor() > 0.0) then
		b = b - 0.2 - math.min(bodypart:getSplintFactor() / 10.0, 0.8);
	end
	return math.max(0.0, b);
end

---TODO : (START) clean speed modifiers functions code

--- calculates the body part injuries speed
--- this method is complicated (it needs some refactor)
---@param bodypart any
---@param b any
---@return number
function SuperSurvivor:calculateInjurySpeed(bodypart,b)
	local scratchSpeedModifier = bodypart:getScratchSpeedModifier();
	local cutSpeedModifier = bodypart:getCutSpeedModifier();
	local burnSpeedModifier = bodypart:getBurnSpeedModifier();
	local deepWoundSpeedModifier = bodypart:getDeepWoundSpeedModifier();
	local n = 0.0;
	if ((bodypart:getType() == "Foot_L" or bodypart:getType() == "Foot_R") and (bodypart:getBurnTime() > 5.0 or bodypart:getBiteTime() > 0.0 or bodypart:deepWounded() or bodypart:isSplint() or bodypart:getFractureTime() > 0.0 or bodypart:haveGlass())) then
		n = 1.0
		if (bodypart:bandaged()) then
			n = 0.7;
		end
		if (bodypart:getFractureTime() > 0.0) then
			n = self:calcFractureInjurySpeed(bodypart);
		end
	end
	if (bodypart:haveBullet()) then
		return 1.0;
	end
	if (bodypart:getScratchTime() > 2.0 or bodypart:getCutTime() > 5.0 or bodypart:getBurnTime() > 0.0 or bodypart:getDeepWoundTime() > 0.0 or bodypart:isSplint() or bodypart:getFractureTime() > 0.0 or bodypart:getBiteTime() > 0.0) then
		n = n + (bodypart:getScratchTime() / scratchSpeedModifier + bodypart:getCutTime() / cutSpeedModifier + bodypart:getBurnTime() / burnSpeedModifier + bodypart:getDeepWoundTime() / deepWoundSpeedModifier) + bodypart:getBiteTime() / 20.0;
		if (bodypart:bandaged()) then
			n = n / 2.0;
		end
		if (bodypart:getFractureTime() > 0.0) then
			n = self:calcFractureInjurySpeed(bodypart);
		end
	end
	if (b and bodypart:getPain() > 20.0) then
		n = n + bodypart:getPain() / 10.0;
	end
	return n;
end

--- calculates the foot injuries speed
---@return number
function SuperSurvivor:NPCgetFootInjurySpeedModifier()
	local b = true;
	local n = 0.0;
	local n2 = 0.0;
	for i = BodyPartType.UpperLeg_L:index(), (BodyPartType.MAX:index() - 1) do
		local bodydamage = self.player:getBodyDamage()
		local bodypart = bodydamage:getBodyPart(BodyPartType.FromIndex(i));
		local calculateInjurySpeed = self:calculateInjurySpeed(bodypart, false);
		if (b) then
			n = n + calculateInjurySpeed;
			b = false
		else
			n2 = n2 + calculateInjurySpeed;
			b = true
		end
	end
	if (n > n2) then
		return -(n + n2);
	else
		return n + n2;
	end
end

--- gets run speed modifier
---@return number
function SuperSurvivor:NPCgetrunSpeedModifier() 
	local NPCrunSpeedModifier = 1.0;
	local items = self.player:getWornItems()
	for i=0, items:size()-1 do
		local item = items:getItemByIndex(i)
		if item ~= nil and (item:getCategory() == "Clothing") then
			NPCrunSpeedModifier = NPCrunSpeedModifier + (item:getRunSpeedModifier() - 1.0);
		end
	end	
	local shoeitem = items:getItem("Shoes");
	if not (shoeitem) or (shoeitem:getCondition() == 0) then
		NPCrunSpeedModifier = NPCrunSpeedModifier * 0.85;
	end
	return NPCrunSpeedModifier
end

--- gets walk speed modifier
---@return number
function SuperSurvivor:NPCgetwalkSpeedModifier() 
	local NPCwalkSpeedModifier = 1.0;
	local items = self.player:getWornItems()
	local shoeitem = items:getItem("Shoes");
	if not (shoeitem) or (shoeitem:getCondition() == 0) then
		NPCwalkSpeedModifier = NPCwalkSpeedModifier * 0.85;
	end
	return NPCwalkSpeedModifier
end

--- gets run speed modifier with bag
---@return number
function SuperSurvivor:NPCcalcRunSpeedModByBag(bag)
	return (bag:getScriptItem().runSpeedModifier - 1.0) * (1.0 + bag:getContentsWeight() / bag:getEffectiveCapacity(self.player) / 2.0);
end

--- gets speed modifier
---@return number
function SuperSurvivor:NPCgetfullSpeedMod() 
	local NPCfullSpeedMod
	local NPCbagRunSpeedModifier = 0
	if (self.player:getClothingItem_Back() ~= nil) and (instanceof(self.player:getClothingItem_Back(),"InventoryContainer")) then
		NPCbagRunSpeedModifier = NPCbagRunSpeedModifier + self:NPCcalcRunSpeedModByBag(self.player:getClothingItem_Back():getItemContainer())
	end
	if (self.player:getSecondaryHandItem() ~= nil) and (instanceof(self.player:getSecondaryHandItem(),"InventoryContainer")) then
		NPCbagRunSpeedModifier = NPCbagRunSpeedModifier + self:NPCcalcRunSpeedModByBag(self.player:getSecondaryHandItem():getItemContainer());
	end
	if (self.player:getPrimaryHandItem() ~= nil) and (instanceof(self.player:getPrimaryHandItem(),"InventoryContainer")) then
		NPCbagRunSpeedModifier = NPCbagRunSpeedModifier + self:NPCcalcRunSpeedModByBag(self.player:getPrimaryHandItem():getItemContainer());
	end
	NPCfullSpeedMod = self:NPCgetrunSpeedModifier() + (NPCbagRunSpeedModifier - 1.0);
	return NPCfullSpeedMod
end

--- gets walk speed modifier
---@return number
function SuperSurvivor:NPCcalculateWalkSpeed()
	local NPCfootInjurySpeedModifier = self:NPCgetFootInjurySpeedModifier();
	self.player:setVariable("WalkInjury", NPCfootInjurySpeedModifier);
	local NPCcalculateBaseSpeed = self.player:calculateBaseSpeed();
	local wmax;
	if self:getRunning() == true then
		wmax = ((NPCcalculateBaseSpeed - 0.15) * self:NPCgetfullSpeedMod() + self.player:getPerkLevel(Perks.FromString("Sprinting")) / 20.0 - AbsoluteValue(NPCfootInjurySpeedModifier / 1.5));
	else
		wmax = NPCcalculateBaseSpeed * self:NPCgetwalkSpeedModifier();
	end
	if (self.player:getSlowFactor() > 0.0) then
		wmax = wmax * 0.05;
	end
	local wmin = math.min(1.0, wmax);
	local bodydamage = self.player:getBodyDamage()
	if (bodydamage) then 
		local thermo = bodydamage:getThermoregulator()
	end
	if (thermo) then
		wmin = wmin * thermo:getMovementModifier();
	end
	--local gametime = getGameTime()
	if (self.player:isAiming()) then
		self.player:setVariable("StrafeSpeed", math.max(math.min(0.9 + self.player:getPerkLevel(Perks.FromString("Nimble")) / 10.0, 1.5) * math.min(wmin * 2.5, 1.0), 0.6) * 0.8);
	end
	if (self.player:isInTreesNoBush()) then
		local cs = self.player:getCurrentSquare()
		if (cs) and cs:HasTree() then
			local tree = cs:getTree();
		end
		if tree then
			wmin = wmin * tree:getSlowFactor(self.player);
		end
	end
	self.player:setVariable("WalkSpeed", wmin * 0.8);
end

---TODO : (END) clean speed modifiers functions code

--- unstuck the survivor if its stuck
--- this function has too much responsbilities
---@return void
function SuperSurvivor:CheckForIfStuck() 
	local cs = self.player:getCurrentSquare()
	if(cs ~= nil) then
		if(self.LastSquare == nil) or (self.LastSquare ~= cs) then
			self.TicksSinceSquareChanged = 0
			self.LastSquare = cs
		elseif (self.LastSquare == cs) then
			self.TicksSinceSquareChanged = self.TicksSinceSquareChanged + 1
			--self:Speak(tostring(self.TicksSinceSquareChanged))
		end
	end
		
	--self.player:Say(tostring(self:isInAction()) ..",".. tostring(self.TicksSinceSquareChanged > 6) ..",".. tostring(self:inFrontOfLockedDoor()) ..",".. tostring(self:getTaskManager():getCurrentTask() ~= "Enter New Building") ..",".. tostring(self.TargetBuilding ~= nil))
	if (
		(self:inFrontOfLockedDoor()) -- this may need to be changed to the Xor blocked door?
		or
		(self:inFrontOfWindow())
	) and (
		self:getTaskManager():getCurrentTask() ~= "Enter New Building"
	) and (
		self.TargetBuilding ~= nil
	) and (
		(
			(self.TicksSinceSquareChanged > 6)
			and (self:isInAction() == false)
			and (
				self:getCurrentTask() == "None"
				or self:getCurrentTask() == "Find This"
				or self:getCurrentTask() == "Find New Building"
			)
		) or (self:getCurrentTask() == "Pursue")
	) then
		self:DebugSay("CheckForIfStuck Function Is happening!")
		self:getTaskManager():AddToTop(AttemptEntryIntoBuildingTask:new(self, self.TargetBuilding))
		self.TicksSinceSquareChanged = 0
	end
		
	if (self.TicksSinceSquareChanged > 9) and (self:isInAction() == false) and (self:inFrontOfWindow()) and (self:getCurrentTask() ~= "Enter New Building") then
		self.player:climbThroughWindow(self:inFrontOfWindow())
		self.TicksSinceSquareChanged = 0
	end
	
	if ((self.TicksSinceSquareChanged > 7) and (self:Get():getModData().bWalking == true)) or (self.TicksSinceSquareChanged > 250) then
		self.StuckCount = self.StuckCount + 1
	--elseif ((self.TicksSinceSquareChanged > 10) and (self:Get():getModData().bWalking == true)) then
		if (self.StuckCount > 100) and (self.TicksSinceSquareChanged > 250) then
			self.StuckCount = 0
			ISTimedActionQueue.add(ISGetHitFromBehindAction:new(self.player,getSpecificPlayer(0)))
	else
		local xoff = self.player:getX() + ZombRand(-3,3)
		local yoff = self.player:getY() + ZombRand(-3,3)	
		self:StopWalk()
		self:WalkToPoint(xoff,yoff,self.player:getZ())
		self:Wait(1)
		end
	end
	
end

--- increases the walk attempts to a square
---@param sq square
---@return void
function SuperSurvivor:WalkToAttempt(sq)
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareWalkToAttempts[key] == nil) then 
			self.SquareWalkToAttempts[key] = 1
		else 
			self.SquareWalkToAttempts[key] = self.SquareWalkToAttempts[key] + 1 
		end
	end
end

--- sets the walk attempts to a square
---@param sq square
---@param toThis integer
---@return void
function SuperSurvivor:setWalkToAttempt(sq,toThis)
	if(sq) then
		local key = sq:getX()..sq:getY()
		self.SquareWalkToAttempts[key] = toThis
	end
end

--- gets the walk attempts to a square
---@param sq square
---@return integer the number of walk attempts
function SuperSurvivor:getWalkToAttempt(sq)	
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareWalkToAttempts[key] == nil) then 
			return 0
		else 
			return self.SquareWalkToAttempts[key] 
		end
	end
	return 0
end
--- resets all walk attempts
---@return void
function SuperSurvivor:resetWalkToAttempts()
	self.SquareWalkToAttempts = {}
end

--- checks if the survivor is walking
---@return boolean
function SuperSurvivor:isWalking()
	local queue = ISTimedActionQueue.queues[self.player]
  if queue == nil then 
		return false 
	end

	for k=1, #queue.queue do
		local v = queue.queue[k]
    if v then 
			return true 
		end
  end
	
	return false;
end

--- Walks to a square
---@deprecated try WalkToDirect instead
---@param square square
---@return void
function SuperSurvivor:walkTo(square)
	if(square == nil) then 
		return 
	end
	--ISTimedActionQueue.add(ISWalkToTimedAction:new (self.player, square))
	--self:setRunning(true)
	--self.player:StopAllActionQueue()
	
	local parent
	if(instanceof(square,"IsoObject")) then 
		parent = square:getSquare() 
	else 
		parent = square 
	end
	
	self.TargetSquare = square
	if(square:getRoom() ~= nil) and (square:getRoom():getBuilding() ~= nil) then 
		self.TargetBuilding = square:getRoom():getBuilding() 
	end
	
	local adjacent = AdjacentFreeTileFinder.Find(parent, self.player);
	if instanceof(square, "IsoWindow") or instanceof(square, "IsoDoor") then
		adjacent = AdjacentFreeTileFinder.FindWindowOrDoor(parent, square, self.player);
	end
	if adjacent ~= nil then
		local door = self:inFrontOfDoor()
		if (door ~= nil) and (door:isLocked() or door:isLockedByKey() or door:isBarricaded()) and (not door:isDestroyed()) then
			local building = door:getOppositeSquare():getBuilding()
				self:DebugSay("little pig, little pig")
				self:NPC_ManageLockedDoors() -- This function will be sure ^ doesn't make the npc stuck in these cases
		end
		if (self.StuckDoorTicks < 7) then
			self:WalkToAttempt(square)
			self:WalkToPoint(adjacent:getX(),adjacent:getY(),adjacent:getZ())
		end
	end
	--]]
end

--- walks to a position
---@param x integer
---@param y integer
---@param z integer
---@return void
function SuperSurvivor:walkTowards(x,y,z)
	local towardsSquare = getTowardsSquare(self:Get(),x,y,z)
	if(towardsSquare == nil) then 
		return 
	end
	self:WalkToPoint(towardsSquare:getX(),towardsSquare:getY(),towardsSquare:getZ())
end

--- walks torwards a square dealing with doors and multiple attempts
---@param square square
---@return void
function SuperSurvivor:walkToDirect(square)
	if(square == nil) then 
		return 
	end
	
	self:NPC_ManageLockedDoors() -- If things get too weird with npc pathing at doors, remove this line
	
	self:WalkToAttempt(square)
	self:WalkToPoint(square:getX(),square:getY(),square:getZ())
end

--- walks to a position using pathfinding
--- its better for avoid iso objects and walls
---@param tx integer
---@param ty integer
---@param tz integer
---@return void
function SuperSurvivor:WalkToPoint(tx, ty, tz) 
	if(not self.player:getPathFindBehavior2():isTargetLocation(tx,ty,tz)) then
      self.player:getModData().bWalking = true
      self.player:setPath2(nil);
      self.player:getPathFindBehavior2():pathToLocation(tx,ty,tz);
  end     
end

--- stops if the walks to is not possible
---@param tx integer
---@param ty integer
---@param tz integer
---@return void
function SuperSurvivor:WalkToUpdate()
	if(self.player:getModData().bWalking) then
		local myBehaviorResult = self.player:getPathFindBehavior2():update() 
		if((myBehaviorResult == BehaviorResult.Failed) or (myBehaviorResult == BehaviorResult.Succeeded)) then  
			self:StopWalk()
		elseif (myBehaviorResult ~= BehaviorResult.Working) then
			-- do nothing
		end
 end
end
--- This is the attempt to make the NPCs less likely to freeze in place. 
--- its not using certain commands that StopWalk is using.
---@deprecated is not being used. Remove it later
---@return void
function SuperSurvivor:iStopMovement()
	self.player:setPath2(nil)
	self.player:getModData().bWalking = false
	self.player:getModData().Running = false
	self:setRunning(false)
	self.player:setSneaking(false)		
	self.player:NPCSetJustMoved(false)
	self.player:NPCSetAttack(false)
	self.player:NPCSetMelee(false)
	self.player:NPCSetAiming(false)	
end

--- clear all timed actions and clear all actions 
--- todo: create a new function (stopAttack)
---@return void
function SuperSurvivor:StopWalk()
	ISTimedActionQueue.clear(self.player)
	self.player:StopAllActionQueue()
	self.player:setPath2(nil)
	self.player:getModData().bWalking = false
	self.player:getModData().Running = false
	self:setRunning(false)
	self.player:setSneaking(false)	
	--self.player:clearVariables()
	--self.player:setMoving(false)
	--self.player:NPCSetRunning(false)
	self.player:NPCSetJustMoved(false)
	self.player:NPCSetAttack(false)
	self.player:NPCSetMelee(false)
	self.player:NPCSetAiming(false)
	--self.player:setPerformingAnAction(false)
	--self.player:setVariable("bPathfind", false)	
	--self.player:setVariable("bKnockedDown", false)	
	--self.player:setVariable("AttackAnim", false)
	--self.player:setVariable("BumpFall", false)

	--self.player:setVariable("IsPerformingAnAction", this::isPerformingAnAction, this::setPerformingAnAction);
end

-- TODO : remove "NPC_" from function names

--- Deals with locked doors 
--- A bit on how this function works
--- This function was made because I noticed there's alot of cases the NPCs will just stand in front of a door and loop between tasks or refuses to add a task, or just gets stuck, period.
--- So as a result, this function can be inserted in movement codes, to watch out for doors.
--- Don't add more tasks to this function, Wander task is the only one that turns the NPC around and walks away. 
---@return void
function SuperSurvivor:NPC_ManageLockedDoors()
	-- Prevent your follers from listening to this rule. Temp solution for now.
	if (self:getGroupRole() == "Companion") then 
		self.StuckDoorTicks = 0 
	end
	
	if ((self:inFrontOfLockedDoorAndIsOutside() == true) or (self:NPC_IFOD_BarricadedInside() == true) or (self:inFrontOfBarricadedWindowAlt() )) then
		self.StuckDoorTicks = self.StuckDoorTicks + 1
	
		-- Once the timer strikes 11
		if (self.StuckDoorTicks > 5) then
			self:getTaskManager():AddToTop(WanderTask:new(self))
			self:DebugSay("NPC_ManageLockedDoors Function triggered!")

			-- Double failsafe - For being outside, npc should try to go inside
			if (self.player:isOutside()) then
				self:NPC_ForceFindNearestBuilding()	
				self:getTaskManager():AddToTop(AttemptEntryIntoBuildingTask:new(self, self.TargetBuilding))
			end
			
			-- timer will continue going up within an emergency
			if (self.StuckDoorTicks > 11) then
				if (self:getGroupRole() == "Random Solo") then -- Not a player's base allie
					self:getTaskManager():clear()
					self:getTaskManager():AddToTop(WanderTask:new(self))
					self:getTaskManager():AddToTop(FindUnlootedBuildingTask:new(self))
					self:getTaskManager():AddToTop(WanderTask:new(self))
					self:DebugSay("NPC_ManageLockedDoors - NPC refused to leave door, trying more measure!")	
				end				
				if (self.StuckDoorTicks > 15) then
					if (self.player:getModData().isHostile == true) then -- Not a player's base allie
						self.lastenemyseen = nil
						self:getTaskManager():clear()
						self:getTaskManager():AddToTop(FleeTask:new(self))
						self:getTaskManager():AddToTop(FleeFromHereTask:new(self, self:Get():getCurrentSquare()))
						self:DebugSay("NPC_ManageLockedDoors - THAT'S IT, NPC refuses to list, enforcing drastic measures!")
						self.StuckDoorTicks = 0	
					end
					if (self.player:getModData().isHostile == false) then -- Not a player's base allie
						self:getTaskManager():clear()
						self:getTaskManager():AddToTop(FleeTask:new(self))
						self:getTaskManager():AddToTop(FleeFromHereTask:new(self, self:Get():getCurrentSquare()))
						self:getTaskManager():AddToTop(WanderTask:new(self))
						self:DebugSay("NPC_ManageLockedDoors - THAT'S IT, NPC refuses to list, enforcing drastic measures!")
						self.StuckDoorTicks = 0	
					end
				end
			end
			
		end
	else
		self.StuckDoorTicks = 0 -- This will set to 0 if not near the door in general
	end
end

--- manage with locked doors from outside
---@deprecated Older attempts : use NPC_ManageLockedDoors
---@return void
function SuperSurvivor:ManageOutdoorStuck()
	-- TODO : remove these lines to test
	if (self:NPC_TaskCheck_EnterLeaveBuilding()) and (self:inFrontOfLockedDoor()) and (self.player:isOutside() == true) and (self:getTaskManager():getCurrentTask() ~= "Wander") then
		self.TicksSinceSquareChanged = self.TicksSinceSquareChanged + 1

		if (self.TicksSinceSquareChanged > 10) then
			self:getTaskManager():AddToTop(WanderTask:new(self))
			--self:getTaskManager():AddToTop(AttemptEntryIntoBuildingTask:new(self, self.TargetBuilding))
			--self:getTaskManager():AddToTop(WanderTask:new(self))
			--self:getTaskManager():AddToTop(FleeFromHereTask:new(self, self:Get():getCurrentSquare()))
			--self:getTaskManager():AddToTop(WanderTask:new(self))
			--self:getTaskManager():AddToTop(FleeFromHereTask:new(self, self:Get():getCurrentSquare()))
			--self:getTaskManager():AddToTop(WanderTask:new(self))
			self:DebugSay("This is when I changed my tasks to wander - Reference number ZA - 0003")
			self.TicksSinceSquareChanged = 0
		end		
	else
		self.TicksSinceSquareChanged = 0
	end	

end

--- manage with locked doors from inside
---@deprecated Older attempts : use NPC_ManageLockedDoors
---@return void
function SuperSurvivor:ManageIndoorStuck()
	if (self:inFrontOfLockedDoor()) and (not self.player:isOutside()) and (self:getTaskManager():getCurrentTask() ~= "Wander") then
	self.TicksSinceSquareChanged = self.TicksSinceSquareChanged + 1
	
		if (self.TicksSinceSquareChanged > 10) then
			self:StopWalk()
			self:getTaskManager():clear()
			self:getTaskManager():AddToTop(WanderTask:new(self))
			self:DebugSay("This is when I changed my tasks to wander - Reference number ZA - 0002 (StopWalk Also Triggered)")
			self.TicksSinceSquareChanged = 0
		end
	else
		self.TicksSinceSquareChanged = 0
	end

end

--- This function watches over if they're too close to a target or the main player and forces walk if they are.
--- That way they don't trip over each other (and more importantly the main player)
--- This function is used mainly in the combat related tasks, but could be used elsewhere if the npc is running over the main player often.
--- This literally implies it will check top to bottom priority. I'm writing this to remind myself for the future.
---@return void
function SuperSurvivor:NPC_ShouldRunOrWalk()
	-- instanceof(self.player:getCell():getObjectList(),"IsoPlayer") < - hold this for now 

	if (self.LastEnemeySeen ~= nil) then
		local distance = getDistanceBetween(self.player,self.LastEnemeySeen)
		local distanceAlt = getDistanceBetween(self.player,getSpecificPlayer(0))	-- To prevent running into the player
		local zNPC_AttackRange = self:isEnemyInRange(self.LastEnemeySeen)

		
		if(self:Task_IsFleeOrFleeFromSpot()) or (distanceAlt <= 1) or (distance and self:Task_IsAttack()) or (distance and self:Task_IsThreaten() or (distance and self:Task_IsPursue()) ) then
			self:setRunning(false)
			self:NPCDebugPrint("NPC_ShouldRunOrWalk set running to false due to distance and Task_IsFleeOrFleeFromSpot returned true SRW_0001")
		else
			self:setRunning(true)
			self:NPCDebugPrint("NPC_ShouldRunOrWalk set running to true due to not distance and Task_IsFleeOrFleeFromSpot returned false SRW_0002")
		end
	else
		self:NPCDebugPrint("LastEnemySeen returned Nil so, setting NPC to run Reference Number SRW_0003")
		self:setRunning(false)
	end
end

--- walks next to the main player 
--- TODO: change name to WalkNearMainPlayer
---@return void
function SuperSurvivor:NPC_EnforceWalkNearMainPlayer()
	-- Emergency failsafe to prevent NPCs from running into player
	if (getDistanceBetween(self.player,getSpecificPlayer(0)) < 1) then
		self:setRunning(false)
	end
end

--- runs next to the main player 
--- ERW stands for 'EnforceRunWalk'
---@param VarDist integer the distance of the player
---@return void
function SuperSurvivor:NPC_ERW_AroundMainPlayer(VarDist)
		-- Emergency failsafe to prevent NPCs from running into player
		if (getDistanceBetween(self.player,getSpecificPlayer(0)) > VarDist) then
			if (self:isInAction() == true) then
				self:setRunning(true)
			end
		else
			if (self:isInAction() == false) then
				self:setRunning(false)
			end
		end
end

--- runs next to the main player 
--- ERW stands for 'EnforceRunWalk' walk priority
---@param VarDist integer the distance of the player
---@return void
function SuperSurvivor:NPC_ERW_AroundMainPlayerReverse(VarDist)
		-- Emergency failsafe to prevent NPCs from running into player
		if (getDistanceBetween(self.player,getSpecificPlayer(0)) > VarDist) then
			if (self:isInAction() == true) then
				self:setRunning(false)
			end
		else
			if (self:isInAction() == true) then
				self:setRunning(true)
			end
		end
end

--- Manages movement and movement speed
---@return void
function SuperSurvivor:NPC_MovementManagement_Guns()
	if (self:isWalkingPermitted()) and (self:hasGun()) then
		local cs = self.LastEnemeySeen:getCurrentSquare()
		local distance = getDistanceBetween(self.player,self.LastEnemeySeen)
		local RealDistance = getDistanceBetween(self.player,self.LastEnemeySeen)
		local minrange = self:getMinWeaponRange()
		local zNPC_AttackRange = self:isEnemyInRange(self.LastEnemeySeen)

		if (not zNPC_AttackRange) then
			-- The actual walking itself
			if(instanceof(self.LastEnemeySeen,"IsoPlayer")) then
				self:walkToDirect(cs)
			else
				local fs = cs:getTileInDirection(self.LastEnemeySeen:getDir())
				if(fs) and (fs:isFree(true)) then
					self:walkToDirect(fs)
					self:DebugSay("AtkTicks NPC_MovementManagement Walkto FS")
				else 
					self:walkToDirect(cs) 
					self:DebugSay("AtkTicks NPC_MovementManagement Walkto CS")
				end	
			end
		end
	end
end

--- Manages movement and movement for AttackTask. 
---@return void
function SuperSurvivor:NPC_MovementManagement()
	if (self:isWalkingPermitted()) and (not self:hasGun()) then
		local cs = self.LastEnemeySeen:getCurrentSquare()
		local distance = getDistanceBetween(self.player,self.LastEnemeySeen)
		local RealDistance = getDistanceBetween(self.player,self.LastEnemeySeen)
		local minrange = self:getMinWeaponRange()
		local zNPC_AttackRange = self:isEnemyInRange(self.LastEnemeySeen)

		if (distance > minrange + 0.1) then
			-- The actual walking itself
			if(instanceof(self.LastEnemeySeen,"IsoPlayer")) then	
				self:walkToDirect(cs)
				self:setRunning(true)
				
			else
				local fs = cs:getTileInDirection(self.LastEnemeySeen:getDir())
				if(fs) and (fs:isFree(true)) then
					self:walkToDirect(fs)
					self:DebugSay("AtkTicks NPC_MovementManagement Walkto FS")
					self:setRunning(true)
				else 
					self:walkToDirect(cs) 
					self:DebugSay("AtkTicks NPC_MovementManagement Walkto CS")
					self:setRunning(true)
				end	
			end
		end
		
	end
end
--- END MOVEMENT ---

--- INVENTORY ---

--- gets the first equipped bag of the survivor
--- current priority is : back clothing > secondary hand > primary hand > inventory (although the survivors don't care about the hand items)
---@return inventory
function SuperSurvivor:getBag()
	local backItem = self.player:getClothingItem_Back()
	if(backItem ~= nil) and (instanceof(backItem,"InventoryContainer")) then 
		return backItem:getItemContainer() 
	end

	local secondaryItem = self.player:getSecondaryHandItem()
	if(secondaryItem ~= nil) and (instanceof(secondaryItem,"InventoryContainer")) then 
		return secondaryItem:getItemContainer() 
	end

	local primaryItem = self.player:getPrimaryHandItem()
	if(primaryItem ~= nil) and (instanceof(primaryItem,"InventoryContainer")) then 
		return seprimaryItem:getItemContainer() 
	end
	
	return self.player:getInventory()
end

--- gets an item from inside of a bag 
---@deprecated not tested yet. 
---@param inventory inventory
---@param item string
---@return item
function SuperSurvivor:getBagItem(inventory, item)
	if(inventory ~= nil) and (inventory:getCategory() == "Container") then 
		return inventory:getItemContainer():FindAndReturn(item); 
	end

	return nil
end

--- gets an item from inside of a bag 
---@deprecated not tested yet.
---@param inventory inventory
---@param item lootType
---@return item
function SuperSurvivor:getBagItemByCategory(inventory, category)
	---check if condition to self.player:getInventory() value
	if(inventory ~= nil) and (inventory:getCategory() == "Container") then 
		return inventory:getItemContainer():FindAndReturnCategory(category); 
	end

	return nil
end

--- gets an item from survivor's inventory
--- current priority is : back clothing > secondary hand > primary hand > inventory
---@param thisType string
---@return item
function SuperSurvivor:FindAndReturn(thisType)
	local item = self.player:getInventory():FindAndReturn(thisType);
	
	local secondaryHandItem = self.player:getSecondaryHandItem()
	if(not item) and (secondaryHandItem ~= nil) and (secondaryHandItem:getCategory() == "Container") then 
		item = secondaryHandItem:getItemContainer():FindAndReturn(thisType); 
	end

	local clothingItem = self.player:getClothingItem_Back()
	if(not secondaryHandItem) and (clothingItem ~= nil) then 
		item = clothingItem:getItemContainer():FindAndReturn(thisType); 
	end
			
	return item
end

--- returns an item from survivor inventory by category
---@deprecated not tested yet.
---@return item returns any item from 
function SuperSurvivor:FindAndReturnByCategory(category)
	--TODO : add getBagItemByCategory 
	local inventory = self.player:getInventory()
	local item = nil

	if(inventory ~= nil) then
		item = inventory:FindAndReturnCategory(category)
		if(item ~= nil) then 
			return item
		end
	end
	
	local back = self.player:getClothingItem_Back()
	if(back ~= nil) and (instanceof(back,"InventoryContainer")) then
		item = back:getItemContainer():FindAndReturnCategory(category)
		if(item ~= nil) then 
			return item
		end
	end

	local secondary = self.player:getSecondaryHandItem()
	if(secondary ~= nil) and (instanceof(secondary,"InventoryContainer")) then 
		item = secondary:getItemContainer():FindAndReturnCategory(category) 
		if(item ~= nil) then 
			return item
		end
	end
	
	return nil
end

--- gets any weapon from survivor's inventory
---@return weapon
function SuperSurvivor:getWeapon()
	--TODO : add call for FindAndReturnByCategory
	local inventory = self.player:getInventory()
	if(inventory ~= nil) and (inventory:FindAndReturnCategory("Weapon")) then 
		return inventory:FindAndReturnCategory("Weapon") 
	end
	
	local back = self.player:getClothingItem_Back()
	if(back ~= nil) and (instanceof(back,"InventoryContainer")) and (back:getItemContainer():FindAndReturnCategory("Weapon")) then 
		return back:getItemContainer():FindAndReturnCategory("Weapon") 
	end
	local secondary = self.player:getSecondaryHandItem()
	if(secondary ~= nil) and (instanceof(secondary,"InventoryContainer")) and (secondary:getItemContainer():FindAndReturnCategory("Weapon")) then 
		return secondary:getItemContainer():FindAndReturnCategory("Weapon") 
	end
	
	return nil
end

--- checks if there is any space inside survivor's inventory
---@return boolean
function SuperSurvivor:hasRoomInBag()
	local playerBag = self:getBag()
	
	return playerBag:getCapacityWeight() >= (playerBag:getMaxWeight() * 0.9)
end

--- checks if there is any space inside survivor's inventory for the item
---@param item item
function SuperSurvivor:hasRoomInBagFor(item)
	local playerBag = self:getBag()
	
	if(playerBag:getCapacityWeight() + item:getWeight() >= (playerBag:getMaxWeight() * 0.9)) then 
		return false
	else 
		return true 
	end
end

--- Returns the amount of an item of type that the survivor holds
---@param thisType lootType
---@return integer The amount of an item inside the survivors inventory and bag
function SuperSurvivor:FindAndReturnCount(thisType)
	if(thisType == nil) then 
		return 0 
	end
	
	local count = 0
	count = count + self.player:getInventory():getItemsFromType(thisType):size()

	local secondary = self.player:getSecondaryHandItem()
	if(secondary ~= nil) and (secondary:getCategory() == "Container") then 
		count = count + secondary:getItemContainer():getItemsFromType(thisType):size() 
	end

	local back = self.player:getClothingItem_Back()
	if(back ~= nil) then 
		count = count + back:getItemContainer():getItemsFromType(thisType):size() 
	end
			
	return count
end
--- END INVENTORY ---

--- LOOTING ---

--- gets the number of looted buildings
---@return number the current number of looted buildings
function SuperSurvivor:getBuildingsLooted()	
	return self.NumberOfBuildingsLooted
end
--- increases the number of looted buildings by 1
---@return void
function SuperSurvivor:BuildingLooted()	
	self.NumberOfBuildingsLooted = self.NumberOfBuildingsLooted + 1
end

--- Checks if the survivor checked for food near by
---@return boolean returns true if there is food near by and last time checked is recent
function SuperSurvivor:getNoFoodNearBy()
	if (self.NoFoodNear == true) then
		if (self.TicksAtLastDetectNoFood ~= nil)and ((self.Reducer - self.TicksAtLastDetectNoFood) > 12000)then 
			self.NoFoodNear = false 
			logSurvivorLog(SurvivorDebugEnum.Looting, "no food nearby survivor", tostring(self:getID()))
		end
	end
	return self.NoFoodNear
end
--- Sets that there is or not food near by the survivor
---@param toThis boolean 
---@return void
function SuperSurvivor:setNoFoodNearBy(toThis)
	if(toThis == true) then
		self.TicksAtLastDetectNoFood = self.Reducer
	end
	
	self.NoFoodNear = toThis
end

--- Checks if the survivor checked for water near by
---@return boolean returns true if there is water near by and last time checked is recent
function SuperSurvivor:getNoWaterNearBy()
	if (self.NoWaterNear == true) then
		if (self.TicksAtLastDetectNoWater ~= nil)
			and (
				(self.Reducer < self.TicksAtLastDetectNoWater)or 
				((self.Reducer - self.TicksAtLastDetectNoWater) > 12900)
			) then 
				self.NoWaterNear = false 
				logSurvivorLog(SurvivorDebugEnum.Looting, "no water nearby survivor", tostring(self:getID()))
			end
	end
	return self.NoWaterNear
end
--- Sets that there is or not water near by the survivor
---@param toThis boolean 
---@return void
function SuperSurvivor:setNoWaterNearBy(toThis)
	if(toThis == true) then
		self.TicksAtLastDetectNoWater = self.Reducer
	end
	self.NoWaterNear = toThis
end
--- adds a looted square with a category item
---@param sq square
---@param Category lootType 
---@return void
function SuperSurvivor:addContainerSquareLooted(sq,category)
	if(sq) then
		local key = sq:getX()..sq:getY()
		if(self.SquareContainerSquareLooteds[category][key] == nil) then 
			self.SquareContainerSquareLooteds[category][key] = 1
		else 
			self.SquareContainerSquareLooteds[category][key] = self.SquareContainerSquareLooteds[category][key] + 1 
		end
	end
end

--- sets a looted square to a value
---@param sq square
---@param toThis integer 
---@param category lootType
---@return void
function SuperSurvivor:setContainerSquareLooted(sq,toThis,category)
	if(sq) then
		local key = sq:getX()..sq:getY()
		self.SquareContainerSquareLooteds[category][key] = toThis
	end
end
--- Gets the amount of items of a category in a square 
---@param sq square square to be searched
---@param category lootType the name of the selected category
---@return integer the amount of items of the selected category
function SuperSurvivor:getContainerSquareLooted(sq,category)	
	local level = SurvivorDebugEnum.Looting
	logSurvivorFunction(level, "getContainerSquareLooted")
	logSurvivorValues(level, "category", category)

	if(sq) then
		local key = sq:getX()..sq:getY()
		logSurvivorValues(level, "key", key)

		if(self.SquareContainerSquareLooteds[category][key] == nil) then 
			return 0
		else 
			return self.SquareContainerSquareLooteds[category][key] 
		end
	end
	
	logSurvivorLog(level, "empty square")
	logSurvivorFunction(level,"getContainerSquareLooted")
	return 0
end

--- New function: To allow the exact position of the NPC to mark spot. This could be useful for preventing NPCs from walking to blocked off doors they witnessed
--- It needs work though, because right now it will more than likely mark off the whole building.
--- IFOD stands for 'In front of door' but it will also check for barricaded windows too.
---@deprecated this functions is not being used. will be removed soon
---@param building building
---@return void
function SuperSurvivor:MarkCurrentSquareExplored_IFOD(building)
	if (not self:inFrontOfLockedDoor()) or (not self:inFrontOfBarricadedWindowAlt()) then 
		return false 
	end
	self:resetBuildingWalkToAttempts(building)
	local bdef = building:getDef()	
	for x=bdef:getX()-1,(bdef:getX() + bdef:getW()+1) do	
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH()+1) do
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:Explore(sq)
			end			
		end							
	end
end
--- Marks a building as explored
---@param building building
---@return void
function SuperSurvivor:MarkBuildingExplored(building)
	if(not building) then 
		return 
	end
	self:resetBuildingWalkToAttempts(building)
	local bdef = building:getDef()	
	
	local xdef = bdef:getX()
	local ydef = bdef:getY()

	for x=xdef-1,(xdef + bdef:getW()+1) do	
		for y=ydef-1,(ydef + bdef:getH()+1) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:Explore(sq)
			end			
		end							
	end
end

--- Checks it the current building was explored
---@param building building
---@return boolean returns true if the building was explored
function SuperSurvivor:getBuildingExplored(building)
	if self:isTargetBuildingClaimed(building) then 
		return true 
	end

	local sq = getRandomBuildingSquare(building)		
	if(sq) then 
		return self:getExplore(sq) > 0
	end			
	
	return false
end

--- Checks if the current building is unlooted
---@return boolean returns true if the survivor is inside a buidling and was not explored
function SuperSurvivor:inUnLootedBuilding()
	if(self.player:isOutside()) then 
		return false 
	end
	
	local sq = self.player:getCurrentSquare()

	if(sq) then
		local room = sq:getRoom()
		if(room) then
			local building = room:getBuilding()
			return (building) and (self:getBuildingExplored(building) == false)
		end
	end
	
	return false
end
--- 
---@param building any
---@return boolean returns true if the 
function SuperSurvivor:AttemptedLootBuilding(building)
	if(not building) then 
		return false 
	end
		
	local buildingSquareRoom = building:getRandomRoom()
	if not buildingSquareRoom then 
		return false 
	end
	
	local buildingSquare = buildingSquareRoom:getRandomFreeSquare()
	if not buildingSquare then 
		return false 
	end

	return self:getWalkToAttempt(buildingSquare) >= 8;	
end

--- Searches for the closests square outside a building by searching in a range of 20 squares
---@param thisBuildingSquare any
---@return any returns the closest and outside square or the current square if is out of the range of searching (20)
function SuperSurvivor:FindClosestOutsideSquare(thisBuildingSquare)

	if(thisBuildingSquare == nil) then 
		return nil 
	end 
	
	local bx=thisBuildingSquare:getX()
	local by=thisBuildingSquare:getY()
	local px=self.player:getX()
	local py=self.player:getY()
	local xdiff = AbsoluteValue(bx-px)
	local ydiff = AbsoluteValue(by-py)
	
	if(xdiff > ydiff) then
		if(px > bx) then
			for i=1,20 do
				local sq = getCell():getGridSquare(bx + i, by, 0)
				if(sq ~= nil and sq:isOutside()) then 
					return sq 
				end
			end
		else
			for i=1,20 do
				local sq = getCell():getGridSquare(bx - i, by, 0)
				if(sq ~= nil and sq:isOutside()) then 
					return sq 
				end
			end
		end
	else 
		if(py > by) then
			for i=1,20 do
				local sq = getCell():getGridSquare(bx, by + i, 0)
				if(sq ~= nil and sq:isOutside()) then 
					return sq 
				end
			end
		else
			for i=1,20 do
				local sq = getCell():getGridSquare(bx, by - i, 0)
				if(sq ~= nil and sq:isOutside()) then 
					return sq 
				end
			end
		end
	end

	return thisBuildingSquare
end

--- resets the looted squares  
---@return void
function SuperSurvivor:resetContainerSquaresLooted()
	self.SquareContainerSquareLooteds = {}
	for i=1, #LootTypes do self.SquareContainerSquareLooteds[LootTypes[i]] = {} end
end
--- END LOOTING ---

--- COMBAT ---

--- checks if the survivor is using a firearm
---@return boolean
function SuperSurvivor:usingGun()
	local handItem = self.player:getPrimaryHandItem()

	return (handItem ~= nil) and (instanceof(handItem,"HandWeapon")) and (handItem:isAimedFirearm())
end

--- checks if the survivor is enemy from self
---@param character any
---@return boolean
function SuperSurvivor:isEnemy(character)
	local group = self:getGroup()
	if(group) then
		return group:isEnemy(self,character)
	else
		local modData = self.player:getModData()
		-- zombie is enemy to anyone
		if character:isZombie() then 
			return true 
		elseif (self:isInGroup(character)) then 
			return false
		elseif (modData.isHostile ~= true and modData.surender == true) then 
			return false -- so other npcs dont attack anyone surendering
		elseif (modData.hitByCharacter == true) and (character:getModData().semiHostile == true) then 
			return true 
		elseif (character:getModData().isHostile ~= modData.isHostile) then 
			return true
		else 
			return false
		end 
	end

end

--- checks if the survivor is using a weapon
---@return boolean
function SuperSurvivor:hasWeapon()
	if(self.player:getPrimaryHandItem() ~= nil) and (instanceof(self.player:getPrimaryHandItem(),"HandWeapon")) then
		return self.player:getPrimaryHandItem() 
	else
		return false
	end
end

--- checks if the survivor is using a firearm
---@deprecated it does the same as usingGun()
---@return boolean
function SuperSurvivor:hasGun()
	local primaryWeapon = self.player:getPrimaryHandItem()
	return (primaryWeapon ~= nil) and (instanceof(primaryWeapon,"HandWeapon")) and (primaryWeapon:isAimedFirearm())
end

--- sets if the survivor needs ammo
---@param toValue boolean
---@return void
function SuperSurvivor:setNeedAmmo(toValue)
	self.player:getModData().NeedAmmo = toValue
end

--- checks if the survivor needs ammo
---@return boolean
function SuperSurvivor:getNeedAmmo()
	if(self.player:getModData().NeedAmmo ~= nil) then
		return self.player:getModData().NeedAmmo
	end

	return false
end

--- checks if the survivor is inside the range of an attack 
---@param enemy any
---@return boolean
function SuperSurvivor:isEnemyInRange(enemy)
	if not enemy then 
		return false 
	end
	
	local result = self.player:IsAttackRange(enemy:getX(),enemy:getY(),enemy:getZ())
	
	return result
end

--- checks if something is in the same room of the survivor 
---@param movingObj any
---@return boolean
function SuperSurvivor:isInSameRoom(movingObj)
	if not movingObj then 
		return false 
	end
	local objSquare = movingObj:getCurrentSquare()
	if (not objSquare) then 
		return false 
	end

	local selfSquare = self.player:getCurrentSquare()
	if (not selfSquare) then 
		return false 
	end

	if(selfSquare:getRoom() == objSquare:getRoom()) then 
		return true
	end

	return false 
end 

--- checks if the survivor is in the same room of the last seen enemy
---@return boolean
function SuperSurvivor:isInSameRoomWithEnemy()
	return self:isInSameRoom(self.LastEnemeySeen)
end  

--- checks if something is in the same building of the survivor
---@param movingObj any
---@return boolean
function SuperSurvivor:isInSameBuilding(movingObj)
	if not movingObj then 
		return false 
	end

	local objSquare = movingObj:getCurrentSquare()
	if (not objSquare) then 
		return false 
	end

	local selfSquare = self.player:getCurrentSquare()
	if (not selfSquare) then 
		return false 
	end

	if(selfSquare:getRoom() ~= nil and objSquare:getRoom() ~= nil) then 
		return (selfSquare:getRoom():getBuilding() == objSquare:getRoom():getBuilding())
	end

	if(selfSquare:getRoom() == objSquare:getRoom()) then
		return true 
	end
	
	return false 
end
--- An easiser function to make InBuildingWithEntity returns
---@return boolean
function SuperSurvivor:isInSameBuildingWithEnemy()
	return self:isInSameBuilding(self.LastEnemeySeen)
end		

--- gets the current range of attack
---@return number
function SuperSurvivor:getAttackRange()	 
	return self.AttackRange 
end

--- checks if the enemy is outside
---@return boolean
function SuperSurvivor:enemyIsOutside()
	if (self.LastEnemeySeen ~= nil) then
		return self.LastEnemeySeen:isOutside()
	end

	return false
end

-- checks if the enemy has a gun
---@return boolean
function SuperSurvivor:EnemyHasGun()
	
	if (self.LastEnemeySeen ~= nil) then
		local EnemyIsSurvivor = (instanceof(self.LastEnemeySeen,"IsoPlayer"))
		local EnemySuperSurvivor = nil
		local LastSuperSurvivor = nil
		local EnemyIsSurvivorHasGun = false -- this is the one you want to have set true
		local LastSurvivorHasGun = false
		
		if(EnemyIsSurvivor) then 
			local id = self.LastEnemeySeen:getModData().ID
			
			EnemySuperSurvivor = SSM:Get(id) 
			if(EnemySuperSurvivor) then
				EnemyIsSurvivorHasGun = EnemySuperSurvivor:hasGun()
				return true
			end
		end
		if(self.LastSurvivorSeen) then 
			local lsid = self.LastSurvivorSeen:getModData().ID
			
			LastSuperSurvivor = SSM:Get(lsid) 
			if(LastSuperSurvivor) then
				LastSurvivorHasGun = LastSuperSurvivor:hasGun()
			end
		end
	else
		return false
	end
end

-- checks if the enemy is human
---@return boolean
function SuperSurvivor:isEnemyHuman()
	return instanceof(self.LastEnemeySeen,"IsoPlayer")
end

--- unjam/reaload and rack a weapon
--- TODO: this function can be turned in a task (and it have a lot of responsabilities)
---@param weapon any
function SuperSurvivor:ReadyGun(weapon)
	--self:DoZombieEntityScan()
	
	local readyGun_AntiStuck_Ticks = 0

	if(not weapon) or (not weapon:isAimedFirearm()) or readyGun_AntiStuck_Ticks >= 5 then 
		return true 
	end
	
	if weapon:isJammed() then
		weapon:setJammed(false)
		readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 5
	end	
	
	self:DebugSay("readygun ( weapon:getCurrentAmmoCount() = " .. weapon:getCurrentAmmoCount() .. ") (weapon:getMaxAmmo() = " .. weapon:getMaxAmmo() .. ") (self.EnemiesOnMe = " .. self.EnemiesOnMe .. ")  (self.seenCount =" .. self.seenCount..")")
	
	if weapon:haveChamber() and not weapon:isRoundChambered() then
		readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
		if(ISReloadWeaponAction.canRack(weapon)) then
			ISReloadWeaponAction.OnPressRackButton(self.player, weapon)
			self:DebugSay(self:getName().." needs to rack gun")
			readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
			return true		
		end	
	end
		
	if(weapon:getMagazineType()) then
		
		if(weapon:isContainsClip() == false) then
			self:DebugSay(self:getName().." gun needs a magazine0:"..tostring(weapon:getMagazineType()))
			local magazine = weapon:getBestMagazine(self.player)
			if(magazine == nil) then magazine = self.player:getInventory():getFirstTypeRecurse(weapon:getMagazineType()) end
			if(magazine == nil) and (SurvivorInfiniteAmmo) then 
				self:DebugSay(self:getName().." needs to spawn magazine1:" .. tostring(weapon:getMagazineType()))
				magazine = self.player:getInventory():AddItem(weapon:getMagazineType()); 
			end
			
			if magazine then
				readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
				
				local ammotype = magazine:getAmmoType();
				if (not self.player:getInventory():containsWithModule(ammotype)) and (magazine:getCurrentAmmoCount()==0) and (SurvivorInfiniteAmmo) then
					readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 5
					magazine:setCurrentAmmoCount(magazine:getMaxAmmo())
				end
				
				self:DebugSay(self:getName().." trying to load magazine into gun - readyGun_AntiStuck_Ticks = "..tostring(readyGun_AntiStuck_Ticks))
				if readyGun_AntiStuck_Ticks > 0 and readyGun_AntiStuck_Ticks < 15 then
					ISTimedActionQueue.add(ISInsertMagazine:new(self.player, weapon, magazine))
					ISReloadWeaponAction.ReloadBestMagazine(self.player, weapon)
					readyGun_AntiStuck_Ticks = 0
				end

				return	true		
			else
				self:DebugSay(self:getName().." error trying to spawn mag for gun?")
			end			
		end
		
		
		if weapon:isContainsClip() then
			readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
			
			local magazine = weapon:getBestMagazine(self.player)
			if(magazine == nil) then 
				magazine = self.player:getInventory():getFirstTypeRecurse(weapon:getMagazineType()) 
			end
			if(magazine == nil) and (SurvivorInfiniteAmmo) then 
				self:DebugSay(self:getName().." needs to spawn magazine2:" .. tostring(weapon:getMagazineType()))
				magazine = self.player:getInventory():AddItem(weapon:getMagazineType()); 
			end
			local currentAmmo = self:getInventoryAmmoCount(weapon)
			if(currentAmmo < 1) and (SurvivorInfiniteAmmo) then
				
				local maxammo = magazine:getMaxAmmo()
				local amtype = magazine:getAmmoType()
				self:DebugSay(self:getName().." needs to spawn "..tostring(maxammo).." x " .. tostring(amtype))
				for i=0, maxammo do
					local am = instanceItem(amtype)
					self.player:getInventory():AddItem(am)
				end
			elseif(currentAmmo < 1) and (not ISReloadWeaponAction.canShoot(weapon)) and (not SurvivorInfiniteAmmo) then
				local ammo = self:openBoxForGun()
				if ammo == nil then
					self:DebugSay(self:getName().." no clip ammo left")
					return false
				end
			end
			
			if (currentAmmo < 1) and (weapon:getCurrentAmmoCount() > 0) then
				self:DebugSay(self:getName().." out of bullets but mag not empty, keep firing")		
				return true
			elseif (self.EnemiesOnMe == 0 and self.seenCount == 0 and weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()) or (weapon:getCurrentAmmoCount() == 0) then
				ISTimedActionQueue.add(ISEjectMagazine:new(self.player, weapon))
			
				-- reload the ejected magazine and insert it
				self:DebugSay(self:getName().." needs to reload the ejected magazine and insert it")
				ISTimedActionQueue.queueActions(self.player, ISReloadWeaponAction.ReloadBestMagazine, weapon)
				return true
			else 
				self:DebugSay(self:getName().." mag already full (enough)")				
				return true
			end
		end
		
		local magazine = weapon:getBestMagazine(self.player)
		if magazine then
			readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
			ISInventoryPaneContextMenu.transferIfNeeded(self.player, magazine)
			ISTimedActionQueue.add(ISInsertMagazine:new(self.player, weapon, magazine))
			return true
		end
		-- check if we have an empty magazine for the current gun
		ISReloadWeaponAction.ReloadBestMagazine(self.player, weapon)
	else -- gun with no magazine
			
		if(self:getInventoryAmmoCount(weapon) < 1) and (SurvivorInfiniteAmmo) then
			readyGun_AntiStuck_Ticks = readyGun_AntiStuck_Ticks + 1
			local maxammo = weapon:getMaxAmmo()
			local ammotype = weapon:getAmmoType()
			self:DebugSay(self:getName().." needs to spawn ammo type:" .. tostring(ammotype))
			for i=0, maxammo do			
				local am = instanceItem(ammotype)
				self.player:getInventory():AddItem(am)
			end
		end
		
		-- if can't have more bullets, we don't do anything, this doesn't apply for magazine-type guns (you'll still remove the current clip)
		if weapon:getCurrentAmmoCount() >= weapon:getMaxAmmo() then
			self:DebugSay(self:getName().." ammo already max")
			return true
		end

		-- if there's bullets in the gun and we're in danger, just keep shooting
		if (weapon:getCurrentAmmoCount() > 0 and self.EnemiesOnMe > 0) then
			self:DebugSay("just keep shooting")
			return true
		elseif (weapon:getCurrentAmmoCount() > 0 and self.seenCount > 0 and not self:isReloading()) then
			self:DebugSay("empty the gun")
			return true
		end
		
		local ammoCount = ISInventoryPaneContextMenu.transferBullets(self.player, weapon:getAmmoType(), weapon:getCurrentAmmoCount(), weapon:getMaxAmmo())
		if ammoCount == 0 then
			local ammo = self:openBoxForGun()
			if ammo == nil then
				self:DebugSay(self:getName().." no ammo")
				if(not ISReloadWeaponAction.canShoot(weapon)) then
					return false 
				else
					return true
				end
			end
		elseif (self.seenCount == 0 and weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()) or (weapon:getCurrentAmmoCount() == 0) and (not self:isReloading()) then
			self:DebugSay("reload")
			ISTimedActionQueue.add(ISReloadWeaponAction:new(self.player, weapon))
		end
		return true
	end
	
	if(not ISReloadWeaponAction.canShoot(weapon)) then
		return false 
	else
		return true
	end
end

--- checks if the survivor needs to ready the gun
---@param weapon weapon
---@return boolean
function SuperSurvivor:needToReadyGun(weapon)
	return weapon and self:usingGun() and not ISReloadWeaponAction.canShoot(weapon)
end

--- gets the amount of ammo the survivor has its inventory
---@param gun weapon
---@return integer
function SuperSurvivor:getInventoryAmmoCount(gun)
	local ammoType = gun:getAmmoType()
	if ammoType then
		return self.player:getInventory():getItemCountRecurse(ammoType)
	end
	
	return 0
end

--- checks if the survivor needs to reload the equipped gun
---@return boolean
function SuperSurvivor:needToReload()
	local weapon = self.player:getPrimaryHandItem()
	if(not weapon) then 
		return false 
	end

	return 
	(
		self:usingGun() and 
		not self:isReloading() and 
		weapon:getAmmoType() and 
		(
			weapon:getCurrentAmmoCount() < weapon:getMaxAmmo()
		) 
	)
end

--- checks if the survivor is reloading the gun
---@return boolean
function SuperSurvivor:isReloading()
	return self.player:getVariableBoolean("isLoading")	
end

--- recieve a weapon and equip it if equipIt is true
---@param weaponType string
---@param equipIt boolean 
---@return void
function SuperSurvivor:giveWeapon(weaponType,equipIt)
	if ((weaponType == "AssaultRifle") or (weaponType == "AssaultRifle2"))  then -- TODO : remove it 
		weaponType = "VarmintRifle" 
	end 
	
	local weapon = self.player:getInventory():AddItem(weaponType);
	if(weapon == nil) then return false end
	
	if(weapon:isAimedFirearm()) then 
		if(isModEnabled("ORGM")) then ORGM.setupGun(ORGM.getFirearmData(weapon), weapon) end
		self:setGunWep(weapon)
	else 
		self:setMeleWep(weapon) 
	end
	
	if(weapon:getMagazineType()~=nil) then
		self.player:getInventory():AddItem(weapon:getMagazineType());
	end
	
	if(equipIt) then 
		self.player:setPrimaryHandItem(weapon) 
		if(weapon:isRequiresEquippedBothHands() or weapon:isTwoHandWeapon()) then 
			self.player:setSecondaryHandItem(weapon)  
		end
	end
	
	local ammotypes = getAmmoBullets(weapon,true);
	if(ammotypes) then 
		
		local bwep = self.player:getInventory():AddItem( MeleWeapons[ZombRand(1,#MeleWeapons)] ) -- give a beackup mele weapon if using ammo gun
		if(bwep) then 
			self.player:getModData().weaponmele = bwep:getType() 
			self:setMeleWep(bwep)
		end
		
		local ammo = ammotypes[1]
		if(ammo) then
			--local tempammoitem = self.player:getInventory():AddItem(ammo);
			--if(tempammoitem ~= nil) then
			--	local groupcount = tempammoitem:getCount() ;
			--	local randomammo = math.floor(ZombRand(40,100)/groupcount);
			--	print("giving "..tostring(randomammo).." ".. ammo.. " to s for weapon:"..weapon:getType())
			--	for i=0, randomammo do
			--	self.player:getInventory():AddItem(ammo);
			--	end
			--end
			local ammobox = getAmmoBox(ammo)
			if(ammobox ~= nil) then
				local randomammo = ZombRand(4,10);
				--print("giving "..tostring(randomammo).." ".. ammo.. " to s for weapon:"..weapon:getType())
				for i=0, randomammo do
					self.player:getInventory():AddItem(ammobox);
				end
			end
		end
		ammotypes = getAmmoBullets(weapon,false);
		self.player:getModData().ammoCount = self:FindAndReturnCount(ammotypes[1])
		
	else
		--print("no ammo types for weapon:"..weapon:getType())
	end
end

--- sets the equiped weapon ready
---@return boolean returns true if ReadyGun returns true or if its a meele weapon
function SuperSurvivor:WeaponReady()
	--print("WeaponReady " .. self:getName())
	local primary = self.player:getPrimaryHandItem()
	if(primary ~= nil) and (self.player ~= nil) and (instanceof(primary,"HandWeapon")) and (primary:isAimedFirearm()) then
		--print("firearm")
	
		primary:setCondition(primary:getConditionMax())	
		primary:setJammed(false);
		primary:getModData().isJammed = nil 
		
		
		local ammo, ammoBox, result;
		
		local bulletcount = 0
		for i=1,#self.AmmoTypes do			
			bulletcount = bulletcount + self:FindAndReturnCount(self.AmmoTypes[i])
		end
		--print("bulletcount " .. tostring(bulletcount))
		
		self.player:getModData().ammoCount = bulletcount
		
		for i=1, #self.AmmoTypes do	
			ammo = self:FindAndReturn(self.AmmoTypes[i])
			if(ammo) then break end
		end
		if(not ammo) and (SurvivorInfiniteAmmo) then 
			ammo = self.player:getInventory():AddItem(self.AmmoTypes[1])
		end
		
		if(not ammo) then
				--print("not ammo")
				self.TriggerHeldDown = false
				ammo = self:openBoxForGun()
			
		else
			
		end
		
		if(not ISReloadWeaponAction.canShoot(primary)) then 
			return self:ReadyGun(primary) 
		else 
			return true 
		end
		
	end
	return true
end

--- opens a bullet box and returns it
---@return any
function SuperSurvivor:openBoxForGun()
	local index = 0
	local ammoBox = nil
	for i=1,#self.AmmoBoxTypes do	
		index = i
		ammoBox = self:FindAndReturn(self.AmmoBoxTypes[i])
		if(ammoBox) then 
			break 
		end
	end
	
	if(ammoBox) then 
		--print("ammoBox")
		
		local ORGMEnabled = false
		if(isModEnabled("ORGM")) then 
			ORGMEnabled = true 
		end
	
		local ammotype = self.AmmoTypes[index]
		local inv = self.player:getInventory()
		
		local modl = ammoBox:getModule() .. "."
		
		local tempBullet = instanceItem(modl..ammotype)
		local groupcount = tempBullet:getCount()
		local count = 0
		if ORGMEnabled then 
			--print(ammoBox:getType())
			count = ORGM.getAmmoData(ammotype).BoxCount
		else
			count = (getBoxCount(ammoBox:getType()) / groupcount)
		end
							
		--print("box tyoe count was "..tostring(count))
		for i=1, count do
			--print("in loop!")
			inv:AddItem(modl..ammotype)
		end
		self:RoleplaySpeak(getActionText("Opens_Before") .. ammoBox:getDisplayName() .. getActionText("Opens_After"))
		ammoBox:getContainer():Remove(ammoBox)
		return self.player:getInventory():FindAndReturn(ammotype);
	else
		--print("could not find ammo box for "..tostring(boxType))
	end
end

--- check if the survivor has any kind of ammo 
---@return boolean
function SuperSurvivor:hasAmmoForPrevGun()
	if(self.AmmoTypes ~= nil) and (#self.AmmoTypes > 0) then 	
		
		local ammoRound
		for i=1,#self.AmmoTypes do		
			ammoRound = self:FindAndReturn(self.AmmoTypes[i])
			if(ammoRound) then break end
		end
		
		if (ammoRound ~= nil) then
			return true
		end
		
		local ammoBox 
		for i=1,#self.AmmoBoxTypes do		
			ammoBox = self:FindAndReturn(self.AmmoBoxTypes[i])
			if(ammoBox) then break end
		end
		
		if (ammoBox ~= nil) then
			return true
		end	
	end
	
	return false
end

--- re-equips the survivor's gun
---@return void
function SuperSurvivor:reEquipGun()
	if(self.LastGunUsed == nil) then 
		return
	 end
	
	if(self.LastGunUsed ~= nil) then
		if(self.player:getPrimaryHandItem() ~= nil and self.player:getPrimaryHandItem():isTwoHandWeapon()) then 
			self.player:setSecondaryHandItem(nil) 
		end 

		self.player:setPrimaryHandItem(self.LastGunUsed)
		if(self.LastGunUsed:isTwoHandWeapon()) then 
			self.player:setSecondaryHandItem(self.LastGunUsed) 
		end
		return
	end

end
--- re-equips the survivor's meele weapon
---@return void
function SuperSurvivor:reEquipMele()
	if(self.LastMeleUsed == nil) then 
		return 
	end

	if(self.player:getPrimaryHandItem() ~= nil and self.player:getPrimaryHandItem():isTwoHandWeapon()) then 
		self.player:setSecondaryHandItem(nil) 
	end
	self.player:setPrimaryHandItem(self.LastMeleUsed)

	if(self.LastMeleUsed:isTwoHandWeapon()) then 
		self.player:setSecondaryHandItem(self.LastMeleUsed) 
	end
end
--- sets the meleWeapon
---@param handWeapon any
---@return void
function SuperSurvivor:setMeleWep(handWeapon)
	self:Get():getModData().meleWeapon = handWeapon:getType()
	self.LastMeleUsed = handWeapon
end
--- gets the gun
---@param handWeapon any
---@return void
function SuperSurvivor:setGunWep(handWeapon)
	self:Get():getModData().gunWeapon = handWeapon:getType()
	self.LastGunUsed = handWeapon
end
--- gets the min range of the equiped weapon
---@return number returns the range of the weapon or 0.5 if no weapon is equiped
function SuperSurvivor:getMinWeaponRange()
	local out = 0.5
	local primaryHandItem = self.player:getPrimaryHandItem()
	if(primaryHandItem ~= nil) then
		if(instanceof(primaryHandItem,"HandWeapon")) then
			return primaryHandItem:getMinRange()
		end
	end
	return out
end
--- checks if the atk ticks is zero
---@deprecated 
---@return boolean
function SuperSurvivor:Is_AtkTicksZero()
	return self.AtkTicks <= 0
end
--- decreases the atk tick by 1
---@return void
function SuperSurvivor:AtkTicks_Countdown()
	if (self.AtkTicks > 0) then
		self.AtkTicks = self.AtkTicks - 1
	end
		self:DebugSay("AtkTicks: "..tostring(self.AtkTicks))
end
--- Used in 'if the npc has swiped their weapon'.
---@return boolean
function SuperSurvivor:hasSwipedState()
	return self.player:getCurrentState() == SwipeStatePlayer.instance()
end

--- checks if the survivor has felldown
---@return boolean
function SuperSurvivor:hasFellDown()
	return self.player:getModData().felldown
end
	
function SuperSurvivor:canAttack()
	return not self:hasSwipedState() and not self:hasFellDown()
end

--- gets every square between the npc and the target and adds a cover value 
---@param victim any
---@return number represents the final cover value of the victim
function SuperSurvivor:checkVictimCoverValue(victim)
	local totalCover = 0
	local blockingObjects  = 0 

	local squares = getSquaresBetween(self:getCurrentSquare(),victim:getCurrentSquare())

	for _, square in ipairs(squares) do
		local objs = square:getObjects()

		for i = 0, objs:size() - 1, 1 do
			local obj = objs:get(i)
			if(obj ~= nil)then
				local coverValue = getCoverValue(obj) -- the function is considering grass as a 10 cover value (fix it later)
				totalCover = totalCover + coverValue
				blockingObjects = blockingObjects + 1 
			end
		end
	end

	if blockingObjects == 0 then -- prevent divide by zero exceptions
		return totalCover
	end

	totalCover = totalCover/ blockingObjects
	
	--print("total cover : " .. tostring(totalCover))

	return totalCover - 10  -- workaround (see line 4085)
end

--- gets the weapon damager based on a rng and distance from the target
---@param weapon any
---@param distance number
---@return number represents the damage that the weapon will give if hits
function SuperSurvivor:getWeaponDamage(weapon,distance)
	if (weapon == nil) then
		return 0
	end

	--	local damage = ZombRand(weapon:getMinDamage(), weapon:getMaxDamage())
	--	damage = damage - (damage * (distance * 0.1))
	
	--local Multiplier = Option_NPC_AttackMultiplier 
	-- local minrange = self:getMinWeaponRange() + 0.1
	local damage = 0
		  damage = (weapon:getMaxDamage() * ZombRand(10))
		  damage = damage - (damage * (distance * 0.1))	
	
	
	return damage
end

--- Gets the change of a shoot based on aiming skill, weapon, victim's distance and cover
--- TODO: re-add rng	damage
---@param weapon weapon
---@param victim player
---@return number represents the chance of a hit
function SuperSurvivor:getGunHitChange(weapon,victim)
	local aimingLevel = self.player:getPerkLevel(Perks.FromString("Aiming"))
	local aimingPerkModifier = weapon:getAimingPerkHitChanceModifier()
	local weaponHitChance = weapon:getHitChance()
	
	local hitChance = weaponHitChance + (aimingPerkModifier * aimingLevel)

	local distance = getDistanceBetween(self.player,victim)
	local coverValue = self:checkVictimCoverValue(victim)

	return hitChance - distance - coverValue -- TODO: change formula when coverValue != 0
end

--- The new function that will now control NPC attacking. Not perfect, but. Cleaner code, and works better-ish.
--- TODO: join the attack functions
---@param victim player
---@return void
function SuperSurvivor:NPC_Attack(victim)
	
	if (not self:Is_AtkTicksZero()) and (self:canAttack()) then
		self:AtkTicks_Countdown()
		return 
	end
	
	local isHuman = instanceof(victim,"IsoPlayer")
	local isZombie = instanceof(victim,"IsoZombie")
	-- This is to force PVP so the player can fight back the hostile NPCs. This does NOT prevent hostile NPCs from being able to hit the player. -(This has been tested)-
	if(isHuman and IsoPlayer.getCoopPVP() == false) then
		ForcePVPOn = true;
		SurvivorTogglePVP();
	end
		
	if not (isHuman or isZombie) then 
		return 
	end

	if(self:WeaponReady()) then
		self:DebugSay("NPC_Attack is about to trigger a StopWalk!")
		self:StopWalk()
		self.player:NPCSetAiming(true) -- Visually animate 
		self.player:NPCSetAttack(true) -- Visually animate 
		self.player:faceThisObject(victim)
	end

	local distance = getDistanceBetween(self.player,victim) - 0.1
	local RealDistance = getDistanceBetween(self.player,victim)
	local minrange = self:getMinWeaponRange()
	local weapon = self.player:getPrimaryHandItem()
	local zNPC_AttackRange = self:isEnemyInRange(self.LastEnemeySeen)
	local damage = 1

	-- Makes sure if the weapon exists
	if (weapon ~= nil) then
		damage = weapon:getMaxDamage();
	end
	
	if((RealDistance <= minrange) or zNPC_AttackRange) and (self.AtkTicks <= 0) and (self:canAttack()) and (not self.player:NPCGetRunning()) then
		victim:Hit(weapon, self.player, damage, false, 1.0, false)
		-- To keep the NPC from spamming another entity, but give fighting chance for zeds
		if (isHuman) then 
			self.AtkTicks = 2 
		end
		if (isZombie) then 
			self.AtkTicks = 1 
		end
	end	
end
	

--- This is the old variant of the attack function. It should not be used for melee attacks. It works well with guns though, so...
--- TODO: move it to attack task
---@param victim player  
---@return void
function SuperSurvivor:Attack(victim)
	local level = SurvivorDebugEnum.Combat;
	logSurvivorFunction(level,"Attack")

	if(self.player == nil) then
		logSurvivorLog(level,"survivor", self:getID() ,"can't attack", "reason : no player")
		logSurvivorFunction(level,"Attack")
		return
	end
	-- Create the attack cooldown. (once 0, the npc will do the 'attack' then set the time back up by 1, so anti-attack spam method)
	-- note: don't use self:canAttack() in this if statement. it's already being done in this function. (Update: It works long as it's set to true)
	if (not self:Is_AtkTicksZero()) and (self:canAttack()) then
		self:AtkTicks_Countdown()
		logSurvivorLog(level,"survivor", self:getID() ,"can't attack", "reason : cooldown")
		logSurvivorFunction(level,"Attack")
		return
	end

	-- cant attack if stunned by an attack
	if(self.player:getModData().felldown) then 
		logSurvivorLog(level,"survivor", self:getID() ,"can't attack", "reason : survivor has fell down")
		logSurvivorFunction(level,"Attack")
		return 
	end 
	
	local isHuman = instanceof(victim,"IsoPlayer")
	local isZombie = instanceof(victim,"IsoZombie")

	if not (isHuman or isZombie) then 
		logSurvivorLog(level,"survivor", self:getID() ,"can't attack", "reason : target is not an enemy")
		logSurvivorFunction(level,"Attack")
		return 
	end

	if(self:WeaponReady()) then
		logSurvivorLog(level,"Weapon is ready")

		if(isHuman and IsoPlayer.getCoopPVP() == false) then
			ForcePVPOn = true;
			SurvivorTogglePVP();
		end
		
		self:DebugSay("Attack() is about to trigger a StopWalk!")
		self:StopWalk()
		self.player:faceThisObject(victim);

		local distance = getDistanceBetween(self.player,victim)
		local minrange = self:getMinWeaponRange() + 0.1
		local weapon = self.player:getPrimaryHandItem();
		
		-- local damage = self:getWeaponDamage(weapon,distance)
		-- For now disabling rng shooting, I just can't get it working
		-- But at least the 'RealCanSee' works 
		local damage = weapon:getMaxDamage();
		
		self.player:NPCSetAiming(true)
		self.player:NPCSetAttack(true)

		if(distance < minrange) or (self.player:getPrimaryHandItem() == nil) then
			victim:Hit(weapon, self.player, damage, true, 1.0, false)
		else 
			if (self.AtkTicks <= 0) then -- First to make sure it's okay to attack
				if (self:hasGun()) then		
					if(self.UsingFullAuto) then 
						logSurvivorLog(level,"survivor", self:getID() ,"has automatic weapon")
						self.TriggerHeldDown = true 
					end
					
					local hitChance = self:getGunHitChange(weapon,victim) 
					local dice = ZombRand(0,100)
					-- Added RealCanSee to see if it works | and (damage > 0)
					if (hitChance >= dice) and (damage > 0) and (self:RealCanSee(victim)) then
						victim:Hit(weapon, self.player, damage, false, 1.0, false)
						self:DebugSay("I HIT THE GUNSHOT!")
						logSurvivorAttack(self,victim,damage);
						self.AtkTicks = 1
					else
						self:DebugSay("I MISSED THE GUNSHOT!")
						logSurvivorLog(level,"survivor", self:getID() ,"missed the shot against the survivor", victim:getID())
						self.AtkTicks = 1
					end
				else
					victim:Hit(weapon, self.player, damage, false, 1.0, false)
					logSurvivorAttack(self,victim,damage);
					self:DebugSay("MELEE STRIKE! For some reason... I shouldn't be using this Attack function! Modder, fix this!")
					self.AtkTicks = 1
				end
			else
				logSurvivorLog(level,"survivor", self:getID() ,"can't attack", "reason : cooldown (2)") -- TODO : check if this condition is necessary
			end
		end
	else
		logSurvivorLog(level,"Weapon is not ready")
		local pwep = self.player:getPrimaryHandItem()
		local pwepContainer = pwep:getContainer()
		
		if(pwepContainer) then 
			pwepContainer:Remove(pwep) 
		end -- remove temporarily so FindAndReturn("weapon") does not find this ammoless gun
		
		self:Speak(getSpeech("OutOfAmmo"));
		
		for i=1, #self.AmmoTypes do
			self:getTaskManager():AddToTop(FindThisTask:new(self,self.AmmoTypes[i],"Type",20))
		end	
		for i=1, #self.AmmoBoxTypes do
			self:getTaskManager():AddToTop(FindThisTask:new(self,self.AmmoBoxTypes[i],"Type",1))
		end
		self:setNeedAmmo(true)	
	
		local mele = self:FindAndReturn(self.player:getModData().weaponmele);
		if(mele) then 
			logSurvivorLog(level,"getting a meele weapon")
			self.player:setPrimaryHandItem(mele) 
			if(mele:isRequiresEquippedBothHands()) then 
				self.player:setSecondaryHandItem(mele) 
			end
		else
			-- TODO: move to a method
			local bwep = self.player:getInventory():getBestWeapon();
			if(bwep) and (bwep ~= pwep) then 
				logSurvivorLog(level,"getting the best weapon it can found")
				self.player:setPrimaryHandItem(bwep) ;
				if(bwep:isRequiresEquippedBothHands()) then 
					self.player:setSecondaryHandItem(bwep) 
				end
			else 
				bwep = self:getWeapon()
				if(bwep) then
					logSurvivorLog(level,"getting any weapon")
					self.player:setPrimaryHandItem(bwep) ;
					if(bwep:isRequiresEquippedBothHands()) then 
						self.player:setSecondaryHandItem(bwep) 
					end
				else
					logSurvivorLog(level,"no weapons in the invetory,", "searching for weapons")
					self.player:setPrimaryHandItem(nil) 
					self:getTaskManager():AddToTop(FindThisTask:new(self,"Weapon","Category",1))
				end
			end
		end
		
		if(pwepContainer) and (not pwepContainer:contains(pwep)) then 
			pwepContainer:AddItem(pwep) 
		end -- re add the former wepon that we temp removed
	end
	logSurvivorFunction(level,"Attack")
end
--- END COMBAT ---

--- CONTEXT ---
function SuperSurvivor:getFacingSquare()	
	local fsquare = square:getTileInDirection(self.player:getDir())
	
	if(fsquare) then 
		return fsquare 
	else 
		return self.player:getCurrentSquare() 
	end
end

function SuperSurvivor:inFrontOfStairs()

	local cs = self.player:getCurrentSquare()

	if cs:HasStairs() then return true end
	local osquare = GetAdjSquare(cs,"N")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"E")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"S")
	if cs and osquare and osquare:HasStairs() then return true end
	
	osquare = GetAdjSquare(cs,"W")
	if cs and osquare and osquare:HasStairs() then return true end
	
	return false 
	
end

function SuperSurvivor:isTargetBuildingDangerous()
	if self:isTargetBuildingClaimed(self.TargetBuilding) then return true end

	local result = NumberOfZombiesInOrAroundBuilding(self.TargetBuilding)
	
	if(result >= 10) and (self:isTooScaredToFight()) then 
		return true
	else 
		return false 
	end
end

function SuperSurvivor:getBuilding()
	if(self.player == nil) then 
		return nil 
	end

	local sq = self.player:getCurrentSquare()

	if(sq) then
		local room = sq:getRoom()
		if(room) then
			local building = room:getBuilding()
			if(building) then 
				return building 
			else 
				return nil 
			end
		end
	end
	
	return nil
end
function SuperSurvivor:isInBuilding(building)
	if(building == self:getBuilding()) then return true
	else return false end
end

function SuperSurvivor:inFrontOfDoor()

	 local cs = self.player:getCurrentSquare()
	 local osquare = GetAdjSquare(cs,"N")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"E")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"S")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"W")
	 if cs and osquare and cs:getDoorTo(osquare) then return cs:getDoorTo(osquare) end
	 
	 return nil 
	
end
function SuperSurvivor:inFrontOfLockedDoor()

	local door = self:inFrontOfDoor()
			
	if (door ~= nil) and (door:isLocked() or door:isLockedByKey() or door:isBarricaded()) and (not door:isDestroyed())  then
		return true
	else 
		return false
	end
	
end
function SuperSurvivor:inFrontOfLockedDoorAndIsOutside()

	local door = self:inFrontOfDoor()

	if (door ~= nil) and (door:isLocked() or door:isLockedByKey() or door:isBarricaded()) and (self.player:isOutside()) then
		return true
	else 
		return false
	end
end
function SuperSurvivor:inFrontOfLockedDoorAndIsInside()

	local door = self:inFrontOfDoor()

	if (door ~= nil) and (door:isLocked() or door:isLockedByKey() or door:isBarricaded()) and (not self.player:isOutside()) then
		return true
	else 
		return false
	end
end
function SuperSurvivor:inFrontOfBarricadedDoor()

	local door = self:inFrontOfDoor()
			
	if (door ~= nil) and (door:isBarricaded())  then
		return true
	else 
		return false
	end
	
end
function SuperSurvivor:NPC_IFOD_BarricadedInside() -- IFOD stands for In front of door 

	local door = self:inFrontOfDoor()
			
	if (door ~= nil) and ((door:isBarricaded()) and (not self.player:isOutside()))  then
		return true
	else 
		return false
	end
	
end
function SuperSurvivor:NPC_IFOD_BarricadedOutside() -- IFOD stands for In front of door 

	local door = self:inFrontOfDoor()
			
	if (door ~= nil) and (door:isBarricaded()) and (self.player:isOutside())  then
		return true
	else 
		return false
	end

end
function SuperSurvivor:inFrontOfWindow()

	 local cs = self.player:getCurrentSquare()
	 local fsquare = cs:getTileInDirection(self.player:getDir());
	 if cs and fsquare then return cs:getWindowTo(fsquare)
	 else return nil end
	
end
-- since inFrontOfWindow (not alt) doesn't have this function's code
function SuperSurvivor:inFrontOfWindowAlt() 

	 local cs = self.player:getCurrentSquare()
	 local osquare = GetAdjSquare(cs,"N")
	 if cs and osquare and cs:getWindowTo(osquare) then return cs:getWindowTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"E")
	 if cs and osquare and cs:getWindowTo(osquare) then return cs:getWindowTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"S")
	 if cs and osquare and cs:getWindowTo(osquare) then return cs:getWindowTo(osquare) end
	 
	 osquare = GetAdjSquare(cs,"W")
	 if cs and osquare and cs:getWindowTo(osquare) then return cs:getWindowTo(osquare) end
	 
	 return nil 
 
end
function SuperSurvivor:inFrontOfBarricadedWindowAlt()-- Used door locked code for this, added 'alt' to function name just to be safe for naming
	local window = self:inFrontOfWindowAlt()

	if (window ~= nil) and (window:isBarricaded()) then
		return true
	else 
		return false
	end
end
function SuperSurvivor:inFrontOfWindowAndIsOutsideAlt()-- Used door locked code for this, added 'alt' to function name just to be safe for naming
	local window = self:inFrontOfWindowAlt()

	if (window ~= nil) and (self.player:isOutside()) then
		return true
	else 
		return false
	end
end
function SuperSurvivor:inFrontOfBarricadedWindowAndIsOutsideAlt()-- Used door locked code for this, added 'alt' to function name just to be safe for naming
	local window = self:inFrontOfWindowAlt()

	if (window ~= nil) and (window:isBarricaded()) and (self.player:isOutside()) then
		return true
	else 
		return false
	end
end
function SuperSurvivor:NPC_inFrontOfUnBarricadedWindowOutside()-- Is the NPC front of an UNbarricaded window AND is the NPC outside?
	local window = self:inFrontOfWindowAlt()

	if (window ~= nil) and (not window:isBarricaded()) and (self.player:isOutside()) then
		return true
	else 
		return false
	end
	self:DebugSay("NPC In front of Unbarricaded Window Outside: Window is barricaded("..tostring(window:isBarricaded())..") and Is outside("..tostring(self.player:isOutside())..")")
end
function SuperSurvivor:getUnBarricadedWindow(building)

	local pcs = self.player:getCurrentSquare()
	local WindowOut = nil
	local closestSoFar = 100
	local bdef = building:getDef()	
	for x=bdef:getX()-1,(bdef:getX() + bdef:getW() + 1) do	
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH() + 1) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				local Objs = sq:getObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					local objectSquare = Object:getSquare()
					local distance = getDistanceBetween(objectSquare,self.player)
					if(instanceof(Object,"IsoWindow"))  and (self:getWalkToAttempt(objectSquare) < 8) and distance < closestSoFar then
						
						 local barricade = Object:getBarricadeForCharacter(self.player)
						 if barricade == nil or (barricade:canAddPlank()) then 
							closestSoFar = distance	
							WindowOut = Object 
						end
					end
				end	
			end
			
		end
							
	end
	return WindowOut
end

function SuperSurvivor:Explore(sq)
	if(sq) then
		local key = tostring(sq:getX()).. "/" ..tostring(sq:getY())
		if(self.SquaresExplored[key] == nil) then 
			self.SquaresExplored[key] = 1
		else 
			self.SquaresExplored[key] = self.SquaresExplored[key] + 1 
		end
	end
end
function SuperSurvivor:getExplore(sq)	
	if(sq) then
		local key = tostring(sq:getX()).. "/" ..tostring(sq:getY())

		if(self.SquaresExplored[key] == nil) then 
			return 0
		else 
			return self.SquaresExplored[key] 
		end
	end
	return 0
end
function SuperSurvivor:MarkAttemptedBuildingExplored(building)
	if(building == nil) then return false end
	local bdef = building:getDef()	
	for x=bdef:getX(),(bdef:getX() + bdef:getW()) do	
		for y=bdef:getY(),(bdef:getY() + bdef:getH()) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:setWalkToAttempt(sq,8)
			end			
		end							
	end
end
function SuperSurvivor:resetBuildingWalkToAttempts(building)
	if(building == nil) then return false end
	local bdef = building:getDef()	
	for x=bdef:getX(),(bdef:getX() + bdef:getW()) do	
		for y=bdef:getY(),(bdef:getY() + bdef:getH()) do
			
			local sq = getCell():getGridSquare(x,y,self.player:getZ())			
			if(sq) then 
				self:setWalkToAttempt(sq,0)
			end			
		end							
	end
end

function SuperSurvivor:NPC_ForceFindNearestBuilding()
	if(self.TargetSquare ~= nil) and (self.TargetSquare:getRoom()) and (self.TargetSquare:getRoom():getBuilding()) then 
		self.TargetBuilding = self.TargetSquare:getRoom():getBuilding() 
	end
end
--- END CONTEXT ---

--- RELATIONSHIP ---
function SuperSurvivor:getRelationshipWP()
	if(self.player:getModData().RWP == nil) then 
		return 0
	else 
		return self.player:getModData().RWP 
	end	
end
function SuperSurvivor:PlusRelationshipWP(thisAmount)
	if(self.player:getModData().RWP == nil) then 
		self.player:getModData().RWP = 0 
	end
	
	self.player:getModData().RWP = self.player:getModData().RWP + thisAmount
	return self.player:getModData().RWP
end
--- END RELATIONSHIP ---

--- DEBUG ---
function SuperSurvivor:NPCDebugPrint(text)
	if (DebugOptions == true) then
		-- This gives spacing for the console so you can find it
		--print("")
		--print("NPCDebugPrint")
		--print("NPC Name: "..tostring(self:getName()))
		--print(text)
		--print("")
		--print("")
	end
end

function SuperSurvivor:DebugSay(text) 
	-- Now, the In game DebugOptions will now effect this.
	local zDebugSayDistance = DebugOption_DebugSay_Distance

	if(DebugOptions == true and DebugOption_DebugSay == 1) then
		
		if (getDistanceBetween(getSpecificPlayer(0),self.player) < 10) then
			print("")
			print("============="..tostring(self:getName()).." = "..text)
		end
		
		
		if (getDistanceBetween(getSpecificPlayer(0),self.player) < zDebugSayDistance) then -- if far enough away from player, don't do anything
		
			local zLastEnemySeen = 0
			if (self.LastEnemeySeen ~= nil) then zLastEnemySeen = self.LastEnemeySeen else zLastEnemySeen = 0 end
			print("")
			print("")
			print("")
			print("========================================== SUPER DEBUG ===================================================")
			print("----------------------------------------------------------------------------------------------------------")
			print("")
			print("----------------------------------------")
			print("")
			print("		"..tostring(self:getName()).." = "..text)
			print("^ General Debug Text")
			print("")
			print("----------------------------------------")
			print("----------------------------------------")
			print("--------- Detailed Debug Information ---")
			print("----------------------------------------")
			print("Current time - "..(os.date ("%c")))
			print("")
			print("")
			
			-- Uncomment this at your own risk. It is full of lag if you use it.
			--if (self.player:isOutside()) 			then print(self:getName().."=	*IS* OUTSIDE") 																						else print(self:getName().."=	IS *NOT* OUTSIDE") end
			--if (self:inUnLootedBuilding())		then print(self:getName().."=	*IS* in a UnLootedBuilding") 																		else print(self:getName().."=	IS *NOT* in front of a UnlootedBuilding") end
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	*CAN* RealCanSee Last Enemey 			= True") 													else print(self:getName().."=	CAN *NOT* RealCanSee") end
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	isInSameRoom(self.LastEnemeySeen)		= "..tostring(self:isInSameRoom(self.LastEnemeySeen))) 		else print(self:getName().."=	is *NOT* in the same Room with an enemy  (or a nil was returned)") end
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	isInSameRoomWithEnemy				= "..tostring(self:isInSameRoomWithEnemy())) 			else print(self:getName().."=	is *NOT* in the same Room with an enemy  (or a nil was returned)") end
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	isInSameBuilding(self.LastEnemeySeen)	= "..tostring(self:isInSameBuilding(self.LastEnemeySeen))) 	else print(self:getName().."=	is *NOT* in the same Building with an enemy (or a nil was returned)") end	
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	isInSameBuildingWithEnemy			= "..tostring(self:isInSameBuildingWithEnemy())) 		else print(self:getName().."=	is *NOT* in the same Building with an enemy (or a nil was returned)") end	
			--if (self.LastEnemeySeen ~= nil) 	then print(self:getName().."=	enemyIsOutside (LastEnemySeen)		= "..tostring(self:enemyIsOutside())) 					else print(self:getName().."=	NPC's Target IS *NOT* outside! (OR Returned a Nil)") end	
	
			-- Extra information
			print("")
			print("")
			print("		----------- Door Information ---------------")			
			print("		---- IFOD Stands for 'In front of door' ----")			
			if(self:inFrontOfDoor()) 					then	print(self:getName().."		inFrontOfDoor					=	true") else print(self:getName().."		inFrontOfDoor						=	false") end
			if(self:inFrontOfLockedDoor()) 				then	print(self:getName().."		inFrontOfLockedDoor				=	true") else print(self:getName().."		inFrontOfLockedDoor 				=	false") end
			if(self:inFrontOfLockedDoorAndIsOutside())	then	print(self:getName().."		inFrontOfLockedDoorAndIsOutside =	true") else print(self:getName().."		inFrontOfLockedDoorAndIsOutside		=	false") end
			print("")
			if(self:inFrontOfBarricadedDoor()) 			then	print(self:getName().."		inFrontOfBarricadedDoor			=	true") else print(self:getName().."		inFrontOfBarricadedDoor				=	false") end
			if(self:inFrontOfLockedDoorAndIsInside()) 	then	print(self:getName().."		inFrontOfLockedDoorAndIsInside	=	true") else print(self:getName().."		inFrontOfLockedDoorAndIsInside		=	false") end
			print("")
			if(self:NPC_IFOD_BarricadedInside()) 		then	print(self:getName().."		NPC_IFOD_BarricadedInside		=	true") else print(self:getName().."		NPC_IFOD_BarricadedInside			=	false") end
			if(self:NPC_IFOD_BarricadedOutside()) 		then	print(self:getName().."		NPC_IFOD_BarricadedOutside		=	true") else print(self:getName().."		NPC_IFOD_BarricadedOutside			=	false") end

			print("")
			print("---------------")
			print("---- Task -----")
			print("---------------")
			print(self:getName().."		getCurrentTask	= "..tostring(self:getCurrentTask()))
			print(self:getName().."		getGroupRole	= "..tostring(self:getGroupRole()))
			print(self:getName().."		AIMode			= "..tostring(self.player:getModData().AIMode))
			
			print("")
			print("--------------------")
			print("---- Direction -----")
			print("--------------------")
			print(self:getName().."		getBuilding		= "..tostring(self:getBuilding()))
			print(self:getName().."		getRouteID		= "..tostring(self:getRouteID()))
			print(self:getName().."		X/Y/Z			= X:"..tostring(self:getX()).." Y:"..tostring(self:getY()).." Z:"..tostring(self:getZ())    )
			print(self:getName().."		getSneaking		= "..tostring(self:getSneaking()))
			print(self:getName().."		getFacingSquare	= "..tostring(self:getFacingSquare()))
			
			print("")
			print("---- Seperator -----")
			print("")
			print(self:getName().."		getSeenCount		= "..tostring(self:getSeenCount()))
			print(self:getName().."		getDangerSeenCount	= "..tostring(self:getDangerSeenCount()))
			print(self:getName().."		isTooScaredToFight	= "..tostring(self:isTooScaredToFight()))
			print(self:getName().."		isWalkingPermitted	= "..tostring(self:isWalkingPermitted()))
			
			print("")
			print("---- Personal Health -----")
			print("")
			print(self:getName().."		HasInjury			= "..tostring(self:HasInjury()))
			print(self:getName().."		HasMultipleInjury	= "..tostring(self:HasMultipleInjury()))


			
			print("")
			print("---- Seperator -----")
			print("")
			print(self:getName().."		isInCell 			= "..tostring(self:isInCell()))
			print(self:getName().."	-	isInBase		-	= "..tostring(self:isInBase()))
			print(self:getName().."		isWalking			= "..tostring(self:isWalking()))
			print(self:getName().."	-	isInAction		-	= "..tostring(self:isInAction()))
			print(self:getName().."		isOnScreen			= "..tostring(self:isOnScreen()))
			print(self:getName().."	-	getAttackRange	-	= "..tostring(self.getAttackRange))
			
			print("")
			print("---- Attack Info -----")
			print("")
			print(self:getName().."		LastEnemeySeen		= "..tostring(zLastEnemySeen))
			print("")
			print(self:getName().."	-	canAttack	-	= "..tostring(self:canAttack()))
			print(self:getName().."		HasSwipedState		= "..tostring(self:hasSwipedState()))
			print(self:getName().."	-	HasFellDown		-	= "..tostring(self:hasFellDown()))
			print(self:getName().."		AtkTicks_Countdown	= "..tostring(self.AtkTicks))
			print(self:getName().."	-	Is_AtkTicksZero	-	= "..tostring(self:Is_AtkTicksZero()))
			print(self:getName().."		IsNOT_AtkTicksZero	= "..tostring(not self:Is_AtkTicksZero()))
			print(self:getName().."	-	hasWeapon		-	= "..tostring(self:hasWeapon()))
		
			-- Large named seperator
			print(self:getName().."		NPC_TaskCheck_EnterLeaveBuilding = "..tostring(self:NPC_TaskCheck_EnterLeaveBuilding()))
			print("")
			print("")
			print("------------------------------------------------------")
			print("------------- NPC's Other variables ------------------")
			print("------------------------------------------------------")
			print("")
			print(self:getName().."self.NumberOfBuildingsLooted		=	"..tostring(self.NumberOfBuildingsLooted))
			print(self:getName().."self.AttackRange					=	"..tostring(self.AttackRange))
			print(self:getName().."self.UsingFullAuto				=	"..tostring(self.UsingFullAuto))
			print(self:getName().."self.GroupBraveryBonus			=	"..tostring(self.GroupBraveryBonus))
			print(self:getName().."self.GroupBraveryUpdatedTicks	=	"..tostring(self.GroupBraveryUpdatedTicks))
			print(self:getName().."self.WaitTicks					=	"..tostring(self.WaitTicks))
			print(self:getName().."self.AtkTicks					=	"..tostring(self.AtkTicks))
			print(self:getName().."self.TriggerHeldDown				=	"..tostring(self.TriggerHeldDown))
			print(self:getName().."self.LastGunUsed					=	"..tostring(self.LastGunUsed))
			print(self:getName().."self.LastMeleUsed				=	"..tostring(self.LastMeleUsed))
			print(self:getName().."self.roundChambered				=	"..tostring(self.roundChambered))
			print(self:getName().."self.TicksSinceSpoke				=	"..tostring(self.TicksSinceSpoke))
			print(self:getName().."self.JustSpoke					=	"..tostring(self.JustSpoke))
			print(self:getName().."self.SayLine1					=	"..tostring(self.SayLine1))
			print(self:getName().."self.LastSurvivorSeen			=	"..tostring(self.LastSurvivorSeen))
			print(self:getName().."self.LastMemberSeen				=	"..tostring(self.LastMemberSeen))
			print(self:getName().."self.TicksAtLastDetectNoFood		=	"..tostring(self.TicksAtLastDetectNoFood))
			print(self:getName().."self.NoFoodNear					=	"..tostring(self.NoFoodNear))
			print(self:getName().."self.TicksAtLastDetectNoWater	=	"..tostring(self.TicksAtLastDetectNoWater))
			print(self:getName().."self.NoWaterNear					=	"..tostring(self.NoWaterNear))
			print(self:getName().."self.GroupRole					=	"..tostring(self.GroupRole))
			print(self:getName().."self.seenCount					=	"..tostring(self.seenCount))
			print(self:getName().."self.dangerSeenCount				=	"..tostring(self.dangerSeenCount))
			print(self:getName().."self.LastEnemeySeen				=	"..tostring(self.LastEnemeySeen))
			print(self:getName().."self.Container					=	"..tostring(self.Container))
			print(self:getName().."self.Room						=	"..tostring(self.Room))
			print(self:getName().."self.Building					=	"..tostring(self.Building))
			print(self:getName().."self.WalkingPermitted			=	"..tostring(self.WalkingPermitted))
			print(self:getName().."self.TargetBuilding				=	"..tostring(self.TargetBuilding))
			print(self:getName().."self.TargetSquare				=	"..tostring(self.TargetSquare))
			print(self:getName().."self.Tree						=	"..tostring(self.Tree))
			print(self:getName().."self.LastSquare					=	"..tostring(self.LastSquare))
			print(self:getName().."self.TicksSinceSquareChanged		=	"..tostring(self.TicksSinceSquareChanged))
			print(self:getName().."self.StuckDoorTicks				=	"..tostring(self.StuckDoorTicks))
			print(self:getName().."self.StuckCount					=	"..tostring(self.StuckCount))
			print(self:getName().."self.EnemiesOnMe					=	"..tostring(self.EnemiesOnMe))
			print(self:getName().."self.BaseBuilding				=	"..tostring(self.BaseBuilding))
			print(self:getName().."self.BravePoints					=	"..tostring(self.BravePoints))
			print(self:getName().."self.Shirt						=	"..tostring(self.Shirt))
			print(self:getName().."self.Pants						=	"..tostring(self.Pants))
			print(self:getName().."self.WasOnScreen					=	"..tostring(self.WasOnScreen))
			print(self:getName().."self.PathingCounter				=	"..tostring(self.PathingCounter))
			print(self:getName().."self.GoFindThisCounter			=	"..tostring(self.GoFindThisCounter))

			print("")
			print("")
			print("")

			print("")
			print("End of This Debug")
			print("----------------------------------------------------------------------------------------------------------")
			print("----------------------------------------------------------------------------------------------------------")
			print("")
			print("")
			print("")
				
		end
		
		self:Speak(text)
		
	end
end

-- Built for pursueTaskSE, to keep clean code
-- Set the local var debugging in function to 1 to enable superdebugging of the function
-- Otherwise the NPC will just say in game what the value is. I will create another option for this
function SuperSurvivor:zDebugSayPTSC(zTxtRef,zTxtRefNum)
	-- Exclusive function debugger- 	--
	-- -------------------------------- --
	-- 									--
	local Task_IsPursueSC_Debugging = 0	--
	-- 									--	
	-- --------------------------------	--
	
	if (Task_IsPursueSC_Debugging == 1) then 
		return self:Speak("zRangeToPursue "..tostring(zTxtRef).."= Reference Number PTSE_000"..zTxtRefNum)
	elseif (self:isSpeaking() == false) and (Task_IsPursueSC_Debugging == 2) then 
		return self:DebugSay("zRangeToPursue "..tostring(zTxtRef).."= Reference Number PTSE_000"..zTxtRefNum) 
	end
end	
--- END DEBUG ---

--- TASKS ---
-- TODO: create task for this
function SuperSurvivor:WearThis(ClothingItemName)
 
	 local ClothingItem
 
	 if(instanceof(ClothingItemName,"InventoryItem")) then 
		 ClothingItem = ClothingItemName
	 else 
		 ClothingItem = instanceItem(ClothingItemName) 
	 end
		
	 if not ClothingItem then 
		 return 
	 end
	 
	 self.player:getInventory():AddItem(ClothingItem)
 
	 if instanceof(ClothingItem, "InventoryContainer") and ClothingItem:canBeEquipped() ~= "" then
		 --self.player:setWornItem(ClothingItem:canBeEquipped(), ClothingItem);
		 self.player:setClothingItem_Back(ClothingItem)
		 getPlayerData(self.player:getPlayerNum()).playerInventory:refreshBackpacks();
		 --self.player:initSpritePartsEmpty();
	 elseif ClothingItem:getCategory() == "Clothing" then
		 if ClothingItem:getBodyLocation() ~= "" then
			 --print(ClothingItem:getDisplayName() .. " " ..tostring(ClothingItem:getBodyLocation()))
			 self.player:setWornItem(ClothingItem:getBodyLocation(), nil);
			 self.player:setWornItem(ClothingItem:getBodyLocation(), ClothingItem);
		 end
	 else
		 return
	 end
	 
	 self.player:initSpritePartsEmpty();
	 triggerEvent("OnClothingUpdated", self.player)
 
end
function SuperSurvivor:isInAction()

	if((self.player:getModData().bWalking == true) and (self.TicksSinceSquareChanged <= 10)) then
		return true 
	end
	
  local queue = ISTimedActionQueue.queues[self.player]
  if queue == nil then 
		return false 
	end

	for k=1, #queue.queue do
		local v = queue.queue[k]
        if v then 
			return true 
		end
  end
	
	return false;
		
end

-- Individual task checklist. This list is used to help for AI-manager lua to not be a clutter
-- TODO: remove it (its TMI responsability)
function SuperSurvivor:NPCTask_Clear()
	self:getTaskManager():clear()
end

function SuperSurvivor:NPCTask_DoAttack()
	if (self:getTaskManager():getCurrentTask() ~= "Attack") then
		self:getTaskManager():AddToTop(AttackTask:new(self))
	end
end
function SuperSurvivor:NPCTask_DoThreaten()
	if (self:getTaskManager():getCurrentTask() ~= "Threaten") then
		self:getTaskManager():AddToTop(ThreatenTask:new(self,self.LastEnemeySeen,"Scram"))
	end
end
function SuperSurvivor:NPCTask_DoWander()
	if (self:getTaskManager():getCurrentTask() ~= "Wander") then
		self:getTaskManager():AddToTop(WanderTask:new(self))
	end
end
function SuperSurvivor:NPCTask_DoFindUnlootedBuilding()
	if (self:getTaskManager():getCurrentTask() ~= "Find New Building") then
		self:getTaskManager():AddToTop(FindUnlootedBuildingTask:new(self))
	end
end
function SuperSurvivor:NPCTask_DoFleeFromHere()
	if (self:getTaskManager():getCurrentTask() ~= "Flee From Spot") or (self:getTaskManager():getCurrentTask() ~= "Flee") then	
		self:getTaskManager():AddToTop(FleeFromHereTask:new(self,self.player:getCurrentSquare()))
	end
end
function SuperSurvivor:NPCTask_DoFlee() -- Which is different from ^
	if (self:getTaskManager():getCurrentTask() ~= "Flee") or (self:getTaskManager():getCurrentTask() ~= "Flee From Spot") then	
		self:getTaskManager():AddToTop(FleeTask:new(self))
	end
end
function SuperSurvivor:Task_IsAttack()
	if (self:getTaskManager():getCurrentTask() == "Attack") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsThreaten()
	if (self:getTaskManager():getCurrentTask() == "Threaten") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsSurender()
	if (self:getTaskManager():getCurrentTask() == "Surender") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsDoctor()
	if (self:getTaskManager():getCurrentTask() == "Doctor") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsWander()
	if (self:getTaskManager():getCurrentTask() == "Wander") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsPursue()
	if (self:getTaskManager():getCurrentTask() == "Pursue") then
		return true
	else
		return false
	end
end
function SuperSurvivor:Task_IsFlee()
	return self:getTaskManager():getCurrentTask() ~= "Flee"
end
-- Test Functions
function SuperSurvivor:TMI_CTOneVar_IsNot(Var1)
	if (self:getTaskManager():getCurrentTask() ~= Var1) then
		return true
	end
end
function SuperSurvivor:Task_IsFleeFromSpot()
	if (self:getTaskManager():getCurrentTask() ~= "Flee From Spot") then
		return true
	end
end
function SuperSurvivor:Task_IsFleeOrFleeFromSpot()
	if (not (self:getTaskManager():getCurrentTask() == "Flee")) and (not (self:getTaskManager():getCurrentTask() == "Flee From Spot")) then
		return true
	end
end

--TODO : Create a IsAnyOf
-- NPC:TMI_CTFourVars_IsNot("Surender", "Flee", "Flee From Spot", "Clean Inventory")
function SuperSurvivor:TMI_CTFourVars_IsNot(Var1,Var2,Var3,Var4)
	if (self:getTaskManager():getCurrentTask() ~= Var1) 
	and (self:getTaskManager():getCurrentTask() ~= Var2)
	and (self:getTaskManager():getCurrentTask() ~= Var3)
	and (self:getTaskManager():getCurrentTask() ~= Var4)
	 then
		return true
	end
end

-- TODO: remove it
-- I'm tired of writing long precise 'ifs' so, Xor it is (IDK and IDC if that's what 'Xor' means.)
function SuperSurvivor:NPC_IFOD_Xor_BlockedDoor()
	if (self:inFrontOfLockedDoorAndIsOutside() == true) then
		return true
	elseif  (self:NPC_IFOD_BarricadedInside() == true) then
		return true
	else
		return false
	end
end

-- Super Function: Pursue_SC - Point system for the NPC to pursue a target.
-- Pursue, as far as I've seen, is used any time the NPC needs to reach their target, either it be zombie or human.
-- Todo: add self:RealCanSee(self.LastEnemeySeen) senses
function SuperSurvivor:NPC_CheckPursueScore()
	
	if (self.LastEnemeySeen ~= nil) then
	local zRangeToPursue = 2

		-- ------------------------------------  --
		-- Keep pursue from happening when 	
		-- lots of enemies the npc sees --		
		-- ------------------------------------  --		
		if (not self:getGroupRole() == "Companion") and ( ((self:getSeenCount() > 4) and (self:isEnemyInRange()) and (Enemy_Is_a_Zombie)) or (self:isTooScaredToFight()) ) then
			zRangeToPursue = 0
			self:zDebugSayPTSC(zRangeToPursue,"Fear_0")
			return zRangeToPursue	
		end

		if (self.LastEnemeySeen == nil) and (self.player == nil) then
			self:zDebugSayPTSC(zRangeToPursue,"0_CantFind")
			zRangeToPursue = 0
			return zRangeToPursue
		end	

		if (self:getTaskManager():getCurrentTask() == "Enter New Building") and not (self:RealCanSee(self.LastEnemeySeen)) then
			self:zDebugSayPTSC(zRangeToPursue,"0_EnteringNewBuilding")
			zRangeToPursue = 0
			return zRangeToPursue
		end

	
		local Enemy_Is_a_Zombie = (instanceof(self.LastEnemeySeen,"IsoZombie")) 
		local Enemy_Is_a_Human 	= (instanceof(self.LastEnemeySeen,"IsoPlayer")) 
		local Weapon_HandGun   	= self.player:getPrimaryHandItem()
		local NPCsDangerSeen   	= self:getDangerSeenCount()
		local Distance_AnyEnemy = getDistanceBetween(self.LastEnemeySeen,self.player)

		-- To make enemies stop chasing after their target cause too far away. 
		-- Unless you have a real reason, you wouldn't pursue a target forever.
		if (Distance_AnyEnemy > 10) and (self:RealCanSee(self.LastEnemeySeen)) then
			zRangeToPursue = 0
			return zRangeToPursue		
		end

		-- -------------------------------------- --
		--  Companion: They should always be cautious of their surroundings
		-- -------------------------------------- --
		if ((self:getGroupRole() == "Companion") and (self:isEnemyInRange(self.LastEnemeySeen))) then
			if getDistanceBetween(getSpecificPlayer(0),self.player) < 10 then
				zRangeToPursue = 5
				return zRangeToPursue
			end
			if getDistanceBetween(getSpecificPlayer(0),self.player) >= 10 then
				zRangeToPursue = 0
				return zRangeToPursue
			end
		end
		
		-- ------------------------ --
		-- Locked door checker 		--
		-- IFOD 'In front of door' 	--
		-- ------------------------ --
		if (self:enemyIsOutside()) and (self.player:isOutside())	then -- NPC's Target AND the NPC itself are Both OUT-SIDE
			self:zDebugSayPTSC(zRangeToPursue,"_door_1")
			zRangeToPursue = 6
			return zRangeToPursue
		end	
		if (not self:enemyIsOutside()) and (not self.player:isOutside()) then -- NPC's Target AND the NPC itself are Both INSIDE
			self:zDebugSayPTSC(zRangeToPursue,"_door_2")
			zRangeToPursue = 3
			return zRangeToPursue
		end	
		if ((not self:enemyIsOutside()) and (self.player:isOutside())) then 	-- NPC's Target Is Inside | NPC itself Is OUTSIDE		
			self:zDebugSayPTSC(zRangeToPursue,"_door_6")
			zRangeToPursue = 0
			return zRangeToPursue
		end			
		if (self:enemyIsOutside()) and (not self.player:isOutside())  then 	-- NPC's Target Is OUTSIDE | NPC itself Is Inside	
			self:zDebugSayPTSC(zRangeToPursue,"_door_7")
			zRangeToPursue = 1
			return zRangeToPursue
		end	
		
		-- -------------------------------------- -- 
		-- Gun Checker
		-- Don't add 'force reload' AI manager does this already
		-- -------------------------------------- --
		if (self:hasGun() == true) then
			self:zDebugSayPTSC(zRangeToPursue,"10")
			if (self:WeaponReady() == true) then
				self:zDebugSayPTSC(zRangeToPursue,"11")
				zRangeToPursue = 6
				return zRangeToPursue
				
			--elseif (self:WeaponReady() == false) then
			--	self:zDebugSayPTSC(zRangeToPursue,"11_A1")
			--	zRangeToPursue = 0
			--	return zRangeToPursue
			end
		end
		
		-- -------------------------------------- --
		-- Check if target is too far away 		
		-- We don't want the NPCs to spam this function if too far away, 
		-- so yes, we're double checking range. 
		-- IDEA: How ab out making this line option an in game option!
		-- -------------------------------------- --
		if (Distance_AnyEnemy >= 10) then 	
			self:zDebugSayPTSC(zRangeToPursue,"12_ToFarEnemy")
			zRangeToPursue = 0
			return zRangeToPursue
		end
		
		if (self:HasMultipleInjury()) and not (self:getGroupRole() == "Companion") then	-- Make the NPC not persist pursing until injuries are fixed
			self:zDebugSayPTSC(zRangeToPursue,"13_Injured_NonCompanion")
			zRangeToPursue = 0
			return zRangeToPursue
		end
	end
	
	-- This should keep the NPC from returning 0 when the local variable at top is 0
	if (self.LastEnemeySeen ~= nil) and (self.player ~= nil) and (zRangeToPursue == 0) then
		self:zDebugSayPTSC(zRangeToPursue,"LE_144")
		self.LastEnemeySeen = nil -- To force npc to stop pursuing the first target to re-scan
		return zRangeToPursue
	end

end

--- Checks if the current task is pursuing the last seen enemy
---@deprecated move it to TaskManager (or AIManager)
---@return boolean
function SuperSurvivor:Task_IsPursue_SC()
	local Enemy_Is_a_Zombie = (instanceof(self.LastEnemeySeen,"IsoZombie")) 
	local Enemy_Is_a_Human  = (instanceof(self.LastEnemeySeen,"IsoPlayer")) 

	
	if (self.LastEnemeySeen ~= nil) and (self.player ~= nil) then
		local Distance_AnyEnemy = getDistanceBetween(self.LastEnemeySeen,self.player)
		local zNPC_AttackRange  = self:isEnemyInRange(self.LastEnemeySeen)
		
		if (self:NPC_CheckPursueScore() > Distance_AnyEnemy ) then -- Task priority checker
			if (self:hasWeapon())
			--	and (self:Task_IsAttack() and (not zNPC_AttackRange)) 		
				and (not self:Task_IsThreaten())
				and (zNPC_AttackRange)
				and (not self:Task_IsPursue())
				and (not self:Task_IsSurender())
				and (self:Task_IsFlee())
				and (self:isWalkingPermitted())
				then
				self:DebugSay("Task_IsPursue_SC Is 'True', all conditions were met")
				return true
				else
				self:zDebugSayPTSC(self:NPC_CheckPursueScore(),"false_13")
				return false
			end	
		else
			self:zDebugSayPTSC(self:NPC_CheckPursueScore(),"false_14")
			return false
		end
	else
	--	Un-mark if you need to see if the NPCs aren't pursuing, to see if it's returning the 'final false'
	-- 	Otherwise NPCs will just spam this message infinitely
	--	self:zDebugSayPTSC(self:NPC_CheckPursueScore(),"false_15")
		return false
	end
end

--- sets the current task to @AttemptEntryIntoBuildingTask
---@return void
function SuperSurvivor:NPCTask_DoAttemptEntryIntoBuilding()
	self:NPC_ForceFindNearestBuilding()
	if(self.TargetSquare ~= nil) then
		if (self.player:isOutside()) then
			self:getTaskManager():AddToTop(AttemptEntryIntoBuildingTask:new(self, self.TargetBuilding))
			self:DebugSay("Do Attempt Entry into Building Triggered!")
		end
	end
end
function SuperSurvivor:Task_IsThreaten_Verify() -- You want this function to return 'true' 
	if (self.LastEnemeySeen ~= nil) then 

		local LES_GCS = self.LastEnemeySeen:getCurrentSquare()
		local distance = getDistanceBetween(self.player,self.LastEnemeySeen)
		
		if (self:Task_IsThreaten() == true) and (distance > 1)
			and ((self:enemyIsOutside()) and (self.player:isOutside()))
			or	((not self:enemyIsOutside()) and (not self.player:isOutside()))
		then
			self:DebugSay("Task_IsThreaten_Verify Returned TRUE")
			return true
		else
			self:DebugSay("Task_IsThreaten_Verify Returned FALSE")
			return false
		end
	else
		self:DebugSay("Task_IsThreaten_Verify Returned NIL")
		return false -- If LastEnemySeen is nil
	end
end
-- Function List for checking specific scenarios of NPC tasks
-- This one is for if the NPC is trying to get out or inside a building but can not
-- This **should** be the complete list of tasks that would get an npc stuck
function SuperSurvivor:NPC_TaskCheck_EnterLeaveBuilding()
	if
		(self:getTaskManager():getCurrentTask() ~= "Enter New Building") and			-- AttemptEntryIntoBuildingTask
		 (
			(self:getTaskManager():getCurrentTask() == "Find New Building") or			-- FindUnlootedBuildingTask
		--	(self:getTaskManager():getCurrentTask() == "Flee From Spot") or
			(self:getTaskManager():getCurrentTask() == "Wander In Area") or
			(self:getTaskManager():getCurrentTask() == "Wander In Base") or
			(self:getTaskManager():getCurrentTask() == "Loot Category") or
			(self:getTaskManager():getCurrentTask() == "Find Building") or
			(self:getTaskManager():getCurrentTask() == "Threaten") or
			(self:getTaskManager():getCurrentTask() == "Attack") or
			(self:getTaskManager():getCurrentTask() == "Pursue") or
		--	(self:getTaskManager():getCurrentTask() == "Wander") or
			(self:getTaskManager():getCurrentTask() == "Flee")
		 )
	then
		return true
	else
		return false
	end
	
end

-- This was built for getting away from zeds
-- This needed 'not a companion' check to keep the NPC in question not to run away when they're following main player.
function SuperSurvivor:NPC_FleeWhileReadyingGun()
	local Distance_AnyEnemy = getDistanceBetween(self.LastEnemeySeen,self.player)
	local Distance_MainPlayer = getDistanceBetween(getSpecificPlayer(0),self.player)
	local Enemy_Is_a_Zombie = (instanceof(self.LastEnemeySeen,"IsoZombie")) 
	local Enemy_Is_a_Human = (instanceof(self.LastEnemeySeen,"IsoPlayer")) 
	local Weapon_HandGun = self.player:getPrimaryHandItem()
	local NPCsDangerSeen = self:getDangerSeenCount()
	
	-- Ready gun, despite being an if statement, it's also running the code to make the gun ready.  
	if (self:hasGun() == true) then	
		if (self:getGroupRole() == "Random Solo") then -- Prevents any job classes from doing the following
			if (self:ReadyGun(Weapon_HandGun)) and (NPCsDangerSeen > 0) and (Enemy_Is_a_Zombie) then
				self:NPCTask_Clear()
				self:NPCTask_DoFlee()
			--	self:NPCTask_DoFleeFromHere()
				self:NPC_EnforceWalkNearMainPlayer()
				self:DebugSay("NPC_FleeWhileReadyingGun Triggered! Reference number NFWRG_0001")
			end
		end
	end
	if (self:getGroupRole() == "Companion") and (Distance_MainPlayer > 9) then
	--	self:NPCTask_Clear()
		self:getTaskManager():AddToTop(FollowTask:new(self,getSpecificPlayer(0)))
		self:DebugSay("NPC_FleeWhileReadyingGun - Companion - Too far away, enforcing follow! Reference number NFWRG_0002")
	end
	return true
end

function SuperSurvivor:SuitUp(SuitName)

		-- reset
		self.player:clearWornItems();
		self.player:getInventory():clear();

		self.player:setWornItem("Jacket", nil);
		
		-- Select the preset if applicable
		local tempTable = SurvivorRandomSuits["Preset"]

		if SuitName:contains("Preset_") then
			setRandomSurvivorSuit(self,"Preset",SuitName)
		-- Do the normal outfit selection otherwise
		else 
			getRandomSurvivorSuit(self)
		
			local hoursSurvived = math.min(math.floor(getGameTime():getWorldAgeHours() / 24.0), 28)
			local result = ZombRand(1, 72) + hoursSurvived
			
			if(result > 98) then -- 2% (at 28 days)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_SurvivorBag"))
			elseif(result > 96) then -- 2%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_ALICEpack"))
			elseif(result > 92) then -- 4%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_BigHikingBag"))
			elseif(result > 80) then -- 12%
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_NormalHikingBag"))
			elseif(result > 60) then -- 20% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_DuffelBag"))	
			elseif(result > 48) then -- 12% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_Schoolbag"))
			elseif(result > 36) then -- 12% / (12/72 or 16% at start)
				self.player:setClothingItem_Back(self.player:getInventory():AddItem("Base.Bag_Satchel"))
			end			
		end
end
-- TODO : this should be a Task 
function SuperSurvivor:CleanUp(percent)


	for i=0, BloodBodyPartType.MAX:index()-1 do
		
		local currentblood = self.player:getVisual():getBlood(BloodBodyPartType.FromIndex(i));
		self.player:getVisual():setBlood(BloodBodyPartType.FromIndex(i), (currentblood * percent)); -- always cut 10% off current amount 
	end
	
	local washList = {}
		if (self.player:getClothingItem_Feet() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Feet())
		end
		if (self.player:getClothingItem_Hands() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Hands())
		end
		if (self.player:getClothingItem_Head() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Head())
		end
		if (self.player:getClothingItem_Legs() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Legs())
		end
		if (self.player:getClothingItem_Torso() ~= nil) then
		
			table.insert(washList,self.player:getClothingItem_Torso())
		end
		if (self.player:getWornItem("Jacket") ~= nil) then
		
			table.insert(washList,self.player:getWornItem("Jacket"))
		end
		

	--for i,item in ipairs(washList) do
	for i=1, #washList do
		local item = washList[i]
		--print("wash loop: "..tostring(item))
		
		local blood
		if instanceof(item, "Clothing") then
			if BloodClothingType.getCoveredParts(item:getBloodClothingType()) then
                local coveredParts = BloodClothingType.getCoveredParts(item:getBloodClothingType())
				if(coveredParts ~= nil) then
					for j=0, coveredParts:size()-1 do
						local part = coveredParts:get(j);
						if(part ~= nil) then
							blood = item:getBlood(part);
							item:setBlood(part, (blood * percent));
						else
							--print("coveredParts(j) was nil")
						end
						
					end
				else
					--print("BloodClothingType.getCoveredParts was nil")
				end
			end
			
			local dirty = item:getDirtyness();
			item:setDirtyness(dirty * percent);
		
			if(blood) then
				if(blood < 0.1) then item:setBloodLevel(0)
				else item:setBloodLevel(blood * percent) end
			end
		end
	end
	
	self.player:resetModel();

end
--- END TASKS ---
 
--- VISION ---
function SuperSurvivor:getSeenCount()
	return self.seenCount
end
function SuperSurvivor:getDangerSeenCount()
	return self.dangerSeenCount
end

function SuperSurvivor:RealCanSee(character)
	
	if(character:isZombie()) then return (self.player:CanSee(character)) end -- normal vision for zombies (they are not quiet or sneaky)
	
	local visioncone = SurvivorVisionCone
	if(character:isSneaking()) then visioncone = visioncone - 0.15 end
	return (self.player:CanSee(character) and (self.player:getDotWithForwardDirection(character:getX(),character:getY()) + visioncone) >= 1.0 ) 						

end

function SuperSurvivor:DoVision()

	local atLeastThisClose = 19;
	local spottedList = self.player:getCell():getObjectList()
	--local closestSoFar = 200
	local closestSoFar = 25
	--local closestSurvivorSoFar = 200
	local closestSurvivorSoFar = 25
	self.seenCount = 0
	self.dangerSeenCount = 0
	self.EnemiesOnMe = 0
	self.LastEnemeySeen = nil
	self.LastSurvivorSeen = nil
	local dangerRange = 6
	if self.AttackRange > dangerRange then dangerRange = self.AttackRange end
	
	local closestNumber = nil
	local tempdistance = 1
	
	
	if(spottedList ~= nil) then
		for i=0, spottedList:size()-1 do
			local character = spottedList:get(i);
			if(character ~= nil) and (character ~= self.player) and (instanceof(character,"IsoZombie") or instanceof(character,"IsoPlayer")) then
			
				if (character:isDead() == false) then
					tempdistance = tonumber(getDistanceBetween(character,self.player))
					
					if( (tempdistance <= atLeastThisClose) and self:isEnemy(character) ) then	
					
						local CanSee = self:RealCanSee(character)
						
						if(tempdistance < 1) and (character:getZ() == self.player:getZ()) then 
							self.EnemiesOnMe = self.EnemiesOnMe + 1 
						end
						if(tempdistance < dangerRange) and (character:getZ() == self.player:getZ()) then
							--if (character:CanSee(self.player)) and (self:isInSameRoom(character) or (tempdistance <= 1)) then 
								self.dangerSeenCount = self.dangerSeenCount + 1 
							--end 
						end
						if(CanSee) then 
							self.seenCount = self.seenCount + 1 
						end
						if( ( CanSee or (tempdistance < 0.5)) and (tempdistance < closestSoFar) ) then
							closestSoFar = tempdistance ;
							self.player:getModData().seenZombie = true;
							closestNumber = i;							
						end
						
					elseif( tempdistance < closestSurvivorSoFar ) and false then
						closestSurvivorSoFar = tempdistance
						self.LastSurvivorSeen = character						
					end
				end
				
			end
		end
	end
		
	if(closestNumber ~= nil) then 
		self.LastEnemeySeen = spottedList:get(closestNumber)
		
		return self.LastEnemeySeen
	end
	
end

function SuperSurvivor:isOnScreen()	
	if(self.player:getCurrentSquare() ~= nil) and (self.player:getCurrentSquare():IsOnScreen()) then 
		return true
	else 
		return false
	end	
end

function SuperSurvivor:isInCell()	
	if(self.player == nil) or (self.player:getCurrentSquare() == nil) or (self:isDead()) then return false
	else return true end	
end

-- Come to think of it, this function could be cloned to find windows/doors if done right......
-- This function is to keep companions from being snuck upon. It's a little OP, but it's also preventing situations like
-- 'Oh I'm trying to fight a NPC I'm stuck on, oh no a zombie behind me and I could clearly hear it? Oh well...' THIS function prevents cases like THAT.
-- Also I believe since the self.seencount and other variables that 'reset to 0' is marked off, maybe helping as to why this function's working so cleverly.
function SuperSurvivor:Companion_DoSixthSenseScan()

	local atLeastThisClose = 3;
	local spottedList = self.player:getCell():getObjectList()
	local closestSoFar = 4
	local closestSurvivorSoFar = 4

	local dangerRange = 2
		
	if (self:getGroupRole() == "Companion") then 
		atLeastThisClose = 5
		closestSoFar = 10
		closestSurvivorSoFar = 10
		dangerRange = 3
		self.dangerSeenCount = 0
		self.EnemiesOnMe = 0
	end	

	local closestNumber = nil
	local tempdistance = 1
	
	
	if(spottedList ~= nil) then
		for i=0, spottedList:size()-1 do
			local character = spottedList:get(i);
			if(character ~= nil) and (character ~= self.player) and (instanceof(character,"IsoPlayer")) or (instanceof(character,"IsoZombie")) then
			
				if (character:isDead() == false) then
					tempdistance = tonumber(getDistanceBetween(character,self.player))
					
					if( (tempdistance <= atLeastThisClose) and self:isEnemy(character) ) then	
					
						local CanSee = self:RealCanSee(character)
						
						-- Melee scan
						if(tempdistance < 1) and (not (self:usingGun())) and (character:getZ() == self.player:getZ()) then 
							self.EnemiesOnMe = self.EnemiesOnMe + 1 
						end
						
						-- Gun Scan
						if(tempdistance < 2) and (self:usingGun()) and (character:getZ() == self.player:getZ()) then 
							self.EnemiesOnMe = self.EnemiesOnMe + 1 
						end

						if(self:getGroupRole() == "Companion") and (tempdistance < dangerRange) and (character:getZ() == self.player:getZ()) then
							self.dangerSeenCount = self.dangerSeenCount + 1
							self:DebugSay("self.dangerSeenCount = "..tostring(self.dangerSeenCount))
						end

						if(not CanSee) then -- added 'not' to it so enemy can sense behind them for a moment
							self.seenCount = self.seenCount + 1 
						end

						if( (not CanSee)  and (tempdistance < closestSoFar) ) then
							closestSoFar = tempdistance ;
							self.player:getModData().seenZombie = true;
							closestNumber = i;							
						end
						
					elseif( tempdistance < closestSurvivorSoFar ) and false then
						closestSurvivorSoFar = tempdistance
						self.LastSurvivorSeen = character						
					end
				end
				
			end
		end
	end
	
	-- This only tells the other function there's a enemy nearby as long as the npc isn't stuck in front of a blocked off door
	if(closestNumber ~= nil) then 
		self.LastEnemeySeen = spottedList:get(closestNumber)
		return self.LastEnemeySeen
	end
	
end

-- This function is still in testing. It's basically 'dovision' but re-functioned to find the closest hostile the npc can find, that is a human only.
-- DO *NOT* put this in update() function or anything similar. This is supposed to be exclusively to make dopursuealt work.
-- And to attempt-fix a situation where the player can walk behind the NPC mid-attack and the npc suddenly forgetting about the player.
-- Update: BE VERY CAREFUL using this. It will overwrite Dovision. This is using for bandits to keep up with the main player.
function SuperSurvivor:DoHumanEntityScan()

	local atLeastThisClose = 5;
	local spottedList = self.player:getCell():getObjectList()
	local closestSoFar = 6
	local closestSurvivorSoFar = 6

	local dangerRange = 6
	if self.AttackRange > dangerRange then dangerRange = self.AttackRange end
	
	local closestNumber = nil
	local tempdistance = 1
		
	if(spottedList ~= nil) then
		for i=0, spottedList:size()-1 do
			local character = spottedList:get(i);
			if(character ~= nil) and (character ~= self.player) and (instanceof(character,"IsoPlayer")) and not (instanceof(character,"IsoZombie")) then
			
				if (character:isDead() == false) then
					tempdistance = tonumber(getDistanceBetween(character,self.player))
					
					if( (tempdistance <= atLeastThisClose) and self:isEnemy(character) ) then	
					
						local CanSee = self:RealCanSee(character)
						
						--if(tempdistance < 1) and (character:getZ() == self.player:getZ()) then 
						--	self.EnemiesOnMe = self.EnemiesOnMe + 1 
						--end
						-- Removed: The sixth sense and dovision does this well enough. this would just stack numbers infinitely
						--if(tempdistance < dangerRange) and (character:getZ() == self.player:getZ()) then
						--	self.dangerSeenCount = self.dangerSeenCount + 1 
						--end
						if(not CanSee) or (CanSee) then -- added 'not' to it so enemy can sense behind them for a moment
							self.seenCount = self.seenCount + 1 
						end
						if( ( ((not CanSee) or (CanSee)) or (tempdistance < 3.5)) and (tempdistance < closestSoFar) ) then
							closestSoFar = tempdistance ;
							self.player:getModData().seenZombie = true;
							closestNumber = i;							
						end
						
					elseif( tempdistance < closestSurvivorSoFar ) and false then
						closestSurvivorSoFar = tempdistance
						self.LastSurvivorSeen = character						
					end
				end
				
			end
		end
	end
	
	-- This only tells the other function there's a enemy nearby as long as the npc isn't stuck in front of a blocked off door
	if(closestNumber ~= nil) then 
		self.LastEnemeySeen = spottedList:get(closestNumber)
		
		return self.LastEnemeySeen
	end
	
end
--- END VISION ---

--- UPDATE ---

function SuperSurvivor:Get()
	return self.player
end

--- Set WaitTicks
---@param ticks integer
---@return void
function SuperSurvivor:Wait(ticks)
	self.WaitTicks = ticks
end

function SuperSurvivor:updateTime()
		self:renderName()
		self.Reducer = self.Reducer + 1 
	
	if(self.Reducer % 20 == 0) then 
		if(self.WaitTicks == 0) then
			return true
		else
			self.WaitTicks = self.WaitTicks - 1
			return false
		end
	else return false end
end

function SuperSurvivor:update()
	
	if(self:isDead()) then 
		
		return false
	end
	
	self:DoVision()
	
	-- I know this is 'not companion' but the function works almost too well not to use.
	if (Option_Perception_Bonus == 2) then	-- The in game option from supersurvivorsmod.lua and to keep it from scanning infinitely
		if (not (self:getGroupRole() == "Companion")) then 		-- See how this line is? this is the ONLY WAY I could get the follower to accept 'is not a follower'. I'm bad at math logic.
			self:Companion_DoSixthSenseScan() 
		end
	end
	
	self.player:setBlockMovement(true)
	
	--self:CleanUp(0.988); -- slowly reduces current blood/dirt by this percent - Ryuu: I have no idea why this is marked out. Guessing it didn't work?
	
	self.TriggerHeldDown = false
	if(not SurvivorHunger) then						-- removed 'not' for update
		self.player:getStats():setThirst(0.0)
		self.player:getStats():setHunger(0.0)	
	--else
		--self.player:getStats():setThirst(self.player:getStats():getThirst() + 0.00005) -- survivor thirst does not move so manually incremnt it
	elseif (not self:isInBase()) then
		-- dont get hungry outside of base, to prevent infinite search loops
		-- TODO : fix it
		--self.player:getStats():setThirst(0.0)
		--self.player:getStats():setHunger(0.0)	
	end
	
	--control of unmanaged stats
	self.player:getNutrition():setWeight(85);
	self.player:getBodyDamage():setSneezeCoughActive(0);	
	self.player:getBodyDamage():setFoodSicknessLevel(0);	
	self.player:getBodyDamage():setPoisonLevel(0);	
	self.player:getBodyDamage():setUnhappynessLevel(0);		
	self.player:getBodyDamage():setHasACold(false);		
	self.player:getStats():setFatigue(0.0);	
	self.player:getStats():setIdleboredom(0.0);
	self.player:getStats():setMorale(0.5);
	self.player:getStats():setStress(0.0);
	self.player:getStats():setSanity(1);
	
	if (not SurvivorsFindWorkThemselves) then
		self.player:getStats():setBoredom(0.0);
	end
	if (not RainManager.isRaining()) or (not self.player:isOutside()) then
		self.player:getBodyDamage():setWetness(self.player:getBodyDamage():getWetness() - 0.1);
	end
	
	if(self.player:isOnFire()) then 
		self.player:getBodyDamage():RestoreToFullHealth() -- temporarily give some fireproofing as they walk right through fire via pathfinding
		self.player:setFireSpreadProbability(0); -- give some fireproofing as they walk right through fire via pathfinding	
	end
	

	if (self.TargetSquare ~= nil and self.TargetSquare:getZ() ~= self.player:getZ() and getGameSpeed() > 2) then
		self:DebugSay("DANGER ZONE 2: " .. self:getName());
		self.TargetSquare = nil
		self:DebugSay("Update() is about to trigger a StopWalk!")
		self:StopWalk()
		self:Wait(10)
	end

	self:CheckForIfStuck() -- New function to cleanup the update() function
	self:NPCcalculateWalkSpeed()
	--self:DoVision()
	if (not getSpecificPlayer(0):isAsleep()) and (self:getGroupRole() ~= "Random Solo") then
		self.MyTaskManager:update()
	end

	if(self.Reducer % 480 == 0) then 
		self:setSneaking(false)
		
		self.player:setNPC(true)
		
		local group = self:getGroup()
		if(group) then group:checkMember(self:getID()) end
			self:SaveSurvivor()
			if(self:Get():getPrimaryHandItem() ~= nil) and (((self:Get():getPrimaryHandItem():getDisplayName()=="Corpse") and (self:getCurrentTask() ~= "Pile Corpses")) or (self:Get():getPrimaryHandItem():isBroken()) ) then
				ISTimedActionQueue.add(ISDropItemAction:new(self:Get(),self:Get():getPrimaryHandItem(),30))
				self:Get():setPrimaryHandItem(nil)
				self:Get():setSecondaryHandItem(nil)
			end
			if(self:Get():getPrimaryHandItem() == nil) and (self:getWeapon()) then 
				self:Get():setPrimaryHandItem(self:getWeapon()) 
			end
			self:ManageXP()
			
			self.player:getModData().hitByCharacter = false
			self.player:getModData().semiHostile = false	
			self.player:getModData().felldown = nil	
	else 
		self:SaveSurvivorOnMap() 
	end
	
	if( self.GoFindThisCounter > 0 ) then 
		self.GoFindThisCounter = self.GoFindThisCounter -1 
	end
end

function SuperSurvivor:PlayerUpdate()

	if(not self.player:isLocalPlayer()) then
	
		if(self.TriggerHeldDown) and (self:canAttack()) and (not (self:hasGun())) then -- simulate automatic weapon fire
			self:NPC_Attack(self.LastEnemeySeen)
		end
		if(self.TriggerHeldDown) and (self:canAttack()) and (self:hasGun()) then -- simulate automatic weapon fire
			self:Attack(self.LastEnemeySeen)
		end
		
		if(self.player:getLastSquare() ~= nil ) then
			local cs = self.player:getCurrentSquare()
			local ls = self.player:getLastSquare()
			local tempdoor = ls:getDoorTo(cs);
			if(tempdoor ~= nil and tempdoor:IsOpen() ) then
				 tempdoor:ToggleDoor(self.player);
				
			end		
		end
		
		self:WalkToUpdate(self.player)
		
	end
	
end

function SuperSurvivor:OnDeath()
	print(self:getName() .. " has died")

	local ID = self:getID()
	SSM:OnDeath(ID)
	
	SurvivorLocX[ID] = nil
	SurvivorLocY[ID] = nil
	SurvivorLocZ[ID] = nil
	if(self.player:getModData().LastSquareSaveX ~= nil) then
		local lastkey = self.player:getModData().LastSquareSaveX .. self.player:getModData().LastSquareSaveY .. self.player:getModData().LastSquareSaveZ
		if(lastkey) and ( SurvivorMap[lastkey] ~= nil ) then
			table.remove(SurvivorMap[lastkey] , ID)
		end 
	end
end

function SuperSurvivor:ManageXP()

	local currentLevel
	local currentXP,XPforNextLevel
	local ThePerk
	for i=1, #SurvivorPerks do
		ThePerk = Perks.FromString(SurvivorPerks[i])
		if(ThePerk) then
			
			currentLevel = self.player:getPerkLevel(ThePerk)
			currentXP = self.player:getXp():getXP(ThePerk)
			XPforNextLevel = self.player:getXpForLevel(currentLevel+1)
			local display_perk = PerkFactory.getPerkName(Perks.FromString(SurvivorPerks[i]))
			--print(tostring(self:getName())..tostring(display_perk).." - "..tostring(currentXP).."/"..tostring(XPforNextLevel))
			if(currentXP >= XPforNextLevel) and (currentLevel < 10) then 
				self.player:LevelPerk(ThePerk)
				
				
				if( string.match(SurvivorPerks[i], "Blade") ) or ( SurvivorPerks[i] == "Axe" ) then
					display_perk = getText("IGUI_perks_Blade") .. " " .. display_perk
				elseif( string.match(SurvivorPerks[i], "Blunt") ) then
					display_perk = getText("IGUI_perks_Blunt") .. " " .. display_perk
				end
				
				self:RoleplaySpeak(getActionText("PerkLeveledUp_Before")..tostring(display_perk)..getActionText("PerkLeveledUp_After"))
			end
			--if(SurvivorPerks[i] == "Aiming") then self.player:Say(tostring(currentXP).."/"..tostring(XPforNextLevel)) end
		end
	end

end

function SuperSurvivor:reload()
	local cs = self.player:getCurrentSquare()
	local id = self:getID()
	self:delete()
	self.player = self:spawnPlayer(cs,nil)
	self:loadPlayer(cs,id)
end
--- END UPDATE ---

--- HEALTH ---
function SuperSurvivor:HasMultipleInjury()

	local bodyparts = self.player:getBodyDamage():getBodyParts()
	local total = 0
	for i=0, bodyparts:size()-1 do

		local bp = bodyparts:get(i)
		if(bp:HasInjury()) and (bp:bandaged() == false) then
			total = total + 1
			if(total > 1) then break end
		end
		
	end
	
	return (total > 1)

end
function SuperSurvivor:HasInjury()

	local bodyparts = self.player:getBodyDamage():getBodyParts()
	
	for i=0, bodyparts:size()-1 do

		local bp = bodyparts:get(i)
		if(bp:HasInjury()) and (bp:bandaged() == false) then
			return true
		end
		
	end
	
	return false

end
--- END HEALTH ---

--- SAVEFILES --- 
function SuperSurvivor:getID()

	if(instanceof(self.player,"IsoPlayer")) then return self.player:getModData().ID 
	else return 0 end

end
function SuperSurvivor:setID(id)
	self.player:getModData().ID = id;
end

--- TODO : move these functions to SuperSurvivorManager

--- deletes everything from the survivor and removes it
function SuperSurvivor:delete()

	self.player:getInventory():emptyIt();
	self.player:setPrimaryHandItem(nil);
	self.player:setSecondaryHandItem(nil);
	self:setID(0)

	local filename = getSaveDir() .. "SurvivorTemp";
	self.player:save(filename);
	self.player:removeFromWorld()
	self.player:removeFromSquare()
	self.player = nil;
	
end

function SuperSurvivor:SaveSurvivorOnMap()
	local level = SurvivorDebugEnum.Other
	logSurvivorFunction(level,"SaveSurvivorOnMap")

	if self.player:getModData().RealPlayer == true then 
		logSurvivorLog(level,"main player not saved")
		logSurvivorFunction(level,"SaveSurvivorOnMap")
		return
	end

	local ID = self.player:getModData().ID;
	
	if (ID ~= nil) then
		logSurvivorValues(level,"survivor id", ID)

		local x = math.floor(self.player:getX())
		local y = math.floor(self.player:getY())
		local z = math.floor(self.player:getZ())
		local key = x .. y .. z

		if(not SurvivorMap[key]) then 
			SurvivorMap[key] = {} 
		end
		
		SurvivorLocX[ID] = x
		SurvivorLocY[ID] = y
		SurvivorLocZ[ID] = z
		if (has_value(SurvivorMap[key],ID) == false) then
			
			local removeFailed = false;
			if(self.player:getModData().LastSquareSaveX ~= nil) then
				local lastkey = self.player:getModData().LastSquareSaveX .. self.player:getModData().LastSquareSaveY .. self.player:getModData().LastSquareSaveZ
				logSurvivorLog(level,"removing old position save",lastkey)
				
				if(lastkey) and (SurvivorMap[lastkey] ~= nil) then
					table.remove(SurvivorMap[lastkey] , ID);
					logSurvivorLog(level,"old position removed")
				else 
					removeFailed = true;
					logSurvivorLog(level,"old position not removed")
				end
			end
			
			if(removeFailed == false) then
				logSurvivorLog(level,"saving new position",key)
				table.insert(SurvivorMap[key], ID);			
				self.player:getModData().LastSquareSaveX = x;
				self.player:getModData().LastSquareSaveY = y;
				self.player:getModData().LastSquareSaveZ = z;
			end
		end
	else
		logSurvivorLog(level,"survivor without id")
	end

	logSurvivorFunction(level,"SaveSurvivorOnMap")
end

function SuperSurvivor:SaveSurvivor()
	local level = SurvivorDebugEnum.Other
	logSurvivorFunction(level,"SaveSurvivor")
	if self.player:getModData().RealPlayer == true then 
		logSurvivorLog(level,"main player not saved")
		logSurvivorFunction(level,"SaveSurvivor")
		return 
	end
	
	local ID = self.player:getModData().ID;
	if(ID ~= nil) then
		local filename = getSaveDir() .. "Survivor"..tostring(ID);
		self.player:save(filename);
		logSurvivorValues(level, "saved survivor", ID)
		
		if(self.player ~= nil and self.player:isDead() == false ) then
			logSurvivorLog(level,"survivor", ID ,"is alive")
			self:SaveSurvivorOnMap()		
		else			
			local group = self:getGroup()
			if(group) then 
				logSurvivorLog(level,"survivor", ID ,"is dead")
				group:removeMember(self) 
			end
		end
	end
	logSurvivorFunction(level,"SaveSurvivor")
end

--- loads a survivor 
--- It doesnt use "self" variable so it can be moved to other file 
---@param square any the square that the survivor will be loaded
---@param ID any the ID of the survivor (needs to be inside the savefiles)
---@return table returns Survivor if the file exists
function SuperSurvivor:loadPlayer(square, ID)
	local level = SurvivorDebugEnum.Other
	logSurvivorFunction(level,"loadPlayer")
	-- load from file if save file exists
	if(ID == nil) or (not checkSaveFileExists("Survivor"..tostring(ID))) then
		logSurvivorError(level,"survivor with id " .. ID .. " not found")
		logSurvivorFunction(level,"loadPlayer")
		return nil
	else	
		local BuddyDesc = SurvivorFactory.CreateSurvivor();
		local Buddy = IsoPlayer.new(getWorld():getCell(),BuddyDesc,square:getX(),square:getY(),square:getZ());

		Buddy:getInventory():emptyIt();
		local filename = getSaveDir() .. "Survivor"..tostring(ID);
		Buddy:load(filename);
		
		Buddy:setX(square:getX())
		Buddy:setY(square:getY())
		Buddy:setZ(square:getZ())
		Buddy:getModData().ID = ID
		Buddy:setNPC(true);
		Buddy:setBlockMovement(true)
		Buddy:setSceneCulled(false)

		logSurvivorSpawnInfo(Buddy)
		logSurvivorPosition(Buddy)

		logSurvivorFunction(level,"loadPlayer")
		return Buddy
	end
end

--- respawn the survivor with the same things 
function SuperSurvivor:reload()
	local level = SurvivorDebugEnum.Spawn

	logSurvivorFunction(level, "reload")
	local cs = self.player:getCurrentSquare()
	local id = self:getID()
	logSurvivorValues(level, "survivor id",id)

	self:delete()

	self.player = self:spawnPlayer(cs,nil)
	self:loadPlayer(cs,id)

		logSurvivorFunction(level, "reload")
end
--- END SAVEFILES ---

function SuperSurvivor:findNearestSheetRopeSquare(down)

	local sq, CloseSquareSoFar;
		local range = 20
		local minx=math.floor(self.player:getX() - range);
		local maxx=math.floor(self.player:getX() + range);
		local miny=math.floor(self.player:getY() - range);
		local maxy=math.floor(self.player:getY() + range);
		local closestSoFar = 999;
		
		for x=minx, maxx do
			for y=miny, maxy do
				sq = getCell():getGridSquare(x,y,self.player:getZ());
				if(sq ~= nil) then
					local distance = getDistanceBetween(sq,self.player)
				
					if down and (distance < closestSoFar) and self.player:canClimbDownSheetRope(sq) then
						closestSoFar = distance
						CloseSquareSoFar = sq
					elseif not down and (distance < closestSoFar) and self.player:canClimbSheetRope(sq) then
						closestSoFar = distance
						CloseSquareSoFar = sq
					end
				
				end
			end
		end
		
	return CloseSquareSoFar
end

function SuperSurvivor:isAmmoForMe(itemType)

	if(self.AmmoTypes) and (#self.AmmoTypes > 0) then		
		for i=1, #self.AmmoTypes do		
			if(itemType == self.AmmoTypes[i]) then return true end
		end	
	end
	if(self.AmmoBoxTypes) and (#self.AmmoBoxTypes > 0) then		
		for i=1, #self.AmmoBoxTypes do		
			if(itemType == self.AmmoBoxTypes[i]) then return true end
		end	
	end
		-- AmmoTypesBox
	return false

end

--- func desc
--- TODO : this should be moved to the find Task
---@param itemType any
---@param TypeOrCategory any
function SuperSurvivor:FindThisNearBy(itemType, TypeOrCategory)
				
	if(self.GoFindThisCounter > 0) then return nil end
	
	self.GoFindThisCounter = 10;
	local sq, itemtoReturn;
	local range = 30
	--local minx=math.floor(self.player:getX() - range);
	--local maxx=math.floor(self.player:getX() + range);
	--local miny=math.floor(self.player:getY() - range);
	--local maxy=math.floor(self.player:getY() + range);
	local closestSoFar = 999;
	if(self.player:getZ() > 0) or (getCell():getGridSquare(self.player:getX(),self.player:getY(),self.player:getZ() + 1) ~= nil) then
		zhigh = self.player:getZ() + 1
	else
		zhigh = 0
	end
	
	--print("find " .. itemType)
	for z=0, zhigh do
		--for x=minx, maxx do
		--	for y=miny, maxy do
		local spiral = SpiralSearch:new(self.player:getX(), self.player:getY(), range)
		local x, y
		--print(spiral:forMax())

		for i = spiral:forMax(), 0, -1 do
					
			x = spiral:getX()
			y = spiral:getY()
			--print(x .. ", " .. y)

			sq = getCell():getGridSquare(x,y,z);
			if(sq ~= nil) then
				local tempDistance = 0--getDistanceBetween(sq,self.player)
				if (self.player:getZ() ~= z) then tempDistance = tempDistance + 10 end
				local items = sq:getObjects()
				-- check containers in square
				--print(items:size() .. " objects")
				for j=0, items:size()-1 do
					--print(tostring(items:get(j):getObjectName())..":"..tostring(items:get(j):getContainer())..","..tostring(items:get(j):hasWater()))
					if(items:get(j):getContainer() ~= nil) then
						local container = items:get(j):getContainer()
						--print("container with " ..tostring(container:getCapacity()))
						
						if(sq:getZ() ~= self.player:getZ()) then tempDistance = tempDistance + 13 end
						
						local FindCatResult
						--if(itemType == "Food") then 
						--	FindCatResult = FindAndReturnBestFood(container)
						--else 
							FindCatResult = FindItemByCategory(container, itemType, self) 
						--end
						--print("FindCatResult: " .. tostring(FindCatResult))
						
						if(tempDistance<closestSoFar) 
							and (
								(TypeOrCategory == "Category")
								and (FindCatResult ~= nil)
							) or (
								(TypeOrCategory == "Type")
								and (container:FindAndReturn(itemType)) ~= nil
							) then
							
							if (TypeOrCategory == "Category")  then
								itemtoReturn = FindCatResult
							else
								itemtoReturn = container:FindAndReturn(itemType)
							end

							if itemtoReturn:isBroken() then
								itemtoReturn = nil
							else
								closestSoFar = tempDistance
							end
							
						end	
					elseif(itemType == "Water") and (items:get(j):hasWater()) and (tempDistance<closestSoFar) then
						itemtoReturn = items:get(j)
						closestSoFar = tempDistance
					elseif(itemType == "WashWater")
							and (items:get(j):hasWater()) 
							and (items:get(j):getWaterAmount() > 5000 or items:get(j):isTaintedWater())
							and (tempDistance<closestSoFar) then
						itemtoReturn = items:get(j)
						closestSoFar = tempDistance
					end
				end	
				
				-- check floor
				if itemtoReturn ~= nil then
					self.TargetSquare = sq
				else
					if (itemType == "Food") then
						local item = FindAndReturnBestFoodOnFloor(sq, self)

						if (item ~= nil) then
							itemtoReturn = item
							closestSoFar = tempDistance
							self.TargetSquare = sq
						end
					else
						items = sq:getWorldObjects()
						--print("Checking " .. tostring(items:size()) .. " world objects.")
						for j=0, items:size()-1 do
							if(items:get(j):getItem()) then
								local item = items:get(j):getItem()
								--print(tostring(item:getType()).."("..tostring(item:isBroken()).."/"..tostring(item:getCondition()).."):"..itemType)
								if (tempDistance < closestSoFar) and 
								(item ~= nil) and 
								(not item:isBroken()) and
								(
									((TypeOrCategory == "Category") and (hasCategory(item,itemType))) or 
									((TypeOrCategory == "Type") and (tostring(item:getType()) == itemType or tostring(item:getName()) == itemType))
								) then
									--print("hit "..tempDistance)
									itemtoReturn = item
									closestSoFar = tempDistance
									self.TargetSquare = sq
								end
							end
						end
					end
				end
			
				
				
			end

			if (self.TargetSquare ~= nil and itemtoReturn ~= nil) then
				break
			end

			spiral:next()
			
		end
		--	end						
		--end

		if (self.TargetSquare ~= nil and itemtoReturn ~= nil) then
			break
		end
	end
		
	if(self.TargetSquare ~= nil and itemtoReturn ~= nil) and (self.TargetSquare:getRoom()) and (self.TargetSquare:getRoom():getBuilding()) then 
		self.TargetBuilding = self.TargetSquare:getRoom():getBuilding() 
		--print("target building set")
	end
	return itemtoReturn
			
end

function SuperSurvivor:ensureInInv(item)

	if(self:getBag():contains(item)) then self:getBag():Remove(item) end
	if(item:getWorldItem() ~= nil) then
		item:getWorldItem():removeFromSquare()
		item:setWorldItem(nil)
	end
	if(not self:Get():getInventory():contains(item)) then self:Get():getInventory():AddItem(item) end

	return item
end

------------------armor mod functions-------------------

function SuperSurvivor:getUnEquipedArmors()

	local armors = {}
	local inv = self.player:getInventory()
	local items = inv:getItems()
	
	for i=1, items:size()-1 do
		local item = items:get(i)
		--if item ~= nil then print ("checking: "..tostring(item:getDisplayName()) .. "/" .. tostring(item:getCategory()) .. "/" .. tostring(item:isEquipped())) end
		if item ~= nil and ((item:getCategory() == "Clothing") or (item:getCategory() == "Container" and item:getWeight() > 0) ) and item:isEquipped() == false then 
			table.insert(armors,item) 
			--print("added "..item:getDisplayName() .. " to table")
			--getSpecificPlayer(0):Say("added "..item:getDisplayName() .. " to table")
		end
	end

	return armors
end
