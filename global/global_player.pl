# items: 67704
sub EVENT_ENTERZONE { #message only appears in Cities / Pok and wherever the Wayfarer Camps (LDON) is in.  This message won't appear in the player's home city.
  if($ulevel >= 15 && !defined($qglobals{Wayfarer})) {
    if($client->GetStartZone()!=$zoneid && ($zoneid == 1 || $zoneid == 2 || $zoneid == 3 || $zoneid == 8 || $zoneid == 9 || $zoneid == 10 || $zoneid == 19 || $zoneid == 22 || $zoneid == 23 || $zoneid == 24 || $zoneid == 29 || $zoneid == 30 || $zoneid == 34 || $zoneid == 35 || $zoneid == 40 || $zoneid == 41 || $zoneid == 42 || $zoneid == 45 || $zoneid == 49 || $zoneid == 52 || $zoneid == 54 || $zoneid == 55 || $zoneid == 60 || $zoneid == 61 || $zoneid == 62 || $zoneid == 67 || $zoneid == 68 || $zoneid == 75 || $zoneid == 82 || $zoneid == 106 || $zoneid == 155 || $zoneid == 202 || $zoneid == 382 || $zoneid == 383 || $zoneid == 392 || $zoneid == 393 || $zoneid == 408)) {
	  $client->Message(15,"A mysterious voice whispers to you, 'If you can feel me in your thoughts, know this -- something is changing in the world and I reckon you should be a part of it. I do not know much, but I do know that in every home city and the wilds there are agents of an organization called the Wayfarers Brotherhood. They are looking for recruits . . . If you can hear this message, you are one of the chosen. Rush to your home city, or search the West Karanas and Rathe Mountains for a contact if you have been exiled from your home for your deeds, and find out more. Adventure awaits you, my friend.'");
	}
  }
}

sub EVENT_COMBINE_VALIDATE {
	# $validate_type values = { "check_zone", "check_tradeskill" }
	# criteria exports:
	#	"check_zone"		=> zone_id
	#	"check_tradeskill"	=> tradeskill_id (not active)
	if ($recipe_id == 10344) {
		if ($validate_type =~/check_zone/i) {
			if ($zone_id != 289 && $zone_id != 290) {
				return 1;
			}
		}
	}
	
	return 0;
}

sub EVENT_COMBINE_SUCCESS {
    if ($recipe_id =~ /^1090[4-7]$/) {
        $client->Message(1,
            "The gem resonates with power as the shards placed within glow unlocking some of the stone's power. ".
            "You were successful in assembling most of the stone but there are four slots left to fill, ".
            "where could those four pieces be?"
        );
    }
    elsif ($recipe_id =~ /^10(903|346|334)$/) {
        my %reward = (
            melee  => {
                10903 => 67665,
                10346 => 67660,
                10334 => 67653
            },
            hybrid => {
                10903 => 67666,
                10346 => 67661,
                10334 => 67654
            },
            priest => {
                10903 => 67667,
                10346 => 67662,
                10334 => 67655
            },
            caster => {
                10903 => 67668,
                10346 => 67663,
                10334 => 67656
            }
        );
        my $type = plugin::ClassType($class);
        quest::summonitem($reward{$type}{$recipe_id});
        quest::summonitem(67704); # Item: Vaifan's Clockwork Gemcutter Tools
        $client->Message(1,"Success");
    }
}

