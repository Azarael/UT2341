/*************************************************************
*
*
*
*************************************************************/
class UT2341EnforcerAltFire extends InstantFire;

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

simulated function DestroyEffects()
{
    if (NewFlashEmitter != None)
        NewFlashEmitter.Destroy();

    if (SmokeEmitter != None)
        SmokeEmitter.Destroy();
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
	
	Spread = FMin(default.Spread + (0.05 * FireCount), 0.3);
	if (UT2341Enforcer(Weapon).GunState != GS_Single)
		Spread = FClamp(3 * Spread, 0.075, 0.3);

   R = rotator(Vector(Aim) + (Spread * (FRand() -0.5) * Y) + (Spread * (FRand() -0.5)  * Z));
   DoTrace(StartTrace, R);
}

function PlayFireEnd()
{
	//no pls
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

	if (Weapon.Role == ROLE_Authority)
	{
		Spread = FMin(default.Spread + (0.05 * FireCount), 0.3);
		
		if (UT2341Enforcer(Weapon).GunState != GS_Single)
			Spread = FClamp(3 * Spread, 0.075, 0.3);
	}
	UT2341Enforcer(Weapon).SpawnShell();
}

function ServerPlayFiring()
{
	FireCount++;
}

function StopFiring()
{
	Spread = default.Spread;
	FireCount = 0;
}

defaultproperties
{
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_EnforcerMuzFlash'
     DamageType=Class'UT2341Weapons_BETA3.DamType_Enforcer'
     DamageMin=25
     DamageMax=25
     PreFireTime=0.200000
     PreFireAnim="PreAlt"
     FireAnim="FireAlt"
     FireEndAnim="AltEnd"
     PreFireAnimRate=2.000000
     FireAnimRate=2.000000
     FireEndAnimRate=2.000000
     FireSound=Sound'UT2341Weapons_Sounds.Enforcer.Shot'
     FireRate=0.290000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341MinigunAmmo'
     AmmoPerFire=1
     BotRefireRate=0.400000
     WarnTargetPct=0.500000
     aimerror=850.000000
     Spread=0.040000
     SpreadStyle=SS_Random
}
