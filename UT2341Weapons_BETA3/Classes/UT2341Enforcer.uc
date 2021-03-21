//=============================================================================
// Enforcer.
//
// Pain in the arse dual-wielded weapon. Slave is driven by master.
//=============================================================================
class UT2341Enforcer extends Weapon
    config(user);

#EXEC OBJ LOAD FILE=InterfaceContent.utx

enum EGunState
{
	GS_Single,
	GS_Master,
	GS_Slave
};

var	EGunState 			GunState;

var 	UT2341Enforcer	Enforcer2;

replication
{
	reliable if (Role == ROLE_Authority)
		GunState, Enforcer2;
	reliable if (Role < ROLE_Authority)
		GrantMePower;
}


simulated function bool FirstPersonView()
{
    return (Instigator.IsLocallyControlled() && (PlayerController(Instigator.Controller) != None) && !PlayerController(Instigator.Controller).bBehindView);
}

//===========================================================================
// ClientWeaponSet
//
// Don't autoswitch to a slave
// Slave should bring itself up if the master's the active weapon
//===========================================================================
simulated function ClientWeaponSet(bool bPossiblySwitch)
{
    local int Mode;

    Instigator = Pawn(Owner);

    bPendingSwitch = (bPossiblySwitch && GunState != GS_Slave);

    if( Instigator == None )
    {
        GotoState('PendingClientWeaponSet');
        return;
    }

    for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
    {
        if( FireModeClass[Mode] != None )
        {
			// laurent -- added check for vehicles (ammo not replicated but unlimited)
            if( ( FireMode[Mode] == None ) || ( FireMode[Mode].AmmoClass != None ) && !bNoAmmoInstances && Ammo[Mode] == None && FireMode[Mode].AmmoPerFire > 0 )
            {
                GotoState('PendingClientWeaponSet');
                return;
            }
        }

        FireMode[Mode].Instigator = Instigator;
        FireMode[Mode].Level = Level;
    }

    ClientState = WS_Hidden;
    GotoState('Hidden');
	
	if (GunState == GS_Slave)
	{
		Enforcer2.ItemName = "Double Enforcers";
		if (Instigator.Weapon == Enforcer2 && Instigator.PendingWeapon == None)
			BringUp();
		return;
	}

    if( Level.NetMode == NM_DedicatedServer || !Instigator.IsHumanControlled() )
        return;

    if( Instigator.Weapon == self || Instigator.PendingWeapon == self ) // this weapon was switched to while waiting for replication, switch to it now
    {
		if (Instigator.PendingWeapon != None)
            Instigator.ChangedWeapon();
        else
            BringUp();
        return;
    }

    if( Instigator.PendingWeapon != None && Instigator.PendingWeapon.bForceSwitch )
        return;

    if( Instigator.Weapon == None )
    {
        Instigator.PendingWeapon = self;
        Instigator.ChangedWeapon();
    }
    else if ( bPossiblySwitch && !Instigator.Weapon.IsFiring() )
    {
		if ( PlayerController(Instigator.Controller) != None && PlayerController(Instigator.Controller).bNeverSwitchOnPickup )
			return;
        if ( Instigator.PendingWeapon != None )
        {
            if ( RateSelf() > Instigator.PendingWeapon.RateSelf() )
            {
                Instigator.PendingWeapon = self;
                Instigator.Weapon.PutDown();
            }
        }
        else if ( RateSelf() > Instigator.Weapon.RateSelf() )
        {
            Instigator.PendingWeapon = self;
            Instigator.Weapon.PutDown();
        }
    }
}


//===========================================================================
// SpawnShell
//
// Just spawns an actor for the shell. MeshEmitters don't respect the rotation, xEmitters don't respect
// the initial shot OR the rotation.
//===========================================================================
simulated function SpawnShell()
{
	Spawn(class'EnforcerShellCasing', self,,GetBoneCoords('Bone_CaseEjector').Origin, Rotation);
}


