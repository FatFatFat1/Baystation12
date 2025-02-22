
/obj/machinery/computer/account_database
	name = "accounts uplink terminal"
	desc = "Access transaction logs, account data and all kinds of other financial records."
	req_access = list(list(access_hop, access_captain))
	var/receipt_num
	var/machine_id = ""
	var/obj/item/weapon/card/id/held_card
	var/datum/money_account/detailed_account_view
	var/creating_new_account = 0
	var/const/fund_cap = 1000000

	circuit = /obj/item/weapon/circuitboard/account_database

	proc/get_access_level()
		if (!held_card)
			return 0
		if(access_cent_captain in held_card.access)
			return 2
		else if(access_hop in held_card.access || access_captain in held_card.access)
			return 1

	proc/accounting_letterhead(report_name)
		return {"
			<center><h1><b>[report_name]</b></h1></center>
			<center><small><i>[station_name()] Accounting Report</i></small></center>
			<hr>
			<u>Generated By:</u> [held_card.registered_name], [held_card.assignment]<br>
		"}

/obj/machinery/computer/account_database/New()
	machine_id = "[station_name()] Acc. DB #[num_financial_terminals++]"
	..()

/obj/machinery/computer/account_database/attackby(obj/O, mob/user)
	if(!istype(O, /obj/item/weapon/card/id))
		return ..()

	if(!held_card)
		if(!user.unEquip(O, src))
			return
		held_card = O

		SSnano.update_uis(src)

	attack_hand(user)

/obj/machinery/computer/account_database/attack_hand(mob/user as mob)
	if(stat & (NOPOWER|BROKEN)) return
	ui_interact(user)

/obj/machinery/computer/account_database/ui_interact(mob/user, ui_key="main", var/datum/nanoui/ui = null, var/force_open = 1)
	user.set_machine(src)

	var/data[0]
	data["src"] = "\ref[src]"
	data["id_inserted"] = !!held_card
	data["id_card"] = held_card ? text("[held_card.registered_name], [held_card.assignment]") : "-----"
	data["access_level"] = check_access(held_card)
	data["machine_id"] = machine_id
	data["creating_new_account"] = creating_new_account
	data["detailed_account_view"] = !!detailed_account_view
	data["station_account_number"] = station_account.account_number
	data["transactions"] = null
	data["accounts"] = null

	if (detailed_account_view)
		data["account_number"] = detailed_account_view.account_number
		data["owner_name"] = detailed_account_view.owner_name
		data["money"] = detailed_account_view.money
		data["suspended"] = detailed_account_view.suspended

		var/list/trx[0]
		for (var/datum/transaction/T in detailed_account_view.transaction_log)
			trx.Add(list(list(\
				"date" = T.date, \
				"time" = T.time, \
				"target_name" = T.get_target_name(), \
				"purpose" = T.purpose, \
				"amount" = T.amount, \
				"source_terminal" = T.get_source_name())))

		if (trx.len > 0)
			data["transactions"] = trx

	var/list/accounts[0]
	for(var/i=1, i<=all_money_accounts.len, i++)
		var/datum/money_account/D = all_money_accounts[i]
		accounts.Add(list(list(\
			"account_number"=D.account_number,\
			"owner_name"=D.owner_name,\
			"suspended"=D.suspended ? "SUSPENDED" : "",\
			"account_index"=i)))

	if (accounts.len > 0)
		data["accounts"] = accounts

	ui = SSnano.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "accounts_terminal.tmpl", src.name, 400, 640)
		ui.set_initial_data(data)
		ui.open()

/obj/machinery/computer/account_database/Topic(href, href_list)
	if(..())
		return 1

	var/datum/nanoui/ui = SSnano.get_open_ui(usr, src, "main")

	if(href_list["choice"])
		switch(href_list["choice"])
			if("create_account")
				creating_new_account = 1

			if("toggle_suspension")
				if(detailed_account_view)
					detailed_account_view.suspended = !detailed_account_view.suspended
					callHook("change_account_status", list(detailed_account_view))

			if("finalise_create_account")
				var/account_name = href_list["holder_name"]
				var/starting_funds = max(text2num(href_list["starting_funds"]), 0)

				starting_funds = Clamp(starting_funds, 0, station_account.money)	// Not authorized to put the station in debt.
				starting_funds = min(starting_funds, fund_cap)						// Not authorized to give more than the fund cap.

				var/datum/money_account/new_account = create_account("[account_name]'s Personal Account", account_name, starting_funds, ACCOUNT_TYPE_PERSONAL, src)
				if(starting_funds > 0)
					//subtract the money
					station_account.money -= starting_funds

					//create a transaction log entry
					new_account.deposit(starting_funds, "New account activation", machine_id)

					creating_new_account = 0
					ui.close()

				creating_new_account = 0
			if("insert_card")
				if(held_card)
					held_card.dropInto(loc)

					if(ishuman(usr) && !usr.get_active_hand())
						usr.put_in_hands(held_card)
					held_card = null

				else
					var/obj/item/I = usr.get_active_hand()
					if (istype(I, /obj/item/weapon/card/id))
						if(!usr.unEquip(I, src))
							return
						held_card = I

			if("view_account_detail")
				var/index = text2num(href_list["account_index"])
				if(index && index <= all_money_accounts.len)
					detailed_account_view = all_money_accounts[index]

			if("view_accounts_list")
				detailed_account_view = null
				creating_new_account = 0

			if("revoke_payroll")
				var/funds = detailed_account_view.money
				detailed_account_view.transfer(station_account, funds, "Revocation of payroll")

				callHook("revoke_payroll", list(detailed_account_view))

			if("print")
				var/text
				var/obj/item/weapon/paper/P = new(loc)
				if (detailed_account_view)
					P.SetName("account #[detailed_account_view.account_number] details")
					var/title = "Account #[detailed_account_view.account_number] Details"
					text = {"
						[accounting_letterhead(title)]
						<u>Holder:</u> [detailed_account_view.owner_name]<br>
						<u>Balance:</u> T[detailed_account_view.money]<br>
						<u>Status:</u> [detailed_account_view.suspended ? "Suspended" : "Active"]<br>
						<u>Transactions:</u> ([detailed_account_view.transaction_log.len])<br>
						<table>
							<thead>
								<tr>
									<td>Timestamp</td>
									<td>Target</td>
									<td>Reason</td>
									<td>Value</td>
									<td>Terminal</td>
								</tr>
							</thead>
							<tbody>
						"}

					for (var/datum/transaction/T in detailed_account_view.transaction_log)
						text += {"
									<tr>
										<td>[T.date] [T.time]</td>
										<td>[T.get_target_name()]</td>
										<td>[T.purpose]</td>
										<td>[T.amount]</td>
										<td>[T.get_source_name()]</td>
									</tr>
							"}

					text += {"
							</tbody>
						</table>
						"}

				else
					P.SetName("financial account list")
					text = {"
						[accounting_letterhead("Financial Account List")]
						<table>
							<thead>
								<tr>
									<td>Account Number</td>
									<td>Holder</td>
									<td>Balance</td>
									<td>Status</td>
								</tr>
							</thead>
							<tbody>
					"}

					for(var/i=1, i<=all_money_accounts.len, i++)
						var/datum/money_account/D = all_money_accounts[i]
						text += {"
								<tr>
									<td>#[D.account_number]</td>
									<td>[D.owner_name]</td>
									<td>T[D.money]</td>
									<td>[D.suspended ? "Suspended" : "Active"]</td>
								</tr>
						"}

					text += {"
							</tbody>
						</table>
					"}

				P.info = text
				state("The terminal prints out a report.")

	return 1