/turf/proc/ReplaceWithLattice(var/material)
	src.ChangeTurf(get_base_turf_by_area(src))
	new /obj/structure/lattice( locate(src.x, src.y, src.z), material )

// Removes all signs of lattice on the pos of the turf -Donkieyo
/turf/proc/RemoveLattice()
	var/obj/structure/lattice/L = locate(/obj/structure/lattice, src)
	if(L)
		qdel(L)
// Called after turf replaces old one
/turf/proc/post_change()
	levelupdate()
	var/turf/simulated/open/T = GetAbove(src)
	if(istype(T))
		T.update_icon()

//Creates a new turf
/turf/proc/ChangeTurf(var/turf/N, var/tell_universe = TRUE, var/force_lighting_update = FALSE, var/keep_air = FALSE)
	if (!N)
		return

	// This makes sure that turfs are not changed to space when one side is part of a zone
	if(N == /turf/space)
		var/turf/below = GetBelow(src)
		if(istype(below) && !istype(below,/turf/space))
			N = /turf/simulated/open

	var/old_air = air
	var/old_fire = fire
	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_affecting_lights = affecting_lights
	var/old_lighting_overlay = lighting_overlay
	var/old_corners = corners

//	log_debug("Replacing [src.type] with [N]")


	if(connections) connections.erase_all()

	overlays.Cut()
	underlays.Cut()
	if(istype(src,/turf/simulated))
		//Yeah, we're just going to rebuild the whole thing.
		//Despite this being called a bunch during explosions,
		//the zone will only really do heavy lifting once.
		var/turf/simulated/S = src
		if(S.zone) S.zone.rebuild()

	// Closest we can do as far as giving sane alerts to listeners. In particular, this calls Exited and moved events in a self-consistent way.
	var/list/old_contents = list()
	for(var/atom/movable/A in src)
		old_contents += A
		A.forceMove(null)

	var/turf/simulated/W = new N( locate(src.x, src.y, src.z) )
	for(var/atom/movable/A in old_contents)
		A.forceMove(W)

	W.opaque_counter = opaque_counter

	if (keep_air)
		W.air = old_air

	if(ispath(N, /turf/simulated))
		if(old_fire)
			fire = old_fire
		if (istype(W,/turf/simulated/floor))
			W.RemoveLattice()
	else if(old_fire)
		qdel(old_fire)

	if(tell_universe)
		GLOB.universe.OnTurfChange(W)

	SSair.mark_for_update(src) //handle the addition of the new turf.

	for(var/turf/space/S in range(W,1))
		S.update_starlight()

	W.post_change()
	. = W

	if(lighting_overlays_initialised)
		lighting_overlay = old_lighting_overlay
		affecting_lights = old_affecting_lights
		corners = old_corners
		if((old_opacity != opacity) || (dynamic_lighting != old_dynamic_lighting))
			reconsider_lights()
		if(dynamic_lighting != old_dynamic_lighting)
			if(dynamic_lighting)
				lighting_build_overlay()
			else
				lighting_clear_overlay()

/turf/proc/transport_properties_from(turf/other)
	if(!istype(other, src.type))
		return 0
	src.set_dir(other.dir)
	src.icon_state = other.icon_state
	src.icon = other.icon
	src.overlays = other.overlays.Copy()
	src.underlays = other.underlays.Copy()
	if(other.decals)
		src.decals = other.decals.Copy()
		src.update_icon()
	return 1

//I would name this copy_from() but we remove the other turf from their air zone for some reason
/turf/simulated/transport_properties_from(turf/simulated/other)
	if(!..())
		return 0

	if(other.zone)
		if(!src.air)
			src.make_air()
		src.air.copy_from(other.zone.air)
		other.zone.remove(other)
	return 1

/turf/simulated/wall/transport_properties_from(turf/simulated/wall/other)
	if(!..())
		return 0
	paint_color = other.paint_color
	stripe_color = other.stripe_color
	return 1

//No idea why resetting the base appearence from New() isn't enough, but without this it doesn't work
/turf/simulated/shuttle/wall/corner/transport_properties_from(turf/simulated/other)
	. = ..()
	reset_base_appearance()