simulated function Timer()
{
	local int Mode;
	local float OldDownDelay;

	OldDownDelay = DownDelay;
	DownDelay = 0;
	
	//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"enters Timer. State:"@GetEnum(enum'EWeaponClientState', ClientState));
	
    if (ClientState == WS_BringUp)
    {
		for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
	       FireMode[Mode].InitEffects();
        PlayIdle();
        ClientState = WS_ReadyToFire;
		//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"state Bringup");
    }
    else if (ClientState == WS_PutDown)
    {
        if ( OldDownDelay > 0 )
        {
            if ( HasAnim(PutDownAnim) )
                PlayAnim(PutDownAnim, PutDownAnimRate, 0.0);
			SetTimer(PutDownTime, false);
			//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"state PutDown PlayingAnim");
			return;
		}
		if ( Instigator.PendingWeapon == None && GunState != GS_Slave)
		{
			PlayIdle();
			ClientState = WS_ReadyToFire;
			//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"state Putdown No Pending");
		}
		else
		{
			ClientState = WS_Hidden;
			if (GunState != GS_Slave)
				Instigator.ChangedWeapon();
			if ( (Instigator.Weapon == self || Instigator.Weapon == Enforcer2) && (GunState != GS_Slave || (Instigator.PendingWeapon == None || Instigator.PendingWeapon == Enforcer2)) )
			{
				PlayIdle();
				ClientState = WS_ReadyToFire;
				//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"state Putdown Weapon Self Or Enforcer");
			}
			else
			{
				for( Mode = 0; Mode < NUM_FIRE_MODES; Mode++ )
					FireMode[Mode].DestroyEffects();
				//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"state Putdown Fail");
			}
		}
    }
}

simulated exec function GrantMePower()
{
	local UT2341Enforcer Gun2;
	
	if (Level.NetMode == NM_Standalone || Instigator.PlayerReplicationInfo.bAdmin)
	{
		Gun2 = Spawn(class);
		Gun2.GiveTo(Instigator);
	}
}

simulated function bool WeaponCentered()
{
	return GunState != GS_Slave && ( bSpectated || (Hand > 1) );
}

simulated function vector GetEffectStart()
{
    // jjs - this function should actually never be called in third person views
    // any effect that needs a 3rdp weapon offset should figure it out itself

    // 1st person
    if (Instigator.IsFirstPerson())
    {
        if ( WeaponCentered() )
			return CenteredEffectStart();

        return GetBoneCoords('Bone_Flash').Origin;
    }
    // 3rd person
    else
    {
        return (Instigator.Location +
            Instigator.EyeHeight*Vect(0,0,0.5) +
            Vector(Instigator.Rotation) * 40.0);
    }
}

simulated function SetOverlayMaterial( Material mat, float time, bool bOverride )
{
	Super.SetOverlayMaterial(mat, time, bOverride);
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.SetOverlayMaterial(mat, time, bOverride);
}

function AttachToPawn(Pawn P)
{
	local name BoneName;
	local Rotator R;

	Instigator = P;
	if ( ThirdPersonActor == None )
	{
		ThirdPersonActor = Spawn(AttachmentClass,Owner);
		InventoryAttachment(ThirdPersonActor).InitFor(self);
	}
	else
		ThirdPersonActor.NetUpdateTime = Level.TimeSeconds - 1;
	if (GunState == GS_Slave)
	{
		UT2341EnforcerAttachment(ThirdPersonActor).bDualGun = True;
		BoneName = P.GetOffhandBoneFor(self);
		R = ThirdPersonActor.RelativeRotation;
		R.Yaw += 32768;
		ThirdPersonActor.SetRelativeRotation(R);
	}
	else BoneName = P.GetWeaponBoneFor(self);
	if ( BoneName == '' )
	{
		ThirdPersonActor.SetLocation(P.Location);
		ThirdPersonActor.SetBase(P);
	}
	else
		P.AttachToBone(ThirdPersonActor,BoneName);
}

