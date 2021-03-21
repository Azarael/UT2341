class UT2341EnforcerAttachment extends xWeaponAttachment;

var Emitter mMuzFlash3rd;

var bool bDualGun;
var UT2341EnforcerAttachment Enforcer2Attachment;
var float AimAlpha;

replication
{
	reliable if ( Role == ROLE_Authority )
		bDualGun, Enforcer2Attachment;
}

simulated function Hide(bool NewbHidden)
{
	bHidden = NewbHidden;
	if ( Enforcer2Attachment != None )
		Enforcer2Attachment.bHidden = bHidden;
}

simulated function Tick(float deltatime)
{
	local rotator newRot;

	if ( !bDualGun || (Level.NetMode == NM_DedicatedServer) )
	{
		Disable('Tick');
		return;
	}
	
	AimAlpha = AimAlpha * ( 1 - 2*DeltaTime);
		
	// point in firing direction
	if ( Instigator != None )
	{
		newRot = Instigator.Rotation;
		if ( AimAlpha < 0.5 )
			newRot.Yaw += 4500 * (1 - 2*AimAlpha);
		Instigator.SetBoneDirection('lfarm', newRot,, 1.0, 1);
	    
		newRot.Roll += 32768;
		Instigator.SetBoneDirection(AttachmentBone, newRot,, 1.0, 1);
	}
}


simulated function Destroyed()
{
	if ( bDualGun )
	{
		if ( Instigator != None )
		{
			Instigator.SetBoneDirection(AttachmentBone, Rotation,, 0, 0);
			Instigator.SetBoneDirection('lfarm', Rotation,, 0, 0);
		}
	}
   if (mMuzFlash3rd != None)
      mMuzFlash3rd.Destroy();
   Super.Destroyed();
}

simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
	Super.SetOverlayMaterial(mat, time, bOverride);
	if ( !bDualGun && (Enforcer2Attachment != None) )
		Enforcer2Attachment.SetOverlayMaterial(mat, time, bOverride);
}

simulated event ThirdPersonEffects()
{
   if ( (FlashCount != 0) && (Level.NetMode != NM_DedicatedServer) )
   {
		if (FiringMode == 0)
			WeaponLight();

		if ( Level.TimeSeconds - Instigator.LastRenderTime < 0.2 )
		{
			if (mMuzFlash3rd == None)
			{
				mMuzFlash3rd = Spawn(class'FX_EnforcerMuzFlash');
				AttachToBone(mMuzFlash3rd, 'tip');
			}
			if (mMuzFlash3rd != None)
				mMuzFlash3rd.Trigger(Self, None);
		}
   }

   Super.ThirdPersonEffects();
}

simulated function Vector GetTipLocation()
{
    local Coords C;
	
    C = GetBoneCoords('tip');
    return C.Origin;
}

defaultproperties
{
     LightType=LT_Steady
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=224
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTEnforcer3rd'
     RelativeLocation=(X=3.000000,Z=3.000000)
     DrawScale=0.120000
}
