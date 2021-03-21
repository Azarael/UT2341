//==============================================================================
// UTR Team DeathMatch HUD
// Based off OLTeamGames.HudOLTeamDeathmatch
//
// Writen by Brian 'Snake.PLiSKiN' Alexander for UTR
// Copyright (c) 2006, Brian Alexander for UTR.  All Rights Reserved.
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
// http://wiki.beyondunreal.com/wiki/OpenUnrealModLicense
//==============================================================================
class HudCTeamGamePlus extends HudCDeathMatchPlus;

var() NumericWidget ScoreTeam[2];
var() NumericWidget totalLinks;
var() SpriteWidget  VersusSymbol;
var() SpriteWidget  TeamScoreBackGround[2];
var() SpriteWidget  TeamScoreBackGroundDisc[2];
var() SpriteWidget  LinkIcon;
var() SpriteWidget  TeamSymbols[2];
var() int Links;
// Team Colors
var() Color CarrierTextColor1;
var() Color CarrierTextColor2;
var() Color CarrierTextColor3;
var() String CarriersName, CarriersLocation;
var() float CNPosX, CNPosY;
var localized string LinkEstablishedMessage;

var() NumericWidget OLScoreTeam[4];
var() SpriteWidget  OLTeamScoreBackGround[4];
var() SpriteWidget  OLTeamScoreBackGroundDisc[4];
var() SpriteWidget  OLTeamSymbols[4];
var() color OLHudColorTeam[4];
var() color TeamBeaconTeamColors[4];
var() color TeamBeaconLinkColor;
var() float DistributionCornerX[4], DistributionCornerY[4];
var() float DistributionSpacingX, DistributionSpacingY;
var() float DistributionIndicatorWidth;
var() float NewMessagePosY;
var Material DistributionIndicator;
var Material DistributionIndicatorAlert;
var color EliminatedColor;
var int OLTeamIndex;

var globalconfig bool bShowTeamBeacons;

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(texture'UTRHUDTextures.HUDContent.HudBase');
	Level.AddPrecacheMaterial(Texture'UTRHUDTextures.HUDContent.HUDShields');
	Super.UpdatePrecacheMaterials();
}

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0, True);
}

simulated function DrawSpectatingHud (Canvas C)
{
	Super.DrawSpectatingHud(C);

	if ( (PlayerOwner == None) || (PlayerOwner.PlayerReplicationInfo == None)
		|| !PlayerOwner.PlayerReplicationInfo.bOnlySpectator )
		return;

	UpdateRankAndSpread(C);
	ShowTeamScorePassA(C);
	ShowTeamScorePassC(C);
	UpdateTeamHUD();
}

simulated function Tick(float deltaTime)
{
	Super.Tick(deltaTime);

	if (Links >0)
		TeamLinked = True;
	else
		TeamLinked = False;
}

simulated function ShowLinks()
{
	if ( PawnOwner.Weapon != None && PawnOwner.Weapon.IsA('LinkGun') )
		Links = LinkGun(PawnOwner.Weapon).Links;
	else
		Links = 0;
}

simulated function drawLinkText(Canvas C)
{
	text = LinkEstablishedMessage;

	C.Font = LoadLevelActionFont();
	C.DrawColor = LevelActionFontColor;

	C.DrawColor = LevelActionFontColor;
	C.Style = ERenderStyle.STY_Alpha;

	C.DrawScreenText (text, 1, 0.81, DP_LowerRight);
}

simulated function UpdateRankAndSpread(Canvas C)
{
	// making sure that the Rank and Spread dont get drawn in other gametypes
}

simulated function DrawTeamOverlay( Canvas C )
{
	// TODO: draw top 5 playersnames and Position on map
}

simulated function DrawMyScore ( Canvas C )
{
	// Dont show MyScore in team games
}

simulated function DrawMessage( Canvas C, int i, float PosX, float PosY, out float DX, out float DY )
{
	if(LocalMessages[i].Message.default.PosY == 0.1)
		PosY = PosY + (NewMessagePosY - 0.1);

	super.DrawMessage(C,i,PosX,PosY,DX,DY);
}

/*
simulated function Message( PlayerReplicationInfo PRI, coerce string Msg, name MsgType )
{
	local Class<LocalMessage> LocalMessageClass;

	switch( MsgType )
	{
	case 'Say':
		if ( PRI == None )
			return;
		Msg = PRI.PlayerName$": "$Msg;
		LocalMessageClass = Class'UTRSayMessagePlus';
		break;
	case 'TeamSay':
		if ( PRI == None )
			return;
		Msg = PRI.PlayerName$"("$PRI.GetLocationName()$"): "$Msg;
		LocalMessageClass = class'UTRTeamSayMessagePlus';
		break;
	case 'CriticalEvent':
		LocalMessageClass = class'CriticalEventPlus';
		LocalizedMessage( LocalMessageClass, 0, None, None, None, Msg );
		return;
	case 'DeathMessage':
		LocalMessageClass = class'xDeathMessage';
		break;
	default:
		LocalMessageClass = class'StringMessagePlus';
		break;
	}

	AddTextMessage(Msg,LocalMessageClass,PRI);
}*/

