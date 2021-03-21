class DamType_Pulse extends WeaponDamageType
	abstract;

static function GetHitEffects(out class<xEmitter> HitEffects[4], int VictemHealth )
{
    HitEffects[0] = class'HitSmoke';
}

defaultproperties
{
     WeaponClass=Class'UT2341Weapons_BETA3.UT2341PulseGun'
     DeathString="%o ate %k's burning plasma death."
     FemaleSuicide="%o fried herself with her own plasma blast."
     MaleSuicide="%o fried himself with his own plasma blast."
     bDetonatesGoop=True
     bDelayedDamage=True
     FlashFog=(X=700.000000)
     DamageOverlayMaterial=Shader'XGameShaders.PlayerShaders.LinkHit'
     DamageOverlayTime=0.500000
     VehicleDamageScaling=0.670000
}
