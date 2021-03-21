class UT2341MinigunFire extends MinigunFire;

var float WindDownModifier;
var() class<Emitter> NewFlashClass;
var Emitter NewFlashEmitter;

var Sound WindUpSound;

function InitEffects()
{
    // don't even spawn on server
    if ( (Level.NetMode == NM_DedicatedServer) || (AIController(Instigator.Controller) != None) )
		return;
    if ( (NewFlashClass != None) && ((NewFlashEmitter == None) || NewFlashEmitter.bDeleteMe) )
    {
        NewFlashEmitter = Weapon.Spawn(NewFlashClass);
		Weapon.AttachToBone(NewFlashEmitter, 'Flash');
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
    local rotator r;

    r.Roll = Rand(65535);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
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

auto state Idle
{
	function bool IsIdle()
	{
		return true;
	}

    function BeginState()
    {
        PlayAmbientSound(None);
        StopRolling();
    }

    function EndState()
    {
        PlayAmbientSound(WindUpSound);
    }

    function StartFiring()
    {
        RollSpeed = 0;
		FireTime = (RollSpeed/MaxRollSpeed) * WindUpTime;
        GotoState('WindUp');
    }
}

state WindUp
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime += dt;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if ( !bIsFiring )
        {
			GotoState('WindDown');
			return;
		}

        if (RollSpeed >= MaxRollSpeed)
        {
            RollSpeed = MaxRollSpeed;
            FireTime = WindUpTime;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
			GotoState('FireLoop');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StopFiring()
    {
        GotoState('WindDown');
    }
}

state WindDown
{
    function BeginState()
    {
        ClientPlayForceFeedback(WindingForce);  // jdf
    }

    function EndState()
    {
        if (ThisModeNum == 0)
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(1).bIsFiring )
                StopForceFeedback(WindingForce);
        }
        else
        {
            if ( (Weapon == None) || !Weapon.GetFireMode(0).bIsFiring )
                StopForceFeedback(WindingForce);
        }
    }

    function ModeTick(float dt)
    {
        FireTime -= dt / WindDownModifier;
        RollSpeed = (FireTime/WindUpTime) * MaxRollSpeed;

        if (RollSpeed <= 0.f)
        {
            RollSpeed = 0.f;
            FireTime = 0.f;
            Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
            GotoState('Idle');
            return;
        }

        Gun.UpdateRoll(dt, RollSpeed, ThisModeNum);
    }

    function StartFiring()
    {
        GotoState('WindUp');
    }
}

defaultproperties
{
     WindDownModifier=12.000000
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_EnforcerMuzFlash'
     WindUpSound=Sound'UT2341Weapons_Sounds.Minigun.M2WindUp'
     BarrelRotationsPerSec=1.250000
     WindingSound=Sound'UT2341Weapons_Sounds.Minigun.M2WindDown'
     FiringSound=Sound'UT2341Weapons_Sounds.Minigun.M2RegFire'
     WindUpTime=0.050000
     DamageType=Class'UT2341Weapons_BETA3.DamType_MinigunBullet'
     DamageMin=15
     DamageMax=21
     PreFireTime=0.100000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341MinigunAmmo'
     Spread=0.050000
}
