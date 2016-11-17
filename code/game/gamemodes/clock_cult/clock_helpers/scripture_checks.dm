//returns a list of scriptures and if they're unlocked or not
/proc/scripture_unlock_check()
	var/servants = 0
	var/unconverted_ai_exists = FALSE
	for(var/mob/living/M in living_mob_list)
		if(is_servant_of_ratvar(M) && (ishuman(M) || issilicon(M)))
			servants++
		else if(isAI(M))
			unconverted_ai_exists = TRUE
	. = list(SCRIPTURE_DRIVER = TRUE, SCRIPTURE_SCRIPT = FALSE, SCRIPTURE_APPLICATION = FALSE, SCRIPTURE_REVENANT = FALSE, SCRIPTURE_JUDGEMENT = FALSE)
	//Drivers: always unlocked
	.[SCRIPTURE_SCRIPT] = (servants >= SCRIPT_SERVANT_REQ && clockwork_caches >= SCRIPT_CACHE_REQ)
	//Script: SCRIPT_SERVANT_REQ or more non-brain servants and SCRIPT_CACHE_REQ or more clockwork caches
	.[SCRIPTURE_APPLICATION] = (servants >= APPLICATION_SERVANT_REQ && clockwork_caches >= APPLICATION_CACHE_REQ && clockwork_construction_value >= APPLICATION_CV_REQ)
	//Application: APPLICATION_SERVANT_REQ or more non-brain servants, APPLICATION_CACHE_REQ or more clockwork caches, and at least APPLICATION_CV_REQ CV
	.[SCRIPTURE_REVENANT] = (servants >= REVENANT_SERVANT_REQ && clockwork_caches >= REVENANT_CACHE_REQ && clockwork_construction_value >= REVENANT_CV_REQ)
	//Revenant: REVENANT_SERVANT_REQ or more non-brain servants, REVENANT_CACHE_REQ or more clockwork caches, and at least REVENANT_CV_REQ CV
	.[SCRIPTURE_JUDGEMENT] = (servants >= JUDGEMENT_SERVANT_REQ && clockwork_caches >= JUDGEMENT_CACHE_REQ && clockwork_construction_value >= JUDGEMENT_CV_REQ && !unconverted_ai_exists)
	//Judgement: JUDGEMENT_SERVANT_REQ or more non-brain servants, JUDGEMENT_CACHE_REQ or more clockwork caches, at least JUDGEMENT_CV_REQ CV, and there are no living, non-servant ais

//reports to servants when scripture is locked or unlocked
/proc/scripture_unlock_alert(list/previous_states)
	. = scripture_unlock_check()
	for(var/i in .)
		if(.[i] != previous_states[i])
			hierophant_message("<span class='large_brass'><i>Hierophant Network:</i> <b>[i] Scripture has been [.[i] ? "un":""]locked.</b></span>")

//changes construction value
/proc/change_construction_value(amount)
	clockwork_construction_value += amount

//throws the no cache alert if there are no caches and clears it otherwise
/proc/cache_check(mob/M)
	if(!clockwork_caches)
		M.throw_alert("nocache", /obj/screen/alert/clockwork/nocache)
	else
		M.clear_alert("nocache")
