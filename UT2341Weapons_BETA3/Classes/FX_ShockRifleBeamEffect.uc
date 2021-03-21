/*************************************************************
*
*
*
*************************************************************/

/*
class FX_ShockRifleBeamEffect extends Emitter;

defaultproperties
{
    Begin Object Class=BeamEmitter Name=BeamEmitter0
        BeamDistanceRange=(Min=800.000000,Max=800.000000)
        DetermineEndPointBy=PTEP_Distance
        LowFrequencyNoiseRange=(Z=(Max=1.000000))
        FadeOut=True
        UseSizeScale=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.200000,Max=0.200000))
        Opacity=0.200000
        FadeOutStartTime=1.500000
        MaxParticles=8
        Name="ShockBeam"
        StartSizeRange=(X=(Min=16.000000,Max=16.000000),Y=(Min=16.000000,Max=16.000000),Z=(Min=16.000000,Max=16.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'EpicParticles.Beams.WhiteStreak01aw'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=20.000000,Max=20.000000))
    End Object
    Emitters(0)=BeamEmitter'BeamEmitter0'
 
    Begin Object Class=BeamEmitter Name=BeamEmitter1
        BeamDistanceRange=(Min=800.000000,Max=800.000000)
        DetermineEndPointBy=PTEP_Distance
        LowFrequencyNoiseRange=(X=(Max=1.000000),Y=(Min=-0.500000,Max=0.500000),Z=(Max=1.000000))
        HighFrequencyPoints=17
        HFScaleFactors(0)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=3.000000),RelativeLength=0.520000)
        FadeOut=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.600000,Max=0.600000))
        Opacity=0.070000
        FadeOutStartTime=1.500000
        MaxParticles=8
        Name="ShockBeam2"
        StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'AS_FX_TX.Beams.HotBolt_1'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=20.000000,Max=20.000000))
    End Object
    Emitters(1)=BeamEmitter'BeamEmitter1'
 
    Begin Object Class=BeamEmitter Name=BeamEmitter2
        BeamDistanceRange=(Min=800.000000,Max=800.000000)
        DetermineEndPointBy=PTEP_Distance
        LowFrequencyNoiseRange=(X=(Min=-10.000000,Max=-1.000000),Y=(Min=-10.000000,Max=-0.500000),Z=(Min=-10.000000,Max=-1.000000))
        HighFrequencyPoints=17
        HFScaleFactors(0)=(FrequencyScale=(X=1.000000,Y=1.000000,Z=3.000000),RelativeLength=0.520000)
        FadeOut=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.600000,Max=0.600000))
        Opacity=0.030000
        FadeOutStartTime=1.500000
        MaxParticles=8
        Name="ShockBeam3"
        StartSizeRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
        InitialParticlesPerSecond=5000.000000
        Texture=Texture'AS_FX_TX.Beams.HotBolt_1'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=20.000000,Max=20.000000))
    End Object
    Emitters(2)=BeamEmitter'BeamEmitter2'
 
    Begin Object Class=SpriteEmitter Name=SpriteEmitter1
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.400000,Max=0.400000))
        Opacity=0.330000
        FadeOutStartTime=0.540000
        MaxParticles=15
        Name="ShockTrail"
        SpinsPerSecondRange=(X=(Max=0.200000))
        StartSpinRange=(X=(Max=0.100000))
        StartSizeRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=30.000000,Max=30.000000),Z=(Min=30.000000,Max=30.000000))
        InitialParticlesPerSecond=10.000000
        Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Min=680.000000,Max=680.000000))
    End Object
    Emitters(3)=SpriteEmitter'SpriteEmitter1'
 
    Begin Object Class=SpriteEmitter Name=SpriteEmitter2
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.600000,Max=0.600000))
        Opacity=0.270000
        FadeOutStartTime=0.540000
        MaxParticles=15
        Name="ShockTrail2"
        SpinsPerSecondRange=(X=(Max=0.200000))
        StartSpinRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=30.000000,Max=30.000000),Z=(Min=30.000000,Max=30.000000))
        InitialParticlesPerSecond=10.000000
        Texture=Texture'AS_FX_TX.Flares.Laser_Flare'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Max=480.000000))
    End Object
    Emitters(4)=SpriteEmitter'SpriteEmitter2'
 
    Begin Object Class=SpriteEmitter Name=SpriteEmitter3
        FadeOut=True
        SpinParticles=True
        UniformSize=True
        AutomaticInitialSpawning=False
        ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
        ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
        ColorMultiplierRange=(X=(Min=0.300000,Max=0.300000),Y=(Min=0.400000,Max=0.400000))
        Opacity=0.340000
        FadeOutStartTime=0.540000
        MaxParticles=15
        Name="ShockTrailfaint"
        SpinsPerSecondRange=(X=(Max=0.100000))
        StartSpinRange=(X=(Max=1.000000))
        StartSizeRange=(X=(Min=30.000000,Max=30.000000),Y=(Min=30.000000,Max=30.000000),Z=(Min=30.000000,Max=30.000000))
        InitialParticlesPerSecond=13.000000
        Texture=Texture'EpicParticles.Flares.SoftFlare'
        LifetimeRange=(Min=3.000000,Max=3.000000)
        StartVelocityRange=(X=(Max=480.000000))
    End Object
    Emitters(5)=SpriteEmitter'SpriteEmitter3'
}
*/

// xEmitter version
class FX_ShockRifleBeamEffect extends ShockBeamEffect;

simulated function SpawnImpactEffects(rotator HitRot, vector EffectLoc)
{
    //Spawn(class'ShockImpactFlare',,, EffectLoc, HitRot);
    //Spawn(class'ShockImpactRing',,, EffectLoc, HitRot);
    //Spawn(class'ShockImpactScorch',,, EffectLoc, Rotator(-HitNormal));
    //Spawn(class'ShockExplosionCore',,, EffectLoc+HitNormal*8, HitRot);
    Spawn(class'FX_ShockRifleImpact',,, EffectLoc, HitRot);
}

defaultproperties
{
     Texture=Texture'UT2341Weapons_Tex.ASMD.ASMDBeamTex'
     Skins(0)=Texture'UT2341Weapons_Tex.ASMD.ASMDBeamTex'
}
