-- this file has methods related to world context

local enableDebugContext = false

--- Prints a debug message when enableDebugContext is true
---@param text string
local function debugContext(text)
	if enableDebugContext then
		print(text)
	end
end

--- SQUARES

---@alias direction 
---| '"N"' # North
---| '"S"' # South
---| '"E"' # East
---| '"W"' # West

---Get an adjacent square based on a direction
---@param square any  
---@param dir direction
---@return any the adjacent square
function GetAdjSquare(square,dir)

	if(dir == 'N') then
		return getCell():getGridSquare(square:getX(),square:getY() - 1,square:getZ());
	elseif(dir == 'E') then
		return getCell():getGridSquare(square:getX() + 1,square:getY(),square:getZ());
	elseif(dir == 'S') then
		return getCell():getGridSquare(square:getX(),square:getY() + 1,square:getZ());
	else
		return getCell():getGridSquare(square:getX() - 1,square:getY(),square:getZ());
	end
end

--- gets all squares between 2 positions (don't use it with large distances)
---@param from any
---@param to any
---@return table
function getSquaresBetween(from,to)
	
	local fromX = math.ceil(from:getX())
	local fromY = math.ceil(from:getY())
	
	local toX = math.ceil(to:getX())
	local toY = math.ceil(to:getY())

	local squares = {}
	local pos = 0
	local sqr = from
	
	debugContext("----- getSquaresBetween -----")
	debugContext("from x : " .. tostring(fromX) .. " from y : " .. tostring(fromY))
	debugContext("to x : " .. tostring(toX) .. " to y : " .. tostring(toY))

	repeat
		if fromY < toY then
			sqr = GetAdjSquare(sqr,"S")
			fromY = fromY + 1
		elseif fromY > toY then
			sqr = GetAdjSquare(sqr,"N")
			fromY = fromY - 1
		end
		
		if fromX < toX then
			sqr = GetAdjSquare(sqr,"E")
			fromX = fromX + 1
		elseif fromX > toX then
			sqr = GetAdjSquare(sqr,"W")
			fromX = fromX - 1
		end
		
		debugContext("getting square x : " .. tostring(fromX) .. " y : " .. tostring(fromY))
		
		if sqr ~= nil then		
			debugContext("saving square x : " .. tostring(fromX) .. " y : " .. tostring(fromY) .. " into position : " .. tostring(pos))
			squares[pos] = sqr
			pos = pos + 1
		end
	until fromX == toX and fromY == toY

	debugContext("total squares : " .. tostring(pos))
	debugContext("----- getSquaresBetween -----")
	return squares
end

--- SQUARES

--- COORDINATES ---
-- gets the coordinate from a npc survivor
function getCoordsFromID(id)

	for k,v in pairs(SurvivorMap) do

		for i=1,#v do
			--print(tostring(k)..","..tostring(v[i]))
			if(v[i] == id) then 
        return k 
      end
		end

	end

	return 0

end

-- gets the distance between 2 instances (zombies, npcs or players)
function getDistanceBetween(z1,z2)
	if(z1 == nil) or (z2 == nil) then 
		return -1 
	end

	local z1x = z1:getX()
	local z1y = z1:getY()
	local z1z = z1:getZ()

	local z2x = z2:getX()
	local z2y = z2:getY()
	local z2z = z2:getZ()

	local dx = z1x - z2x
	local dy = z1y - z2y
	local dz = z1z - z2z

	return math.sqrt ( dx * dx + dy * dy + (dz * dz * 2) )

end

-- gets the distance between 2 coordinates
function getDistanceBetweenPoints(Ax,Ay,Bx,By)
	if(Ax == nil) or (Bx == nil) then 
		return -1 
	end

	local dx = Ax - Bx
	local dy = Ay - By

	return math.sqrt ( dx * dx + dy * dy )

end
--- END COORDINATES ---

--- AREAS ----

--- checks if the square is inside of the area 'area'
function isSquareInArea(sq,area)

	local x1 = area[1]
	local x2 = area[2]
	local y1 = area[3]
	local y2 = area[4]

	if(sq:getX() > x1) and (sq:getX() <= x2) and (sq:getY() > y1) and (sq:getY() <= y2) and (sq:getZ() == area[5]) then 
    return true
	else 
    return false 
  end

end

-- gets the center square of an area
function getCenterSquareFromArea(x1,x2,y1,y2,z)

	local xdiff = x2 - x1
	local ydiff = y2 - y1

	local result = getCell():getGridSquare(x1+math.floor(xdiff/2),y1+math.floor(ydiff/2),z)

	return result

end

-- gets the center square inside of an area
function getRandomAreaSquare(area)

	local x1 = area[1]
	local x2 = area[2]
	local y1 = area[3]
	local y2 = area[4]
	--print(tostring(x1)..","..tostring(y1).." : " .. tostring(x2)..","..tostring(y2))
	if(x1 ~= nil) then
		local xrand = ZombRand(x1,x2)
		local yrand = ZombRand(y1,y2)

		local result = getCell():getGridSquare(xrand,yrand,area[5])

		return result
	end
end

--- END AREAS ----

-- gets a random square awyas from the 'attackGuy' inside a distance of 7
function getFleeSquare(fleeGuy,attackGuy)
	local distance = 7
	local tempx = (fleeGuy:getX() - attackGuy:getX());
	local tempy = (fleeGuy:getY() - attackGuy:getY());

	if (tempx < 0) then 
    tempx = -distance;
	else 
    tempx = distance; 
  end
	if (tempy < 0) then 
    tempy = -distance
	else 
    tempy = distance
  end

  local fleex = fleeGuy:getX() + tempx + ZombRand(-5,5)
  local fleey = fleeGuy:getY() + tempy + ZombRand(-5,5)

	return fleeGuy:getCell():getGridSquare(fleex,fleey,fleeGuy:getZ());
end

-- New Function where you can choose the distance
function getFleeSquareAlt(fleeGuy,attackGuy,distanceToFlee)
	local distance = distanceToFlee
	local tempx = (fleeGuy:getX() - attackGuy:getX());
	local tempy = (fleeGuy:getY() - attackGuy:getY());

	if (tempx < 0) then 
    tempx = -distance;
	else 
    tempx = distance; 
  end
	if (tempy < 0) then 
    tempy = -distance
	else 
    tempy = distance
  end

  local fleex = fleeGuy:getX() + tempx + ZombRand(-5,5)
  local fleey = fleeGuy:getY() + tempy + ZombRand(-5,5)

	return fleeGuy:getCell():getGridSquare(fleex,fleey,fleeGuy:getZ());
end


function getTowardsSquare(moveguy,x,y,z)
	local distance = 15
	local tempx = (moveguy:getX() - x);
	local tempy = (moveguy:getY() - y);

	if (tempx > 0) and (tempx >= distance) then 
    tempx = -distance;
	elseif (tempx < -distance) then 
    tempx = distance
	else 
		tempx = -tempx 
	end

	if (tempy > 0) and (tempy >= distance) then 
		tempy = -distance
	elseif (tempy < -distance) then 
		tempy = distance;
	else 
		tempy = -tempy 
	end

	local movex = moveguy:getX()+tempx+ZombRand(-2,2)
	local movey = moveguy:getY()+tempy+ZombRand(-2,2)

	return moveguy:getCell():getGridSquare(movex,movey,moveguy:getZ());
end

--- WINDOWS ----

-- gets a window square 
function getSquaresWindow(cs)

	if not cs then 
		return nil 
	end

	local objs = cs:getObjects()
	for i=1, objs:size() do
		if (instanceof(objs:get(i),"IsoWindow")) then 
			return objs:get(i) 
		end
	end


	return nil
end

-- gets the nearest adjacent window square of 'cs'
function getSquaresNearWindow(cs)

	local osquare = GetAdjSquare(cs,"N")
	if cs and osquare and getSquaresWindow(osquare) then 
		return getSquaresWindow(osquare) 
	end

	osquare = GetAdjSquare(cs,"E")
	if cs and osquare and getSquaresWindow(osquare) then 
		return getSquaresWindow(osquare) 
	end

	osquare = GetAdjSquare(cs,"S")
	if cs and osquare and getSquaresWindow(osquare) then 
		return getSquaresWindow(osquare) 
	end

	osquare = GetAdjSquare(cs,"W")
	if cs and osquare and getSquaresWindow(osquare) then 
		return getSquaresWindow(osquare) 
	end

	return nil

end

function getCloseWindow(building,character)

	local WindowOut = nil
	local closestSoFar = 100
	local bdef = building:getDef()
	for x=bdef:getX()-1,(bdef:getX() + bdef:getW() + 1) do
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH() + 1) do

			local sq = getCell():getGridSquare(x,y,character:getZ())
			if(sq) then
				local Objs = sq:getObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					local distance = getDistanceBetween(Object,character)
					if(instanceof(Object,"IsoWindow"))
						and (not windowHasBarricade(Object,character))
						and (not Object:isLocked())
						and (not Object:isPermaLocked())
						and distance < closestSoFar then

							closestSoFar = distance
							WindowOut = Object

					end
				end
			end

		end

	end
	return WindowOut
