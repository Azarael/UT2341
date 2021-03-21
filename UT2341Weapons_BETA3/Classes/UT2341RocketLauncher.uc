//=============================================================================
// RocketLaucher
//=============================================================================
class UT2341RocketLauncher extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

const NUM_BARRELS = 3;
const BARREL_ROTATION_RATE = 2.95;

var float BarrelRotation;
var float FinalRotation;
var bool bRotateBarrel;
var byte NextBarrel;
var float BarrelRotationRate, BarrelTransitionTime, LoadAnimRate;

struct SBarrelInfo
{
	var Name 		BoneName;
	var float		DesiredBarrelRotation;
};

var array<SBarrelInfo> BarrelInfo;

var Pawn SeekTarget;
var float LockTime, UnLockTime, SeekCheckTime;
var bool bLockedOn, bBreakLock;
var bool bTightSpread;
var() float SeekCheckFreq, SeekRange;
var() float LockRequiredTime, UnLockRequiredTime;
var() float LockAim;
var() Color CrosshairColor;
var() float CrosshairX, CrosshairY;

replication
{
    reliable if (Role == ROLE_Authority && bNetOwner)
        bLockedOn;

    reliable if (Role < ROLE_Authority)
        ServerSetTightSpread, ServerClearTightSpread;
}

function Tick(float dt)
{
    local Pawn Other;
    local Vector StartTrace;
    local Rotator Aim;
    local float BestDist, BestAim;

    if (Instigator == None || Instigator.Weapon != self)
        return;

	if ( Role < ROLE_Authority )
		return;

    if ( !Instigator.IsHumanControlled() )
        return;

    if (Level.TimeSeconds > SeekCheckTime)
    {
        if (bBreakLock)
        {
            bBreakLock = false;
            bLockedOn = false;
            SeekTarget = None;
        }

        StartTrace = Instigator.Location + Instigator.EyePosition();
        Aim = Instigator.GetViewRotation();

        BestAim = LockAim;
        Other = Instigator.Controller.PickTarget(BestAim, BestDist, Vector(Aim), StartTrace, SeekRange);

        if ( CanLockOnTo(Other) )
        {
            if (Other == SeekTarget)
            {
                LockTime += SeekCheckFreq;
                if (!bLockedOn && LockTime >= LockRequiredTime)
                {
                    bLockedOn = true;
                    PlayerController(Instigator.Controller).ClientPlaySound(Sound'UT2341Weapons_Sounds.RocketLauncher.SeekLock');
                 }
            }
            else
            {
                SeekTarget = Other;
                LockTime = 0.0;
            }
            UnLockTime = 0.0;
        }
        else
        {
            if (SeekTarget != None)
            {
                UnLockTime += SeekCheckFreq;
                if (UnLockTime >= UnLockRequiredTime)
                {
                    SeekTarget = None;
                    if (bLockedOn)
                    {
                        bLockedOn = false;
                        PlayerController(Instigator.Controller).ClientPlaySound(Sound'UT2341Weapons_Sounds.RocketLauncher.SeekLost');
                    }
                }
            }
            else
                 bLockedOn = false;
         }

        SeekCheckTime = Level.TimeSeconds + SeekCheckFreq;
    }
}

function bool CanLockOnTo(Actor Other)
{
    local Pawn P;
    
    P = Pawn(Other);

    if (P == None || P == Instigator || !P.bProjTarget)
        return false;

    if (!Level.Game.bTeamGame)
        return true;

	if ( (Instigator.Controller != None) && Instigator.Controller.SameTeamAs(P.Controller) )
		return false;
		
    return ( (P.PlayerReplicationInfo == None) || (P.PlayerReplicationInfo.Team != Instigator.PlayerReplicationInfo.Team) );
}

simulated event RenderOverlays( Canvas Canvas )
{
    if (bLockedOn)
    {
        Canvas.DrawColor = CrosshairColor;
        Canvas.DrawColor.A = 255;
        Canvas.Style = ERenderStyle.STY_Alpha;

        Canvas.SetPos(Canvas.SizeX*0.5-CrosshairX, Canvas.SizeY*0.5-CrosshairY);
        Canvas.DrawTile(Texture'SniperArrows', CrosshairX*2.0, CrosshairY*2.0, 0.0, 0.0, Texture'SniperArrows'.USize, Texture'SniperArrows'.VSize);
    }

    Super.RenderOverlays(Canvas);
}

