/obj/machinery/autolathe
	name = "autolathe"
	desc = "It produces items using metal, glass, plastic, and aluminium. It has a built in shredder that can recycle most items, although any materials it cannot use will be wasted."
	icon_state = "autolathe"
	density = 1
	anchored = 1
	idle_power_usage = 10
	active_power_usage = 2000
	clicksound = "keyboard"
	clickvol = 30
	layer = BELOW_OBJ_LAYER

	var/list/machine_recipes
	var/list/stored_material =  list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_GLASS = 0, MATERIAL_PLASTIC = 0)
	var/list/storage_capacity = list(MATERIAL_STEEL = 0, MATERIAL_ALUMINIUM = 0, MATERIAL_GLASS = 0, MATERIAL_PLASTIC = 0)
	var/show_category = "All"

	var/hacked = 0
	var/disabled = 0
	var/shocked = 0
	var/busy = 0

	var/mat_efficiency = 1
	var/build_time = 50

	var/datum/wires/autolathe/wires = null


/obj/machinery/autolathe/New()

	..()
	wires = new(src)
	//Create parts for lathe.
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/autolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/console_screen(src)
	RefreshParts()

/obj/machinery/autolathe/Destroy()
	qdel(wires)
	wires = null
	return ..()

/obj/machinery/autolathe/proc/update_recipe_list()
	if(!machine_recipes)
		machine_recipes = autolathe_recipes

/obj/machinery/autolathe/interact(mob/user as mob)

	update_recipe_list()

	if(..() || (disabled && !panel_open))
		to_chat(user, "<span class='danger'>\The [src] is disabled!</span>")
		return

	if(shocked)
		shock(user, 50)

	var/dat = "<center><h1>Autolathe Control Panel</h1><hr/>"
	var/operator_device_skill = list(1.5, 1, 0.9, 0.8, 0.75)[user.get_skill_value(SKILL_DEVICES)]

	if(!disabled)
		dat += "<table width = '100%'>"
		var/material_top = "<tr>"
		var/material_bottom = "<tr>"

		for(var/material in stored_material)
			material_top += "<td width = '25%' align = center><b>[material]</b></td>"
			material_bottom += "<td width = '25%' align = center>[stored_material[material]]<b>/[storage_capacity[material]]</b></td>"

		dat += "[material_top]</tr>[material_bottom]</tr></table><hr>"
		dat += "<h2>Printable Designs</h2><h3>Showing: <a href='?src=\ref[src];change_category=1'>[show_category]</a>.</h3></center><table width = '100%'>"

		var/index = 0
		for(var/datum/autolathe/recipe/R in machine_recipes)
			index++
			if((!user.skill_check(SKILL_DEVICES, SKILL_EXPERT) && (R.hidden && !hacked)) || (show_category != "All" && show_category != R.category))
				continue
			var/can_make = 1
			var/material_string = ""
			var/multiplier_string = ""
			var/max_sheets
			var/comma
			if(!R.resources || !R.resources.len)
				material_string = "No resources required.</td>"
			else
				//Make sure it's buildable and list requires resources.
				for(var/material in R.resources)
					var/sheets = round(stored_material[material]/round(R.resources[material]*mat_efficiency))
					if(isnull(max_sheets) || max_sheets > sheets)
						max_sheets = sheets
					if(!isnull(stored_material[material]) && stored_material[material] < round(R.resources[material]*mat_efficiency*(R.is_stack ? 1 : operator_device_skill)))
						can_make = 0
					if(!comma)
						comma = 1
					else
						material_string += ", "
					material_string += "[round(R.resources[material] * mat_efficiency * (R.is_stack ? 1 : operator_device_skill))] [material]"
				material_string += ".<br></td>"
				//Build list of multipliers for sheets.
				if(R.is_stack)
					var/obj/item/stack/R_stack = R.path
					max_sheets = min(max_sheets, initial(R_stack.max_amount))
					//do not allow lathe to print more sheets than the max amount that can fit in one stack
					if(max_sheets && max_sheets > 0)
						multiplier_string  += "<br>"
						for(var/i = 5;i<max_sheets;i*=2) //5,10,20,40...
							multiplier_string  += "<a href='?src=\ref[src];make=[index];multiplier=[i]'>\[x[i]\]</a>"
						multiplier_string += "<a href='?src=\ref[src];make=[index];multiplier=[max_sheets]'>\[x[max_sheets]\]</a>"
			dat += "<tr><td width = 180>[R.hidden ? "<font color = 'red'>*</font>" : ""]<b>[can_make ? "<a href='?src=\ref[src];make=[index];multiplier=1'>" : ""][R.name][can_make ? "</a>" : ""]</b>[R.hidden ? "<font color = 'red'>*</font>" : ""][multiplier_string]</td><td align = right>[material_string]</tr>"

		dat += "</table><hr>"
	//Hacking.
	if(panel_open)
		dat += "<h2>Maintenance Panel</h2>"
		dat += wires.GetInteractWindow(user)

		dat += "<hr>"

	var/datum/browser/popup = new(user, "autolathenew", "Autholathe", 450, 600)
	popup.set_content(dat)
	popup.open()

