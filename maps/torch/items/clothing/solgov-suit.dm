/obj/item/clothing/suit/storage/solgov/
	name = "master solgov jacket"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')

//Service

/obj/item/clothing/suit/storage/solgov/service
	name = "service jacket"
	desc = "A uniform service jacket, plain and undecorated."
	icon_state = "blackservice"
	item_state = "blackservice"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/weapon/pen,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/weapon/storage/fancy/cigarettes,/obj/item/weapon/flame/lighter,/obj/item/device/taperecorder,/obj/item/device/scanner/gas,/obj/item/device/radio,/obj/item/taperoll)
	valid_accessory_slots = list(ACCESSORY_SLOT_ARMBAND,ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK,ACCESSORY_SLOT_DEPT)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/service/expeditionary
	name = "expeditionary jacket"
	desc = "A uniform service jacket belonging to the SCG Expeditionary Corps."
	icon_state = "ecservice_crew"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/medical/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/medical/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/engineering/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/engineering/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/supply
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/supply/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/security/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/security/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/service/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/service/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/exploration/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/exploration/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/research/service)

/obj/item/clothing/suit/storage/solgov/service/expeditionary/research/command
	icon_state = "ecservice_officer"

/obj/item/clothing/suit/storage/solgov/service/expeditionary/command
	icon_state = "ecservice_officer"
	starting_accessories = list(/obj/item/clothing/accessory/solgov/department/command/service)

/obj/item/clothing/suit/storage/solgov/service/fleet
	name = "fleet service jacket"
	desc = "A navy blue SCG Fleet service jacket."
	icon_state = "blueservice"
	item_state = "blueservice"

/obj/item/clothing/suit/storage/solgov/service/fleet/snco
	name = "fleet SNCO service jacket"
	desc = "A navy blue SCG Fleet service jacket with silver cuffs."
	icon_state = "blueservice_snco"
	item_state = "blueservice_snco"

/obj/item/clothing/suit/storage/solgov/service/fleet/officer
	name = "fleet officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents."
	icon_state = "blueservice_off"
	item_state = "blueservice_off"

/obj/item/clothing/suit/storage/solgov/service/fleet/command
	name = "fleet senior officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents."
	icon_state = "blueservice_comm"
	item_state = "blueservice_comm"

/obj/item/clothing/suit/storage/solgov/service/fleet/flag
	name = "fleet flag officer's service jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents."
	icon_state = "blueservice_flag"
	item_state = "blueservice_flag"

/obj/item/clothing/suit/storage/solgov/service/army
	name = "army coat"
	desc = "An SCG Army service coat. Green and undecorated."
	icon_state = "greenservice"
	item_state = "greenservice"

/obj/item/clothing/suit/storage/solgov/service/army/medical
	name = "army medical jacket"
	desc = "An SCG Army service coat. This one has blue markings."
	icon_state = "greenservice_med"
	item_state = "greenservice_med"

/obj/item/clothing/suit/storage/solgov/service/army/medical/command
	name = "army medical command jacket"
	desc = "An SCG Army service coat. This one has blue and gold markings."
	icon_state = "greenservice_medcom"
	item_state = "greenservice_medcom"

/obj/item/clothing/suit/storage/solgov/service/army/engineering
	name = "army engineering jacket"
	desc = "An SCG Army service coat. This one has orange markings."
	icon_state = "greenservice_eng"
	item_state = "greenservice_eng"

/obj/item/clothing/suit/storage/solgov/service/army/engineering/command
	name = "army engineering command jacket"
	desc = "An SCG Army service coat. This one has orange and gold markings."
	icon_state = "greenservice_engcom"
	item_state = "greenservice_engcom"

/obj/item/clothing/suit/storage/solgov/service/army/supply
	name = "army supply jacket"
	desc = "An SCG Army service coat. This one has brown markings."
	icon_state = "greenservice_sup"
	item_state = "greenservice_sup"

/obj/item/clothing/suit/storage/solgov/service/army/security
	name = "army security jacket"
	desc = "An SCG Army service coat. This one has red markings."
	icon_state = "greenservice_sec"
	item_state = "greenservice_sec"

/obj/item/clothing/suit/storage/solgov/service/army/security/command
	name = "army security command jacket"
	desc = "An SCG Army service coat. This one has red and gold markings."
	icon_state = "greenservice_seccom"
	item_state = "greenservice_seccom"

/obj/item/clothing/suit/storage/solgov/service/army/service
	name = "army service jacket"
	desc = "An SCG Army service coat. This one has green markings."
	icon_state = "greenservice_srv"
	item_state = "greenservice_srv"

/obj/item/clothing/suit/storage/solgov/service/army/service/command
	name = "army service command jacket"
	desc = "An SCG Army service coat. This one has green and gold markings."
	icon_state = "greenservice_srvcom"
	item_state = "greenservice_srvcom"

