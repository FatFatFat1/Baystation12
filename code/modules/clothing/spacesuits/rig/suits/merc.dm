/obj/item/clothing/head/helmet/space/rig/merc
	light_overlay = "helmet_light_dual_green"
	camera = /obj/machinery/camera/network/mercenary

/obj/item/weapon/rig/merc
	name = "crimson hardsuit control module"
	desc = "A blood-red hardsuit module with heavy armour plates."
	icon_state = "merc_rig"
	suit_type = "crimson hardsuit"
	armor = list(melee = 80, bullet = 65, laser = 65, energy = 15, bomb = 75, bio = 100, rad = 60)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_HEAVY

	helm_type = /obj/item/clothing/head/helmet/space/rig/merc
	glove_type = /obj/item/clothing/gloves/rig/merc
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/melee/baton,/obj/item/weapon/melee/energy/sword,/obj/item/weapon/handcuffs)

	initial_modules = list(
		/obj/item/rig_module/mounted/lcannon,
		/obj/item/rig_module/vision/thermal,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/power_sink,
		/obj/item/rig_module/electrowarfare_suite,
		/obj/item/rig_module/chem_dispenser/combat,
		/obj/item/rig_module/fabricator/energy_net
		)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/clothing/gloves/rig/merc
	item_flags = ITEM_FLAG_THICKMATERIAL | ITEM_FLAG_NOCUFFS

//Has most of the modules removed
/obj/item/weapon/rig/merc/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)

/obj/item/weapon/rig/merc/heavy
	name = "crimson EOD hardsuit control module"
	desc = "A blood-red hardsuit with heavy armoured plates. Judging by the abnormally thick plates, this one is for working with explosives."
	icon_state = "merc_rig_heavy"
	armor = list(melee = 80, bullet = 65, laser = 70, energy = 35, bomb = 100, bio = 100, rad = 80)
	online_slowdown = 3
	offline_slowdown = 4
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/weapon/rig/merc/heavy/empty
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/electrowarfare_suite,
		)
