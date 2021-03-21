class FX_PulseBeamEnd extends Emitter;

defaultproperties
{
     Begin Object Class=BeamEmitter Name=BeamEmitter0
         BeamDistanceRange=(Min=70.000000,Max=70.000000)
         DetermineEndPointBy=PTEP_Distance
         RotatingSheets=1
         LowFrequencyNoiseRange=(X=(Max=10.000000),Y=(Max=10.000000),Z=(Max=10.000000))
         LowFrequencyPoints=2
         HighFrequencyNoiseRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000),Z=(Min=-8.000000,Max=8.000000))
         HighFrequencyPoints=4
         HFScaleFactors(0)=(FrequencyScale=(X=0.400000,Y=0.400000,Z=0.400000),RelativeLength=0.280000)
         HFScaleRepeats=10.000000
         UseHighFrequencyScale=True
         BranchProbability=(Min=1.000000,Max=1.000000)
         BranchSpawnAmountRange=(Min=5.000000,Max=5.000000)
         LinkupLifetime=True
         FadeOut=True
         FadeIn=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.500000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.460000
         FadeOutStartTime=2.000000
         FadeInEndTime=2.000000
         CoordinateSystem=PTCS_Relative
         StartLocationShape=PTLS_Sphere
         SphereRadiusRange=(Max=5.000000)
         SizeScale(0)=(RelativeTime=0.500000,RelativeSize=-1.000000)
         SizeScaleRepeats=1.000000
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=10.000000
         Texture=Texture'AW-2004Particles.Energy.BeamBolt1a'
         LifetimeRange=(Min=0.601000,Max=0.601000)
         StartVelocityRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(0)=BeamEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.BeamEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.700000,Max=0.700000))
         Opacity=0.780000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinCCWorCW=(X=0.680000)
         SpinsPerSecondRange=(X=(Min=4.700000,Max=4.700000))
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.LargeSpot'
         LifetimeRange=(Min=9.000000,Max=9.000000)
     End Object
     Emitters(1)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.300000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.260000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinCCWorCW=(X=0.680000)
         SpinsPerSecondRange=(X=(Min=4.700000,Max=4.700000))
         StartSizeRange=(X=(Min=24.000000,Max=24.000000),Y=(Min=24.000000,Max=24.000000),Z=(Min=24.000000,Max=24.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.BoloBlob'
         LifetimeRange=(Min=9.000000,Max=9.000000)
     End Object
     Emitters(2)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         SpinParticles=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.300000),Z=(Min=0.000000,Max=0.200000))
         Opacity=0.910000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinCCWorCW=(X=0.680000)
         SpinsPerSecondRange=(X=(Min=-4.700000,Max=-4.700000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.000000)
         StartSizeRange=(X=(Min=42.000000,Max=42.000000),Y=(Min=42.000000,Max=42.000000),Z=(Min=42.000000,Max=42.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=9.000000,Max=9.000000)
     End Object
     Emitters(3)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         SpinParticles=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.100000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.810000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinCCWorCW=(X=0.680000)
         SpinsPerSecondRange=(X=(Min=5.700000,Max=5.700000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         StartSizeRange=(X=(Min=54.000000,Max=54.000000),Y=(Min=54.000000,Max=54.000000),Z=(Min=54.000000,Max=54.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.FlickerFlare'
         LifetimeRange=(Min=9.000000,Max=9.000000)
     End Object
     Emitters(4)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-50.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Z=(Min=0.400000,Max=0.400000))
         Opacity=0.400000
         FadeOutStartTime=0.450000
         CoordinateSystem=PTCS_Relative
         MaxParticles=9
         SpinCCWorCW=(X=0.750000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeTime=0.140000,RelativeSize=0.100000)
         SizeScaleRepeats=1.000000
         StartSizeRange=(X=(Min=7.000000,Max=7.000000),Y=(Min=7000000.000000,Max=7.000000),Z=(Min=7.000000,Max=7.000000))
         ParticlesPerSecond=10.000000
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=1.000000,Max=1.000000)
         StartVelocityRange=(X=(Min=-35.000000,Max=45000000.000000),Y=(Min=-45.000000,Max=45.000000),Z=(Min=-35.000000,Max=80.000000))
     End Object
     Emitters(5)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamEnd.SpriteEmitter2'

     bNoDelete=False
}
