require "SuperSurvivorGroup"

---@type SuperSurvivorGroupManager
SuperSurvivorGroupManager = {}
SuperSurvivorGroupManager.__index = SuperSurvivorGroupManager

--- START ---

--- creates a new Group Manager
---@return SuperSurvivorGroupManager
function SuperSurvivorGroupManager:new()
	---@type SuperSurvivorGroupManager
	local o = {}
	setmetatable(o, self)
	self.__index = self

	o.Groups = {}
	o.GroupCount = 0

	return o
end

--- creates a new group with a new id
---@return SuperSurvivorGroup
function SuperSurvivorGroupManager:newGroup()
	--self:Print()

	local groupID = self.GroupCount
	for i=0, self.GroupCount do
		if(self.Groups[i]) and (self.Groups[i]:getID() >= groupID) then
			groupID = self.Groups[i]:getID() + 1
		end
	end

	--print("created new group with ID of " .. tostring(groupID))
	self.Groups[groupID] = SuperSurvivorGroup:new(groupID)
	self.GroupCount = groupID + 1
	return self.Groups[groupID]
end

--- END START ---

--- GROUPS ---

--- gets a group by id
---@param thisID number
---@return SuperSurvivorGroup
function SuperSurvivorGroupManager:Get(thisID)
	return self.Groups[thisID]
end

--- gets the id from a group that owns a square
---@param square IsoGridSquare
---@return number returns the id of the group or -1 if the square doesn't belong to a group
function SuperSurvivorGroupManager:GetGroupIdFromSquare(square)
	for i=0, self.GroupCount do		
		if (self.Groups[i]) and (self.Groups[i]:IsInBounds(square)) then
			return self.Groups[i]:getID()
		end
	end
	return -1
end

--- returns the amount of existing groups
---@return number
function SuperSurvivorGroupManager:getCount()
	return self.GroupCount
end
--- END GROUPS ---

--- DEBUG ---

--- prints information of every group and the total of groups
---@return void
function SuperSurvivorGroupManager:Print()
	print("printing groups, groupcount:"..tostring(self.GroupCount))
	for i=0, self.GroupCount do
		if(self.Groups[i]) then
			self.Groups[i]:Print()
		end
	end
end

--- END DEBUG ---

--- SAVE FILES ---

---save every existing group
---@return void
function SuperSurvivorGroupManager:Save()
--print("saving groups:")
	for i=0, self.GroupCount do
		if(self.Groups[i]) then 
			--print("saving group #"..tostring(i))
			self.Groups[i]:Save() 
		end
	end
--print("DOne saving groups")
end

---loads every existing group from the save file
---@return void
function SuperSurvivorGroupManager:Load()
	if(doesFileExist("SurvivorGroup0.lua")) then -- only load if any groups detected at all
		self.GroupCount = 0
		print("loading groups")
		while doesFileExist("SurvivorGroup"..tostring(self.GroupCount)..".lua") do
			print("loading group#" .. tostring(self.GroupCount))
			local newGroup = self:newGroup()
			newGroup:Load()
		end
	end
end
--- END SAVE FILES ---

--- main SuperSurvivorGroupManager
SSGM = SuperSurvivorGroupManager:new()

--- PRESETS ---

HillTopGroup = SSGM:newGroup()  -- 0
HillTopGroupID = HillTopGroup:getID()
HillTopGroup:setBounds({11707,11753,7917,7967,0})
HillTopGroup:setGroupArea("ForageArea",11686,11706,7912,7967,0)
HillTopGroup:setGroupArea("CorpseStorageArea",11691,11691,7936,7936,0)
HillTopGroup:setGroupArea("FoodStorageArea",11715,11715,7926,7926,0)
HillTopGroup:setGroupArea("GuardArea",11707,11711,7938,7946,0)
HillTopGroup:setGroupArea("ChopTreeArea",11679,11700,7951,7973,0)
HillTopGroup:setGroupArea("FarmingArea",11741,11746,7939,7949,0)

BlockadeGroup = SSGM:newGroup()  -- 1
BlockadeGroup:setGroupArea("FarmingArea",12473,12475,4438,4476,0)
BlockadeGroup:setGroupArea("ForageArea",12483,12484,4442,4443,0)
BlockadeGroupID = BlockadeGroup:getID()

WoodburyGroup = SSGM:newGroup()  -- 2 
WoodburyGroupID = WoodburyGroup:getID()

LoslokosGroup = SSGM:newGroup()  -- 3
LoslokosGroupID = LoslokosGroup:getID()

Gang1Group = SSGM:newGroup()  -- 4
Gang1GroupID = Gang1Group:getID()

Gang2Group = SSGM:newGroup()  -- 5
Gang2GroupID = Gang2Group:getID()

--- END PRESETS ---