function Projectile SpawnProjectile(Vector Start, Rotator Dir)
{
    local UT2341RocketProj Rocket;
    local UT2341SeekingRocketProj SeekingRocket;
	local bot B;

    bBreakLock = true;

	// decide if bot should be locked on
	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Skill > 2 + 5 * FRand()) && (FRand() < 0.6) && (B.Target != None)
		&& (B.Target == B.Enemy) && (VSize(B.Enemy.Location - B.Pawn.Location) > 2000 + 2000 * FRand())
		&& (Level.TimeSeconds - B.LastSeenTime < 0.4) && (Level.TimeSeconds - B.AcquireTime > 1.5) )
	{
		bLockedOn = true;
		SeekTarget = B.Enemy;
	}

    if (bLockedOn && SeekTarget != None)
    {
        SeekingRocket = Spawn(class'UT2341SeekingRocketProj',,, Start, Dir);
        SeekingRocket.Seeking = SeekTarget;
        if ( B != None )
        {
			//log("LOCKED");
			bLockedOn = false;
			SeekTarget = None;
		}
        return SeekingRocket;
    }
    else
    {
        Rocket = Spawn(class'UT2341RocketProj',,, Start, Dir);
        return Rocket;
    }
}

//===========================================================================
// PlayIdle
//
// If in bringup state, doesn't tween (to prevent a swapping issue with the rockets)
//===========================================================================
simulated function PlayIdle()
{
	if (ClientState == WS_BringUp)
		LoopAnim(IdleAnim, IdleAnimRate, 0);
    else LoopAnim(IdleAnim, IdleAnimRate, 0.25);
}

//===========================================================================
// PlayLoad
//
// If no rocket loaded, plunge (to load one)
//===========================================================================
simulated function PlayLoad(bool bDoLoad)
{
    if (bDoLoad)
        GotoState('AnimateLoad', 'Begin');
}

simulated function EmptyBarrels(byte pos, byte Shift)
{
	local int i;
	
	for (i=0; i < Shift; i++)
	{
		SetBoneScale(pos, 0, BarrelInfo[pos].BoneName);
		pos++;
		if (pos > 5)
			pos = 0;
	}
}

simulated function AnimEnd(int Channel)
{
    if ( (Channel == 0) && (ClientState == WS_ReadyToFire) )
    {
        PlayIdle();
		if ( (Role < ROLE_Authority) && !HasAmmo() )
			DoAutoSwitch(); //FIXME HACK
	}
	
	if (Channel == 1)
	{
		SetBoneScale(NextBarrel, 1, BarrelInfo[NextBarrel].BoneName);
		if (NextBarrel == 5)
			NextBarrel = 0;
		else NextBarrel++;
		
		//We need to move the Loader rocket back into position
		FreezeAnimAt(0.0, 1);
	}
}

simulated function RotateBarrel()
{
    FinalRotation = BarrelInfo[NextBarrel].DesiredBarrelRotation;
    if (FinalRotation > BarrelRotation)
        BarrelRotation += 65535.0;
	if (FinalRotation != BarrelRotation)
	{
		BarrelRotationRate = (BarrelRotation - FinalRotation) / BarrelTransitionTime; 
		bRotateBarrel = true;
	}
}

simulated function UpdateBarrel(float dt)
{
    local Rotator R;

    BarrelRotation -= dt * BarrelRotationRate;
    if (BarrelRotation < FinalRotation)
    {
        BarrelRotation = FinalRotation;
        bRotateBarrel = false;
    }

    R.Roll = BarrelRotation;
    SetBoneRotation('Bone_Barrels', R, 0, 1);
}

simulated function Plunge()
{
    PlayAnim('load1', LoadAnimRate, 0.0, 1);
}

simulated event ClientStartFire(int Mode)
{
	local int OtherMode;
	
	if ( Mode == 0 )
		OtherMode = 1;

	if ( UT2341RocketFire(FireMode[Mode]) != None )
	{
		SetTightSpread(false);
		
		if ( FireMode[OtherMode].bIsFiring || FireMode[OtherMode].Load > 1 || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds) )
			return;
	}
    else
    {
		if ( FireMode[OtherMode].bIsFiring || FireMode[OtherMode].Load > 1 || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds) )
		{
			if ( FireMode[OtherMode].Load > 0 )
				SetTightSpread(true);
			return;
		}
	}
    Super.ClientStartFire(Mode);
}

