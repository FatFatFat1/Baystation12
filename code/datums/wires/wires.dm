// Wire datums. Created by Giacomand.
// Was created to replace a horrible case of copy and pasted code with no care for maintability.
// Goodbye Door wires, Cyborg wires, Vending Machine wires, Autolathe wires
// Protolathe wires, APC wires and Camera wires!

#define MAX_FLAG 65535

var/list/same_wires = list()
// 14 colours, if you're adding more than 14 wires then add more colours here
var/list/wireColours = list("red", "blue", "green", "darkred", "orange", "brown", "gold", "gray", "cyan", "navy", "purple", "pink", "black", "yellow")

var/global/all_solved_wires = list() //Solved wire associative list, eg; all_solved_wires[/obj/machinery/door/airlock] used form NTStation13

/datum/wires

	var/random = 0 // Will the wires be different for every single instance.
	var/atom/holder = null // The holder
	var/holder_type = null // The holder type; used to make sure that the holder is the correct type.
	var/wire_count = 0 // Max is 16
	var/wires_status = 0 // BITFLAG OF WIRES

	var/list/wires = list()
	var/list/signallers = list()

	var/table_options = " align='center'"
	var/row_options1 = " width='80px'"
	var/row_options2 = " width='320px'"
	var/window_x = 470
	var/window_y = 470

	var/list/descriptions // Descriptions of wires (datum/wire_description) for use with examining.

/datum/wires/New(var/atom/holder)
	..()
	src.holder = holder
	if(!istype(holder, holder_type))
		CRASH("Our holder is null/the wrong type!")
		return

	// Generate new wires
	if(random)
		GenerateWires()
		for(var/datum/wire_description/desc in descriptions)
			if(prob(50))
				desc.skill_level++
	// Get the same wires
	else
		// We don't have any wires to copy yet, generate some and then copy it.
		if(!same_wires[holder_type])
			GenerateWires()
			same_wires[holder_type] = src.wires.Copy()
		else
			var/list/wires = same_wires[holder_type]
			src.wires = wires // Reference the wires list.

/datum/wires/Destroy()
	holder = null
	return ..()

/datum/wires/proc/GenerateWires()
	var/list/colours_to_pick = wireColours.Copy() // Get a copy, not a reference.
	var/list/indexes_to_pick = list()
	//Generate our indexes
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		indexes_to_pick += i
	colours_to_pick.len = wire_count // Downsize it to our specifications.

	while(colours_to_pick.len && indexes_to_pick.len)
		// Pick and remove a colour
		var/colour = pick_n_take(colours_to_pick)

		// Pick and remove an index
		var/index = pick_n_take(indexes_to_pick)

		src.wires[colour] = index
		//wires = shuffle(wires)
	all_solved_wires[holder_type] = SolveWires()
/datum/wires/proc/Interact(var/mob/living/user)

	var/html = null
	if(holder && CanUse(user))
		html = GetInteractWindow(user)
	if(html)
		user.set_machine(holder)
	else
		user.unset_machine()
		// No content means no window.
		user << browse(null, "window=wires")
		return

	var/datum/browser/popup = new(user, "wires", holder.name, window_x, window_y)
	popup.set_content(html)
	popup.set_title_image(user.browse_rsc_icon(holder.icon, holder.icon_state))
	popup.open()

