class UTUDamageTimer extends UDamageTimer;

#exec OBJ LOAD FILE=UT2341Weapons_Sounds.uax

function Timer()
{
	if ( Pawn(Owner) == None )
	{
		Destroy();
		return;
	}
	if ( SoundCount < 4 )
	{
		SoundCount++;
        Pawn(Owner).PlaySound(Sound'UT2341Weapons_Sounds.General.AmpOut', SLOT_None, 1.5*Pawn(Owner).TransientSoundVolume,,1000,1.0);
		SetTimer(0.75,false);
		return;
	}
	Pawn(Owner).DisableUDamage();
	Destroy();
}

defaultproperties
{
}
