class UT2341HammerFire extends WeaponFire;

var class<DamageType> DamageType;       // weapon fire damage type (no projectile, so we put this here)
var float AutoCheckRange, HammerLongRange;                  // from pawn centre
var float Force;          					 // force to other players
var float Damage;
var float SelfDamageScale;              // %damage to self (when shielding a wall)
var float MinSelfDamage;
var Sound ChargingSound;                // charging sound
var float AutoFireTestFreq;
var float FullyChargedTime;				// held for this long will do max damage
var bool bAutoRelease;
var bool bStartedChargingForce;
var	byte  ChargingSoundVolume;
var Pawn AutoHitPawn;
var float AutoHitTime;

var bool bCheckingHit;

var sound PreFireSound;

// jdf ---
var String ChargingForce;
// --- jdf

simulated function InitEffects()
{
    bStartedChargingForce = false;  // jdf
}

function Rotator AdjustAim(Vector Start, float InAimError)
{
	local rotator Aim, EnemyAim;

	if ( AIController(Instigator.Controller) != None )
	{
		Aim = Instigator.Rotation;
		if ( Instigator.Controller.Enemy != None )
		{
			EnemyAim = rotator(Instigator.Controller.Enemy.Location - Start);
			Aim.Pitch = EnemyAim.Pitch;
		}
		return Aim;
	}
	else
		return super.AdjustAim(Start,InAimError);
}

function DoFireEffect()
{
	local Vector HitLocation, HitNormal, StartTrace, EndTrace, X,Y,Z;
    local Rotator Aim;
	local Actor Other;
    local float Scale;

	Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);
	bAutoRelease = false;

	if ( (AutoHitPawn != None) && (Level.TimeSeconds - AutoHitTime < 0.15) )
	{
		Other = AutoHitPawn;
		HitLocation = Other.Location;
		AutoHitPawn = None;
	}
	else
	{
		StartTrace = Instigator.Location + Instigator.EyePosition();
		Aim = AdjustAim(StartTrace, AimError);
		EndTrace = StartTrace + HammerLongRange * Vector(Aim);
		Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
	}

    Scale = FMin(HoldTime, FullyChargedTime);
	
    Instigator.AmbientSound = None;
	Instigator.SoundVolume = Instigator.Default.SoundVolume;

    if ( Other != None && Other != Instigator )
    {
		if ( Pawn(Other) != None  || (Decoration(Other) != None && Decoration(Other).bDamageable) || TranslocatorBeacon(Other) != None)
		{
			if (Pawn(Other) == None || Pawn(Other).Controller == None || !Pawn(Other).Controller.SameTeamAs(Instigator.Controller))
				Other.TakeDamage(Damage * Scale, Instigator, HitLocation, Scale*Force*(X+vect(0,0,0.5)), DamageType);
		}
		else
		{
			Scale = FMax(Scale, 1);
			if ( xPawn(Instigator).bBerserk )
				Force *= 2.0;
			Instigator.TakeDamage(SelfDamageScale*Damage, Instigator, HitLocation, -Scale*Force*X, DamageType);
			if ( DestroyableObjective(Other) != None )
		      	Other.TakeDamage(Damage*Scale, Instigator, HitLocation, Scale*Force*(X+vect(0,0,0.5)), DamageType);
		}
    }
	
	UT2341Hammer(Weapon).ClientForceRelease(ThisModeNum);

	bCheckingHit=False;
    SetTimer(0, false);
}

function ModeHoldFire()
{
	bCheckingHit = False;
    SetTimer(1.33, false);
	Weapon.PlayAnim(PreFireAnim);
	Weapon.PlayOwnedSound(PreFireSound, SLOT_Interact, 1);
}

function bool IsFiring()
{
	return ( bIsFiring || bAutoRelease );
}

function Timer()
{
    local Actor Other;
    local Vector HitLocation, HitNormal, StartTrace, EndTrace;
    local Rotator Aim;
    local float ChargeScale;

    if (HoldTime > 0.0 && !bNowWaiting)
    {
	    StartTrace = Instigator.Location;
		Aim = AdjustAim(StartTrace, AimError);
	    EndTrace = StartTrace + AutoCheckRange * Vector(Aim);

        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
        if ( (Pawn(Other) != None) && (Other != Instigator) )
        {
			bAutoRelease = true;
            bIsFiring = false;
            Instigator.AmbientSound = None;
			Instigator.SoundVolume = Instigator.Default.SoundVolume;
            AutoHitPawn = Pawn(Other);
            AutoHitTime = Level.TimeSeconds;
        }
        else
        {
            ChargeScale = FMin(HoldTime, FullyChargedTime);
			
            if (!bStartedChargingForce)
            {
                bStartedChargingForce = true;
                ClientPlayForceFeedback( ChargingForce );
            }
        }
    }
    else
    {
		if ( Instigator.AmbientSound == ChargingSound )
		{	
			Instigator.AmbientSound = None;
			Instigator.SoundVolume = Instigator.Default.SoundVolume;
		}

        SetTimer(0, false);
    }
	
	if (!bCheckingHit)
	{
		bCheckingHit=True;
		SetTimer(AutoFireTestFreq, true);
	}
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location;
}

function StartBerserk()
{
	if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
		return;
    MaxHoldTime = default.MaxHoldTime * 0.75;
    FullyChargedTime = default.FullyChargedTime * 0.75;
}

function StopBerserk()
{
	if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
		return;
    MaxHoldTime = default.MaxHoldTime;
    FullyChargedTime = default.FullyChargedTime;
}

function StartSuperBerserk()
{
    MaxHoldTime = default.MaxHoldTime/Level.GRI.WeaponBerserk;
    FullyChargedTime = default.FullyChargedTime/Level.GRI.WeaponBerserk;
    Damage = Default.Damage * Level.GRI.WeaponBerserk;
}

// jdf ---
function PlayFiring()
{
    bStartedChargingForce = false;
    StopForceFeedback(ChargingForce);
    Super.PlayFiring();
}
// --- jdf

function PlayPreFire();

defaultproperties
{
     DamageType=Class'UT2341Weapons_BETA3.DamType_Hammer'
     AutoCheckRange=82.000000
     HammerLongRange=120.000000
     Force=79000.000000
     Damage=90.000000
     SelfDamageScale=0.600000
     ChargingSound=Sound'UT2341Weapons_Sounds.Hammer.ImpactLoop'
     AutoFireTestFreq=0.150000
     FullyChargedTime=1.500000
     ChargingSoundVolume=200
     PreFireSound=Sound'UT2341Weapons_Sounds.Hammer.ImpactFireStart'
     ChargingForce="shieldgun_charge"
     bFireOnRelease=True
     bWaitForRelease=True
     TransientSoundVolume=1.000000
     PreFireAnim="FireLoad"
     FireLoopAnim=
     FireEndAnim=
     PreFireAnimRate=2.000000
     TweenTime=0.000000
     FireSound=Sound'UT2341Weapons_Sounds.Hammer.ImpactFireRelease'
     FireForce="ShieldGunFire"
     FireRate=0.600000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341HammerAmmo'
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=1.000000
     WarnTargetPct=0.100000
     FlashEmitterClass=Class'XEffects.ForceRingA'
}
