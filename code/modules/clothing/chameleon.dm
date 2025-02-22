//*****************
//**Cham Jumpsuit**
//*****************

/obj/item/proc/disguise(var/newtype, var/mob/user)
	if(!user || !CanPhysicallyInteract(user))
		return
	//this is necessary, unfortunately, as initial() does not play well with list vars
	var/obj/item/copy = new newtype(null)

	desc = copy.desc
	name = copy.name
	icon = copy.icon
	color = copy.color
	icon_state = copy.icon_state
	item_state = copy.item_state
	body_parts_covered = copy.body_parts_covered
	flags_inv = copy.flags_inv
	icon = copy.icon
	item_icons  = copy.item_icons
	gender = copy.gender

	if(copy.item_icons)
		item_icons = copy.item_icons.Copy()
	if(copy.item_state_slots)
		item_state_slots = copy.item_state_slots.Copy()
	if(copy.sprite_sheets)
		sprite_sheets = copy.sprite_sheets.Copy()
	//copying sprite_sheets_obj should be unnecessary as chameleon items are not refittable.

	OnDisguise(copy, user)
	qdel(copy)

// Subtypes shall override this, not /disguise()
/obj/item/proc/OnDisguise(var/obj/item/copy, var/mob/user)
	return

/proc/generate_chameleon_choices(var/basetype, var/blacklist=list())
	. = list()

	var/types = islist(basetype) ? basetype : typesof(basetype)
	var/i = 1 //in case there is a collision with both name AND icon_state
	for(var/typepath in (types - blacklist))
		var/obj/O = typepath
		if(initial(O.icon) && initial(O.icon_state))
			var/name = initial(O.name)
			if(name in .)
				name += " ([initial(O.icon_state)])"
			if(name in .)
				name += " \[[i++]\]"
			.[name] = typepath
	return sortAssoc(.)

/obj/item/clothing/under/chameleon
//starts off as a jumpsuit
	name = "jumpsuit"
	icon_state = "jumpsuit"
	item_state = "jumpsuit"
	worn_state = "jumpsuit"
	desc = "It's a plain jumpsuit. It seems to have a small dial on the wrist."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/clothing/under/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		var/blocked = list(src.type, /obj/item/clothing/under/cloud, /obj/item/clothing/under/gimmick)//Prevent infinite loops and bad jumpsuits.
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/under, blocked)

/obj/item/clothing/under/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Jumpsuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*****************
//**Chameleon Hat**
//*****************

/obj/item/clothing/head/chameleon
	name = "grey cap"
	icon_state = "greysoft"
	desc = "It looks like a plain hat, but upon closer inspection, there's an advanced holographic array installed inside. It seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	body_parts_covered = 0
	var/global/list/clothing_choices

/obj/item/clothing/head/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		var/blocked = list(src.type, /obj/item/clothing/head/justice,)//Prevent infinite loops and bad hats.
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/head, blocked)

/obj/item/clothing/head/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Hat/Helmet Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//******************
//**Chameleon Suit**
//******************

/obj/item/clothing/suit/chameleon
	name = "armor"
	icon_state = "armor"
	item_state = "armor"
	desc = "It appears to be a vest of standard armor, except this is embedded with a hidden holographic cloaker, allowing it to change it's appearance, but offering no protection.. It seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/clothing/suit/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		var/blocked = list(src.type, /obj/item/clothing/suit/cyborg_suit, /obj/item/clothing/suit/justice, /obj/item/clothing/suit/greatcoat)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/suit, blocked)

/obj/item/clothing/suit/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Oversuit Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*******************
//**Chameleon Shoes**
//*******************
/obj/item/clothing/shoes/chameleon
	name = "black shoes"
	icon_state = "black"
	item_state = "black"
	desc = "They're comfy black shoes, with clever cloaking technology built in. It seems to have a small dial on the back of each shoe."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/clothing/shoes/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		var/blocked = list(src.type, /obj/item/clothing/shoes/syndigaloshes, /obj/item/clothing/shoes/cyborg)//prevent infinite loops and bad shoes.
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/shoes, blocked)

/obj/item/clothing/shoes/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Footwear Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//**********************
//**Chameleon Backpack**
//**********************
/obj/item/weapon/storage/backpack/chameleon
	name = "backpack"
	icon_state = "backpack"
	item_state = "backpack"
	desc = "A backpack outfitted with cloaking tech. It seems to have a small dial inside, kept away from the storage."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/weapon/storage/backpack/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		var/blocked = list(src.type, /obj/item/weapon/storage/backpack/satchel/grey/withwallet)
		clothing_choices = generate_chameleon_choices(/obj/item/weapon/storage/backpack, blocked)

/obj/item/weapon/storage/backpack/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Backpack Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)

	//so our overlays update.
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_back()

//********************
//**Chameleon Gloves**
//********************

/obj/item/clothing/gloves/chameleon
	name = "black gloves"
	icon_state = "black"
	item_state = "bgloves"
	desc = "It looks like a pair of gloves, but it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/clothing/gloves/chameleon/New()
	..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/gloves, list(src.type))

/obj/item/clothing/gloves/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Gloves Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//******************
//**Chameleon Mask**
//******************

