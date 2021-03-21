/*************************************************************
*
*
*
*************************************************************/

class UT2341SniperRifleFire extends ClassicSniperFire;

var class<FX_SniperRifleBeamEffect> TeamBeamClasses[2];
var class<TracerProjectile> TeamTracerClasses[2];
var float LimbShotDamageMult;
var vector FireStartOffset;
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

   Instigator.MakeNoise(1.0);

   StartTrace = Instigator.Location + Instigator.EyePosition();

   Aim = AdjustAim(StartTrace, AimError);
   R = rotator(vector(Aim) + VRand()*FRand()*Spread);
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
   local Pawn HeadShotPawn;

   //For Monsters
   local float dist;
   local name HitBone;
   local vector BoneTestLocation, ClosestLocation;
   local float HitHorizontal, HitVertical;


   Weapon.GetViewAxes(X, Y, Z);

   X = Vector(Dir);
   End = Start + TraceRange * X;
   Other = Weapon.Trace(HitLocation, HitNormal, End, Start, true);
    
   //Spawn team colored tracers
   if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
      Weapon.Spawn(TeamTracerClasses[1],Instigator.Controller,,Start,Dir);
   else
      Weapon.Spawn(TeamTracerClasses[0],Instigator.Controller,,Start,Dir);

	if ( Other != None && (Other != Instigator) )
	{
		if ( !Other.bWorldGeometry )
		{
			if(Pawn(Other) != None)
			{
				 //Find a point on the victim's Z axis at the same height as the HitLocation.
				 ClosestLocation = Other.Location;
				 ClosestLocation.Z += (HitLocation - Other.Location).Z;

				 //Extend the shot along its direction to a point where it is closest to the victim's Z axis.
				 BoneTestLocation = X;
				 BoneTestLocation *= VSize(ClosestLocation - HitLocation);
				 BoneTestLocation *= Normal(ClosestLocation - HitLocation) dot Normal(HitLocation - Start);
				 BoneTestLocation += HitLocation;

				 //Find the closest bone.
				 HitBone = Other.GetClosestBone(BoneTestLocation, X, dist, 'head', 8.000);
			   
				 if (HitBone != 'head')
					HitBone = Other.GetClosestBone(BoneTestLocation, X, dist, 'spine', 20.000);


				 if (Vehicle(Other) != None)
					HeadShotPawn = Vehicle(Other).CheckForHeadShot(HitLocation, X, 1.0);

				 if (HeadShotPawn != None)
					HeadShotPawn.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
				 else if ( (Pawn(Other) != None) && Pawn(Other).IsHeadShot(HitLocation, X, 1.0))
					Other.TakeDamage(DamageMax * HeadShotDamageMult, Instigator, HitLocation, Momentum*X, DamageTypeHeadShot);
				 else if ( (Pawn(Other) != None) && ClassIsChildOf(Other.Class, class'skaarjpack.Monster') )
				 {
					HitVertical = BoneTestLocation.Z - Other.Location.Z;
					BoneTestLocation.Z = Other.Location.Z;
					HitHorizontal = VSize(BoneTestLocation - Other.Location);

					if (HitHorizontal < Other.CollisionRadius * 0.6)
					{
					   if ( ClassIsChildOf(Other.Class, class'skaarjpack.GasBag') || ClassIsChildOf(Other.Class, class'skaarjpack.Manta') || ClassIsChildOf(Other.class, class'skaarjpack.RazorFly') || ClassIsChildOf(Other.class, class'skaarjpack.SkaarjPupae') )
					   {
						  Other.TakeDamage(DamageMax*HeadShotDamageMult, Instigator, HitLocation, Momentum * X, DamageTypeHeadShot);
						   
						  if ( (Pawn(Other).Health <= 0) && (Pawn(Other).Health + DamageMax*HeadShotDamageMult > 0) )
							 Instigator.ReceiveLocalizedMessage(class'SpecialKillMessage', 0, Instigator.PlayerReplicationInfo, None, None);
					   }
					   else if (HitVertical > Other.CollisionHeight * 0.8 )
					   {
						  Other.TakeDamage(DamageMax*HeadShotDamageMult, Instigator, HitLocation, Momentum * X, DamageTypeHeadShot);
						  
						  if ( (Pawn(Other).Health <= 0) && (Pawn(Other).Health + DamageMax*HeadShotDamageMult > 0) )
							 Instigator.ReceiveLocalizedMessage(class'SpecialKillMessage', 0, Instigator.PlayerReplicationInfo, None, None);
					   }
					   else if (HitVertical > Other.CollisionHeight * -0.4)
						  Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum * X, DamageType);
					}
					else
					   Other.TakeDamage(DamageMax*LimbShotDamageMult, Instigator, HitLocation, Momentum * X, DamageType);
				 }
				 else
					Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum*X, DamageType);
			}
			else
				Other.TakeDamage(DamageMax, Instigator, HitLocation, Momentum * X, DamageType);
		}
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
      S = Weapon.Spawn(class'FX_SniperWallHitEffect',,, HitLocation, rotator(-1 * HitNormal));
      if ( S != None )
         S.FireStart = Start;
   }

   SpawnBeamEffect(Start, Dir, HitLocation, HitNormal, 0);
}

