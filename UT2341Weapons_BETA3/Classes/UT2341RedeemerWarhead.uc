class UT2341RedeemerWarhead extends RedeemerWarhead;

#EXEC OBJ LOAD FILE=2K4Hud.utx


simulated function PostBeginPlay()
{
	local vector Dir;

	Dir = Vector(Rotation);
    Velocity = AirSpeed * Dir;
    Acceleration = Velocity;

	if ( Level.NetMode != NM_DedicatedServer)
	{
		SmokeTrail = Spawn(class'RedeemerTrail',self,,Location - 13 * Dir);
		SmokeTrail.SetBase(self);
	}
}

simulated function PostNetBeginPlay()
{
	Super(Pawn).PostNetBeginPlay();

	if ( PlayerController(Controller) != None )
	{
		Controller.SetRotation(Rotation);
		PlayerController(Controller).SetViewTarget(self);
		Controller.GotoState(LandMovementState);
		PlayOwnedSound(Sound'UT2341Weapons_Sounds.Redeemer.WarheadShot',SLOT_Interact,1.0);
	}
}
function BlowUp(vector HitLocation)
{
	local Emitter E;

	if ( Role == ROLE_Authority )
	{
		bHidden = true;
        E = Spawn(class'FX_RedeemerExplosion',,, HitLocation - 100 * Normal(Velocity), Rot(0,16384,0));
		if ( Level.NetMode == NM_DedicatedServer )
		{
			E.LifeSpan = 0.7;
		}
		GotoState('Dying');
	}
}

state Dying
{
ignores Trigger, Bump, HitWall, HeadVolumeChange, PhysicsVolumeChange, Falling, BreathTimer;

	function Fire( optional float F ) {}
	function BlowUp(vector HitLocation) {}
	function ServerBlowUp() {}
	function Timer() {}
	function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
							Vector momentum, class<DamageType> damageType) {}

    function BeginState()
    {
		bHidden = true;
		bStaticScreen = true;
		SetPhysics(PHYS_None);
		SetCollision(false,false,false);
		//Spawn(class'IonCore',,, Location, Rotation);
		if ( SmokeTrail != None )
			SmokeTrail.Destroy();
		ShakeView();
    }

    function ShakeView()
    {
        local Controller C;
        local PlayerController PC;
        local float Dist, Scale;

        for ( C=Level.ControllerList; C!=None; C=C.NextController )
        {
            PC = PlayerController(C);
            if ( PC != None && PC.ViewTarget != None )
            {
                Dist = VSize(Location - PC.ViewTarget.Location);
                if ( Dist < DamageRadius * 2.0)
                {
                    if (Dist < DamageRadius)
                        Scale = 1.0;
                    else
                        Scale = (DamageRadius*2.0 - Dist) / (DamageRadius);
                    C.ShakeView(ShakeRotMag*Scale, ShakeRotRate, ShakeRotTime, ShakeOffsetMag*Scale, ShakeOffsetRate, ShakeOffsetTime);
                }
            }
        }
    }

Begin:
	Instigator = self;
    PlaySound(sound'UT2341Weapons_Sounds.Redeemer.WarExplo');
    HurtRadius(Damage, DamageRadius*0.125, MyDamageType, MomentumTransfer, Location);
    Sleep(0.5);
    HurtRadius(Damage, DamageRadius*0.300, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.475, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    RelinquishController();
    HurtRadius(Damage, DamageRadius*0.650, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*0.825, MyDamageType, MomentumTransfer, Location);
    Sleep(0.2);
    HurtRadius(Damage, DamageRadius*1.000, MyDamageType, MomentumTransfer, Location);
    Destroy();
}

defaultproperties
{
     Damage=350.000000
     AirSpeed=670.000000
     AccelRate=1500.000000
     StaticMesh=StaticMesh'UT2341Weapons_SM.General.UTRedeemerMissile'
     AmbientSound=Sound'UT2341Weapons_Sounds.Redeemer.WarFly'
     DrawScale=0.300000
}