simulated event RenderOverlays( Canvas Canvas )
{
    local int m;
	local vector NewScale3D;
	local rotator CenteredRotation;
	local name AnimSeq;
	local float frame,rate;

    if (Instigator == None)
        return;

	if ( Instigator.Controller != None )
	{
		if (GunState == GS_Slave)
		{
			Hand = Instigator.Controller.Handedness * -1;
			if (Hand == 0)
				Hand = -1;
		}
		else
			Hand = Instigator.Controller.Handedness;
	}

    if ((Hand < -1.0) || (Hand > 1.0))
        return;

    // draw muzzleflashes/smoke for all fire modes so idle state won't
    // cause emitters to just disappear
    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m] != None)
        {
            FireMode[m].DrawMuzzleFlash(Canvas);
        }
    }

	if ( (OldMesh != None) && (bUseOldWeaponMesh != (OldMesh == Mesh)) )
	{
		GetAnimParams(0,AnimSeq,frame,rate);
		bInitOldMesh = true;
		if ( bUseOldWeaponMesh )
			LinkMesh(OldMesh);
		else
			LinkMesh(Default.Mesh);
		PlayAnim(AnimSeq,rate,0.0);
	}

    if ( (Hand != RenderedHand) || bInitOldMesh )
    {
		newScale3D = Default.DrawScale3D;
		if ( Hand != 0 )
			newScale3D.Y *= Hand;
		SetDrawScale3D(newScale3D);
		SetDrawScale(Default.DrawScale);
		CenteredRoll = Default.CenteredRoll;
		CenteredYaw = Default.CenteredYaw;
		CenteredOffsetY = Default.CenteredOffsetY;
		PlayerViewPivot = Default.PlayerViewPivot;
		SmallViewOffset = Default.SmallViewOffset;
		if ( SmallViewOffset == vect(0,0,0) )
			SmallViewOffset = Default.PlayerviewOffset;
		bInitOldMesh = false;
		if ( Default.SmallEffectOffset == vect(0,0,0) )
			SmallEffectOffset = EffectOffset + Default.PlayerViewOffset - SmallViewOffset;
		else
			SmallEffectOffset = Default.SmallEffectOffset;
		if ( Mesh == OldMesh )
		{
			SmallEffectOffset = EffectOffset + OldPlayerViewOffset - OldSmallViewOffset;
			PlayerViewPivot = OldPlayerViewPivot;
			SmallViewOffset = OldSmallViewOffset;
			if ( Hand != 0 )
			{
				PlayerViewPivot.Roll *= Hand;
				PlayerViewPivot.Yaw *= Hand;
			}
			CenteredRoll = OldCenteredRoll;
			CenteredYaw = OldCenteredYaw;
			CenteredOffsetY = OldCenteredOffsetY;
			SetDrawScale(OldDrawScale);
		}
		else if ( Hand == 0 )
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw;
		}
		else
		{
			PlayerViewPivot.Roll = Default.PlayerViewPivot.Roll * Hand;
			PlayerViewPivot.Yaw = Default.PlayerViewPivot.Yaw * Hand;
		}
		RenderedHand = Hand;
	}
	if ( class'PlayerController'.Default.bSmallWeapons )
		PlayerViewOffset = SmallViewOffset;
	else if ( Mesh == OldMesh )
		PlayerViewOffset = OldPlayerViewOffset;
	else
		PlayerViewOffset = Default.PlayerViewOffset;
	if ( Hand == 0 )
		PlayerViewOffset.Y = CenteredOffsetY;
	else
		PlayerViewOffset.Y *= Hand;

    SetLocation( Instigator.Location + Instigator.CalcDrawOffset(self) );
    if ( Hand == 0 )
    {
		CenteredRotation = Instigator.GetViewRotation();
		CenteredRotation.Yaw += CenteredYaw;
		CenteredRotation.Roll = CenteredRoll;
	    SetRotation(CenteredRotation);
    }
    else
	    SetRotation( Instigator.GetViewRotation() );

	PreDrawFPWeapon();	// Laurent -- Hook to override things before render (like rotation if using a staticmesh)

    bDrawingFirstPerson = true;
    Canvas.DrawActor(self, false, false, DisplayFOV);
    bDrawingFirstPerson = false;
	if ( Hand == 0 )
		PlayerViewOffset.Y = 0;
	
	if (GunState == GS_Master && Enforcer2 != None && Enforcer2.ClientState != WS_Hidden)
		Enforcer2.RenderOverlays(Canvas);
}