function SpawnBeamEffect(Vector Start, Rotator Dir, Vector HitLocation, Vector HitNormal, int ReflectNum)
{
   local FX_SniperRifleBeamEffect Beam;
   local vector SpawnVec;

   if (Weapon != None)
   {
		if (ClassicSniperRifle(Weapon).Zoomed)
			SpawnVec = Instigator.Location + Instigator.EyePosition() - vect(0,0,10);
		else SpawnVec = Weapon.GetBoneCoords('Bone_Flash').Origin;
       //Spawn team colored beams
      if ( (Instigator.PlayerReplicationInfo.Team != None) && (Instigator.PlayerReplicationInfo.Team.TeamIndex == 1) )
         Beam = Weapon.Spawn(TeamBeamClasses[1],,, SpawnVec, Dir);
      else
         Beam = Weapon.Spawn(TeamBeamClasses[0],,, SpawnVec, Dir);

      // prevents client side repositioning of beam start
      Beam.AimAt(HitLocation, HitNormal, 1);
   }
}

function PlayFiring()
{
   Weapon.PlayAnim(FireAnims[Rand(3)], FireAnimRate, TweenTime);
   Weapon.PlayOwnedSound(FireSound,SLOT_Interact,TransientSoundVolume,,,Default.FireAnimRate/FireAnimRate,false);
   ClientPlayForceFeedback(FireForce);
   FireCount++;
}

/*
note that this weapon has been nerfed because of how horrendously overpowered
it was in 99

limb shot damage is only used vs monster
*/
defaultproperties
{
     TeamBeamClasses(0)=Class'UT2341Weapons_BETA3.FX_SniperRifleBeamEffect'
     TeamBeamClasses(1)=Class'UT2341Weapons_BETA3.FX_SniperRifleBeamEffectBlue'
     TeamTracerClasses(0)=Class'UT2341Weapons_BETA3.UT2341SniperRifleTracerProjectile'
     TeamTracerClasses(1)=Class'UT2341Weapons_BETA3.UT2341SniperRifleTracerProjectileBlue'
     LimbShotDamageMult=0.750000
     FireStartOffset=(X=6.000000,Y=8.000000)
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_SniperRifleMuzFlash'
     HeadShotDamageMult=2.250000
     DamageTypeHeadShot=Class'UT2341Weapons_BETA3.DamType_SniperHeadShot'
     DamageType=Class'UT2341Weapons_BETA3.DamType_SniperShot'
     DamageMin=67
     DamageMax=67
     FireEndAnim=
     FireSound=Sound'UT2341Weapons_Sounds.Sniper.SniperFire'
     FireRate=0.660000
     AmmoClass=Class'UT2341Weapons_BETA3.UT2341SniperAmmo'
}
