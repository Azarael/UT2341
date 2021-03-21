class FX_PickupRespawn extends Emitter;

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	if ( Level.NetMode == NM_DedicatedServer )
		LifeSpan = 0.15;
	else if ( Level.GetLocalPlayerController().BeyondViewDistance(Location, CullDistance)  )
		LifeSpan = 0.01;
	else
		PlaySound(sound'WeaponSounds.item_respawn');
}

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter1
         UseCollision=True
         FadeOut=True
         RespawnDeadParticles=False
         SpinParticles=True
         UseSizeScale=True
         UniformSize=True
         AutomaticInitialSpawning=False
         Acceleration=(Z=3.000000)
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         FadeOutStartTime=0.220000
         MaxParticles=14
         StartLocationRange=(X=(Min=-20.000000,Max=20.000000),Y=(Min=-20.000000,Max=20.000000),Z=(Min=-12.000000,Max=12.000000))
         SpinCCWorCW=(X=0.750000)
         SpinsPerSecondRange=(X=(Min=0.500000,Max=1.000000),Y=(Min=0.500000,Max=1.000000),Z=(Min=0.500000,Max=1.000000))
         StartSpinRange=(X=(Max=1.000000),Y=(Max=1.000000),Z=(Max=1.000000))
         SizeScaleRepeats=1.000000
         StartSizeRange=(X=(Min=16.000000,Max=16.000000),Y=(Min=16.000000,Max=16.000000),Z=(Min=16.000000,Max=16.000000))
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'AW-2004Particles.Weapons.PlasmaStar'
         LifetimeRange=(Min=1.200000,Max=1.200000)
         InitialDelayRange=(Min=0.400000,Max=0.400000)
         StartVelocityRange=(X=(Min=-8.000000,Max=8.000000),Y=(Min=-8.000000,Max=8.000000))
     End Object
     Emitters(0)=SpriteEmitter'UT2341Weapons_BETA3.FX_PickupRespawn.SpriteEmitter1'

     AutoDestroy=True
     bNoDelete=False
}
