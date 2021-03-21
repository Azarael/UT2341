//========================================================================
// EONSSniperRifleAttachment
// EONS Sniper Rifle by Wail of Suicide
// Modifications to this class remove the smoke effect of the Classic Sniper Rifle.
//========================================================================

class UT2341SniperRifleAttachment extends xWeaponAttachment;

var Emitter mMuzFlash3rd;

simulated function Destroyed()
{
   if (mMuzFlash3rd != None)
      mMuzFlash3rd.Destroy();
   Super.Destroyed();
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
				mMuzFlash3rd = Spawn(class'FX_SniperRifleMuzFlash');
				AttachToBone(mMuzFlash3rd, 'tip');
			}
			if (mMuzFlash3rd != None)
				mMuzFlash3rd.Trigger(self, None);
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
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTSniperRifle3rd'
     DrawScale=0.110000
}
