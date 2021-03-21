class UT2341BioRifle extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

function DropFrom(vector StartLocation)
{
	if ( bCanThrow && (AmmoAmount(0) == 0) )
		AddAmmo(1,0);
    Super.DropFrom(StartLocation);
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

	if ( B.Enemy == None )
	{
		if ( (B.Target != None) && VSize(B.Target.Location - B.Pawn.Location) > 3500 )
			return 0.2;
		return AIRating;
	}

	// if retreating, favor this weapon
	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	if ( EnemyDist > 1500 )
		return 0.1;
	if ( B.IsRetreating() )
		return (AIRating + 0.4);
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon )
		return (AIRating + 0.35);
	if ( -1 * EnemyDir.Z > EnemyDist )
		return AIRating + 0.1;
	if ( EnemyDist > 1000 )
		return 0.35;
	return AIRating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	if ( FRand() < 0.8 )
		return 0;
	return 1;
}

function float SuggestAttackStyle()
{
	local Bot B;
	local float EnemyDist;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0.4;

	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > 1500 )
		return 1.0;
	if ( EnemyDist > 1000 )
		return 0.4;
	return -0.4;
}

function float SuggestDefenseStyle()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( VSize(B.Enemy.Location - Instigator.Location) < 1600 )
		return -0.6;
	return 0;
}

// End AI Interface

simulated function AnimEnd(int Channel)
{
    local name anim;
    local float frame, rate;
    GetAnimParams(0, anim, frame, rate);

    if (anim == 'FireLoop')
        LoopAnim('IDLEFireLoop', 1.0, 0.1);
    else
        Super.AnimEnd(Channel);
}

simulated function bool HasAmmo()
{
    return ( (AmmoAmount(0) >= 1) || FireMode[1].bIsFiring );
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341BioFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341BioChargedFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'UT2341Weapons_Sounds.BioRifle.GelSelect'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.550000
     CurrentRating=0.550000
     Description="Classification: Toxic Rifle||Primary Fire: Wads of Tarydium byproduct are lobbed at a medium rate of fire.||Secondary Fire: When trigger is held down, the BioRifle will create a much larger wad of byproduct. When this wad is launched, it will burst into smaller wads which will adhere to any surfaces.||Techniques: Byproducts will adhere to walls, floors, or ceilings. Chain reactions can be caused by covering entryways with this lethal green waste."
     EffectOffset=(X=100.000000,Y=25.000000)
     DisplayFOV=80.000000
     Priority=4
     HudColor=(B=255,G=0,R=0)
     SmallViewOffset=(X=4.000000,Y=-4.000000,Z=-15.000000)
     CenteredOffsetY=-8.000000
     CustomCrosshair=7
     CustomCrossHairColor=(G=0,R=0)
     CustomCrossHairScale=1.333000
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Triad1"
     InventoryGroup=3
     PickupClass=Class'UT2341Weapons_BETA3.UT2341BioRiflePickup'
     PlayerViewOffset=(X=4.000000,Y=-4.000000,Z=-15.000000)
     PlayerViewPivot=(Pitch=1024)
     BobDamping=2.200000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341BioAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_BioRifle'
     IconCoords=(X2=127,Y2=31)
     ItemName="GES Bio-Rifle"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTGESBioRifleFP'
     DrawScale=2.000000
}
