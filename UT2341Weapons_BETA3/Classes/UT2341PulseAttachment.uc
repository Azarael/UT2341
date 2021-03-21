class UT2341PulseAttachment extends xWeaponAttachment;

var FX_PulseMuzFlash MuzFlash;

simulated function Destroyed()
{
    if ( MuzFlash != None )
        MuzFlash.Destroy();

    super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    local Rotator R;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
        if (FiringMode == 0)
        {
            if (MuzFlash == None)
            {
                MuzFlash = Spawn(class'FX_PulseMuzFlash');
                AttachToBone(MuzFlash, 'tip');
            }
            if (MuzFlash != None)
            {
                MuzFlash.Trigger(self, None);
                R.Roll = Rand(65536);
                SetBoneRotation('Bone_flashA', R, 0, 1.0);
            }
        }
    }
	
    super.ThirdPersonEffects();
}

defaultproperties
{
     bRapidFire=True
     bAltRapidFire=True
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTPulseGun3rd'
     RelativeLocation=(X=3.000000,Z=6.000000)
     DrawScale=0.250000
}