simulated function bool StartFire(int Mode)
{
	local int OtherMode;

	if ( Mode == 0 )
		OtherMode = 1;
	if ( FireMode[OtherMode].bIsFiring || (FireMode[OtherMode].NextFireTime > Level.TimeSeconds) )
		return false;

	return Super.StartFire(Mode);
}

//===========================================================================
// StopFire
//
// Dual hold fire modes do not seem to play nice without this.
// Seems to be a timing issue - the bug occurs if you hold 0, hold 1, release 0 then release 1.
// 0 and 1 will both fire on command - 1 should be delayed.
//===========================================================================
simulated function StopFire(int Mode)
{
	FireMode[Mode^1].NextFireTime = Level.TimeSeconds + FireMode[Mode].FireRate;
	Super.StopFire(Mode);
}

simulated function SetTightSpread(bool bNew, optional bool bForce)
{
	if ( (bTightSpread != bNew) || bForce )
	{
		bTightSpread = bNew;
		if ( bTightSpread )
			ServerSetTightSpread();
		else
			ServerClearTightSpread();
	}
}

function ServerClearTightSpread()
{
	bTightSpread = false;
}

function ServerSetTightSpread()
{
	bTightSpread = true;
}



simulated function BringUp(optional Weapon PrevWeapon)
{
	local int i, CurrentBarrel;
	
    SetTightSpread(false,true);
    if (Instigator.IsLocallyControlled())
       AnimBlendParams( 1, 1.0, 0.0, 0.0, 'RocketPack' );

	if (NextBarrel == 0)
		CurrentBarrel = 5;
	else CurrentBarrel = NextBarrel-1;
	SetBoneScale(CurrentBarrel, 1, BarrelInfo[CurrentBarrel].BoneName);
	
	i = NextBarrel;
	
	while (i != CurrentBarrel)
	{
		SetBoneScale(i, 0, BarrelInfo[i].BoneName);
		if (i == 5)
			i = 0;
		else i++;
	}

    Super.BringUp(PrevWeapon);
}

exec function SetBarrelRotation(float desiredroll)
{
	local Rotator R;
	
	R.Roll = desiredroll;
    SetBoneRotation('Bone_Barrels', R, 0, 1);
}

simulated state AnimateLoad
{
    simulated function Tick(float dt)
    {
        if (bRotateBarrel)
            UpdateBarrel(dt);
    }

Begin:
    Sleep(0.15);
    RotateBarrel();
    Sleep(0.07);
    PlayOwnedSound(Sound'UT2341Weapons_Sounds.RocketLauncher.BarrelMove', SLOT_None,0.1,,,,false);
    ClientPlayForceFeedback( "RocketLauncherLoad" );  // jdf
    Sleep(0.28);
    Plunge();
    PlayOwnedSound(Sound'UT2341Weapons_Sounds.RocketLauncher.Loading', SLOT_None,,,,,false);
    ClientPlayForceFeedback( "RocketLauncherPlunger" );  // jdf
    Sleep(0.29);
    GotoState('');
}

// AI Interface
function float SuggestAttackStyle()
{
	local float EnemyDist;

	// recommend backing off if target is too close
	EnemyDist = VSize(Instigator.Controller.Enemy.Location - Owner.Location);
	if ( EnemyDist < 750 )
	{
		if ( EnemyDist < 500 )
			return -1.5;
		else
			return -0.7;
	}
	else if ( EnemyDist > 1600 )
		return 0.5;
	else
		return -0.1;
}

