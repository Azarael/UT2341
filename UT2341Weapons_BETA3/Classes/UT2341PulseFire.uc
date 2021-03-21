class UT2341PulseFire extends ProjectileFire;

var sound WindDownSound;

var() class<Emitter> NewFlashClass;
var Emitter NewFlashEmitter;

simulated function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (NewFlashClass != None) && ((NewFlashEmitter == None) || NewFlashEmitter.bDeleteMe) )
    {
        NewFlashEmitter = Weapon.Spawn(NewFlashClass);
		Weapon.AttachToBone(NewFlashEmitter, 'tip');
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

    if (NewFlashEmitter != None && NewFlashEmitter.Base != Weapon)
    {
        NewFlashEmitter.SetLocation( Weapon.GetEffectStart() );
        Canvas.DrawActor( NewFlashEmitter, false, false, Weapon.DisplayFOV );
    }
}

function FlashMuzzleFlash()
{
    if (NewFlashEmitter != None)
        NewFlashEmitter.Trigger(Weapon, Instigator);
}

simulated function DestroyEffects()
{
    if (NewFlashEmitter != None)
        NewFlashEmitter.Destroy();

    if (SmokeEmitter != None)
        SmokeEmitter.Destroy();
}

function PlayFiring()
{
	if ( Weapon.Mesh != None )
	{
		if ( FireCount > 0 )
		{
			if ( Weapon.HasAnim(FireLoopAnim) )
			{
				Weapon.PlayAnim(FireLoopAnim, FireLoopAnimRate, 0.0);
			}
			else
			{
				Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			}
		}
		else
		{
			Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
			UT2341PulseGun(Weapon).BarrelState = 1;
		}
	}
	
	Instigator.AmbientSound = FireSound;
	Instigator.SoundVolume = 254;
   // Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,Default.FireAnimRate/FireAnimRate,false);
    ClientPlayForceFeedback(FireForce);  // jdf

    FireCount++;
}

function ServerPlayFiring()
{
	Instigator.AmbientSound = FireSound;
	Instigator.SoundVolume = 254;
}

simulated function bool AllowFire()
{
    return ( Weapon.AmmoAmount(ThisModeNum) >= 1 );
}

function StopFiring()
{
	Weapon.PlaySound(WindDownSound,SLOT_Interact,TransientSoundVolume,,TransientSoundRadius,,false);
	Instigator.AmbientSound=None;
	Instigator.SoundVolume = Instigator.Default.SoundVolume;
	UT2341PulseGun(Weapon).BarrelState = 2;
}

defaultproperties
{
     WindDownSound=Sound'UT2341Weapons_Sounds.PulseGun.PulseDown'
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_PulseMuzFlash'
     ProjSpawnOffset=(X=25.000000,Y=8.000000,Z=-3.000000)
     FireAnimRate=1.500000
     FireLoopAnimRate=1.500000
     FireSound=Sound'UT2341Weapons_Sounds.PulseGun.PulseFire'
     FireForce="TranslocatorFire"
     FireRate=0.180000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341PulseAmmo'
     AmmoPerFire=2
     ShakeRotMag=(X=40.000000)
     ShakeRotRate=(X=2000.000000)
     ShakeRotTime=2.000000
     ShakeOffsetMag=(Y=1.000000)
     ShakeOffsetRate=(Y=-2000.000000)
     ShakeOffsetTime=4.000000
     ProjectileClass=Class'UT2341Weapons_BETA3.UT2341PulseProjectile'
     BotRefireRate=0.990000
     WarnTargetPct=0.100000
}
