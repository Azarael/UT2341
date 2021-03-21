/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifle extends Weapon;

#exec OBJ LOAD FILE=UT2341Weapons_Tex.utx
#exec OBJ LOAD FILE=UT2341Weapons_Anims.ukx
#exec OBJ LOAD FILE=UT2341Weapons_SM.usx

var ShockProjectile ComboTarget;	// used by AI
var bool			bRegisterTarget;
var	bool			bWaitForCombo;
var vector			ComboStart;
var color			EffectColor;

simulated function vector GetEffectStart()
{
	local Coords C;

    if ( Instigator.IsFirstPerson() )
    {
		if ( WeaponCentered() )
			return CenteredEffectStart();
	    C = GetBoneCoords('tip');
		return C.Origin - 15 * C.XAxis;
	}
	return Super.GetEffectStart();
}

simulated function bool WeaponCentered()
{
	return ( bSpectated || (Hand > 1) );
}

// AI Interface
function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 8000 )
			return 0.9;
		return AIRating;
	}

	if ( bWaitForCombo )
		return 1.5;
	if ( !B.ProficientWithWeapon() )
		return AIRating;
	if ( B.Stopped() )
	{
		if ( !B.EnemyVisible() && (VSize(B.Enemy.Location - Instigator.Location) < 5000) )
			return (AIRating + 0.5);
		return (AIRating + 0.3);
	}
	else if ( VSize(B.Enemy.Location - Instigator.Location) > 1600 )
		return (AIRating + 0.1);
	else if ( B.Enemy.Location.Z > B.Location.Z + 200 )
		return (AIRating + 0.15);

	return AIRating;
}

function SetComboTarget(ShockProjectile S)
{
	if ( !bRegisterTarget || (bot(Instigator.Controller) == None) || (Instigator.Controller.Enemy == None) )
		return;

	bRegisterTarget = false;
	ComboStart = Instigator.Location;
	ComboTarget = S;
	ComboTarget.Monitor(Bot(Instigator.Controller).Enemy);
}

function float RangedAttackTime()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( B.CanComboMoving() )
		return 0;

	return FMin(2,0.3 + VSize(B.Enemy.Location - Instigator.Location)/class'ShockProjectile'.default.Speed);
}

function float SuggestAttackStyle()
{
	return -0.4;
}

simulated function bool StartFire(int mode)
{
	if ( bWaitForCombo && (Bot(Instigator.Controller) != None) )
	{
		if ( (ComboTarget == None) || ComboTarget.bDeleteMe )
			bWaitForCombo = false;
		else
			return false;
	}
	return Super.StartFire(mode);
}

function DoCombo()
{
	if ( bWaitForCombo )
	{
		bWaitForCombo = false;
		if ( (Instigator != None) && (Instigator.Weapon == self) )
			StartFire(0);
	}
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local float EnemyDist, MaxDist;
	local bot B;

	bWaitForCombo = false;
	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if (B.IsShootingObjective())
		return 0;

	if ( !B.EnemyVisible() )
	{
		if ( (ComboTarget != None) && !ComboTarget.bDeleteMe && B.CanCombo() )
		{
			bWaitForCombo = true;
			return 0;
		}
		ComboTarget = None;
		if ( B.CanCombo() && B.ProficientWithWeapon() )
		{
			bRegisterTarget = true;
			return 1;
		}
		return 0;
	}

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( B.Skill > 5 )
		MaxDist = 4 * class'ShockProjectile'.default.Speed;
	else
		MaxDist = 3 * class'ShockProjectile'.default.Speed;

	if ( (EnemyDist > MaxDist) || (EnemyDist < 150) )
	{
		ComboTarget = None;
		return 0;
	}

	if ( (ComboTarget != None) && !ComboTarget.bDeleteMe && B.CanCombo() )
	{
		bWaitForCombo = true;
		return 0;
	}

	ComboTarget = None;

	if ( (EnemyDist > 2500) && (FRand() < 0.5) )
		return 0;

	if ( B.CanCombo() && B.ProficientWithWeapon() )
	{
		bRegisterTarget = true;
		return 1;
	}
	if ( FRand() < 0.7 )
		return 0;
	return 1;
}
// end AI Interface

defaultproperties
{
     EffectColor=(B=255,G=125,R=128,A=96)
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341ShockRifleBeamFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341ShockRifleProjectileFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'UT2341Weapons_Sounds.ShockRifle.TazerSelect'
     SelectForce="SwitchToShockRifle"
     Description="Classification: Energy Rifle||Primary Fire: Instant hit laser beam.||Secondary Fire: Large, slow moving plasma balls.||Techniques: Hitting the secondary fire plasma balls with the regular fire's laser beam will cause an immensely powerful explosion."
     EffectOffset=(X=65.000000,Y=14.000000,Z=-10.000000)
     DisplayFOV=80.000000
     HudColor=(B=255,G=0,R=128)
     SmallViewOffset=(X=5.000000,Y=1.000000,Z=-4.000000)
     CenteredOffsetY=1.000000
     CenteredRoll=1000
     CenteredYaw=-1000
     CustomCrosshair=5
     CustomCrossHairColor=(G=0)
     CustomCrossHairScale=0.698105
     InventoryGroup=4
     PickupClass=Class'UT2341Weapons_BETA3.UT2341ShockRiflePickup'
     PlayerViewOffset=(X=-2.000000,Z=-10.000000)
     BobDamping=1.800000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341ShockRifleAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_ShockRifle'
     IconCoords=(X2=128,Y2=32)
     ItemName="ASMD Shock Rifle"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=165
     LightSaturation=70
     LightBrightness=255.000000
     LightRadius=4.000000
     LightPeriod=3
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTASMD_FP'
     DrawScale=1.500000
}
