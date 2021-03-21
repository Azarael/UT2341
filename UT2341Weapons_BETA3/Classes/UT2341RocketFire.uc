//===========================================================================
// UT2341 Rocket Fire.
//
// Standard RL fire code, cleaned up a bit and with support for any given max number of rockets.
//===========================================================================
class UT2341RocketFire extends ProjectileFire;

var() float TightSpread, LooseSpread;
var int MaxLoad;
var byte StartRocket;

simulated function bool AllowFire()
{
	return Super.AllowFire();
}

simulated function PreBeginPlay()
{
	MaxHoldTime = FireRate * (MaxLoad - 1) + 0.5;
}

event ModeHoldFire()
{
	StartRocket = UT2341RocketLauncher(Weapon).NextBarrel - 1;
	if (StartRocket > 5)
		StartRocket = 5;
    if (Instigator.IsLocallyControlled())
		PlayStartHold();
	else
		ServerPlayLoading();
}

simulated function ServerPlayLoading()
{
	UT2341RocketLauncher(Weapon).PlayOwnedSound(Sound'UT2341Weapons_Sounds.RocketLauncher.Loading', SLOT_None,,,,,false);
}

function PlayFireEnd()
{
}

function PlayStartHold()
{
	//Loading, empty
    UT2341RocketLauncher(Weapon).PlayLoad(true);
}

function PlayFiring()
{
    if (Load > 4.0)
        FireAnim = 'Fire3';
	else if (Load > 1.0)
		FireAnim = 'Fire2';
    else
        FireAnim = 'Fire';
    Super.PlayFiring();
	//If on the max load, load new rocket - because the weapon won't be in the process of loading
    UT2341RocketLauncher(Weapon).PlayLoad((Load == MaxLoad));
	UT2341RocketLauncher(Weapon).EmptyBarrels(StartRocket, Load);
	Weapon.OutOfAmmo();
}

event ModeDoFire()
{
    if ( UT2341RocketLauncher(Weapon).bTightSpread || ((Bot(Instigator.Controller) != None) && (FRand() < 0.65)) )
    {
        Spread = TightSpread;
		SpreadStyle = SS_Ring;
    }
    else
    {
		SpreadStyle = SS_Line;
        Spread = LooseSpread;
    }
    UT2341RocketLauncher(Weapon).bTightSpread = false;
    Super.ModeDoFire();
	NextFireTime = FMax(NextFireTime, Level.TimeSeconds + FireRate);
}

function DoFireEffect()
{
    local Vector StartProj, StartTrace, X,Y,Z;
    local Rotator Aim;
    local Vector HitLocation, HitNormal,FireLocation;
    local Actor Other;
    local int p,SpawnCount;
	
	if ( (SpreadStyle == SS_Line) || (Load < 2) )
	{
		Super.DoFireEffect();
		return;
	}
	
    Instigator.MakeNoise(1.0);
    Weapon.GetViewAxes(X,Y,Z);

    StartTrace = Instigator.Location + Instigator.EyePosition();
    StartProj = StartTrace + X*ProjSpawnOffset.X + Z*ProjSpawnOffset.Z;
    if ( !Weapon.WeaponCentered() )
	    StartProj = StartProj + Weapon.Hand * Y*ProjSpawnOffset.Y;

    // check if projectile would spawn through a wall and adjust start location accordingly
    Other = Weapon.Trace(HitLocation, HitNormal, StartProj, StartTrace, false);
    if (Other != None)
    {
        StartProj = HitLocation;
    }
    
    Aim = AdjustAim(StartProj, AimError);

    SpawnCount = Max(1, int(Load));

    for ( p=0; p<SpawnCount; p++ )
    {
 		Firelocation = StartProj - 2*((Sin(p*2*PI/MaxLoad)*8 - 7)*Y - (Cos(p*2*PI/MaxLoad)*8 - 7)*Z) - X * 8 * FRand();
        SpawnProjectile(FireLocation, Aim);
	}
}

function ModeTick(float dt)
{
    // auto fire if loaded last rocket
	// bNowWaiting is true if we're waiting for the altfire to be released after firing.
    if (HoldTime > 0.0 && Load >= Weapon.AmmoAmount(ThisModeNum) && !bNowWaiting)
    {
        bIsFiring = false;
		//NextFireTime=Level.TimeSeconds + FireRate;
    }

    Super.ModeTick(dt);
	
	if (Load > 0 && Load < MaxLoad)
	{
		//Rewrite this for multi-load.
		if (HoldTime >= FireRate * Load)
		{
			if (Load < (MaxLoad-1))
			{
				if (Instigator.IsLocallyControlled())
					UT2341RocketLauncher(Weapon).PlayLoad(true);
				else
					ServerPlayLoading();
			}
			Load = Load + 1.0;
		}
	}
}

function InitEffects()
{
    Super.InitEffects();
    if ( FlashEmitter != None )
		Weapon.AttachToBone(FlashEmitter, 'tip');
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local Projectile p;    
    
    p = UT2341RocketLauncher(Weapon).SpawnProjectile(Start, Dir);
    if ( P != None )
		p.Damage *= DamageAtten;
    return p;
}

defaultproperties
{
     TightSpread=300.000000
     LooseSpread=1000.000000
     MaxLoad=6
     ProjSpawnOffset=(X=25.000000,Y=6.000000,Z=-6.000000)
     bSplashDamage=True
     bSplashJump=True
     bRecommendSplashDamage=True
     bFireOnRelease=True
     MaxHoldTime=2.300000
     FireAnim="AltFire"
     TweenTime=0.000000
     FireSound=Sound'UT2341Weapons_Sounds.RocketLauncher.Ignite'
     FireForce="RocketLauncherFire"
     FireRate=0.950000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341RocketAmmo'
     AmmoPerFire=1
     ShakeRotTime=2.000000
     ShakeOffsetMag=(X=-20.000000)
     ShakeOffsetRate=(X=-1000.000000)
     ShakeOffsetTime=2.000000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341RocketProj'
     BotRefireRate=0.600000
     WarnTargetPct=0.900000
     SpreadStyle=SS_Line
}
