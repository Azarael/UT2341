class UT2341FlakAttachment extends xWeaponAttachment;

var class<FlakMuzFlash3rd>  mMuzFlashClass;
var xEmitter                mMuzFlash3rd;

simulated function PostNetBeginPlay()
{
	Super.PostNetBeginPlay();
	PlayAnim('Select', 1.35);
}

simulated function Destroyed()
{
    if (mMuzFlash3rd != None)
        mMuzFlash3rd.Destroy();
	Super.Destroyed();
}

simulated event ThirdPersonEffects()
{
    local rotator r;

    if ( Level.NetMode != NM_DedicatedServer && FlashCount > 0 )
	{
		WeaponLight();
        if (mMuzFlash3rd == None)
        {
            mMuzFlash3rd = Spawn(mMuzFlashClass);
            AttachToBone(mMuzFlash3rd, 'tip');
        }
        if (mMuzFlash3rd != None)
        {
            r.Roll = Rand(65536);
            SetBoneRotation('Bone_Flash', r, 0, 1.f);
            mMuzFlash3rd.mStartParticles++;
        }
    }
	
	if (FiringMode == 0)
		PlayAnim('FireLoad',1.35);
	else PlayAnim('FireAltLoad',1.25);

    Super.ThirdPersonEffects();
}

simulated function Notify_AttachmentLoad()
{
	if (Level.NetMode != NM_DedicatedServer && !Instigator.IsLocallyControlled())
		PlaySound(Sound'UT2341Weapons_Sounds.Flak.load1', SLOT_None,0.65,,,,false);
}

defaultproperties
{
     mMuzFlashClass=Class'XEffects.FlakMuzFlash3rd'
     bHeavy=True
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTFlakCannon3rd'
     DrawScale=0.100000
}
