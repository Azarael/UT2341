/*************************************************************
*
*
*
*************************************************************/

class FX_ShockRifleComboVortex extends Emitter;





/*



    Begin Map
    Begin Actor Class=Emitter Name=Emitter1
        Begin Object Class=MeshEmitter Name=MeshEmitter0
            StaticMesh=StaticMesh'Editor.TexPropSphere'
            UseMeshBlendMode=False
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.400000,Max=0.400000))
            Opacity=0.160000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="BallExplosion"
            StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
            SizeScale(0)=(RelativeTime=0.680000,RelativeSize=2.500000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
            StartSizeRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.400000,Max=0.400000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(0)=MeshEmitter'myLevel.Emitter1.MeshEmitter0'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter3
            StaticMesh=StaticMesh'Editor.TexPropSphere'
            UseMeshBlendMode=False
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
            Opacity=0.160000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="BallInnerExplosion"
            StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
            SizeScale(0)=(RelativeTime=0.620000,RelativeSize=2.500000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
            StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(1)=MeshEmitter'myLevel.Emitter1.MeshEmitter3'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter4
            StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
            Opacity=0.400000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="VortexInnerSwirl"
            SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
            StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Max=1.000000),Z=(Min=1.000000,Max=1.000000))
            SizeScale(0)=(RelativeTime=0.620000,RelativeSize=2.000000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
            StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(2)=MeshEmitter'myLevel.Emitter1.MeshEmitter4'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter5
            StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
            Opacity=0.400000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="VortexSwirl"
            SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
            StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
            SizeScale(0)=(RelativeTime=0.750000,RelativeSize=2.000000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
            StartSizeRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(3)=MeshEmitter'myLevel.Emitter1.MeshEmitter5'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter6
            StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
            Opacity=0.190000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="VortexOuterSwirl"
            SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
            StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
            SizeScale(0)=(RelativeTime=0.750000,RelativeSize=2.600000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
            StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(4)=MeshEmitter'myLevel.Emitter1.MeshEmitter6'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter7
            StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000))
            Opacity=0.190000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="VortexOuterSwirl2"
            SpinsPerSecondRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
            StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.700000)
            StartSizeRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.900000,Max=0.900000),Z=(Min=0.900000,Max=0.900000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(5)=MeshEmitter'myLevel.Emitter1.MeshEmitter7'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter8
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
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="SmallBall"
            StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
            SizeScale(0)=(RelativeTime=0.170000,RelativeSize=4.000000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=17.000000)
            StartSizeRange=(X=(Min=0.040000,Max=0.040000),Y=(Min=0.040000,Max=0.040000),Z=(Min=0.040000,Max=0.040000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(6)=MeshEmitter'myLevel.Emitter1.MeshEmitter8'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter9
            StaticMesh=StaticMesh'Editor.TexPropSphere'
            UseMeshBlendMode=False
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000))
            Opacity=0.150000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="Ball2"
            StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
            SizeScale(0)=(RelativeTime=0.370000,RelativeSize=2.000000)
            SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
            StartSizeRange=(X=(Min=0.390000,Max=0.390000),Y=(Min=0.390000,Max=0.390000),Z=(Min=0.390000,Max=0.390000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(7)=MeshEmitter'myLevel.Emitter1.MeshEmitter9'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter10
            StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.390000,Max=0.390000),Z=(Min=0.700000,Max=0.700000))
            Opacity=0.680000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="ShockWave"
            StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
            StartSizeRange=(X=(Min=1.200000,Max=1.200000),Y=(Min=1.200000,Max=1.200000),Z=(Min=0.100000,Max=0.100000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(8)=MeshEmitter'myLevel.Emitter1.MeshEmitter10'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter11
            StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.440000,Max=0.440000),Z=(Min=0.600000,Max=0.600000))
            Opacity=0.150000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="Shockwave2"
            StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
            StartSizeRange=(X=(Min=1.100000,Max=1.100000),Y=(Min=1.100000,Max=1.100000),Z=(Min=0.100000,Max=0.100000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(9)=MeshEmitter'myLevel.Emitter1.MeshEmitter11'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter0
            RespawnDeadParticles=False
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.400000,Max=0.400000))
            Opacity=0.480000
            MaxParticles=1
            Name="Flare"
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'EpicParticles.Flares.FlashFlare1'
            LifetimeRange=(Min=0.500000,Max=0.500000)
        End Object
        Emitters(10)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter0'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter1
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.300000,Max=0.300000))
            Opacity=0.190000
            MaxParticles=1
            Name="Flare2"
            SpinsPerSecondRange=(X=(Max=0.400000))
            StartSpinRange=(X=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=180.000000,Max=180.000000),Y=(Min=180.000000,Max=180.000000),Z=(Min=180.000000,Max=180.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'EpicParticles.Flares.FlashFlare1'
            LifetimeRange=(Min=0.500000,Max=0.500000)
        End Object
        Emitters(11)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter1'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter2
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
            Opacity=0.490000
            FadeOutStartTime=0.280000
            MaxParticles=1
            Name="FlareWhole"
            SpinsPerSecondRange=(X=(Max=0.200000))
            StartSpinRange=(X=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=220.000000,Max=220.000000),Y=(Min=220.000000,Max=220.000000),Z=(Min=220.000000,Max=220.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(12)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter2'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter3
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.400000,Max=0.400000))
            Opacity=0.080000
            MaxParticles=1
            Name="FlareFinal"
            SpinsPerSecondRange=(X=(Max=0.200000))
            StartSpinRange=(X=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=210.000000,Max=210.000000),Y=(Min=210.000000,Max=210.000000),Z=(Min=210.000000,Max=210.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'AW-2004Particles.Energy.PurpleSwell'
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(13)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter3'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter4
            UseDirectionAs=PTDU_Normal
            ProjectionNormal=(X=40.000000)
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.000000,Max=0.600000),Y=(Min=0.700000,Max=0.700000))
            Opacity=0.200000
            FadeOutStartTime=0.340000
            MaxParticles=1
            Name="RingTex"
            SpinsPerSecondRange=(X=(Min=0.300000,Max=0.330000))
            StartSpinRange=(X=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
            StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=150.000000,Max=150.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'AW-2004Particles.Fire.BlastMark'
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(14)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter4'
     
        Begin Object Class=MeshEmitter Name=MeshEmitter12
            StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
            RenderTwoSided=True
            UseParticleColor=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.100000,Max=0.100000),Z=(Min=0.500000,Max=0.500000))
            Opacity=0.200000
            FadeOutStartTime=0.370000
            MaxParticles=1
            Name="ShockwaveInner"
            StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
            StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.230000,Max=0.230000))
            InitialParticlesPerSecond=10.000000
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(15)=MeshEmitter'myLevel.Emitter1.MeshEmitter12'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter5
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000))
            FadeOutStartTime=0.280000
            MaxParticles=1
            Name="ShockVortexSpin"
            SpinsPerSecondRange=(X=(Min=0.800000,Max=1.000000))
            StartSpinRange=(X=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=240.000000,Max=240.000000),Y=(Min=240.000000,Max=240.000000),Z=(Min=240.000000,Max=240.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'AW-2004Particles.Energy.BurnFlare'
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(16)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter5'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter6
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
            Opacity=0.400000
            FadeOutStartTime=0.280000
            MaxParticles=1
            Name="Vortex2"
            SpinsPerSecondRange=(X=(Min=-1.000000,Max=-1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
            StartSizeRange=(X=(Min=240.000000,Max=240.000000),Y=(Min=240.000000,Max=240.000000),Z=(Min=240.000000,Max=240.000000))
            InitialParticlesPerSecond=10.000000
            Texture=Texture'AW-2004Particles.Energy.BurnFlare'
            LifetimeRange=(Min=1.000000,Max=1.000000)
        End Object
        Emitters(17)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter6'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter8
            UseCollision=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            Acceleration=(X=-10.000000,Y=-10.000000,Z=-10.000000)
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.600000,Max=0.600000))
            FadeOutStartTime=0.496000
            MaxParticles=18
            Name="Sparks"
            SpinCCWorCW=(X=0.750000)
            SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
            StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.100000)
            SizeScaleRepeats=6.000000
            StartSizeRange=(X=(Min=17.000000,Max=17.000000),Y=(Min=17.000000,Max=17.000000),Z=(Min=17.000000,Max=17.000000))
            InitialParticlesPerSecond=5000.000000
            Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
            LifetimeRange=(Min=1.600000,Max=1.600000)
            StartVelocityRange=(X=(Min=-270.000000,Max=270.000000),Y=(Min=-270.000000,Max=270.000000),Z=(Min=-270.000000,Max=270.000000))
        End Object
        Emitters(18)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter8'
     
        Begin Object Class=SpriteEmitter Name=SpriteEmitter7
            UseCollision=True
            FadeOut=True
            RespawnDeadParticles=False
            SpinParticles=True
            UseSizeScale=True
            UseRegularSizeScale=False
            UniformSize=True
            AutomaticInitialSpawning=False
            Acceleration=(X=-10.000000,Y=-10.000000,Z=-10.000000)
            ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
            ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
            ColorMultiplierRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.600000,Max=0.600000))
            FadeOutStartTime=0.816000
            MaxParticles=15
            Name="Sparks2"
            SpinCCWorCW=(X=0.750000)
            SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
            StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
            SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.100000)
            SizeScaleRepeats=6.000000
            StartSizeRange=(X=(Min=17.000000,Max=17.000000),Y=(Min=17.000000,Max=17.000000),Z=(Min=17.000000,Max=17.000000))
            InitialParticlesPerSecond=5000.000000
            Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
            LifetimeRange=(Min=1.600000,Max=1.600000)
            StartVelocityRange=(X=(Min=-110.000000,Max=110.000000),Y=(Min=-110.000000,Max=110.000000),Z=(Min=-110.000000,Max=110.000000))
        End Object
        Emitters(19)=SpriteEmitter'myLevel.Emitter1.SpriteEmitter7'
     
        bLightChanged=True
        Level=LevelInfo'myLevel.LevelInfo0'
        Region=(Zone=LevelInfo'myLevel.LevelInfo0',ZoneNumber=1)
        Tag="Emitter"
        PhysicsVolume=DefaultPhysicsVolume'myLevel.DefaultPhysicsVolume0'
        Location=(X=-55.284935,Y=-242.478378,Z=96.000000)
        bUnlit=False
        CollisionRadius=1144.854126
        CollisionHeight=809.534119
        ColLocation=(X=71.000000,Y=-16.000000)
        bSelected=True
    End Actor
    Begin Surface
    End Surface
    End Map



*/

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'Editor.TexPropSphere'
         UseMeshBlendMode=False
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.400000,Max=0.400000))
         Opacity=0.250000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.680000,RelativeSize=2.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.400000,Max=0.400000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(0)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter3
         StaticMesh=StaticMesh'Editor.TexPropSphere'
         UseMeshBlendMode=False
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
         Opacity=0.160000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.650000,RelativeSize=2.500000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=0.100000,Max=0.100000),Y=(Min=0.100000,Max=0.100000),Z=(Min=0.100000,Max=0.100000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(1)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter3'

     Begin Object Class=MeshEmitter Name=MeshEmitter4
         StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
         Opacity=0.400000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Y=(Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.620000,RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.600000,Max=0.600000),Y=(Min=0.600000,Max=0.600000),Z=(Min=0.600000,Max=0.600000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(2)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter5
         StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
         Opacity=0.400000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
         SizeScale(0)=(RelativeTime=0.760000,RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=4.000000)
         StartSizeRange=(X=(Min=0.700000,Max=0.700000),Y=(Min=0.700000,Max=0.700000),Z=(Min=0.700000,Max=0.700000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(3)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter5'

     Begin Object Class=MeshEmitter Name=MeshEmitter6
         StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
         Opacity=0.190000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=5.000000,Max=5.000000),Y=(Min=5.000000,Max=5.000000),Z=(Min=5.000000,Max=5.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
         SizeScale(0)=(RelativeTime=0.790000,RelativeSize=2.600000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=5.000000)
         StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(4)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter6'

     Begin Object Class=MeshEmitter Name=MeshEmitter7
         StaticMesh=StaticMesh'XGame_rc.BombEffectMesh'
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.600000,Max=0.600000))
         Opacity=0.190000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=3.000000,Max=3.000000),Y=(Min=3.000000,Max=3.000000),Z=(Min=3.000000,Max=3.000000))
         StartSpinRange=(X=(Min=-1.000000,Max=-1.000000),Y=(Min=-1.000000,Max=-1.000000),Z=(Min=-1.000000,Max=-1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.700000)
         StartSizeRange=(X=(Min=0.900000,Max=0.900000),Y=(Min=0.900000,Max=0.900000),Z=(Min=0.900000,Max=0.900000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(5)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter7'

     Begin Object Class=MeshEmitter Name=MeshEmitter8
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
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.600000,Max=0.600000))
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.220000,RelativeSize=4.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=17.000000)
         StartSizeRange=(X=(Min=0.040000,Max=0.040000),Y=(Min=0.040000,Max=0.040000),Z=(Min=0.040000,Max=0.040000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(6)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter8'

     Begin Object Class=MeshEmitter Name=MeshEmitter9
         StaticMesh=StaticMesh'Editor.TexPropSphere'
         UseMeshBlendMode=False
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.400000,Max=0.400000))
         Opacity=0.150000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=1.000000,Max=1.000000),Z=(Min=1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.390000,RelativeSize=2.000000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=6.000000)
         StartSizeRange=(X=(Min=0.390000,Max=0.390000),Y=(Min=0.390000,Max=0.390000),Z=(Min=0.390000,Max=0.390000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(7)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter9'

     Begin Object Class=MeshEmitter Name=MeshEmitter10
         StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.100000,Max=0.100000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.730000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=1.200000,Max=1.200000),Y=(Min=1.200000,Max=1.200000),Z=(Min=0.100000,Max=0.100000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(8)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter10'

     Begin Object Class=MeshEmitter Name=MeshEmitter11
         StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.100000,Max=0.100000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.200000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=1.100000,Max=1.100000),Y=(Min=1.100000,Max=1.100000),Z=(Min=0.100000,Max=0.100000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(9)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter11'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter0
         RespawnDeadParticles=False
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Y=(Min=0.400000,Max=0.400000))
         Opacity=0.480000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=50.000000,Max=50.000000),Y=(Min=50.000000,Max=50.000000),Z=(Min=50.000000,Max=50.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(10)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter0'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.300000,Max=0.300000))
         Opacity=0.190000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=0.400000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=180.000000,Max=180.000000),Y=(Min=180.000000,Max=180.000000),Z=(Min=180.000000,Max=180.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.500000,Max=0.500000)
     End Object
     Emitters(11)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter1'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.490000
         FadeOutStartTime=0.280000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=220.000000,Max=220.000000),Y=(Min=220.000000,Max=220.000000),Z=(Min=220.000000,Max=220.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar2'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(12)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.400000,Max=0.400000))
         Opacity=0.080000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Max=0.200000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=210.000000,Max=210.000000),Y=(Min=210.000000,Max=210.000000),Z=(Min=210.000000,Max=210.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.PurpleSwell'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(13)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter3'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter4
         UseDirectionAs=PTDU_Normal
         ProjectionNormal=(X=40.000000)
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.600000),Y=(Min=0.700000,Max=0.700000))
         Opacity=0.200000
         FadeOutStartTime=0.340000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.300000,Max=0.330000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=150.000000,Max=150.000000),Y=(Min=150.000000,Max=150.000000),Z=(Min=150.000000,Max=150.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Fire.BlastMark'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(14)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter4'

     Begin Object Class=MeshEmitter Name=MeshEmitter12
         StaticMesh=StaticMesh'ParticleMeshes.Complex.IonSphere'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.100000,Max=0.100000),Z=(Min=0.500000,Max=0.500000))
         Opacity=0.200000
         FadeOutStartTime=0.370000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         StartSpinRange=(X=(Min=0.250000,Max=0.250000),Y=(Min=1.000000,Max=1.000000),Z=(Min=0.250000,Max=0.250000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.500000)
         StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.230000,Max=0.230000))
         InitialParticlesPerSecond=1000.000000
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(15)=MeshEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.MeshEmitter12'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter5
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         FadeOutStartTime=0.280000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.800000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=240.000000,Max=240.000000),Y=(Min=240.000000,Max=240.000000),Z=(Min=240.000000,Max=240.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(16)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter5'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter6
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.500000,Max=0.500000),Y=(Min=0.500000,Max=0.500000))
         Opacity=0.400000
         FadeOutStartTime=0.280000
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=-1.000000,Max=-1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=240.000000,Max=240.000000),Y=(Min=240.000000,Max=240.000000),Z=(Min=240.000000,Max=240.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Energy.BurnFlare'
         LifetimeRange=(Min=1.000000,Max=1.000000)
     End Object
     Emitters(17)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter6'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter8
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(X=-10.000000,Y=-10.000000,Z=-10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.400000,Max=0.400000),Y=(Min=0.600000,Max=0.600000))
         FadeOutStartTime=0.512000
         MaxParticles=24
         SpinCCWorCW=(X=0.750000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeTime=0.140000,RelativeSize=0.100000)
         SizeScaleRepeats=1.000000
         StartSizeRange=(X=(Min=17.000000,Max=17.000000),Y=(Min=17.000000,Max=17.000000),Z=(Min=17.000000,Max=17.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=1.600000,Max=1.600000)
         StartVelocityRange=(X=(Min=-200.000000,Max=200.000000),Y=(Min=-200.000000,Max=200.000000),Z=(Min=-200.000000,Max=200.000000))
     End Object
     Emitters(18)=SpriteEmitter'UT2341Weapons_BETA3.FX_ShockRifleComboVortex.SpriteEmitter8'

     AutoDestroy=True
     bNoDelete=False
     bNetInitialRotation=True
}
