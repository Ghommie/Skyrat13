/obj/item/clothing/mask/gas/sechailer/cpmask
	name = "Civil Protection gas mask"
	icon = 'modular_skyrat/icons/obj/clothing/masks.dmi'
	alternate_worn_icon = 'modular_skyrat/icons/mob/mask.dmi'
	icon_state = "cpmask"
	item_state = "cpmask"
	actions_types = list(/datum/action/item_action/halt)
	aggressiveness = 3

/obj/item/clothing/mask/gas/sechailer/cpmask/halt()
	set category = "Object"
	set name = "HALT"
	set src in usr
	if(!isliving(usr))
		return
	if(!can_use(usr))
		return
	if(broken_hailer)
		to_chat(usr, "<span class='warning'>\The [src]'s hailing system is broken.</span>")
		return

	var/phrase = 0	//selects which phrase to use
	var/phrase_text = null
	var/phrase_sound = null


	if(cooldown < world.time - 30) // A cooldown, to stop people being jerks
		recent_uses++
		if(cooldown_special < world.time - 180) //A better cooldown that burns jerks
			recent_uses = initial(recent_uses)

		switch(recent_uses)
			if(3)
				to_chat(usr, "<span class='warning'>\The [src] is starting to heat up.</span>")
			if(4)
				to_chat(usr, "<span class='userdanger'>\The [src] is heating up dangerously from overuse!</span>")
			if(5) //overload
				broken_hailer = 1
				to_chat(usr, "<span class='userdanger'>\The [src]'s power modulator overloads and breaks.</span>")
				return
		switch(aggressiveness)		// checks if the user has unlocked the restricted phrases
			if(3)
				phrase = rand(1,6)	// user has broke the restrictor, it will now only play shitcurity phrases
			else
				to_chat(usr, "<span class='userdanger'>\The [src] is broken.</span>")
		switch(phrase)	//sets the properties of the chosen phrase
			if(1)				// good cop
				phrase_text = "Watch it."
				phrase_sound = "watchit"
			if(2)
				phrase_text = "Pick up that can."
				phrase_sound = "pickupthecan1"
			if(3)
				phrase_text = "Investigate."
				phrase_sound = "investigate"
			if(4)
				phrase_text = "Hold it right there."
				phrase_sound = "holditrightthere"
			if(5)
				phrase_text = "Don't move."
				phrase_sound = "dontmove2"
			if(6)
				phrase_text = "11-99! Officer needs assistance!"
				phrase_sound = "officerneedsassistance"
		usr.audible_message("[usr]'s Compli-o-Nator: <font color='red' size='4'><b>[phrase_text]</b></font>")
		playsound(src.loc, "sound/voice/complionator/[phrase_sound].ogg", 100, 0, 4)
		playsound(src.loc, "sound/voice/complionator/off2.ogg", 100, 0, 4)
		cooldown = world.time
		cooldown_special = world.time

/obj/item/clothing/mask/gas/sechailer/cpmask/emag_act(mob/user)
	return

/obj/item/clothing/mask/gas/sechailer/cpmask/screwdriver_act(mob/living/user, obj/item/I)
	return

/obj/item/clothing/mask/gas/sechailer/cpmask/wirecutter_act(mob/living/user, obj/item/I)
	return

/obj/item/clothing/mask/gas/sechailer/cpmask/equipped(mob/user, slot)
	. = ..()
	if(!ishuman(user))
		return
	if(slot == SLOT_WEAR_MASK)
		var/mob/living/carbon/human/H = user
		var/obj/item/implant/flatline/F = new
		F.implant(H, H)

/obj/item/clothing/mask/gas/sechailer/cpmask/dropped(mob/user)
	. = ..()
	if(!ishuman(user))
		return
	else
		var/mob/living/carbon/human/H = user
		for(var/obj/item/implant/flatline/F in H.implants)
			F.removed(H)

/obj/item/implant/flatline
	name = "flatline implant"
	activated = 0

/obj/item/implant/flatline/get_data()
	var/dat = {"<b>Implant Specifications:</b><BR>
				<b>Name:</b> Combine Civil Protection flatline Implant<BR>
				<b>Life:</b> Activates upon death.<BR>
				"}
	return dat

/obj/item/implant/sad_trombone/trigger(emote, mob/source)
	if(emote == "deathgasp")
		playsound(source.loc, 'sound/voice/complionator/die1.ogg', 50, 0)

/obj/item/implanter/flatline
	name = "implanter (flatline)"
	imp_type = /obj/item/implant/flatline

/obj/item/implantcase/flatline
	name = "implant case - 'Flatline'"
	desc = "A glass case containing a flatline implant."
	imp_type = /obj/item/implant/flatline