/var/global/list/autolathe_recipes
/var/global/list/autolathe_categories

var/const/EXTRA_COST_FACTOR = 1.25
// Items are more expensive to produce than they are to recycle.

/proc/populate_lathe_recipes()

	//Create global autolathe recipe list if it hasn't been made already.
	autolathe_recipes = list()
	autolathe_categories = list()
	for(var/R in typesof(/datum/autolathe/recipe)-/datum/autolathe/recipe)
		var/datum/autolathe/recipe/recipe = new R
		autolathe_recipes += recipe
		autolathe_categories |= recipe.category

		var/obj/item/I = new recipe.path
		if(I.matter && !recipe.resources) //This can be overidden in the datums.
			recipe.resources = list()
			for(var/material in I.matter)
				recipe.resources[material] = I.matter[material] * EXTRA_COST_FACTOR
		qdel(I)

/datum/autolathe/recipe
	var/name = "object"
	var/path
	var/list/resources
	var/hidden
	var/category
	var/power_use = 0
	var/is_stack

/datum/autolathe/recipe/bucket
	name = "bucket"
	path = /obj/item/weapon/reagent_containers/glass/bucket
	category = "General"

/datum/autolathe/recipe/drinkingglass
	name = "drinking glass"
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/square
	category = "General"

/datum/autolathe/recipe/drinkingglass/New()
	..()
	var/obj/O = path
	name = initial(O.name) // generic recipes yay

/datum/autolathe/recipe/drinkingglass/rocks
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/rocks

/datum/autolathe/recipe/drinkingglass/shake
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shake

/datum/autolathe/recipe/drinkingglass/cocktail
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/cocktail

/datum/autolathe/recipe/drinkingglass/shot
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/shot

/datum/autolathe/recipe/drinkingglass/pint
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/pint

/datum/autolathe/recipe/drinkingglass/mug
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/mug

/datum/autolathe/recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/wine

/datum/autolathe/recipe/drinkingglass/wine
	path = /obj/item/weapon/reagent_containers/food/drinks/glass2/carafe

/datum/autolathe/recipe/flashlight
	name = "flashlight"
	path = /obj/item/device/flashlight
	category = "General"

/datum/autolathe/recipe/floor_light
	name = "floor light"
	path = /obj/machinery/floor_light
	category = "General"

/datum/autolathe/recipe/extinguisher
	name = "extinguisher"
	path = /obj/item/weapon/extinguisher
	category = "General"

/datum/autolathe/recipe/jar
	name = "jar"
	path = /obj/item/glass_jar
	category = "General"

/datum/autolathe/recipe/crowbar
	name = "crowbar"
	path = /obj/item/weapon/crowbar
	category = "Tools"

/datum/autolathe/recipe/prybar
	name = "pry bar"
	path = /obj/item/weapon/crowbar/prybar
	category = "Tools"

/datum/autolathe/recipe/multitool
	name = "multitool"
	path = /obj/item/device/multitool
	category = "Tools"

/datum/autolathe/recipe/t_scanner
	name = "T-ray scanner"
	path = /obj/item/device/t_scanner
	category = "Tools"

/datum/autolathe/recipe/weldertool
	name = "welding tool"
	path = /obj/item/weapon/weldingtool
	category = "Tools"

/datum/autolathe/recipe/screwdriver
	name = "screwdriver"
	path = /obj/item/weapon/screwdriver
	category = "Tools"

/datum/autolathe/recipe/wirecutters
	name = "wirecutters"
	path = /obj/item/weapon/wirecutters
	category = "Tools"

/datum/autolathe/recipe/wrench
	name = "wrench"
	path = /obj/item/weapon/wrench
	category = "Tools"

/datum/autolathe/recipe/hatchet
	name = "hatchet"
	path = /obj/item/weapon/material/hatchet
	category = "Tools"

/datum/autolathe/recipe/minihoe
	name = "mini hoe"
	path = /obj/item/weapon/material/minihoe
	category = "Tools"

/datum/autolathe/recipe/radio_headset
	name = "radio headset"
	path = /obj/item/device/radio/headset
	category = "General"

/datum/autolathe/recipe/radio_bounced
	name = "shortwave radio"
	path = /obj/item/device/radio/off
	category = "General"

/datum/autolathe/recipe/suit_cooler
	name = "suit cooling unit"
	path = /obj/item/device/suit_cooling_unit
	category = "General"

/datum/autolathe/recipe/weldermask
	name = "welding mask"
	path = /obj/item/clothing/head/welding
	category = "General"

