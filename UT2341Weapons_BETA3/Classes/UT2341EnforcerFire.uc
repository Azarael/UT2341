/*************************************************************
*
*
*
*************************************************************/
class UT2341EnforcerFire extends InstantFire;

var() class<Emitter> NewFlashClass;
var Emitter NewFlashEmitter;

function InitEffects()
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
    local rotator r;

    r.Roll = Rand(65535);
    Weapon.SetBoneRotation('Bone_Flash', r, 0, 1.f);
    if (NewFlashEmitter != None)
        NewFlashEmitter.Trigger(Weapon, Instigator);
}

function DoFireEffect()
{
	local Vector StartTrace;
	local Rotator R, Aim;
	local Vector X,Y,Z;

	Instigator.MakeNoise(1.0);

	StartTrace = Instigator.Location + Instigator.EyePosition();

	Aim = AdjustAim(StartTrace, AimError);
	Weapon.GetViewAxes(X, Y, Z);
	//R = rotator(vector(Aim) + VRand()*FRand()*Spread);
	//UT99 Enforcer spread implementation - Spread == UT99's Accuracy value/10
	if (UT2341Enforcer(Weapon).GunState != GS_Single)
		Spread = 0.075;
	R = rotator(Vector(Aim) + (Spread * (FRand() -0.5) * Y) + (Spread * (FRand() -0.5)  * Z));
	DoTrace(StartTrace, R);
}

simulated function DestroyEffects()
{
    if (NewFlashEmitter != None)
        NewFlashEmitter.Destroy();

    if (SmokeEmitter != None)
        SmokeEmitter.Destroy();
}

function DoTrace(Vector Start, Rotator Dir)
{
	local Vector X,Y,Z, End, HitLocation, HitNormal;
	local Actor Other;
	local SniperWallHitEffect S;

	Weapon.GetViewAxes(X, Y, Z);

	X = Vector(Dir);
	End = Start + TraceRange * X;
	Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);

   if ( Other != None && (Other != Instigator) )
   {
		if ( !Other.bWorldGeometry && Other.bCanBeDamaged )
			Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
		else
			HitLocation = HitLocation + 2.0 * HitNormal;
   }
   else
   {
		HitLocation = End;
		HitNormal = Normal(Start - End);
   }

   if ( (HitNormal != Vect(0,0,0)) && (HitScanBlockingVolume(Other) == None) )
   {
		S = Weapon.Spawn(class'SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
		if ( S != None )
			S.FireStart = Start;
   }
}


function PlayFiring()
{
	Super.PlayFiring();

	UT2341Enforcer(Weapon).SpawnShell();
}

function StopFiring()
{
	Spread = default.Spread;
}

defaultproperties
{
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_EnforcerMuzFlash'
     DamageType=Class'UT2341Weapons_BETA3.DamType_Enforcer'
     DamageMin=25
     DamageMax=25
     FireSound=Sound'UT2341Weapons_Sounds.Enforcer.Shot'
     FireRate=0.400000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341MinigunAmmo'
     AmmoPerFire=1
     BotRefireRate=0.400000
     WarnTargetPct=0.500000
     aimerror=850.000000
     Spread=0.020000
     SpreadStyle=SS_Random
}
