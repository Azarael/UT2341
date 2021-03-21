class FX_RipperExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.620000
         FadeOutStartTime=0.380000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=16.000000,Max=16.000000),Y=(Min=16.000000,Max=16.000000),Z=(Min=16.000000,Max=16.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp7_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.601000,Max=0.601000)
         InitialDelayRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(0)=SpriteEmitter'UT2341Weapons_BETA3.FX_RipperExplosion.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter18
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.900000,Max=0.900000))
         Opacity=0.820000
         FadeOutStartTime=0.380000
         MaxParticles=2
         StartLocationRange=(X=(Min=4.000000,Max=4.000000),Y=(Min=4.000000,Max=4.000000),Z=(Min=4.000000,Max=4.000000))
         SpinsPerSecondRange=(X=(Min=-0.100000,Max=-0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=14.000000,Max=14.000000),Y=(Min=14.000000,Max=14.000000),Z=(Min=14.000000,Max=14.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=0.601000,Max=0.601000)
         InitialDelayRange=(Max=0.040000)
     End Object
     Emitters(1)=SpriteEmitter'UT2341Weapons_BETA3.FX_RipperExplosion.SpriteEmitter18'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter21
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=90.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.140000
         FadeOutStartTime=0.250000
         FadeInEndTime=0.160000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000),Y=(Min=25.000000,Max=25.000000),Z=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Smoke.Smokepuff2'
         LifetimeRange=(Min=1.400000,Max=1.400000)
     End Object
     Emitters(2)=SpriteEmitter'UT2341Weapons_BETA3.FX_RipperExplosion.SpriteEmitter21'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter22
         UseCollision=True
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
         ColorMultiplierRange=(Y=(Min=0.940000,Max=0.940000),Z=(Min=0.840000,Max=0.840000))
         Opacity=0.510000
         FadeOutStartTime=0.286000
         FadeInEndTime=0.013000
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=13.000000)
         StartSizeRange=(X=(Min=25.000000,Max=25.000000),Y=(Min=25.000000,Max=25.000000),Z=(Min=25.000000,Max=25.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.700000,Max=0.700000)
     End Object
     Emitters(3)=SpriteEmitter'UT2341Weapons_BETA3.FX_RipperExplosion.SpriteEmitter22'

     Begin Object Class=SparkEmitter Name=SparkEmitter1
         LineSegmentsRange=(Min=1.000000,Max=1.000000)
         TimeBetweenSegmentsRange=(Min=0.200000,Max=0.200000)
         FadeOut=True
         RespawnDeadParticles=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=-1200.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.700000,Max=0.700000),Z=(Min=0.300000,Max=0.300000))
         Opacity=0.540000
         FadeOutStartTime=0.282470
         MaxParticles=14
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=0.701000,Max=0.701000)
         InitialDelayRange=(Min=0.040000,Max=0.040000)
         StartVelocityRange=(X=(Min=-700.000000,Max=700.000000),Y=(Min=-700.000000,Max=700.000000),Z=(Min=-700.000000,Max=700.000000))
     End Object
     Emitters(4)=SparkEmitter'UT2341Weapons_BETA3.FX_RipperExplosion.SparkEmitter1'

     bNoDelete=False
}
