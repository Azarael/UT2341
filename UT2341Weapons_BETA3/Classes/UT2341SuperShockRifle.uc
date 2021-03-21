/*************************************************************
*
*
*
*************************************************************/

class UT2341SuperShockRifle extends UT2341ShockRifle;

defaultproperties
{
     EffectColor=(B=0,G=100,R=255)
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341SuperShockRifleBeamFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341SuperShockRifleBeamFire'
     HudColor=(B=0,G=100,R=255)
     PickupClass=Class'UT2341Weapons_BETA3.UT2341SuperShockRiflePickup'
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341SuperShockRifleAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_SuperShockRifle'
     ItemName="Super Shock Rifle"
     LightHue=30
     Skins(0)=Shader'UT2341Weapons_Tex.ASMD-Weapon.InstagibShader'
}
