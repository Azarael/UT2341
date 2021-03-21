/*************************************************************
*
*
*
*************************************************************/

class FX_SniperRifleBeamEffect extends xEmitter;

var vector HitNormal;

replication
{
   reliable if(bNetInitial && Role == ROLE_Authority)
      HitNormal;
}

simulated function PostNetBeginPlay()
{
   if (Role < ROLE_Authority)
      SpawnEffects();
}

function AimAt(Vector hl, Vector hn, float Charge)
{
   HitNormal = hn;
   mSpawnVecA = hl;

   if (Level.NetMode != NM_DedicatedServer)
      SpawnEffects();
}


simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
   Spawn(class'pclImpactSmoke',,, EffectLoc, HitRot);
}

simulated function bool CheckMaxEffectDistance(PlayerController P, vector SpawnLocation)
{
   return !P.BeyondViewDistance(SpawnLocation,3000);
}

simulated function SpawnEffects()
{
   local xWeaponAttachment Attachment;

   if (Instigator != None)
   {
		if ( Instigator.IsFirstPerson() )
        {
            if ( (Instigator.Weapon == None) || Instigator.Weapon.WeaponCentered() || (Instigator.Weapon.Instigator == None) )
 		        SetLocation( Instigator.Location );
            else
				SetLocation( Instigator.Weapon.GetEffectStart() );
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if ( Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1 )
                SetLocation( Attachment.GetTipLocation() );
            else
                SetLocation( Instigator.Location  );
        }
   }

   if (EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && HitNormal != Vect(0,0,0))
      SpawnImpactEffects(Rotator(HitNormal), mSpawnVecA + HitNormal*2);
}

defaultproperties
{
     mParticleType=PT_Beam
     mMaxParticles=3
     mLifeRange(0)=0.100000
     mRegenDist=150.000000
     mSizeRange(0)=2.000000
     mSizeRange(1)=2.000000
     mColorRange(0)=(B=0)
     mColorRange(1)=(B=0)
     mAttenKa=0.100000
     bReplicateInstigator=True
     bReplicateMovement=False
     RemoteRole=ROLE_SimulatedProxy
     NetPriority=3.000000
     LifeSpan=0.100000
     Skins(0)=Texture'XEffectMat.Ion.painter_beam'
     Style=STY_Additive
}
