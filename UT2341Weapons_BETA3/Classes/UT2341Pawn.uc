//===========================================================================
// UT2341 Pawn.
//
// For UT99 handling.
// It turns out that the basic properties vary very little between the two engines - the UT2004 scale
// is about 12.5% greater than that of UT99, but the properties have a 10% adjustment so it seems 
// to work out regardless.
//===========================================================================
class UT2341Pawn extends xPawn;

var bool bHasShieldBelt; //used to prevent this overlay from being removed
var int	ArmorStrength, MaxArmorStrength;

var Vector BloodFlashV, ShieldFlashV;

var Material	ShieldShaders[4];

replication
{
	reliable if (Role == ROLE_Authority)
		ArmorStrength;
}


function bool CanDoubleJump()
{
	return false;
}

function bool CanMultiJump()
{
	return false;
}

function EnableUDamage(float amount)
{
    UDamageTime = FMax(UDamageTime, Level.TimeSeconds+amount);
    ClientSetUDamageTime(UDamageTime - Level.TimeSeconds);
    if ( UDamageTimer == None )
		UDamageTimer = Spawn(class'UTUDamageTimer',self);
	UDamageTimer.SetTimer(UDamageTime - Level.TimeSeconds - 3,false);
	LightType = LT_Steady;
	bDynamicLight = true;
    SetWeaponOverlay(UDamageWeaponMaterial, UDamageTime - Level.TimeSeconds, false);
}

//===========================================================================
// SetOverlayMaterial
//
// Push the Shield Belt overlay if there is no current and we have ShieldStrength
//===========================================================================
simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
    if (OverlayMaterial == None || OverlayMaterial == mat || bOverride)
    {
		if (mat == None && ShieldStrength > 0)
		{
			if (PlayerReplicationInfo.Team != None)
				OverlayMaterial = ShieldShaders[PlayerReplicationInfo.Team.TeamIndex];
			else OverlayMaterial = ShieldShaders[2];
			OverlayTimer = 999;
		}
		else
		{
			OverlayMaterial = mat;
			if ( OverlayTimer == time )
				OverlayTimer = time + 0.001;
			else
				OverlayTimer = time;
		}
        ClientOverlayTimer = OverlayTimer;
        ClientOverlayCounter = OverlayTimer;
        NetUpdateTime = Level.TimeSeconds - 1;
    }
}

// ----- shield control ----- //
function float GetShieldStrengthMax()
{
    return ShieldStrengthMax;
}

function float GetShieldStrength()
{
    // could return max if it's active right now, which make it unable to be recharged while it's on...
	if (ShieldStrength > 0)
		return ShieldStrength;
	return ArmorStrength;
}

//===========================================================================
// CanUseShield
//
// If we have the Shield Belt (i.e. any ShieldStrength value as opposed to ArmorStrength),
// any incoming armor is added to that or refused.
// Else, we increment ArmorStrength up to its max of 100.
//===========================================================================
function int CanUseShield(int ShieldAmount)
{
	ShieldStrength = Max(ShieldStrength,0);
	
	if (ShieldStrength > 0)
		return Min(ShieldStrengthMax - ShieldStrength, ShieldAmount);
	else return Min (100 - ArmorStrength, ShieldAmount);
}

function bool AddShieldStrength(int ShieldAmount)
{
	local int OldShieldStrength, OldArmorStrength;
	
	OldShieldStrength = ShieldStrength;
	OldArmorStrength = ArmorStrength;
	
	if (ShieldAmount == 150) //belt - wipe ArmorStrength and max ShieldStrength
	{
		ArmorStrength = 0;
		ShieldStrength = ShieldStrengthMax;
		SetOverlayMaterial(None, 0, true);
	}
	
	else
	{
		if (ShieldStrength > 0)
			ShieldStrength += CanUseShield(ShieldAmount);
		else ArmorStrength += CanUseShield(ShieldAmount);
	}
	
	return (ShieldStrength != OldShieldStrength) || (ArmorStrength != OldArmorStrength);
}

