local debugConfigs = {
  enabled = true,
  logUpdates = false,
  logStatus = true,
}
--- UPDATES ---
--- logs that happens a lot ---

function logUpdates(...)
  if debugConfigs.enabled and debugConfigs.logUpdates then
    log(...)  
  end
end

function logFunctionUpdates(text)
  if debugConfigs.enabled and debugConfigs.logUpdates then
    logFunction(text)
  end
end

function logValuesUpdates(label,value)
  if debugConfigs.enabled and debugConfigs.logUpdates then
    logValue(label,value)
  end
end
--- END UPDATES ---

--- SURVIVOR LOGS  ---

function logSurvivorStatus(...)
  if debugConfigs.enabled and debugConfigs.logStatus then
    log(...)
  end
end

function logSurvivorSpawn(survivor)
  if debugConfigs.enabled and debugConfigs.logStatus then
    logFunction("spawn survivor")

    logValue("survivor id",   survivor:getID())
    logValue("survivor name", survivor:getName())
    logValue("group id",      survivor:getGroupID())

    logFunction("spawn survivor")
  end
end

function logSurvivorPosition(survivor)
  if debugConfigs.enabled and debugConfigs.logStatus then
    logFunction("survivor position")

    local square = survivor:getCurrentSquare()
    logValue("X", square:getX())
    logValue("X", square:getY())
    logValue("Z", square:getZ())

    logFunction("survivor position")
  end
end

function logSurvivorPerks(survivor)
  if debugConfigs.enabled and debugConfigs.logStatus then
    logFunction("survivor skills")
    for i = 1, #SurvivorPerks, 1 do
      local aperk = Perks.FromString(SurvivorPerks[i])
      if aperk ~= nil then
        local level = survivor:getPerkLevel(aperk)
        logValue(aperk:getName(), level)
      end
    end
    logFunction("survivor skills")
  end
end
--- END SURVIVOR LOGS  ---