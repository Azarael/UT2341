class DamType_BioGel extends WeaponDamageType
	abstract;

defaultproperties
{
     WeaponClass=Class'UT2341Weapons_BETA3.UT2341BioRifle'
     DeathString="%o drank a glass of %k's dripping green load."
     FemaleSuicide="%o slimed herself."
     MaleSuicide="%o slimed himself."
     bDetonatesGoop=True
     bDelayedDamage=True
     DeathOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
}
