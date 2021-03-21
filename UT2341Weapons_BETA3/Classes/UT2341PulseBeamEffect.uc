class UT2341PulseBeamEffect extends xEmitter;

#exec OBJ LOAD FILE=XEffectMat.utx

var Vector	StartEffect, EndEffect;
var bool		bHitSomething;
var Vector	EffectOffset;
var Vector	PrevLoc;
var Rotator PrevRot;
var float	scorchtime;

var FX_PulseBeamEnd			BeamEndEffect;
var FX_PulseBeamFlash3rd 	MuzFlash;

replication
{
    unreliable if (Role == ROLE_Authority)
        bHitSomething;

    unreliable if ( (Role == ROLE_Authority) && (!bNetOwner || bDemoRecording || bRepClientDemo)  )
        StartEffect, EndEffect;
}


simulated function Destroyed()
{
    if ( MuzFlash != None )
        MuzFlash.Kill();
		
	if (BeamEndEffect != None)
		BeamEndEffect.Destroy();

	Super.Destroyed();
}

simulated function SetBeamLocation()
{
	local xWeaponAttachment Attachment;

	if ( Level.NetMode == NM_DedicatedServer )
    {
        StartEffect = Instigator.Location + Instigator.EyeHeight*Vect(0,0,1);
        SetLocation( StartEffect );
        return;
    }

    if ( Instigator == None )
    {
        SetLocation( StartEffect );
    }
    else
    {
		if ( Instigator.IsFirstPerson() )
        {
            if ( (Instigator.Weapon == None) || Instigator.Weapon.WeaponCentered() || (Instigator.Weapon.Instigator == None) )
 		        SetLocation( Instigator.Location );
            else
				SetLocation(Instigator.Weapon.GetEffectStart() - (20 * vector(Instigator.Controller.Rotation)));
        }
        else
        {
            Attachment = xPawn(Instigator).WeaponAttachment;
            if ( Attachment != None && (Level.TimeSeconds - Attachment.LastRenderTime) < 1 )
                SetLocation( Attachment.GetTipLocation() );
            else
                SetLocation( Instigator.Location + Normal(EndEffect - Instigator.Location) * 25.0 );
        }
        if ( Role == ROLE_Authority ) // what clients will use if their instigator is not relevant yet
            StartEffect = Location;
    }
}

simulated function Vector SetBeamRotation()
{
    if ( (Instigator != None) && PlayerController(Instigator.Controller) != None )
        SetRotation( Instigator.Controller.GetViewRotation() );
    else
        SetRotation( Rotator(EndEffect - Location) );

	return Normal(EndEffect - Location);
}

simulated function bool CheckMaxEffectDistance(PlayerController P, vector SpawnLocation)
{
	return !P.BeyondViewDistance(SpawnLocation,1000);
}


simulated function Tick(float dt)
{
    local Vector BeamDir, HitLocation, HitNormal;
    local actor HitActor;

    if ( Role == ROLE_Authority && (Instigator == None || Instigator.Controller == None) )
    {
        Destroy();
        return;
    }

	// set beam start location
	SetBeamLocation();
	BeamDir = SetBeamRotation();

	if ( Level.NetMode != NM_DedicatedServer )
	{
		if ( (Instigator != None) && !Instigator.IsFirstPerson() )
		{
			if ( MuzFlash == None || MuzFlash.bDeleteMe )
				MuzFlash = Spawn(class'FX_PulseBeamFlash3rd', self);
		}
		else if ( MuzFlash != None )
			MuzFlash.Destroy();

		if ( BeamEndEffect == None && EffectIsRelevant(EndEffect, false) )
			BeamEndEffect = Spawn(class'FX_PulseBeamEnd', self);
	}

    if ( Level.bDropDetail || Level.DetailMode == DM_Low )
    {
		bDynamicLight = false;
        LightType = LT_None;
    }
    else if ( bDynamicLight )
        LightType = LT_Steady;

    mSpawnVecA = EndEffect;

	mWaveAmplitude = 0.0;

    PrevLoc = Location;
    PrevRot = Rotation;
	
	if ( MuzFlash != None )
		MuzFlash.SetLocation( StartEffect );

    if ( BeamEndEffect != None )
        BeamEndEffect.SetLocation( EndEffect );

    if ( bHitSomething && (Level.NetMode != NM_DedicatedServer) && (Level.TimeSeconds - ScorchTime > 0.07) )
    {
		ScorchTime = Level.TimeSeconds;
		HitActor = Trace(HitLocation, HitNormal, EndEffect + 100*BeamDir, EndEffect - 100*BeamDir, true);
		if ( (HitActor != None) && HitActor.bWorldGeometry )
			spawn(class'LinkScorch',,,HitLocation,rotator(-HitNormal));
	}
}

defaultproperties
{
     EffectOffset=(X=22.000000,Y=11.000000,Z=1.400000)
     mParticleType=PT_Beam
     mMaxParticles=3
     mRegenDist=65.000000
     mSpinRange(0)=45000.000000
     mColorRange(0)=(B=240,G=240,R=240)
     mColorRange(1)=(B=240,G=240,R=240)
     mAttenuate=False
     mAttenKa=0.000000
     mWaveFrequency=0.060000
     mWaveAmplitude=8.000000
     mWaveShift=100000.000000
     mBendStrength=3.000000
     mWaveLockEnd=True
     LightType=LT_Steady
     LightHue=100
     LightSaturation=100
     LightBrightness=255.000000
     LightRadius=4.000000
     bDynamicLight=True
     bNetTemporary=False
     bReplicateInstigator=True
     RemoteRole=ROLE_SimulatedProxy
     Skins(0)=FinalBlend'UT2341Weapons_Tex.PulseGun.PulseBeamBlend'
     Style=STY_Additive
}
