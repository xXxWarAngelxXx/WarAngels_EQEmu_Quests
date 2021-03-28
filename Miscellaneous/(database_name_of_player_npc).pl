####################################
#:: Usage:					Have this script name match the NPC name in the database. Make sure to set a unique faction for you "player_npc" or not 
#::							and see what happens!!  :-) If you want to NOT USE a plugin, just comment it out. (Example : #plugin::wa_NameGenerator();).
#:: Created:				10 May 2020
#:: Version(wa_ddmmyy_##):	wa_270321_01
#:: Author:					WarAngel
#:: Description:			To have a NPC create the illusion of other real world players running around.
#:: With help from:			TurmoilToad,Salvanna,Akkadius,Trust,Kinglykrab
#:: Plugins:				plugin::RandomWeapons(1, 11169, 50, 200, 230);plugin::RandomFeatures($npc);plugin::wa_Decisions();
#::							plugin::wa_NameGenerator();plugin::wa_RandomGender();plugin::MobHealPercentage();plugin::SetAnim();
#:: Future Plans:			I am going to look into making plugins for an array chat spams.
#:: Notes:					Be aware that the NPC's faction can dictate if it will attack its own people such as guards. 
####################################

sub EVENT_SPAWN {
	my $npc = plugin::val('$npc'); #Not sure if this is needed here as I do not fully understand required locations for this call. So, put it here just in case.
	my $wa_Diff = int(rand(10)); #Picks a number 0-9, 10 means 10 total int starting at 0
	$npc->SetEntityVariable("wa_minRange", 10); #Minimum range for the area the NPC will look to find a Mob to kill.
	$npc->SetEntityVariable("wa_maxRange", 150); #Maximum range for the area the NPC will look to find a Mob to kill.
	quest::settimer("wa_FeatureChange", 1); #1 seconds
	quest::settimer("wa_Decide", 10 + ($wa_Diff)); #10 seconds + random (0-9) 10 means 10 total int starting at 0
	#quest::setnexthpevent(90); #Tried this to get the NPC to heal out of combat. Just was not working as needed. Created my own HP checks and heal.
}
#########################
#End of EVENT_SPAWN
#########################

sub EVENT_TIMER {
	if($timer eq "wa_FeatureChange") { ###Change my look here###
		quest::stoptimer("wa_FeatureChange"); #Lets not repeat
		quest::SetRunning(1); #players always run, so lets make these NPCs run.
		plugin::wa_RandomGender(); #Plugin made to randomized gender. (OPTIONAL)
		plugin::RandomWeapons(1, 139, 100, 200, 230); #Any random weapon available through Kunark, make a random armor? (OPTIONAL)
		plugin::wa_NameGenerator(); #Plugin made to randomize names you can create yourself in the plugin. (OPTIONAL)
		plugin::RandomFeatures($npc); #Change facial features. (OPTIONAL)
		#plugin::Debug("ChangeLook done for ----" . $npc->GetName()); # The "d" in debug HAS to be UPPER CASE.
	}
	if($timer eq "wa_Decide") { ###What do I want to do?###   #"eq" is used for strings not int "!" means NOT for numbers.
		plugin::wa_Decisions(50); #Chance to # <= KillMode or # > ChatMode. 50 is 50% kill and 50% chat/emote. 30 is 30% chance to kill. 70% chance to chat/emote.
		#plugin::Debug("Decision start for ----" . $npc_GetName()); # The "d" in debug HAS to be UPPER CASE.
	}
}

#########################
#End of EVENTS_TIMER
#########################

sub EVENT_CAST {
######################################################
#:: Help provided by : xJeris, DeadZergling, THALIX.
######################################################

	#my $wa_npcClass = $npc->GetClass(); #Not needed.
	#my $wa_npcPet = $npc->GetPetID(); #Not needed.
	#$wa_NPC_list= $entity_list->GetNPCList(); #Not needed.

	#$wa_NPCpet = $entity_list->GetMobByID($wa_npcPet); #Not needed.
	$wa_NPCpet = $entity_list->GetMobByID($npc->GetPetID()); #Works!! Get the pet via the NPC.

	#my $entity_list = plugin::val('$entity_list'); #Not needed.
	#my $npc = plugin::val('$npc'); #Not needed.

	#my $wa_PetName = $wa_npcPet->GetName(); #Kills the script
	#my $wa_PetName = $wa_npcPet->GetCleanName(); #Kills the script

	#if ($wa_Class = 5||6||8||10||11||12||13||14||15) # Works but wanted a more strict if
	if ($npc->GetPetID()) { #Someday I want to figure out how to make this fire, if only the pet spell is casted.
		$wa_NPCpet->TempName($npc->GetName() . "'s_pet"); #Works!!
		#plugin::Debug("Cast event PetID ----" . $wa_npcPet);		
		#plugin::Debug("Cast event for ----" . $npc->GetName());
		#plugin::Debug("Cast event for ----" . $wa_NPCpet);
	}
}

#########################
#End of EVENTS_CAST
#########################

#sub EVENT_COMBAT {
	#plugin::Debug("Combat state change for ----" . $npc->GetName());
#}

#########################
#End of EVENTS_COMBAT
#########################