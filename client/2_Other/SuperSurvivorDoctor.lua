--- checks if a body part with injury needs to change bandages
---@param bp BodyPart
---@return boolean
local function DoctorNeedsCleanBandage(bp)
	return (bp:HasInjury()) and (bp:bandaged() == true) and (bp:getBandageLife() <= 0 )
end

--- checks if a body part with injury
---@param bp BodyPart
---@return boolean
local function DoctorNeedsBandage(bp)
	if (bp:bandaged() == false) and ((bp:HasInjury()) or (bp:stitched())) then 
		if(tostring(bp) == "ForeArm_R") then
			getSpecificPlayer(0):Say("needs bandage")
		end
		return true 
	end
	if(tostring(bp) == "ForeArm_R") then
		getSpecificPlayer(0):Say("NOT needs bandage")
	end

	return false
end

--- checks if a body part with injury
---@param bp BodyPart
---@return boolean
local function DoctorNeedsBulletRemoval(bp)
	return (bp:HasInjury()) and (bp:haveBullet())
end

--- checks if a body part with injury
---@param bp BodyPart
---@return boolean
local function DoctorNeedsGlassRemoval(bp)
	return (bp:HasInjury()) and (bp:haveGlass())
end

--- checks if a body part with injury
---@param bp BodyPart
---@return boolean
local function DoctorNeedsStiches(bp)
	return (bp:HasInjury()) and (bp:isDeepWounded()) and (bp:stitched() == false)
end

--- checks if a body part with injury
---@param bp BodyPart
---@return boolean
local function DoctorNeedsSplint(bp)
	return (bp:HasInjury()) and (bp:isSplint() == false) and (bp:getFractureTime() > 0)
end

--- determine which kind of treatment a body part needs
---@param bp BodyPart
---@return string
function DoctorDetermineTreatement(bp)
	
	if not instanceof(bp,"BodyPart") then 
		print("error non body part given to DoctorDetermineTreatement")
		return "?" 
	end

	if (DoctorNeedsSplint(bp)) then return "Splint"
	elseif (DoctorNeedsStiches(bp)) and (bp:bandaged()) then return "Bandage Removal"
	elseif (DoctorNeedsStiches(bp)) and (not bp:bandaged()) then return "Stich"
	elseif (DoctorNeedsGlassRemoval(bp)) and (bp:bandaged()) then return "Bandage Removal"
	elseif (DoctorNeedsGlassRemoval(bp)) and (not bp:bandaged()) then return "Remove Glass"
	elseif (DoctorNeedsBulletRemoval(bp)) and (bp:bandaged()) then return "Bandage Removal"
	elseif (DoctorNeedsBulletRemoval(bp)) and (not bp:bandaged()) then return "Remove Bullet"
	elseif (DoctorNeedsBandage(bp)) then return "Bandage"
	elseif (DoctorNeedsCleanBandage(bp)) then return "Bandage Removal"
	else return "None" end
end

---	checks if a survivor has any body damage
---@param player IsoPlayer
---@return boolean
function RequiresTreatment(player)
	local bodyparts = player:getBodyDamage():getBodyParts()
	
	for i=0, bodyparts:size()-1 do
		local bp = bodyparts:get(i)
		if DoctorDetermineTreatement(bp) ~= "None" then
			return true
		end
	end
	
	return false
end