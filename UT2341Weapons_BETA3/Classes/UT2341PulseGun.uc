class UT2341PulseGun extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=UT2341Weapons_Tex.utx

var byte 		BarrelState; //0 - still - 1 - spin - 2 - winddown
var Rotator	BarrelRot;
var float		RotationsPerSecond, RemainingWind;

simulated function bool HasAmmo()
{
	return ( AmmoClass[0] != None && FireMode[0] != None && AmmoCharge[0] >= 1 );
}

function bool ConsumeAmmo(int Mode, float load, optional bool bAmountNeededIsMax)
{
	if ( mode == 0 )
		bAmountNeededIsMax = true;

	return Super.ConsumeAmmo(Mode, load, bAmountNeededIsMax);
}

//===========================================================================
// GetEffectStart
//
// Use tip location
//===========================================================================
simulated function vector GetEffectStart()
{
	if (FireMode[1].bIsFiring)
		return GetBoneCoords('tip2').Origin;
	return GetBoneCoords('tip').Origin;
}

function float GetAIRating()
{
	local Bot B;
	local DestroyableObjective O;
	local Vehicle V;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	V = B.Squad.GetLinkVehicle(B);
	if ( (V != None)
		&& (VSize(Instigator.Location - V.Location) < 1.5 * UT2341PulseAltFire(FireMode[1]).TraceRange)
		&& (V.Health < V.HealthMax) && (V.LinkHealMult > 0) )
		return 1.2;

	if ( Vehicle(B.RouteGoal) != None && B.Enemy == None && VSize(Instigator.Location - B.RouteGoal.Location) < 1.5 * UT2341PulseAltFire(FireMode[1]).TraceRange
	     && Vehicle(B.RouteGoal).TeamLink(B.GetTeamNum()) )
		return 1.2;

	O = DestroyableObjective(B.Squad.SquadObjective);
	if ( O != None && B.Enemy == None && O.TeamLink(B.GetTeamNum()) && O.Health < O.DamageCapacity
	     && VSize(Instigator.Location - O.Location) < 1.1 * UT2341PulseAltFire(FireMode[1]).TraceRange && B.LineOfSightTo(O) )
		return 1.2;

	return AIRating * FMin(Pawn(Owner).DamageScaling, 1.5);
}

//===========================================================================
// AnimEnd
//
// Handles loop firing animation
//===========================================================================
simulated function AnimEnd(int channel)
{
    local name anim;
    local float frame, rate;

    GetAnimParams(0, anim, frame, rate);
	
    if (ClientState == WS_ReadyToFire)
    {
        if (anim == FireMode[1].FireAnim)
        {
			if (FireMode[1].bIsFiring)
				LoopAnim(FireMode[1].FireLoopAnim, FireMode[1].FireLoopAnimRate, 0.0);
			else if (HasAnim(FireMode[1].FireEndAnim))
				PlayAnim(FireMode[1].FireEndAnim, FireMode[1].FireEndAnimRate, 0.0);
        }
        else if ((FireMode[0] == None || !FireMode[0].bIsFiring) && (FireMode[1] == None || !FireMode[1].bIsFiring))
        {
            PlayIdle();
        }
    }
}

//===========================================================================
// WeaponTick
//
// Rotate barrels
//===========================================================================
simulated function WeaponTick (float dt)
{
	if (BarrelState == 1)
	{
		BarrelRot.Roll += dt * RotationsPerSecond * 65535;
		SetBoneRotation('Bone_Barrels', BarrelRot);
	}
	
	else if (BarrelState == 2)
	{
		RemainingWind -= dt;
		if (RemainingWind < 0)
		{
			RemainingWind = default.RemainingWind;
			BarrelState = 0;
		}
		else
		{	BarrelRot.Roll += dt * (RemainingWind / default.RemainingWind) * RotationsPerSecond * 65535;
			SetBoneRotation('Bone_Barrels', BarrelRot);
		}
	}

}
/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local float EnemyDist;
	local bot B;
	local Vehicle V;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return 0;

	if ( ( (DestroyableObjective(B.Squad.SquadObjective) != None && B.Squad.SquadObjective.TeamLink(B.GetTeamNum()))
		|| (B.Squad.SquadObjective == None && DestroyableObjective(B.Target) != None && B.Target.TeamLink(B.GetTeamNum())) )
	     && VSize(B.Squad.SquadObjective.Location - B.Pawn.Location) < FireMode[1].MaxRange() && (B.Enemy == None || !B.EnemyVisible()) )
		return 1;
	V = B.Squad.GetLinkVehicle(B);
	if ( V == None )
		V = Vehicle(B.MoveTarget);
	if ( V == B.Target )
		return 1;
	if ( (V != None) && (VSize(Instigator.Location - V.Location) < UT2341PulseAltFire(FireMode[1]).TraceRange)
		&& (V.Health < V.HealthMax) && (V.LinkHealMult > 0) && B.LineOfSightTo(V) )
		return 1;
	if ( B.Enemy == None )
		return 0;
	EnemyDist = VSize(B.Enemy.Location - Instigator.Location);
	if ( EnemyDist > UT2341PulseAltFire(FireMode[1]).TraceRange || EnemyDist < 400)
		return 0;
	return 1;
}

function float SuggestAttackStyle()
{
	return 0.8;
}

function float SuggestDefenseStyle()
{
    return -0.4;
}

function bool CanHeal(Actor Other)
{
	if (DestroyableObjective(Other) != None && DestroyableObjective(Other).LinkHealMult > 0)
		return true;
	if (Vehicle(Other) != None && Vehicle(Other).LinkHealMult > 0)
		return true;

	return false;
}

defaultproperties
{
     RotationsPerSecond=0.800000
     RemainingWind=0.800000
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341PulseFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341PulseAltFire'
     PutDownAnim="PutDown"
     IdleAnimRate=0.030000
     SelectSound=Sound'UT2341Weapons_Sounds.PulseGun.PulsePickup'
     SelectForce="SwitchToLinkGun"
     AIRating=0.680000
     CurrentRating=0.680000
     Description="Classification: Plasma Rifle||Primary Fire: Medium sized, fast moving plasma balls are fired at a fast rate of fire.||Secondary Fire: A bolt of green lightning is expelled for 100 meters, which will shock all opponents.||Techniques: Firing and keeping the secondary fire's lightning on an opponent will melt them in seconds."
     EffectOffset=(X=100.000000,Y=25.000000,Z=-3.000000)
     DisplayFOV=80.000000
     Priority=7
     HudColor=(B=128,R=128)
     SmallViewOffset=(Y=-1.000000,Z=-12.000000)
     CenteredOffsetY=-5.000000
     CenteredRoll=3000
     CenteredYaw=-1000
     CustomCrosshair=10
     CustomCrossHairColor=(B=128,R=128)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Bracket1"
     InventoryGroup=5
     PickupClass=Class'UT2341Weapons_BETA3.UT2341PulseGunPickup'
     PlayerViewOffset=(Y=-1.000000,Z=-12.000000)
     BobDamping=1.575000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341PulseAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_PulseGun'
     IconCoords=(X2=128,Y2=32)
     ItemName="Pulse Gun"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTPulseGunFP'
     DrawScale=2.000000
}
