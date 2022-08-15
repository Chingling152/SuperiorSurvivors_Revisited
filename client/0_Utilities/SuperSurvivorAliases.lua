--- this file only contains aliases to improve auto-complete and documentation
--- this file doenst have any code

--- SUPER SURVIVOR ---
---@class TextDrawObject
---@field setAllowAnyImage fun(set: boolean):void 
---@field setDefaultFont fun(font: any):void 
---@field setDefaultColors fun(r: number, g: number, b: number, a: number):void 
---@field ReadString fun(text:string):void 

---@class playerStats
---@field getHunger fun(): number
---@field getThirst fun(): number

---@class IsoPlayer
---@field isDead fun(): boolean
---@field getStats fun(): playerStats
---@field getPerkLevel fun(perk: string): number
---@field getCurrentSquare fun(): square 
---@field getModData fun(): modData 
---@field getInventory fun() : inventory

---@class modData
---@field ID number the id of the survivor
---@field Name string the name of the survivor
---@field NameRaw string
---@field PVP boolean 
---@field surender boolean
---@field isHostile boolean
---@field isRobber boolean check if the survivor stole a item from inside other survivors base
---@field semiHostile boolean
---@field hitByCharacter boolean
---@field seenZombie boolean
---@field BravePoints number
---@field AIMode AIMode
---@field RWP number
---@field NoParty boolean
---@field Group string
---@field FollowCharID number id of the survivor that the current is following
---@field RouteID number
---@field bWalking boolean
---@field Sneaking boolean
---@field Running boolean
---@field felldown boolean
---@field LockNLoad boolean
---@field NeedAmmo boolean
---@field AmmoCount number
---@field ammotype string
---@field ammoBoxtype string
---@field meleWeapon boolean
---@field gunWeapon boolean
---@field LastSquareSaveX number
---@field LastSquareSaveY number
---@field LastSquareSaveZ number
---@field RealPlayer number
---@field PX number    first x position of the square for patrolling
---@field PY number    first y position of the square for patrolling
---@field PZ number    first z position of the square for patrolling
---@field P2X number   second x position of the square for patrolling
---@field P2Y number   second y position of the square for patrolling
---@field P2Z number   second z position of the square for patrolling
---@field ShowName boolean
---@field Greeting string
---@field InitGreeting string
---@field Toggle boolean
---@field dealBreaker boolean

---@alias AIMode string
---| '"Random Solo"'
---| '"Wander"'
---| '"Follow"'
---| '"Follow Route"'
---| '"Stand Ground"'
---| '"Guard"'
---| '"Doctor"'
---| '"Farmer"'

---@class SuperSurvivor
---@field GroupRole groupRole
---@field SquareContainerSquareLooteds table
---@field SquaresExplored table 
---@field AttackRange number 
---@field BravePoints number
---@field UsingFullAuto boolean 
---@field NoFoodNear boolean 
---@field NoWaterNear boolean 
---@field seenCount number
---@field userName TextDrawObject 
---@field LastEnemeySeen IsoPlayer 
---@field player IsoPlayer

--- END SUPER SURVIVOR ---

--- BUILDINGS ---

---@class buildingdef
---@field getX fun(): number	
---@field getY fun(): number
---@field getZ fun(): number
---@field getH fun(): number
---@field getW fun(): number

---@class room
---@field getBuilding fun(): building

---@class building
---@field getDef fun(): buildingdef

--- END BUILDINGS ---

--- SQUARES ---
---@class worldobject
---@field getObjectName fun(): string
---@field getSquare fun(): square

---@class square 
---@field getX fun(): number
---@field getY fun(): number
---@field getZ fun(): number
---@field isFree fun(isFree: boolean): boolean
---@field isOutside fun(): boolean
---@field getRoom fun(): room

--- END SQUARES ---

--- ITEMS ---
---@class container
---@field FindAndReturnCategory fun(category:string): item
---@field getItems fun(): item[]

---@class inventory:container

---@class item
---@field getDisplayName fun(): string
---@field getCategory fun(): string
---@field getType fun(): string
---@field getWeight fun(): number