//===========================================================================
// ShieldAbsorb
//
// ArmorStrength is regular armor with 75% absorption
//===========================================================================
function int ShieldAbsorb( int dam )
{
	local float damage;

	damage = dam;
	
    if ( ShieldStrength == 0 && ArmorStrength == 0 )
        return damage;
    
	if (ShieldStrength > 0)
		PlaySound(sound'WeaponSounds.ArmorHit', SLOT_Pain,2*TransientSoundVolume,,400);
	else PlaySound(sound'WeaponSounds.ArmorHit', SLOT_Pain,2*TransientSoundVolume,,400);
	
	//can only have one or the other
    if ( ShieldStrength > 0 )
    {
		if (ShieldStrength >= Damage)
		{
			ShieldStrength -= Damage;
			if (ShieldStrength == 0)
				SetOverlayMaterial(None, 0, true);
			return 0;
		}
		
		else
		{
			Damage -= ShieldStrength;
			ShieldStrength = 0;
			SetOverlayMaterial(None, 0, true);
			return Damage;
		}
	}
	else if (ArmorStrength > 0)
	{
		if (ArmorStrength >=  0.75 * Damage)
		{
			ArmorStrength -= 0.75 * Damage;
			return 0.25 * Damage;
		}
		
		else
		{
			Damage -= 0.75 * ArmorStrength;
			ArmorStrength = 0;
			return Damage;
		}
	}
}

function TakeDamage(int Damage, Pawn instigatedBy, Vector hitlocation, Vector momentum, class<DamageType> damageType)
{
	local int actualDamage;
	local Controller Killer;

	if ( damagetype == None )
	{
		if ( InstigatedBy != None )
			warn("No damagetype for damage by "$instigatedby$" with weapon "$InstigatedBy.Weapon);
		DamageType = class'DamageType';
	}

	if ( Role < ROLE_Authority )
	{
		log(self$" client damage type "$damageType$" by "$instigatedBy);
		return;
	}

	if ( Health <= 0 )
		return;

	if ((instigatedBy == None || instigatedBy.Controller == None) && DamageType.default.bDelayedDamage && DelayedDamageInstigatorController != None)
		instigatedBy = DelayedDamageInstigatorController.Pawn;

	if ( (Physics == PHYS_None) && (DrivenVehicle == None) )
		SetMovementPhysics();
	if (Physics == PHYS_Walking && damageType.default.bExtraMomentumZ)
		momentum.Z = FMax(momentum.Z, 0.4 * VSize(momentum));
	if ( instigatedBy == self )
		momentum *= 0.6;
	momentum = momentum/Mass;

	if (Weapon != None)
		Weapon.AdjustPlayerDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if (DrivenVehicle != None)
        	DrivenVehicle.AdjustDriverDamage( Damage, InstigatedBy, HitLocation, Momentum, DamageType );
	if ( (InstigatedBy != None) && InstigatedBy.HasUDamage() )
		Damage *= 2;
	actualDamage = Level.Game.ReduceDamage(Damage, self, instigatedBy, HitLocation, Momentum, DamageType);
	if( DamageType.default.bArmorStops && (actualDamage > 0) )
		actualDamage = ShieldAbsorb(actualDamage);

	Health -= actualDamage;
	if ( HitLocation == vect(0,0,0) )
		HitLocation = Location;

	PlayHit(actualDamage,InstigatedBy, hitLocation, damageType, Momentum);

	if ( Health <= 0 )
	{
		// pawn died
		if ( DamageType.default.bCausedByWorld && (instigatedBy == None || instigatedBy == self) && LastHitBy != None )
			Killer = LastHitBy;
		else if ( instigatedBy != None )
			Killer = instigatedBy.GetKillerController();
		if ( Killer == None && DamageType.Default.bDelayedDamage )
			Killer = DelayedDamageInstigatorController;
		if ( bPhysicsAnimUpdate )
			TearOffMomentum = momentum;
		Died(Killer, damageType, HitLocation);
	}
	else
	{
		AddVelocity( momentum );
		if ( Controller != None )
			Controller.NotifyTakeHit(instigatedBy, HitLocation, actualDamage, DamageType, Momentum);
		if ( instigatedBy != None && instigatedBy != self )
			LastHitBy = instigatedBy.Controller;
		if (PlayerController(Controller) != None)
		{
            HandleViewFlash(Damage);
		}
	}
	MakeNoise(1.0);
}

