class UT2341SniperZoomFire extends WeaponFire;

function PlayFiring()
{
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     bWaitForRelease=True
     bModeExclusive=False
     FireAnim=
     FireLoopAnim=
     FireEndAnim=
     FireRate=0.100000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341SniperAmmo'
     BotRefireRate=0.300000
}
