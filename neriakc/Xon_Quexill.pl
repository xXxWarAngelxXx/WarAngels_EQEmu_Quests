sub EVENT_SPAWN
{
  $x = $npc->GetX();
  $y = $npc->GetY();
  quest::set_proximity($x - 50, $x + 50, $y - 50, $y + 50);
}

sub EVENT_ENTER
{
  if(plugin::check_hasitem($client, 18758)) 
  { 
		#$client->Message(15"Xon Quexill turns towards you. 'Welcome to the Lodge of the Dead. I am Xon Quexill and with my training you will learn to master the Necromantic arts. Read the note in your inventory and hand it to me when you are ready to begin your training.'");
		quest::emote("Xon Quexill turns towards you."); #created by WarAngel
		quest::say("Welcome to the Lodge of the Dead $name. I am Xon Quexill and with our training you will learn to master the Necromantic arts. Read the note in your inventory and hand it to me when you are ready to begin your training.");#created by WarAngel
  }
}

sub EVENT_SAY 
{
	if($text=~/Hail/i)
	{
		if ($class eq "Necromancer") #Common greeting
		{
		quest::say("Welcome to the Lodge of the Dead. May you serve our Queen with the bleeding of others.");
		plugin::DoAnim("nod"); #added by WarAngel
		}
		else
		{
		quest::say("One that is not of my kind... What do you want!"); #added by WarAngel
		plugin::DoAnim("point"); #added by WarAngel
		}
	}
	if($text=~/befallen/i)
	{
		quest::say("It is true that the return of Marnek could create difficulties for us, especially if this has the blessing of Solusek Ro himself. Therefore, I command you to deliver to me any further information you uncover regarding the plans of the Burning Dead, and likewise I order you to return here at my bidding for further instructions in this matter. Now, begone.");
	}
	if ($text=~/trade/i)
	{
		quest::say("I thought you might be one who was interested in the various different trades, but which one would suit you? Ahh, alas, it would be better to let you decide for yourself, perhaps you would even like to master them all! That would be quite a feat. Well, lets not get ahead of ourselves, here, take this book. When you have finished reading it, ask me for the " . quest::saylink("second book", 1) . ", and I shall give it to you. Inside them you will find the most basic recipes for each trade. These recipes are typically used as a base for more advanced crafting, for instance, if you wished to be a smith, one would need to find some ore and smelt it into something usable. Good luck!");
		plugin::DoAnim("nod");
		quest::summonitem(51121); # Item: Tradeskill Basics : Volume I
	}
	if ($text=~/second book/i)
	{
		quest::say("Here is the second volume of the book you requested, may it serve you well!");
		quest::summonitem(51122); # Item: Tradeskill Basics : Volume II
	}
}

sub EVENT_ITEM
{
	if(plugin::check_handin(\%itemcount,18474 =>1))
	{
		quest::say("Very interesting, servant of the Queen. This deed has stayed my wrath for this interruption of my business. Where did you find this?");
		quest::faction(239,1); # Faction: The Dead
		quest::faction(303,1); # Faction: Queen Cristanos Thex
		quest::faction(278,-3); # Faction: King Naythox Thex
		quest::faction(275,-3); # Faction: Keepers of the Art
		quest::faction(245,-3); # Faction: Eldritch Collective
		quest::faction(1522,-3); # Faction: Primordial Malice
		quest::exp(6400);
		quest::ding();
		quest::givecash(0,8,0,0);
	}
	elsif(plugin::check_handin(\%itemcount,31492 => 1))
	{
		quest::say("It is true that the return of Marnek could create difficulties for us, especially if this has the blessing of Solusek Ro himself. Therefore, I command you to deliver to me any further information you uncover regarding the plans of the Burning Dead, and likewise I order you to return here at my bidding for further instructions in this matter. Now, begone.");
		quest::summonitem(31496); # Item: Bridle of Sir Ariam
		quest::faction(239,1); # Faction: The Dead
		quest::faction(303,1); # Faction: Queen Cristanos Thex
		quest::faction(278,-3); # Faction: King Naythox Thex
		quest::faction(275,-3); # Faction: Keepers of the Art
		quest::faction(245,-3); # Faction: Eldritch Collective
		quest::faction(1522,-3); # Faction: Primordial Malice
		quest::exp(6400);
		quest::ding();
	}
	elsif(plugin::check_handin(\%itemcount,18758 => 1)) #Tattered Note
	{
		quest::emote("reads the note...");
		quest::say("So you believe you good enough to command the dead?");
		quest::say("Just what I need in this outfit, another waste of flesh. Here, put this on. Go bother Talorial for a while. I'm sure he has some menial task for you. Return to me when you have become more experienced in our art, I will be able to further instruct you on how to progress through your early ranks, as well as in some of the various " . quest::saylink("trades", 1) . " you will have available to you. You'd better prove yourself of value to me. I hear I can get a few plat for the skull of an idiot on the black market, and I could make a fortune from your type. Now, get outta here!");
		quest::summonitem(13587); #Faction:Dark Stained Training Robe*
		quest::faction(239,100); #Faction:The Dead
		quest::faction(303,15); #Faction:Queen Cristanos Thex
		quest::faction(278,-15); #Faction:King Naythox Thex
		quest::faction(275,-15); #Faction:Keeper of the Art
		quest::faction(245,-15); #Faction:Eldritch Collective
		quest::faction(1522,-200); #Faction:Primodial Malice
		quest::exp(100);
		quest::ding();
	}
  plugin::try_tome_handins(\%itemcount, $class, 'Necromancer');
  plugin::return_items(\%itemcount);

}