/obj/item/clothing/suit/storage/solgov/service/army/exploration
	name = "army exploration jacket"
	desc = "An SCG Army service coat. This one has purple markings."
	icon_state = "greenservice_exp"
	item_state = "greenservice_exp"

/obj/item/clothing/suit/storage/solgov/service/army/exploration/command
	name = "army exploration command jacket"
	desc = "An SCG Army service coat. This one has purple and gold markings."
	icon_state = "greenservice_expcom"
	item_state = "greenservice_expcom"

/obj/item/clothing/suit/storage/solgov/service/army/command
	name = "army command jacket"
	desc = "An SCG Marine Corps service coat. This one has gold markings."
	icon_state = "greenservice_com"
	item_state = "greenservice_com"

//Dress - murder me with a gun why are these 3 different types

/obj/item/clothing/suit/storage/solgov/dress
	name = "dress jacket"
	desc = "A uniform dress jacket, plain and undecorated."
	icon_state = "ecdress_xpl"
	item_state = "ecdress_xpl"
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK)
	restricted_accessory_slots = list(ACCESSORY_SLOT_ARMBAND)

/obj/item/clothing/suit/storage/solgov/dress/expedition
	name = "expeditionary dress coat"
	desc = "A silver and black dress peacoat belonging to the SCG Expeditionary Corps. Fashionable, for the 25th century at least."
	icon_state = "ecdress_xpl"
	item_state = "ecdress_xpl"
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi'
		)

/obj/item/clothing/suit/storage/solgov/dress/expedition/senior
	name = "expeditionary senior's dress coat"
	icon_state = "ecdress_sxpl"
	item_state = "ecdress_sxpl"

/obj/item/clothing/suit/storage/solgov/dress/expedition/chief
	name = "expeditionary chief's dress coat"
	icon_state = "ecdress_cxpl"
	item_state = "ecdress_cxpl"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command
	name = "expeditionary officer's dress coat"
	desc = "A gold and black dress peacoat belonging to the SCG Expeditionary Corps. The height of fashion."
	icon_state = "ecdress_ofcr"
	item_state = "ecdress_ofcr"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/cdr
	name = "expeditionary commander's dress coat"
	icon_state = "ecdress_cdr"
	item_state = "ecdress_cdr"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/capt
	name = "expeditionary captain's dress coat"
	icon_state = "ecdress_capt"
	item_state = "ecdress_capt"

/obj/item/clothing/suit/storage/solgov/dress/expedition/command/adm
	name = "expeditionary admiral's dress coat"
	icon_state = "ecdress_adm"
	item_state = "ecdress_adm"

/obj/item/clothing/suit/storage/solgov/dress/fleet
	name = "fleet dress jacket"
	desc = "A navy blue SCG Fleet dress jacket. Don't get near pasta sauce or vox."
	icon_state = "whitedress"
	item_state = "whitedress"

/obj/item/clothing/suit/storage/solgov/dress/fleet/snco
	name = "fleet dress SNCO jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver cuffs. Don't get near pasta sauce or vox."
	icon_state = "whitedress_snco"
	item_state = "whitedress_snco"

/obj/item/clothing/suit/storage/solgov/dress/fleet/officer
	name = "fleet officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with silver accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_off"
	item_state = "whitedress_off"

/obj/item/clothing/suit/storage/solgov/dress/fleet/command
	name = "fleet senior officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with gold accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_comm"
	item_state = "whitedress_comm"

/obj/item/clothing/suit/storage/solgov/dress/fleet/flag
	name = "fleet flag officer's dress jacket"
	desc = "A navy blue SCG Fleet dress jacket with red accents. Don't get near pasta sauce or vox."
	icon_state = "whitedress_flag"
	item_state = "whitedress_flag"

/obj/item/clothing/suit/dress/solgov
	name = "dress jacket"
	desc = "A uniform dress jacket, fancy."
	icon_state = "blackdress"
	item_state = "blackdress"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	body_parts_covered = UPPER_TORSO|ARMS
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 0, rad = 0)
	siemens_coefficient = 0.9
	allowed = list(/obj/item/weapon/tank/emergency,/obj/item/device/flashlight,/obj/item/clothing/head/soft,/obj/item/clothing/head/beret,/obj/item/device/radio,/obj/item/weapon/pen)
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/dress/solgov/fleet/sailor
	name = "fleet dress overwear"
	desc = "A navy blue SCG Fleet dress suit. Almost looks like a school-girl outfit."
	icon_state = "sailordress"
	item_state = "whitedress"

/obj/item/clothing/suit/dress/solgov/army
	name = "army dress jacket"
	desc = "A tailored black SCG Army dress jacket with red trim. So sexy it hurts."
	icon_state = "blackdress"
	item_state = "blackdress"

/obj/item/clothing/suit/dress/solgov/army/command
	name = "army officer's dress jacket"
	desc = "A tailored black SCG Army dress jacket with gold trim. Smells like ceremony."
	icon_state = "blackdress_com"
	item_state = "blackdress_com"

