/obj/item/weapon/rig/light/internalaffairs
	name = "augmented tie"
	suit_type = "augmented suit"
	desc = "Prepare for paperwork."
	icon_state = "internalaffairs_rig"
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	online_slowdown = 0
	offline_slowdown = 0
	offline_vision_restriction = 0

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/briefcase, /obj/item/weapon/storage/secure/briefcase)

	req_access = list(access_lawyer)

	glove_type = null
	helm_type = null
	boot_type = null

	hides_uniform = 0

/obj/item/weapon/rig/light/internalaffairs/equipped
	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/device/paperdispenser,
		/obj/item/rig_module/device/pen,
		/obj/item/rig_module/device/stamp,
		/obj/item/rig_module/cooling_unit
		)

	glove_type = null
	helm_type = null
	boot_type = null

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/weapon/rig/industrial
	name = "industrial suit control module"
	suit_type = "industrial hardsuit"
	desc = "A heavy, powerful rig used by construction crews and mining corporations."
	icon_state = "engineering_rig"
	armor = list(melee = 45, bullet = 25, laser = 35, energy = 25, bomb = 45, bio = 100, rad = 50)
	online_slowdown = 1
	offline_slowdown = 3
//	vision_restriction = TINT_HEAVY
	vision_restriction = 0
//	offline_vision_restriction = TINT_HEAVY
	emp_protection = -20
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

	chest_type = /obj/item/clothing/suit/space/rig/industrial
	helm_type = /obj/item/clothing/head/helmet/space/rig/industrial
	boot_type = /obj/item/clothing/shoes/magboots/rig/industrial
	glove_type = /obj/item/clothing/gloves/rig/industrial

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/ore,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe, /obj/item/weapon/rcd)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/clothing/head/helmet/space/rig/industrial
	camera = /obj/machinery/camera/network/mining
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi'
		)

/obj/item/clothing/suit/space/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/suit.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/feet.dmi'
		)

/obj/item/clothing/gloves/rig/industrial
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	siemens_coefficient = 0
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/hands.dmi'
		)

/obj/item/weapon/rig/industrial/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/drill,
		/obj/item/rig_module/device/orescanner,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/eva
	name = "EVA hardsuit control module"
	suit_type = "EVA hardsuit"
	desc = "A light rig for repairs and maintenance to the outside of habitats and vessels."
	icon_state = "eva_rig"
	armor = list(melee = 30, bullet = 10, laser = 20,energy = 25, bomb = 20, bio = 100, rad = 100)
	online_slowdown = 0.25
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/eva
	helm_type = /obj/item/clothing/head/helmet/space/rig/eva
	boot_type = /obj/item/clothing/shoes/magboots/rig/eva
	glove_type = /obj/item/clothing/gloves/rig/eva

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/weapon/inflatable_dispenser,/obj/item/device/t_scanner,/obj/item/weapon/rcd)

	req_access = list(access_engine_equip)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_rig_back_unathi.dmi'
		)

/obj/item/clothing/head/helmet/space/rig/eva
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/engineering
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_IPC)
	slowdown_general = 0.2
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi'
		)

/obj/item/clothing/suit/space/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_IPC)
	slowdown_general = 0.5
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_IPC)
	slowdown_general = 0.25
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_feet_unathi.dmi'
		)

/obj/item/clothing/gloves/rig/eva
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_UNATHI,SPECIES_TAJARA,SPECIES_IPC)
	siemens_coefficient = 0
	slowdown_general = 0.3
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_hands_unathi.dmi'
		)

