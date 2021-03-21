//=============================================================================
// Translocator Beacon
//=============================================================================
class UT2341TransBeacon extends TransBeacon;

//I don't approve of making pointless subclasses
var byte myTeam;

var byte UpdatePhysics, OldUpdatePhysics;

var UT2341Translocator Master;

var class<TransFlareBlue> TransFlareClasses[2];

replication
{
	reliable if (Role == ROLE_Authority)
		myTeam, UpdatePhysics;
}

simulated event PostNetReceive()
{
	Super.PostNetReceive();
	
	if (UpdatePhysics != OldUpdatePhysics)
	{
		OldUpdatePhysics = UpdatePhysics;
		SetPhysics(PHYS_Falling);
	}		
}

simulated function PostBeginPlay()
{
	local vector dir;
    local Rotator r;
	
    Super(TranslocatorBeacon).PostBeginPlay();

    if ( Role == ROLE_Authority )
    {
		dir = vector(Instigator.GetViewRotation());
		dir.Z = dir.Z + 0.35 * (1- Abs(dir.Z));
		Velocity = Speed * Normal(dir);
        R.Yaw = Rotation.Yaw;
        R.Pitch = 0;
        R.Roll = 0;
        SetRotation(R);
        bCanHitOwner = false;
    }
	PlayAnim('Idle');
    SetTimer(0.3,false);
}

// poll for disruption
simulated function Timer()
{
    if ( Level.NetMode == NM_DedicatedServer )
        return;

    if ( !Disrupted() )
    {
        SetTimer(0.3, false);
        return;
    }

    // create the disrupted effect
    if (Sparks == None)
    {
        Sparks = Spawn(class'TransBeaconSparks',,,Location+vect(0,0,5),Rotator(vect(0,0,1)));
        Sparks.SetBase(self);
    }

    if (Flare != None)
        Flare.Destroy();
}

function TakeDamage(int Damage, Pawn EventInstigator, vector HitLocation, vector Momentum, class<DamageType> DamageType)
{
	SetPhysics(PHYS_Falling);
	Velocity = Momentum/50;
	Velocity.Z = FMax(Velocity.Z, 0.7 * VSize(Velocity));
	++UpdatePhysics;
	NetUpdateTime = Level.TimeSeconds - 1;

    if ( Level.Game.bTeamGame && (EventInstigator != None)
		&& (EventInstigator.PlayerReplicationInfo != None)
		&& ((Instigator == None) || (EventInstigator.PlayerReplicationInfo.Team == Instigator.PlayerReplicationInfo.Team)) )
    {
		return;
    }
    else
    {
        Disruption += Damage;
		Disruptor = EventInstigator;
    }
}

simulated function HitWall( vector HitNormal, actor Wall )
{
	local CTFBase B;

    bCanHitOwner = true;

	Velocity = 0.3*(( Velocity dot HitNormal ) * HitNormal * (-2.0) + Velocity);   // Reflect off Wall w/damping
	Speed = VSize(Velocity);

	if ( Speed < 100 )
	{
		ForEach TouchingActors(class'CTFBase', B)
			break;

		if ( B != None )
		{
			Speed = VSize(Velocity);
			if ( Speed < 100 )
			{
				Speed = 90;
				Velocity = 90 * Normal(Velocity);
			}
			Disruption += 5;
			if ( Disruptor == None )
				Disruptor = Instigator;
		}
	}


	if ( Speed < 20 && Wall.bWorldGeometry && (HitNormal.Z >= 0.7) )
	{
		if ( Level.NetMode != NM_DedicatedServer )
			PlaySound(ImpactSound, SLOT_Misc );
		bBounce = false;
		SetPhysics(PHYS_None);
		
		PlayAnim('Deploy');

		if (Trail != None)
			Trail.mRegen = false;

		if ( (Level.NetMode != NM_DedicatedServer) && (Flare == None) )
		{
			Flare = Spawn(TransFlareClasses[myTeam], self,, Location + vect(0,0,5), rot(16384,0,0));
			Flare.SetBase(self);
		}
	}
}

simulated function Destroyed()
{
	if (Role == ROLE_Authority && Master != None)
		Master.BeaconOut(false);

	Super.Destroyed();
}

defaultproperties
{
     TransFlareClasses(0)=Class'XEffects.TransFlareRed'
     TransFlareClasses(1)=Class'XEffects.TransFlareBlue'
     Speed=900.000000
     MaxSpeed=1200.000000
     DrawType=DT_Mesh
     AmbientSound=Sound'UT2341Weapons_Sounds.XLoc.targethum'
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTTranslocatorModule'
     DrawScale=3.000000
     PrePivot=(Z=-7.500000)
     SoundVolume=100
     SoundRadius=20.000000
}
