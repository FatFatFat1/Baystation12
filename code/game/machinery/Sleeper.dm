/obj/machinery/sleeper
	name = "sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	var/base_icon = "sleeper"
	density = 1
	anchored = 1
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	var/mob/living/carbon/human/occupant = null
	var/list/base_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Soporific" = /datum/reagent/soporific, "Paracetamol" = /datum/reagent/paracetamol, "Dylovene" = /datum/reagent/dylovene, "Dexalin" = /datum/reagent/dexalin)
	var/list/available_chemicals = list()
	var/list/upgrade_chemicals = list("Kelotane" = /datum/reagent/kelotane)
	var/list/upgrade2_chemicals = list("Hyronalin" = /datum/reagent/hyronalin)
	var/list/antag_chemicals = list("Hair Remover" = /datum/reagent/toxin/hair_remover, "Chloral Hydrate" = /datum/reagent/chloralhydrate)
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0
	var/pump
	var/list/stasis_settings = list(1, 2, 5, 10)
	var/stasis = 1
	var/synth_modifier = 1
	var/pump_speed

	idle_power_usage = 15
	active_power_usage = 1 KILOWATTS //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/Initialize()
	. = ..()
	component_parts = list(
		new /obj/item/weapon/circuitboard/sleeper,
		new /obj/item/weapon/stock_parts/scanning_module,
		new /obj/item/weapon/stock_parts/manipulator,
		new /obj/item/weapon/stock_parts/manipulator,
		new /obj/item/weapon/stock_parts/console_screen,
		new /obj/item/weapon/reagent_containers/syringe,
		new /obj/item/weapon/reagent_containers/syringe,
		new /obj/item/weapon/reagent_containers/glass/beaker/large)
	RefreshParts()

	beaker = locate(/obj/item/weapon/reagent_containers/glass/beaker/large) in component_parts
	update_icon()

/obj/machinery/sleeper/RefreshParts()
	var/U = 0

	for(var/obj/item/weapon/stock_parts/P in component_parts)
		if(istype(P, /obj/item/weapon/stock_parts/manipulator))
			U += P.rating
		if(istype(P, /obj/item/weapon/stock_parts/scanning_module))
			U += P.rating

	switch(U)
		if(0 to 5)
			available_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Soporific" = /datum/reagent/soporific, "Paracetamol" = /datum/reagent/paracetamol, "Dylovene" = /datum/reagent/dylovene, "Dexalin" = /datum/reagent/dexalin)
		if(6 to 8)
			available_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Soporific" = /datum/reagent/soporific, "Tramadol" = /datum/reagent/tramadol, "Dylovene" = /datum/reagent/dylovene, "Hyronalin" = /datum/reagent/hyronalin, "Dexalin" = /datum/reagent/dexalin, "Kelotane" = /datum/reagent/kelotane)
		else
			available_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Soporific" = /datum/reagent/soporific, "Tramadol" = /datum/reagent/tramadol, "Dylovene" = /datum/reagent/dylovene, "Arithrazine" = /datum/reagent/arithrazine, "Dexalin Plus" = /datum/reagent/dexalinp, "Dermaline" = /datum/reagent/dermaline, "Bicaridine" = /datum/reagent/bicaridine, "Alkysine" = /datum/reagent/alkysine)

/obj/machinery/sleeper/examine(mob/user)
	. = ..()
	if (. && user.Adjacent(src))
		if (beaker)
			to_chat(user, "It is loaded with a beaker.")
		if(occupant)
			occupant.examine(user)
		if (emagged && user.skill_check(SKILL_MEDICAL, SKILL_EXPERT))
			to_chat(user, "The sleeper chemical synthesis controls look tampered with.")


/obj/machinery/sleeper/Process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, pump_speed)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()
	if(pump > 0)
		if(beaker && istype(occupant))
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/datum/reagents/ingested = occupant.get_ingested_reagents()
				if(ingested)
					for(var/datum/reagent/x in ingested.reagent_list)
						ingested.trans_to_obj(beaker, pump_speed)
		else
			toggle_pump()

	if(iscarbon(occupant) && stasis > 1)
		occupant.SetStasis(stasis)

/obj/machinery/sleeper/on_update_icon()
	icon_state = "[base_icon]_[occupant ? "1" : "0"]"

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return 1

	ui_interact(user)

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["name"] = T
		if(occupant && occupant.reagents)
			reagent["amount"] = occupant.reagents.get_reagent_amount(T)
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		var/scan = user.skill_check(SKILL_MEDICAL, SKILL_ADEPT) ? medical_scan_results(occupant) : "<span class='white'><b>Contains: \the [occupant]</b></span>"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		data["occupant"] = scan
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering
	data["pump"] = pump
	data["stasis"] = stasis
	data["skill_check"] = user.skill_check(SKILL_MEDICAL, SKILL_BASIC)

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/sleeper/CanUseTopic(user)
	if(user == occupant)
		to_chat(usr, "<span class='warning'>You can't reach the controls from the inside.</span>")
		return STATUS_CLOSE
	. = ..()

