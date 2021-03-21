//==============================================================================
// Copy + Pasted from BonusPack.HudLMS and then customized for UTR
//
// Writen by Brian 'Snake.PLiSKiN' Alexander for UTR
// Copyright (c) 2005, Brian Alexander for UTR.  All Rights Reserved.
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
// http://wiki.beyondunreal.com/wiki/OpenUnrealModLicense
//==============================================================================
class HudCUTRLastManStanding extends HudCDeathMatchPlus;

#exec OBJ LOAD FILE=LastManStanding.utx

var localized string LivesRemainingString, PlayersRemainString;

simulated function DrawSpectatingHud (Canvas C)
{
	local string InfoString;
	local plane OldModulate;
	local float xl,yl,Full, Height, Top, TextTop, MedH, SmallH,Scale;
	local int i,cnt;
	local GameReplicationInfo GRI;

	if (!PlayerOwner.PlayerReplicationInfo.bOutOfLives)
	{
		Super.DrawSpectatingHud(C);
		return;
	}

	DisplayLocalMessages (C);
	OldModulate = C.ColorModulate;

	C.Font = GetMediumFontFor(C);
	C.StrLen("W",xl,MedH);
	Height = MedH;
	C.Font = GetConsoleFont(C);
	C.StrLen("W",xl,SmallH);
	Height += SmallH;

	Full = Height;
	Top  = C.ClipY-8-Full;

	Scale = (Full+16)/128;

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

	if ( Pawn(PlayerOwner.ViewTarget) != None && Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo != None )
	{
		// Draw View Target info
		C.SetDrawColor(32,255,32,255);

		if ( C.ClipX < 640 )
			SmallH = 0;
		else
		{
			C.SetPos((256*Scale*0.75),TextTop);
			C.DrawText(NowViewing,false);
			C.StrLen(LivesRemainingString,Xl,Yl);
			C.SetPos(C.ClipX-5-XL,TextTop);
			C.DrawText(LivesRemainingString);
		}

		C.SetDrawColor(255,255,0,255);
		C.Font = GetMediumFontFor(C);
		C.SetPos((256*Scale*0.75),TextTop+SmallH);
		C.DrawText(Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo.PlayerName,false);

		InfoString = ""$Int(GRI.MaxLives - Pawn(PlayerOwner.ViewTarget).PlayerReplicationInfo.Deaths);
		C.StrLen(InfoString,xl,yl);

		C.SetPos(C.ClipX-5-XL,TextTop+SmallH);
		C.DrawText(InfoString,false);
	}
	else
	{
		C.SetDrawColor(255,255,255,255);
		C.Font = GetMediumFontFor(C);
		C.StrLen(InitialViewingString,XL,YL);
		C.SetPos( (C.ClipX/2) - (XL/2), Top + (Full/2) - (YL/2));
		C.DrawText(InitialViewingString,false);
	}

	C.Font = GetConsoleFont(C);
	C.StrLen(GRI.GameName,XL,YL);
	C.SetPos( (C.ClipX/2) - (XL/2), 10);
	C.SetDrawColor(255,255,255,255);
	C.ColorModulate.Z = 255;
	C.DrawText(GRI.GameName);
	Cnt=0;

	for (i=0;i<GRI.PRIArray.Length;i++)
	{
		if ( (GRI.PRIArray[i]!=None) && !GRI.PRIArray[i].bOutOfLives && !GRI.PRIArray[i].bIsSpectator && !GRI.PRIArray[i].bOnlySpectator )
			cnt++;
	}

	InfoString = ""$cnt@PlayersRemainString@InitialViewingString;
	C.StrLen(InfoString,xl,yl);
	C.SetPos( (C.ClipX/2) - (XL/2),Top-3-YL);
	C.DrawText(InfoString);
	OldModulate = C.ColorModulate;
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
			c.DrawText("Lives:"@myRank);
			c.SetPos(C.ClipX*0.01,C.ClipY*0.90);
			c.DrawText("Players Remaining:"@mySpread);

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

simulated function UpdateRankAndSpread(Canvas C)
{
	local int i,cnt;

	if ( (Scoreboard == None) || !Scoreboard.UpdateGRI() )
		return;

	MyRank = PlayerOwner.GameReplicationInfo.MaxLives-PawnOwnerPRI.Deaths;

	cnt=0;
	for( i=0 ; i<PlayerOwner.GameReplicationInfo.PRIArray.Length ; i++ )
		if (!PlayerOwner.GameReplicationInfo.PRIArray[i].bOutOfLives)
			cnt++;

	MySpread = cnt;
	myScore.Value = Min (PawnOwnerPRI.Score, 999);  // max display space

	if( bShowPoints )
	{
		DrawWidgetAsTile( C, MyScoreBackground );
		MyScoreBackground.Tints[TeamIndex] = HudColorBlack;
		MyScoreBackground.Tints[TeamIndex].A = 150;

		DrawWidgetAsTile( C, MyScoreBackground );
		DrawWidgetAsTile( C, MyScoreIcon );

		DrawNumericWidgetAsTiles (C, myScore, DigitsBig);
		if ( C.ClipX >= 640 )
	}
}

defaultproperties
{
     LivesRemainingString="Lives Remaining"
     PlayersRemainString="Players Remain -- "
}