//Misc

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov
	name = "expeditionary winter coat"
	icon_state = "coatec"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	armor = list(melee = 25, bullet = 10, laser = 5, energy = 10, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/army
	name = "army winter coat"
	icon_state = "coatar"
	armor = list(melee = 30, bullet = 10, laser = 10, energy = 15, bomb = 20, bio = 0, rad = 0)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA,ACCESSORY_SLOT_RANK)

/obj/item/clothing/suit/storage/hooded/wintercoat/solgov/fleet
	name = "fleet winter coat"
	icon_state = "coatfl"
	armor = list(melee = 20, bullet = 10, laser = 10, energy = 20, bomb = 20, bio = 0, rad = 10)
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)

//SolGov Hardsuits

/obj/item/clothing/suit/space/void/engineering/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/suits.dmi'
		)

/obj/item/clothing/suit/space/void/engineering/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/engineering/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/atmos/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/suits.dmi'
		)

/obj/item/clothing/suit/space/void/atmos/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/atmos/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/pilot/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/suits.dmi'
		)

/obj/item/clothing/suit/space/void/pilot/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/pilot/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/suit/space/void/medical/alt/sol
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_UNATHI = 'maps/torch/icons/obj/unathi/obj_suit_solgov_unathi.dmi',
		SPECIES_SKRELL = 'maps/torch/icons/obj/skrell/obj_suit_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/suits.dmi'
		)

/obj/item/clothing/suit/space/void/medical/alt/sol/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/medical/alt/sol
	boots = /obj/item/clothing/shoes/magboots

/obj/item/clothing/head/helmet/space/void/command
	icon = 'maps/torch/icons/obj/obj_head_solgov.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi')
	name = "command voidsuit helmet"
	desc = "A light, radiation resistant voidsuit helmet commonly used among SCG uniformed services."
	icon_state = "void_command"
	item_state = "void_command"
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)
	light_overlay = "helmet_light_dual_green"

/obj/item/clothing/suit/space/void/command
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	icon_state = "void_command"
	name = "command voidsuit"
	desc = "A light, radiation resistant voidsuit commonly used among SCG uniformed services. This one has an EC seal on its chest plate and command department markings."
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/weapon/storage/briefcase/inflatable)
	armor = list(melee = 30, bullet = 5, laser = 10,energy = 5, bomb = 5, bio = 100, rad = 60)

/obj/item/clothing/suit/space/void/command/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0

/obj/item/clothing/suit/space/void/command/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/command
	boots = /obj/item/clothing/shoes/magboots

//Exploration
/obj/item/clothing/head/helmet/space/void/exploration
	name = "exploration voidsuit helmet"
	desc = "A helmet of Exoplanet Exploration Unit, standard issue for Expeditionary Corps away missions. It has an armored glass dome for superiour visibility and extra anti-radiation lining."
	icon = 'maps/torch/icons/obj/obj_head_solgov.dmi'
	item_icons = list(slot_head_str = 'maps/torch/icons/mob/onmob_head_solgov.dmi')
	icon_state = "helm_explorer"
	sprite_sheets = list(
		SPECIES_SKRELL = 'maps/torch/icons/mob/skrell/onmob_head_solgov_skrell.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/helmet.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_head_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/hats.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/hats.dmi'
		)
	armor = list(melee = 30, bullet = 10, laser = 15,energy = 45, bomb = 30, bio = 100, rad = 90)
	light_overlay = "yellow_light"
	tinted = FALSE

/obj/item/clothing/suit/space/void/exploration
	name = "exploration voidsuit"
	icon = 'maps/torch/icons/obj/obj_suit_solgov.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/torch/icons/mob/onmob_suit_solgov.dmi')
	desc = "The bulky Exoplanet Exploration Unit is a standard voidsuit for Expeditionary Corps field operations. It features extra padding and respectable radiation-resistant lining."
	icon_state = "void_explorer"
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_suit_solgov_unathi.dmi',
		SPECIES_TAJARA = 'icons/mob/species/tajaran/suit.dmi',
		SPECIES_RESOMI = 'infinity/icons/mob/species/resomi/onmob_suit_resomi.dmi'
		)
	sprite_sheets_obj = list(
		SPECIES_TAJARA = 'icons/obj/clothing/species/tajaran/suits.dmi',
		SPECIES_RESOMI = 'infinity/icons/obj/clothing/species/resomi/suits.dmi'
		)
	armor = list(melee = 40, bullet = 10, laser = 15,energy = 45, bomb = 30, bio = 100, rad = 90)
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit,/obj/item/stack/flag,/obj/item/device/scanner/health,/obj/item/device/gps,/obj/item/weapon/pinpointer/radio,/obj/item/device/radio/beacon,/obj/item/weapon/material/hatchet/machete,/obj/item/weapon/shovel)

/obj/item/clothing/suit/space/void/exploration/prepared
	helmet = /obj/item/clothing/head/helmet/space/void/exploration
	boots = /obj/item/clothing/shoes/magboots
