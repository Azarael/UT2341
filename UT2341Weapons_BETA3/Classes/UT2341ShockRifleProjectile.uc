/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifleProjectile extends ShockProjectile;

var FX_ShockRifleProjectile ASMDBallEffect;
var class<DamageType> ComboInstigatingDamageType;

simulated function PostBeginPlay()
{
    Super(Projectile).PostBeginPlay();

    if ( Level.NetMode != NM_DedicatedServer )
    {
        ASMDBallEffect = Spawn(class'FX_ShockRifleProjectile', self);
        ASMDBallEffect.SetBase(self);
    }

    Velocity = Speed * Vector(Rotation); // starts off slower so combo can be done closer

    SetTimer(0.4, false);
    tempStartLoc = Location;
}

function Timer()
{
    SetCollisionSize(20, 20);
}

simulated function Destroyed()
{
    if (ASMDBallEffect != None)
    {
		ASMDBallEffect.Destroy();
    }

    Super(Projectile).Destroyed();
}

simulated function DestroyTrails()
{
    if (ASMDBallEffect != None)
    {
        ASMDBallEffect.Destroy();
    }
}

// @! override explosion
simulated function Explode(vector HitLocation,vector HitNormal)
{
    if ( Role == ROLE_Authority )
    {
        HurtRadius(Damage, DamageRadius, MyDamageType, MomentumTransfer, HitLocation );
    }

    PlaySound(ImpactSound, SLOT_Misc);
    if ( EffectIsRelevant(Location,false) )
        Spawn(class'FX_ShockRifleImpact',,, Location, Rotator(HitNormal));
    SetCollisionSize(0.0, 0.0);
    Destroy();
}

// @! override Combo
function SuperExplosion()
{
    local actor HitActor;
    local vector HitLocation, HitNormal;

    HurtRadius(ComboDamage, ComboRadius, ComboDamageType, ComboMomentumTransfer, Location );

    Spawn(class'UT2341ShockRifleCombo',self,,,Rotator(Location - Instigator.Location));
    if ( (Level.NetMode != NM_DedicatedServer) && EffectIsRelevant(Location,false) )
    {
        HitActor = Trace(HitLocation, HitNormal,Location - Vect(0,0,120), Location,false);
        if ( HitActor != None )
            Spawn(class'ComboDecal',self,,HitLocation, rotator(vect(0,0,-1)));
    }
    PlaySound(ComboSound, SLOT_None,1.0,,800);
    DestroyTrails();
    Destroy();
}

event TakeDamage( int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
    if (DamageType == ComboInstigatingDamageType)
    {
        Instigator = EventInstigator;
        SuperExplosion();
        if( EventInstigator.Weapon != None )
        {
            EventInstigator.Weapon.ConsumeAmmo(0, ComboAmmoCost, true);
            Instigator = EventInstigator;
        }
    }
}

defaultproperties
{
    ComboInstigatingDamageType=Class'UT2341Weapons_BETA3.DamType_ShockRifleBeam'
    ComboDamage=250.000000
    ComboRadius=275.000000
    ComboMomentumTransfer=140000
    ComboAmmoCost=2
    ComboDamageType=Class'UT2341Weapons_BETA3.DamType_ShockRifleProjectileCombo'
    Speed=1125.000000
    MaxSpeed=1125.000000
    Damage=82.000000
    DamageRadius=70.000000
    MyDamageType=Class'UT2341Weapons_BETA3.DamType_ShockRifleProjectile'
    LightType=LT_Steady
    LightEffect=LE_NonIncidence
    LightBrightness=255
    LightHue=165
    LightSaturation=72
    LightRadius=6
    LifeSpan=10
    Texture=None
    Skins(0)=None
    ForceRadius=20.000000
    CollisionRadius=13.000000
    CollisionHeight=13.000000
}
