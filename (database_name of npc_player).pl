####################################
#:: Usage:			Have this script name match the NPC name in the database. Make sure to set a unique faction for you "player_npc" or not 
#::					and see what happens!!  :-)
#:: Created:		7April2020
#:: Version:		wa_200419_01
#:: Author:			WarAngel
#:: Description:	To have a NPC create the illusion of other real world players running around.
#:: With help from:	TurmoilToad,Salvanna,Akkadius,Trust,Kinglykrab
#:: Plugins:		plugin::RandomWeapons(1, 11169, 50, 200, 230);plugin::RandomFeatures($npc);plugin::wa_Decisions();
#::					plugin::wa_NameGenerator();
#::Future Plans:	I am going to look into making plugins for an array chat spams.
####################################

sub EVENT_SPAWN
{
	#$npc->TempName("Test_Name"); #Works but want a randomizer for names, maybe make a plugin array that makes names..."Leg" + "olas" type of idea
	my $wa_Diff = int(rand(10)); #Picks a number 0-9, 10 means 10 total int starting at 0

	quest::settimer("wa_FeatureChange", 1); #1 seconds
	quest::settimer("wa_RandomName", 1); #1 seconds
	quest::settimer("wa_Decisions", 10 + ($wa_Diff)); #10 seconds + random (0-9) 10 means 10 total int starting at 0
}
#####################
#End of EVENT_SPAWN
#####################

sub EVENT_TIMER
{
	if($timer eq "wa_Decisions" && !$npc->IsEngaged()) #"eq" is used for strings not int "!" means NOT
	{ ###What do I want to do?###
		plugin::wa_Decisions();
	}
	if($timer eq "wa_FeatureChange")
	{ ###Change my look here###
		#quest::debug("ChangeLook begin");
		quest::stoptimer("wa_FeatureChange"); #Lets not repeat
		plugin::RandomWeapons(1, 139, 100, 200, 230); #Any random weapon available through Kunark, make a random armor?
		plugin::RandomFeatures($npc); #Change facial features
	}
	if($timer eq "wa_RandomName")
	{ ###Change my name here###
		quest::stoptimer("wa_RandomName"); #Lets not repeat...EXCELSIOR!
		#plugin::wa_RandomName(); #Using the plugin::wa_NameGenerator(); now
		plugin::wa_NameGenerator();
	}
}

###################
#End of EVENTS_TIMER
###################