/datum/autolathe/recipe/metal
	name = "steel sheets"
	path = /obj/item/stack/material/steel
	category = "General"
	is_stack = 1
	resources = list(MATERIAL_STEEL = SHEET_MATERIAL_AMOUNT * EXTRA_COST_FACTOR)

/datum/autolathe/recipe/glass
	name = "glass sheets"
	path = /obj/item/stack/material/glass
	category = "General"
	is_stack = 1
	resources = list(MATERIAL_GLASS = SHEET_MATERIAL_AMOUNT * EXTRA_COST_FACTOR)

/datum/autolathe/recipe/aluminium
	name = "aluminium sheets"
	path = /obj/item/stack/material/aluminium
	category = "General"
	is_stack = 1
	resources = list(MATERIAL_ALUMINIUM = SHEET_MATERIAL_AMOUNT * EXTRA_COST_FACTOR)

/datum/autolathe/recipe/rglass
	name = "reinforced glass sheets"
	path = /obj/item/stack/material/glass/reinforced
	category = "General"
	is_stack = 1
	resources = list(MATERIAL_GLASS = (SHEET_MATERIAL_AMOUNT/2) * EXTRA_COST_FACTOR, MATERIAL_STEEL = (SHEET_MATERIAL_AMOUNT/2) * EXTRA_COST_FACTOR)

/datum/autolathe/recipe/plastic
	name = "plastic sheets"
	path = /obj/item/stack/material/plastic
	category = "General"
	is_stack = 1
	resources = list(MATERIAL_PLASTIC = SHEET_MATERIAL_AMOUNT * EXTRA_COST_FACTOR)

/datum/autolathe/recipe/rods
	name = "metal rods"
	path = /obj/item/stack/material/rods
	category = "General"
	is_stack = 1

/datum/autolathe/recipe/knife
	name = "kitchen knife"
	path = /obj/item/weapon/material/knife/kitchen
	category = "General"

/datum/autolathe/recipe/taperecorder
	name = "tape recorder"
	path = /obj/item/device/taperecorder/empty
	category = "General"

/datum/autolathe/recipe/tape
	name = "tape"
	path = /obj/item/device/tape
	category = "General"

/datum/autolathe/recipe/airlockmodule
	name = "airlock electronics"
	path = /obj/item/weapon/airlock_electronics
	category = "Engineering"

/datum/autolathe/recipe/airalarm
	name = "air alarm electronics"
	path = /obj/item/weapon/airalarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/firealarm
	name = "fire alarm electronics"
	path = /obj/item/weapon/firealarm_electronics
	category = "Engineering"

/datum/autolathe/recipe/powermodule
	name = "power control module"
	path = /obj/item/weapon/module/power_control
	category = "Engineering"

/datum/autolathe/recipe/rcd_ammo
	name = "matter cartridge"
	path = /obj/item/weapon/rcd_ammo
	category = "Engineering"
/datum/autolathe/recipe/rcd_ammo_large
	name = "high-capacity matter cartridge"
	path = /obj/item/weapon/rcd_ammo/large
	category = "Engineering"

/datum/autolathe/recipe/scalpel
	name = "scalpel"
	path = /obj/item/weapon/scalpel
	category = "Medical"

/datum/autolathe/recipe/circularsaw
	name = "circular saw"
	path = /obj/item/weapon/circular_saw
	category = "Medical"

/datum/autolathe/recipe/surgicaldrill
	name = "surgical drill"
	path = /obj/item/weapon/surgicaldrill
	category = "Medical"

/datum/autolathe/recipe/retractor
	name = "retractor"
	path = /obj/item/weapon/retractor
	category = "Medical"

/datum/autolathe/recipe/cautery
	name = "cautery"
	path = /obj/item/weapon/cautery
	category = "Medical"

/datum/autolathe/recipe/hemostat
	name = "hemostat"
	path = /obj/item/weapon/hemostat
	category = "Medical"

/datum/autolathe/recipe/beaker
	name = "glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker
	category = "Medical"

/datum/autolathe/recipe/beaker_large
	name = "large glass beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/large
	category = "Medical"

/datum/autolathe/recipe/beaker_insul
	name = "insulated beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/insulated
	category = "Medical"

/datum/autolathe/recipe/beaker_insul_large
	name = "large insulated beaker"
	path = /obj/item/weapon/reagent_containers/glass/beaker/insulated/large
	category = "Medical"

