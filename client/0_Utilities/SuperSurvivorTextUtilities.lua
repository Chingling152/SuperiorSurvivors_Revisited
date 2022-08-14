--- gets a challenge text from Challenge_xx.txt
---@param text string the label inside the file without the prefix ("Challenge_SS_")
---@return string returns the text inside the Challenge_xx.txt that is assigned to the selected text
function getChallengeText(text)
	return getText("Challenge_SS_" .. text)
end

--- gets a context menu text from ContextMenu_xx.txt
---@param text string the label inside the file without the prefix ("ContextMenu_SS_")
---@return string returns the text inside the ContextMenu_xx.txt that is assigned to the selected text
function getContextMenuText(text)
	return getText("ContextMenu_SS_" .. text)
end

--- gets a dialogue text from GameSound_xx.txt
---@param text string the label inside the file without the prefix ("GameSound_Dialogues_SS_")
---@return string returns the text inside the GameSound_xx.txt that is assigned to the selected text
function getDialogue(text)
  return getText("GameSound_Dialogues_SS_" .. text)
end

--- gets an action text from IG_UI_xx.txt
---@param text string the label inside the file without the prefix ("IGUI_SS_")
---@return string returns the text inside the IG_UI_xx.txt that is assigned to the selected text
function getActionText(text)
	return getText("IGUI_SS_" .. text)
end

--- gets a name from Moodles_xx.txt
---@param name string the label inside the file without the prefix ("Moodles_SS_")
---@return string returns the name inside the Moodles_xx.txt that is assigned to the selected text
function getName(name)
  return getText("Moodles_SS_" .. name)
end

--- gets an UI option from UI_xx.txt
---@param text string the label inside the file without the prefix ("UI_Option_SS_")
---@return string returns the text inside the UI_xx.txt that is assigned to the selected text
function getOptionText(text)
	return getText("UI_Option_SS_" .. text)
end