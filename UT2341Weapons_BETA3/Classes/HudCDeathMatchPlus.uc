//==============================================================================
// UTR DeathMatch HUD
// Base HUD for UTR
//
// Writen by Brian 'Snake.PLiSKiN' Alexander for UTR
// Copyright (c) 2005, Brian Alexander for UTR.  All Rights Reserved.
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
// http://wiki.beyondunreal.com/wiki/OpenUnrealModLicense
//
// Azarael note: Permission attained for this HUD.
// Added widescreen aspect ratio correction and ten weapons support.
//==============================================================================
class HudCDeathMatchPlus extends HudBase
	config(User);

#exec OBJ LOAD FILE=UTRHUDTextures.utx
#exec OBJ LOAD FILE=UTRFonts.utx

var() DigitSet DigitsBig;
var() DigitSet DigitsBigPulse;
var() SpriteWidget AmmoIcon;
var() NumericWidget AdrenalineCount;
var() NumericWidget myScore;
// Timer
var() NumericWidget TimerHours;
var() NumericWidget TimerMinutes;
var() NumericWidget TimerSeconds;
var() SpriteWidget TimerDigitSpacer[2];
var() SpriteWidget TimerIcon;
var() SpriteWidget TimerBackground;
// Timer2 (Used when there is NO ChatBox)
var() NumericWidget Timer2Hours;
var() NumericWidget Timer2Minutes;
var() NumericWidget Timer2Seconds;
var() SpriteWidget Timer2DigitSpacer[2];
var() SpriteWidget Timer2Icon;
var() SpriteWidget Timer2Background;

var() Font LevelActionFontFont;
var() Color LevelActionFontColor;
var() float LevelActionPositionX, LevelActionPositionY;
// Hud Digits
var() NumericWidget DigitsHealth, DigitsVehicleHealth;
var() NumericWidget DigitsAmmo;
var() NumericWidget DigitsShield;
// UDamage
var() NumericWidget UDamageTime;
var() SpriteWidget UDamageIcon;
// Shields
var() SpriteWidget ShieldManIcon;		// Base Human Male Texture. The next 3 textures are rendered over this texture
var() SpriteWidget ShieldFemaleIcon;	// Alt texture for female players (used instead of the ShieldManIcon)
var() SpriteWidget ShieldBeltIcon;		// Shield Belt overlay texture
var() SpriteWidget ShieldBodyArmorIcon;	// Body Armor overlay texture
var() SpriteWidget ShieldThighPadsIcon;	// ThighPads overlay texture
var() SpriteWidget ShieldBootsIcon;		// Jump Boots overlay texture
// Adrenaline Meter
var() SpriteWidget AdrenalineIcon;
var() SpriteWidget AdrenalineBackground;
var() SpriteWidget AdrenalineAlert;
// Personal Score
var() SpriteWidget MyScoreIcon;
var() SpriteWidget MyScoreBackground;
var() SpriteWidget ChatBackground;
// Borders
var() SpriteWidget HudHealthALERT, HudVehicleHealthALERT;
var() SpriteWidget HudAmmoALERT;
var() SpriteWidget HudBorderShield;
var() SpriteWidget HudBorderHealth, HudBorderVehicleHealth;
var() SpriteWidget HudBorderAmmo;
var() SpriteWidget HudBorderShieldIcon;
var() SpriteWidget HudBorderHealthIcon, HudBorderVehicleHealthIcon;
// WeaponBar
const WEAPON_BAR_SIZE = 10;

struct WeaponState
{
	var float       PickupTimer;    // set this to > 0 to begin animating
	var bool        HasWeapon;      // did I have this weapon last frame?
};

var() class<Weapon> BaseWeapons[WEAPON_BAR_SIZE];
var() SpriteWidget      BarWeaponIcon[WEAPON_BAR_SIZE];
var() SpriteWidget      BarAmmoIcon[WEAPON_BAR_SIZE];
var() SpriteWidget      BarBorder[WEAPON_BAR_SIZE];
var() SpriteWidget      BarBorderAmmoIndicator[WEAPON_BAR_SIZE];
var float               BarBorderScaledPosition[WEAPON_BAR_SIZE];
var WeaponState         BarWeaponStates[WEAPON_BAR_SIZE];
// RechargeBar
var() SpriteWidget  RechargeBar;
var bool bDrawTimer;
var bool TeamLinked;
var globalconfig bool bShowMissingWeaponInfo;
var globalconfig bool bShowPortraitOnTalk;
// Vars for Items
var int CurHealth, LastHealth, CurVehicleHealth, LastVehicleHealth, CurShield, LastShield, MaxShield, CurEnergy, MaxEnergy, LastEnergy;
var float LastDamagedHealth, LastDamagedVehicleHealth, ZoomToggleTime, FadeTime;
// used with the ShieldMan
var bool bShieldbelt, bThighArmor, bChestArmor, bJumpBoots;
var() int BeltAmount, ThighAmount, ChestAmount;
// Ammo
var() float MaxAmmoPrimary, CurAmmoPrimary, LastAdrenalineTime;
var transient int CurScore, CurRank, ScoreDiff;
var int OldRemainingTime;
var name CountDownName[10];
var name LongCountName[10];
// WeaponIcons
var() int BarWeaponIconAnim[WEAPON_BAR_SIZE];
// HudColors
var() color HudColorRed, HudColorBlue, HudColorBlack, HudColorHighLight, HudColorNormal, HudColorTeam[2];
var globalconfig color CustomHUDHighlightColor;
// PlayerNames
var PlayerReplicationInfo NamedPlayer;
var float NameTime;
// Player portraits
var Material Portrait;
var float PortraitTime;
var float PortraitX;
var array<SceneManager> MySceneManagers;
var float VehicleDrawTimer;
var Pawn OldPawn;
var string VehicleName;
var material HUDTex, HUDPulseTex;
var() globalconfig bool bShowChatBackground;
var() config bool bDebugHeadShotSphere; // Draws the head shot sphere around pawns heads. Only works if this is true and godmode is on for a NM_Standalone game.
var()	Font	HardFontLink;
var int myRank, mySpread;
var byte PlayersInGame;

var bool bSmallBar;

//Positioning
var const float XShifts[9];
var const float YShifts[9];

//Scaling
var bool bCorrectAspectRatio;

var float ScaleYCache;

//Greater than normal HUD scaling is sometimes desirable.
exec final function ScaleHUD(float F)
{
	HUDScale = FClamp(F, 0.5, ResScaleX/ResScaleY);
	SaveConfig();
}

