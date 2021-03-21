//=============================================================================
// Translocator Launcher
//=============================================================================
class UT2341Translocator extends TransLauncher
    config(user)
    HideDropDown;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

var bool bBeaconOut, bOldHasBeacon;

replication
{
	reliable if (Role == ROLE_Authority)
		bBeaconOut;
}

simulated function PostNetReceive()
{
	Super.PostNetReceive();
	
	if (bBeaconOut != bOldHasBeacon)
	{
		bOldHasBeacon = bBeaconOut;
		if (!bBeaconOut)
		{
			IdleAnim = 'Idle';
			SelectAnim = 'Select';
			PutDownAnim = 'PutDown';
			SetBoneScale(1, 1, 'Module');
		}

		else
		{
			IdleAnim = 'IdleFiredA';
			SelectAnim = 'SelectFiredA';
			PutDownAnim = 'PutDownFiredA';
			SetBoneScale(1, 0, 'Module');
		}
	}
}
function class<DamageType> GetDamageType()
{
	return class'DamTypeTelefrag';
}

function ReduceAmmo()
{
}

simulated function GetAmmoCount(out float MaxAmmoPrimary, out float CurAmmoPrimary)
{
	MaxAmmoPrimary=1;
	CurAmmoPrimary=1;
}

function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    Super(Weapon).GiveAmmo(m, WP,bJustSpawned);
}

function DrainCharges()
{
}

simulated function float ChargeBar()
{
	return 0;
}

simulated function BringUp(optional Weapon PrevWeapon)
{
	if (!bBeaconOut)
	{
		IdleAnim = 'Idle';
		SelectAnim = 'Select';
		PutDownAnim = 'PutDown';
	}
	
	else
	{
		IdleAnim = 'IdleFiredA';
		SelectAnim = 'SelectFiredA';
		PutDownAnim = 'PutDownFiredA';
	}
	
	Super.BringUp(PrevWeapon);
}


function BeaconOut(bool bIsInWorld)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);
	
	bBeaconOut=bIsInWorld;
	
	log("BeaconOut:"@bIsInWorld@anim@frame);
	
	UT2341TransAttachment(ThirdPersonActor).SetDiskShow(!bBeaconOut);
	
	if (bBeaconOut)
	{
		IdleAnim = 'IdleFiredA';
		SelectAnim = 'SelectFiredA';
		PutDownAnim = 'PutDownFiredA';
		SetBoneScale(1, 0, 'Module');

	}
	else
	{
		IdleAnim = 'Idle';
		SelectAnim = 'Select';
		PutDownAnim = 'PutDown';
		if (anim == 'IdleFiredA')
			TweenAnim('Idle', 0.15);
		SetBoneScale(1, 1, 'Module');
	}
}

defaultproperties
{
     AmmoChargeF=1.000000
     RepAmmo=1
     AmmoChargeMax=1.000000
     AmmoChargeRate=1.000000
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341TransFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341TransRecall'
     bShowChargingBar=False
     EffectOffset=(Y=-30.000000)
     DisplayFOV=80.000000
     SmallViewOffset=(X=-12.000000,Y=0.000000,Z=-10.000000)
     PickupClass=Class'UT2341Weapons_BETA3.UT2341TransPickup'
     PlayerViewOffset=(X=-12.000000,Y=0.000000,Z=-10.000000)
     PlayerViewPivot=(Pitch=1024)
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341TransAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_Translocator'
     IconCoords=(X2=127,Y2=31)
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTTranslocatorFP'
     DrawScale=2.000000
     Skins(0)=Texture'UT2341Weapons_Tex.XLoc.TranslocatorTex'
     Skins(1)=Texture'UT2341Weapons_Tex.General.HandTex'
}
