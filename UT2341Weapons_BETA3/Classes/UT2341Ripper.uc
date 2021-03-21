class UT2341Ripper extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

// AI Interface
function float GetAIRating()
{
	local Bot B;

	B = Bot(Owner);

	if ( B != None && B.Enemy != None )
	{
		if ( B.Location.Z > B.Enemy.Location.Z + 140 )
		{
			return (AIRating + 0.25);
		}
		else if ( B.Enemy.Location.Z > B.Location.Z + 160 )
			return (AIRating - 0.07);
	}
	return (AIRating + FRand() * 0.05);
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local Bot B;
	
	B = Bot(Owner);
	if ( B != None && ((B.Enemy == None ) || (B.Enemy.Location.Z < B.Location.Z - 60) || (FRand() < 0.5)) )
		return 1;
	return 0;
}

function float SuggestAttackStyle()
{
	return -0.2;
}

function float SuggestDefenseStyle()
{
	return -0.2;
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341RipperFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341RipperAltFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'UT2341Weapons_Sounds.Ripper.Beam'
     SelectForce="SwitchToFlakCannon"
     AIRating=0.550000
     CurrentRating=0.550000
     Description="Classification: Ballistic Blade Launcher||Primary Fire: Razor sharp titanium disks are launched at a medium rate of speed. Shots will ricochet off of any surfaces.||Secondary Fire: Explosive disks are launched at a slow rate of fire.||Techniques: Aim for the necks of your opponents."
     EffectOffset=(X=100.000000,Y=32.000000,Z=-20.000000)
     DisplayFOV=80.000000
     Priority=4
     HudColor=(B=255,G=64,R=64)
     SmallViewOffset=(Y=-1.000000,Z=-12.000000)
     CenteredOffsetY=-8.000000
     CustomCrosshair=7
     CustomCrossHairColor=(G=0,R=0)
     CustomCrossHairScale=1.333000
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Triad1"
     InventoryGroup=6
     PickupClass=Class'UT2341Weapons_BETA3.UT2341RipperPickup'
     PlayerViewOffset=(Y=-1.000000,Z=-12.000000)
     BobDamping=2.200000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341RipperAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_Ripper'
     IconCoords=(X2=128,Y2=32)
     ItemName="Ripper"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTRipperFP'
     DrawScale=2.000000
}