/obj/machinery/autolathe/attackby(var/obj/item/O as obj, var/mob/user as mob)

	if(busy)
		to_chat(user, SPAN_NOTICE("\The [src] is busy. Please wait for completion of previous operation."))
		return

	if(default_deconstruction_screwdriver(user, O))
		updateUsrDialog()
		return
	if(default_deconstruction_crowbar(user, O))
		return

	if(panel_open)
		if(default_part_replacement(user, O))
			return

	if(stat)
		return

	if(panel_open)
		if(isMultitool(O) || isWirecutter(O))
			attack_hand(user)
			return
	else
		if(istype(O, /obj/item/weapon/storage/part_replacer))
			var/obj/item/weapon/storage/part_replacer/R = O
			var/hasparts = 0
			var/filltype = 0
			for(var/obj/item/weapon/stock_parts/S in R.contents)
				if(S.rating >= 3)	//i'm not sure but eh.
					continue

				var/list/taking_matter = S.matter
				var/eaten = 0
				hasparts = 1
				for(var/material in taking_matter)
					if(stored_material[material] >= storage_capacity[material])
						continue

					var/total_material = taking_matter[material]

					if(stored_material[material] + total_material > storage_capacity[material])
						total_material = storage_capacity[material] - stored_material[material]
						filltype = 1

					else
						filltype = 2

					eaten = 1
					stored_material[material] += total_material
				if(eaten)
					R.remove_from_storage(S, src)
					qdel(S)

			if(!hasparts)
				to_chat(user, SPAN_NOTICE("\The [R] is empty.\nFollowing parts detected in the machine:"))
				for(var/var/obj/item/C in component_parts)
					to_chat(user, SPAN_NOTICE("	[C.name]"))
				return

			if(!filltype)
				to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.\nFollowing parts detected in the machine:</span>")
				for(var/var/obj/item/C in component_parts)
					to_chat(user, SPAN_NOTICE("	[C.name]"))
				return
			else if(filltype == 1)
				to_chat(user, SPAN_NOTICE("You fill \the [src] to capacity with \the [O]."))
			else
				to_chat(user, SPAN_NOTICE("You empty \the [O] into \the [src]."))

			flick("autolathe_o", src)
			updateUsrDialog()

			return
	if(O.loc != user && !(istype(O,/obj/item/stack)))
		return 0

	if(is_robot_module(O))
		return 0

	//Resources are being loaded.
	var/obj/item/eating = O
	var/list/taking_matter

	if(istype(eating, /obj/item/stack/material))
		var/obj/item/stack/material/mat = eating
		taking_matter = list()
		for(var/matname in eating.matter)
			taking_matter[matname] = Floor(eating.matter[matname]/mat.amount)
	else
		taking_matter = eating.matter

	var/found_useful_mat
	if(LAZYLEN(taking_matter))
		for(var/material in taking_matter)
			if(!isnull(stored_material[material]) && !isnull(storage_capacity[material]))
				found_useful_mat = TRUE
				break

	if(!found_useful_mat)
		to_chat(user, "<span class='warning'>\The [eating] does not contain any accessible useful materials and cannot be accepted.</span>")
		return

	var/filltype = 0       // Used to determine message.
	var/total_used = 0     // Amount of material used.
	var/mass_per_sheet = 0 // Amount of material constituting one sheet.

	for(var/material in taking_matter)

		if(stored_material[material] >= storage_capacity[material])
			continue

		var/total_material = taking_matter[material]

		//If it's a stack, we eat multiple sheets.
		if(istype(eating,/obj/item/stack))
			var/obj/item/stack/stack = eating
			total_material *= stack.get_amount()

		if(stored_material[material] + total_material > storage_capacity[material])
			total_material = storage_capacity[material] - stored_material[material]
			filltype = 1
		else
			filltype = 2

		stored_material[material] += total_material
		total_used += total_material
		mass_per_sheet += taking_matter[material]

	if(!filltype)
		to_chat(user, "<span class='notice'>\The [src] is full. Please remove material from the autolathe in order to insert more.</span>")
		return
	else if(filltype == 1)
		to_chat(user, "You fill \the [src] to capacity with \the [eating].")
	else
		to_chat(user, "You fill \the [src] with \the [eating].")

	flick("autolathe_o", src) // Plays metal insertion animation. Work out a good way to work out a fitting animation. ~Z

	if(istype(eating,/obj/item/stack))
		var/obj/item/stack/stack = eating
		stack.use(max(1, round(total_used/mass_per_sheet))) // Always use at least 1 to prevent infinite materials.
	else if(user.unEquip(O))
		qdel(O)

	updateUsrDialog()