end

function windowHasBarricade(window,character)

	local thisSide = window:getBarricadeForCharacter(character)
	local oppositeSide = window:getBarricadeOppositeCharacter(character)
	
	if(thisSide == nil) and (oppositeSide == nil) then 
		return false
	else 
		return true 
	end
	
end
--- END WINDOWS ----

--- DOORS ----

-- gets the inside square of a door
function getDoorsInsideSquare(door,player)

	if(player == nil) or not (instanceof(door,"IsoDoor")) then 
		return nil 
	end

	local sq1 = door:getOppositeSquare()
	local sq2 = door:getSquare()
	local sq3 = door:getOtherSideOfDoor(player)

	if(not sq1:isOutside()) then 
		return sq1
	elseif(not sq2:isOutside()) then 
		return sq2
	elseif(not sq3:isOutside()) then 
		return sq3
	else 
		return nil 
	end

end

-- gets the outside square of a door 
function getDoorsOutsideSquare(door,player)

	if(player == nil) or not (instanceof(door,"IsoDoor")) then 
		return nil 
	end

	local sq1 = door:getOppositeSquare()
	local sq2 = door:getSquare()
	local sq3 = door:getOtherSideOfDoor(player)

	if(sq1 and sq1:isOutside()) then 
		return sq1
	elseif(sq2 and sq2:isOutside()) then 
		return sq2
	elseif(sq3 and sq3:isOutside()) then 
		return sq3
	else 
		return nil 
	end

