class FX_PulseImpact extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         DampRotation=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=-400.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.370000
         FadeOutStartTime=0.240000
         CoordinateSystem=PTCS_Relative
         MaxParticles=8
         SpinsPerSecondRange=(X=(Min=1.000000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         RotationDampingFactorRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=20.000000,Max=20.000000))
         SizeScale(0)=(RelativeTime=0.170000,RelativeSize=1.000000)
         SizeScale(1)=(RelativeTime=0.370000)
         StartSizeRange=(X=(Min=10.000000,Max=10.000000),Y=(Min=10.000000,Max=10.000000),Z=(Min=10.000000,Max=10.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=2.000000,Max=2.000000)
         StartVelocityRange=(X=(Min=50.000000,Max=170.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=20.000000,Max=350.000000))
     End Object
     Emitters(0)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseImpact.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.800000
         FadeOutStartTime=0.360000
         FadeInEndTime=0.360000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.HardSpot'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(1)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseImpact.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.140000
         FadeOutStartTime=0.360000
         FadeInEndTime=0.360000
         CoordinateSystem=PTCS_Relative
         MaxParticles=5
         SpinsPerSecondRange=(X=(Max=4.600000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.070000)
         SizeScale(1)=(RelativeTime=0.370000,RelativeSize=1.000000)
         SizeScaleRepeats=1.020000
         StartSizeRange=(X=(Min=80.000000,Max=80.000000),Y=(Min=80.000000,Max=80.000000),Z=(Min=80.000000,Max=80.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'VMParticleTextures.LeviathanParticleEffects.LeviathanMGUNFlare'
         LifetimeRange=(Min=0.801000,Max=0.801000)
     End Object
     Emitters(2)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseImpact.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.190000
         FadeOutStartTime=0.245000
         FadeInEndTime=0.225000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=0.600000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=3.000000)
         SizeScale(1)=(RelativeTime=0.560000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=40.000000,Max=40.000000),Y=(Min=40.000000,Max=40.000000),Z=(Min=40.000000,Max=40.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.BoloBlob'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(3)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseImpact.SpriteEmitter4'

     AutoDestroy=True
     bNoDelete=False
}