/obj/item/weapon/rig/eva/equipped

	initial_modules = list(
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/ce

	name = "advanced engineering hardsuit control module"
	suit_type = "engineering hardsuit"
	desc = "An advanced hardsuit that protects against hazardous, low pressure environments. Shines with a high polish. Appears compatible with the physiology of most species."
	icon_state = "ce_rig"
	armor = list(melee = 40, bullet = 25, laser = 30, energy = 25, bomb = 40, bio = 100, rad = 100)
	online_slowdown = 0.25
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE // this is passed to the rig suit components when deployed, including the helmet.

	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_rig_back_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

	helm_type = /obj/item/clothing/head/helmet/space/rig/ce
	chest_type = /obj/item/clothing/suit/space/rig/ce
	glove_type = /obj/item/clothing/gloves/rig/ce
	boot_type = /obj/item/clothing/shoes/magboots/rig/ce

	allowed = list(/obj/item/weapon/gun,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/ore,/obj/item/weapon/storage/toolbox,/obj/item/weapon/storage/briefcase/inflatable,/obj/item/weapon/inflatable_dispenser,/obj/item/device/t_scanner,/obj/item/weapon/pickaxe,/obj/item/weapon/rcd)

	req_access = list(access_ce)
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
	min_pressure_protection = 0

/obj/item/weapon/rig/ce/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/mounted/plasmacutter,
		/obj/item/rig_module/device/rcd,
		/obj/item/rig_module/device/flash,
		/obj/item/rig_module/vision/meson,
		/obj/item/rig_module/grenade_launcher/mfoam,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/clothing/head/helmet/space/rig/ce
	camera = /obj/machinery/camera/network/engineering
	slowdown_general = 0.1

/obj/item/clothing/suit/space/rig/ce
	slowdown_general = 0.3

/obj/item/clothing/gloves/rig/ce
	siemens_coefficient = 0
	slowdown_general = 0.1

/obj/item/clothing/shoes/magboots/rig/ce
	slowdown_general = 0.2

/obj/item/weapon/rig/hazmat
	name = "\improper AMI control module"
	suit_type = "hazmat hardsuit"
	desc = "An Anomalous Material Interaction hardsuit, a cutting-edge NanoTrasen design, protects the wearer against the strangest energies the universe can throw at it."
	icon_state = "science_rig"
	armor = list(melee = 45, bullet = 5, laser = 45, energy = 80, bomb = 60, bio = 100, rad = 100)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/hazmat
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazmat
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazmat
	glove_type = /obj/item/clothing/gloves/rig/hazmat

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/weapon/storage/excavation,/obj/item/weapon/pickaxe,/obj/item/device/scanner/health,/obj/item/device/measuring_tape,/obj/item/device/ano_scanner,/obj/item/device/depth_scanner,/obj/item/device/core_sampler,/obj/item/device/gps,/obj/item/weapon/pinpointer/radio,/obj/item/device/radio/beacon,/obj/item/weapon/pickaxe/xeno,/obj/item/weapon/storage/bag/fossils)

	req_access = list(access_tox)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/clothing/head/helmet/space/rig/hazmat
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/research
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi'
		)

/obj/item/clothing/suit/space/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/suit.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/feet.dmi'
		)

/obj/item/clothing/gloves/rig/hazmat
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/hands.dmi'
		)

/obj/item/weapon/rig/hazmat/equipped

	initial_modules = list(
		/obj/item/rig_module/ai_container,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/anomaly_scanner,
		/obj/item/rig_module/cooling_unit,
		)

/obj/item/weapon/rig/medical
	name = "rescue suit control module"
	suit_type = "rescue hardsuit"
	desc = "A durable suit designed for medical rescue in high risk areas."
	icon_state = "medical_rig"
	armor = list(melee = 30, bullet = 15, laser = 25, energy = 60, bomb = 30, bio = 100, rad = 100)
	online_slowdown = 1
	offline_vision_restriction = TINT_HEAVY

	chest_type = /obj/item/clothing/suit/space/rig/medical
	helm_type = /obj/item/clothing/head/helmet/space/rig/medical
	boot_type = /obj/item/clothing/shoes/magboots/rig/medical
	glove_type = /obj/item/clothing/gloves/rig/medical

	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/firstaid,/obj/item/device/scanner/health,/obj/item/stack/medical,/obj/item/roller,/obj/item/auto_cpr)

	req_access = list(access_medical_equip)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_rig_back_resomi.dmi'
		)

/obj/item/clothing/head/helmet/space/rig/medical
	camera = /obj/machinery/camera/network/medbay
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_head_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_helmet_unathi.dmi',
		SPECIES_SKRELL = 'icons/mob/species/skrell/onmob_head_skrell.dmi',
		)

/obj/item/clothing/suit/space/rig/medical
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/medical
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_feet_unathi.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/feet.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_feet_resomi.dmi'
		)

/obj/item/clothing/gloves/rig/medical
	species_restricted = list(SPECIES_HUMAN, SPECIES_SKRELL, SPECIES_TAJARA, SPECIES_UNATHI, SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_hands_unathi.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/hands.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_hands_resomi.dmi'
		)

