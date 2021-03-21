/*************************************************************
*
*
*
*************************************************************/

class FX_PulseBeamFlash3rd extends Emitter;

defaultproperties
{
     Begin Object Class=SpriteEmitter Name=SpriteEmitter13
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.200000,Max=0.200000),Z=(Min=0.000000,Max=0.000000))
         Opacity=0.240000
         FadeOutStartTime=0.110550
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.300000,Max=0.300000))
         SizeScale(0)=(RelativeTime=0.370000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=36.000000,Max=36.000000),Y=(Min=36.000000,Max=36.000000),Z=(Min=25.000000,Max=25.000000))
         ParticlesPerSecond=5.000000
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'EpicParticles.Flares.FlashFlare1'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(0)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamFlash3rd.SpriteEmitter13'

     Begin Object Class=SpriteEmitter Name=SpriteEmitter14
         FadeOut=True
         SpinParticles=True
         UseSizeScale=True
         UseRegularSizeScale=False
         UniformSize=True
         AutomaticInitialSpawning=False
         TriggerDisabled=False
         ColorScale(0)=(Color=(B=255,G=255,R=255,A=255))
         ColorScale(1)=(RelativeTime=1.000000,Color=(B=255,G=255,R=255,A=255))
         ColorMultiplierRange=(X=(Min=0.000000,Max=0.000000),Y=(Min=0.400000,Max=0.400000),Z=(Min=0.000000))
         Opacity=0.370000
         FadeOutStartTime=0.110550
         CoordinateSystem=PTCS_Relative
         MaxParticles=1
         SpinsPerSecondRange=(X=(Min=0.500000,Max=0.500000))
         SizeScale(0)=(RelativeTime=0.140000,RelativeSize=2.000000)
         StartSizeRange=(X=(Min=18.000000,Max=18.000000),Y=(Min=18.000000,Max=18.000000),Z=(Min=18.000000,Max=18.000000))
         ParticlesPerSecond=5.000000
         InitialParticlesPerSecond=1000.000000
         Texture=Texture'XEffects.Skins.MuzFlashRocket_t'
         LifetimeRange=(Min=0.200000,Max=0.200000)
     End Object
     Emitters(1)=SpriteEmitter'UT2341Weapons_BETA3.FX_PulseBeamFlash3rd.SpriteEmitter14'

     bNoDelete=False
     bHardAttach=True
}