simulated function BringUp(optional Weapon PrevWeapon)
{
   local int Mode;

	if ( ClientState == WS_Hidden)
	{
		PlayOwnedSound(SelectSound, SLOT_Interact,,,,, false);
		ClientPlayForceFeedback(SelectForce);  // jdf

		if ( Instigator.IsLocallyControlled() )
		{
			if ( (Mesh!=None) && HasAnim(SelectAnim) )
				PlayAnim(SelectAnim, SelectAnimRate, 0.0);
		}

		ClientState = WS_BringUp;
		SetTimer(BringUpTime, false);
	}
	for (Mode = 0; Mode < NUM_FIRE_MODES; Mode++)
	{
		FireMode[Mode].bIsFiring = false;
		FireMode[Mode].HoldTime = 0.0;
		FireMode[Mode].bServerDelayStartFire = false;
		FireMode[Mode].bServerDelayStopFire = false;
		FireMode[Mode].bInstantStop = false;
	}
	if ( (PrevWeapon != None) && PrevWeapon.HasAmmo() && !PrevWeapon.bNoVoluntarySwitch )
		OldWeapon = PrevWeapon;
	else
		OldWeapon = None;
	
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.BringUp();
	if (GunState == GS_Slave)
		AttachToPawn(Instigator);
}

//===========================================================================
// Slave should never be accessible to the player.
//===========================================================================
simulated function Weapon WeaponChange( byte F, bool bSilent )
{
    local Weapon newWeapon;

    if ( InventoryGroup == F )
    {
        if ( !HasAmmo() || GunState == GS_Slave)
        {
            if ( Inventory == None )
                newWeapon = None;
            else
                newWeapon = Inventory.WeaponChange(F,bSilent);

            if ( !bSilent && (newWeapon == None) && Instigator.IsHumanControlled() )
                Instigator.ClientMessage( ItemName$MessageNoAmmo );

            return newWeapon;
        }
        else
            return self;
    }
    else if ( Inventory == None )
        return None;
    else
        return Inventory.WeaponChange(F,bSilent);
}

simulated function Weapon PrevWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if (GunState == GS_Slave)
	{
		if ( Inventory == None )
			return CurrentChoice;
		else
			return Inventory.PrevWeapon(CurrentChoice,CurrentWeapon);
	}
	
	return Super.PrevWeapon(CurrentChoice, CurrentWeapon);
}

simulated function Weapon NextWeapon(Weapon CurrentChoice, Weapon CurrentWeapon)
{
	if (GunState == GS_Slave)
	{
		if ( Inventory == None )
			return CurrentChoice;
		else
			return Inventory.NextWeapon(CurrentChoice,CurrentWeapon);
	}
	
	return Super.NextWeapon(CurrentChoice, CurrentWeapon);
}

//===========================================================================
// DropFrom
//
// Throw the slave as well.
//===========================================================================
function DropFrom(vector StartLocation)
{
    local int m;
	local Pickup Pickup;

    if (!bCanThrow || !HasAmmo())
        return;
		
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.DropFrom(StartLocation + vect(1,1,1));

    ClientWeaponThrown();

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if (FireMode[m].bIsFiring)
            StopFire(m);
    }

	if ( Instigator != None )
	{
		DetachFromPawn(Instigator);
	}

	Pickup = Spawn(PickupClass,,, StartLocation);
	if ( Pickup != None )
	{
    	Pickup.InitDroppedPickupFor(self);
	    Pickup.Velocity = Velocity;
        if (Instigator.Health > 0)
            WeaponPickup(Pickup).bThrown = true;
    }

    Destroy();
}

