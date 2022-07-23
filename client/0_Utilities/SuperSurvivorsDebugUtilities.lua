local isDebugEnabled =  getCore():getDebug()

local debugConfigs = {
  enabled = isDebugEnabled,
  logValues = true,
  logFunctions = true,
  logErrors = true,
}

--- default log method, only logs when is in debug mode
---@param ... table any one or more texts (separated by commas) to be written in console.txt
function log(...)
  if debugConfigs.enabled then
    local args = {...}
    print(table.concat(args, " "))
  end
end

--- logs a function name with a dash pattern
---@param text string a function name
function logFunction(text)
  if debugConfigs.logFunctions then
    log(" -----", text, "----- ")
  end
end

--- method used to show values 
--- it's made so the logs have a pattern and the string concat only be made when is in debug mode
---@param label string 
---@param value any
function logValue(label, value)
  if debugConfigs.logValues then
    if label == nil then
      label = 'nil'
    end
    if value == nil then
      value = 'nil'
    end
    log(label, ":", value)
  end
end

--- method used to throw an exception in debug mode
--- only use it if you want to break code when something wrong happen
---@param text any
function logError(text)
  if debugConfigs.logErrors then
    error(text,1)
  end
end