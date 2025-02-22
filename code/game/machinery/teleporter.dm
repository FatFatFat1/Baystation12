/obj/machinery/computer/teleporter
	name = "Teleporter Control Console"
	desc = "Used to control a linked teleportation hub and station."
	icon_keyboard = "teleport_key"
	icon_screen = "teleport"
	dir = 2
	circuit = /obj/item/weapon/circuitboard/teleporter
	var/obj/machinery/teleport/station/station = null
	var/obj/machinery/teleport/hub/hub = null
	var/obj/item/locked = null
	var/id = null
	var/one_time_use = 0 //Used for one-time-use teleport cards (such as clown planet coordinates.)
						 //Setting this to 1 will set src.locked to null after a player enters the portal and will not allow hand-teles to open portals to that location.

/obj/machinery/computer/teleporter/Initialize()
	. = ..()
	src.id = "[random_id(/obj/machinery/computer/teleporter, 1000, 9999)]"
	underlays.Cut()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "telecomp-wires")
	connect_console()

/obj/machinery/computer/teleporter/proc/connect_console()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		station = locate(/obj/machinery/teleport/station, get_step(src, dir))
		if(station)
			station.com = src
			hub = station.hub
			if(hub && !hub.com)
				hub.com = src
				break

/obj/machinery/computer/teleporter/power_change()
	. = ..()
	if (stat & NOPOWER)
		// Lose memory
		locked = null

/obj/machinery/computer/teleporter/examine(mob/user)
	. = ..()
	if(locked)
		var/turf/T = get_turf(locked)
		to_chat(user, "<span class='notice'>The console is locked on to \[[T.loc.name]\].</span>")


/obj/machinery/computer/teleporter/attackby(var/obj/I, var/mob/living/user)
	if(istype(I, /obj/item/weapon/card/data/))
		var/obj/item/weapon/card/data/C = I
		if(stat & (NOPOWER|BROKEN) & (C.function != "teleporter"))
			attack_hand(user)

		var/obj/L = null

		for(var/obj/effect/landmark/sloc in landmarks_list)
			if(sloc.name != C.data) continue
			if(locate(/mob/living) in sloc.loc) continue
			L = sloc
			break

		if(!L)
			L = locate("landmark*[C.data]") // use old stype


		if(istype(L, /obj/effect/landmark/) && istype(L.loc, /turf))
			if(!user.unEquip(I))
				return
			to_chat(usr, "You insert the coordinates into the machine.")
			to_chat(usr, "A message flashes across the screen reminding the traveller that the nuclear authentication disk is to remain on the [station_name()] at all times.")
			qdel(I)

			if(C.data == "Clown Land")
				//whoops
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='warning'>Incoming bluespace portal detected, unable to lock in.</span>", 2)

				for(var/obj/machinery/teleport/hub/H in range(1))
					var/amount = rand(2,5)
					for(var/i=0;i<amount;i++)
						new /mob/living/simple_animal/hostile/carp(get_turf(H))
				//
			else
				for(var/mob/O in hearers(src, null))
					O.show_message("<span class='notice'>Locked in.</span>", 2)
				src.locked = L
				one_time_use = 1

			src.add_fingerprint(usr)
	else
		..()

	return

/obj/machinery/teleport/station/attack_ai(var/mob/user)
	attack_hand(user)