simulated function UpdateHud()
{
	UpdateTeamHUD();
	showLinks();
	Super.UpdateHud();

	if ((PawnOwnerPRI != none) && (PawnOwnerPRI.Team != None))
	{
		TeamIndex = 0; // Make it always choose Tints[0]
		OLTeamIndex = PawnOwnerPRI.Team.TeamIndex;
	}
}

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
						HudAmmoALERT.Tints[0] = OLHudColorTeam[OLTeamIndex];
						HudAmmoALERT.Tints[1] = OLHudColorTeam[OLTeamIndex];
						AmmoIcon.WidgetTexture = Material'HudContent.Generic.HUDPulse';
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

			DrawHUDAnimWidget( HudBorderHealthIcon, default.HudBorderHealthIcon.TextureScale, LastHealthPickupTime, 0.5, 0.15);
			DrawWidgetAsTile( C, HudBorderHealth );

			if(CurHealth/PawnOwner.HealthMax < 0.26)
			{
				HudHealthALERT.Tints[0] = OLHudColorTeam[OLTeamIndex];
				HudHealthALERT.Tints[1] = OLHudColorTeam[OLTeamIndex];
				DrawWidgetAsTile( C, HudHealthALERT);
				HudBorderHealthIcon.WidgetTexture = Material'HudContent.Generic.HUDPulse';
			}
			else
				HudBorderHealthIcon.WidgetTexture = default.HudBorderHealth.WidgetTexture;

			DrawWidgetAsTile( C, HudBorderHealthIcon);

			if( CurHealth < LastHealth )
				LastDamagedHealth = Level.TimeSeconds;

			DrawHUDAnimDigit( DigitsHealth, default.DigitsHealth.TextureScale, LastDamagedHealth, 0.8, default.DigitsHealth.Tints[0], HudColorHighLight);
			DrawNumericWidgetAsTiles( C, DigitsHealth, DigitsBig);

			if(CurHealth > 999)
			{
				DigitsHealth.OffsetX=220;
				DigitsHealth.OffsetY=-35;
				DigitsHealth.TextureScale=0.39;
			}
			else
			{
				DigitsHealth.OffsetX = default.DigitsHealth.OffsetX;
				DigitsHealth.OffsetY = default.DigitsHealth.OffsetY;
				DigitsHealth.TextureScale = default.DigitsHealth.TextureScale;
			}

			if (RealPawnOwner != None)
			{
				PawnOwner = RealPawnOwner;

				DrawWidgetAsTile( C, HudBorderVehicleHealth );

				if (CurVehicleHealth/PawnOwner.HealthMax < 0.26)
				{
					HudVehicleHealthALERT.Tints[0] = OLHudColorTeam[OLTeamIndex];
					HudVehicleHealthALERT.Tints[1] = OLHudColorTeam[OLTeamIndex];
					DrawWidgetAsTile(C, HudVehicleHealthALERT);
					HudBorderVehicleHealthIcon.WidgetTexture = Material'HudContent.Generic.HUDPulse';
				}
				else
					HudBorderVehicleHealthIcon.WidgetTexture = default.HudBorderVehicleHealth.WidgetTexture;

				DrawWidgetAsTile(C, HudBorderVehicleHealthIcon);

				if (CurVehicleHealth < LastVehicleHealth )
					LastDamagedVehicleHealth = Level.TimeSeconds;

				DrawHUDAnimDigit(DigitsVehicleHealth, default.DigitsVehicleHealth.TextureScale, LastDamagedVehicleHealth, 0.8, default.DigitsVehicleHealth.Tints[0], HudColorHighLight);
				DrawNumericWidgetAsTiles(C, DigitsVehicleHealth, DigitsBig);

				if (CurVehicleHealth > 999)
				{
					DigitsVehicleHealth.OffsetX = 220;
					DigitsVehicleHealth.OffsetY = -35;
					DigitsVehicleHealth.TextureScale = 0.39;
				}
				else
				{
					DigitsVehicleHealth.OffsetX = default.DigitsVehicleHealth.OffsetX;
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

	if( bShowPersonalInfo )
	{
		DrawShieldMan(C);
		if ( bShowChatBackground )
			DrawWidgetAsTile( C, ChatBackground);
	}

	// Temp Drawwwith Hud Colors
	HudBorderHealth.Tints[0] = OLHudColorTeam[OLTeamIndex];
	HudBorderHealth.Tints[1] = OLHudColorTeam[OLTeamIndex];
	HudBorderVehicleHealth.Tints[0] = OLHudColorTeam[OLTeamIndex];
	HudBorderVehicleHealth.Tints[1] = OLHudColorTeam[OLTeamIndex];
	HudBorderAmmo.Tints[0] = OLHudColorTeam[OLTeamIndex];
	HudBorderAmmo.Tints[1] = OLHudColorTeam[OLTeamIndex];
	if ( bShowChatBackground )
	{
		ChatBackground.Tints[0] = OLHudColorTeam[OLTeamIndex];
		ChatBackground.Tints[1] = OLHudColorTeam[OLTeamIndex];
	}

	if( Level.TimeSeconds - LastVoiceGainTime < 0.333 )
		DisplayVoiceGain(C);

	DisplayLocalMessages (C);

	if( bShowTeamBeacons )
		DrawOLTeamBeacons(C);

	UpdateRankAndSpread(C);
	ShowTeamScorePassA(C);

	if ( Links >0 )
	{
		DrawWidgetAsTile (C, LinkIcon);
		DrawNumericWidgetAsTiles (C, totalLinks, DigitsBigPulse);
	}
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
		if(PortraitPRI != none)
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
				C.DrawColor = OLHudColorTeam[PortraitPRI.Team.TeamIndex];
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

	DrawCrosshair(C);
	ShowTeamScorePassC(C);
}

simulated function DrawAdrenaline( Canvas C )
{
	if ( !PlayerOwner.bAdrenalineEnabled )
		return;

	DrawWidgetAsTile( C, AdrenalineBackground );

	if( CurEnergy == MaxEnergy )
	{
		DrawWidgetAsTile( C, AdrenalineAlert );
		AdrenalineAlert.Tints[0] = HudColorHighLight;
		AdrenalineAlert.Tints[1] = HudColorHighLight;
	}

	DrawWidgetAsTile( C, AdrenalineIcon );
	DrawNumericWidgetAsTiles( C, AdrenalineCount, DigitsBig);

	if(CurEnergy > LastEnergy)
		LastAdrenalineTime = Level.TimeSeconds;

	LastEnergy = CurEnergy;
	DrawHUDAnimWidget( AdrenalineIcon, default.AdrenalineIcon.TextureScale, LastAdrenalineTime, 0.5, 0.15);
	AdrenalineBackground.Tints[0] = OLHudColorTeam[OLTeamIndex];
	AdrenalineBackground.Tints[1] = OLHudColorTeam[OLTeamIndex];
}

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

	TimerBackground.Tints[0] = HudColorBlack;
	TimerBackground.Tints[0].A = 150;
	TimerBackground.Tints[1] = HudColorBlack;
	TimerBackground.Tints[1].A = 150;

	DrawWidgetAsTile( C, TimerBackground);
	DrawWidgetAsTile( C, TimerIcon);

	TimerMinutes.OffsetX = default.TimerMinutes.OffsetX - 80;
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

	Timer2Background.Tints[0] = HudColorBlack;
	Timer2Background.Tints[0].A = 150;
	Timer2Background.Tints[1] = HudColorBlack;
	Timer2Background.Tints[1].A = 150;

	DrawWidgetAsTile( C, Timer2Background);
	DrawWidgetAsTile( C, Timer2Icon);

	Timer2Minutes.OffsetX = default.Timer2Minutes.OffsetX - 80;
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

// <Render Shields> ============================================================
// <summary>
// Match the ShieldManIcon and HudBorderShield colors to the pawns team color
// </summary>
// <remarks>
// Writen by Brian 'Snake.PLiSKiN' Alexander
//  (c) 2006, UTR.  All Rights Reserved
// </remarks>
// <param name="C">Canvas</param>
simulated function DrawShieldMan( Canvas C )
{
	super.DrawShieldMan(C);

	ShieldManIcon.Tints[0] = OLHudColorTeam[OLTeamIndex];
	ShieldManIcon.Tints[1] = OLHudColorTeam[OLTeamIndex];

	HudBorderShield.Tints[0] = OLHudColorTeam[OLTeamIndex];
	HudBorderShield.Tints[1] = OLHudColorTeam[OLTeamIndex];
}
// </Render Shields> ============================================================

simulated function ShowTeamScorePassA(Canvas C)
{
	if ( bShowPoints )
	{
		DrawWidgetAsTile (C, OLTeamScoreBackground[0]);
		DrawWidgetAsTile (C, OLTeamScoreBackground[1]);
		DrawWidgetAsTile (C, OLTeamScoreBackgroundDisc[0]);
		DrawWidgetAsTile (C, OLTeamScoreBackgroundDisc[1]);

		OLTeamScoreBackground[0].Tints[TeamIndex] = HudColorBlack;
		OLTeamScoreBackground[0].Tints[TeamIndex].A = 150;
		OLTeamScoreBackground[1].Tints[TeamIndex] = HudColorBlack;
		OLTeamScoreBackground[1].Tints[TeamIndex].A = 150;

		if (OLTeamSymbols[0].WidgetTexture != None)
			DrawWidgetAsTile (C, OLTeamSymbols[0]);

		if (OLTeamSymbols[1].WidgetTexture != None)
			DrawWidgetAsTile (C, OLTeamSymbols[1]);

		//ShowVersusIcon(C);
		DrawNumericWidgetAsTiles (C, OLScoreTeam[0], DigitsBig);
		DrawNumericWidgetAsTiles (C, OLScoreTeam[1], DigitsBig);
	}
}

/*
function DrawDistributionArray(Canvas C)
{
	local int i,j,k,realj;
	local UTRGameReplicationInfo OLGRI;
	local float tmpX, tmpY, Scaling;

	OLGRI = UTRGameReplicationInfo(PlayerOwner.GameReplicationInfo);
	if (OLGRI == None)
		Return;

	for (i=0; i < OLGRI.NumTeams; i++)
	{
		j=0;
		for ( realj = 0; realj < OLGRI.NumTeams; realj++ )
		{
			if (OLGRI.UTRTeams[realj] == OLGRI.UTRTeams[i])
				continue;
			j++;

			for (k=0; k < OLGRI.DistributionArray[i].ScoresNeeded[realj]; k++)
			{
				//                if(OLGRI.DistributionArray[i].ScoresNeeded[realj] < 5)
				//                {
				if (i%2 == 1) // for the odd teams (drawn on the right side)
					tmpX= 0.5 + ((DistributionCornerX[i] + (DistributionSpacingX*k))*HudScale);
				else
					tmpX= 0.5 - ( (DistributionCornerX[i] + (DistributionSpacingX*k) + (DistributionIndicatorWidth/C.ClipX*(C.ClipX/1600)))*HudScale );

				tmpY= DistributionCornerY[i] + (DistributionSpacingY*j);
				C.Style = ERenderStyle.STY_Alpha;
				C.SetPos(TmpX * C.ClipX,
					TmpY * C.ClipY * HudScale);
				C.DrawColor = OLHudColorTeam[realj];
				Scaling = DistributionIndicatorWidth*C.ClipX*HUDScale/1600;

				if (k==OLGRI.DistributionArray[i].ScoresNeeded[realj]-1 && OLGRI.UTRFlagState[realj] == EFlagState.FLAG_HeldEnemy && OLGRI.UTRFlagHolder[realj].Team.TeamIndex == i)
					C.DrawTile(DistributionIndicatorAlert, Scaling, Scaling,497,92,6,6);
				else
					C.DrawTile(DistributionIndicator, Scaling, Scaling,497,92,6,6);
			}
		}
	}
}*/

simulated function ShowVersusIcon(Canvas C)
{
	DrawWidgetAsTile (C, VersusSymbol );
}

simulated function ShowTeamScorePassC(Canvas C);
simulated function TeamScoreOffset();

// Alternate Texture Pass ======================================================================
simulated function UpdateTeamHud()
{
	local GameReplicationInfo GRI;
	local int i;

	GRI = PlayerOwner.GameReplicationInfo;

	if (GRI == None)
		Return;
	/*
	if (UTRGameReplicationInfo(GRI) != None)
	{
		for (i = 0; i < UTRGameReplicationInfo(GRI).NumTeams; i++)
		{
			if (UTRGameReplicationInfo(GRI).UTRTeams[i] == None)
				continue;

			OLTeamSymbols[i].Tints[0] = OLHudColorTeam[i];
			OLTeamSymbols[i].Tints[1] = OLHudColorTeam[i];
			OLScoreTeam[i].Value = Min(UTRGameReplicationInfo(GRI).UTRTeams[i].Score, 999);  // max space in hud

			if (UTRGameReplicationInfo(GRI).ClassicTeamSymbols[i] != None)
				OLTeamSymbols[i].WidgetTexture = UTRGameReplicationInfo(GRI).ClassicTeamSymbols[i];
		}
	}
	else
	{*/
		for (i = 0; i < 2; i++)
		{
			if (GRI.Teams[i] == None)
				continue;

			OLTeamSymbols[i].Tints[i] = OLHudColorTeam[i];
			OLScoreTeam[i].Value =  Min(GRI.Teams[i].Score, 999);  // max space in hud

			if (GRI.TeamSymbols[i] != None)
				OLTeamSymbols[i].WidgetTexture = GRI.TeamSymbols [i];
		}
	//}
}

function bool CustomHUDColorAllowed()
{
	return false;
}

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

		BarBorder[i].Tints[0] = OLHudColorTeam[OLTeamIndex];
		BarBorder[i].Tints[1] = OLHudColorTeam[OLTeamIndex];
		BarBorder[i].OffsetY = 0;
		BarWeaponIcon[i].OffsetY = default.BarWeaponIcon[i].OffsetY;

		if( W == none )
		{
			BarWeaponStates[i].HasWeapon = false;
			if ( bShowMissingWeaponInfo )
			{
				if ( BarWeaponIcon[i].Tints[0] != HudColorBlack )
				{
					BarWeaponIcon[i].WidgetTexture = default.BarWeaponIcon[i].WidgetTexture;
					BarWeaponIcon[i].TextureCoords = default.BarWeaponIcon[i].TextureCoords;
					if (bSmallBar)
						BarWeaponIcon[i].TextureScale = 0.48;
					else BarWeaponIcon[i].TextureScale = 0.53;
					BarWeaponIcon[i].Tints[0] = HudColorBlack;
					BarWeaponIcon[i].Tints[1] = HudColorBlack;
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
			BarWeaponIcon[i].Tints[0] = HudColorNormal;
			BarWeaponIcon[i].Tints[1] = HudColorNormal;

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
                    BarWeaponIconAnim[i] = 1;
			}

			if (W == PendingWeapon)
			{
				// Change color to highlight and possibly changeTexture or animate it
				BarBorder[i].Tints[0] = HudColorHighLight;
				BarBorder[i].Tints[1] = HudColorHighLight;
				BarBorder[i].OffsetY = -10;
				BarBorderAmmoIndicator[i].OffsetY = -10;
				BarWeaponIcon[i].OffsetY += -10;
			}
			if ( ExtraWeapon[i] == 1 )
			{
				if ( W == PendingWeapon )
				{
					BarBorder[i].Tints[0] = OLHudColorTeam[OLTeamIndex];
					BarBorder[i].Tints[1] = OLHudColorTeam[OLTeamIndex];
					BarBorder[i].OffsetY = 0;
					BarBorder[i].TextureCoords.Y1 = 80;
					DrawWidgetAsTile( C, BarBorder[i] );
					BarBorder[i].TextureCoords.Y1 = 39;
					BarBorder[i].OffsetY = -10;
					BarBorder[i].Tints[0] = HudColorHighLight;
					BarBorder[i].Tints[1] = HudColorHighLight;
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

simulated function DrawChargeBar( Canvas C)
{
	local float ScaleFactor;

	ScaleFactor = HUDScale * 0.135 * C.ClipX;
	if (bCorrectAspectRatio)
		ScaleFactor *= ResScaleY / ResScaleX;
	C.Style = ERenderStyle.STY_Alpha;
	C.DrawColor = OLHudColorTeam[OLTeamIndex];
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
	C.DrawColor = OLHudColorTeam[OLTeamIndex];
	C.SetPos(C.ClipX - ScaleFactor - 0.0011*HUDScale*C.ClipX, (1 - 0.0975*HUDScale)*C.ClipY);
	C.DrawTile( HUDTex, ScaleFactor, 0.223*ScaleFactor, 0, 110, 166, 53 );

	DrawWidgetAsTile(C, RechargeBar);
	RechargeBar.Scale = Vehicle(PawnOwner).ChargeBar();
	ShowReloadingPulse(RechargeBar.Scale);
}

simulated function DrawOLTeamBeacons(Canvas C)
{
	local vector        ScreenPos;
	local vector        CamLoc;
	local rotator       CamRot;
	//    local float     ProgressPct;
	local int MyTeam;
	local Pawn P;


	if (PawnOwnerPRI.Team == none)
		return;

	ForEach DynamicActors(class'Pawn',P)
	{
		if(P.PlayerReplicationInfo == none || P.PlayerReplicationInfo.Team == none || P.PlayerReplicationInfo.bOnlySpectator || P.Health <= 0)
			continue;

		if(PawnOwner == P)
			continue;

		MyTeam = PawnOwnerPRI.Team.TeamIndex;

		if(P.PlayerReplicationInfo.Team.TeamIndex != MyTeam)
			continue;

		C.DrawColor = OLHudColorTeam[MyTeam];
		C.Style     = ERenderStyle.STY_Alpha;
		C.GetCameraLocation( CamLoc, CamRot );
		//        ProgressPct = float(P.Health) / 100;

		if ( IsPawnVisible( C, P, ScreenPos, CamLoc, CamRot ) )
			DrawOLTeamBeacon( C, P, CamLoc, ScreenPos);

		/*        else if ( IsTargetInFrontOfPlayer( C, SlavePRI.TaggedPlayerLocation[i], ScreenPos, CamLoc, CamRot ) )
		{
		DrawLocationTracking_Obstructed( C, SlavePRI.TaggedPlayerLocation[i], false, CamLoc, ScreenPos );
		}
		else
		{

		}
		*/
	}
}

simulated function DrawOLTeamBeacon( Canvas C, Pawn P, vector CamLoc, out vector ScreenPos )
{
	local float     XL, YL, tileX, tileY, width, height;
	local vector    IndicatorPos, A;

	A = P.location;
	XL = XL*0.5;
	YL = YL*0.5;

	tileX   = 64.f * 0.45 * ResScaleX * HUDScale;
	tileY   = 64.f * 0.45 * ResScaleY * HUDScale;

	width   = FMax(tileX*0.5, XL);
	height  = tileY*0.5 + YL*2;
	ClipScreenCoords( C, ScreenPos.X, ScreenPos.Y, width, height );

	// Objective Icon
	IndicatorPos.X = ScreenPos.X;
	IndicatorPos.Y = ScreenPos.Y - height + YL + tileY*0.5;
	DrawOLBeacon( C, P, IndicatorPos.X - tileX*0.5, IndicatorPos.Y - tileY*0.5, tileX, tileY );

	ScreenPos = IndicatorPos;
}

// This function actually draws an individual beacon
simulated function DrawOLBeacon( Canvas C, Pawn P, float posX, float posY, float tileX, float tileY )
{
	local texture BeaconTex;
	local string NameString;
	local float Distance;
	local float XL, YL;

	Distance = VSize(P.Location - PawnOwner.Location);

	if(P.Weapon != none && P.Weapon.IsA('UTRPulseGun'))
	{
		BeaconTex = PlayerOwner.LinkBeaconTexture;
		C.DrawColor = TeamBeaconLinkColor;
	}
	else
	{
		BeaconTex = PlayerOwner.TeamBeaconTexture;
		C.DrawColor = TeamBeaconTeamColors[PlayerOwner.PlayerReplicationInfo.Team.TeamIndex];
	}

	if(Distance < xPlayer(PlayerOwner).TeamBeaconMaxDist)
	{
		C.SetPos(posX + (0.25 * BeaconTex.USize * ResScaleX * HUDScale)/2, posY);
		C.DrawTile(BeaconTex,
			0.25 * BeaconTex.USize,
			0.25 * BeaconTex.VSize,
			0.0,
			0.0,
			BeaconTex.USize,
			BeaconTex.VSize);
	}

	if(Distance < xPlayer(PlayerOwner).TeamBeaconPlayerInfoMaxDist)
	{
		if(P.PlayerReplicationInfo.bBot)
			NameString = P.PlayerReplicationInfo.PlayerName@"["$P.PlayerReplicationInfo.GetCallSign()$"]"@"("$P.Health$")";
		else
			NameString = P.PlayerReplicationInfo.PlayerName@"("$P.Health$")";

		C.Font          = C.SmallFont;
		C.StrLen("Test",XL, YL);
		C.SetPos(PosX + (0.25 * BeaconTex.USize * ResScaleX * HUDScale)/2, PosY - (1.2 * YL));

		C.DrawTextClipped(NameString, false);
	}
}

static function Color GetGYRColorRamp( float Pct )
{
	local Color GYRColor;

	GYRColor.A = 255;
	if ( Pct < 0.34 )
	{
		GYRColor.R = 128 + 127 * FClamp(3.f*Pct, 0.f, 1.f);
		GYRColor.G = 0;
		GYRColor.B = 0;
	}
	else if ( Pct < 0.67 )
	{
		GYRColor.R = 255;
		GYRColor.G = 255 * FClamp(3.f*(Pct-0.33), 0.f, 1.f);
		GYRColor.B = 0;
	}
	else
	{
		GYRColor.R = 255 * FClamp(3.f*(1.f-Pct), 0.f, 1.f);
		GYRColor.G = 255;
		GYRColor.B = 0;
	}

	return GYRColor;
}

simulated final function bool IsPawnVisible( Canvas C, Pawn Target, out vector ScreenPos,
											Vector CamLoc, Rotator CamRot )
{
	local vector        TargetLocation, TargetDir;
	local float         Dist;

	Dist = VSize(Target.Location - CamLoc);

	// Target is located behind camera
	if ( !IsPawnInFrontOfPlayer( C, Target, ScreenPos, CamLoc, CamRot ) )
		return false;

	// Simple Line check to see if we hit geometry
	TargetDir       = Target.Location - CamLoc;
	TargetDir.Z     = 0;
	TargetLocation  = Target.Location;// - 2.f * Target.CollisionRadius * vector(rotator(TargetDir));
	TargetLocation.Z += Target.CollisionHeight;

	if ( !FastTrace( TargetLocation, CamLoc ) )
		return false;

	return true;
}

/* returns true if target is projected on visible canvas area */
static function bool IsPawnInFrontOfPlayer( Canvas C, Pawn Target, out Vector ScreenPos,
										   Vector CamLoc, Rotator CamRot )
{
	local vector TargetLocation, TargetDir;

	TargetDir       = Target.Location - CamLoc;
	TargetDir.Z     = 0;
	TargetLocation = Target.Location;// - 2.f * Target.CollisionRadius * vector(rotator(TargetDir));
	TargetLocation.Z += Target.CollisionHeight;

	// Is Target located behind camera ?
	if ( (Target.Location - CamLoc) Dot vector(CamRot) < 0)
		return false;

	// Is Target on visible canvas area ?
	ScreenPos = C.WorldToScreen( TargetLocation );
	if ( ScreenPos.X <= 0 || ScreenPos.X >= C.ClipX ) return false;
	if ( ScreenPos.Y <= 0 || ScreenPos.Y >= C.ClipY ) return false;

	return true;
}

simulated final function bool IsActorVisible( Canvas C, Actor Target, out vector ScreenPos,
											 Vector CamLoc, Rotator CamRot )
{
	local vector        TargetLocation, TargetDir;
	local float         Dist;

	Dist = VSize(Target.Location - CamLoc);

	// Target is located behind camera
	if ( !IsActorInFrontOfPlayer( C, Target, ScreenPos, CamLoc, CamRot ) )
		return false;

	// Simple Line check to see if we hit geometry
	TargetDir       = Target.Location - CamLoc;
	TargetDir.Z     = 0;
	TargetLocation  = Target.Location;// - 2.f * Target.CollisionRadius * vector(rotator(TargetDir));
	TargetLocation.Z += Target.CollisionHeight / 2;

	if ( !FastTrace( TargetLocation, CamLoc ) )
		return false;

	return true;
}

/* returns true if target is projected on visible canvas area */
static function bool IsActorInFrontOfPlayer( Canvas C, Actor Target, out Vector ScreenPos,
											Vector CamLoc, Rotator CamRot )
{
	local vector TargetLocation, TargetDir;

	TargetDir       = Target.Location - CamLoc;
	TargetDir.Z     = 0;
	TargetLocation = Target.Location;// - 2.f * Target.CollisionRadius * vector(rotator(TargetDir));
	TargetLocation.Z += Target.CollisionHeight / 2;

	// Is Target located behind camera ?
	if ( (Target.Location - CamLoc) Dot vector(CamRot) < 0)
		return false;

	// Is Target on visible canvas area ?
	ScreenPos = C.WorldToScreen( TargetLocation );
	if ( ScreenPos.X <= 0 || ScreenPos.X >= C.ClipX ) return false;
	if ( ScreenPos.Y <= 0 || ScreenPos.Y >= C.ClipY ) return false;

	return true;
}

static function ClipScreenCoords( Canvas C, out float X, out float Y, optional float XL, optional float YL )
{
	if ( X < XL ) X = XL;
	if ( Y < YL ) Y = YL;
	if ( X > C.ClipX - XL ) X = C.ClipX - XL;
	if ( Y > C.ClipY - YL ) Y = C.ClipY - YL;
}

/*
function Timer()
{
	local TeamInfo TargetTeam;

	Super.Timer();

	if ( (PawnOwnerPRI == None)
		|| (PlayerOwner.IsSpectating() && (PlayerOwner.bBehindView || (PlayerOwner.ViewTarget == PlayerOwner))) )
		return;

	
	if( UTRGameReplicationInfo(PlayerOwner.GameReplicationInfo) != none
		&& UTRGameReplicationInfo(PlayerOwner.GameReplicationInfo).bDesignation )
	{
		TargetTeam = UTRGameReplicationInfo(PlayerOwner.GameReplicationInfo).DesignationTarget[PawnOwnerPRI.Team.TeamIndex];
		if ( UTRGameReplicationInfo(PlayerOwner.GameReplicationInfo).UTRFlagHolder[TargetTeam.TeamIndex] != PawnOwnerPRI )
			PlayerOwner.ReceiveLocalizedMessage( class'UTRCTFHUDMessage', 4+TargetTeam.TeamIndex);
	}
}*/

static function color GetTeamColor( byte TeamNum )
{
	if (TeamNum < 4)
		return default.OLHudColorTeam[TeamNum];

	return default.OLHudColorTeam[0];
}

defaultproperties
{
     ScoreTeam(0)=(RenderStyle=STY_Alpha,MinDigitCount=1,TextureScale=0.540000,DrawPivot=DP_MiddleRight,PosX=0.500000,OffsetX=-90,OffsetY=32,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     ScoreTeam(1)=(RenderStyle=STY_Alpha,MinDigitCount=1,TextureScale=0.540000,DrawPivot=DP_MiddleLeft,PosX=0.500000,OffsetX=90,OffsetY=32,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     totalLinks=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.750000,DrawPivot=DP_LowerRight,PosX=1.000000,PosY=0.835000,OffsetX=-65,OffsetY=48,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     VersusSymbol=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=435,X2=508,Y2=31),TextureScale=0.400000,DrawPivot=DP_UpperMiddle,PosX=0.500000,OffsetY=30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TeamScoreBackGround(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-50,OffsetY=10,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TeamScoreBackGround(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,PosX=0.500000,OffsetX=50,OffsetY=10,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TeamScoreBackGroundDisc(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-35,OffsetY=5,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TeamScoreBackGroundDisc(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,PosX=0.500000,OffsetX=35,OffsetY=5,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     LinkIcon=(WidgetTexture=FinalBlend'HUDContent.Generic.fbLinks',RenderStyle=STY_Alpha,TextureCoords=(X2=127,Y2=63),TextureScale=0.800000,DrawPivot=DP_LowerRight,PosX=1.000000,PosY=1.000000,OffsetX=5,OffsetY=-40,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     TeamSymbols(0)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-200,OffsetY=45,Tints[0]=(B=100,G=100,R=255,A=200),Tints[1]=(B=32,G=32,R=255,A=200))
     TeamSymbols(1)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,PosX=0.500000,OffsetX=200,OffsetY=45,Tints[0]=(B=255,G=128,A=200),Tints[1]=(B=255,G=210,R=32,A=200))
     CarrierTextColor1=(G=255,R=255,A=255)
     CarrierTextColor2=(G=255,A=255)
     CarrierTextColor3=(B=200,G=200,R=200,A=255)
     CNPosX=0.010000
     CNPosY=0.010000
     LinkEstablishedMessage="LINK ESTABLISHED"
     OLScoreTeam(0)=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.540000,DrawPivot=DP_MiddleRight,PosX=0.500000,OffsetX=-80,OffsetY=32,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLScoreTeam(1)=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.540000,DrawPivot=DP_MiddleLeft,PosX=0.500000,OffsetX=80,OffsetY=32,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLScoreTeam(2)=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.540000,DrawPivot=DP_MiddleRight,PosX=0.500000,OffsetX=-80,OffsetY=87,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLScoreTeam(3)=(RenderStyle=STY_Alpha,MinDigitCount=2,TextureScale=0.540000,DrawPivot=DP_MiddleLeft,PosX=0.500000,OffsetX=80,OffsetY=87,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGround(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-20,OffsetY=10,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGround(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,PosX=0.500000,OffsetX=20,OffsetY=10,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGround(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-20,OffsetY=65,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGround(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=168,Y1=211,X2=334,Y2=255),TextureScale=0.530000,PosX=0.500000,OffsetX=20,OffsetY=65,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGroundDisc(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-5,OffsetY=5,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGroundDisc(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,PosX=0.500000,OffsetX=5,OffsetY=5,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGroundDisc(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-5,OffsetY=60,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamScoreBackGroundDisc(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=119,Y1=258,X2=173,Y2=313),TextureScale=0.530000,PosX=0.500000,OffsetX=5,OffsetY=60,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     OLTeamSymbols(0)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-41,OffsetY=45,Tints[0]=(B=100,G=100,R=255,A=200),Tints[1]=(B=32,G=32,R=255,A=200))
     OLTeamSymbols(1)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,PosX=0.500000,OffsetX=41,OffsetY=45,Tints[0]=(B=255,G=128,A=200),Tints[1]=(B=255,G=210,R=32,A=200))
     OLTeamSymbols(2)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-41,OffsetY=337,Tints[0]=(B=255,G=128,A=200),Tints[1]=(B=255,G=210,R=32,A=200))
     OLTeamSymbols(3)=(RenderStyle=STY_Alpha,TextureCoords=(X2=256,Y2=256),TextureScale=0.100000,PosX=0.500000,OffsetX=41,OffsetY=337,Tints[0]=(B=255,G=128,A=200),Tints[1]=(B=255,G=210,R=32,A=200))
     OLHudColorTeam(0)=(R=200,A=255)
     OLHudColorTeam(1)=(B=200,G=64,R=50,A=255)
     OLHudColorTeam(2)=(G=200,A=255)
     OLHudColorTeam(3)=(G=200,R=200,A=255)
     TeamBeaconTeamColors(0)=(R=180,A=255)
     TeamBeaconTeamColors(1)=(B=200,G=80,R=80,A=255)
     TeamBeaconTeamColors(2)=(B=80,G=200,R=80,A=255)
     TeamBeaconTeamColors(3)=(B=80,G=200,R=200,A=255)
     TeamBeaconLinkColor=(B=255,G=255,R=255,A=255)
     DistributionCornerX(0)=0.045000
     DistributionCornerX(1)=0.045000
     DistributionCornerX(2)=0.045000
     DistributionCornerX(3)=0.045000
     DistributionCornerY(0)=0.010000
     DistributionCornerY(1)=0.010000
     DistributionCornerY(2)=0.073000
     DistributionCornerY(3)=0.073000
     DistributionSpacingX=0.007500
     DistributionSpacingY=0.010000
     DistributionIndicatorWidth=12.000000
     NewMessagePosY=0.170000
     DistributionIndicator=Texture'UTRHUDTextures.HUDContent.HudBase'
     DistributionIndicatorAlert=FinalBlend'UTRHUDTextures.Generic.HUDPulse'
     EliminatedColor=(B=100,G=100,R=100,A=255)
}