/datum/autolathe/recipe/vial
	name = "glass vial"
	path = /obj/item/weapon/reagent_containers/glass/beaker/vial
	category = "Medical"

/datum/autolathe/recipe/syringe
	name = "syringe"
	path = /obj/item/weapon/reagent_containers/syringe
	category = "Medical"

/datum/autolathe/recipe/implanter
	name = "implanter"
	path = /obj/item/weapon/implanter
	category = "Medical"

/datum/autolathe/recipe/pill_bottle
	name = "pill bottle"
	path = /obj/item/weapon/storage/pill_bottle
	category = "Medical"

/datum/autolathe/recipe/syringegun_ammo
	name = "syringe gun cartridge"
	path = /obj/item/weapon/syringe_cartridge
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_holder
	name = "shotgun ammunition holder"
	path = /obj/item/ammo_magazine/shotholder/empty
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_blanks
	name = "ammunition (shotgun, blank)"
	path = /obj/item/ammo_casing/shotgun/blank
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_beanbag
	name = "ammunition (shotgun, beanbag)"
	path = /obj/item/ammo_casing/shotgun/beanbag
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_flash
	name = "ammunition (shotgun, flash)"
	path = /obj/item/ammo_casing/shotgun/flash
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg_rubber
	name = "ammunition (SMG rubber) top mounted"
	path = /obj/item/ammo_magazine/smg_top/rubber
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/consolescreen
	name = "console screen"
	path = /obj/item/weapon/stock_parts/console_screen
	category = "Devices and Components"

/datum/autolathe/recipe/igniter
	name = "igniter"
	path = /obj/item/device/assembly/igniter
	category = "Devices and Components"

/datum/autolathe/recipe/signaler
	name = "signaler"
	path = /obj/item/device/assembly/signaler
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_infra
	name = "infrared sensor"
	path = /obj/item/device/assembly/infra
	category = "Devices and Components"

/datum/autolathe/recipe/timer
	name = "timer"
	path = /obj/item/device/assembly/timer
	category = "Devices and Components"

/datum/autolathe/recipe/sensor_prox
	name = "proximity sensor"
	path = /obj/item/device/assembly/prox_sensor
	category = "Devices and Components"

/datum/autolathe/recipe/cable_coil
	name = "cable coil"
	path = /obj/item/stack/cable_coil/single
	category = "Devices and Components"
	is_stack = 1

/datum/autolathe/recipe/tube/large
	name = "spotlight tube"
	path = /obj/item/weapon/light/tube/large
	category = "General"

/datum/autolathe/recipe/tube
	name = "light tube"
	path = /obj/item/weapon/light/tube
	category = "General"

/datum/autolathe/recipe/bulb
	name = "light bulb"
	path = /obj/item/weapon/light/bulb
	category = "General"

/datum/autolathe/recipe/ashtray_glass
	name = "glass ashtray"
	path = /obj/item/weapon/material/ashtray/glass
	category = "General"

/datum/autolathe/recipe/camera_assembly
	name = "camera assembly"
	path = /obj/item/weapon/camera_assembly
	category = "Engineering"

/datum/autolathe/recipe/weldinggoggles
	name = "welding goggles"
	path = /obj/item/clothing/glasses/welding
	category = "General"

/datum/autolathe/recipe/blackpen
	name = "black ink pen"
	path = /obj/item/weapon/pen
	category = "General"

/datum/autolathe/recipe/bluepen
	name = "blue ink pen"
	path = /obj/item/weapon/pen/blue
	category = "General"

/datum/autolathe/recipe/redpen
	name = "red ink pen"
	path = /obj/item/weapon/pen/red
	category = "General"

/datum/autolathe/recipe/greenpen
	name = "green ink pen"
	path = /obj/item/weapon/pen/green
	category = "General"

/datum/autolathe/recipe/clipboard_steel
	name = "clipboard, steel"
	path = /obj/item/weapon/material/clipboard/steel
	category = "General"

/datum/autolathe/recipe/clipboard_alum
	name = "clipboard, aluminium"
	path = /obj/item/weapon/material/clipboard/aluminium
	category = "General"

/datum/autolathe/recipe/clipboard_glass
	name = "clipboard, glass"
	path = /obj/item/weapon/material/clipboard/glass
	category = "General"

/datum/autolathe/recipe/clipboard_alum
	name = "clipboard, plastic"
	path = /obj/item/weapon/material/clipboard/plastic
	category = "General"

/datum/autolathe/recipe/destTagger
	name = "destination tagger"
	path = /obj/item/device/destTagger
	category = "General"