/obj/machinery/autolathe/attack_hand(mob/user as mob)
	user.set_machine(src)
	interact(user)

/obj/machinery/autolathe/CanUseTopic(user, href_list)
	if(busy)
		to_chat(user, SPAN_NOTICE("The autolathe is busy. Please wait for completion of previous operation."))
		return min(STATUS_UPDATE, ..())
	return ..()

/obj/machinery/autolathe/OnTopic(mob/user, href_list, state)
	set waitfor = 0
	if(href_list["change_category"])
		var/choice = input("Which category do you wish to display?") as null|anything in autolathe_categories+"All"
		if(!choice || !CanUseTopic(user, state))
			return TOPIC_HANDLED
		show_category = choice
		. = TOPIC_REFRESH

	else if(!busy && href_list["make"] && machine_recipes)
		. = TOPIC_REFRESH
		var/index = text2num(href_list["make"])
		var/multiplier = text2num(href_list["multiplier"])
		var/datum/autolathe/recipe/making
		var/operator_device_skill = list(1.5, 1, 0.9, 0.8, 0.75)[user.get_skill_value(SKILL_DEVICES)]


		if(index > 0 && index <= machine_recipes.len)
			making = machine_recipes[index]

		//Exploit detection, not sure if necessary after rewrite.
		if(!making || multiplier < 0 || multiplier > 100)
			log_and_message_admins("tried to exploit an autolathe to duplicate an item!", user)
			return TOPIC_HANDLED

		busy = 1
		update_use_power(POWER_USE_ACTIVE)

		//Check if we still have the materials.
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				if(stored_material[material] < round(making.resources[material] * mat_efficiency * (making.is_stack ? 1 : operator_device_skill)) * multiplier)
					busy = 0
					return TOPIC_REFRESH

		//Consume materials.
		for(var/material in making.resources)
			if(!isnull(stored_material[material]))
				stored_material[material] = max(0, stored_material[material] - round(making.resources[material] * mat_efficiency * (making.is_stack ? 1 : operator_device_skill)) * multiplier)

		//Fancy autolathe animation.
		flick("autolathe_n", src)

		sleep(build_time * operator_device_skill)

		busy = 0
		update_use_power(POWER_USE_IDLE)

		//Sanity check.
		if(!making || QDELETED(src)) return TOPIC_HANDLED

		//Create the desired item.
		if(!user.skill_check(SKILL_DEVICES, SKILL_BASIC)) // little chance to fail for unskilled users.
			if(prob(10))
				audible_message("<span class='warning'>[pick("You hear a strange noises and some metal crackles.", "You hear a strange buzz from [src].")]</span>")
				return

		var/obj/item/I = new making.path(loc)
		if(making.is_stack && multiplier > 1)
			var/obj/item/stack/S = I
			S.amount = multiplier
			S.update_icon()
			return
		else
			for(var/material in making.resources)
				I.matter[material] = round(making.resources[material] * operator_device_skill * 0.75)

	if(. == TOPIC_REFRESH)
		interact(user)

/obj/machinery/autolathe/on_update_icon()
	icon_state = (panel_open ? "autolathe_t" : "autolathe")

//Updates overall lathe storage size.
/obj/machinery/autolathe/RefreshParts()
	..()
	var/mb_rating = 0
	var/man_rating = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/MB in component_parts)
		mb_rating += MB.rating
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		man_rating += M.rating

	storage_capacity[MATERIAL_STEEL] = mb_rating  * 25000
	storage_capacity[MATERIAL_ALUMINIUM] = mb_rating  * 25000
	storage_capacity[MATERIAL_GLASS] = mb_rating  * 12500
	storage_capacity[MATERIAL_PLASTIC] = mb_rating  * 12500
	build_time = 50 / man_rating
	mat_efficiency = 1.1 - man_rating * 0.1// Normally, price is 1.25 the amount of material, so this shouldn't go higher than 0.8. Maximum rating of parts is 3

/obj/machinery/autolathe/dismantle()

	for(var/mat in stored_material)
		var/material/M = SSmaterials.get_material_by_name(mat)
		if(!istype(M))
			continue
		var/obj/item/stack/material/S = M.place_sheet(get_turf(src), 1, M.name)
		if(stored_material[mat] > S.perunit)
			S.amount = round(stored_material[mat] / S.perunit)
		else
			qdel(S)
	..()
	return 1