simulated function bool PutDown()
{
	if (Super.PutDown())
	{
		if (GunState == GS_Slave || Enforcer2 == None || Enforcer2.PutDown())
		{
			//log("Enforcer"@eval(GunState == GS_Slave, "Slave", "Master")@"PutDown");
			return true;
		}
	}
	return false;
}

simulated function DetachFromPawn(Pawn P)
{
	if (Enforcer2 != None && GunState != GS_Slave)
		Enforcer2.DetachFromPawn(P);
	Super.DetachFromPawn(P);
}

simulated event WeaponTick(float dt)
{
	local int Mode;
	
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.WeaponTick(dt);

	if (GunState == GS_Slave)
	{
		for (Mode=0; Mode < NUM_FIRE_MODES; Mode++)
		{
			if (FireMode[Mode].bIsFiring)
			{
				if (FireMode[Mode].NextFireTime <= Level.TimeSeconds)
					FireMode[Mode].ModeDoFire();
				if (Instigator.IsLocallyControlled() && Instigator.Controller != None && ((Instigator.Controller.bFire == 0 && Mode == 0) || (Instigator.Controller.bAltFire == 0 && Mode == 1)))
					ClientStopFire(Mode);
			}
			if (FireMode[Mode].NextTimerPop != 0 && FireMode[Mode].NextTimerPop <= Level.TimeSeconds)
			{
				FireMode[Mode].Timer();
				if (FireMode[Mode].bTimerLoop)
					FireMode[Mode].NextTimerPop = Level.TimeSeconds + FireMode[Mode].TimerInterval;
				else FireMode[Mode].NextTimerPop = 0.0f;
			}
		}
	}
}

//// client & server ////
simulated function bool StartFire(int Mode)
{
    local int alt;

    if (!ReadyToFire(Mode))
        return false;

    if (Mode == 0)
        alt = 1;
    else
        alt = 0;

    FireMode[Mode].bIsFiring = true;
	
	//Stagger firing for slave as old Enforcers did.
	if (GunState == GS_Slave)
		FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime + FireMode[Mode].FireRate/2;
	else
		FireMode[Mode].NextFireTime = Level.TimeSeconds + FireMode[Mode].PreFireTime;

    if (FireMode[alt].bModeExclusive)
    {
        // prevents rapidly alternating fire modes
        FireMode[Mode].NextFireTime = FMax(FireMode[Mode].NextFireTime, FireMode[alt].NextFireTime);
    }

    if (Instigator.IsLocallyControlled())
    {
        if (FireMode[Mode].PreFireTime > 0.0 || FireMode[Mode].bFireOnRelease)
        {
            FireMode[Mode].PlayPreFire();
        }
        FireMode[Mode].FireCount = 0;
    }
	
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.StartFire(Mode);

    return true;
}

simulated event StopFire(int Mode)
{
	Super.StopFire(Mode);
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.StopFire(Mode);
}

//hack to stop all firing and release any charging firemodes RIGHT THIS INSTANT
//used when getting into vehicles
simulated function ImmediateStopFire()
{
	Super.ImmediateStopFire();
	
	if (GunState == GS_Master && Enforcer2 != None)
		Enforcer2.ImmediateStopFire();
}

