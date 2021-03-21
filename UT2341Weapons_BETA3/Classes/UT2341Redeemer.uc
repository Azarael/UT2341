class UT2341Redeemer extends Weapon
    config(user);

simulated event ClientStopFire(int Mode)
{
    if (Role < ROLE_Authority)
    {
        StopFire(Mode);
    }
    if ( Mode == 0 )
		ServerStopFire(Mode);
}

simulated event WeaponTick(float dt)
{
	if ( (Instigator.Controller == None) || HasAmmo() )
		return;
	Instigator.Controller.SwitchToBestWeapon();
}


// AI Interface
function float SuggestAttackStyle()
{
    return -1.0;
}

function float SuggestDefenseStyle()
{
    return -1.0;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	return 0;
}

function float GetAIRating()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return 0.4;

	if ( B.IsShootingObjective() )
		return 1.0;

	if ( (B.Enemy == None) || B.Enemy.bCanFly || VSize(B.Enemy.Location - Instigator.Location) < 2400 )
		return 0.4;

	return AIRating;
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341RedeemerFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341RedeemerGuidedFire'
     PutDownAnim="PutDown"
     SelectAnimRate=0.667000
     PutDownAnimRate=1.000000
     PutDownTime=0.450000
     BringUpTime=0.675000
     SelectSound=Sound'UT2341Weapons_Sounds.Redeemer.WarheadPickup'
     SelectForce="SwitchToFlakCannon"
     AIRating=1.500000
     CurrentRating=1.500000
     Description="Classification: Thermonuclear Device||Primary Fire: Launches a huge yet slow moving missile that, upon striking a solid surface, will explode and send out a gigantic shock wave, instantly pulverizing anyone or anything within its colossal radius, including yourself.||Secondary Fire: Take control of the missile and fly it anywhere.  You can press the primary fire button to explode the missile early.||Techniques: Remember that while this rocket is being piloted you are a sitting duck.  If an opponent manages to hit your incoming Redeemer missile while it's in the air, the missile will explode harmlessly."
     DisplayFOV=80.000000
     Priority=16
     SmallViewOffset=(Y=1.000000,Z=-12.000000)
     CustomCrosshair=13
     CustomCrossHairColor=(B=128)
     CustomCrossHairScale=2.000000
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Circle2"
     InventoryGroup=0
     GroupOffset=1
     PickupClass=Class'UT2341Weapons_BETA3.UT2341RedeemerPickup'
     PlayerViewOffset=(Y=1.000000,Z=-12.000000)
     BobDamping=1.400000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341RedeemerAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_Redeemer'
     IconCoords=(X2=127,Y2=32)
     ItemName="Redeemer"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTRedeemerFP'
     DrawScale=2.000000
}
