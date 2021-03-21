//=============================================================================
// Minigun
//=============================================================================
class UT2341Minigun extends Minigun
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

simulated function PostBeginPlay()
{
    Super.PostBeginPlay();

    if ( Level.NetMode == NM_DedicatedServer )
        return;

    ShellCaseEmitter = spawn(class'ShellSpewer');
	if ( ShellCaseEmitter != None )
	{
		ShellCaseEmitter.Trigger(Self, Instigator); //turn off
		AttachToBone(ShellCaseEmitter, 'Bone_CaseEjector');
	}
}

simulated function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	local int AmountNeeded;

	if ( bNoAmmoInstances )
	{
		if ( AmmoClass[0] == AmmoClass[mode] )
			mode = 0;
		AmountNeeded = int(load);
		if (bAmountNeededIsMax && AmmoCharge[mode] < AmountNeeded)
			AmountNeeded = AmmoCharge[mode];

		if (AmmoCharge[mode] < AmountNeeded)
		{
			CheckOutOfAmmo();
			return false;   // Can't do it
		}

		AmmoCharge[mode] -= AmountNeeded;
		NetUpdateTime = Level.TimeSeconds - 1;

		if (Level.NetMode == NM_StandAlone || Level.NetMode == NM_ListenServer)
			CheckOutOfAmmo();

		return true;
	}
    if (Ammo[Mode] != None)
        return Ammo[Mode].UseAmmo(int(load), bAmountNeededIsMax);

    return true;
}

simulated function OutOfAmmo()
{
	log("OUTOFAMMO");
    if ( (Instigator == None) || !Instigator.IsLocallyControlled() || HasAmmo() )
        return;

	Instigator.AmbientSound = None;
	Instigator.SoundVolume = Instigator.default.SoundVolume;
    DoAutoSwitch();
}

function byte BestMode()
{
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( FireMode[0].bIsFiring )
		return 0;
	else if ( FireMode[1].bIsFiring )
		return 1;
	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist < 2000 )
		return 1;
	return 0;
}
// end AI Interface

simulated function SpawnShells(float amountPerSec)
{
    if(ShellCaseEmitter == None || !FirstPersonView())
        return;
	if ( Bot(Instigator.Controller) != None )
	{
		ShellCaseEmitter.Destroy();
		return;
	}

	ShellCaseEmitter.mRegenRange[0] = amountPerSec;
	ShellCaseEmitter.mRegenRange[1] = amountPerSec;
    ShellCaseEmitter.Trigger(self, Instigator);
}

// Client-side only: update the first person barrel rotation
simulated function UpdateRoll(float dt, float speed, int mode)
{
    local rotator r;

    if (Level.NetMode == NM_DedicatedServer)
        return;

    if (mode == CurrentMode) // to limit to one mode
    {
       // log(self$" updateroll (mode="$mode$") speed="$speed);

        RollSpeed = speed;
        CurrentRoll += dt*RollSpeed;
        CurrentRoll = CurrentRoll % 65536.f;
        r.Roll = int(CurrentRoll);
        SetBoneRotation('Bone_Barrels', r, 0, Blend);
    }
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341MinigunFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341MinigunAltFire'
     SelectSound=Sound'UT2341Weapons_Sounds.Minigun.MiniSelect'
     bNoAmmoInstances=False
     Description="Classification: Gatling Gun||Primary Fire: Bullets are sprayed forth at a medium to fast rate of fire and good accuracy.||Secondary Fire: Minigun fires twice as fast and is half as accurate.||Techniques: Secondary fire is much more useful at close range, but can eat up tons of ammunition."
     EffectOffset=(Y=22.000000,Z=-10.000000)
     DisplayFOV=80.000000
     SmallViewOffset=(X=0.000000,Y=2.000000,Z=-5.000000)
     InventoryGroup=7
     PickupClass=Class'UT2341Weapons_BETA3.UT2341MinigunPickup'
     PlayerViewOffset=(X=0.000000,Y=2.000000,Z=-5.000000)
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341MinigunAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_Minigun'
     IconCoords=(X1=0,Y1=0,X2=128,Y2=32)
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTminigun_FP'
     DrawScale=1.000000
     HighDetailOverlay=None
}
