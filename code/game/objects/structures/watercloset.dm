//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos
/obj/structure/hygiene
	var/next_gurgle = 0
	var/clogged = 0 // -1 = never clog

/obj/structure/hygiene/New()
	..()
	SSfluids.hygiene_props += src

/obj/structure/hygiene/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	SSfluids.hygiene_props -= src
	. = ..()

/obj/structure/hygiene/proc/clog(var/severity)
	if(clogged) //We can only clog if our state is zero, aka completely unclogged and cloggable
		return FALSE
	clogged = severity
	START_PROCESSING(SSprocessing, src)
	return TRUE

/obj/structure/hygiene/proc/unclog()
	clogged = 0
	STOP_PROCESSING(SSprocessing, src)

/obj/structure/hygiene/attackby(var/obj/item/thing, var/mob/user)
	if(clogged > 0 && isPlunger(thing))
		user.visible_message("<span class='notice'>\The [user] strives valiantly to unclog \the [src] with \the [thing]!</span>")
		spawn
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
			sleep(5)
			playsound(loc, 'sound/effects/plunger.ogg', 75, 1)
		if(do_after(user, 45, src) && clogged > 0)
			visible_message("<span class='notice'>With a loud gurgle, \the [src] begins flowing more freely.</span>")
			playsound(loc, pick(SSfluids.gurgles), 100, 1)
			clogged--
			if(clogged <= 0)
				unclog()
		return
	. = ..()

/obj/structure/hygiene/examine()
	. = ..()
	if(clogged > 0)
		to_chat(usr, "<span class='warning'>It seems to be badly clogged.</span>")

/obj/structure/hygiene/Process()
	if(clogged <= 0)
		return
	var/flood_amt
	switch(clogged)
		if(1)
			flood_amt = FLUID_SHALLOW
		if(2)
			flood_amt = FLUID_OVER_MOB_HEAD
		if(3)
			flood_amt = FLUID_DEEP
	if(flood_amt)
		var/turf/T = loc
		if(istype(T))
			var/obj/effect/fluid/F = locate() in T
			if(!F) F = new(loc)
			T.show_bubbles()
			if(world.time > next_gurgle)
				visible_message("\The [src] gurgles and overflows!")
				next_gurgle = world.time + 80
				playsound(T, pick(SSfluids.gurgles), 50, 1)
			SET_FLUID_DEPTH(F, min(F.fluid_amount + (rand(30,50)*clogged), flood_amt))

/obj/structure/hygiene/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet00"
	density = 0
	anchored = 1
	can_buckle = 1
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/hygiene/toilet/Initialize()
	. = ..()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/hygiene/toilet/attack_hand(var/mob/living/user)
	if (buckled_mob)
		..()
		return
	if(swirlie)
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(8)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, "<span class='notice'>The cistern is empty.</span>")
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.dropInto(loc)
			to_chat(user, "<span class='notice'>You find \an [I] in the cistern.</span>")
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/hygiene/toilet/on_update_icon()
	icon_state = "toilet[open][cistern]"

