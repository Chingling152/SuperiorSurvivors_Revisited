--- this file only contains aliases to improve auto-complete and documentation

--- SUPER SURVIVOR ---
---@class userName
---@field setAllowAnyImage fun(set: boolean):void 
---@field setDefaultFont fun(font: any):void 
---@field setDefaultColors fun(r: number, g: number, b: number, a: number):void 
---@field ReadString fun(text:string):void 

---@class playerStats
---@field getHunger fun(): number
---@field getThirst fun(): number

---@class player
---@field isDead fun(): boolean
---@field getStats fun(): playerStats
---@field getPerkLevel fun(perk: string): integer
---@field getCurrentSquare fun(): square 
---@field getModData fun(): modData 
---@field getInventory fun() : inventory

---@class modData
---@field ID integer the id of the survivor
---@field Name string the name of the survivor
---@field NameRaw string
---@field PVP boolean 
---@field surender boolean
---@field isHostile boolean
---@field isRobber boolean check if the survivor stole a item from inside other survivors base
---@field semiHostile boolean
---@field hitByCharacter boolean
---@field seenZombie boolean
---@field BravePoints integer
---@field AIMode AIMode
---@field RWP integer
---@field NoParty boolean
---@field Group string
---@field FollowCharID integer id of the survivor that the current is following
---@field RouteID integer
---@field bWalking boolean
---@field Sneaking boolean
---@field Running boolean
---@field felldown boolean
---@field LockNLoad boolean
---@field NeedAmmo boolean
---@field AmmoCount integer
---@field ammotype string
---@field ammoBoxtype string
---@field meleWeapon boolean
---@field gunWeapon boolean
---@field LastSquareSaveX integer
---@field LastSquareSaveY integer
---@field LastSquareSaveZ integer
---@field RealPlayer integer
---@field PX integer    first x position of the square for patrolling
---@field PY integer    first y position of the square for patrolling
---@field PZ integer    first z position of the square for patrolling
---@field P2X integer   second x position of the square for patrolling
---@field P2Y integer   second y position of the square for patrolling
---@field P2Z integer   second z position of the square for patrolling
---@field ShowName boolean
---@field Greeting string
---@field InitGreeting string
---@field Toggle boolean
---@field dealBreaker boolean

---@class SuperSurvivor
---@field GroupRole groupRole
---@field SquareContainerSquareLooteds table
---@field SquaresExplored table 
---@field AttackRange number 
---@field BravePoints integer 
---@field UsingFullAuto boolean 
---@field NoFoodNear boolean 
---@field NoWaterNear boolean 
---@field seenCount integer 
---@field userName userName 
---@field LastEnemeySeen player 
---@field player player 

---@alias AIMode string
---| '"Random Solo"'
---| '"Wander"'
---| '"Follow"'
---| '"Follow Route"'
---| '"Stand Ground"'
---| '"Guard"'
---| '"Doctor"'
---| '"Farmer"'

--- END SUPER SURVIVOR ---

--- BUILDINGS ---

---@class buildingdef
---@field getX fun(): integer	
---@field getY fun(): integer
---@field getZ fun(): integer
---@field getH fun(): integer
---@field getW fun(): integer

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
---@field getX fun(): integer
---@field getY fun(): integer
---@field getZ fun(): integer
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

---@alias itemCategory
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

---@alias foodType
---| '"NoExplicit"'
---| '"Fruits"'
---| '"Vegetables"'
---| '"Rice"'
---| '"Pasta"'
---| '"Coffee"'
---| '"Meat"'
---| '"Egg"'

---@alias rarity
---| '"Common"'
---| '"Uncommon"'
---| '"Normal"'
---| '"Rare"'
---| '"VeryRare"'
---| '"Legendary"'

--- END ITEMS ---

--- GROUPS --- 
---@alias groupRole
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

---@class GroupAreas
---@field ChopTreeArea integer[]
---@field TakeCorpseArea integer[]
---@field TakeWoodArea integer[]
---@field FarmingArea integer[]
---@field ForageArea integer[]
---@field CorpseStorageArea integer[]
---@field FoodStorageArea integer[]
---@field WoodStorageArea integer[]
---@field ToolStorageArea integer[]
---@field WeaponStorageArea integer[]
---@field MedicalStorageArea integer[]
---@field GuardArea integer[]

--- END GROUPS --- 

--- MISC. ---
---@alias	gender
---| '"GirlNames"'
---| '"BoyNames"'
--- END MISC. ---

-- TODO : remove zomboid api docs (modData, player, inventory, userName)