/obj/machinery/computer/teleporter/attack_hand(var/mob/user)
	if(..()) return

	/* Ghosts can't use this one because it's a direct selection */
	if(isobserver(user)) return

	var/list/L = list()
	var/list/areaindex = list()

	for(var/obj/item/device/radio/beacon/R in world)
		if(!R.functioning)
			continue
		var/turf/T = get_turf(R)
		if (!T)
			continue
		if(!(T.z in GLOB.using_map.player_levels))
			continue
		var/tmpname = T.loc.name
		if(areaindex[tmpname])
			tmpname = "[tmpname] ([++areaindex[tmpname]])"
		else
			areaindex[tmpname] = 1
		L[tmpname] = R

	for (var/obj/item/weapon/implant/tracking/I in world)
		if (!I.implanted || !ismob(I.loc))
			continue
		else
			var/mob/M = I.loc
			if (M.stat == 2)
				if (M.timeofdeath + 6000 < world.time)
					continue
			var/turf/T = get_turf(M)
			if(!T)
				continue
			if(!(T.z in GLOB.using_map.player_levels))
				continue
			var/tmpname = M.real_name
			if(areaindex[tmpname])
				tmpname = "[tmpname] ([++areaindex[tmpname]])"
			else
				areaindex[tmpname] = 1
			L[tmpname] = I

	var/desc = input("Please select a location to lock in.", "Locking Computer") in L|null
	if(!desc)
		return
	if(get_dist(src, usr) > 1 && !issilicon(usr))
		return
	set_target(L[desc])
	for(var/mob/O in hearers(src, null))
		O.show_message("<span class='notice'>Locked In</span>", 2)
	return

/obj/machinery/computer/teleporter/verb/set_id(t as text)
	set category = "Object"
	set name = "Set teleporter ID"
	set src in oview(1)
	set desc = "ID Tag:"

	if(stat & (NOPOWER|BROKEN) || !istype(usr,/mob/living))
		return
	if (t)
		src.id = t
	return

/obj/machinery/computer/teleporter/proc/target_lost()
	audible_message("<span class='warning'>Connection with locked in coordinates has been lost.</span>")
	clear_target()

/obj/machinery/computer/teleporter/proc/clear_target()
	if(src.locked)
		GLOB.destroyed_event.unregister(locked, src, .proc/target_lost)
	src.locked = null
	if(station && station.engaged)
		station.disengage()

/obj/machinery/computer/teleporter/proc/set_target(var/obj/O)
	src.locked = O
	GLOB.destroyed_event.register(locked, src, .proc/target_lost)

/obj/machinery/computer/teleporter/Destroy()
	clear_target()
	station = null
	hub = null
	return ..()

/proc/find_loc(obj/R as obj)
	if (!R)	return null
	var/turf/T = R.loc
	while(!istype(T, /turf))
		T = T.loc
		if(!T || istype(T, /area))	return null
	return T

/obj/machinery/teleport
	name = "teleport"
	icon = 'icons/obj/stationobjs.dmi'
	density = 1
	anchored = 1.0
	var/lockeddown = 0


/obj/machinery/teleport/hub
	name = "teleporter hub"
	desc = "The teleporter hub handles all of the impossibly complex busywork required in instant matter transmission."
	icon_state = "tele0"
	dir = 2
	density = 0
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/computer/teleporter/com
	var/obj/machinery/teleport/station/station

/obj/machinery/teleport/hub/Initialize()
	. = ..()
	underlays.Cut()
	underlays += image('icons/obj/stationobjs.dmi', icon_state = "tele-wires")
	component_parts = list(
		new /obj/item/weapon/circuitboard/teleporter_hub(src),
		new /obj/item/weapon/stock_parts/micro_laser/ultra(src),
		new /obj/item/weapon/stock_parts/micro_laser/ultra(src),
		new /obj/item/weapon/stock_parts/micro_laser/ultra(src),
		new /obj/item/weapon/stock_parts/micro_laser/ultra(src),
		new /obj/item/bluespace_crystal/artificial(src),
		new /obj/item/bluespace_crystal/artificial(src),
		new /obj/item/bluespace_crystal/artificial(src),
		new /obj/item/bluespace_crystal/artificial(src))
	connect_hub()

/obj/machinery/teleport/hub/proc/connect_hub()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		station = locate(/obj/machinery/teleport/station, get_step(src, dir))
		if(station)
			station.hub = src
			com = station.com
			if(com && !com.hub)
				com.hub = src
			break

/obj/machinery/teleport/hub/attackby(var/obj/item/weapon/W, var/mob/user)
	if(station && station.engaged)
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/teleport/hub/Bumped(M as mob|obj)
	spawn()
		if (src.icon_state == "tele1")
			teleport(M)
			use_power_oneoff(5000)

