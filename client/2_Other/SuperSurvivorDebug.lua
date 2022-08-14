local SurvivorDebugConfigs = {
  EnabledLogs = {
    5
  }
}

---@alias SurvivorDebugEnum integer
---|"1" Spawn Logs
---|"2" Update Logs
---|"3" Combat Logs
---|"4" Status Logs
---|"5" Looting Logs
---|"6" Other Logs

---@alias DebugLogEnum integer
---|"1" Default Log
---|"2" Function Log
---|"3" Label/Value Log
---|"4" Error Log


--- Values for Debug
SurvivorDebugEnum = {
  Spawn = 1,
  Update = 2,
  Combat = 3,
  Status = 4,
  Looting = 5,
  Other = 6,
  Obsolete = -1,
}

local DebugLogEnum = {
  Log = 1,
  Function = 2,
  Value = 3,
  Error = 4
}

local function canLogThisLevel(level)
  if (level == -1) or (level <= #SurvivorDebugConfigs)then
    return false   
  end

  for _, v in ipairs(SurvivorDebugConfigs.EnabledLogs) do
    if v == level then
      return true
    end
  end

  return false
end

--- SURVIVOR GENERIC LOGS  ---

--- Generic log for survivor
---@param type integer|DebugLogEnum 
---@param level integer|SurvivorDebugEnum
local function logSurvivor(type,level,...)
  if (canLogThisLevel(level)) then
    if type == DebugLogEnum.Log then
      log(...)
    elseif type == DebugLogEnum.Function then
      logFunction(...)
    elseif type == DebugLogEnum.Value then
      local values = {...};
      if(#values > 1)then
        logValue(values[1], values[2])
      end
    elseif type == DebugLogEnum.Error then
      logError(...)
    end
  end
end

--- Default log for survivor
--- Any text after the param level will be considered the message 
---@param level integer|SurvivorDebugEnum The level of the log text
function logSurvivorLog(level,...)
  logSurvivor(DebugLogEnum.Log, level,...)
end

--- Logs the start/end of a function for survivor,
--- Any text after the param level will be considered the message 
---@param level integer|SurvivorDebugEnum The level of the log text
function logSurvivorFunction(level,text)
  logSurvivor(DebugLogEnum.Function,level,text)
end

--- Logs a label and value separated by " : "
--- Any text after the param level will be considered the message 
---@param level integer|SurvivorDebugEnum The level of the log text
---@param label string
---@param value any
function logSurvivorValues(level,label,value)
  logSurvivor(DebugLogEnum.Value,level,label,value)
end

--- Logs an error by throwing an exception (use this method if its really an error)
--- Any text after the param level will be considered the message 
---@param level integer|SurvivorDebugEnum The level of the log text
function logSurvivorError(level,...)
  logSurvivor(DebugLogEnum.Error,level,...)
end
--- END SURVIVOR LOGS  ---


--- SURVIVOR SPECIFIC LOGS  ---
function logSurvivorSpawnInfo(survivor)
  local level = SurvivorDebugEnum.Spawn

  if (canLogThisLevel(level)) then
    logSurvivorFunction(level, "spawn survivor")

    logSurvivorLog(level, "survivor id",   survivor:getID())
    logSurvivorLog(level, "survivor name", survivor:getName())

    logSurvivorFunction(level, "spawn survivor")
  end
end

function logSurvivorPosition(survivor)
  local level = SurvivorDebugEnum.Spawn

  if (canLogThisLevel(level)) then
    
    logSurvivorFunction(level, "survivor position")

    local square = survivor:getCurrentSquare()
    logSurvivorValues(level, "X", square:getX())
    logSurvivorValues(level, "X", square:getY())
    logSurvivorValues(level, "Z", square:getZ())

    logSurvivorFunction(level,"survivor position")
  end
end

function logSurvivorPerks(survivor)
  local level = SurvivorDebugEnum.Spawn
  if (canLogThisLevel(level)) then
    logSurvivorFunction(level,"survivor skills")

    for i = 1, #SurvivorPerks, 1 do
      local aperk = Perks.FromString(SurvivorPerks[i])
      if aperk ~= nil then
        local level = survivor:getPerkLevel(aperk)
        logSurvivorValues(level, aperk:getName(), level)
      end
    end

    logSurvivorFunction(level,"survivor skills")
  end
end

function logSurvivorAttack(survivor,victim,damage)
  local level = SurvivorDebugEnum.Combat
  if (canLogThisLevel(level)) then
    logSurvivorLog(level, "survivor", survivor:getID(), "hit the survivor", victim:getID())
    logSurvivorLog(level, "survivor", victim:getID() ,"recieved", tostring(damage), "of damage")
  end
end
--- SURVIVOR SPECIFIC LOGS  ---