---@class food:item
---@field getFoodType fun(): foodType
---@field getPoisonPower fun(): number
---@field getHungerChange fun(): number
---@field getUnhappyChange fun(): number
---@field getBoredomChange fun(): number
---@field getHungerChange fun(): number
---@field isAlcoholic fun(): boolean
---@field isIsCookable fun(): boolean
---@field isCooked fun(): boolean
---@field isbDangerousUncooked fun(): boolean
---@field isSpice fun(): boolean
---@field isFresh fun(): boolean
---@field IsRotten fun(): boolean

---@class water:item
---@field isWaterSource fun(): boolean

---@class weapon:item
---@field getMinDamage fun(): number
---@field getMaxDamage fun(): number
---@field getAmmoType fun(): string
---@field getType fun(): string
---@field isAimedFirearm fun(): boolean

---@alias itemCategory string
---| '"Food"'
---| '"Water"'
---| '"Weapon"'

---@alias lootType string
---| '"Food"'
---| '"Weapon"'
---| '"Item"'
---| '"Clothing"'
---| '"Container"'
---| '"Literature"'

---@alias foodType string
---| '"NoExplicit"'
---| '"Fruits"'
---| '"Vegetables"'
---| '"Rice"'
---| '"Pasta"'
---| '"Coffee"'
---| '"Meat"'
---| '"Egg"'

---@alias rarity string
---| '"Common"'
---| '"Uncommon"'
---| '"Normal"'
---| '"Rare"'
---| '"VeryRare"'
---| '"Legendary"'

--- END ITEMS ---

--- GROUPS --- 
---@alias groupRole string
---|'"Worker"'
---|'"Companion"'
---|'"Dustman"'
---|'"Junkman"'
---|'"Farmer"'
---|'"Timberjack"'
---|'"Doctor"'
---|'"Sheriff"'
---|'"Follow"'

---@class SuperSurvivorGroup
---@field Bounds number[]
---@field GroupAreas GroupAreas

---@class GroupAreas
---@field ChopTreeArea number[]
---@field TakeCorpseArea number[]
---@field TakeWoodArea number[]
---@field FarmingArea number[]
---@field ForageArea number[]
---@field CorpseStorageArea number[]
---@field FoodStorageArea number[]
---@field WoodStorageArea number[]
---@field ToolStorageArea number[]
---@field WeaponStorageArea number[]
---@field MedicalStorageArea number[]
---@field GuardArea number[]

--- END GROUPS --- 

--- MISC. ---
---@alias	gender "GirlNames"|"BoyNames"
--- END MISC. ---

--- TASKS ---

---@class TaskManager

---@class Task
---@field Name string name of the task
---@field parent any the one who is executing the task
---@field isValid fun(): boolean checks if the task is valid to be executed
---@field OnGoing boolean checks if the task is being executed
---@field isComplete fun(): boolean checks if the task is complete
---@field Complete boolean checks if the task is complete
---@field OnComplete fun(): void function that is called when the task is finished
---@field update fun(): void task execution

---@class AttackTask:Task

---@class AttemptEntryIntoBuildingTask:Task

---@class BarricadeBuildingTask:Task

---@class ChopWoodTask:Task

---@class CleanInvTask:Task

---@class DoctorTask:Task

---@class EatFoodTask:Task

---@class EquipWeaponTask:Task

---@class FarmingTask:Task
---@field Seeds string[] name of all typs of seeds

---@class FindBuildingTask:Task

---@class FindThisTask:Task

---@class FindUnlootedBuildingTask:Task

---@class FirstAideTask:Task

---@class FleeFromHereTask:Task

---@class FleeTask:Task

---@class FollowTask:Task

---@class FollowRouteTask:Task

---@class ForageTask:Task

---@class GatherWoodTask:Task

---@class GoCheckItOutTask:Task

---@class GuardTask:Task

---@class HoldStillTask:Task

---@class ListenTask:Task

---@class LockDoorsTask:Task

---@class LootCategoryTask:Task

---@class PatrolTask:Task

---@class PileCorpsesTask:Task

---@class PursueTask:Task

---@class ReturnToBaseTask:Task

---@class SpeakDialogueTask:Task

---@class SurenderTask:Task

---@class TakeGiftTask:Task

---@class ThreatenTask:Task

---@class WanderTask:Task

---@class WanderInAreaTask:Task

---@class WanderInBaseTask:Task

---@class WanderInBuildingTask:Task

---@class WashSelfTask:Task

--- END TASKS ---

-- TODO : remove zomboid api docs (modData, IsoPlayer, inventory, userName)