/obj/machinery/teleport/hub/proc/teleport(atom/movable/M as mob|obj)
	do_teleport(M, com.locked)
	if(com.one_time_use) //Make one-time-use cards only usable one time!
		com.one_time_use = 0
		com.locked = null
	return

/obj/machinery/teleport/hub/Destroy()
	com = null
	return ..()

/obj/machinery/teleport/station
	name = "projector"
	desc = "This machine is capable of projecting a miniature wormhole leading directly to its provided target."
	icon_state = "controller"
	dir = 2
	var/engaged = 0
	idle_power_usage = 10
	active_power_usage = 2000
	var/obj/machinery/teleport/hub/hub
	var/obj/machinery/computer/teleporter/com

/obj/machinery/teleport/station/Initialize()
	. = ..()
	overlays.Cut()
	overlays += image('icons/obj/stationobjs.dmi', icon_state = "controller-wires")
	component_parts = list(
		new /obj/item/weapon/circuitboard/teleporter_station(src),
		new /obj/item/weapon/stock_parts/manipulator/pico(src),
		new /obj/item/weapon/stock_parts/scanning_module/phasic(src),
		new /obj/item/weapon/stock_parts/scanning_module/phasic(src),
		new /obj/item/weapon/stock_parts/subspace/filter(src),
		new /obj/item/weapon/stock_parts/subspace/analyzer(src),
		new /obj/item/weapon/stock_parts/subspace/transmitter(src))
	connect_station()

/obj/machinery/teleport/station/proc/connect_station()
	for(var/dir in list(NORTH,EAST,SOUTH,WEST))
		com = locate(/obj/machinery/computer/teleporter, get_step(src, dir))
		if(com)
			if(!com.station)
				com.station = src
			if(!com.hub)
				com.hub = hub
		hub = locate(/obj/machinery/teleport/hub, get_step(src, dir))
		if(hub)
			if(!hub.com)
				hub.com = com

/obj/machinery/teleport/station/attackby(var/obj/item/weapon/W, var/mob/user)
	if(engaged)
		return
	if(default_deconstruction_screwdriver(user, W))
		return
	if(default_deconstruction_crowbar(user, W))
		return
	if(default_part_replacement(user, W))
		return

/obj/machinery/teleport/station/attack_ai(var/mob/user)
	attack_hand(user)

/obj/machinery/teleport/station/attack_hand(var/mob/user)
	. = ..()
	if(engaged)
		src.disengage()
	else
		src.engage()

/obj/machinery/teleport/station/proc/engage()
	if(stat & (BROKEN|NOPOWER))
		return

	if (com && !com.locked)
		audible_message("<span class='warning'>Failure: Cannot authenticate locked on coordinates. Please reinstate coordinate matrix.</span>")
		return

	if(istype(com.locked, /obj/item/device/radio/beacon))
		var/obj/item/device/radio/beacon/B = com.locked
		if(!B.functioning)
			audible_message("<span class='warning'>Failure: Unable to establish connection to provided coordinates. Please reinstate coordinate matrix.</span>")
			return

	if (hub)
		hub.icon_state = "tele1"
		use_power_oneoff(5000)
		update_use_power(POWER_USE_ACTIVE)
		hub.update_use_power(POWER_USE_ACTIVE)
		hub.density = 1
		audible_message("<span class='notice'>Teleporter engaged!</span>")
	engaged = 1
	return

/obj/machinery/teleport/station/proc/disengage()
	if(stat & BROKEN)
		return

	if (hub)
		hub.icon_state = "tele0"
		hub.update_use_power(POWER_USE_IDLE)
		update_use_power(POWER_USE_IDLE)
		hub.density = 0
		audible_message("<span class='notice'>Teleporter disengaged!</span>")
	engaged = 0
	return

/obj/machinery/teleport/station/Destroy()
	disengage()
	com = null
	hub = null
	return ..()

/obj/machinery/teleport/station/power_change()
	. = ..()
	if (engaged && (stat & NOPOWER))
		disengage()

/obj/machinery/teleport/station/on_update_icon()
	if(stat & NOPOWER)
		icon_state = "controller-p"
	else
		icon_state = "controller"