/datum/wires/proc/GetInteractWindow(mob/user)
	var/html = list()
	html += "<div class='block'>"
	html += "<h3>Exposed Wires</h3>"
	html += "<table[table_options]>"

	var/list/wires_used = list()
	for(var/colour in wires)
		wires_used += prob(user.skill_fail_chance(SKILL_ELECTRICAL, 20, SKILL_ADEPT)) ? pick(wires) : colour
	if(!user.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
		wires_used = shuffle(wires_used)

	for(var/colour in wires_used)
		html += "<tr>"
		html += "<td[row_options1]><font color='[colour]'>&#9724;</font>[capitalize(colour)]</td>"
		html += "<td[row_options2]>"
		html += "<A href='?src=\ref[src];action=1;cut=[colour]'>[IsColourCut(colour) ? "Mend" :  "Cut"]</A>"
		html += " <A href='?src=\ref[src];action=1;pulse=[colour]'>Pulse/Check</A>"
		html += " <A href='?src=\ref[src];action=1;attach=[colour]'>[IsAttached(colour) ? "Detach" : "Attach"] Signaller</A>"
		html += " <A href='?src=\ref[src];action=1;examine=[colour]'>Examine</A></td></tr>"
	html += "</table>"
	html += "<br /><A href='?src=\ref[src];action=1;check=1'>Check Wiring</A>"
	html += "</div>"

	if (random)
		html += "<i>\The [holder] appears to have tamper-resistant electronics installed.</i><br><br>" //maybe this could be more generic?

	return JOINTEXT(html)

/datum/wires/Topic(href, href_list)
	..()
	var/list/unsolved_wires = src.wires.Copy()
	var/colour_function
	var/solved_colour_function

	if(in_range(holder, usr) && isliving(usr))

		var/mob/living/L = usr
		if(CanUse(L) && href_list["action"])
			var/obj/item/I = L.get_active_hand()
			holder.add_hiddenprint(L)
			if(href_list["cut"]) // Toggles the cut/mend status
				if(isWirecutter(I))
					var/colour = href_list["cut"]
					CutWireColour(colour)
					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 20, SKILL_ADEPT)))
						RandomCut()
						to_chat(L, "<span class='danger'>You accidentally nick another wire!</span>")
					else if(!L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
						RandomCutAll(10)
						to_chat(L, "<span class='danger'>You think you might have nicked some of the other wires!</span>")
				else
					to_chat(L, "<span class='error'>You need wirecutters!</span>")
			else if(href_list["pulse"])
				var/colour = href_list["pulse"]
				if(isMultitool(I))
					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 30, SKILL_ADEPT)))
						RandomPulse()
						to_chat(L, "<span class='danger'>You accidentally pulse another wire!</span>")
						if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 60, SKILL_BASIC)))
							RandomPulse() //or two
					else
						PulseColour(colour)
					if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 50, SKILL_BASIC)))
						wires = shuffle(wires) //Leaves them in a different order for anyone else.
						to_chat(L, "<span class='danger'>You get the wires all tangled up!</span>")
				else if(isMultimeter(I))
					var/obj/item/device/multitool/multimeter/O = L.get_active_hand()
					if(O.mode == METER_MESURING)
						if (L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
							to_chat(L, "<span class='notice'>������ ����������...</span>")
							if(!do_after(L, 50, holder))
								return
							PulseColour(colour)
							to_chat(L, "<span class='notice'>������ ������������.</span>")
						else
							to_chat(L, "<span class='notice'>�� �� ������ � ����� ����������� �������� ���� ������.</span>")
					else
						if (L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
							if(!do_after(L, 10, holder))
								return
							if(!IsColourCut(colour))
								colour_function = unsolved_wires[colour]
								solved_colour_function = SolveWireFunction(colour_function)
								if(solved_colour_function != "")
									to_chat(L, "the [colour] wire connected to [solved_colour_function]")
									playsound(O.loc, 'infinity/sound/machines/mbeep.ogg', 20, 1)
								else
									to_chat(L, "the [colour] wire not connected")
							else
								to_chat(L, "the [colour] wire not connected")
						else
							to_chat(L, "<span class='notice'>�� �� ������ ���������� ����������.</span>")
				else
					to_chat(L, "<span class='error'>You need a multitool or a multimeter!</span>")

			else if(href_list["attach"])
				var/colour = href_list["attach"]
				if(prob(L.skill_fail_chance(SKILL_ELECTRICAL, 80, SKILL_EXPERT)))
					colour = pick(wires)
					to_chat(L, "<span class='danger'>Are you sure you got the right wire?</span>")
				// Detach
				if(IsAttached(colour))
					var/obj/item/O = Detach(colour)
					if(O)
						L.put_in_hands(O)

				// Attach
				else
					if(istype(I, /obj/item/device/assembly/signaler))
						if(L.unEquip(I))
							Attach(colour, I)
					else
						to_chat(L, "<span class='error'>You need a remote signaller!</span>")
			//multimeter stuff
			else if(href_list["check"])
				if(isMultimeter(I))
//					var/colour = href_list["check"]
					var/obj/item/device/multitool/multimeter/O = L.get_active_hand()
					if (L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
						if(O.mode == METER_CHECKING)
							to_chat(L, "<span class='notice'>���������� �������...</span>")
							var/name_by_type = name_by_type()
							to_chat(L, "[name_by_type] wires:")
							for(var/colour in src.wires)
								if(unsolved_wires[colour])
									if(!do_after(L, 10, holder))
										return
									if(!IsColourCut(colour))
										colour_function = unsolved_wires[colour]
										solved_colour_function = SolveWireFunction(colour_function)
										if(solved_colour_function != "")
											to_chat(L, "the [colour] wire connected to [solved_colour_function]")
											playsound(O.loc, 'infinity/sound/machines/mbeep.ogg', 20, 1)
										else
											to_chat(L, "the [colour] wire not connected")
									else
										to_chat(L, "the [colour] wire not connected")
							//to_chat(L, "<span class='notice'>[all_solved_wires[holder_type]]</span>")
						else
							to_chat(L, "<span class='notice'>����������� ���������� � ����� ���������.</span>")
					else
						to_chat(L, "<span class='notice'>�� �� ������ ��� � ���� ��������.</span>")
				else
					to_chat(L, "<span class='warning'>��� ����� ����������.</span>")

			else if(href_list["examine"])
				var/colour = href_list["examine"]
				to_chat(usr, examine(GetIndex(colour), usr))

		// Update Window
			Interact(usr)

	if(href_list["close"])
		usr << browse(null, "window=wires")
		usr.unset_machine(holder)

//
// Overridable Procs
//

// Called when wires cut/mended.
/datum/wires/proc/UpdateCut(var/index, var/mended)
	return

// Called when wire pulsed. Add code here.
/datum/wires/proc/UpdatePulsed(var/index)
	return

/datum/wires/proc/examine(index, mob/user)
	. = "You aren't sure what this wire does."

	var/datum/wire_description/wd = get_description(index)
	if(!wd)
		return
	if(wd.skill_level && !user.skill_check(SKILL_ELECTRICAL, wd.skill_level))
		return
	return wd.description

/datum/wires/proc/CanUse(var/mob/living/L)
	return 1

// Example of use:
/*

var/const/BOLTED= 1
var/const/SHOCKED = 2
var/const/SAFETY = 4
var/const/POWER = 8

/datum/wires/door/UpdateCut(var/index, var/mended)
	var/obj/machinery/door/airlock/A = holder
	switch(index)
		if(BOLTED)
		if(!mended)
			A.bolt()
	if(SHOCKED)
		A.shock()
	if(SAFETY )
		A.safety()

*/


//
// Helper Procs
//

/datum/wires/proc/get_description(index)
	for(var/datum/wire_description/desc in descriptions)
		if(desc.index == index)
			return desc

/datum/wires/proc/PulseColour(var/colour)
	PulseIndex(GetIndex(colour))

/datum/wires/proc/PulseIndex(var/index)
	if(IsIndexCut(index))
		return
	playsound(holder.loc, 'infinity/sound/items/multitool_pulse.ogg', 20, 1)
	UpdatePulsed(index)

/datum/wires/proc/GetIndex(var/colour)
	if(wires[colour])
		var/index = wires[colour]
		return index
	else
		CRASH("[colour] is not a key in wires.")


/datum/wires/proc/RandomPulse()
	var/index = rand(1, wires.len)
	PulseColour(wires[index])

//
// Is Index/Colour Cut procs
//

/datum/wires/proc/IsColourCut(var/colour)
	var/index = GetIndex(colour)
	return IsIndexCut(index)

/datum/wires/proc/IsIndexCut(var/index)
	return (index & wires_status)

//
// Signaller Procs
//

/datum/wires/proc/IsAttached(var/colour)
	if(signallers[colour])
		return 1
	return 0

/datum/wires/proc/GetAttached(var/colour)
	if(signallers[colour])
		return signallers[colour]
	return null

/datum/wires/proc/Attach(var/colour, var/obj/item/device/assembly/signaler/S)
	if(colour && S)
		if(!IsAttached(colour))
			signallers[colour] = S
			S.forceMove(holder)
			S.connected = src
			return S

/datum/wires/proc/Detach(var/colour)
	if(colour)
		var/obj/item/device/assembly/signaler/S = GetAttached(colour)
		if(S)
			signallers -= colour
			S.connected = null
			S.dropInto(holder.loc)
			return S


/datum/wires/proc/Pulse(var/obj/item/device/assembly/signaler/S)

	for(var/colour in signallers)
		if(S == signallers[colour])
			PulseColour(colour)
			break

//
// Cut Wire Colour/Index procs
//

/datum/wires/proc/CutWireColour(var/colour)
	var/index = GetIndex(colour)
	CutWireIndex(index)

/datum/wires/proc/CutWireIndex(var/index)
	if(IsIndexCut(index))
		wires_status &= ~index
		UpdateCut(index, 1)
	else
		wires_status |= index
		UpdateCut(index, 0)
	playsound(holder.loc, 'sound/items/Wirecutter.ogg', 100, 1)

/datum/wires/proc/RandomCut()
	var/r = rand(1, wires.len)
	CutWireColour(wires[r])

/datum/wires/proc/RandomCutAll(var/probability = 10)
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		if(prob(probability))
			CutWireIndex(i)

/datum/wires/proc/CutAll()
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		CutWireIndex(i)

/datum/wires/proc/IsAllCut()
	if(wires_status == (1 << wire_count) - 1)
		return 1
	return 0

/datum/wires/proc/MendAll()
	for(var/i = 1; i < MAX_FLAG && i < (1 << wire_count); i += i)
		if(IsIndexCut(i))
			CutWireIndex(i)

//
//Shuffle and Mend
//

/datum/wires/proc/Shuffle()
	wires_status = 0
	GenerateWires()

// Wire solve functions

/datum/wires/proc/name_by_type()
	var/name_by_type
	if(istype(src, /datum/wires/airlock))
		name_by_type = "Airlock"
	if(istype(src, /datum/wires/apc))
		name_by_type = "APC"
	if(istype(src, /datum/wires/robot))
		name_by_type = "Cyborg"
	if(istype(src, /datum/wires/autolathe))
		name_by_type = "Autolathe"
	if(istype(src, /datum/wires/alarm))
		name_by_type = "Air Alarm"
	if(istype(src, /datum/wires/camera))
		name_by_type = "Camera"
	if(istype(src, /datum/wires/explosive))
		name_by_type = "C4 Bomb"
	if(istype(src, /datum/wires/nuclearbomb))
		name_by_type = "Nuclear Bomb"
	if(istype(src, /datum/wires/particle_acc))
		name_by_type = "Particle Accelerator"
	if(istype(src, /datum/wires/radio))
		name_by_type = "Radio"
	if(istype(src, /datum/wires/vending))
		name_by_type = "Vending Machine"
	return name_by_type

/datum/wires/proc/SolveWireFunction(var/WireFunction)
	return WireFunction //Default returns the original number, so it still "works"

/datum/wires/proc/SolveWires()
	var/list/unsolved_wires = src.wires.Copy()
	var/colour_function
	var/solved_colour_function

	var/name_by_type = name_by_type()

	var/solved_txt = "[name_by_type] wires:<br>"

	for(var/colour in src.wires)
		if(unsolved_wires[colour]) //unsolved_wires[red]
			colour_function = unsolved_wires[colour] //unsolved_wires[red] = 1 so colour_index = 1
			solved_colour_function = SolveWireFunction(colour_function) //unsolved_wires[red] = 1, 1 = AIRLOCK_WIRE_IDSCAN
			solved_txt += "the [colour] wire connected to [solved_colour_function]<br>" //the red wire is the ID wire

	solved_txt += "<br>"

	return solved_txt
