/*************************************************************
*
*
*
*************************************************************/

class UT2341SniperRifleTracerProjectile extends TracerProjectile;

var class<FX_SniperTracerTrail> MyTrailerClass;

simulated function PostNetBeginPlay()
{
   local PlayerController PC;
   local vector Dir,LinePos,LineDir, OldLocation;
    
   if ( (Level.NetMode == NM_Client) && (Level.GetLocalPlayerController() == Owner) )
   {
      Destroy();
      return;
   }

   if ( Level.NetMode != NM_DedicatedServer )
   {
      if ( !PhysicsVolume.bWaterVolume )
      {
         Trail = Spawn(MyTrailerClass,self);
         Trail.Lifespan = Lifespan;
      }
   }
   Velocity = Vector(Rotation) * (Speed);
   Super.PostNetBeginPlay();

   // see if local player controller near bullet, but missed
   PC = Level.GetLocalPlayerController();
   if ( (PC != None) && (PC.Pawn != None) )
   {
      Dir = Normal(Velocity);
      LinePos = (Location + (Dir dot (PC.Pawn.Location - Location)) * Dir);
      LineDir = PC.Pawn.Location - LinePos;

      if ( VSize(LineDir) < 150 )
      {
         OldLocation = Location;
         SetLocation(LinePos);

         if ( FRand() < 0.5 )
            PlaySound(sound'Impact3Snd',,,,80);
         else
            PlaySound(sound'Impact7Snd',,,,80);
         SetLocation(OldLocation);
      }
   }
}

defaultproperties
{
     MyTrailerClass=Class'UT2341Weapons_BETA3.FX_SniperTracerTrail'
     Speed=40000.000000
     MaxSpeed=40000.000000
     bOwnerNoSee=False
}
