/*************************************************************
*
*
*
*************************************************************/
class DamType_RipperBladeHead extends WeaponDamageType
	abstract;

var class<LocalMessage> KillerMessage;

static function IncrementKills(Controller Killer)
{
	local xPlayerReplicationInfo xPRI;
	
	if ( PlayerController(Killer) == None )
		return;
		
	PlayerController(Killer).ReceiveLocalizedMessage( Default.KillerMessage, 0, Killer.PlayerReplicationInfo, None, None );
	xPRI = xPlayerReplicationInfo(Killer.PlayerReplicationInfo);
	if ( xPRI != None )
	{
		xPRI.headcount++;
		if ( (xPRI.headcount == 15) && (UnrealPlayer(Killer) != None) )
			UnrealPlayer(Killer).ClientDelayedAnnouncementNamed('HeadHunter',15);
	}
}	

defaultproperties
{
     KillerMessage=Class'XGame.SpecialKillMessage'
     WeaponClass=Class'UT2341Weapons_BETA3.UT2341Ripper'
     DeathString="%k took off %o's head with the Ripper."
     FemaleSuicide="%o took her own head off with a razorblade."
     MaleSuicide="%o took his own head off with a razorblade."
     bAlwaysSevers=True
     bSpecial=True
     bRagdollBullet=True
     bBulletHit=True
     GibPerterbation=1.000000
     KDamageImpulse=6000.000000
     VehicleDamageScaling=0.000000
}