/datum/autolathe/recipe/labeler
	name = "hand labeler"
	path = /obj/item/weapon/hand_labeler
	category = "General"

/datum/autolathe/recipe/machete
	name = "fabricated machete"
	path = /obj/item/weapon/material/hatchet/machete/steel
	category = "Arms and Ammunition"
	resources = list(MATERIAL_STEEL = 15000, MATERIAL_PLASTIC = 2500)

/datum/autolathe/recipe/flamethrower
	name = "flamethrower"
	path = /obj/item/weapon/flamethrower/full
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/speedloader
	name = "ammunition (speedloader)"
	path = /obj/item/ammo_magazine/speedloader
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/speedloader_small
	name = "ammunition (speedloader, holdout)"
	path = /obj/item/ammo_magazine/speedloader/small
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/speedloader_magnum
	name = "ammunition (speedloader, magnum)"
	path = /obj/item/ammo_magazine/speedloader/magnum
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_pistol
	name = "ammunition (pistol)"
	path = /obj/item/ammo_magazine/pistol
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_pistol_rubber
	name = "ammunition (pistol, rubber)"
	path = /obj/item/ammo_magazine/pistol/rubber
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_pistol_double
	name = "ammunition (pistol, doublestack)"
	path = /obj/item/ammo_magazine/pistol/double
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_pistol_double_rubber
	name = "ammunition (pistol, doublestack. rubber)"
	path = /obj/item/ammo_magazine/pistol/double/rubber
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_small
	name = "ammunition (holdout)"
	path = /obj/item/ammo_magazine/pistol/small
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_magnum
	name = "ammunition (magnum)"
	path = /obj/item/ammo_magazine/magnum
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg
	name = "ammunition (submachine gun)"
	path = /obj/item/ammo_magazine/smg
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_uzi
	name = "ammunition (machine pistol)"
	path = /obj/item/ammo_magazine/machine_pistol
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_smg_topmounted
	name = "ammunition (SMG, top mounted)"
	path = /obj/item/ammo_magazine/smg_top
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_arifle
	name = "ammunition (rifle magazine)"
	path = /obj/item/ammo_magazine/rifle
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/magazine_carbine
	name = "ammunition (military rifle)"
	path = /obj/item/ammo_magazine/mil_rifle
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun
	name = "ammunition (slug, shotgun)"
	path = /obj/item/ammo_casing/shotgun
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/shotgun_pellet
	name = "ammunition (shell, shotgun)"
	path = /obj/item/ammo_casing/shotgun/pellet
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/tacknife
	name = "tactical knife"
	path = /obj/item/weapon/material/knife/combat
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/stunshell
	name = "ammunition (stun cartridge, shotgun)"
	path = /obj/item/ammo_casing/shotgun/stunshell
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/rcd
	name = "rapid construction device"
	path = /obj/item/weapon/rcd
	hidden = 1
	category = "Engineering"

/datum/autolathe/recipe/electropack
	name = "electropack"
	path = /obj/item/device/radio/electropack
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/beartrap
	name = "mechanical trap"
	path = /obj/item/weapon/beartrap
	hidden = 1
	category = "Devices and Components"

/datum/autolathe/recipe/welder_industrial
	name = "industrial welding tool"
	path = /obj/item/weapon/weldingtool/largetank
	hidden = 1
	category = "Tools"

/datum/autolathe/recipe/handcuffs
	name = "handcuffs"
	path = /obj/item/weapon/handcuffs
	hidden = 1
	category = "General"

/datum/autolathe/recipe/cell_device
	name = "device cell"
	path = /obj/item/weapon/cell/device/standard
	category = "Devices and Components"

/datum/autolathe/recipe/ecigcartridge
	name = "ecigarette cartridge"
	path = /obj/item/weapon/reagent_containers/ecig_cartridge/blank
	category = "Devices and Components"

/datum/autolathe/recipe/plunger
	name = "plunger"
	path = /obj/item/clothing/mask/plunger
	category = "General"

/datum/autolathe/recipe/skrellian_rifle_flechette
	name = "ammunition (skrellian rifle, flechette)"
	path = /obj/item/weapon/magnetic_ammo/skrell
	hidden = 1
	category = "Arms and Ammunition"

/datum/autolathe/recipe/skrellian_rifle_slug
	name = "ammunition (skrellian rifle, slug)"
	path = /obj/item/weapon/magnetic_ammo/skrell/slug
	hidden = 1
	category = "Arms and Ammunition"