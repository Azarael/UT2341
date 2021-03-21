//========================================================================
// EONSSniperRifle
// EONS Sniper Rifle by Wail of Suicide
// The EONS Sniper Rifle is intended to perform as the UT2004 Lightning Gun(Sniper Rifle) but utilizing the appearance of the Classic Sniper Rifle. Additionally, the smoke associated with the Classic Sniper Rifle has been removed and an improved projectile-impact emitter has been implemented to help in both aiming and determining the location of snipers. Firing sounds for the EONS Sniper Rifle are taken from Unreal Tournament Game of the Year Edition.
//
// Credit goes to Mr. Evil for the approach taken from his Helios weapon (Weapons of Evil pack) for Headshot detection on Monsters
// Feel free to use this content in any maps you create, but please provide credit in the readme.
// Contact: wailofsuicide@gmail.com - Comments and suggestions welcome.
//========================================================================

// O Damage Overlay on Hit
// O Look into Monster headshot detection

class UT2341SniperRifle extends ClassicSniperRifle
   config(user);

#EXEC OBJ LOAD FILE=WeaponSounds.uax
//#exec AUDIO IMPORT FILE="Sounds\SniperFire.wav" NAME="SniperFire" GROUP="Sniper"
//#exec TEXTURE IMPORT FILE="Textures\gold_beam.dds" NAME="gold_beam" GROUP="Sniper"
//#exec TEXTURE IMPORT FILE="Textures\EONSSniper1.dds" NAME="EONSSniper1" GROUP="Sniper"
//#exec TEXTURE IMPORT FILE="Textures\EONSSniper2.dds" NAME="EONSSniper2" GROUP="Sniper"

simulated function bool WeaponCentered()
{
	if (Zoomed)
		return true;
	return Super.WeaponCentered();
}

simulated function Vector GetEffectStart()
{
	return GetBoneCoords('tip').Origin;
}

simulated event RenderOverlays( Canvas Canvas )
{
   local float CX,CY,Scale;
   local float ChargeBar;
   local float barOrgX, barOrgY;
   local float barSizeX, barSizeY;

   if ( PlayerController(Instigator.Controller) == None )
   {
      Super.RenderOverlays(Canvas);
      Zoomed = false;
      return;
   }

   if ( LastFOV > PlayerController(Instigator.Controller).DesiredFOV )
   {
      PlaySound(Sound'AssaultSounds.TargetCycle01', SLOT_Misc,,,,0.2,false);
   }
   else if ( LastFOV < PlayerController(Instigator.Controller).DesiredFOV )
   {
      PlaySound(Sound'WeaponSounds.FlakCannonReload', SLOT_Misc,,,,1.2,false);  //Sound'WeaponSounds.FlakCannon.FlakCannonReload' //Sound'WeaponSounds.LightningGun.LightningZoomOut
   }
   LastFOV = PlayerController(Instigator.Controller).DesiredFOV;

   if ( PlayerController(Instigator.Controller).DesiredFOV == PlayerController(Instigator.Controller).DefaultFOV )
   {
      Super.RenderOverlays(Canvas);
      Zoomed = false;
   }
   else
   {
      if ( FireMode[0].NextFireTime <= Level.TimeSeconds )
      {
         ChargeBar = 1.0;
      }
      else
      {
         ChargeBar = 1.0 - ((FireMode[0].NextFireTime-Level.TimeSeconds) / FireMode[0].FireRate);
      }

      CX = Canvas.ClipX/2;
      CY = Canvas.ClipY/2;
      Scale = Canvas.ClipX/1024;

      Canvas.Style = ERenderStyle.STY_Alpha;
      Canvas.SetDrawColor(0,0,0);

      // Draw the crosshair
      Canvas.SetPos(CX-169*Scale,CY-155*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 164,35, 169,310);
      Canvas.SetPos(CX,CY-155*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',169*Scale,310*Scale, 332,345, -169,-310);

      // Draw Cornerbars
      Canvas.SetPos(160*Scale,160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 0 , 0, 111, 111);

      Canvas.SetPos(Canvas.ClipX-271*Scale,160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 0, -111, 111);

      Canvas.SetPos(160*Scale,Canvas.ClipY-271*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale, 0 , 111, 111, -111);

      Canvas.SetPos(Canvas.ClipX-271*Scale,Canvas.ClipY-271*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 111*Scale, 111*Scale , 111 , 111, -111, -111);

      // Draw the 4 corners
      Canvas.SetPos(0,0);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0, 274, 159, -158);

      Canvas.SetPos(Canvas.ClipX-160*Scale,0);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159,274, -159, -158);

      Canvas.SetPos(0,Canvas.ClipY-160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 0,116, 159, 158);

      Canvas.SetPos(Canvas.ClipX-160*Scale,Canvas.ClipY-160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair',160*Scale,160*Scale, 159, 116, -159, 158);

      // Draw the Horz Borders
      Canvas.SetPos(160*Scale,0);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 512, 32, -160);

      Canvas.SetPos(160*Scale,Canvas.ClipY-160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', Canvas.ClipX-320*Scale, 160*Scale, 284, 352, 32, 160);

      // Draw the Vert Borders
      Canvas.SetPos(0,160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 0,308, 160,32);

      Canvas.SetPos(Canvas.ClipX-160*Scale,160*Scale);
      Canvas.DrawTile(texture'NewSniperRifle.COGAssaultZoomedCrosshair', 160*Scale, Canvas.ClipY-320*Scale, 160,308, -160,32);

      // Draw the Charging meter
      Canvas.DrawColor = ChargeColor;
      Canvas.DrawColor.A = 255;

      if (ChargeBar <1)
         Canvas.DrawColor.R = 255*ChargeBar;
      else
      {
         Canvas.DrawColor.R = 0;
         Canvas.DrawColor.B = 0;
      }

      if (ChargeBar == 1)
         Canvas.DrawColor.G = 255;
      else
         Canvas.DrawColor.G = 0;

      Canvas.Style = ERenderStyle.STY_Alpha;
      Canvas.SetPos( barOrgX, barOrgY );
      Canvas.DrawTile(Texture'Engine.WhiteTexture',barSizeX,barSizeY*chargeBar, 0.0, 0.0,Texture'Engine.WhiteTexture'.USize,Texture'Engine.WhiteTexture'.VSize*chargeBar);
      zoomed = true;
   }
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341SniperRifleFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341SniperZoomFire'
     SelectAnim="Select"
     SelectAnimRate=1.200000
     PutDownAnimRate=1.200000
     SelectSound=Sound'UT2341Weapons_Sounds.Sniper.RiflePickup'
     Description="Classification: Long Range Ballistic||Regular Fire: Fires a high powered bullet. Can kill instantly when applied to the cranium of opposing forces. ||Secondary Fire: Zooms the rifle in, up to eight times normal vision. Allows for extreme precision from hundreds of yards away.||Techniques: Great for long distance headshots!"
     EffectOffset=(Y=31.000000,Z=-5.000000)
     DisplayFOV=80.000000
     Priority=60
     SmallViewOffset=(X=30.000000,Z=-15.600000)
     InventoryGroup=0
     GroupOffset=0
     PickupClass=Class'UT2341Weapons_BETA3.UT2341SniperRiflePickup'
     PlayerViewOffset=(X=0.000000,Y=-3.000000,Z=-22.000000)
     PlayerViewPivot=(Pitch=256,Yaw=-256)
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341SniperRifleAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_SniperRifle'
     IconCoords=(X1=0,Y1=0,X2=128,Y2=32)
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTSniper_FP'
     DrawScale=3.000000
     HighDetailOverlay=None
}
