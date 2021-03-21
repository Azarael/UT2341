/*************************************************************
*
*
*
*************************************************************/

class FX_SniperWallHitEffect extends SniperWallHitEffect;

simulated function SpawnEffects()
{
   local rotator ReverseRot;
   local PlayerController PC;
   local vector Dir, LinePos, LineDir;
   local bool bViewed;

   PlaySound(ImpactSounds[Rand(6)],, 2.5*TransientSoundVolume,,200);
    
   PC = Level.GetLocalPlayerController();
   if ( (PC != None) && (PC.ViewTarget != None) && (VSize(PC.Viewtarget.Location - Location) < 3000*PC.FOVBias) )
   {
      Spawn(class'LongBulletDecal');
      bViewed = true;
   }
    
   if ( !PhysicsVolume.bWaterVolume )
   {
      ReverseRot = rotator(-1 * vector(Rotation));
      if ( bViewed )
         Spawn(class'pclImpactSmoke',,,,ReverseRot);
      Spawn(class'SmallExplosion',,,,ReverseRot);
      Spawn(class'WallSparks',,,,ReverseRot);
   }
    
   if ( FireStart != vect(0,0,0) )
   {
      // see if local player controller near bullet, but missed
      if ( (PC != None) && (PC.Pawn != None) )
      {
         Dir = Normal(Location - FireStart);
         LinePos = (FireStart + (Dir dot (PC.Pawn.Location - FireStart)) * Dir);
         LineDir = PC.Pawn.Location - LinePos;
         if ( VSize(LineDir) < 150 )
         {
            SetLocation(LinePos);
            if ( FRand() < 0.5 )
               PlaySound(sound'Impact3Snd',,,,80);
            else
               PlaySound(sound'Impact7Snd',,,,80);
         }
      }
   }
}

defaultproperties
{
}
