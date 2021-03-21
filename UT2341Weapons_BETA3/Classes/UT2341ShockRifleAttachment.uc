/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifleAttachment extends ShockAttachment;

//var class<xEmitter>     MuzFlashClass;
//var xEmitter            MuzFlash;

simulated function PostNetBeginPlay()
{
    Super(xWeaponAttachment).PostNetBeginPlay();
    /*
    if ( (Instigator != None) && (Instigator.PlayerReplicationInfo != None)&& (Instigator.PlayerReplicationInfo.Team != None) )
    {
        if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 0 )
            Skins[1] = Material'UT2004Weapons.RedShockFinal';
        else if ( Instigator.PlayerReplicationInfo.Team.TeamIndex == 1 )
            Skins[1] = Material'UT2004Weapons.BlueShockFinal';
    }
    */
}


simulated event ThirdPersonEffects()
{
    local rotator r;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
    {
        if ( FiringMode == 0 )
            WeaponLight();
        else
        {
            if (MuzFlash == None)
            {
                MuzFlash = Spawn(MuzFlashClass);
                AttachToBone(MuzFlash, 'tip');
            }
            if (MuzFlash != None)
            {
                MuzFlash.mStartParticles++;
                r.Roll = Rand(65536);
                SetBoneRotation('Flash_Bone', r, 0, 1.f);
            }
        }
    }

    Super(xWeaponAttachment).ThirdPersonEffects();
}

defaultproperties
{
     MuzFlashClass=Class'UT2341Weapons_BETA3.FX_ShockRifleMuzFlash3rd'
     LightHue=165
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTASMD3rd'
     RelativeLocation=(X=0.000000,Y=0.000000,Z=10.000000)
     RelativeRotation=(Pitch=0)
     DrawScale=0.125000
     Skins(0)=Texture'UT2341Weapons_Tex.ASMD-Weapon.ShockRifleTex0'
}