/obj/structure/hygiene/toilet/attackby(obj/item/I as obj, var/mob/living/user)
	if(isWrench(I))
		var/choices = list()
		if(anchored)
			choices += "Disconnect"
		else
			choices += "Connect"
			choices += "Rotate"

		var/response = input(user, "What do you want to do?", "[src]") as null|anything in choices
		if(!Adjacent(user) || !response)	//moved away or cancelled
			return
		switch(response)
			if("Disconnect")
				user.visible_message("<span class='notice'>[user] starts disconnecting [src].</span>", "<span class='notice'>You begin disconnecting [src]...</span>")
				if(do_after(user, 40, target = src))
					if(!loc || !anchored)
						return
					user.visible_message("<span class='notice'>[user] disconnects [src]!</span>", "<span class='notice'>You disconnect [src]!</span>")
					anchored = 0
					update_icon()
			if("Connect")
				user.visible_message("<span class='notice'>[user] starts connecting [src].</span>", "<span class='notice'>You begin connecting [src]...</span>")
				if(do_after(user, 40, target = src))
					if(!loc || anchored)
						return
					user.visible_message("<span class='notice'>[user] connects [src]!</span>", "<span class='notice'>You connect [src]!</span>")
					anchored = 1
					update_icon()
			if("Rotate")
				var/list/dir_choices = list("North" = NORTH, "East" = EAST, "South" = SOUTH, "West" = WEST)
				var/selected = input(user,"Select a direction for the connector.", "Connector Direction") in dir_choices
				dir = dir_choices[selected]
				update_icon()	//is this necessary? probably not
		return

	if(isCrowbar(I))
		to_chat(user, "<span class='notice'>You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"].</span>")
		playsound(loc, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30, src))
			user.visible_message("<span class='notice'>[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!</span>", "<span class='notice'>You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!</span>", "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			var/mob/living/GM = G.affecting
			if(!GM.loc == get_turf(src))
				to_chat(user, "<span class='warning'>\The [GM] needs to be on the toilet.</span>")
				return
			if(open && !swirlie)
				user.visible_message("<span class='danger'>\The [user] starts jamming \the [GM]'s face into \the [src]!</span>")
				swirlie = GM
				if(do_after(user, 30, src))
					user.visible_message("<span class='danger'>\The [user] gives [GM.name] a swirlie!</span>")
					GM.adjustOxyLoss(5)
				swirlie = null
			else
				user.visible_message("<span class='danger'>\The [user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
				GM.adjustBruteLoss(8)

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > ITEM_SIZE_NORMAL)
			to_chat(user, "<span class='warning'>\The [I] does not fit.</span>")
			return
		if(w_items + I.w_class > 5)
			to_chat(user, "<span class='warning'>The cistern is full.</span>")
			return
		if(!user.unEquip(I, src))
			return
		w_items += I.w_class
		to_chat(user, "<span class='notice'>You carefully place \the [I] into the cistern.</span>")
		return
	. = ..()

/obj/structure/hygiene/toilet/proc/can_place(var/mob/target, var/mob/user)
	for(var/obj/item/grab/G in target.grabbed_by)
		if (G.force_danger())
			return 1
	return 0

	. = ..()

/obj/structure/hygiene/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = 0
	anchored = 1

/obj/structure/hygiene/urinal/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(!GM.loc == get_turf(src))
				to_chat(user, "<span class='warning'>[GM.name] needs to be on the urinal.</span>")
				return
			user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>")
			GM.adjustBruteLoss(8)
	. = ..()

/obj/structure/hygiene/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2200s by the Hygiene Division."
	icon = 'icons/obj/watercloset_inf.dmi'
	icon_state = "shower"
	density = 0
	anchored = 1
	clogged = -1

	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/is_washing = 0
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)

	var/sound_id
	var/datum/sound_token/sound_token

/obj/structure/hygiene/shower/Initialize()
	. = ..()
	sound_id = "[type]_[sequential_id(type)]"

/obj/structure/hygiene/shower/Destroy()
	QDEL_NULL(sound_token)
	return ..()

/obj/structure/hygiene/shower/New()
	..()
	create_reagents(50)
	START_PROCESSING(SSprocessing, src)

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	layer = MOB_LAYER + 1
	anchored = 1
	mouse_opacity = 0

/obj/structure/hygiene/shower/attack_hand(var/mob/M)
	on = !on
	update_icon()
	if(on)
		QDEL_NULL(sound_token)
		playsound(src.loc, 'infinity/sound/machines/shower_start.ogg', 40)
		sound_token = GLOB.sound_player.PlayLoopingSound(src, sound_id, 'infinity/sound/machines/shower_mid3.ogg', volume = 20, range = 7, falloff = 4, prefer_mute = TRUE)
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood()
	else
		QDEL_NULL(sound_token)
		playsound(src.loc, 'infinity/sound/machines/shower_end.ogg', 40)

/obj/structure/hygiene/shower/attackby(obj/item/I as obj, var/mob/user)
	if(istype(I, /obj/item/device/scanner/gas))
		to_chat(user, "<span class='notice'>The water temperature seems to be [watertemp].</span>")
		return

	if(isWrench(I))
		var/newtemp = input(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve") in temperature_settings
		to_chat(user,"<span class='notice'>You begin to adjust the temperature valve with \the [I].</span>")
		playsound(src.loc, 'sound/items/Ratchet.ogg', 50, 1)
		if(do_after(user, 50, src))
			watertemp = newtemp
			user.visible_message("<span class='notice'>\The [user] adjusts \the [src] with \the [I].</span>", "<span class='notice'>You adjust the shower with \the [I].</span>")
			add_fingerprint(user)
			return
	. = ..()

/obj/structure/hygiene/shower/on_update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	overlays.Cut()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)
		mymist = null

	if(on)
		overlays += image('icons/obj/watercloset_inf.dmi', src, "water", MOB_LAYER + 1, dir)
		if(temperature_settings[watertemp] < T20C)
			return //no mist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(250)
			if(src && !on)
				qdel(mymist)
				mymist = null
				ismist = 0

