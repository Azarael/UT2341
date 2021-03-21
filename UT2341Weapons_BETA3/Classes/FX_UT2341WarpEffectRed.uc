class FX_UT2341WarpEffectRed extends Emitter;

function PostBeginPlay()
{
	If ( Role == ROLE_Authority )
		Instigator = Pawn(Owner);
	if ( Level.NetMode == NM_DedicatedServer )
		LifeSpan = 0.15;
	Super.PostBeginPlay();
}

simulated function PostNetBeginPlay()
{
	local PlayerController PC;
	local float Dist;
	
	if ( Instigator != None )
	{
		SetLocation(Instigator.Location);
		SetBase(Instigator);
		if ( (Level.NetMode == NM_Standalone) || (Level.NetMode == NM_Client) )
		{
			PC = Level.GetLocalPlayerController();
			if ( (PC != None) && (PC.ViewTarget != None) )
			{
				Dist = VSize(PC.ViewTarget.Location - Location);
				if ( Dist > PC.Region.Zone.DistanceFogEnd )
					LifeSpan = 0.01;
			}
		}
	}
    PlaySound(Sound'UT2341Weapons_Sounds.General.Resp2a',SLOT_None);
	Super.PostNetBeginPlay();
}

defaultproperties
{
     Begin Object Class=MeshEmitter Name=MeshEmitter0
         StaticMesh=StaticMesh'XEffects.TeleRing'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=12.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.190000,Max=0.190000),Z=(Min=0.080000,Max=0.080000))
         FadeOutStartTime=0.800000
         MaxParticles=3
         SpinCCWorCW=(Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000),Z=(Min=0.010000,Max=0.020000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=1.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=0.800000,Max=0.800000),Y=(Min=0.800000,Max=0.800000),Z=(Min=0.800000,Max=0.800000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
     End Object
     Emitters(0)=MeshEmitter'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed.MeshEmitter0'

     Begin Object Class=MeshEmitter Name=MeshEmitter1
         StaticMesh=StaticMesh'XEffects.TeleRing'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=12.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.190000,Max=0.190000),Z=(Min=0.080000,Max=0.080000))
         FadeOutStartTime=1.000000
         FadeInEndTime=0.120000
         MaxParticles=3
         StartLocationRange=(Z=(Min=40.000000,Max=40.000000))
         SpinCCWorCW=(Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000),Z=(Min=0.010000,Max=0.020000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=1.100000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Max=0.100000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
     End Object
     Emitters(1)=MeshEmitter'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed.MeshEmitter1'

     Begin Object Class=MeshEmitter Name=MeshEmitter2
         StaticMesh=StaticMesh'XEffects.TeleRing'
         RenderTwoSided=True
         UseParticleColor=True
         FadeOut=True
         FadeIn=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         AutomaticInitialSpawning=False
         Acceleration=(Z=12.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.190000,Max=0.190000),Z=(Min=0.080000,Max=0.080000))
         FadeOutStartTime=1.000000
         FadeInEndTime=0.120000
         MaxParticles=3
         StartLocationRange=(Z=(Min=-40.000000,Max=-40.000000))
         SpinCCWorCW=(Y=0.000000,Z=0.000000)
         SpinsPerSecondRange=(X=(Min=1.000000,Max=2.000000),Z=(Min=0.010000,Max=0.020000))
         StartSpinRange=(X=(Min=-1.000000,Max=1.000000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=1.050000)
         SizeScale(1)=(RelativeTime=1.000000,RelativeSize=1.200000)
         StartSizeRange=(X=(Min=0.750000,Max=0.750000),Y=(Min=0.750000,Max=0.750000),Z=(Min=0.750000,Max=0.750000))
         InitialParticlesPerSecond=5000.000000
         LifetimeRange=(Min=1.250000,Max=1.250000)
         InitialDelayRange=(Max=0.100000)
         StartVelocityRange=(Z=(Min=-10.000000,Max=-10.000000))
     End Object
     Emitters(2)=MeshEmitter'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed.MeshEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter2
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(X=10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         Opacity=0.800000
         FadeOutFactor=(Z=0.000000)
         FadeOutStartTime=1.360000
         MaxParticles=15
         StartLocationRange=(X=(Min=-20.100000,Max=20.100000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-60.000000,Max=60.000000))
         SpinCCWorCW=(X=0.750000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=16.000000,Max=16.000000),Y=(Min=16.000000,Max=16.000000),Z=(Min=16.000000,Max=16.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=1.300000,Max=1.300000)
         StartVelocityRange=(X=(Min=-30.000000,Max=40.000000),Y=(Min=-60.000000,Max=60.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(3)=SpriteEmitter'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed.SpriteEmitter2'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter3
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(X=10.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(Y=(Min=0.600000,Max=0.600000),Z=(Min=0.400000,Max=0.400000))
         Opacity=0.800000
         FadeOutStartTime=0.400000
         MaxParticles=15
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-30.000000,Max=30.000000),Z=(Min=-60.000000,Max=60.000000))
         SpinCCWorCW=(X=0.750000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScale(0)=(RelativeTime=1.000000,RelativeSize=0.100000)
         StartSizeRange=(X=(Min=21.000000,Max=21.000000),Y=(Min=21.000000,Max=21.000000),Z=(Min=21.000000,Max=21.000000))
         InitialParticlesPerSecond=5000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=1.600000,Max=1.600000)
         InitialDelayRange=(Max=0.100000)
         StartVelocityRange=(X=(Min=-30.000000,Max=40.000000),Y=(Min=-60.000000,Max=60.000000),Z=(Min=-20.000000,Max=20.000000))
     End Object
     Emitters(4)=SpriteEmitter'UT2341Weapons_BETA3.FX_UT2341WarpEffectRed.SpriteEmitter3'

     AutoDestroy=True
     bNoDelete=False
     bNetTemporary=True
     bReplicateInstigator=True
     RemoteRole=ROLE_SimulatedProxy
}
