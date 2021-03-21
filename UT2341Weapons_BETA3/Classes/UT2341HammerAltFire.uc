class UT2341HammerAltFire extends WeaponFire;

var class<DamageType> DamageType;       // weapon fire damage type (no projectile, so we put this here)
var float HammerLongRange;                  // from pawn centre
var float Force;          					 // force to other players
var float Damage;
var float SelfDamageScale;              // %damage to self (when shielding a wall)

simulated function InitEffects()
{
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

	Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

	StartTrace = Instigator.Location + Instigator.EyePosition();
	Aim = AdjustAim(StartTrace, AimError);
	EndTrace = StartTrace + HammerLongRange * Vector(Aim);
	Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
	
    if ( Other != None && Other != Instigator )
    {
		if ( Pawn(Other) != None  || (Decoration(Other) != None && Decoration(Other).bDamageable) || TranslocatorBeacon(Other) != None)
		{
			if (Pawn(Other) == None || Pawn(Other).Controller == None || !Pawn(Other).Controller.SameTeamAs(Instigator.Controller))
				Other.TakeDamage(Damage , Instigator, HitLocation, Force*(X+vect(0,0,0.5)), DamageType);
		}
		else
		{
			if ( xPawn(Instigator).bBerserk )
				Force *= 2.0;
			Instigator.TakeDamage(SelfDamageScale*Damage, Instigator, HitLocation, -Force*X, DamageType);
			if ( DestroyableObjective(Other) != None )
		      	Other.TakeDamage(Damage, Instigator, HitLocation, Force*(X+vect(0,0,0.5)), DamageType);
		}
    }
}

defaultproperties
{
     DamageType=Class'UT2341Weapons_BETA3.DamType_Hammer'
     HammerLongRange=200.000000
     Force=35000.000000
     Damage=30.000000
     SelfDamageScale=1.200000
     TransientSoundVolume=1.000000
     FireLoopAnim=
     FireEndAnim=
     TweenTime=0.000000
     FireSound=Sound'UT2341Weapons_Sounds.Hammer.ImpactAltFire'
     FireForce="ShieldGunFire"
     FireRate=0.810000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341HammerAmmo'
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     BotRefireRate=1.000000
     WarnTargetPct=0.100000
     FlashEmitterClass=Class'XEffects.ForceRingA'
}