function GiveTo(Pawn Other, optional Pickup Pickup)
{
    local int m;
    local weapon w;
    local bool bPossiblySwitch, bJustSpawned;

	Instigator = Other;
	W = Weapon(Instigator.FindInventoryType(class));
    if ( W == None || W.Class != Class || UT2341Enforcer(W).Enforcer2 == None) // added class check because somebody made FindInventoryType() return subclasses for some reason
    {
		bJustSpawned = true;
		Super(Inventory).GiveTo(Other);
		bPossiblySwitch = true;
		if (W != None && UT2341Enforcer(W).Enforcer2 == None)
		{
			UT2341Enforcer(W).Enforcer2 = self;
			Enforcer2 = UT2341Enforcer(W);
			W.ItemName = "Double Enforcers";
			GunState = GS_Slave;
			bPossiblySwitch=False; //Never allow a slave to trigger an autoswitch
			UT2341Enforcer(W).GunState = GS_Master;
		}
		W = self;
	}
	
	else if ( !W.HasAmmo() )
	    bPossiblySwitch = true;
    if ( Pickup == None && GunState != GS_Slave)
        bPossiblySwitch = true;

    for (m = 0; m < NUM_FIRE_MODES; m++)
    {
        if ( FireMode[m] != None )
        {
            FireMode[m].Instigator = Instigator;
            W.GiveAmmo(m,WeaponPickup(Pickup),(bJustSpawned && GunState != GS_Slave));
        }
    }

	if ( Instigator.Weapon != W)
		W.ClientWeaponSet(bPossiblySwitch);

    if ( !bJustSpawned )
	{
        for (m = 0; m < NUM_FIRE_MODES; m++)
            Ammo[m] = None;
		Destroy();
	}
	
	if (W == self && GunState == GS_Slave && Instigator.Weapon == Enforcer2 && Instigator.PendingWeapon == None)
		BringUp();
}

//===========================================================================
// GiveAmmo
//
// Enforcers should start with 30, not the amount defined in the base ammo, which is for the Mini
//===========================================================================
function GiveAmmo(int m, WeaponPickup WP, bool bJustSpawned)
{
    local bool bJustSpawnedAmmo;
    local int addAmount, InitialAmount;

    if ( FireMode[m] != None && FireMode[m].AmmoClass != None )
    {
        Ammo[m] = Ammunition(Instigator.FindInventoryType(FireMode[m].AmmoClass));
		bJustSpawnedAmmo = false;

		if ( bNoAmmoInstances )
		{
			if ( (FireMode[m].AmmoClass == None) || ((m != 0) && (FireMode[m].AmmoClass == FireMode[0].AmmoClass)) )
				return;

			InitialAmount = FireMode[m].AmmoClass.Default.InitialAmount;
			if ( (WP != None) && ((WP.AmmoAmount[0] > 0) || (WP.AmmoAmount[1] > 0))  )
			{
				InitialAmount = WP.AmmoAmount[m];
			}
			
			InitialAmount *= 0.3;

			if ( Ammo[m] != None )
			{
				addamount = InitialAmount + Ammo[m].AmmoAmount;
				Ammo[m].Destroy();
			}
			else
				addAmount = InitialAmount;

			AddAmmo(addAmount,m);
		}
		else
		{
			if ( (Ammo[m] == None) && (FireMode[m].AmmoClass != None) )
			{
				Ammo[m] = Spawn(FireMode[m].AmmoClass, Instigator);
				Instigator.AddInventory(Ammo[m]);
				bJustSpawnedAmmo = true;
			}
			else if ( (m == 0) || (FireMode[m].AmmoClass != FireMode[0].AmmoClass) )
				bJustSpawnedAmmo = ( bJustSpawned || ((WP != None) && !WP.bWeaponStay) );

			if ( (WP != None) && ((WP.AmmoAmount[0] > 0) || (WP.AmmoAmount[1] > 0))  )
			{
				addAmount = WP.AmmoAmount[m];
			}
			else if ( bJustSpawnedAmmo )
			{
				addAmount = Ammo[m].InitialAmount * 0.3;
			}

			Ammo[m].AddAmmo(addAmount);
			Ammo[m].GotoState('');
		}
    }
}
function bool HandlePickupQuery( pickup Item )
{
	local int i;

	if ( bNoAmmoInstances )
	{
		// handle ammo pickups
		for ( i=0; i<2; i++ )
		{
			if ( (item.inventorytype == AmmoClass[i]) && (AmmoClass[i] != None) )
			{
				if ( AmmoCharge[i] >= MaxAmmo(i) )
					return true;
				item.AnnouncePickup(Pawn(Owner));
				AddAmmo(Ammo(item).AmmoAmount, i);
				item.SetRespawn();
				return true;
			}
		}
	}

	if (class == Item.InventoryType)
    {
		if(WeaponPickup(Item) != None && !WeaponPickup(Item).AllowRepeatPickup())
			return true;
		//if (Enforcer2 == None)
		return false;
		//return true;
    }

    if ( Inventory == None )
		return false;

	return Inventory.HandlePickupQuery(Item);
}