/obj/item/weapon/rig/medical/equipped

	initial_modules = list(
		/obj/item/rig_module/chem_dispenser/injector,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/device/healthscanner,
		/obj/item/rig_module/vision/medhud,
		/obj/item/rig_module/device/defib,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/hazard
	name = "hazard hardsuit control module"
	suit_type = "hazard hardsuit"
	desc = "A security hardsuit designed for prolonged EVA in dangerous environments."
	icon_state = "hazard_rig"
	armor = list(melee = 60, bullet = 40, laser = 40, energy = 15, bomb = 60, bio = 100, rad = 30)
	online_slowdown = 1
	offline_slowdown = 3
	offline_vision_restriction = TINT_BLIND

	chest_type = /obj/item/clothing/suit/space/rig/hazard
	helm_type = /obj/item/clothing/head/helmet/space/rig/hazard
	boot_type = /obj/item/clothing/shoes/magboots/rig/hazard
	glove_type = /obj/item/clothing/gloves/rig/hazard

	allowed = list(/obj/item/weapon/gun,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/weapon/handcuffs,/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/melee/baton)

	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/rig_back.dmi'
		)

/obj/item/clothing/head/helmet/space/rig/hazard
	light_overlay = "helmet_light_dual"
	camera = /obj/machinery/camera/network/security
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_head_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/head.dmi',
		SPECIES_SCRELL = 'icons/mob/species/skrell/helmet.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi'
		)

/obj/item/clothing/suit/space/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/suit.dmi',
		SPECIES_SCRELL = 'icons/mob/species/skrell/suit.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi'
		)

/obj/item/clothing/shoes/magboots/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_feet_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/feet.dmi',
		SPECIES_SCRELL = 'icons/mob/species/skrell/feet.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/feet.dmi'
		)

/obj/item/clothing/gloves/rig/hazard
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL,SPECIES_TAJARA,SPECIES_UNATHI,SPECIES_RESOMI)
	sprite_sheets = list(
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_hands_resomi.dmi',
		SPECIES_UNATHI = 'icons/mob/onmob/Unathi/hands.dmi',
		SPECIES_SCRELL = 'icons/mob/species/skrell/hands.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/hands.dmi'
		)

/obj/item/weapon/rig/hazard/equipped

	initial_modules = list(
		/obj/item/rig_module/vision/sechud,
		/obj/item/rig_module/maneuvering_jets,
		/obj/item/rig_module/grenade_launcher,
		/obj/item/rig_module/mounted/taser,
		/obj/item/rig_module/cooling_unit
		)

/obj/item/weapon/rig/zero
	name = "null suit control module"
	suit_type = "null hardsuit"
	desc = "A very lightweight suit designed to allow use inside mechs and starfighters. It feels like you're wearing nothing at all."
	icon_state = "null_rig"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 20)
	online_slowdown = 0
	offline_slowdown = 1
	offline_vision_restriction = TINT_HEAVY //You're wearing a flash protective space suit without light compensation, think it makes sense

	chest_type = /obj/item/clothing/suit/space/rig/zero
	helm_type = /obj/item/clothing/head/helmet/space/rig/zero
	boot_type = null
	glove_type = null
	max_pressure_protection = null
	min_pressure_protection = 0


	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	//Bans the most common combat items, idea is that this isn't a mass built shouldergun rig.
	banned_modules = list(/obj/item/rig_module/grenade_launcher,/obj/item/rig_module/mounted,/obj/item/rig_module/fabricator )
	req_access = list()

/obj/item/clothing/head/helmet/space/rig/zero
	camera = null
	species_restricted = list(SPECIES_HUMAN, SPECIES_UNATHI, SPECIES_SKRELL)
	light_overlay = "null_light"
	desc = "A bubble helmet that maximizes the field of view. A state of the art holographic display provides a stream of information"

//All in one suit
/obj/item/clothing/suit/space/rig/zero
	species_restricted = list(SPECIES_HUMAN,SPECIES_SKRELL, SPECIES_UNATHI)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_suit_unathi.dmi'
		)
	breach_threshold = 18
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS

/obj/item/weapon/rig/zero/on_update_icon(var/update_mob_icon)
	..()
	//Append the f for female states
	if(!ishuman(loc))
		return
	var/mob/living/carbon/human/user = loc
	if(!chest) return
	//If there's a better way to do this with current rig setup tell me
	//Do not further append if current state already indicates gender
	if(user.gender == FEMALE && !findtext(chest.icon_state,"_f", -2))
		chest.icon_state = "[chest.icon_state]_f"
	chest.update_icon(1)

