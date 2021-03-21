class FX_RedeemerExplosion extends Emitter;

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter13
         StaticMesh=StaticMesh'Editor.TexPropSphere'
         UseMeshBlendMode=False
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.270000
         FadeOutStartTime=0.370000
         MaxParticles=2
         SpinCCWorCW=(X=1.000000,Y=1.000000,Z=1.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=14.000000),Y=(Min=1.000000,Max=4.000000),Z=(Min=1.000000,Max=4.000000))
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=4.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=26.000000)
         InitialParticlesPerSecond=10.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=MeshEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.MeshEmitter13'

     Begin Object Class=MeshEmitter Name=MeshEmitter15
         StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionSphere'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.430000
         FadeOutStartTime=0.370000
         MaxParticles=2
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=4.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=26.000000)
         StartSizeRange=(X=(Min=0.470000,Max=0.470000),Y=(Min=0.470000,Max=0.470000),Z=(Min=0.310000,Max=0.310000))
         InitialParticlesPerSecond=20.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=MeshEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.MeshEmitter15'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter15
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.600000,Max=0.600000))
         Opacity=0.460000
         FadeOutStartTime=0.380000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=16.000000)
         StartSizeRange=(X=(Min=400.000000,Max=400.000000),Y=(Min=400.000000,Max=400.000000),Z=(Min=400.000000,Max=400.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(2)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter15'

     Begin Object Class=MeshEmitter Name=MeshEmitter19
         StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionRing'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.150000
         FadeOutStartTime=0.370000
         MaxParticles=2
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=3.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=12.000000)
         StartSizeRange=(X=(Min=1.810000,Max=1.810000),Y=(Min=1.810000,Max=1.810000),Z=(Min=1.810000,Max=1.810000))
         InitialParticlesPerSecond=10.000000
         LifetimeRange=(Min=1.500000,Max=1.500000)
     End Object
     Emitters(3)=MeshEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.MeshEmitter19'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter16
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Z=(Min=0.800000,Max=0.800000))
         Opacity=0.680000
         FadeOutStartTime=0.460000
         MaxParticles=2
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=12.000000)
         StartSizeRange=(X=(Min=425.000000,Max=425.000000),Y=(Min=425.000000,Max=425.000000),Z=(Min=425.000000,Max=425.000000))
         InitialParticlesPerSecond=1000.000000
         DrawStyle=PTDS_AlphaBlend
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=2.000000,Max=2.000000)
     End Object
     Emitters(4)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter16'

     Begin Object Class=MeshEmitter Name=MeshEmitter20
         StaticMesh=StaticMesh'ParticleMeshes.Complex.ExplosionRing'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.060000
         FadeOutStartTime=0.370000
         MaxParticles=1
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=2.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=7.000000)
         StartSizeRange=(X=(Min=3.370000,Max=3.370000),Y=(Min=3.370000,Max=3.370000),Z=(Min=0.310000,Max=0.310000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(5)=MeshEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.MeshEmitter20'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
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
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.600000,Max=0.600000))
         FadeOutStartTime=0.380000
         MaxParticles=2
         StartLocationRange=(Z=(Max=40.000000))
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=122.000000,Max=122.000000),Y=(Min=122.000000,Max=122.000000),Z=(Min=122.000000,Max=122.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Max=0.100000)
     End Object
     Emitters(6)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter4'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Acceleration=(Z=40.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.600000,Max=0.600000))
         Opacity=0.800000
         FadeOutStartTime=0.380000
         MaxParticles=2
         StartLocationRange=(Z=(Min=511.000000,Max=511.000000))
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=128.000000,Max=128.000000),Y=(Min=128.000000,Max=128.000000),Z=(Min=128.000000,Max=128.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Min=0.200000,Max=0.500000)
     End Object
     Emitters(7)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter9
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Acceleration=(Z=10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.600000,Max=0.600000))
         Opacity=0.610000
         FadeOutStartTime=0.380000
         MaxParticles=2
         StartLocationRange=(Z=(Min=371.000000,Max=371.000000))
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=131.000000,Max=131.000000),Y=(Min=131.000000,Max=131.000000),Z=(Min=131.000000,Max=131.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp7_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=3.300000,Max=3.300000)
         InitialDelayRange=(Min=0.400000,Max=0.400000)
     End Object
     Emitters(8)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter9'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter11
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         BlendBetweenSubdivisions=True
         Acceleration=(Z=40.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.600000,Max=0.600000))
         Opacity=0.390000
         FadeOutStartTime=0.360000
         FadeInEndTime=0.140000
         StartLocationRange=(X=(Min=-490.000000,Max=490.000000),Y=(Min=-490.000000,Max=490.000000),Z=(Min=566.000000,Max=729.000000))
         SpinsPerSecondRange=(X=(Min=0.100000,Max=0.100000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=93.000000,Max=93.000000),Y=(Min=93.000000,Max=93.000000),Z=(Min=93.000000,Max=93.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'ExplosionTex.Framed.exp2_frames'
         TextureUSubdivisions=4
         TextureVSubdivisions=4
         LifetimeRange=(Min=2.000000,Max=2.000000)
         InitialDelayRange=(Min=0.700000,Max=0.700000)
     End Object
     Emitters(9)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter11'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter12
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=286.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.900000,Max=0.900000),Z=(Min=0.800000,Max=0.800000))
         Opacity=0.410000
         FadeOutStartTime=0.234000
         MaxParticles=2
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=12.000000)
         StartSizeRange=(X=(Min=145.000000,Max=145.000000),Y=(Min=145.000000,Max=145.000000),Z=(Min=145.000000,Max=145.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.BurnFlare1'
         LifetimeRange=(Min=2.300000,Max=2.300000)
     End Object
     Emitters(10)=SpriteEmitter'UT2341Weapons_BETA3.FX_RedeemerExplosion.SpriteEmitter12'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     RemoteRole=ROLE_DumbProxy
     Style=STY_Masked
     bDirectional=True
}