//Yes, showers are super powerful as far as washing goes.
/obj/structure/hygiene/shower/proc/wash(var/atom/movable/washing)
	if(on)
		wash_mob(washing)
		if(isturf(loc))
			var/turf/tile = loc
			for(var/obj/effect/E in tile)
				if(istype(E,/obj/effect/decal/cleanable) || istype(E,/obj/effect/overlay))
					qdel(E)
		reagents.splash(washing, 10)

/obj/structure/hygiene/shower/Process()
	if(!on) return

	for(var/thing in loc)
		var/atom/movable/AM = thing
		var/mob/living/L = thing
		if(istype(AM) && AM.simulated)
			wash(AM)
			if(istype(L))
				process_heat(L)
	wash_floor()
	reagents.add_reagent(/datum/reagent/water, reagents.get_free_space())

/obj/structure/hygiene/shower/proc/wash_floor()
	if(!ismist && is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
	reagents.splash(T, reagents.total_volume)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/structure/hygiene/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/water_temperature = temperature_settings[watertemp]
	var/temp_adj = between(BODYTEMP_COOLING_MAX, water_temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(water_temperature >= H.species.heat_level_1)
			to_chat(H, "<span class='danger'>The water is searing hot!</span>")
		else if(water_temperature <= H.species.cold_level_1)
			to_chat(H, "<span class='warning'>The water is freezing cold!</span>")

/obj/item/weapon/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"

/obj/structure/hygiene/sink
	name = "sink"
//	icon = 'icons/obj/watercloset.dmi'
	icon = 'icons/obj/watercloset_inf.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = 1
	var/busy = 0 	//Something's being washed at the moment
	var/graffiti = 0 	//removing this?

/obj/structure/hygiene/sink/MouseDrop_T(var/obj/item/thing, var/mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!usr.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, "<span class='warning'>\The [thing] is empty.</span>")
		return
	// Clear the vessel.
	visible_message("<span class='notice'>\The [usr] tips the contents of \the [thing] into \the [src].</span>")
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/hygiene/sink/attack_hand(var/mob/user)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		var/target_zone = H.zone_sel.selecting
		if((target_zone == BP_HEAD) && (H.organs_by_name[BP_HEAD]) && (H.organs_by_name[BP_HEAD].forehead_graffiti))
			graffiti = 1
		if (user.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user,"<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	if(graffiti)
		to_chat(usr, "<span class='notice'>You start removing your graffiti and washing your hands.</span>")
	else
		to_chat(usr, "<span class='notice'>You start washing your hands.</span>")

	busy = 1
	sleep(40)
	busy = 0

	if(!Adjacent(user)) return		//Person has moved away from the sink

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		if(graffiti)
			V.show_message("<span class='notice'>[user] washes their hands and head using \the [src].</span>")
		else
			V.show_message("<span class='notice'>[user] washes their hands using \the [src].</span>")

	if(graffiti)
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/head/I = H.organs_by_name[BP_HEAD]
		I.remove_graffiti()
		graffiti = 0

/obj/structure/hygiene/sink/attackby(obj/item/O as obj, var/mob/living/user)

	if(isPlunger(O) && clogged > 0)
		return ..()

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	var/obj/item/weapon/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container() && RG.reagents)
		RG.reagents.add_reagent(/datum/reagent/water, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
		return 1

	else if (istype(O, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message( \
					"<span class='danger'>[user] was stunned by \his wet [O]!</span>", \
					"<span class='userdanger'>[user] was stunned by \his wet [O]!</span>")
				return 1
	else if(istype(O, /obj/item/weapon/mop))
		O.reagents.add_reagent(/datum/reagent/water, 5)
		to_chat(user, "<span class='notice'>You wet \the [O] in \the [src].</span>")
		playsound(loc, 'sound/effects/slosh.ogg', 25, 1)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

	busy = 1
	sleep(40)
	busy = 0

	if(user.loc != location) return				//User has moved
	if(!I) return 								//Item's been destroyed while washing
	if(user.get_active_hand() != I) return		//Person has switched hands or the item in their hands

	O.clean_blood()
	user.visible_message( \
		"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
		"<span class='notice'>You wash \a [I] using \the [src].</span>")


/obj/structure/hygiene/sink/kitchen
	name = "kitchen sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink_alt"

/obj/structure/hygiene/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "puddle"
	clogged = -1 // how do you clog a puddle

/obj/structure/hygiene/sink/puddle/attack_hand(var/mob/M)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/hygiene/sink/puddle/attackby(obj/item/O as obj, var/mob/user)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"