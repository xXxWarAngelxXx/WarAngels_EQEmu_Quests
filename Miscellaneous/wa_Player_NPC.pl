####################################
#:: Usage:				Have this script name match the NPC name in the database. Make sure to set a unique faction for you "player_npc" or not 
#::						and see what happens!!  :-)
#:: Created:			10 May 2020
#:: Version(ddmmyy):	wa_160221_01
#:: Author:				WarAngel
#:: Description:		To have a NPC create the illusion of other real world players running around.
#:: With help from:		TurmoilToad,Salvanna,Akkadius,Trust,Kinglykrab
#:: Plugins:			plugin::RandomWeapons(1, 11169, 50, 200, 230);plugin::RandomFeatures($npc);plugin::wa_Decisions();
#::						plugin::wa_NameGenerator();plugin::wa_RandomGender();
#:: Future Plans:		I am going to look into making plugins for an array chat spams.
#:: Notes:				Be aware that the NPC's faction can dictate if it will attack its own people such as guards. 
####################################

sub EVENT_SPAWN
{
	my $wa_Diff = int(rand(10)); #Picks a number 0-9, 10 means 10 total int starting at 0
	$npc->SetEntityVariable("wa_minRange", 400); #Minimum range for the area the NPC will look to find a Mob to kill.
	$npc->SetEntityVariable("wa_maxRange", 1200); #Maximum range for the area the NPC will look to find a Mob to kill.
	quest::settimer("wa_FeatureChange", 1); #1 seconds
	quest::settimer("wa_Decide", 10 + ($wa_Diff)); #10 seconds + random (0-9) 10 means 10 total int starting at 0
}
#####################
#End of EVENT_SPAWN
#####################

sub EVENT_TIMER
{
	if($timer eq "wa_Decide" && !$npc->IsEngaged()) #"eq" is used for strings not int "!" means NOT
	{ ###What do I want to do?###
		#quest::debug("Decision start."); # The "d" in debug HAS to be LOWER CASE.
		plugin::wa_Decisions();
	}
	if($timer eq "wa_FeatureChange")
	{ ###Change my look here###
		#quest::debug("ChangeLook begin"); # The "d" in debug HAS to be LOWER CASE.
		quest::stoptimer("wa_FeatureChange"); #Lets not repeat
		plugin::wa_RandomGender();
		plugin::RandomWeapons(1, 139, 100, 200, 230); #Any random weapon available through Kunark, make a random armor?
		plugin::wa_NameGenerator();
		plugin::RandomFeatures($npc); #Change facial features.

		#quest::debug("ChangeLook ends"); # The "d" in debug HAS to be LOWER CASE.
	}
}

###################
#End of EVENTS_TIMER
###################
