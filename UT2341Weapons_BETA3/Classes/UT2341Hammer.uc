//=============================================================================
// Shield Gun
//=============================================================================
class UT2341Hammer extends Weapon
    config(user)
    HideDropDown;
	
replication
{
	reliable if (Role == ROLE_Authority)
		ClientForceRelease;
}

simulated function ClientForceRelease(byte Mode)
{
    if (Role < ROLE_Authority)
        StopFire(Mode);
}

// AI Interface
function GiveTo(Pawn Other, optional Pickup Pickup)
{
	Super.GiveTo(Other, Pickup);

	if ( Bot(Other.Controller) != None )
		Bot(Other.Controller).bHasImpactHammer = true;
}

function bool CanAttack(Actor Other)
{
	return true;
}

simulated function Timer()
{
	local Bot B;

    if (ClientState == WS_BringUp)
    {
		// check if owner is bot waiting to do impact jump
		B = Bot(Instigator.Controller);
		if ( (B != None) && B.bPreparingMove && (B.ImpactTarget != None) )
		{
			B.ImpactJump();
			B = None;
		}
    }
	Super.Timer();
	if ( (B != None) && (B.Enemy != None) )
		BotFire(false);
}

function FireHack(byte Mode)
{
	if ( Mode == 0 )
	{
		FireMode[0].PlayFiring();
		FireMode[0].FlashMuzzleFlash();
		FireMode[0].StartMuzzleSmoke();
		IncrementFlashCount(0);
	}
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	return 0;
}

// super desireable for bot waiting to impact jump
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	if ( B.bPreparingMove && (B.ImpactTarget != None) )
		return 9;

	if ( B.Enemy == None )
		return AIRating;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( B.Stopped() && (EnemyDist > 100) )
		return 0.1;

	if ( (EnemyDist < 750) && (B.Skill <= 2) && !B.Enemy.IsA('Bot') && (UT2341Hammer(B.Enemy.Weapon) != None) )
		return FClamp(300/(EnemyDist + 1), 0.6, 0.75);

	if ( EnemyDist > 400 )
		return 0.1;
	if ( (Instigator.Weapon != self) && (EnemyDist < 120) )
		return 0.25;

	return ( FMin(0.6, 90/(EnemyDist + 1)) );
}

// End AI interface

simulated function AnimEnd(int channel)
{
    if (FireMode[0].bIsFiring)
    {
        LoopAnim('FireLoop', 2);
		Instigator.AmbientSound = UT2341HammerFire(FireMode[0]).ChargingSound;
		Instigator.SoundVolume = UT2341HammerFire(FireMode[0]).ChargingSoundVolume;
    }
    else
        Super.AnimEnd(channel);
}

function float SuggestAttackStyle()
{
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.8;
}

simulated function float ChargeBar()
{
	return FMin(1,FireMode[0].HoldTime/UT2341HammerFire(FireMode[0]).FullyChargedTime);
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341HammerFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341HammerAltFire'
     PutDownAnim="PutDown"
     BringUpTime=0.500000
     SelectSound=Sound'UT2341Weapons_Sounds.Hammer.ImpactPickup'
     SelectForce="ShieldGun_change"
     AIRating=0.350000
     CurrentRating=0.350000
     bMeleeWeapon=True
     bShowChargingBar=True
     bCanThrow=False
     Description="Classification: Melee Piston||Primary Fire: When trigger is held down, touch opponents with this piston to inflict massive damage.||Secondary Fire: Damages opponents at close range and has the ability to deflect projectiles.||Techniques: Shoot at the ground while jumping to jump extra high."
     EffectOffset=(X=15.000000,Y=5.500000,Z=2.000000)
     DisplayFOV=80.000000
     Priority=2
     HudColor=(G=150)
     SmallViewOffset=(Z=-13.000000)
     CenteredOffsetY=-9.000000
     CenteredRoll=1000
     CustomCrosshair=6
     CustomCrossHairColor=(B=121,G=188)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Pointer"
     PickupClass=Class'XWeapons.ShieldGunPickup'
     PlayerViewOffset=(Z=-13.000000)
     PlayerViewPivot=(Pitch=1024)
     BobDamping=2.200000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341HammerAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_ImpactHammer'
     IconCoords=(X2=127,Y2=31)
     ItemName="Impact Hammer"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTImpactHammerFP'
     DrawScale=1.500000
     TransientSoundVolume=1.000000
}
