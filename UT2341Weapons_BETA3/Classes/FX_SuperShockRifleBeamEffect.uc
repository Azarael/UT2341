// xEmitter version
class FX_SuperShockRifleBeamEffect extends ShockBeamEffect;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    //Spawn(class'ShockImpactFlare',,, EffectLoc, HitRot);
    //Spawn(class'ShockImpactRing',,, EffectLoc, HitRot);
    //Spawn(class'ShockImpactScorch',,, EffectLoc, Rotator(-HitNormal));
    //Spawn(class'ShockExplosionCore',,, EffectLoc+HitNormal*8, HitRot);
    Spawn(class'FX_SuperShockRifleImpact',,, EffectLoc, HitRot);
}

simulated function SpawnEffects()
{
    local ShockBeamCoil Coil;
    local xWeaponAttachment Attachment;
	
    if (Instigator != None)
    {
        if ( Instigator.IsFirstPerson() )
        {
			if ( (Instigator.Weapon != None) && (Instigator.Weapon.Instigator == Instigator) )
				SetLocation(Instigator.Weapon.GetEffectStart());
			else
				SetLocation(Instigator.Location);
			log("Attempting to spawn MuzFlash");
            Spawn(MuzFlashClass,,, Location);
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if (Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1)
                SetLocation(Attachment.GetTipLocation());
            else
                SetLocation(Instigator.Location + Instigator.EyeHeight*Vect(0,0,1) + Normal(mSpawnVecA - Instigator.Location) * 25.0); 
			log("Attempting to spawn MuzFlash3");
            Spawn(MuzFlash3Class);
        }
    }

    if ( EffectIsRelevant(mSpawnVecA + HitNormal*2,false) && (HitNormal != Vect(0,0,0)) )
		SpawnImpactEffects(Rotator(HitNormal),mSpawnVecA + HitNormal*2);
	
    if ( (!Level.bDropDetail && (Level.DetailMode != DM_Low) && (VSize(Location - mSpawnVecA) > 40) && !Level.GetLocalPlayerController().BeyondViewDistance(Location,0))
		|| ((Instigator != None) && Instigator.IsFirstPerson()) )
    {
	    Coil = Spawn(CoilClass,,, Location, Rotation);
	    if (Coil != None)
		    Coil.mSpawnVecA = mSpawnVecA;
    }
}

defaultproperties
{
     CoilClass=Class'XEffects.ShockBeamCoilB'
     MuzFlashClass=Class'UT2341Weapons_BETA3.FX_SuperShockMuzFlash'
     MuzFlash3Class=Class'UT2341Weapons_BETA3.FX_SuperShockMuzFlash3rd'
     Texture=Texture'UT2341Weapons_Tex.SuperShock.SuperShockBeamTex'
     Skins(0)=Texture'UT2341Weapons_Tex.SuperShock.SuperShockBeamTex'
}
