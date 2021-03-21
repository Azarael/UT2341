class UT2341MinigunAttachment extends MinigunAttachment;

var Emitter MuzFlashNew;
var class<Emitter> NewFlashClass;

function Destroyed()
{
    if (mTracer != None)
        mTracer.Destroy();

    if (MuzFlashNew != None)
        MuzFlashNew.Destroy();

    if (mShellCaseEmitter != None)
        mShellCaseEmitter.Destroy();

	Super(xWeaponAttachment).Destroyed();
}

simulated function UpdateRoll(float dt)
{
    local rotator r;

    UpdateRollTime(false);

    if (mRollInc <= 0.f)
        return;

    mCurrentRoll += dt*mRollInc;
    mCurrentRoll = mCurrentRoll % 65536.f;
    r.Roll = int(mCurrentRoll);

    SetBoneRotation('Bone_Barrels', r, 0, 1.f);
}

simulated function vector GetTracerStart()
{
    local Pawn p;

    p = Pawn(Owner);

    if ( (p != None) && p.IsFirstPerson() && p.Weapon != None )
    {
        // 1st person
        return p.Weapon.GetEffectStart();
    }

    // 3rd person
	if ( MuzFlashNew != None )
		return MuzFlashNew.Location;
	else
		return Location;
}

simulated event ThirdPersonEffects()
{
	local PlayerController PC;
	
    if ( (Level.NetMode == NM_DedicatedServer) || (Instigator == None) )
		return; 

    if ( FlashCount > 0 )
	{
 		PC = Level.GetLocalPlayerController();
		if ( OldSpawnHitCount != SpawnHitCount )
		{
			OldSpawnHitCount = SpawnHitCount;
			GetHitInfo();
			PC = Level.GetLocalPlayerController();
			if ( (Instigator.Controller == PC) || (VSize(PC.ViewTarget.Location - mHitLocation) < 2000) )
			{
				Spawn(class'HitEffect'.static.GetHitEffect(mHitActor, mHitLocation, mHitNormal),,, mHitLocation, Rotator(mHitNormal));
				CheckForSplash();
			}
		}
		if ( (Level.TimeSeconds - LastRenderTime > 0.2) && (Instigator.Controller != PC) )
			return;

	 	WeaponLight();

		if (FiringMode == 0)
        {
            mTracerInterval = mTracerIntervalPrimary;
            mRollInc = 65536.f*2.f;
        }
        else
        {
            mTracerInterval = mTracerIntervalSecondary;
            mRollInc = 65536.f *4.f;
        } 

		if ( Level.bDropDetail || Level.DetailMode == DM_Low )
			mTracerInterval *= 2.0;

        UpdateRollTime(true);
		
        UpdateTracer();

        if (MuzFlashNew == None)
        {
            MuzFlashNew = Spawn(NewFlashClass);
            AttachToBone(MuzFlashNew, 'tip');
        }
        if (MuzFlashNew != None)
        {
            MuzFlashNew.Trigger(self, None);
        }

        if ( (mShellCaseEmitter == None) && (Level.DetailMode != DM_Low) && !Level.bDropDetail )
        {
            mShellCaseEmitter = Spawn(mShellCaseEmitterClass);
            if ( mShellCaseEmitter != None )
				AttachToBone(mShellCaseEmitter, 'Bone_CaseEjector');
        }
        if (mShellCaseEmitter != None)
            mShellCaseEmitter.mStartParticles++;
    }
    else
    {
        GotoState('');
    }

    Super(xWeaponAttachment).ThirdPersonEffects();
}

defaultproperties
{
     NewFlashClass=Class'UT2341Weapons_BETA3.FX_EnforcerMuzFlash'
     mTracerIntervalPrimary=0.130000
     mTracerIntervalSecondary=0.080000
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTminigun3rd'
     DrawScale=0.900000
}