sub EVENT_CONNECT {
    # the main key is the ID of the AA
    # the first set is the age required in seconds
    # the second is if to ignore the age and grant anyways live test server style
    # the third is enabled
    my %vet_aa = (
        481 => [31536000, 1, 1], ## Lesson of the Devote 1 yr
        482 => [63072000, 1, 1], ## Infusion of the Faithful 2 yr
        483 => [94608000, 1, 1], ## Chaotic Jester 3 yr
        484 => [126144000, 1, 1], ## Expedient Recovery 4 yr
        485 => [157680000, 1, 1], ## Steadfast Servant 5 yr
        486 => [189216000, 1, 1], ## Staunch Recovery 6 yr
        487 => [220752000, 1, 1], ## Intensity of the Resolute 7 yr
        511 => [252288000, 1, 1], ## Throne of Heroes 8 yr
        2000 => [283824000, 1, 1], ## Armor of Experience 9 yr
        8081 => [315360000, 1, 1], ## Summon Resupply Agent 10 yr
        8130 => [346896000, 1, 1], ## Summon Clockwork Banker 11 yr
        453 => [378432000, 1, 1], ## Summon Permutation Peddler 12 yr
        182 => [409968000, 1, 1], ## Summon Personal Tribute Master 13 yr
        600 => [441504000, 1, 1] ## Blessing of the Devoted 14 yr
    );
    my $age = $client->GetAccountAge();
    for (my ($aa, $v) = each %vet_aa) {
        if ($v[2] && ($v[1] || $age >= $v[0])) {
            $client->GrantAlternateAdvancementAbility($aa, 1);
        }
    }

    ###############################################################
    ## Author : WarAngel
    ## Date Created : 28Mar2021
    ###############################################################
    my $wa_XPKeyDel = "wa_CharXPforID_" . $client->CharacterID();
    my $wa_KeyXPCheck = quest::get_data($wa_XPKeyDel);
    if ($wa_KeyXPCheck) {
        quest::delete_data($wa_XPKeyDel); #Delete the data_bucket entry, not needed anymore.
        #quest::emote("... logged out before performing the &XPOn command. So we reset for you to again earn xp!");
        $client->Message(5, "You logged out before performing the &XPOn command. So we reset for you to again earn xp!");
    }

    ###############################################################
    ## This is a Perl version of the LUA script. Not mine to claim.
    ###############################################################
    my $wa_CheckLevel = "wa_Level_1_check_ID_" . $client->CharacterID();
    my $wa_KeyChaCheck = quest::get_data($wa_CheckLevel);
    if ($client->GetLevel() <= 1 && !$wa_KeyChaCheck) {
        my @wa_FreeSkills = (0..5,7,9,13..15,18,19,22,24,28,30..33,36,41,51,53,55,58..61,63..69,72..77);
        my $wa_NewCha = "wa_Level_1_check_ID_" . $client->CharacterID();

        quest::set_data($wa_NewCha, $wa_NewCha, 172800);

        foreach $wa_SkillCheck (@wa_FreeSkills) {
                if ($client->GetRawSkill($wa_SkillCheck) <= 11 && $client->MaxSkill($wa_SkillCheck) >= 1 && $client->CanHaveSkill($wa_SkillCheck)) {
                    $client->SetSkill($wa_SkillCheck, 0);
                    #plugin::Debug("Client connect Event --- Skills set to 0.");
                }
        }
    }
}

###########################################################
#:: End EVENT_CONNECT
###########################################################

sub EVENT_POPUPRESPONSE {
    #::: plugin::DiaWind response subroutine
    plugin::DiaWind_Process_Response();
}

###########################################################
#:: End EVENT_POPUPRESPONSE
###########################################################

