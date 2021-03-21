class Mut_UT2341Replacement extends Mutator;

var float GravMultiplier;

simulated function PreBeginPlay()
{
	local xPickupBase P;
	
	Super.PreBeginPlay();
	
	if (Role == ROLE_Authority)
	{
		if (Level.Game.DefaultPlayerClassName ~= "xGame.xPawn")
			Level.Game.DefaultPlayerClassName = "UT2341Weapons_BETA3.UT2341Pawn";
        if (level.Game.PlayerControllerClassName ~= "XGame.xPlayer")
			Level.Game.PlayerControllerClassName = "UT2341Weapons_BETA3.UT2341PlayerController";
		Level.DefaultGravity *= GravMultiplier;
		
		switch(Level.Game.HUDType)
		{
			case "XInterface.HudCDeathMatch":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCDeathmatchPlus"; break;
			case "XInterface.HudCTeamDeathMatch":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCTeamGamePlus"; break;
			case "XInterface.HudCCaptureTheFlag":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRCTFGame"; break;/*
			case "Onslaught.ONSHUDOnslaught": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTROnslaught"; break;*/
			case "SkaarjPack.HudInvasion":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRInvasion"; break;
			case "UT2k4Assault.HUD_Assault": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRAssault"; break;
			case "BonusPack.HudLMS":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRLastManStanding"; break;
			case "XInterface.HudCDoubleDomination":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRDomination"; break;
			case "XInterface.HudCBombingRun":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRBombingRun"; break;
			case "BonusPack.HudMutant": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRMutant"; break;
		};
	}
	
	//Apparently CheckReplacement doesn't work on the client side
	else
	{
		foreach AllActors (class'xPickupBase', P)
		{	
			P.bHidden = True;
			P.myEmitter.bHidden = True;
			P.SetDrawType(DT_None);
			P.SetStaticMesh(None);
		}
	}
}

function string GetInventoryClassOverride(string InventoryClassName)
{
	switch(InventoryClassName)
	{
		case "XWeapons.AssaultRifle":				return "UT2341Weapons_BETA3.UT2341Ripper";
		case "XWeapons.BioRifle": 					return "UT2341Weapons_BETA3.UT2341BioRifle";
		case "XWeapons.ONSMineLayer":			return "UT2341Weapons_BETA3.UT2341Ripper";
		case "XWeapons.ShockRifle": 				return "UT2341Weapons_BETA3.UT2341ShockRifle";
		case "XWeapons.LinkGun": 					return "UT2341Weapons_BETA3.UT2341PulseGun";
		case "XWeapons.Minigun": 					return "UT2341Weapons_BETA3.UT2341Minigun";
		case "XWeapons.FlakCannon": 				return "UT2341Weapons_BETA3.UT2341FlakCannon";
		case "XWeapons.ONSGrenadeLauncher": 	return "UT2341Weapons_BETA3.UT2341Ripper";
		case "XWeapons.RocketLauncher":			return "UT2341Weapons_BETA3.UT2341RocketLauncher";
		case "XWeapons.SniperRifle":					return "UT2341Weapons_BETA3.UT2341SniperRifle";
		case "XWeapons.ClassicSniperRifle": 		return "UT2341Weapons_BETA3.UT2341SniperRifle";
		case "XWeapons.Redeemer":					return "UT2341Weapons_BETA3.UT2341Redeemer";
		case "XWeapons.Painter":						return "UT2341Weapons_BETA3.UT2341Redeemer";
		case "XWeapons.Translauncher":			return "UT2341Weapons_BETA3.UT2341Translocator";
	}
	if ( NextMutator != None )
		return NextMutator.GetInventoryClassOverride(InventoryClassName);
	return InventoryClassName;
}

function ModifyPlayer(Pawn Other)
{
	if (UT2341Pawn(Other) == None && xPawn(Other) != None && Monster(Other) == None)
	{
		xPawn(Other).SetCollisionSize(20, xPawn(Other).default.CollisionHeight);
		xPawn(Other).JumpZ = 402;
		xPawn(Other).EyeHeight = 30;
		xPawn(Other).DodgeSpeedZ = 180;
	}
}

function PlayerChangedClass(Controller C)
{
	super.PlayerChangedClass(C);
	if (Bot(C) != None && (C.PawnClass == None || C.PawnClass == class'xPawn'))
		Bot(C).PawnClass = class'UT2341Pawn';
}