// tell bot how valuable this weapon would be to use, based on the bot's combat situation
// also suggest whether to use regular or alternate fire mode
function float GetAIRating()
{
	local Bot B;
	local float EnemyDist, Rating, ZDiff;
	local vector EnemyDir;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return AIRating;

	// if standing on a lift, make sure not about to go around a corner and lose sight of target
	// (don't want to blow up a rocket in bot's face)
	if ( (Instigator.Base != None) && (Instigator.Base.Velocity != vect(0,0,0))
		&& !B.CheckFutureSight(0.1) )
		return 0.1;

	EnemyDir = B.Enemy.Location - Instigator.Location;
	EnemyDist = VSize(EnemyDir);
	Rating = AIRating;

	// don't pick rocket launcher if enemy is too close
	if ( EnemyDist < 360 )
	{
		if ( Instigator.Weapon == self )
		{
			// don't switch away from rocket launcher unless really bad tactical situation
			if ( (EnemyDist > 250) || ((Instigator.Health < 50) && (Instigator.Health < B.Enemy.Health - 30)) )
				return Rating;
		}
		return 0.05 + EnemyDist * 0.001;
	}

	// rockets are good if higher than target, bad if lower than target
	ZDiff = Instigator.Location.Z - B.Enemy.Location.Z;
	if ( ZDiff > 120 )
		Rating += 0.25;
	else if ( ZDiff < -160 )
		Rating -= 0.35;
	else if ( ZDiff < -80 )
		Rating -= 0.05;
	if ( (B.Enemy.Weapon != None) && B.Enemy.Weapon.bMeleeWeapon && (EnemyDist < 2500) )
		Rating += 0.25;

	return Rating;
}

/* BestMode()
choose between regular or alt-fire
*/
function byte BestMode()
{
	local bot B;

	B = Bot(Instigator.Controller);
	if ( (B == None) || (B.Enemy == None) )
		return 0;

	if ( (FRand() < 0.3) && !B.IsStrafing() && (Instigator.Physics != PHYS_Falling) )
		return 1;
	return 0;
}
// end AI Interface

defaultproperties
{
     NextBarrel=1
     BarrelTransitionTime=0.350000
     LoadAnimRate=1.500000
     BarrelInfo(0)=(BoneName="1")
     BarrelInfo(1)=(BoneName="2",DesiredBarrelRotation=57343.000000)
     BarrelInfo(2)=(BoneName="3",DesiredBarrelRotation=49151.000000)
     BarrelInfo(3)=(BoneName="4",DesiredBarrelRotation=32768.000000)
     BarrelInfo(4)=(BoneName="5",DesiredBarrelRotation=24576.000000)
     BarrelInfo(5)=(BoneName="6",DesiredBarrelRotation=16384.000000)
     SeekCheckFreq=0.500000
     SeekRange=8000.000000
     LockRequiredTime=1.250000
     UnLockRequiredTime=0.500000
     LockAim=0.996000
     CrossHairColor=(R=250,A=255)
     CrosshairX=16.000000
     CrosshairY=16.000000
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341RocketFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341RocketGrenadeFire'
     PutDownAnim="PutDown"
     IdleAnimRate=0.500000
     SelectAnimRate=2.000000
     BringUpTime=0.450000
     SelectSound=Sound'UT2341Weapons_Sounds.RocketLauncher.Selecting'
     SelectForce="SwitchToRocketLauncher"
     AIRating=0.780000
     CurrentRating=0.780000
     Description="Classification: Heavy Ballistic||Primary Fire: Slow moving but deadly rockets are fired at opponents. Trigger can be held down to load up to six rockets at a time, which can be fired at once.||Secondary Fire: Grenades are lobbed from the barrel. Secondary trigger can be held as well to load up to six grenades.||Techniques: Keeping this weapon pointed at an opponent will cause it to lock on, and while the gun is locked the next rocket fired will be a homing rocket.  Because the Rocket Launcher can load up multiple rockets, it fires when you release the fire button."
     EffectOffset=(X=50.000000,Y=1.000000,Z=10.000000)
     DisplayFOV=80.000000
     Priority=14
     HudColor=(G=0)
     SmallViewOffset=(Z=-10.000000)
     CenteredOffsetY=-5.000000
     CenteredYaw=-500
     CustomCrosshair=8
     CustomCrossHairColor=(B=0,G=0)
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Triad2"
     InventoryGroup=9
     PickupClass=Class'UT2341Weapons_BETA3.UT2341RocketLauncherPickup'
     PlayerViewOffset=(Z=-10.000000)
     PlayerViewPivot=(Yaw=500,Roll=1000)
     BobDamping=1.500000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341RocketAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_RocketLauncher'
     IconCoords=(X2=128,Y2=32)
     ItemName="Rocket Launcher"
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTRocketLauncherFP'
     DrawScale=2.000000
     HighDetailOverlay=Combiner'UT2004Weapons.WeaponSpecMap2'
}
