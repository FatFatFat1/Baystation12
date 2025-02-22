/obj/item/modular_computer/pda/wrist
	name = "wrist computer"
	desc = "A wrist-mounted modular personal computer. Very stylish."
	icon = 'infinity/icons/obj/wrist_computer.dmi'
	item_icons = list(slot_wear_id_str = 'infinity/icons/mob/wrist_computer.dmi')

	item_state_slots = list(slot_wear_id_str = "wc_base")
	icon_state = "wc_base"
	item_state = "wc_base"
	icon_state_unpowered = "wc_base"

	slot_flags = SLOT_ID | SLOT_BELT

	color = COLOR_GUNMETAL
	item_state_slots = list(slot_wear_id_str = "wc_base")

	interact_sounds = list('infinity/sound/items/ui_pipboy_select.wav')

	var/stripe_color

/obj/item/modular_computer/pda/wrist/get_mob_overlay(var/mob/user_mob, var/slot)
	var/image/ret = ..()
	if(slot == slot_wear_id_str)
		if(enabled)
			var/image/I = image(icon = ret.icon, icon_state = "wc_screen")
			I.appearance_flags |= RESET_COLOR
			I.color = (bsod || updating) ? "#0000ff" : "#00ff00"
			ret.overlays.Add(I)
		else
			ret.overlays.Add(image(icon = ret.icon, icon_state = "wc_screen_off"))
		if(stripe_color)
			var/image/I = image(icon = ret.icon, icon_state = "wc_stripe")
			I.appearance_flags |= RESET_COLOR
			I.color = stripe_color
			overlays.Add(I)
	return ret

/obj/item/modular_computer/pda/wrist/on_update_icon()
	icon_state = icon_state_unpowered
	overlays.Cut()

	if(stripe_color)
		var/image/I = image(icon = icon, icon_state = "wc_stripe")
		I.appearance_flags |= RESET_COLOR
		I.color = stripe_color
		overlays.Add(I)

	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_id == src)
		H.update_inv_wear_id()

	if(bsod || updating)
		var/image/I = image(icon = icon, icon_state ="bsod")
		I.appearance_flags |= RESET_COLOR
		overlays.Add(I)
		return
	if(!enabled)
		if(icon_state_screensaver)
			var/image/I = image(icon = icon, icon_state = icon_state_screensaver)
			I.appearance_flags |= RESET_COLOR
			overlays.Add(I)
		set_light(0)
		return
	set_light(0.2, 0.1, light_strength)
	if(active_program)
		var/image/I = image(icon = icon, icon_state = active_program.program_icon_state ? active_program.program_icon_state : icon_state_menu)
		I.appearance_flags |= RESET_COLOR
		overlays.Add(I)
		if(active_program.program_key_state)
			I = image(icon = icon, icon_state = active_program.program_key_state)
			I.appearance_flags |= RESET_COLOR
			overlays.Add(I)
	else
		overlays.Add(icon_state_menu)
		var/image/I = image(icon = icon, icon_state = icon_state_menu)
		I.appearance_flags |= RESET_COLOR
		overlays.Add(I)

/obj/item/modular_computer/pda/wrist/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	if(card_slot && istype(card_slot.stored_card))
		eject_id()
	else
		..()

/obj/item/modular_computer/pda/wrist/attack_hand(var/mob/user)
	if(loc == user)
		if(user.incapacitated() || user.restrained())
			return
		var/mob/living/carbon/human/H = user
		if(istype(H) && src == H.wear_id)
			return attack_self(user)
	return ..()

/obj/item/modular_computer/pda/wrist/MouseDrop(var/obj/over_object)
	if(ishuman(usr))
		if(loc != usr) return
		if(usr.restrained() || usr.incapacitated()) return
		if (!usr.unEquip(src)) return
		usr.put_in_hands(src)
		src.add_fingerprint(usr)
		return
	return ..()

// wrist box
/obj/item/weapon/storage/box/wrist
	name = "box of spare wrist computers"
	desc = "A box of spare wrist microcomputers."
	icon_state = "pda"
	startswith = list(/obj/item/modular_computer/pda/wrist = 5)

// wrist types

/obj/item/modular_computer/pda/wrist/medical
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/chemistry
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/engineering
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/security
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/forensics
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/science
	stripe_color = COLOR_RESEARCH

/obj/item/modular_computer/pda/wrist/heads
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/heads/paperpusher
	stored_pen = /obj/item/weapon/pen/fancy

/obj/item/modular_computer/pda/wrist/heads/hop
	stripe_color = COLOR_SKY_BLUE

/obj/item/modular_computer/pda/wrist/heads/hos
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/heads/ce
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/heads/cmo
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/heads/rd
	stripe_color = COLOR_RESEARCH

/obj/item/modular_computer/pda/wrist/captain
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_YELLOW

/obj/item/modular_computer/pda/wrist/ert
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_YELLOW

/obj/item/modular_computer/pda/wrist/cargo
	stripe_color = COLOR_PALE_YELLOW

/obj/item/modular_computer/pda/wrist/syndicate
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/roboticist
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/explorer
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_INDIGO

/obj/item/modular_computer/pda/wrist/grey
	color = COLOR_GRAY

/obj/item/modular_computer/pda/wrist/lila
	color = null
	icon_state = "wrist-lila"
	icon_state_unpowered = "wrist-lila"

/obj/item/modular_computer/pda/wrist/lila/black
	icon_state = "wrist-lila-black"
	icon_state_unpowered = "wrist-lila-black"
