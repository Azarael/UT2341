class Mut_UT2341Instagib extends MutInstaGib;

var float GravMultiplier;

simulated function PreBeginPlay()
{
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
			case "Onslaught.ONSHUDOnslaught": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTROnslaught"; break;
			case "SkaarjPack.HudInvasion":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRInvasion"; break;*/
			case "UT2k4Assault.HUD_Assault": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRAssault"; break;
			case "BonusPack.HudLMS":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRLastManStanding"; break;
			case "XInterface.HudCDoubleDomination":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRDomination"; break;
			case "XInterface.HudCBombingRun":	Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRBombingRun"; break;/*
			case "BonusPack.HudMutant": Level.Game.HUDType = "UT2341Weapons_BETA3.HUDCUTRMutant"; break;*/
		}
	}
}

function string GetInventoryClassOverride(string InventoryClassName)
{
	if (InventoryClassName ~=  "XWeapons.Translauncher")
		return "UT2341Weapons_BETA3.UT2341Translocator";

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
	
	/*
	else if (xPawn(Other) != None)
	{
		if(Deathmatch(Level.Game).AllowTransloc())
			xPawn(Other).RequiredEquipment[2] = "UT2341Weapons_BETA3.UT2341Translocator";
		return true;
	}
	
	else if (Other.Class == class'Translauncher')
		return false;
	*/
		
	return Super.CheckReplacement(Other, bSuperRelevant);
}

defaultproperties
{
     GravMultiplier=1.150000
     WeaponName="UT2341SuperShockRifle"
     AmmoName="UT2341SuperShockAmmo"
     WeaponString="UT2341Weapons_BETA3.UT2341SuperShockRifle"
     AmmoString="UT2341Weapons_BETA3.UT2341SuperShockAmmo"
     DefaultWeaponName="UT2341Weapons_BETA3.UT2341SuperShockRifle"
     FriendlyName="UT2341: Instagib"
     Description="Instagib, UT2341-style."
}