/obj/item/clothing/mask/chameleon
	name = "gas mask"
	icon_state = "fullgas"
	item_state = "gas_alt"
	desc = "It looks like a plain gask mask, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/global/list/clothing_choices

/obj/item/clothing/mask/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/mask, list(src.type))

/obj/item/clothing/mask/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Mask Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*********************
//**Chameleon Glasses**
//*********************

/obj/item/clothing/glasses/chameleon
	name = "Optical Meson Scanner"
	icon_state = "meson"
	item_state = "glasses"
	desc = "It looks like a plain set of mesons, but on closer inspection, it seems to have a small dial inside."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/global/clothing_choices

/obj/item/clothing/glasses/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/glasses, list(src.type))

/obj/item/clothing/glasses/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Glasses Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()	//so our overlays update.

//*********************
//**Chameleon Headset**
//*********************

/obj/item/device/radio/headset/chameleon
	name = "radio headset"
	icon_state = "headset"
	item_state = "headset"
	desc = "An updated, modular intercom that fits over the head. This one seems to have a small dial on it."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/global/clothing_choices

/obj/item/device/radio/headset/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/device/radio/headset, list(type))

/obj/item/device/radio/headset/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Headset Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_ears()

//***********************
//**Chameleon Accessory**
//***********************

/obj/item/clothing/accessory/chameleon
	name = "tie"
	icon_state = "tie"
	item_state = ""
	desc = "A neosilk clip-on tie. It seems to have a small dial on its back."
	origin_tech = list(TECH_ILLEGAL = 3)
	var/list/global/clothing_choices

/obj/item/clothing/accessory/chameleon/Initialize()
	. = ..()
	if(!clothing_choices)
		clothing_choices = generate_chameleon_choices(/obj/item/clothing/accessory, list(type))

/obj/item/clothing/accessory/chameleon/verb/change(picked in clothing_choices)
	set name = "Change Accessory Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(clothing_choices[picked]))
		return

	disguise(clothing_choices[picked], usr)
	update_clothing_icon()

/obj/item/clothing/accessory/chameleon/disguise(var/newtype, var/mob/user)
	var/obj/item/clothing/accessory/copy = ..()
	if (!copy)
		return

	slot = copy.slot
	has_suit = copy.has_suit
	inv_overlay = copy.inv_overlay
	mob_overlay = copy.mob_overlay
	overlay_state = copy.overlay_state
	accessory_icons = copy.accessory_icons
	on_rolled = copy.on_rolled
	high_visibility	= copy.high_visibility
	return copy

//*****************
//**Chameleon Gun**
//*****************
/obj/item/weapon/gun/energy/chameleon
	name = "chameleon gun"
	desc = "A hologram projector in the shape of a gun. There is a dial on the side to change the gun's disguise."
	icon = 'icons/obj/guns/revolvers.dmi'
	icon_state = "revolver"
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_COMBAT = 2, TECH_MATERIAL = 2, TECH_ILLEGAL = 3)
	matter = list()

	fire_sound = 'sound/weapons/gunshot/gunshot_pistol.ogg'
	projectile_type = /obj/item/projectile/chameleon
	charge_meter = 0
	charge_cost = 20 //uses next to no power, since it's just holograms
	max_shots = 50

	var/obj/item/projectile/copy_projectile
	var/global/list/gun_choices

/obj/item/weapon/gun/energy/chameleon/Initialize()
	. = ..()
	if(!gun_choices)
		gun_choices = list()
		for(var/gun_type in typesof(/obj/item/weapon/gun/) - src.type)
			var/obj/item/weapon/gun/G = gun_type
			src.gun_choices[initial(G.name)] = gun_type

/obj/item/weapon/gun/energy/chameleon/consume_next_projectile()
	var/obj/item/projectile/P = ..()
	if(P && ispath(copy_projectile))
		P.SetName(initial(copy_projectile.name))
		P.icon = initial(copy_projectile.icon)
		P.icon_state = initial(copy_projectile.icon_state)
		P.pass_flags = initial(copy_projectile.pass_flags)
		P.hitscan = initial(copy_projectile.hitscan)
		P.step_delay = initial(copy_projectile.step_delay)
		P.muzzle_type = initial(copy_projectile.muzzle_type)
		P.tracer_type = initial(copy_projectile.tracer_type)
		P.impact_type = initial(copy_projectile.impact_type)
	return P

/obj/item/weapon/gun/energy/chameleon/OnDisguise(var/obj/item/weapon/gun/copy)
	if(!istype(copy))
		return

	flags_inv = copy.flags_inv
	fire_sound = copy.fire_sound
	fire_sound_text = copy.fire_sound_text
	icon = copy.icon

	var/obj/item/weapon/gun/energy/E = copy
	if(istype(E))
		copy_projectile = E.projectile_type
		//charge_meter = E.charge_meter //does not work very well with icon_state changes, ATM
	else
		copy_projectile = null
		//charge_meter = 0

/obj/item/weapon/gun/energy/chameleon/verb/change(picked in gun_choices)
	set name = "Change Gun Appearance"
	set category = "Chameleon Items"
	set src in usr

	if(!ispath(gun_choices[picked]))
		return

	disguise(gun_choices[picked], usr)

	//so our overlays update.
	if (ismob(src.loc))
		var/mob/M = src.loc
		M.update_inv_r_hand()
		M.update_inv_l_hand()