/obj/machinery/sleeper/OnTopic(user, href_list)
	if(href_list["eject"])
		go_out()
		return TOPIC_REFRESH
	if(href_list["beaker"])
		remove_beaker()
		return TOPIC_REFRESH
	if(href_list["filter"])
		if(filtering != text2num(href_list["filter"]))
			toggle_filter()
			return TOPIC_REFRESH
	if(href_list["pump"])
		if(filtering != text2num(href_list["pump"]))
			toggle_pump()
			return TOPIC_REFRESH
	if(href_list["chemical"] && href_list["amount"])
		if(occupant && occupant.stat != DEAD)
			if(href_list["chemical"] in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(user, href_list["chemical"], text2num(href_list["amount"]))
				return TOPIC_REFRESH
	if(href_list["stasis"])
		var/nstasis = text2num(href_list["stasis"])
		if(stasis != nstasis && nstasis in stasis_settings)
			stasis = text2num(href_list["stasis"])
			change_power_consumption(initial(active_power_usage) + 5 KILOWATTS * (stasis-1), POWER_USE_ACTIVE)
			return TOPIC_REFRESH

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(default_deconstruction_screwdriver(user, I))
		updateUsrDialog()
		go_out()
		return
	if(default_deconstruction_crowbar(user, I))
		return
	if(default_part_replacement(user, I))
		return
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		add_fingerprint(user)
		if(!beaker)
			if(!user.unEquip(I, src))
				return
			beaker = I
			user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			to_chat(user, "<span class='warning'>\The [src] has a beaker already.</span>")
		return
	else
		..()

/obj/machinery/sleeper/dismantle()
	if(occupant)
		go_out()
	..()

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(..()) //anti-ghost
		return
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	if(panel_open)
		to_chat(user, "<span class='warning'>Close the maintenance panel before attempting to place the subject in the sleeper.</span>")
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)
/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	to_chat(occupant, "<span class='warning'>You feel like your blood is being sucked away.</span>")
	filtering = !filtering

/obj/machinery/sleeper/proc/toggle_pump()
	if(!occupant || !beaker)
		pump = 0
		return
	to_chat(occupant, "<span class='warning'>You feel a tube jammed down your throat.</span>")
	pump = !pump

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		set_occupant(M)

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	if(occupant.loc == src)
		if(not_turf_contains_dense_objects(get_turf(get_step(loc, dir))))
			occupant.dropInto(get_step(loc, dir))
		else
			occupant.dropInto(loc)
	set_occupant(null)

	for(var/obj/O in (contents - component_parts)) // In case an object was dropped inside or something. Excludes the beaker and component parts.
		if(O == beaker)
			continue
		O.dropInto(loc)
	toggle_filter()

/obj/machinery/sleeper/proc/set_occupant(var/mob/living/carbon/occupant)
	src.occupant = occupant
	update_icon()
	if(!occupant)
		SetName(initial(name))
		update_use_power(POWER_USE_IDLE)
		return
	occupant.forceMove(src)
	occupant.stop_pulling()
	if(occupant.client)
		occupant.client.perspective = EYE_PERSPECTIVE
		occupant.client.eye = src
	SetName("[name] ([occupant])")
	update_use_power(POWER_USE_ACTIVE)

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.dropInto(loc)
		beaker = null
		toggle_filter()
		toggle_pump()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical_name, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	var/chemical_type = available_chemicals[chemical_name]
	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical_type) + amount <= 20)
			use_power_oneoff(amount * CHEM_SYNTH_ENERGY * synth_modifier)
			occupant.reagents.add_reagent(chemical_type, amount)
			to_chat(user, "Occupant now has [occupant.reagents.get_reagent_amount(chemical_type)] unit\s of [chemical_name] in their bloodstream.")
		else
			to_chat(user, "The subject has too many chemicals.")
	else
		to_chat(user, "There's no suitable occupant in \the [src].")

/obj/machinery/sleeper/RefreshParts()
	var/T = 0

	for (var/obj/item/weapon/stock_parts/scanning_module/S in component_parts) // scanning modules reduce power required and increase speed of dialysis / stomach pump
		T += S.rating

	T = max(T,1)
	synth_modifier = 1/T
	pump_speed = 2 + T
	T = 0

	for (var/obj/item/weapon/stock_parts/manipulator/M in component_parts) // manipulators unlock new drugs
		T += M.rating

	available_chemicals = base_chemicals.Copy()
	if (T >= 4)
		available_chemicals |= upgrade_chemicals
	if (T >= 6)
		available_chemicals |= upgrade2_chemicals


/obj/machinery/sleeper/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	to_chat(user, "<span class='danger'>You [emagged ? "disable" : "enable"] \the [src]'s chemical synthesis safety checks.</span>")

	if (emagged)
		available_chemicals |= antag_chemicals
	else
		available_chemicals -= antag_chemicals
	return 1

//Survival/Stasis sleepers
/obj/machinery/sleeper/survival_pod
	name = "stasis pod"
	desc = "A comfortable pod for stasing of wounded occupants. Similar pods were on first humanity's colonial ships. Now days, you can see them in EMT centers with stasis setting from 20x to 22x."
	icon_state = "stasis_0"
	base_icon = "stasis"
	stasis = 20
	active_power_usage = 55000

/obj/machinery/sleeper/survival_pod/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	if(occupant)
		var/scan = user.skill_check(SKILL_MEDICAL, SKILL_ADEPT) ? medical_scan_results(occupant) : "<span class='white'><b>Contains: \the [occupant]</b></span>"
		scan = replacetext(scan,"'scan_notice'","'white'")
		scan = replacetext(scan,"'scan_warning'","'average'")
		scan = replacetext(scan,"'scan_danger'","'bad'")
		data["occupant"] = scan
	else
		data["occupant"] = 0

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "stasis.tmpl", "Stasis Pod UI", 400, 300, state = state)
		ui.set_initial_data(data)
		ui.open()
