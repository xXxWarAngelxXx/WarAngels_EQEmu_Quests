####################################
#:: Usage:				Have this script name match the NPC name in the database. Make sure to set a unique faction for you "player_npc" or not 
#::						and see what happens!!  :-)
#:: Created:			10 May 2020
#:: Version(ddmmyy):	wa_160221_01
#:: Author:				WarAngel
#:: Description:		To have a NPC create the illusion of other real world players running around.
#:: With help from:		TurmoilToad,Salvanna,Akkadius,Trust,Kinglykrab
#:: Plugins:			plugin::RandomWeapons(1, 11169, 50, 200, 230);plugin::RandomFeatures($npc);plugin::wa_Decisions();
#::						plugin::wa_NameGenerator();plugin::wa_RandomGender();plugin::MobHealPercentage();plugin::SetAnim();
#:: Future Plans:		I am going to look into making plugins for an array chat spams.
#:: Notes:				Be aware that the NPC's faction can dictate if it will attack its own people such as guards. 
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
	my $npc = plugin::val('$npc');

	if($timer eq "wa_FeatureChange") { ###Change my look here###
		quest::stoptimer("wa_FeatureChange"); #Lets not repeat
		quest::SetRunning(1); #players always run, so lets make these NPCs run.
		plugin::wa_RandomGender(); #Plugin made to randomized gender. (OPTIONAL)
		plugin::RandomWeapons(1, 139, 100, 200, 230); #Any random weapon available through Kunark, make a random armor? (OPTIONAL)
		plugin::wa_NameGenerator(); #Plugin made to randomize names you can create yourself in the plugin. (OPTIONAL)
		plugin::RandomFeatures($npc); #Change facial features. (OPTIONAL)
		#plugin::Debug("ChangeLook done for ----" . $npc->GetName()); # The "d" in debug HAS to be UPPER CASE.
	}
	if($timer eq "wa_Decide") { ###What do I want to do?####"eq" is used for strings not int "!" means NOT for numbers.
		plugin::wa_Decisions(50); #Chance to # <= KillMode or # > ChatMode. 50 is 50% kill and 50% chat. 30 is 30% chance to kill. 70% chance to chat.
		#plugin::Debug("Decision start for ----" . $npc_GetName()); # The "d" in debug HAS to be UPPER CASE.
	}
}

#########################
#End of EVENTS_TIMER
#########################

#sub EVENT_HP {

#}

#########################
#End of EVENTS_HP
#########################

sub EVENT_COMBAT {
	plugin::Debug("Combat state change for ----" . $npc->GetName());
}

#########################
#End of EVENTS_COMBAT
#########################