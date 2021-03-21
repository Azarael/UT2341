//=============================================================================
// Flak Cannon
//=============================================================================
class UT2341FlakCannon extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

simulated function Notify_Hydraulic()
{
	if (Instigator.IsLocallyControlled())
		PlaySound(Sound'UT2341Weapons_Sounds.Flak.load1', SLOT_None,0.65,,,,false);
}

simulated function Notify_HydraulicSelect()
{
	PlayOwnedSound(Sound'UT2341Weapons_Sounds.Flak.Hidraul2', SLOT_None,0.8,,,,false);
}

// AI Interface
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;
		
	if ( (B.Target != None) && (Pawn(B.Target) == None) && (VSize(B.Target.Location - Instigator.Location) < 1250) )
		return 0.9;
		
	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 3500 )
			return 0.2;
		return AIRating;
	}

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
	{
		if ( EnemyDist > 2000 )
		{
			if ( EnemyDist > 3500 )
				return 0.2;
			return (AIRating - 0.3);
		}
		if ( EnemyDir.Z < -0.5 * EnemyDist )
			return (AIRating - 0.3);
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.35);
	else if ( EnemyDist < 400 )
		return (AIRating + 0.2);
	return FMax(AIRating + 0.2 - (EnemyDist - 400) * 0.0008, 0.2);
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local vector EnemyDir;
	local float EnemyDist;
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 750 )
	{
		if ( EnemyDir.Z < -0.5 * EnemyDist )
			return 1;
		return 0;
	}
	else if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return 0;
	else if ( (EnemyDist < 400) || (EnemyDir.Z > 30) )
		return 0;
	else if ( FRand() < 0.65 )
		return 1;
	return 0;
}

function float SuggestAttackStyle()
{
	if ( (AIController(Instigator.Controller) != None)
		&& (AIController(Instigator.Controller).Skill < 3) )
		return 0.4;
    return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}
// End AI Interface

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341FlakFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341FlakAltFire'
     PutDownAnim="PutDown"
     BringUpTime=1.000000
     SelectSound=Sound'UT2341Weapons_Sounds.flak.pdown'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.750000
     CurrentRating=0.750000
     Description="Classification: Heavy Shrapnel||Primary Fire: White hot chunks of scrap metal are sprayed forth, shotgun style.||Secondary Fire: A grenade full of shrapnel is lobbed at the enemy.||Techniques: The Flak Cannon is far more useful in close range combat situations."
     EffectOffset=(X=200.000000,Y=32.000000,Z=-25.000000)
     DisplayFOV=80.000000
     Priority=13
     HudColor=(G=128)
     SmallViewOffset=(X=5.000000,Z=-7.000000)
     CenteredOffsetY=-4.000000
     CenteredRoll=3000
     CenteredYaw=-500
     CustomCrosshair=9
     CustomCrossHairColor=(B=0,G=128)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Triad3"
     InventoryGroup=8
     PickupClass=Class'UT2341Weapons_BETA3.UT2341FlakCannonPickup'
     PlayerViewOffset=(X=5.000000,Z=-7.000000)
     BobDamping=1.400000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341FlakAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_FlakCannon'
     IconCoords=(X2=128,Y2=32)
     ItemName="Flak Cannon"
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=4.000000
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTFlakCannonFP'
}