function bool CheckReplacement( Actor Other, out byte bSuperRelevant )
{
	local int i;
	local WeaponLocker L;
	local PhysicsVolume PV;
    local vector XYDir;
    local float ZDiff,Time;
    local JumpPad J;
	
	bSuperRelevant = 0;
	
    PV = PhysicsVolume(Other);

	if ( PV != None )
	{
		PV.Gravity.Z *= GravMultiplier;
		PV.BACKUP_Gravity = PV.Gravity;
		PV.bAlwaysRelevant = true;
		PV.RemoteRole = ROLE_DumbProxy;
		return true;
	}
	J = JumpPad(Other);
	if ( J != None )
	{
		XYDir = J.JumpTarget.Location - J.Location;
		ZDiff = XYDir.Z;
		Time = 2.5f * J.JumpZModifier * Sqrt(Abs(ZDiff/Level.DefaultGravity));
		J.JumpVelocity = XYDir/Time;
		J.JumpVelocity.Z = ZDiff/Time - 0.5f * (Level.DefaultGravity) * Time;
		return true;
	}

	//vehicles shouldn't be affected by this mutator (it would break them)
	if (Vehicle(Other) != None && KarmaParams(Other.KParams) != None)
	{
		KarmaParams(Other.KParams).KActorGravScale *= class'PhysicsVolume'.default.Gravity.Z / Level.DefaultGravity;
		return true;
	}
	
	if (Bot(Other) != None)
	{
		if(Bot(Other).PawnClass == None || Bot(Other).PawnClass == class'xPawn')
		{
			Bot(Other).PawnClass = class'UT2341Pawn';
			Bot(Other).PreviousPawnClass = class'UT2341Pawn';
		}
		return true;
	}
	
	else if (xPawn(Other) != None)
	{
		xPawn(Other).RequiredEquipment[0] = "UT2341Weapons_BETA3.UT2341Enforcer";
		xPawn(Other).RequiredEquipment[1] = "UT2341Weapons_BETA3.UT2341Hammer";
		if (xLastManStandingGame(Level.Game) != None)
			xPawn(Other).RequiredEquipment[2] = "UT2341Weapons_BETA3.UT2341Ripper";
		return true;
	}
	
	else if (xPickupBase(Other) != None)
	{	
		Other.bHidden = True;
		Other.SetDrawType(DT_None);
		Other.SetStaticMesh(None);
		
		if ( xWeaponBase(Other) != None )
		{
			switch(xWeaponBase(Other).WeaponType)
			{
				case class'AssaultRifle':				xWeaponBase(Other).WeaponType = class'UT2341Ripper';					break;
				case class'BioRifle': 					xWeaponBase(Other).WeaponType = class'UT2341BioRifle'; 				break;
				case class'ONSMineLayer':			xWeaponBase(Other).WeaponType = class'UT2341Ripper';					break;
				case class'ShockRifle': 				xWeaponBase(Other).WeaponType = class'UT2341ShockRifle'; 			break;
				case class'LinkGun': 					xWeaponBase(Other).WeaponType = class'UT2341PulseGun'; 				break;
				case class'Minigun': 					xWeaponBase(Other).WeaponType = class'UT2341Minigun'; 				break;
				case class'FlakCannon': 				xWeaponBase(Other).WeaponType = class'UT2341FlakCannon'; 			break;
				case class'ONSGrenadeLauncher': 	xWeaponBase(Other).WeaponType = class'UT2341Ripper'; 				break;
				case class'RocketLauncher':			xWeaponBase(Other).WeaponType = class'UT2341RocketLauncher'; 	break;
				case class'SniperRifle': 				xWeaponBase(Other).WeaponType = class'UT2341SniperRifle'; 			break;
				case class'ClassicSniperRifle': 		xWeaponBase(Other).WeaponType = class'UT2341SniperRifle'; 			break;
				case class'Redeemer': 					xWeaponBase(Other).WeaponType = class'UT2341Redeemer';				break;
				case class'Painter':						xWeaponBase(Other).WeaponType = class'UT2341Redeemer';				break;
				case class'ONSPainter':				xWeaponBase(Other).WeaponType = class'UT2341Redeemer';
			}
			
			xWeaponBase(Other).SpawnHeight = class'UT2341ShockRiflePickup'.default.CollisionHeight + 1;
		}
		else if (HealthCharger(Other) != None)
			HealthCharger(Other).PowerUp = class'UTHealthPack';
		else if (SuperHealthCharger(Other) != None)
			SuperHealthCharger(Other).PowerUp = class'UTSuperHealthPack';
		else if (ShieldCharger(Other) != None)
			ShieldCharger(Other).PowerUp = class'UTBodyArmorPickup';
		else if (UDamageCharger(Other) != None)
			UDamageCharger(Other).PowerUp = class'UTUDamagePack';
		else if (SuperShieldCharger(Other) != None)
			SuperShieldCharger(Other).PowerUp = class'ShieldBelt';
		
		if (xPickupBase(Other).PowerUp != None)
			xPickupBase(Other).SpawnHeight = xPickupBase(Other).PowerUp.default.CollisionHeight + 1;
		return true;
	}
	
	else if (Pickup(Other) != None)
	{
		if ( WeaponLocker(Other) != None )
		{
			L = WeaponLocker(Other);
			for (i = 0; i < L.Weapons.Length; i++)
			{
				switch(L.Weapons[i].WeaponClass)
				{
					case class'BioRifle': 				L.Weapons[i].WeaponClass = class'UT2341BioRifle'; 				break;
					case class'AssaultRifle':			L.Weapons[i].WeaponClass = class'UT2341Ripper';					break;
					case class'ONSMineLayer':		L.Weapons[i].WeaponClass = class'UT2341Ripper';					break;
					case class'ShockRifle': 			L.Weapons[i].WeaponClass = class'UT2341ShockRifle'; 			break;
					case class'LinkGun': 				L.Weapons[i].WeaponClass = class'UT2341PulseGun'; 			break;
					case class'Minigun': 				L.Weapons[i].WeaponClass = class'UT2341Minigun'; 				break;
					case class'FlakCannon': 			L.Weapons[i].WeaponClass = class'UT2341FlakCannon'; 			break;
					case class'RocketLauncher': 	L.Weapons[i].WeaponClass = class'UT2341RocketLauncher';	break;
					case class'SniperRifle': 			L.Weapons[i].WeaponClass = class'UT2341SniperRifle'; 			break;				
					case class'ClassicSniperRifle': 	L.Weapons[i].WeaponClass = class'UT2341SniperRifle'; 			break;
				}
			}
			return true;
		}
		else if (UTAmmoPickup(Other) != None)
		{
			switch(UTAmmoPickup(Other).Class)
			{
				case    class'AssaultAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341RipperAmmoPickup"); break;
				case	class'BioAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341BioAmmoPickup"); break;
				case	class'ONSMineAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341RipperAmmoPickup"); break;
				case	class'ShockAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341ShockRifleAmmoPickup"); break;
				case	class'LinkAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341PulseAmmoPickup"); break;
				case    class'ONSGrenadeAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341RipperAmmoPickup"); break;
				case	class'MinigunAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341MinigunAmmoPickup"); break;
				case	class'FlakAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341FlakAmmoPickup"); break;
				case	class'RocketAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341RocketAmmoPickup"); break;
				case	class'SniperAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341SniperAmmoPickup"); break;
				case	class'ClassicSniperAmmoPickup': ReplaceWith( Other, "UT2341Weapons_BETA3.UT2341SniperAmmoPickup"); break;
				default: i=1;
				if (i == 1)
					return true;
			}
		}
		
		
		else if (MiniHealthPack(Other) != None)
		{
			ReplaceWith(Other,  "UT2341Weapons_BETA3.UTMiniHealthPack");
			return false;
		}
		
		/*
		else if (HealthPack(Other) != None)
			ReplaceWith(Other,  "UT2341Weapons_BETA3.UTHealthPack");
		else if (ShieldPack(Other) != None)
			ReplaceWith(Other, "UT2341Weapons_BETA3.UTBodyArmorPickup");
		else if (UDamagePack(Other) != None)
			ReplaceWith(Other,  "UT2341Weapons_BETA3.UTUDamagePack");
		else if (SuperShieldPack(Other) != None)
			ReplaceWith(Other, "UT2341Weapons_BETA3.ShieldBelt");
		*/
		else
			return true;
		return false;
	}

	else
		return true;
	return false;
}

defaultproperties
{
     GravMultiplier=1.150000
     GroupName="Arena"
     FriendlyName="Unreal Tournament 2341"
     Description="Replaces the standard weapons with UT2341 equivalents. Modifies Pawn properties and the gravity to simulate Unreal Tournament."
     bNetTemporary=True
     bAlwaysRelevant=True
     RemoteRole=ROLE_SimulatedProxy
}