function HandleViewFlash(int damage)
{
    local int rnd;

    rnd = FClamp(Damage, 20, 60);

	if (ShieldStrength > 0)
        PlayerController(Controller).ClientFlash( -0.019 * rnd, ShieldFlashV);
    else 
		PlayerController(Controller).ClientFlash( -0.019 * rnd, rnd * BloodFlashV);       
}

function PlayTeleportEffect( bool bOut, bool bSound)
{
	if ( !bSpawnIn && (Level.TimeSeconds - SpawnTime < DeathMatch(Level.Game).SpawnProtectionTime) )
	{
		bSpawnIn = true;
		SetOverlayMaterial( ShieldHitMat, DeathMatch(Level.Game).SpawnProtectionTime, false );
	    if ( (PlayerReplicationInfo == None) || (PlayerReplicationInfo.Team == None) || (PlayerReplicationInfo.Team.TeamIndex == 1) )
		    Spawn(TransEffects[1],,,Location + CollisionHeight * vect(0,0,0.75));
	    else
		    Spawn(TransEffects[0],,,Location + CollisionHeight * vect(0,0,0.75));
	}
	else if ( bOut )
		DoTranslocateOut(Location);
	else if ( (PlayerReplicationInfo == None) || (PlayerReplicationInfo.Team == None) || (PlayerReplicationInfo.Team.TeamIndex == 1) )
		Spawn(TransEffects[1],self,,Location + CollisionHeight * vect(0,0,0.75));
	else
		Spawn(TransEffects[0],self,,Location + CollisionHeight * vect(0,0,0.75));
    Super.PlayTeleportEffect( bOut, bSound );
}

function DoTranslocateOut(Vector PrevLocation)
{
	if ( (PlayerReplicationInfo == None) || (PlayerReplicationInfo.Team == None) || (PlayerReplicationInfo.Team.TeamIndex == 1) )
		Spawn(TransOutEffect[1], self,, PrevLocation, rotator(Location - PrevLocation));
	else
		Spawn(TransOutEffect[0], self,, PrevLocation, rotator(Location - PrevLocation));
}

/*
as mentioned at the top of this file, most of the properties that affect movement here
have values that are 1.1x those of UT99, due to the 12.5% scaling adjustment of UT2004

this is considered the best compromise given that the majority of maps are designed 
for UT2004 scale, but is not strict UT99

ut99 collision is height 39, radius 17.
ut2341 uses height 44 and radius 20 
(bigger than expected due to eye height and expansive player models/animations)

"hardcore" mode for ut99, which is the default, institutes the following changes:

+10% game speed (NO EFFECT - UT2004 already has 10% game speed, check LevelInfo.TimeDilation)
+10% jump height

so jump height is 325 * 1.125 (scale) * 1.1 (hardcore bonus) = 402
*/

defaultproperties
{
    BloodFlashV=(X=26.5,Y=4.5,Z=4.5)
    ShieldFlashV=(X=400.000000,Y=400.000000,Z=400.000000)

    ShieldShaders(0)=Shader'UT2341Weapons_Tex.General.ShieldBeltShaderRed'
    ShieldShaders(1)=Shader'UT2341Weapons_Tex.General.ShieldBeltShaderBlue'
    ShieldShaders(2)=Shader'UT2341Weapons_Tex.General.ShieldBeltShaderGold'
    UDamageSound=Sound'UT2341Weapons_Sounds.General.AmpFire'
    TransEffects(0)=Class'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed'
    TransEffects(1)=Class'UT2341Weapons_BETA3.FX_UT2341WarpEffectBlue'
    AccelRate=2252.000000
    JumpZ=402.000000
    EyeHeight=30.000000
    DodgeSpeedZ=180.000000
    CollisionRadius=20.000000
     Begin Object Class=KarmaParamsSkel Name=HeavyPawnKParams
         KConvulseSpacing=(Max=2.200000)
         KLinearDamping=0.150000
         KAngularDamping=0.010000
         KBuoyancy=1.000000
         KStartEnabled=True
         KVelDropBelowThreshold=50.000000
         bHighDetailOnly=False
         KFriction=2.500000
         KRestitution=0.700000
         KImpactThreshold=500.000000
     End Object
     KParams=KarmaParamsSkel'UT2341Weapons_BETA3.UT2341Pawn.HeavyPawnKParams'

}