end

function getUnlockedDoor(building,character)

	local DoorOut = nil
	local closestSoFar = 100
	local bdef = building:getDef()

	for x=bdef:getX()-1,(bdef:getX() + bdef:getW() + 1) do
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH() + 1) do

			local sq = getCell():getGridSquare(x,y,character:getZ())
			if(sq) then
				local Objs = sq:getObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					if(Object ~= nil) then
						local distance = getDistanceBetween(sq,character)
						if(instanceof(Object,"IsoDoor")) and (Object:isExteriorDoor(character)) and (distance < closestSoFar) then
							if(not Object:isLocked()) then
								closestSoFar = distance
								DoorOut = Object
							end
						end
					end
				end
			end

		end

	end
	return DoorOut
end

-- gets the closest door inside of a 'building' based on a 'character' position
function getDoor(building,character)
	
	local DoorOut = nil
	local closestSoFar = 100
	local bdef = building:getDef()

	for x=bdef:getX()-1,(bdef:getX() + bdef:getW() + 1) do
		for y=bdef:getY()-1,(bdef:getY() + bdef:getH() + 1) do

			local sq = getCell():getGridSquare(x,y,character:getZ())
			if(sq) then
				local Objs = sq:getObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					if(Object ~= nil) then
						local distance = getDistanceBetween(sq,character)
						if(instanceof(Object,"IsoDoor")) and (Object:isExteriorDoor(character)) and (distance < closestSoFar) then

							closestSoFar = distance
							DoorOut = Object

						end
					end
				end
			end
		end
	end

	return DoorOut
end

--- END DOORS ----

function getOutsideSquare(square,building)

	if(not building) or (not square) then 
		return nil 
	end

	local windowsquare = getCell():getGridSquare(square:getX(),square:getY(),square:getZ());
	if windowsquare~= nil and windowsquare:isOutside() then 
		return windowsquare 
	end

	local N = GetAdjSquare(square,"N")
	local E = GetAdjSquare(square,"E")
	local S = GetAdjSquare(square,"S")
	local W = GetAdjSquare(square,"W")

	if N and N:isOutside() then 
		return N
	elseif E and E:isOutside() then 
		return E
	elseif S and S:isOutside() then 
		return S
	elseif W and W:isOutside() then 
		return W
	else 
		return square
	end

end

--- BUILDINGS ---

function NumberOfZombiesInOrAroundBuilding(building)

	local count = 0
	local padding = 10
	local bdef = building:getDef()

	for x=(bdef:getX() - padding),(bdef:getX() + bdef:getW() + padding) do
		for y=(bdef:getY() - padding),(bdef:getY() + bdef:getH() + padding) do

			local sq = getCell():getGridSquare(x,y,0)
			if(sq) then
				local Objs = sq:getMovingObjects();
				for j=0, Objs:size()-1 do
					local Object = Objs:get(j)
					if(Object ~= nil) and (instanceof(Object,"IsoZombie")) then
						count = count + 1
					end
				end
			end

		end

	end

	return count
end

function getRandomBuildingSquare(building)


	local bdef = building:getDef()
	local x = ZombRand(bdef:getX(), (bdef:getX() + bdef:getW()))
	local y = ZombRand(bdef:getY(), (bdef:getY() + bdef:getH()))

	local sq = getCell():getGridSquare(x,y,0)
	if(sq) then
		return sq
	end

	return nil
end

function getRandomFreeBuildingSquare(building)

	if(building == nil) then return nil end
	local bdef = building:getDef()


	for i=0,100 do

		local x = ZombRand(bdef:getX(), (bdef:getX() + bdef:getW()))
		local y = ZombRand(bdef:getY(), (bdef:getY() + bdef:getH()))

		local sq = getCell():getGridSquare(x,y,0)
		if(sq) and sq:isFree(false) and (sq:getRoom() ~= nil) and (sq:getRoom():getBuilding() == building) then
			return sq
		end
	end

	return nil
end
--- END BUILDINGS ---