//===========================================================================
// Draws a SpriteWidget using DrawTile.
//===========================================================================
simulated final function DrawWidgetAsTile(Canvas C, SpriteWidget W)
{
	if (!bCorrectAspectRatio)
	{
		DrawSpriteWidget(C, W);
		return;
	}
	
	C.Style = W.RenderStyle;
	
	C.DrawColor = W.Tints[TeamIndex];
	
	if (W.Scale == 1.0f || W.ScaleMode == SM_None)
	{
		C.SetPos(
					(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache),
					(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache)
		);
		C.DrawTile(
			W.WidgetTexture, 
			Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.TextureScale * ScaleYCache,  
			Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.TextureScale * ScaleYCache, 
			W.TextureCoords.X1, 
			W.TextureCoords.Y1, 
			W.TextureCoords.X2 - W.TextureCoords.X1, 
			W.TextureCoords.Y2 - W.TextureCoords.Y1
		);
	}
	else
	{
		switch(W.ScaleMode)
		{
			case SM_Right:
				C.SetPos(
					(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache),
					(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache)
					);
					C.DrawTile(
						W.WidgetTexture, 
						Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.TextureScale * W.Scale * ScaleYCache,  
						Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.TextureScale * ScaleYCache, 
						W.TextureCoords.X1, 
						W.TextureCoords.Y1, 
						(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale, 
						W.TextureCoords.Y2 - W.TextureCoords.Y1
					);
				break;
				
			case SM_Left:
				C.SetPos(
					(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot] + (Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * (1- W.Scale))) * (W.TextureScale * ScaleYCache),
					(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot])  * (W.TextureScale * ScaleYCache)
					);
					C.DrawTile(
					W.WidgetTexture, 
					Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.TextureScale * W.Scale * ScaleYCache,  
					Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.TextureScale * ScaleYCache, 
					W.TextureCoords.X1	+	((W.TextureCoords.X2 - W.TextureCoords.X1) * (1-W.Scale)), 
					W.TextureCoords.Y1, 
					(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale, 
					W.TextureCoords.Y2 - W.TextureCoords.Y1
					);
				break;
			
			case SM_Down:
				C.SetPos(
					(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache),
					(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache)
					);
					C.DrawTile(
					W.WidgetTexture, 
					Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.TextureScale * ScaleYCache,  
					Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.TextureScale * W.Scale * ScaleYCache, 
					W.TextureCoords.X1, 
					W.TextureCoords.Y1, 
					W.TextureCoords.X2 - W.TextureCoords.X1,
					(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale
					);
				break;
				
			case SM_Up:
				C.SetPos(
					(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * (W.TextureScale * ScaleYCache),
					(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot] + (Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * (1- W.Scale)))  * (W.TextureScale * ScaleYCache)
					);
					C.DrawTile(
					W.WidgetTexture, 
					Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.TextureScale * ScaleYCache,  
					Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.TextureScale * W.Scale * ScaleYCache, 
					W.TextureCoords.X1, 
					W.TextureCoords.Y1	+	((W.TextureCoords.Y2 - W.TextureCoords.Y1) * (1-W.Scale)), 
					W.TextureCoords.X2 - W.TextureCoords.X1,
					(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale
					);
		}
	}
}

//===========================================================================
//	Draws a NumericWidget via DrawTile.
//===========================================================================
simulated final function DrawNumericWidgetAsTiles(Canvas C, NumericWidget W, DigitSet D)
{
	local String s;
	local array<String> t;
	local int padding, length, i;
	local byte coordindex;
	
	if (!bCorrectAspectRatio)
	{
		DrawNumericWidget(C, W, D);
		return;
	}
	
	C.Style = W.RenderStyle;

	s = String(W.Value);
	length = Len(s);
	
	padding= Max(0, W.MinDigitCount - length);
	
	if (W.bPadWithZeroes != 0)
		length += padding;

	for (i=0; i < length; i++)
	{
		if (W.bPadWithZeroes == 1 && i < padding)
			t[i] = "0";
		else
		{
			t[i] = "";
			EatStr(t[i], s, 1);
		}
	}
		
	C.SetPos((C.ClipX * W.PosX) + (W.OffsetX - (D.TextureCoords[0].X2 - D.TextureCoords[0].X1) * (((length + padding) * XShifts[W.DrawPivot]) - (padding * (1-W.bPadWithZeroes) )) ) * (W.TextureScale * ScaleYCache),
			(C.ClipY * W.PosY) + (W.OffsetY - (D.TextureCoords[0].Y2 - D.TextureCoords[0].Y1) * YShifts[W.DrawPivot])  * (W.TextureScale * ScaleYCache));
	C.DrawColor = W.Tints[TeamIndex];
	
	for (i = 0; i < length; i++)
	{
		if (t[i] == "-")
			coordindex = 10;
		else coordindex = byte(t[i]);
		
		C.DrawTile(
						D.DigitTexture,
						(D.TextureCoords[coordindex].X2 - D.TextureCoords[coordindex].X1) * W.TextureScale * ScaleYCache,  
						(D.TextureCoords[coordindex].Y2 - D.TextureCoords[coordindex].Y1) * W.TextureScale * ScaleYCache, 
						D.TextureCoords[coordindex].X1, 
						D.TextureCoords[coordindex].Y1, 
						(D.TextureCoords[coordindex].X2 - D.TextureCoords[coordindex].X1), 
						(D.TextureCoords[coordindex].Y2 - D.TextureCoords[coordindex].Y1)
						);
	}
}


//===========================================================================
// Manage HUD override.
//===========================================================================
simulated event PostRender( canvas Canvas )
{
    local float XPos, YPos;
    local plane OldModulate,OM;
    local color OldColor;
    local int i;

    BuildMOTD();

    OldModulate = Canvas.ColorModulate;
    OldColor = Canvas.DrawColor;

    Canvas.ColorModulate.X = 1;
    Canvas.ColorModulate.Y = 1;
    Canvas.ColorModulate.Z = 1;
    Canvas.ColorModulate.W = HudOpacity/255;

    LinkActors();

    ResScaleX = Canvas.SizeX / 640.0;
    ResScaleY = Canvas.SizeY / 480.0;
	
	ScaleYCache = ResScaleY * HUDScale;
	
	if (!bCorrectAspectRatio && ResScaleX/ResScaleY > 1.05)
		bCorrectAspectRatio = True;
	else if (bCorrectAspectRatio && ResScaleX / ResScaleY <= 1.05)
		bCorrectAspectRatio = False;

	CheckCountDown(PlayerOwner.GameReplicationInfo);

    if ( PawnOwner != None )
    {
		if ( !PlayerOwner.bBehindView )
		{
			if ( PlayerOwner.bDemoOwner || ((Level.NetMode == NM_Client) && (PlayerOwner.Pawn != PawnOwner)) )
				PawnOwner.GetDemoRecordingWeapon();
			else
				CanvasDrawActors( Canvas, false );
		}
		else
			CanvasDrawActors( Canvas, false );
	}

	if ( PawnOwner != None && PawnOwner.bSpecialHUD )
		PawnOwner.DrawHud(Canvas);
    if ( bShowDebugInfo )
    {
        Canvas.Font = GetConsoleFont(Canvas);
        Canvas.Style = ERenderStyle.STY_Alpha;
        Canvas.DrawColor = ConsoleColor;

        PlayerOwner.ViewTarget.DisplayDebug(Canvas, XPos, YPos);
        if (PlayerOwner.ViewTarget != PlayerOwner && (Pawn(PlayerOwner.ViewTarget) == None || Pawn(PlayerOwner.ViewTarget).Controller == None))
        {
        	YPos += XPos * 2;
        	Canvas.SetPos(4, YPos);
        	Canvas.DrawText("----- VIEWER INFO -----");
        	YPos += XPos;
        	Canvas.SetPos(4, YPos);
        	PlayerOwner.DisplayDebug(Canvas, XPos, YPos);
        }
    }
	else if( !bHideHud )
    {
        if ( bShowLocalStats )
        {
			if ( LocalStatsScreen == None )
				GetLocalStatsScreen();
            if ( LocalStatsScreen != None )
            {
            	OM = Canvas.ColorModulate;
                Canvas.ColorModulate = OldModulate;
                LocalStatsScreen.DrawScoreboard(Canvas);
				DisplayMessages(Canvas);
                Canvas.ColorModulate = OM;
			}
		}
        else if (bShowScoreBoard)
        {
            if (ScoreBoard != None)
            {
            	OM = Canvas.ColorModulate;
                Canvas.ColorModulate = OldModulate;
                ScoreBoard.DrawScoreboard(Canvas);
				if ( Scoreboard.bDisplayMessages )
					DisplayMessages(Canvas);
                Canvas.ColorModulate = OM;
			}
        }
        else
        {
			if ( (PlayerOwner == None) || (PawnOwner == None) || (PawnOwnerPRI == None) || (PlayerOwner.IsSpectating() && PlayerOwner.bBehindView) )
            	DrawSpectatingHud(Canvas);
			else if( !PawnOwner.bHideRegularHUD )
				DrawHud(Canvas);

			for (i = 0; i < Overlays.length; i++)
				Overlays[i].Render(Canvas);

            if (!DrawLevelAction (Canvas))
            {
            	if (PlayerOwner!=None)
                {
                	if (PlayerOwner.ProgressTimeOut > Level.TimeSeconds)
                    {
	                    DisplayProgressMessages (Canvas);
                    }
                    else if (MOTDState==1)
                    	MOTDState=2;
                }
           }

            if (bShowBadConnectionAlert)
                DisplayBadConnectionAlert (Canvas);
            DisplayMessages(Canvas);

        }

        if( bShowVoteMenu && VoteMenu!=None )
            VoteMenu.RenderOverlays(Canvas);
    }
    else if ( PawnOwner != None )
        DrawInstructionGfx(Canvas);


    PlayerOwner.RenderOverlays(Canvas);

    if (PlayerOwner.bViewingMatineeCinematic)
	DrawCinematicHUD(Canvas);

    if ((PlayerConsole != None) && PlayerConsole.bTyping)
        DrawTypingPrompt(Canvas, PlayerConsole.TypedStr, PlayerConsole.TypedStrPos);

    Canvas.ColorModulate=OldModulate;
    Canvas.DrawColor = OldColor;

    OnPostRender(Self, Canvas);
}

exec function GrowHUD()
{
	if( !bShowWeaponInfo )
		bShowWeaponInfo = true;
	else if( !bShowPersonalInfo )
		bShowPersonalInfo = True;
	else if( !bShowPoints )
		bShowPoints = true;
	else if ( !bDrawTimer && Default.bDrawTimer )
		bDrawTimer = True;
	else if ( !bShowWeaponBar )
		bShowWeaponBar = True;
	else if ( !bShowMissingWeaponInfo )
		bShowMissingWeaponInfo = True;

	SaveConfig();
}

exec function ShrinkHUD()
{
	if ( bShowMissingWeaponInfo )
		bShowMissingWeaponInfo = False;
	else if ( bShowWeaponBar )
		bShowWeaponBar = False;
	else if ( bDrawTimer )
		bDrawTimer = False;
	else if( bShowPoints )
		bShowPoints = false;
	else if( bShowPersonalInfo )
		bShowPersonalInfo = false;
	else if( bShowWeaponInfo )
		bShowWeaponInfo = false;

	SaveConfig();
}

simulated function DrawHud (Canvas C)
{
	Super.DrawHud(C);
	if (Level.Netmode==NM_Standalone && bDebugHeadShotSphere && PlayerOwner != none && PlayerOwner.bGodMode)
		DrawHeadShotSphere();
}

simulated function UpdatePrecacheMaterials()
{
	local int i;

	Level.AddPrecacheMaterial(Material'UTRHUDTextures.HUDContent.HudBase');
	Level.AddPrecacheMaterial(Material'UTRHUDTextures.Generic.HUDPulse');
	Level.AddPrecacheMaterial(Material'XGameShaders.ScreenNoise');
	Level.AddPrecacheMaterial(Material'InterfaceContent.BorderBoxA1');
	Level.AddPrecacheMaterial(Material'Engine.BlackTexture');
	Level.AddPrecacheMaterial(Material'InterfaceContent.ScoreBoxA');
	Level.AddPrecacheMaterial(Material'UTRHUDTextures.HUDContent.HUDShields');

	if ( !bUseCustomWeaponCrosshairs )
		return;

	for ( i=0; i<Crosshairs.Length; i++ )
		Level.AddPrecacheMaterial(Crosshairs[i].WidgetTexture);
}

function PostBeginPlay()
{
	local SceneManager SM;

	Super.PostBeginPlay();
	foreach AllActors(Class'SceneManager',SM)
	{
		MySceneManagers.Length = MySceneManagers.Length+1;
		MySceneManagers[MySceneManagers.Length-1] = SM;
	}

	if ( CustomCrosshairsAllowed() )
		SetCustomCrosshairs();
}

function bool CustomCrosshairsAllowed()
{
	return true;
}

function bool CustomCrosshairColorAllowed()
{
	return true;
}

function bool CustomHUDColorAllowed()
{
	return true;
}

function SetCustomCrosshairs()
{
	local int i;
	local array<CacheManager.CrosshairRecord> CustomCrosshairs;

	class'CacheManager'.static.GetCrosshairList(CustomCrosshairs);
	Crosshairs.Length = CustomCrosshairs.Length;
	for (i = 0; i < CustomCrosshairs.Length; i++)
	{
		Crosshairs[i].WidgetTexture = CustomCrosshairs[i].CrosshairTexture;
		Crosshairs[i].TextureCoords.X1 = 0;
		Crosshairs[i].TextureCoords.X2 = 64;
		Crosshairs[i].TextureCoords.Y1 = 0;
		Crosshairs[i].TextureCoords.Y2 = 64;
		Crosshairs[i].TextureScale = 0.75;
		Crosshairs[i].DrawPivot = DP_MiddleMiddle;
		Crosshairs[i].PosX = 0.5;
		Crosshairs[i].PosY = 0.5;
		Crosshairs[i].OffsetX = 0;
		Crosshairs[i].OffsetY = 0;
		Crosshairs[i].ScaleMode = SM_None;
		Crosshairs[i].Scale = 1.0;
		Crosshairs[i].RenderStyle = STY_Alpha;
	}

	if ( CustomCrosshairColorAllowed() )
		SetCustomCrosshairColors();
}

function SetCustomCrosshairColors()
{
	local int i, j;

	for (i = 0; i < Crosshairs.Length; i++)
		for (j = 0; j < 2; j++)
			Crosshairs[i].Tints[j] = CrosshairColor;
}

function SetCustomHUDColor()
{
	if ( !CustomHUDColorAllowed() || ((CustomHUDColor.R == 0) && (CustomHUDColor.G == 0) && (CustomHUDColor.B == 0) && (CustomHUDColor.A == 0)) )
	{
		CustomHUDColor = HudColorBlack;
		CustomHUDColor.A = 0;
		HudColorRed = HudColorTeam[0];
		HudColorBlue = HudColorTeam[1];
		bUsingCustomHUDColor = false;
		return;
	}

	bUsingCustomHUDColor = true;
	HudColorRed = CustomHUDColor;
	HudColorBlue = CustomHUDColor;
}

function CheckCountdown(GameReplicationInfo GRI)
{
	if ( (GRI == None) || (GRI.RemainingTime == 0) || (GRI.RemainingTime == OldRemainingTime) || (GRI.Winner != None) )
		return;

	OldRemainingTime = GRI.RemainingTime;
	if ( OldRemainingTime > 300 )
		return;
	if ( OldRemainingTime > 30 )
	{
		if ( OldRemainingTime == 300 )
			PlayerOwner.PlayStatusAnnouncement(LongCountName[0],1,true);
		else if ( OldRemainingTime == 180 )
			PlayerOwner.PlayStatusAnnouncement(LongCountName[1],1,true);
		else if ( OldRemainingTime == 120 )
			PlayerOwner.PlayStatusAnnouncement(LongCountName[2],1,true);
		else if ( OldRemainingTime == 60 )
			PlayerOwner.PlayStatusAnnouncement(LongCountName[3],1,true);
		return;
	}
	if ( OldRemainingTime == 30 )
		PlayerOwner.PlayStatusAnnouncement(LongCountName[4],1,true);
	else if ( OldRemainingTime == 20 )
		PlayerOwner.PlayStatusAnnouncement(LongCountName[5],1,true);
	else if ( (OldRemainingTime <= 10) && (OldRemainingTime > 0) )
		PlayerOwner.PlayStatusAnnouncement(CountDownName[OldRemainingTime - 1],1,true);
}

simulated function Tick(float deltaTime)
{
	local Material NewPortrait;

	Super.Tick(deltaTime);
	// Setup the player portrait to display an incoming voice chat message
	if ( (Level.TimeSeconds - LastPlayerIDTalkingTime < 0.1) && (PlayerOwner.GameReplicationInfo != None) )
	{
		if ( (PortraitPRI == None) || (PortraitPRI.PlayerID != LastPlayerIDTalking) )
		{
			PortraitPRI = PlayerOwner.GameReplicationInfo.FindPlayerByID(LastPlayerIDTalking);
			if ( PortraitPRI != None )
			{
				NewPortrait = PortraitPRI.GetPortrait();
				if ( NewPortrait != None )
				{
					if ( Portrait == None )
						PortraitX = 1;
					Portrait = NewPortrait;
					PortraitTime = Level.TimeSeconds + 3;
				}
			}
		}
		else
			PortraitTime = Level.TimeSeconds + 0.2;
	}
	else
		LastPlayerIDTalking = 0;

	if ( PortraitTime - Level.TimeSeconds > 0 )
		PortraitX = FMax(0,PortraitX-3*deltaTime);
	else if ( Portrait != None )
	{
		PortraitX = FMin(1,PortraitX+3*deltaTime);
		if ( PortraitX == 1 )
		{
			Portrait = None;
			PortraitPRI = None;
		}
	}
}

simulated function UpdateHud()
{
	if ((PawnOwnerPRI != none) && (PawnOwnerPRI.Team != None))
		TeamIndex = Clamp (PawnOwnerPRI.Team.TeamIndex, 0, 1);
	else
		TeamIndex = 1; // default to the blue HUD because it's sexier

	CalculateHealth();
	CalculateAmmo();
	CalculateShield();
	CalculateEnergy();
	CalculateScore();
	DigitsHealth.Value    = CurHealth;
	DigitsVehicleHealth.Value = CurVehicleHealth;
	DigitsAmmo.Value      = CurAmmoPrimary;
	DigitsShield.Value    = CurShield;
	AdrenalineCount.Value = CurEnergy;
	MyScore.Value    = CurScore;
	Super.UpdateHud ();
}

function DrawVehicleName(Canvas C)
{
	local float XL,YL, Fade;

	if (bHideWeaponName)
		return;

	if (VehicleDrawTimer>Level.TimeSeconds)
	{
		C.Font = GetMediumFontFor(C);
		C.DrawColor = WhiteColor;
		Fade = VehicleDrawTimer - Level.TimeSeconds;
		if (Fade<=1)
			C.DrawColor.A = 255 * Fade;

		C.Strlen(VehicleName,XL,YL);
		C.SetPos( (C.ClipX/2) - (XL/2), C.ClipY*0.8-YL);
		C.DrawText(VehicleName);
	}

	if ( (PawnOwner != PlayerOwner.Pawn) || (PawnOwner == OldPawn) )
		return;

	OldPawn = PawnOwner;
	if ( Vehicle(PawnOwner) == None )
		VehicleDrawTimer = FMin(VehicleDrawTimer,Level.TimeSeconds + 1);
	else
	{
		VehicleName = Vehicle(PawnOwner).VehicleNameString;
		VehicleDrawTimer = Level.TimeSeconds+1.5;
	}
}

simulated function DrawAdrenaline( Canvas C )
{
	if ( !PlayerOwner.bAdrenalineEnabled )
		return;

	DrawWidgetAsTile( C, AdrenalineBackground );
	if( CurEnergy == MaxEnergy )
	{
		DrawWidgetAsTile( C, AdrenalineAlert );
		AdrenalineAlert.Tints[TeamIndex] = HudColorHighLight;
	}

	DrawWidgetAsTile( C, AdrenalineIcon );
	DrawNumericWidgetAsTiles( C, AdrenalineCount, DigitsBig);
	if(CurEnergy > LastEnergy)
		LastAdrenalineTime = Level.TimeSeconds;

	LastEnergy = CurEnergy;
	DrawHUDAnimWidget( AdrenalineIcon, default.AdrenalineIcon.TextureScale, LastAdrenalineTime, 0.5, 0.15);
	AdrenalineBackground.Tints[0] = HudColorRed;
	AdrenalineBackground.Tints[1] = HudColorBlue;
}

// <Render Shields> ============================================================
// <summary>
// Here we will draw on top of the base textures for each of the shieldtypes
// the player has. This allows us to compound items (e.g. the Belt and the Pads!)
// </summary>
// <remarks>
// Writen by Brian 'Snake.PLiSKiN' Alexander
//  (c) 2005, UTR.  All Rights Reserved
// </remarks>
// <param name="C">Canvas</param>
simulated function DrawShieldMan( Canvas C )
{
	DrawWidgetAsTile( C, HudBorderShield );
	DrawWidgetAsTile( C, HudBorderShieldIcon );

	// Start off by drawing our base texture of the player
	//TODO - Show the Merc Female
	if ( PawnOwnerPRI.bIsFemale && ShieldFemaleIcon.WidgetTexture != none )
		DrawWidgetAsTile (C, ShieldFemaleIcon);
	else
		DrawWidgetAsTile (C, ShieldManIcon);
	//	ShieldManIcon.Tints[TeamIndex] = HudColorTeam[TeamIndex];
	
	if (UT2341Pawn(PawnOwner) != None)
	{
		if (bShieldbelt || PawnOwner.ShieldStrength > 0)
		{
			DrawWidgetAsTile (C, ShieldBeltIcon);
			// Changes color depending on the belts shield charge
			ShieldBeltIcon.Tints[TeamIndex] = HudColorNormal * FMin(PawnOwner.ShieldStrength / UT2341Pawn(PawnOwner).ShieldStrengthMax,1);
			//DrawHUDAnimWidget( ShieldBeltIcon, Default.ShieldBeltIcon.TextureScale, LastArmorPickupTime, 0.6, 0.6);
		}

		if (bChestArmor ||  UT2341Pawn(PawnOwner).ArmorStrength > 0)
		{
			DrawWidgetAsTile (C, ShieldBodyArmorIcon);
			ShieldBodyArmorIcon.Tints[TeamIndex] = HudColorNormal * FMin(UT2341Pawn(PawnOwner).ArmorStrength / 100.0f,1);
			//DrawHUDAnimWidget( ShieldBodyArmorIcon, Default.ShieldBodyArmorIcon.TextureScale, LastArmorPickupTime, 0.6, 0.6);
		}

		if (bThighArmor)
		{
			DrawWidgetAsTile (C, ShieldThighPadsIcon);
			ShieldThighPadsIcon.Tints[TeamIndex] = HudColorNormal * FMin(0.01 * ThighAmount,1);
			DrawHUDAnimWidget( ShieldThighPadsIcon, Default.ShieldThighPadsIcon.TextureScale, LastArmorPickupTime, 0.6, 0.6);
		}

		if (bJumpBoots)
		{
			DrawWidgetAsTile (C, ShieldBootsIcon);
			DrawHUDAnimWidget( ShieldBootsIcon, Default.ShieldBootsIcon.TextureScale, LastArmorPickupTime, 0.6, 0.6);
		}
	}

	// Draw the Shields value
	DrawNumericWidgetAsTiles (C, DigitsShield, DigitsBig);
}
// </Render Shields> ============================================================

simulated function DrawTimer(Canvas C)
{
	local GameReplicationInfo GRI;
	local int Minutes, Hours, Seconds;

	if ( !bShowChatBackground )
	{
		DrawTimerNoChatbox(C);
		return;
	}

	GRI = PlayerOwner.GameReplicationInfo;
	if ( GRI.TimeLimit != 0 )
		Seconds = GRI.RemainingTime;
	else
		Seconds = GRI.ElapsedTime;


	TimerBackground.Tints[TeamIndex] = HudColorBlack;
	TimerBackground.Tints[TeamIndex].A = 150;
	DrawWidgetAsTile( C, TimerBackground);
	DrawWidgetAsTile( C, TimerIcon);
	TimerMinutes.OffsetX = Default.TimerMinutes.OffsetX - 80;
	TimerSeconds.OffsetX = default.TimerSeconds.OffsetX - 80;
	TimerDigitSpacer[0].OffsetX = Default.TimerDigitSpacer[0].OffsetX;
	TimerDigitSpacer[1].OffsetX = Default.TimerDigitSpacer[1].OffsetX;
	if( Seconds > 3600 )
	{
		Hours = Seconds / 3600;
		Seconds -= Hours * 3600;
		DrawNumericWidgetAsTiles( C, TimerHours, DigitsBig);
		TimerHours.Value = Hours;
		if(Hours>9)
		{
			TimerMinutes.OffsetX = default.TimerMinutes.OffsetX;
			TimerSeconds.OffsetX = default.TimerSeconds.OffsetX;
		}
		else
		{
			TimerMinutes.OffsetX = default.TimerMinutes.OffsetX -40;
			TimerSeconds.OffsetX = default.TimerSeconds.OffsetX -40;
			TimerDigitSpacer[0].OffsetX = Default.TimerDigitSpacer[0].OffsetX - 32;
			TimerDigitSpacer[1].OffsetX = Default.TimerDigitSpacer[1].OffsetX - 32;
		}
		DrawWidgetAsTile( C, TimerDigitSpacer[0]);
	}
	DrawWidgetAsTile( C, TimerDigitSpacer[1]);
	Minutes = Seconds / 60;
	Seconds -= Minutes * 60;
	TimerMinutes.Value = Min(Minutes, 60);
	TimerSeconds.Value = Min(Seconds, 60);
	DrawNumericWidgetAsTiles( C, TimerMinutes, DigitsBig);
	DrawNumericWidgetAsTiles( C, TimerSeconds, DigitsBig);
}

simulated function DrawTimerNoChatbox(Canvas C)
{
	local GameReplicationInfo GRI;
	local int Minutes, Hours, Seconds;

	if ( bShowChatBackground )
	{
		DrawTimer(C);
		return;
	}

	GRI = PlayerOwner.GameReplicationInfo;
	if ( GRI.TimeLimit != 0 )
		Seconds = GRI.RemainingTime;
	else
		Seconds = GRI.ElapsedTime;

	Timer2Background.Tints[TeamIndex] = HudColorBlack;
	Timer2Background.Tints[TeamIndex].A = 150;
	DrawWidgetAsTile( C, Timer2Background);
	DrawWidgetAsTile( C, Timer2Icon);
	Timer2Minutes.OffsetX = Default.Timer2Minutes.OffsetX - 80;
	Timer2Seconds.OffsetX = default.Timer2Seconds.OffsetX - 80;
	Timer2DigitSpacer[0].OffsetX = Default.Timer2DigitSpacer[0].OffsetX;
	Timer2DigitSpacer[1].OffsetX = Default.Timer2DigitSpacer[1].OffsetX;
	if( Seconds > 3600 )
	{
		Hours = Seconds / 3600;
		Seconds -= Hours * 3600;
		DrawNumericWidgetAsTiles( C, Timer2Hours, DigitsBig);
		Timer2Hours.Value = Hours;
		if(Hours>9)
		{
			Timer2Minutes.OffsetX = default.Timer2Minutes.OffsetX;
			Timer2Seconds.OffsetX = default.Timer2Seconds.OffsetX;
		}
		else
		{
			Timer2Minutes.OffsetX = default.Timer2Minutes.OffsetX -40;
			Timer2Seconds.OffsetX = default.Timer2Seconds.OffsetX -40;
			Timer2DigitSpacer[0].OffsetX = Default.Timer2DigitSpacer[0].OffsetX - 32;
			Timer2DigitSpacer[1].OffsetX = Default.Timer2DigitSpacer[1].OffsetX - 32;
		}
		DrawWidgetAsTile( C, Timer2DigitSpacer[0]);
	}
	DrawWidgetAsTile( C, Timer2DigitSpacer[1]);
	Minutes = Seconds / 60;
	Seconds -= Minutes * 60;
	Timer2Minutes.Value = Min(Minutes, 60);
	Timer2Seconds.Value = Min(Seconds, 60);
	DrawNumericWidgetAsTiles( C, Timer2Minutes, DigitsBig);
	DrawNumericWidgetAsTiles( C, Timer2Seconds, DigitsBig);
}

simulated function DrawUDamage( Canvas C )
{
	local xPawn P;

	if (Vehicle(PawnOwner) != None)
		P = xPawn(Vehicle(PawnOwner).Driver);
	else
		P = xPawn(PawnOwner);

	if (P != None && P.UDamageTime > Level.TimeSeconds)
	{
		if (P.UDamageTime > Level.TimeSeconds + 15 )
			UDamageIcon.TextureScale = default.UDamageIcon.TextureScale * FMin((P.UDamageTime - Level.TimeSeconds)* 0.0333,1);

		DrawWidgetAsTile(C, UDamageIcon);
		UDamageTime.Value = P.UDamageTime - Level.TimeSeconds ;
		DrawNumericWidgetAsTiles(C, UDamageTime, DigitsBig);
	}
}

simulated function UpdateRankAndSpread(Canvas C)
{
	local int i;

	if ( (Scoreboard == None) || !Scoreboard.UpdateGRI() )
		return;
		
	PlayersInGame = 0;

	for( i=0 ; i<PlayerOwner.GameReplicationInfo.PRIArray.Length ; i++ )
	{
		if(PawnOwnerPRI == PlayerOwner.GameReplicationInfo.PRIArray[i])
			myRank = (i+1);
		if (!PlayerOwner.GameReplicationInfo.PRIArray[i].bOnlySpectator)
			++PlayersInGame;
	}

		myScore.Value = Min (PawnOwnerPRI.Score, 999);  // max display space
		if ( PawnOwnerPRI == PlayerOwner.GameReplicationInfo.PRIArray[0] )
		{
			if ( PlayerOwner.GameReplicationInfo.PRIArray.Length > 1 )
				mySpread = Min (PawnOwnerPRI.Score - PlayerOwner.GameReplicationInfo.PRIArray[1].Score, 999);
			else
				mySpread = 0;
		}
		else
			mySpread = Min (PawnOwnerPRI.Score - PlayerOwner.GameReplicationInfo.PRIArray[0].Score, 999);

		if( bShowPoints )
		{
			DrawWidgetAsTile( C, MyScoreBackground );
			MyScoreBackground.Tints[TeamIndex] = HudColorBlack;
			MyScoreBackground.Tints[TeamIndex].A = 150;

			DrawWidgetAsTile( C, MyScoreBackground );
			DrawWidgetAsTile( C, MyScoreIcon );

			DrawNumericWidgetAsTiles (C, myScore, DigitsBig);
		}
}

simulated function CalculateHealth()
{
	LastHealth = CurHealth;

	if (Vehicle(PawnOwner) != None)
	{
		if ( Vehicle(PawnOwner).Driver != None )
			CurHealth = Vehicle(PawnOwner).Driver.Health;
		LastVehicleHealth = CurVehicleHealth;
		CurVehicleHealth = PawnOwner.Health;
	}
	else
	{
		CurHealth = PawnOwner.Health;
		CurVehicleHealth = 0;
	}
}

simulated function CalculateShield()
{
	local UT2341Pawn P;
	Local int ArmorAmount; //, Count;
	//local inventory Inv;

	LastShield = CurShield;
	if (Vehicle(PawnOwner) != None)
		P = UT2341Pawn(Vehicle(PawnOwner).Driver);
	else
		P = UT2341Pawn(PawnOwner);

	// Reset these before getting the current values
	ArmorAmount = 0;
	BeltAmount = 0;
	ThighAmount = 0;
	ChestAmount = 0;
	bShieldbelt = False;
	bChestArmor = False;
	bThighArmor = False;
	bJumpBoots = False;
	
    if( P != None )
    {
        MaxShield = P.ShieldStrengthMax;
        CurShield = Clamp(P.GetShieldStrength(), 0, MaxShield);
    }
    else
    {
        MaxShield = 100;
        CurShield = 0;
    }
	/*
	if( P != None )
	{
		for( Inv=P.Inventory; Inv!=None; Inv=Inv.Inventory )
		{
			Count++;
			if ( Count > 100 )
				Break;

			if (UTRArmor(Inv) != None && UTRArmor(Inv).bIsAnArmor)
			{
				if ( Inv.IsA('UTRShieldbelt') )
				{
					bShieldbelt = True;
					BeltAmount += Inv.Charge;
				}
				else if ( Inv.IsA('UTRThighpads') )
				{
					bThighArmor = True;
					ThighAmount += Inv.Charge;
				}
				else if ( Inv.IsA('UTRBodyArmor') )
				{
					bChestArmor = True;
					ChestAmount += Inv.Charge;
				}
				ArmorAmount += Inv.Charge;
			}
			else if ( Inv.IsA('UTRBootsOfJumping') )
				bJumpBoots = True;
		}

		MaxShield = P.ShieldStrengthMax;
		CurShield = Clamp(ArmorAmount, 0, MaxShield);
	}

	else
	{
		MaxShield = 100;
		CurShield = 0;
	}
	*/
}

simulated function CalculateEnergy()
{
	if ( PawnOwner.Controller == None )
	{
		MaxEnergy = PlayerOwner.AdrenalineMax;
		CurEnergy = Clamp (PlayerOwner.Adrenaline, 0, MaxEnergy);
	}
	else
	{
		MaxEnergy = PawnOwner.Controller.AdrenalineMax;
		CurEnergy = Clamp (PawnOwner.Controller.Adrenaline, 0, MaxEnergy);
	}
}

simulated function CalculateAmmo()
{
	MaxAmmoPrimary = 1;
	CurAmmoPrimary = 1;

	if ( (PawnOwner != none) && (PawnOwner.Weapon != none) )
		PawnOwner.Weapon.GetAmmoCount(MaxAmmoPrimary,CurAmmoPrimary);
}

simulated function CalculateScore()
{
	ScoreDiff = CurScore;
	CurScore = PawnOwnerPRI.Score;
}

simulated function string GetScoreText()
{
	return ScoreText;
}

simulated function string GetScoreValue(PlayerReplicationInfo PRI)
{
	return ""$int(PRI.Score);
}

simulated function string GetScoreTagLine()
{
	return InitialViewingString;
}

static function color GetTeamColor( byte TeamNum )
{
	if ( TeamNum == 1 )
		return default.HudColorTeam[1];
	else return default.HudColorTeam[0];
}

function bool IsInCinematic()
{
	local int i;

	if ( MySceneManagers.Length > 0 )
	{
		for ( i=0; i<MySceneManagers.Length; i++ )
			if ( MySceneManagers[i].bIsRunning )
				return true;
	}
	return false;
}

simulated function DrawSpectatingHud (Canvas C)
{
	local string InfoString;
	local plane OldModulate;
	local float xl,yl,Full, Height, Top, TextTop, MedH, SmallH,Scale;
	local GameReplicationInfo GRI;

	// Hack for tutorials.
	bIsCinematic = IsInCinematic();
	DisplayLocalMessages (C);
	if ( bIsCinematic )
		return;

	OldModulate = C.ColorModulate;
	C.Font = GetMediumFontFor(C);
	C.StrLen("W",xl,MedH);
	Height = MedH;
	C.Font = GetConsoleFont(C);
	C.StrLen("W",xl,SmallH);
	Height += SmallH;
	Full = Height;
	Top  = C.ClipY-8-Full;
	scale = (Full+16)/128;
	// I like Yellow
	C.ColorModulate.X=255;
	C.ColorModulate.Y=255;
	C.ColorModulate.Z=0;
	C.ColorModulate.W=255;
	// Draw Border
	C.SetPos(0,Top);
	C.SetDrawColor(255,255,255,255);
	C.DrawTileStretched(material'InterfaceContent.SquareBoxA',C.ClipX,Full);
	C.ColorModulate.Z=255;
	TextTop = Top + 4;
	GRI = PlayerOwner.GameReplicationInfo;
	C.SetPos(0,Top-8);
	C.Style=5;
	C.DrawTile(material'LMSLogoSmall',256*Scale,128*Scale,0,0,256,128);
	C.Style=1;
	if ( UnrealPlayer(Owner).bDisplayWinner ||  UnrealPlayer(Owner).bDisplayLoser )
	{
		if ( UnrealPlayer(Owner).bDisplayWinner )
			InfoString = YouveWonTheMatch;
		else
		{
			if ( PlayerReplicationInfo(PlayerOwner.GameReplicationInfo.Winner) != None )
				InfoString = WonMatchPrefix$PlayerReplicationInfo(PlayerOwner.GameReplicationInfo.Winner).PlayerName$WonMatchPostFix;
			else
				InfoString = YouveLostTheMatch;
		}

		C.SetDrawColor(255,255,255,255);
		C.Font = GetMediumFontFor(C);
		C.StrLen(InfoString,XL,YL);
		C.SetPos( (C.ClipX/2) - (XL/2), Top + (Full/2) - (YL/2));
		C.DrawText(InfoString,false);
	}
	else if ( Pawn(PlayerOwner.ViewTarget) != None && Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo != None )
	{
		// Draw View Target info
		C.SetDrawColor(32,255,32,255);
		if ( C.ClipX < 640 )
			SmallH = 0;
		else
		{
			// Draw "Now Viewing"
			C.SetPos((256*scale*0.75),TextTop);
			C.DrawText(NowViewing,false);
			// Draw "Score"
			InfoString = GetScoreText();
			C.StrLen(InfoString,Xl,Yl);
			C.SetPos(C.ClipX-5-XL,TextTop);
			C.DrawText(InfoString);
		}

		// Draw Player Name
		C.SetDrawColor(255,255,0,255);
		C.Font = GetMediumFontFor(C);
		C.SetPos((256*Scale*0.75),TextTop+SmallH);
		C.DrawText(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo.PlayerName,false);
		// Draw Score
		InfoString = GetScoreValue(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo);
		C.StrLen(InfoString,xl,yl);
		C.SetPos(C.ClipX-5-XL,TextTop+SmallH);
		C.DrawText(InfoString,false);
		// Draw Tag Line
		C.Font = GetConsoleFont(C);
		InfoString = GetScoreTagLine();
		C.StrLen(InfoString,xl,yl);
		C.SetPos( (C.ClipX/2) - (XL/2),Top-3-YL);
		C.DrawText(InfoString);
	}
	else
	{
		InfoString = GetInfoString();
		// Draw
		C.SetDrawColor(255,255,255,255);
		C.Font = GetMediumFontFor(C);
		C.StrLen(InfoString,XL,YL);
		C.SetPos( (C.ClipX/2) - (XL/2), Top + (Full/2) - (YL/2));
		C.DrawText(InfoString,false);
	}

	C.ColorModulate = OldModulate;
}

simulated function String GetInfoString()
{
	local string InfoString;

	if ( PlayerOwner.IsDead() )
	{
		if ( PlayerOwner.PlayerReplicationInfo.bOutOfLives )
			InfoString = class'ScoreboardDeathMatch'.default.OutFireText;
		else if ( Level.TimeSeconds - UnrealPlayer(PlayerOwner).LastKickWarningTime < 2 )
			InfoString = class'GameMessage'.Default.KickWarning;
		else
			InfoString = class'ScoreboardDeathMatch'.default.Restart;
	}
	else if ( Level.TimeSeconds - UnrealPlayer(PlayerOwner).LastKickWarningTime < 2 )
		InfoString = class'GameMessage'.Default.KickWarning;
	else if ( GUIController(PlayerOwner.Player.GUIController).ActivePage!=None)
		InfoString = AtMenus;
	else if ( (PlayerOwner.PlayerReplicationInfo != None) && PlayerOwner.PlayerReplicationInfo.bWaitingPlayer )
		InfoString = WaitingToSpawn;
	else
		InfoString = InitialViewingString;

	return InfoString;
}

// ====================
simulated function DrawHUDAnimDigit( out NumericWidget HUDPiece, float DefaultScale, float PickUPTime, float AnimTime, color defaultColor, color colorHighlight)
{
	if ( PickUPTime > Level.TimeSeconds - AnimTime)
	{
		HUDPiece.Tints[TeamIndex].R = colorHighlight.R + ((  defaultColor.R  - colorHighlight.R) * (Level.TimeSeconds - PickUPTime));
		HUDPiece.Tints[TeamIndex].B = colorHighlight.B + ((  defaultColor.B  - colorHighlight.B) * (Level.TimeSeconds - PickUPTime));
		HUDPiece.Tints[TeamIndex].G = colorHighlight.G + ((  defaultColor.G  - colorHighlight.G) * (Level.TimeSeconds - PickUPTime));
	}
	else
		HUDPiece.Tints[TeamIndex] = defaultColor;
}

simulated function DrawHUDAnimWidget( out SpriteWidget HUDPiece, float DefaultScale, float PickUPTime, float AnimTime, float AnimScale)
{
	if ( PickUPTime > Level.TimeSeconds - AnimTime)
	{
		if ( PickUPTime > Level.TimeSeconds - AnimTime/2 )
			HUDPiece.TextureScale = DefaultScale * (1 + AnimScale * (Level.TimeSeconds - PickUPTime));
		else
			HUDPiece.TextureScale = DefaultScale * (1 + AnimScale * (PickUPTime + AnimTime - Level.TimeSeconds));
	}
	else
		HUDPiece.TextureScale = DefaultScale;
}

simulated function DrawCrosshair (Canvas C)
{
	local float NormalScale;
	local int i, CurrentCrosshair;
	local float OldScale,OldW, CurrentCrosshairScale;
	local color CurrentCrosshairColor;
	local SpriteWidget CHtexture;

	if ( PawnOwner.bSpecialCrosshair )
	{
		PawnOwner.SpecialDrawCrosshair( C );
		return;
	}

	if (!bCrosshairShow)
		return;

	if ( bUseCustomWeaponCrosshairs && (PawnOwner != None) && (PawnOwner.Weapon != None) )
	{
		CurrentCrosshair = PawnOwner.Weapon.CustomCrosshair;
		if (CurrentCrosshair == -1 || CurrentCrosshair == Crosshairs.Length)
		{
			CurrentCrosshair = CrosshairStyle;
			CurrentCrosshairColor = CrosshairColor;
			CurrentCrosshairScale = CrosshairScale;
		}
		else
		{
			CurrentCrosshairColor = PawnOwner.Weapon.CustomCrosshairColor;
			CurrentCrosshairScale = PawnOwner.Weapon.CustomCrosshairScale;
			if ( PawnOwner.Weapon.CustomCrosshairTextureName != "" )
			{
				if ( PawnOwner.Weapon.CustomCrosshairTexture == None )
				{
					PawnOwner.Weapon.CustomCrosshairTexture = Texture(DynamicLoadObject(PawnOwner.Weapon.CustomCrosshairTextureName,class'Texture'));
					if ( PawnOwner.Weapon.CustomCrosshairTexture == None )
					{
						log(PawnOwner.Weapon$" custom crosshair texture not found!");
						PawnOwner.Weapon.CustomCrosshairTextureName = "";
					}
				}
				CHTexture = Crosshairs[0];
				CHTexture.WidgetTexture = PawnOwner.Weapon.CustomCrosshairTexture;
			}
		}
	}
	else
	{
		CurrentCrosshair = CrosshairStyle;
		CurrentCrosshairColor = CrosshairColor;
		CurrentCrosshairScale = CrosshairScale;
	}

	CurrentCrosshair = Clamp(CurrentCrosshair, 0, Crosshairs.Length - 1);
	NormalScale = Crosshairs[CurrentCrosshair].TextureScale;
	if ( CHTexture.WidgetTexture == None )
		CHTexture = Crosshairs[CurrentCrosshair];
	CHTexture.TextureScale *= 0.5 * CurrentCrosshairScale;
	for( i = 0; i < ArrayCount(CHTexture.Tints); i++ )
		CHTexture.Tints[i] = CurrentCrossHairColor;

	if ( LastPickupTime > Level.TimeSeconds - 0.4 )
	{
		if ( LastPickupTime > Level.TimeSeconds - 0.2 )
			CHTexture.TextureScale *= (1 + 5 * (Level.TimeSeconds - LastPickupTime));
		else
			CHTexture.TextureScale *= (1 + 5 * (LastPickupTime + 0.4 - Level.TimeSeconds));
	}
	OldScale = HudScale;
	HudScale=1;
	OldW = C.ColorModulate.W;
	C.ColorModulate.W = 1;
	DrawWidgetAsTile (C, CHTexture);
	C.ColorModulate.W = OldW;
	HudScale=OldScale;
	CHTexture.TextureScale = NormalScale;

	DrawEnemyName(C);
}

function DrawEnemyName(Canvas C)
{
	local actor HitActor;
	local vector HitLocation,HitNormal,ViewPos;

	if ( PlayerOwner.bBehindView || bNoEnemyNames || (PawnOwner.Controller == None) )
		return;
	ViewPos = PawnOwner.Location + PawnOwner.BaseEyeHeight * vect(0,0,1);
	HitActor = trace(HitLocation,HitNormal,ViewPos+1200*vector(PawnOwner.Controller.Rotation),ViewPos,true);
	if ( (Pawn(HitActor) != None) && (Pawn(HitActor).PlayerReplicationInfo != None)
		&& (HitActor != PawnOwner)
		&& ( (PawnOwner.PlayerReplicationInfo.Team == None) || (PawnOwner.PlayerReplicationInfo.Team != Pawn(HitActor).PlayerReplicationInfo.Team)) )
	{
		if ( (NamedPlayer != Pawn(HitActor).PlayerReplicationInfo) || (Level.TimeSeconds - NameTime > 0.5) )
		{
			DisplayEnemyName(C, Pawn(HitActor).PlayerReplicationInfo);
			NameTime = Level.TimeSeconds;
		}
		NamedPlayer = Pawn(HitActor).PlayerReplicationInfo;
	}
}

function DisplayEnemyName(Canvas C, PlayerReplicationInfo PRI)
{
	PlayerOwner.ReceiveLocalizedMessage(class'PlayerNameMessage',0,PRI);
}

function FadeZoom()
{
	if ( (PawnOwner != None) && (PawnOwner.Weapon != None)
		&& PawnOwner.Weapon.WantsZoomFade() )
		ZoomToggleTime = Level.TimeSeconds;
}

function ZoomFadeOut(Canvas C)
{
	local float FadeValue;

	if ( Level.TimeSeconds - ZoomToggleTime >= FadeTime )
		return;
	if ( ZoomToggleTime > Level.TimeSeconds )
		ZoomToggleTime = Level.TimeSeconds;

	FadeValue = 255 * ( 1.0 - (Level.TimeSeconds - ZoomToggleTime)/FadeTime);
	C.DrawColor.A = FadeValue;
	C.Style = ERenderStyle.STY_Alpha;
	C.SetPos(0,0);
	C.DrawTile( Texture'Engine.BlackTexture', C.SizeX, C.SizeY, 0.0, 0.0, 16, 16);
}

function DisplayVoiceGain(Canvas C)
{
	local Texture Tex;
	local float VoiceGain;
	local float PosY, BlockSize, XL, YL;
	local int i;
	local string ActiveName;

	BlockSize = 8192/C.ClipX * HUDScale;
	Tex = Texture'engine.WhiteSquareTexture';
	PosY = C.ClipY * 0.375;
	VoiceGain = (1 - 3 * Min( Level.TimeSeconds - LastVoiceGainTime, 0.3333 )) * LastVoiceGain;

	for( i=0; i<10; i++ )
	{
		if( VoiceGain > (0.1 * i) )
		{
			C.SetPos( 0.5 * BlockSize, PosY );
			C.SetDrawColor( 28.3 * i, 255 - 28.3 * i, 0, 255 );
			C.DrawTile( Tex, BlockSize, BlockSize, 0, 0, Tex.USize, Tex.VSize );
			PosY -= 1.2 * BlockSize;
		}
	}

	// Display name of currently active channel
	if ( PlayerOwner != None && PlayerOwner.ActiveRoom != None )
		ActiveName = PlayerOwner.ActiveRoom.GetTitle();

	if ( ActiveName != "" )
	{
		ActiveName = "(" @ ActiveName @ ")";
		C.Font = GetFontSizeIndex(C,-2);
		C.StrLen(ActiveName,XL,YL);
		if ( XL > 0.125 * C.ClipY )
		{
			C.Font = GetFontSizeIndex(C,-4);
			C.StrLen(ActiveName,XL,YL);
		}

		C.SetPos( BlockSize * 2, (C.ClipY * 0.375 + BlockSize) - YL );
		C.DrawColor = C.MakeColor(160,160,160);
		if ( PlayerOwner != None && PlayerOwner.PlayerReplicationInfo != None )
		{
			if ( PlayerOwner.PlayerReplicationInfo.Team != None )
			{
				if ( PlayerOwner.PlayerReplicationInfo.Team.TeamIndex == 0 )
					C.DrawColor = RedColor;
				else
					C.DrawColor = TurqColor;
			}
		}

		C.DrawText( ActiveName );
	}
}

// Alpha Pass ==================================================================================
simulated function DrawHudPassA (Canvas C)
{
	local Pawn RealPawnOwner;
	local class<Ammunition> AmmoClass;

	ZoomFadeOut(C);
	if ( PawnOwner != None )
	{
		if( bShowWeaponInfo && (PawnOwner.Weapon != None) )
		{
			if ( PawnOwner.Weapon.bShowChargingBar )
				DrawChargeBar(C);

			DrawWidgetAsTile( C, HudBorderAmmo );
			if( PawnOwner.Weapon != None )
			{
				AmmoClass = PawnOwner.Weapon.GetAmmoClass(0);
				if ( (AmmoClass != None) && (AmmoClass.Default.IconMaterial != None) )
				{
					if( (CurAmmoPrimary/MaxAmmoPrimary) < 0.15)
					{
						DrawWidgetAsTile(C, HudAmmoALERT);
						HudAmmoALERT.Tints[TeamIndex] = HudColorTeam[TeamIndex];
						if ( AmmoClass.Default.IconFlashMaterial == None )
							AmmoIcon.WidgetTexture = Default.HUDPulseTex;
						else
							AmmoIcon.WidgetTexture = AmmoClass.Default.IconFlashMaterial;
					}
					else
					{
						AmmoIcon.WidgetTexture = AmmoClass.default.IconMaterial;
					}

					AmmoIcon.TextureCoords = AmmoClass.Default.IconCoords;
					DrawWidgetAsTile (C, AmmoIcon);
				}
			}
			DrawNumericWidgetAsTiles( C, DigitsAmmo, DigitsBig);
		}

		if ( bShowWeaponBar && (PawnOwner.Weapon != None) )
			DrawWeaponBar(C);

		if( bShowPersonalInfo )
		{

			if ( Vehicle(PawnOwner) != None && Vehicle(PawnOwner).Driver != None )
			{
				if (Vehicle(PawnOwner).bShowChargingBar)
					DrawVehicleChargeBar(C);
				RealPawnOwner = PawnOwner;
				PawnOwner = Vehicle(PawnOwner).Driver;
			}

			DrawWidgetAsTile( C, HudBorderHealth );
			DrawHUDAnimWidget( HudBorderHealthIcon, default.HudBorderHealthIcon.TextureScale, LastHealthPickupTime, 0.5, 0.15);
			//			DrawWidgetAsTile( C, MyScoreBackground );
			//			DrawWidgetAsTile( C, MyScoreIcon );
			myScoreBackground.Tints[0] = HudColorRed;
			myScoreBackground.Tints[1] = HudColorBlue;
			C.SetDrawColor(255,255,255,255);
			C.Font = GetFontSizeIndex(C,-2);
			c.SetPos(C.ClipX*0.01,C.ClipY*0.875);
			c.DrawText("Rank:"@myRank$"/"$PlayersInGame);
			c.SetPos(C.ClipX*0.01,C.ClipY*0.90);
			c.DrawText("Spread:"@mySpread);

			if(CurHealth/PawnOwner.HealthMax < 0.26)
			{
				HudHealthALERT.Tints[TeamIndex] = HudColorTeam[TeamIndex];
				DrawWidgetAsTile( C, HudHealthALERT);
				HudBorderHealthIcon.WidgetTexture = HUDPulseTex;
			}
			else
				HudBorderHealthIcon.WidgetTexture = Default.HudBorderHealth.WidgetTexture;

			// draw chat background
			if ( bShowChatBackground )
			{
				DrawWidgetAsTile( C, ChatBackground);
				ChatBackground.Tints[0] = HudColorRed;
				ChatBackground.Tints[1] = HudColorBlue;
			}
			DrawWidgetAsTile( C, HudBorderHealthIcon);
			if( CurHealth < LastHealth )
				LastDamagedHealth = Level.TimeSeconds;

			DrawHUDAnimDigit( DigitsHealth, default.DigitsHealth.TextureScale, LastDamagedHealth, 0.8, default.DigitsHealth.Tints[TeamIndex], HudColorHighLight);
			DrawNumericWidgetAsTiles( C, DigitsHealth, DigitsBig);
			if(CurHealth > 999)
			{
				DigitsHealth.OffsetX=220;
				DigitsHealth.OffsetY=-35;
				DigitsHealth.TextureScale=0.39;
			}
			else
			{
				DigitsHealth.OffsetX = Default.DigitsHealth.OffsetX;
				DigitsHealth.OffsetY = default.DigitsHealth.OffsetY;
				DigitsHealth.TextureScale = default.DigitsHealth.TextureScale;
			}

			if (RealPawnOwner != None)
			{
				PawnOwner = RealPawnOwner;
				DrawWidgetAsTile( C, HudBorderVehicleHealth );
				if (CurVehicleHealth/PawnOwner.HealthMax < 0.26)
				{
					HudVehicleHealthALERT.Tints[TeamIndex] = HudColorTeam[TeamIndex];
					DrawWidgetAsTile(C, HudVehicleHealthALERT);
					HudBorderVehicleHealthIcon.WidgetTexture = HUDPulseTex;
				}
				else
					HudBorderVehicleHealthIcon.WidgetTexture = Default.HudBorderVehicleHealth.WidgetTexture;

				DrawWidgetAsTile(C, HudBorderVehicleHealthIcon);
				if (CurVehicleHealth < LastVehicleHealth )
					LastDamagedVehicleHealth = Level.TimeSeconds;

				DrawHUDAnimDigit(DigitsVehicleHealth, default.DigitsVehicleHealth.TextureScale, LastDamagedVehicleHealth, 0.8, default.DigitsVehicleHealth.Tints[TeamIndex], HudColorHighLight);
				DrawNumericWidgetAsTiles(C, DigitsVehicleHealth, DigitsBig);
				if (CurVehicleHealth > 999)
				{
					DigitsVehicleHealth.OffsetX = 220;
					DigitsVehicleHealth.OffsetY = -35;
					DigitsVehicleHealth.TextureScale = 0.39;
				}
				else
				{
					DigitsVehicleHealth.OffsetX = Default.DigitsVehicleHealth.OffsetX;
					DigitsVehicleHealth.OffsetY = default.DigitsVehicleHealth.OffsetY;
					DigitsVehicleHealth.TextureScale = default.DigitsVehicleHealth.TextureScale;
				}
			}

			DrawAdrenaline(C);
		}
	}

	UpdateRankAndSpread(C);
	DrawUDamage(C);
	if(bDrawTimer)
		DrawTimer(C);

	// Temp Drawwwith Hud Colors
	HudBorderShield.Tints[0] = HudColorRed;
	HudBorderShield.Tints[1] = HudColorBlue;
	HudBorderHealth.Tints[0] = HudColorRed;
	HudBorderHealth.Tints[1] = HudColorBlue;
	HudBorderVehicleHealth.Tints[0] = HudColorRed;
	HudBorderVehicleHealth.Tints[1] = HudColorBlue;
	HudBorderAmmo.Tints[0] = HudColorRed;
	HudBorderAmmo.Tints[1] = HudColorBlue;

	if( bShowPersonalInfo )
		DrawShieldMan(C);

	if( Level.TimeSeconds - LastVoiceGainTime < 0.333 )
		DisplayVoiceGain(C);

	DisplayLocalMessages (C);
}

simulated function DrawHudPassC (Canvas C)
{
	local VoiceChatRoom VCR;
	local float PortraitWidth,PortraitHeight, X, Y, XL, YL, Abbrev, SmallH, NameWidth;
	local string PortraitString;

	// portrait
	if ( (bShowPortrait || (bShowPortraitVC && Level.TimeSeconds - LastPlayerIDTalkingTime < 2.0)) && (Portrait != None) )
	{
		PortraitWidth = 0.125 * C.ClipY;
		PortraitHeight = 1.5 * PortraitWidth;
		C.DrawColor = WhiteColor;
		C.SetPos(-PortraitWidth*PortraitX + 0.025*PortraitWidth,0.5*(C.ClipY-PortraitHeight) + 0.025*PortraitHeight);
		C.DrawTile( Portrait, PortraitWidth, PortraitHeight, 0, 0, 256, 384);
		C.SetPos(-PortraitWidth*PortraitX,0.5*(C.ClipY-PortraitHeight));
		C.Font = GetFontSizeIndex(C,-2);
		if ( PortraitPRI != None )
		{
			PortraitString = PortraitPRI.PlayerName;
			C.StrLen(PortraitString,XL,YL);
			if ( XL > PortraitWidth )
			{
				C.Font = GetFontSizeIndex(C,-4);
				C.StrLen(PortraitString,XL,YL);
				if ( XL > PortraitWidth )
				{
					Abbrev = float(len(PortraitString)) * PortraitWidth/XL;
					PortraitString = left(PortraitString,Abbrev);
					C.StrLen(PortraitString,XL,YL);
				}
			}
		}
		C.DrawColor = C.static.MakeColor(160,160,160);
		C.SetPos(-PortraitWidth*PortraitX + 0.025*PortraitWidth,0.5*(C.ClipY-PortraitHeight) + 0.025*PortraitHeight);
		C.DrawTile( Material'XGameShaders.ModuNoise', PortraitWidth, PortraitHeight, 0.0, 0.0, 512, 512 );
		C.DrawColor = WhiteColor;
		C.SetPos(-PortraitWidth*PortraitX,0.5*(C.ClipY-PortraitHeight));
		C.DrawTileStretched(texture 'InterfaceContent.Menu.BorderBoxA1', 1.05 * PortraitWidth, 1.05*PortraitHeight);
		C.DrawColor = WhiteColor;
		X = C.ClipY/256-PortraitWidth*PortraitX;
		Y = 0.5*(C.ClipY+PortraitHeight) + 0.06*PortraitHeight;
		C.SetPos( X + 0.5 * (PortraitWidth - XL), Y );
		if ( PortraitPRI != None )
		{
			if ( PortraitPRI.Team != None )
			{
				if ( PortraitPRI.Team.TeamIndex == 0 )
					C.DrawColor = RedColor;
				else
					C.DrawColor = TurqColor;
			}

			C.DrawText(PortraitString,true);
			if ( Level.TimeSeconds - LastPlayerIDTalkingTime < 2.0
				&& PortraitPRI.ActiveChannel != -1
				&& PlayerOwner.VoiceReplicationInfo != None )
			{
				VCR = PlayerOwner.VoiceReplicationInfo.GetChannelAt(PortraitPRI.ActiveChannel);
				if ( VCR != None )
				{
					PortraitString = "(" @ VCR.GetTitle() @ ")";
					C.StrLen( PortraitString, XL, YL );
					if ( PortraitX == 0 )
						C.SetPos( Max(0, X + 0.5 * (PortraitWidth - XL)), Y + YL );
					else C.SetPos( X + 0.5 * (PortraitWidth - XL), Y + YL );
					C.DrawText( PortraitString );
				}
			}
		}
	}

	if( bShowWeaponInfo && (PawnOwner != None) && (PawnOwner.Weapon != None) )
		PawnOwner.Weapon.NewDrawWeaponInfo(C, 0.86 * C.ClipY);

	if ( (PawnOwner != PlayerOwner.Pawn) && (PawnOwner != None)
		&& (PawnOwner.PlayerReplicationInfo != None) )
	{
		// draw viewed player name
		C.Font = GetMediumFontFor(C);
		C.SetDrawColor(255,255,0,255);
		C.StrLen(PawnOwner.PlayerReplicationInfo.PlayerName,NameWidth,SmallH);
		NameWidth = FMax(NameWidth, 0.15 * C.ClipX);
		if ( C.ClipX >= 640 )
		{
			C.Font = GetConsoleFont(C);
			C.StrLen("W",XL,SmallH);
			C.SetPos(79*C.ClipX/80 - NameWidth,C.ClipY * 0.68);
			C.DrawText(NowViewing,false);
		}

		C.Font = GetMediumFontFor(C);
		C.SetPos(79*C.ClipX/80 - NameWidth,C.ClipY * 0.68 + SmallH);
		C.DrawText(PawnOwner.PlayerReplicationInfo.PlayerName,false);
	}

	if( bShowPersonalInfo )
		DrawShieldMan(C);

	DrawCrosshair(C);
}

simulated function ShowReloadingPulse( float hold )
{
	if( hold==1.0 )
		RechargeBar.WidgetTexture = HUDPulseTex;
	else
		RechargeBar.WidgetTexture = Default.RechargeBar.WidgetTexture;
}

simulated function DrawChargeBar( Canvas C )
{
	local float ScaleFactor;

	ScaleFactor = HUDScale * 0.135 * C.ClipX;
	if (bCorrectAspectRatio)
		ScaleFactor *= ResScaleY / ResScaleX;
	C.Style = ERenderStyle.STY_Alpha;
	if ( (PawnOwner.PlayerReplicationInfo == None) || (PawnOwner.PlayerReplicationInfo.Team == None)
		|| (PawnOwner.PlayerReplicationInfo.Team.TeamIndex == 1) )
		C.DrawColor = HudColorBlue;
	else
		C.DrawColor = HudColorRed;

	C.SetPos(C.ClipX - ScaleFactor - 0.0011*HUDScale*C.ClipX, (1 - 0.0975*HUDScale)*C.ClipY);
	C.DrawTile( HUDTex, ScaleFactor, 0.223*ScaleFactor, 0, 110, 166, 53 );
	RechargeBar.Scale = PawnOwner.Weapon.ChargeBar();
	if ( RechargeBar.Scale > 0 )
	{
		DrawWidgetAsTile( C, RechargeBar );
		ShowReloadingPulse(RechargeBar.Scale);
	}
}

simulated function DrawVehicleChargeBar(Canvas C)
{
	local float ScaleFactor;

	ScaleFactor = HUDScale * 0.135 * C.ClipX;
	if (bCorrectAspectRatio)
		ScaleFactor *= ResScaleY / ResScaleX;
	C.Style = ERenderStyle.STY_Alpha;
	if ( (PawnOwner.PlayerReplicationInfo == None) || (PawnOwner.PlayerReplicationInfo.Team == None)
		|| (PawnOwner.PlayerReplicationInfo.Team.TeamIndex == 1) )
		C.DrawColor = HudColorBlue;
	else
		C.DrawColor = HudColorRed;

	C.SetPos(C.ClipX - ScaleFactor - 0.0011*HUDScale*C.ClipX, (1 - 0.0975*HUDScale)*C.ClipY);
	C.DrawTile( HUDTex, ScaleFactor, 0.223*ScaleFactor, 0, 110, 166, 53 );
	DrawWidgetAsTile(C, RechargeBar);
	RechargeBar.Scale = Vehicle(PawnOwner).ChargeBar();
	ShowReloadingPulse(RechargeBar.Scale);
}

//===========================================================================
// DrawWeaponBar
//
// Handles ten weapons. Dispensed with the original Epic implementation in favour of using
// Offset code.
//
// - Azarael
//===========================================================================
simulated function DrawWeaponBar( Canvas C )
{
	local int i, Count, Pos;
	local float IconOffset;
	
	local Weapon Weapons[WEAPON_BAR_SIZE];
	local byte ExtraWeapon[WEAPON_BAR_SIZE];
	local Inventory Inv;
	local Weapon W, PendingWeapon;

	if (ResScaleX / ResScaleY >= 1.1)
	{
		if (bSmallBar)
		{
			for (i=0; i < WEAPON_BAR_SIZE; i++)
			{
				BarBorder[i].TextureScale = 0.53;
				BarWeaponIcon[i].TextureScale = 0.53;
				BarBorderAmmoIndicator[i].TextureScale = 0.53;
			}
			bSmallBar = False;
		}
	}
	else if (!bSmallBar)
	{
		for (i=0; i < WEAPON_BAR_SIZE; i++)
		{
			BarBorder[i].TextureScale = 0.48;
			BarWeaponIcon[i].TextureScale = 0.48;
			BarBorderAmmoIndicator[i].TextureScale = 0.48;
		}
		bSmallBar = True;
	}
	//no weaponbar for vehicles
	if (Vehicle(PawnOwner) != None)
		return;

	if (PawnOwner.PendingWeapon != None)
		PendingWeapon = PawnOwner.PendingWeapon;
	else
		PendingWeapon = PawnOwner.Weapon;

	// fill:
	for( Inv=PawnOwner.Inventory; Inv!=None; Inv=Inv.Inventory )
	{
		W = Weapon( Inv );
		Count++;
		if ( Count > 100 )
			break;

		if( (W == None) || (W.IconMaterial == None) )
			continue;

		if ( W.InventoryGroup == 0 )
			Pos = 9;
		else if ( W.InventoryGroup < 10 )
			Pos = W.InventoryGroup-1;
		else
			continue;

		if ( Weapons[Pos] != None )
			ExtraWeapon[Pos] = 1;
		else
			Weapons[Pos] = W;
	}

	if ( PendingWeapon != None )
	{
		if ( PendingWeapon.InventoryGroup < 10 )
			if (PendingWeapon.InventoryGroup == 0)
				Weapons[9] = PendingWeapon;
			else Weapons[PendingWeapon.InventoryGroup-1] = PendingWeapon;
	}

	// Draw:
	for( i=0; i<WEAPON_BAR_SIZE; i++ )
	{
		W = Weapons[i];

		BarBorder[i].Tints[0] = HudColorRed;
		BarBorder[i].Tints[1] = HudColorBlue;
		BarBorder[i].OffsetY = 0;
		BarWeaponIcon[i].OffsetY = Default.BarWeaponIcon[i].OffsetY;
		
		if( W == none )
		{
			BarWeaponStates[i].HasWeapon = false;
			if ( bShowMissingWeaponInfo )
			{
				//BarWeaponIcon[i].OffsetX =  IconOffset;
				
				if ( BarWeaponIcon[i].Tints[TeamIndex] != HudColorBlack )
				{
					BarWeaponIcon[i].WidgetTexture = Default.BarWeaponIcon[i].WidgetTexture;
					BarWeaponIcon[i].TextureCoords = default.BarWeaponIcon[i].TextureCoords;
					if (bSmallBar)
						BarWeaponIcon[i].TextureScale = 0.48;
					else BarWeaponIcon[i].TextureScale = 0.53;
					BarWeaponIcon[i].Tints[TeamIndex] = HudColorBlack;
					BarWeaponIconAnim[i] = 0;
				}
				DrawWidgetAsTile( C, BarBorder[i] );
				DrawWidgetAsTile( C, BarWeaponIcon[i] ); // FIXME- have combined version
			}
		}
		else
		{
			if( !BarWeaponStates[i].HasWeapon )
			{
				// just picked this weapon up!
				BarWeaponStates[i].PickupTimer = Level.TimeSeconds;
				BarWeaponStates[i].HasWeapon = true;
			}

			BarBorderAmmoIndicator[i].OffsetY = 0;
			
			BarWeaponIcon[i].WidgetTexture = W.IconMaterial;
			BarWeaponIcon[i].TextureCoords = W.IconCoords;
			
			//Cheese
			if (Abs(W.IconCoords.Y1 - W.IconCoords.Y2) > 64)
			{
				BarWeaponIcon[i].TextureScale = default.BarWeaponIcon[i].TextureScale / ((Abs(W.IconCoords.Y1 - W.IconCoords.Y2) + 1)/ 32);
				IconOffset *= (default.BarWeaponIcon[i].TextureScale / BarWeaponIcon[i].TextureScale);
				BarWeaponIcon[i].OffsetY = -30 * (default.BarWeaponIcon[i].TextureScale / BarWeaponIcon[i].TextureScale);
			}
			else
			{
				if (bSmallBar)
					BarWeaponIcon[i].TextureScale = 0.48;
				else BarWeaponIcon[i].TextureScale = 0.53;
				BarWeaponIcon[i].OffsetY = default.BarWeaponIcon[i].OffsetY;
			}
			
			BarBorderAmmoIndicator[i].Scale = FMin(W.AmmoStatus(), 1);
			BarWeaponIcon[i].Tints[TeamIndex] = HudColorNormal;
			
			if( BarWeaponIconAnim[i] == 0 )
			{
                if ( BarWeaponStates[i].PickupTimer > Level.TimeSeconds - 0.6 )
	            {
		           if ( BarWeaponStates[i].PickupTimer > Level.TimeSeconds - 0.3 )
						BarWeaponIcon[i].TextureScale = BarWeaponIcon[i].TextureScale * (1 + 1.3 * (Level.TimeSeconds - BarWeaponStates[i].PickupTimer));	
                   else
					    BarWeaponIcon[i].TextureScale = BarWeaponIcon[i].TextureScale * (1 + 1.3 * (BarWeaponStates[i].PickupTimer + 0.6 - Level.TimeSeconds));	
					if (bSmallBar)
						BarWeaponIcon[i].OffsetX = default.BarWeaponIcon[i].OffsetX * (0.48 / BarWeaponIcon[i].TextureScale);
					else BarWeaponIcon[i].OffsetX = default.BarWeaponIcon[i].OffsetX * (0.53 / BarWeaponIcon[i].TextureScale);
                }
                else
				{
					BarWeaponIcon[i].TextureScale = default.BarWeaponIcon[i].TextureScale;
					BarWeaponIcon[i].OffsetX = default.BarWeaponIcon[i].OffsetX;
                    BarWeaponIconAnim[i] = 1;
				}
			}

			if (W == PendingWeapon)
			{
				// Change color to highlight and possibly changeTexture or animate it
				BarBorder[i].Tints[TeamIndex] = HudColorHighLight;
				BarBorder[i].OffsetY = -10;
				BarBorderAmmoIndicator[i].OffsetY = -10;
				BarWeaponIcon[i].OffsetY += -10;
			}
			if ( ExtraWeapon[i] == 1 )
			{
				if ( W == PendingWeapon )
				{
					BarBorder[i].Tints[0] = HudColorRed;
					BarBorder[i].Tints[1] = HudColorBlue;
					BarBorder[i].OffsetY = 0;
					BarBorder[i].TextureCoords.Y1 = 80;
					DrawWidgetAsTile( C, BarBorder[i] );
					BarBorder[i].TextureCoords.Y1 = 39;
					BarBorder[i].OffsetY = -10;
					BarBorder[i].Tints[TeamIndex] = HudColorHighLight;
				}
				else
				{
					BarBorder[i].OffsetY = -52;
					BarBorder[i].TextureCoords.Y2 = 48;
					DrawWidgetAsTile( C, BarBorder[i] );
					BarBorder[i].TextureCoords.Y2 = 93;
					BarBorder[i].OffsetY = 0;
				}
			}
			DrawWidgetAsTile( C, BarBorder[i] );
			DrawWidgetAsTile( C, BarBorderAmmoIndicator[i] );
			DrawWidgetAsTile( C, BarWeaponIcon[i] );
		}
	}
}

function bool DrawLevelAction (Canvas C)
{
	local String LevelActionText;
	local Plane OldModulate;

	if ((Level.LevelAction == LEVACT_None) && (Level.Pauser != none))
	{
		LevelActionText = LevelActionPaused;
	}
	else if ((Level.LevelAction == LEVACT_Loading) || (Level.LevelAction == LEVACT_Precaching))
		LevelActionText = LevelActionLoading;
	else
		LevelActionText = "";

	if (LevelActionText == "")
		return (false);

	C.Font = LoadLevelActionFont();
	C.DrawColor = LevelActionFontColor;
	C.Style = ERenderStyle.STY_Alpha;
	OldModulate = C.ColorModulate;
	C.ColorModulate = C.default.ColorModulate;
	C.DrawScreenText (LevelActionText, LevelActionPositionX, LevelActionPositionY, DP_MiddleMiddle);
	C.ColorModulate = OldModulate;

	return (true);
}

function DisplayPortrait(PlayerReplicationInfo PRI)
{
	local Material NewPortrait;

	if ( LastPlayerIDTalking > 0 )
		return;

	NewPortrait = PRI.GetPortrait();
	if ( NewPortrait == None )
		return;
	if ( Portrait == None )
		PortraitX = 1;
	Portrait = NewPortrait;
	PortraitTime = Level.TimeSeconds + 3;
	PortraitPRI = PRI;
}

simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
	Super.Message(PRI,Msg,MsgType);
	if ( PRI != None && (MsgType == 'Say') || (MsgType == 'TeamSay') && bShowPortraitOnTalk)
		DisplayPortrait(PRI);
}

simulated function font LoadLevelActionFont()
{
	if( LevelActionFontFont == None )
	{
		LevelActionFontFont = Font(DynamicLoadObject(LevelActionFontName, Class'Font'));
		if( LevelActionFontFont == None )
			Log("Warning: "$Self$" Couldn't dynamically load font "$LevelActionFontName);
	}
	return LevelActionFontFont;
}


//===========================================================================
// Something keeps replacing these fonts.
//===========================================================================
static function Font LoadFontStatic(int i)
{
	//Reload if it's been somehow overridden.
	if( default.FontArrayFonts[i] == None || string(default.FontArrayFonts[i].class) != default.FontArrayNames[i])
	{
		default.FontArrayFonts[i] = Font(DynamicLoadObject(default.FontArrayNames[i], class'Font'));
		if( default.FontArrayFonts[i] == None )
			Log("Warning: "$default.Class$" Couldn't dynamically load font "$default.FontArrayNames[i]);
	}

	return default.FontArrayFonts[i];
}

simulated function Font LoadFont(int i)
{
	if( FontArrayFonts[i] == None  || string(FontArrayFonts[i].class) != FontArrayNames[i])
	{
		FontArrayFonts[i] = Font(DynamicLoadObject(FontArrayNames[i], class'Font'));
		if( FontArrayFonts[i] == None )
			Log("Warning: "$Self$" Couldn't dynamically load font "$FontArrayNames[i]);
	}
	return FontArrayFonts[i];
}

defaultproperties
{
     DigitsBig=(DigitTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureCoords[0]=(X2=38,Y2=38),TextureCoords[1]=(X1=39,X2=77,Y2=38),TextureCoords[2]=(X1=78,X2=116,Y2=38),TextureCoords[3]=(X1=117,X2=155,Y2=38),TextureCoords[4]=(X1=156,X2=194,Y2=38),TextureCoords[5]=(X1=195,X2=233,Y2=38),TextureCoords[6]=(X1=234,X2=272,Y2=38),TextureCoords[7]=(X1=273,X2=311,Y2=38),TextureCoords[8]=(X1=312,X2=350,Y2=38),TextureCoords[9]=(X1=351,X2=389,Y2=38),TextureCoords[10]=(X1=390,X2=428,Y2=38))
     DigitsBigPulse=(DigitTexture=FinalBlend'UTRHUDTextures.Generic.fbHUDAlertSlow',TextureCoords[0]=(X2=38,Y2=38),TextureCoords[1]=(X1=39,X2=77,Y2=38),TextureCoords[2]=(X1=78,X2=116,Y2=38),TextureCoords[3]=(X1=117,X2=155,Y2=38),TextureCoords[4]=(X1=156,X2=194,Y2=38),TextureCoords[5]=(X1=195,X2=233,Y2=38),TextureCoords[6]=(X1=234,X2=272,Y2=38),TextureCoords[7]=(X1=273,X2=311,Y2=38),TextureCoords[8]=(X1=312,X2=350,Y2=38),TextureCoords[9]=(X1=351,X2=389,Y2=38),TextureCoords[10]=(X1=390,X2=428,Y2=38))
     AmmoIcon=(RenderStyle=STY_Alpha,TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=1.000000,PosY=1.000000,OffsetX=-28,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
    
    // scaling block - upper right

     AdrenalineCount=(RenderStyle=STY_Alpha,TextureScale=0.550000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-196,OffsetY=134,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     AdrenalineIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=113,Y1=38,X2=165,Y2=106),TextureScale=0.360000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-220,OffsetY=202,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     AdrenalineBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-96,OffsetY=102,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     AdrenalineAlert=(WidgetTexture=FinalBlend'HUDContent.Generic.fb_Pulse001',RenderStyle=STY_Alpha,TextureCoords=(X2=64,Y2=64),TextureScale=0.690000,DrawPivot=DP_MiddleLeft,PosX=1.000000,OffsetX=-160,OffsetY=122,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))

     MyScore=(RenderStyle=STY_Alpha,TextureScale=0.490000,DrawPivot=DP_MiddleRight,PosY=1.000000,OffsetX=174,OffsetY=-29,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     MyScoreIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=248,X2=68,Y2=310),TextureScale=0.500000,DrawPivot=DP_LowerLeft,PosX=0.002200,PosY=0.999900,ScaleMode=SM_Left,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     MyScoreBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))

     DigitsShield=(RenderStyle=STY_Alpha,TextureScale=0.550000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-198,OffsetY=13,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     DigitsHealth=(RenderStyle=STY_Alpha,TextureScale=0.550000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-198,OffsetY=75,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     DigitsVehicleHealth=(RenderStyle=STY_Alpha,TextureScale=0.610000,DrawPivot=DP_MiddleRight,PosX=0.139000,PosY=1.000000,OffsetX=174,OffsetY=-29,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     
     HudHealthALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse',RenderStyle=STY_Alpha,TextureCoords=(X1=125,Y1=458,X2=291,Y2=511),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-96,OffsetY=52,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HudVehicleHealthALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse',RenderStyle=STY_Alpha,TextureCoords=(X1=125,Y1=458,X2=291,Y2=511),TextureScale=0.660000,DrawPivot=DP_UpperRight,ScaleMode=SM_Right,Tints[0]=(B=255,G=255,R=255),Tints[1]=(B=255,G=255,R=255))

     HudBorderShieldIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=123,Y1=163,X2=163,Y2=224),TextureScale=0.460000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-175,OffsetY=6,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     HudBorderHealthIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=74,Y1=165,X2=123,Y2=216),TextureScale=0.560000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-132,OffsetY=64,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     HudBorderVehicleHealthIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=227,Y1=406,X2=280,Y2=448),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.139000,OffsetY=15,ScaleMode=SM_Right,Tints[0]=(B=255,G=255,R=255),Tints[1]=(B=255,G=255,R=255))
     
     HudBorderShield=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-96,OffsetY=1,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HudBorderHealth=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetX=-96,OffsetY=52,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HudBorderVehicleHealth=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.660000,DrawPivot=DP_UpperRight,PosX=1.000000,OffsetY=15,ScaleMode=SM_Right,Tints[0]=(B=255,G=255,R=255),Tints[1]=(B=255,G=255,R=255))
     
    // end upper right scaling block

     TimerHours=(RenderStyle=STY_Alpha,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,OffsetX=90,OffsetY=200,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TimerMinutes=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,OffsetX=170,OffsetY=200,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255),bPadWithZeroes=1)
     TimerSeconds=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,OffsetX=250,OffsetY=200,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255),bPadWithZeroes=1)
     TimerDigitSpacer(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=495,Y1=91,X2=503,Y2=112),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,OffsetX=194,OffsetY=160,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TimerDigitSpacer(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=495,Y1=91,X2=503,Y2=112),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,OffsetX=130,OffsetY=160,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TimerIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=150,Y1=356,X2=184,Y2=395),TextureScale=0.550000,OffsetX=10,OffsetY=95,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TimerBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,OffsetX=5,OffsetY=160,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     Timer2Hours=(RenderStyle=STY_Alpha,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=90,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     Timer2Minutes=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=170,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255),bPadWithZeroes=1)
     Timer2Seconds=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.320000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=250,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255),bPadWithZeroes=1)
     Timer2DigitSpacer(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=495,Y1=91,X2=503,Y2=112),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=194,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     Timer2DigitSpacer(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=495,Y1=91,X2=503,Y2=112),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=130,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     Timer2Icon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=150,Y1=356,X2=184,Y2=395),TextureScale=0.550000,DrawPivot=DP_MiddleLeft,PosY=0.020000,OffsetX=2,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     Timer2Background=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.400000,DrawPivot=DP_MiddleLeft,PosY=0.022000,OffsetX=40,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     LevelActionFontColor=(B=255,G=255,R=255,A=255)
     LevelActionPositionX=0.500000
     LevelActionPositionY=0.300000

     DigitsAmmo=(RenderStyle=STY_Alpha,TextureScale=0.490000,DrawPivot=DP_MiddleLeft,PosX=1.000000,PosY=1.000000,OffsetX=-174,OffsetY=-29,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))

     UDamageTime=(RenderStyle=STY_Alpha,TextureScale=0.490000,DrawPivot=DP_MiddleMiddle,PosX=0.950000,PosY=0.750000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UDamageIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=164,X2=73,Y2=246),TextureScale=0.750000,DrawPivot=DP_MiddleMiddle,PosX=0.950000,PosY=0.750000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     
     ShieldManIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=360,Y1=4,X2=470,Y2=193),TextureScale=0.50000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     ShieldBeltIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=240,Y1=4,X2=350,Y2=193),TextureScale=0.50000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldBodyArmorIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=4,Y1=4,X2=114,Y2=193),TextureScale=0.50000,DrawPivot=DP_UpperRight,PosX=0.995000,PosY=0.005500,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldThighPadsIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=123,Y1=4,X2=233,Y2=193),TextureScale=0.50000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldBootsIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBoots',RenderStyle=STY_Alpha,TextureCoords=(X1=4,Y1=4,X2=114,Y2=193),TextureScale=0.50000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     
     ChatBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.ChatBG',RenderStyle=STY_Alpha,TextureCoords=(X1=2,Y1=2,X2=512,Y2=128),TextureScale=0.500000,ScaleMode=SM_Right,Scale=1.100000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HudAmmoALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse',RenderStyle=STY_Alpha,TextureCoords=(X1=125,Y1=458,X2=291,Y2=511),TextureScale=0.530000,DrawPivot=DP_LowerRight,PosX=1.000000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HudBorderAmmo=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.530000,DrawPivot=DP_LowerRight,PosX=1.000000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=39,X2=241,Y2=77),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-435,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=245,Y1=39,X2=329,Y2=79),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-338,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=179,Y1=127,X2=241,Y2=175),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-241,OffsetY=-25,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=250,Y1=110,X2=330,Y2=145),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-145,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=78,X2=244,Y2=124),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-48,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=246,Y1=182,X2=331,Y2=210),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=48,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=246,Y1=80,X2=332,Y2=106),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=145,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=172,X2=245,Y2=208),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=241,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=253,Y1=146,X2=333,Y2=181),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=338,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarWeaponIcon(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=430,Y1=182,X2=512,Y2=210),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=435,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     BarBorder(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-480,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorder(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-480,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderAmmoIndicator(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     BarBorderScaledPosition(0)=0.320000
     BarBorderScaledPosition(1)=0.360000
     BarBorderScaledPosition(2)=0.400000
     BarBorderScaledPosition(3)=0.440000
     BarBorderScaledPosition(4)=0.480000
     BarBorderScaledPosition(5)=0.521000
     BarBorderScaledPosition(6)=0.561000
     BarBorderScaledPosition(7)=0.601000
     BarBorderScaledPosition(8)=0.641000
     RechargeBar=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=313,X2=170,Y2=348),TextureScale=0.500000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=1.000000,OffsetY=-93,ScaleMode=SM_Left,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=220),Tints[1]=(B=255,G=255,R=255,A=220))
     bDrawTimer=True
     bShowMissingWeaponInfo=True
     bShowPortraitOnTalk=True
     FadeTime=0.300000
     CountDownName(0)="one"
     CountDownName(1)="two"
     CountDownName(2)="three"
     CountDownName(3)="four"
     CountDownName(4)="five"
     CountDownName(5)="six"
     CountDownName(6)="seven"
     CountDownName(7)="eight"
     CountDownName(8)="nine"
     CountDownName(9)="ten"
     LongCountName(0)="5_minute_warning"
     LongCountName(1)="3_minutes_remain"
     LongCountName(2)="2_minutes_remain"
     LongCountName(3)="1_minute_remains"
     LongCountName(4)="30_seconds_remain"
     LongCountName(5)="20_seconds"
     BarWeaponIconAnim(0)=1
     HudColorRed=(R=200,A=255)
     HudColorBlue=(B=200,G=64,R=50,A=255)
     HudColorBlack=(A=255)
     HudColorHighLight=(G=160,R=255,A=255)
     HudColorNormal=(B=255,G=255,R=255,A=255)
     HudColorTeam(0)=(R=200,A=255)
     HudColorTeam(1)=(B=200,G=64,R=50,A=255)
     HUDTex=Texture'UTRHUDTextures.HUDContent.HudBase'
     HUDPulseTex=FinalBlend'UTRHUDTextures.Generic.HUDPulse'
     bShowChatBackground=True
     HardFontLink=Font'UTRFonts.Dungeon18'
     XShifts(1)=0.500000
     XShifts(2)=1.000000
     XShifts(3)=1.000000
     XShifts(4)=1.000000
     XShifts(5)=0.500000
     XShifts(8)=0.500000
     YShifts(3)=0.500000
     YShifts(4)=1.000000
     YShifts(5)=1.000000
     YShifts(6)=1.000000
     YShifts(7)=0.500000
     YShifts(8)=0.500000
     bCorrectAspectRatio=True
     LevelActionLoading=".:. L O A D I N G .:."
     LevelActionPaused=".:. PAUSED .:."
     LevelActionFontName="UTRFonts.Nimbus29"
     InitialViewingString="Press [Fire] to View a different Player"
     ProgressFontName="UTRFonts.Dungeon18"
     OverrideConsoleFontName="UTRFonts.Nimbus12"
     ConsoleMessagePosX=0.007000
     ConsoleMessagePosY=0.110000
     FontArrayNames(0)="UTRFonts.Nimbus37"
     FontArrayNames(1)="UTRFonts.Nimbus29"
     FontArrayNames(2)="UTRFonts.Nimbus24"
     FontArrayNames(3)="UTRFonts.Nimbus22"
     FontArrayNames(4)="UTRFonts.Nimbus17"
     FontArrayNames(5)="UTRFonts.Nimbus12"
     FontArrayNames(6)="UTRFonts.Nimbus10"
}
