class UT2341PulseAltFire extends WeaponFire;

var UT2341PulseBeamEffect			Beam;
var class<UT2341PulseBeamEffect>	BeamEffectClass;

var() class<DamageType> DamageType;
var() int Damage;
var() float MomentumTransfer;

var() float TraceRange;

var	float	UpTime;

var		bool bDoHit;
var()	bool bFeedbackDeath;
var		bool bInitAimError;
var		bool bLinkFeedbackPlaying;
var		bool bStartFire;
var byte	LinkVolume;
var byte	SentLinkVolume;

var rotator DesiredAimError, CurrentAimError;

var Sound BeamSound;

var() class<Emitter> PulseFlashClass;
var Emitter PulseFlashEmitter;

simulated function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (PulseFlashClass != None) && ((PulseFlashEmitter == None) || PulseFlashEmitter.bDeleteMe) )
    {
        PulseFlashEmitter = Weapon.Spawn(PulseFlashClass);
		Weapon.AttachToBone(PulseFlashEmitter, 'tip');
    }
    if ( (SmokeEmitterClass != None) && ((SmokeEmitter == None) || SmokeEmitter.bDeleteMe) )
    {
        SmokeEmitter = Weapon.Spawn(SmokeEmitterClass);
    }
}

function DrawMuzzleFlash(Canvas Canvas)
{
    // Draw smoke first
    if (SmokeEmitter != None && SmokeEmitter.Base != Weapon)
    {
        SmokeEmitter.SetLocation( Weapon.GetEffectStart() );
        Canvas.DrawActor( SmokeEmitter, false, false, Weapon.DisplayFOV );
    }

    if (PulseFlashEmitter != None && PulseFlashEmitter.Base != Weapon)
    {
        PulseFlashEmitter.SetLocation( Weapon.GetEffectStart() );
        Canvas.DrawActor( PulseFlashEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    if (PulseFlashEmitter != None)
        PulseFlashEmitter.Trigger(Weapon, Instigator);
}

simulated function DestroyEffects()
{
    if (PulseFlashEmitter != None)
        PulseFlashEmitter.Destroy();

    if (SmokeEmitter != None)
        SmokeEmitter.Destroy();

    if ( Level.NetMode != NM_Client )
    {
        if ( Beam != None )
            Beam.Destroy();
    }
}

simulated function bool myHasAmmo( )
{
	return (Weapon.AmmoAmount(ThisModeNum) >= AmmoPerFire);
}

simulated function Rotator	GetPlayerAim( vector StartTrace, float InAimError )
{
	return AdjustAim(StartTrace, InAimError);
}

simulated function ModeTick(float dt)
{
	local Vector StartTrace, EndTrace, X, Y, Z;
	local Vector HitLocation, HitNormal, EndEffect;
	local Actor Other;
	local Rotator Aim;
	local float Step;
	local DestroyableObjective HealObjective;
	local int AdjustedDamage;
	local UT2341PulseBeamEffect LB;

    if ( !bIsFiring )
    {
		bInitAimError = true;
        return;
    }

    if ( myHasAmmo() && ((UpTime > 0.0) || (Instigator.Role < ROLE_Authority)) )
    {
        UpTime -= dt;

		// the to-hit trace always starts right in front of the eye
		Weapon.GetViewAxes(X, Y, Z);
		StartTrace = GetFireStart( X, Y, Z);

        if ( Instigator.Role < ROLE_Authority )
        {
			if ( Beam == None )
				ForEach Weapon.DynamicActors(class'UT2341PulseBeamEffect', LB )
					if ( !LB.bDeleteMe && (LB.Instigator != None) && (LB.Instigator == Instigator) )
					{
						Beam = LB;
						break;
					}
		}

        if ( Instigator.Role == ROLE_Authority )
		{
		    if ( bDoHit )
			   Weapon.ConsumeAmmo(ThisModeNum, AmmoPerFire);
		}

		if ( Bot(Instigator.Controller) != None )
		{
			if ( bInitAimError )
			{
				CurrentAimError = AdjustAim(StartTrace, AimError);
				bInitAimError = false;
			}
			else
			{
				BoundError();
				CurrentAimError.Yaw = CurrentAimError.Yaw + Instigator.Rotation.Yaw;
			}

			// smooth aim error changes
			Step = 7500.0 * dt;
			if ( DesiredAimError.Yaw ClockWiseFrom CurrentAimError.Yaw )
			{
				CurrentAimError.Yaw += Step;
				if ( !(DesiredAimError.Yaw ClockWiseFrom CurrentAimError.Yaw) )
				{
					CurrentAimError.Yaw = DesiredAimError.Yaw;
					DesiredAimError = AdjustAim(StartTrace, AimError);
				}
			}
			else
			{
				CurrentAimError.Yaw -= Step;
				if ( DesiredAimError.Yaw ClockWiseFrom CurrentAimError.Yaw )
				{
					CurrentAimError.Yaw = DesiredAimError.Yaw;
					DesiredAimError = AdjustAim(StartTrace, AimError);
				}
			}
			CurrentAimError.Yaw = CurrentAimError.Yaw - Instigator.Rotation.Yaw;
			if ( BoundError() )
				DesiredAimError = AdjustAim(StartTrace, AimError);
			CurrentAimError.Yaw = CurrentAimError.Yaw + Instigator.Rotation.Yaw;

			if ( Instigator.Controller.Target == None )
				Aim = Rotator(Instigator.Controller.FocalPoint - StartTrace);
			else
				Aim = Rotator(Instigator.Controller.Target.Location - StartTrace);

			Aim.Yaw = CurrentAimError.Yaw;

			// save difference
			CurrentAimError.Yaw = CurrentAimError.Yaw - Instigator.Rotation.Yaw;
		}
		else
			Aim = GetPlayerAim(StartTrace, AimError);

		X = Vector(Aim);
		EndTrace = StartTrace + TraceRange * X;

        Other = Weapon.Trace(HitLocation, HitNormal, EndTrace, StartTrace, true);
        if ( Other != None && Other != Instigator )
			EndEffect = HitLocation - X * 15;
		else
			EndEffect = EndTrace- X * 15;

		if ( Beam != None )
			Beam.EndEffect = EndEffect;
			
		if (Instigator.Role < ROLE_Authority)
			return;

        if ( Other != None && Other != Instigator )
        {
			// beam is updated every frame, but damage is only done based on the firing rate
			if ( bDoHit )
			{
				Instigator.MakeNoise(1.0);

				AdjustedDamage = Damage * 1.5;

				if ( !Other.bWorldGeometry )
				{
					HealObjective = DestroyableObjective(Other);
					if ( HealObjective == None )
						HealObjective = DestroyableObjective(Other.Owner);
					if ( HealObjective != None)
					{
						if ( HealObjective.TeamLink(Instigator.GetTeamNum()) )
						{
							if (!HealObjective.HealDamage(AdjustedDamage, Instigator.Controller, DamageType))
								UT2341PulseGun(Weapon).ConsumeAmmo(ThisModeNum, -AmmoPerFire);
						}
					}
					else if (Vehicle(Other) != None)
					{
						if(!Vehicle(Other).HealDamage(AdjustedDamage, Instigator.Controller, DamageType))
							UT2341PulseGun(Weapon).ConsumeAmmo(ThisModeNum, -AmmoPerFire);
					}
					else Other.TakeDamage(Damage, Instigator, HitLocation, MomentumTransfer*X, DamageType);
				}
			}
		}

		// beam effect is created and destroyed when firing starts and stops
		if ( (Beam == None) && bIsFiring )
		{
			Beam = Weapon.Spawn( BeamEffectClass, Instigator );
			// vary link volume to make sure it gets replicated (in case owning player changed it client side)
			if ( SentLinkVolume == Default.LinkVolume )
				SentLinkVolume = Default.LinkVolume + 1;
			else
				SentLinkVolume = Default.LinkVolume;
		}

		if ( Beam != None )
		{
			Instigator.AmbientSound = BeamSound;
			Instigator.SoundVolume = SentLinkVolume;
			Beam.bHitSomething = (Other != None);
			Beam.EndEffect = EndEffect;
		}
    }
    else
        StopFiring();

    bStartFire = false;
    bDoHit = false;
}

function bool BoundError()
{
	CurrentAimError.Yaw = CurrentAimError.Yaw & 65535;
	if ( CurrentAimError.Yaw > 2048 )
	{
		if ( CurrentAimError.Yaw < 32768 )
		{
			CurrentAimError.Yaw = 2048;
			return true;
		}
		else if ( CurrentAimError.Yaw < 63487 )
		{
			CurrentAimError.Yaw = 63487;
			return true;
		}
	}
	return false;
}

event ModeDoFire()
{
	Load = 0; //don't use ammo here - it will be consumed in ModeTick() where it's sync'ed with damage dealing
	Super.ModeDoFire();
}

function DoFireEffect()
{
    bDoHit = true;
    UpTime = FireRate+0.1;
}

function StopFiring()
{
	if (Instigator.AmbientSound == BeamSound)
	{
		Instigator.AmbientSound = None;
		Instigator.SoundVolume = Instigator.Default.SoundVolume;
	}
    if (Beam != None)
    {
        Beam.Destroy();
        Beam = None;
    }
    bStartFire = true;
    bFeedbackDeath = false;
}

simulated function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Instigator.Location + Instigator.EyePosition() + X*Instigator.CollisionRadius;
}

function StartBerserk()
{
	if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
 		return;

	Damage = default.Damage * 1.33;
}

function StopBerserk()
{
	if ( (Level.GRI != None) && (Level.GRI.WeaponBerserk > 1.0) )
 		return;

	Damage = default.Damage;
}

function PlayFiring()
{
	if ( Weapon.Mesh != None )
	{
		if (FireCount == 0)
			Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
	}
    Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

defaultproperties
{
     BeamEffectClass=Class'UT2341Weapons_BETA3.UT2341PulseBeamEffect'
     DamageType=Class'UT2341Weapons_BETA3.DamType_Pulse'
     Damage=10
     MomentumTransfer=2000.000000
     TraceRange=1100.000000
     bInitAimError=True
     LinkVolume=240
     BeamSound=Sound'UT2341Weapons_Sounds.PulseGun.PulseBolt'
     PulseFlashClass=Class'UT2341Weapons_BETA3.FX_PulseMuzFlash'
     bPawnRapidFireAnim=True
     FireAnim="FireAltStart"
     FireLoopAnim="FireAltLoop"
     FireEndAnim="FireAltEnd"
     NoAmmoSound=ProceduralSound'WeaponSounds.PReload5.P1Reload5'
     FireRate=0.100000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341PulseAmmo'
     AmmoPerFire=1
     ShakeRotMag=(Z=60.000000)
     ShakeRotRate=(Z=4000.000000)
     ShakeRotTime=6.000000
     ShakeOffsetMag=(Y=1.000000,Z=1.000000)
     ShakeOffsetRate=(X=1000.000000,Y=1000.000000,Z=1000.000000)
     ShakeOffsetTime=3.000000
     BotRefireRate=0.990000
     WarnTargetPct=0.200000
}