simulated function DisplayDebug(Canvas Canvas, out float YL, out float YPos)
{
  super.DisplayDebug(Canvas, YL, YPos);

	if (GunState == GS_Master)
		Enforcer2.DisplayDebug(Canvas, YL, YPos);
}

function byte BestMode()
{
	local Bot B;

	B = Bot(Instigator.Controller);
	if ( (B != None) && (B.Enemy != None) )
	{
	    if ( VSize(B.Location - B.Enemy.Location) < 1024 )
		    return 1;
	}
	return 0;
}

function float GetAIRating()
{
	local Bot B;

	if ( Enforcer2 == None )
		return AIRating;

	B = Bot(Instigator.Controller);
	if ( B == None )
		return AIRating;

	if ( B.Enemy == None )
		return AIRating;

	return (AIRating + 0.0003 * FClamp(1500 - VSize(B.Enemy.Location - Instigator.Location),0,1000));
}

defaultproperties
{
     FireModeClass(0)=Class'UT2341Weapons_BETA3.UT2341EnforcerFire'
     FireModeClass(1)=Class'UT2341Weapons_BETA3.UT2341EnforcerAltFire'
     PutDownAnim="PutDown"
     SelectSound=Sound'UT2341Weapons_Sounds.Enforcer.Cocking'
     SelectForce="SwitchToMiniGun"
     AIRating=0.400000
     CurrentRating=0.400000
     bNoAmmoInstances=False
     Description="Classification: Light PistolnnPrimary Fire: Accurate but slow firing instant hit.nnSecondary Fire: Sideways, or 'Gangsta' firing mode, shoots faster and less accurately than the primary fire.nnTechniques: Collect two for twice the damage."
     EffectOffset=(X=100.000000,Y=30.000000,Z=-16.000000)
     Priority=9
     HudColor=(B=255)
     SmallViewOffset=(X=-2.000000,Z=-13.000000)
     CenteredOffsetY=-6.000000
     CenteredRoll=0
     CenteredYaw=-500
     CustomCrosshair=12
     CustomCrossHairTextureName="Crosshairs.Hud.Crosshair_Circle1"
     InventoryGroup=2
     PickupClass=Class'UT2341Weapons_BETA3.UT2341EnforcerPickup'
     PlayerViewOffset=(X=-2.000000,Z=-13.000000)
     BobDamping=2.250000
     AttachmentClass=Class'UT2341Weapons_BETA3.UT2341EnforcerAttachment'
     IconMaterial=Texture'UT2341Weapons_Tex.Icons.Icon_Enforcer'
     IconCoords=(X2=128,Y2=32)
     ItemName="Enforcer"
     LightType=LT_Pulse
     LightEffect=LE_NonIncidence
     LightHue=30
     LightSaturation=150
     LightBrightness=255.000000
     LightRadius=5.000000
     LightPeriod=3
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTEnforcer_FP'
     DrawScale=2.000000
     SoundRadius=400.000000
}