sub EVENT_SAY {

    if ($text=~/&help/) {
        my @wa_CommList = (
            "&XPOff - To suspend you from earning experience.",
            "&XPOn - Turn back on experience gain.");
        foreach $wa_help (@wa_CommList) {
                $client->Message(15, $wa_help);
                #plugin::Debug("Worked");
        }        
        $client->Popup2("&Commands", "<br><c \"#F07F00\">&XPOff</c> - To suspend you from earning experience<br><c \"#F07F00\">&XPOn</c> - turn back on experience gain.");
        
        #plugin::DiaWind("noquotes{in}{in}{y}&Commands~<br><br>&XPOff - To suspend you from earning experience<br>&XPOn - turn back on experience gain.<br>");
    }


    #my $wa_CharXP = $client->GetEXP(); #Current characters XP.
    #my $wa_CharIDKey = $client->CharacterID(); #Current characters ID.
    my $wa_XPKey = "wa_CharXPforID_" . $client->CharacterID();
    my $wa_KeyCheck = quest::get_data($wa_XPKey); #If a key is already made...get it.
    #my $wa_TimerKeyCheck = quest::get_data(wa_TimerKey); #Not needed here.
    if ($text=~/&XPOff/  && !$wa_KeyCheck) { #Did the player type in the command? Have they already started this?
        my $wa_CharXP = $client->GetEXP(); #Current characters XP.
        quest::settimer(wa_XPOff_Timer, 8); #Set a timer. Be carefull to not use the $_ (Scaler) in a timer name. It is like creating a $_$_data. Bad mojo.
                                               #Right now any player can 'reset' the timer. But this is not an issue unless hundreds of players all in a few minutes declare a XPOff.
                                               #In that case it is an easy fix to make the timer 'name' as the players name. But that can make alot of timers firing off all the time.
                                               #Choose your poison...
        quest::set_data($wa_XPKey, $wa_CharXP, 86400); #Create a data_bucket entry with the characters xp for a value. Auto expire in 1 day.
        $client->Message(5, "Your current XP will be stopped at ---- " . $wa_CharXP); #Debug if it works thus far.
        plugin::DiaWind("noquotes{in}{in}{g}Experience~ is now turned off!<br><br>{in}{r}BEWARE!!~ If you are close to DINGing, you could experience leveling, de-leveling issues! And if you log off or LD while your xp is turned off. You NEED to {y}&XPOn~ to reset you Characters controller.<br><br>{in}{y}Also you will be reset to accumulating xp if...~<br>1. Stay logged on for more than 24 hours.<br>2. Log off and back on again.<br><br>{in}{in}...Type {y}&XPOn~ to resume gaining XP."); #Window popup with warnings.

        #if ($wa_TimerKeyCheck) { #measure of protection
        #    quest::set_data(wa_TimerKey, quest::get_data(wa_TimerKey)+1, 86400); #add more to the int and reset the timer.
        #    plugin::Debug("Added a int to wa_TimerKey worked."); #Debug if it works thus far.
        #last;
        #}
        #if (!$wa_TimerKeyCheck) { #Is there even a key made yet?
        #    quest::set_data(wa_TimerKey, 1, 86400); # Create a data_bucket and a timer for it to do checks on the EVENT_TIMER. Prevent someone from turning off the timer while others are using it.
        #    plugin::Debug("Created wa_TimerKey worked."); #Debug if it works thus far.
        #last;
        #}
    }
    if ($text=~/&XPOn/ && $wa_KeyCheck) { #Did the player type in the command? Only those who started can stop.
        my $wa_CharXP = $client->GetEXP(); #Current characters XP.
        quest::delete_data($wa_XPKey); #Delete the data_bucket entry, not needed anymore.
        $client->Message(5, "Your XP is ---- " . $wa_CharXP . ". You are again earning XP!"); #Debug if it works thus far.
        quest::stoptimer(wa_XPOff_Timer); #Stop a timer.
        plugin::DiaWind("noquotes{in}{in}{g}Experience~ is now turned on!<br><br>You are again gaining experience."); #Window popup with warnings.

        #if (quest::get_data(wa_TimerKey)>1) {
        #    quest::set_data(wa_TimerKey, quest::get_data(wa_TimerKey)-1); #Sutract a int from the data_base key.
        #    plugin::Debug("Deleted a int to wa_TimerKey worked."); #Debug if it works thus far.
        #}
        #if (quest::get_data(wa_TimerKey) == 1) {
        #    quest::stoptimer(wa_XPOff_Timer); #STOP a timer. Be carefull to not use the $_ in a timer name. It is like creating a $_$_data. Bad mojo. If a player logs off. The timer...specific to them. Will stop.
        #    plugin::Debug("Stoptimer worked."); #Debug if it works thus far.
        #}
    }
}

###########################################################
#:: End EVENT_SAY
###########################################################

sub EVENT_TIMER { #Timers are entity specific. Not global.
    #my $wa_CharIDKey = $client->CharacterID();
    my $wa_XPKey = "wa_CharXPforID_" . $client->CharacterID(); #Create a unique key for these scripts only that make sense to read in the database.
    my $wa_KeyXPCheck = quest::get_data($wa_XPKey);

        if (wa_XPOff_Timer && $wa_KeyXPCheck) { #Two-level comparison for protection. And good practice to keep the timer from reading alot of info.
            my $wa_CharKey = $client->CharacterID();
            my $wa_StoredXP = quest::get_data($wa_XPKey); #Get that value back from the data_bucket entry.
            my $wa_NewXP = $client->GetEXP(); #get current NEW xp from the character.
            #my $wa_TimerKeyCheck = quest::get_data(wa_TimerKey); #Useless but worked.
            #plugin::Debug("EVENT_TIMER has reach a eight seconds and fired."); #Debug if it works thus far.

            if ($wa_CharKey && $wa_StoredXP && $wa_NewXP > $wa_StoredXP) { #Tri-level comparison for protection.
                #plugin::Debug("if statement passed"); #Debug if it works thus far.
                #quest::whisper("Your new XP is ---- " . $wa_NewXP); #Debug if it works thus far.
                $client->SetEXP($wa_StoredXP,0,0); #Set the characters Xp back to when you started this whole mess.
                #quest::whisper("Your XP is set back to ---- " . $wa_StoredXP); #Debug if it works thus far.
            }
            #if (!$wa_TimerKeyCheck) { 
            #    quest::stoptimer(wa_XPOff_Timer); #STOP a timer. Not needed since if the player logs off or DLs, The Timer stop automaticaly.
            #    plugin::Debug("Timer check NULL so turned off timer."); #Debug if it works thus far.
            #}
        }
}

###########################################################
#:: End EVENT_TIMER
###########################################################

###########################################################
#:: End EVENT_LEVEL_UP
###########################################################