//==============================================================================
// Hud for UTRAssult
//
// Writen by Brian 'Snake.PLiSKiN' Alexander for UTR
// Copyright (c) 2005, Brian Alexander for UTR.  All Rights Reserved.
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
// http://wiki.beyondunreal.com/wiki/OpenUnrealModLicense
//==============================================================================
class HudCUTRAssault extends HUD_Assault;

#exec OBJ LOAD FILE=UTRHUDTextures.utx

//Forced to do this to get a new weapon - nice Const for weapon bar size you got there Epic - Azarael
const ACTUAL_WEAPON_BAR_SIZE = 10;

var() class<Weapon> 		    UTBaseWeapons[ACTUAL_WEAPON_BAR_SIZE];
var() SpriteWidget      		UTBarWeaponIcon[ACTUAL_WEAPON_BAR_SIZE];
var() SpriteWidget      		UTBarAmmoIcon[ACTUAL_WEAPON_BAR_SIZE];
var() SpriteWidget     		    UTBarBorder[ACTUAL_WEAPON_BAR_SIZE];
var() SpriteWidget     		    UTBarBorderAmmoIndicator[ACTUAL_WEAPON_BAR_SIZE];
var float               		UTBarBorderScaledPosition[ACTUAL_WEAPON_BAR_SIZE];
var WeaponState         	    UTBarWeaponStates[ACTUAL_WEAPON_BAR_SIZE];
var() int 						UTBarWeaponIconAnim[ACTUAL_WEAPON_BAR_SIZE];

// used with the ShieldMan
var bool                        bShieldbelt, bThighArmor, bChestArmor, bJumpBoots;
var int                         BeltAmount, ThighAmount, ChestAmount;
// Shields
var() SpriteWidget              ShieldManIcon;		// Base Human Male Texture. The next 3 textures are rendered over this texture
var() SpriteWidget              ShieldBeltIcon;		// Shield Belt overlay texture
var() SpriteWidget              ShieldBodyArmorIcon;	// Body Armor overlay texture
var() SpriteWidget              ShieldThighPadsIcon;	// ThighPads overlay texture
var() SpriteWidget              ShieldBootsIcon;		// Jump Boots overlay texture
// Personal Score
var() SpriteWidget              ChatBackground;
var material                    HUDTex, HUDPulseTex;

var() globalconfig bool         bShowChatBackground;
var   globalconfig bool         bShowPortraitOnTalk;

var bool                        bSmallBar;

//Positioning
var const float                 XShifts[9];
var const float                 YShifts[9];

//Scaling
var bool                        bCorrectAspectRatio;

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
	local float CachedScale;
	
	if (!bCorrectAspectRatio)
	{
		DrawSpriteWidget(C, W);
		return;
	}
	
	CachedScale = W.TextureScale * ResScaleY * HudScale;
	
	C.Style = W.RenderStyle;
	
	C.DrawColor = W.Tints[TeamIndex];
	
	switch(W.ScaleMode)
	{
		case SM_None:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * CachedScale
				);
			C.DrawTile(
					W.WidgetTexture, 
					Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * CachedScale,  
					Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * CachedScale, 
					W.TextureCoords.X1, 
					W.TextureCoords.Y1, 
					W.TextureCoords.X2 - W.TextureCoords.X1, 
					W.TextureCoords.Y2 - W.TextureCoords.Y1
					);
			break;
		
		case SM_Right:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * CachedScale
				);
			C.DrawTile(
				W.WidgetTexture, 
				Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale * CachedScale,  
				Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * CachedScale, 
				W.TextureCoords.X1, 
				W.TextureCoords.Y1, 
				(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale, 
				W.TextureCoords.Y2 - W.TextureCoords.Y1
				);
			break;
			
		case SM_Left:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot] + (Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * (1- W.Scale))) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot])  * CachedScale
				);
			C.DrawTile(
				W.WidgetTexture, 
				Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale * CachedScale,  
				Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * CachedScale, 
				W.TextureCoords.X1	+	((W.TextureCoords.X2 - W.TextureCoords.X1) * (1-W.Scale)), 
				W.TextureCoords.Y1, 
				(W.TextureCoords.X2 - W.TextureCoords.X1) * W.Scale, 
				W.TextureCoords.Y2 - W.TextureCoords.Y1
				);
			break;
		
		case SM_Down:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot]) * CachedScale
				);
			C.DrawTile(
				W.WidgetTexture, 
				Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * CachedScale,  
				Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale * CachedScale, 
				W.TextureCoords.X1, 
				W.TextureCoords.Y1, 
				W.TextureCoords.X2 - W.TextureCoords.X1,
				(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale
				);
			break;
			
		case SM_Up:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot] + (Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * (1- W.Scale)))  * CachedScale
				);
			C.DrawTile(
				W.WidgetTexture, 
				Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * CachedScale,  
				Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale * CachedScale, 
				W.TextureCoords.X1, 
				W.TextureCoords.Y1	+	((W.TextureCoords.Y2 - W.TextureCoords.Y1) * (1-W.Scale)), 
				W.TextureCoords.X2 - W.TextureCoords.X1,
				(W.TextureCoords.Y2 - W.TextureCoords.Y1) * W.Scale
				);
			break;
			
		default:
			C.SetPos(
				(C.ClipX * W.PosX) + (W.OffsetX - Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * XShifts[W.DrawPivot]) * CachedScale,
				(C.ClipY * W.PosY) + (W.OffsetY - Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * YShifts[W.DrawPivot])  * CachedScale
				);
			C.DrawTile(
					W.WidgetTexture, 
					Abs(W.TextureCoords.X2 - W.TextureCoords.X1) * CachedScale,  
					Abs(W.TextureCoords.Y2 - W.TextureCoords.Y1) * CachedScale, 
					W.TextureCoords.X1, 
					W.TextureCoords.Y1, 
					W.TextureCoords.X2 - W.TextureCoords.X1, 
					W.TextureCoords.Y2 - W.TextureCoords.Y1
					);
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
		
	C.SetPos((C.ClipX * W.PosX) + (W.OffsetX - (D.TextureCoords[0].X2 - D.TextureCoords[0].X1) * (((length + padding) * XShifts[W.DrawPivot]) - (padding * (1-W.bPadWithZeroes) )) ) * (W.TextureScale * ResScaleY *  HUDScale),
			(C.ClipY * W.PosY) + (W.OffsetY - (D.TextureCoords[0].Y2 - D.TextureCoords[0].Y1) * YShifts[W.DrawPivot])  * (W.TextureScale * ResScaleY * HUDScale));
	C.DrawColor = W.Tints[TeamIndex];
	
	for (i = 0; i < length; i++)
	{
		if (t[i] == "-")
			coordindex = 10;
		else coordindex = byte(t[i]);
		
		C.DrawTile(
						D.DigitTexture,
						(D.TextureCoords[coordindex].X2 - D.TextureCoords[coordindex].X1) * W.TextureScale * ResScaleY * HUDScale,  
						(D.TextureCoords[coordindex].Y2 - D.TextureCoords[coordindex].Y1) * W.TextureScale * ResScaleY * HUDScale, 
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
	
	if (!bCorrectAspectRatio && ResScaleX/ResScaleY > 1)
		bCorrectAspectRatio = True;
	else if (bCorrectAspectRatio && ResScaleX / ResScaleY <= 1)
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

simulated function UpdatePrecacheMaterials()
{
	Level.AddPrecacheMaterial(Material'UTRHUDTextures.HUDContent.HudBase');
	Level.AddPrecacheMaterial(Material'UTRHUDTextures.Generic.HUDPulse');
	Level.AddPrecacheMaterial(Material'UTRHUDTextures.HUDContent.HUDShields');
	Super.UpdatePrecacheMaterials();
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

simulated function DrawChargeBar( Canvas C)
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
	C.DrawTile( Material'HudContent.HUD', ScaleFactor, 0.223*ScaleFactor, 0, 110, 166, 53 );

	RechargeBar.Scale = FMin(PawnOwner.Weapon.ChargeBar(), 1);
	if ( RechargeBar.Scale > 0 )
	{
		DrawWidgetAsTile( C, RechargeBar);
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
	C.DrawTile( Material'HudContent.HUD', ScaleFactor, 0.223*ScaleFactor, 0, 110, 166, 53 );

	DrawWidgetAsTile(C, RechargeBar);
	RechargeBar.Scale = Vehicle(PawnOwner).ChargeBar();
	ShowReloadingPulse(RechargeBar.Scale);
}

simulated function DrawHudPassA (Canvas C)
{
	local Pawn RealPawnOwner;
	local class<Ammunition> AmmoClass;
	local bool	bOldShowWeaponInfo, bOldShowPersonalInfo;

	// Ammo Count
	bOldShowWeaponInfo = bShowWeaponInfo;
	if ( PawnOwner != None && PawnOwner.Weapon != None )
	{
		AmmoClass = PawnOwner.Weapon.GetAmmoClass(0);
		if ( (AmmoClass == None) || ClassIsChildOf(AmmoClass,class'Ammo_Dummy') )
			bShowWeaponInfo = false;
	}

	// Healh info
	bOldShowPersonalInfo = bShowPersonalInfo;
	if ( (ASVehicle(PawnOwner) != None) && ASVehicle(PawnOwner).bCustomHealthDisplay )
		bShowPersonalInfo = false;

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
							AmmoIcon.WidgetTexture = Material'UTRHUDTextures.Generic.HUDPulse';
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

			DrawHUDAnimWidget( HudBorderHealthIcon, default.HudBorderHealthIcon.TextureScale, LastHealthPickupTime, 0.6, 0.6);
			DrawWidgetAsTile( C, HudBorderHealth );

			if(CurHealth/PawnOwner.HealthMax < 0.26)
			{
				HudHealthALERT.Tints[TeamIndex] = HudColorTeam[TeamIndex];
				DrawWidgetAsTile( C, HudHealthALERT);
				HudBorderHealthIcon.WidgetTexture = Material'UTRHUDTextures.Generic.HUDPulse';
			}
			else
				HudBorderHealthIcon.WidgetTexture = default.HudBorderHealth.WidgetTexture;

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
					HudVehicleHealthALERT.Tints[TeamIndex] = HudColorTeam[TeamIndex];
					DrawWidgetAsTile(C, HudVehicleHealthALERT);
					HudBorderVehicleHealthIcon.WidgetTexture = Material'UTRHUDTextures.Generic.HUDPulse';
				}
				else
					HudBorderVehicleHealthIcon.WidgetTexture = default.HudBorderVehicleHealth.WidgetTexture;

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
					DigitsVehicleHealth.OffsetX = default.DigitsVehicleHealth.OffsetX;
					DigitsVehicleHealth.OffsetY = default.DigitsVehicleHealth.OffsetY;
					DigitsVehicleHealth.TextureScale = default.DigitsVehicleHealth.TextureScale;
				}
			}
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
	{
		DrawShieldMan(C);
		if ( bShowChatBackground )
		{
			DrawWidgetAsTile( C, ChatBackground);
			ChatBackground.Tints[TeamIndex] = HudColorTeam[TeamIndex]; // Aco: color chat box according to team
		}
	}

	if( Level.TimeSeconds - LastVoiceGainTime < 0.333 )
		DisplayVoiceGain(C);

	DisplayLocalMessages (C);
	UpdateRankAndSpread(C);
	ShowTeamScorePassA(C);

	if ( Links >0 )
	{
		DrawWidgetAsTile (C, LinkIcon);
		DrawNumericWidgetAsTiles (C, totalLinks, DigitsBigPulse);
	}
	totalLinks.value = Links;

	bShowWeaponInfo		= bOldShowWeaponInfo;
	bShowPersonalInfo	= bOldShowPersonalInfo;

	// Vehicle Radar
	if ( bDrawRadar && Vehicle(PawnOwner) != None && Vehicle(PawnOwner).bHasRadar )
		DrawRadarPassA( C );
}

simulated function ShowTeamScorePassA(Canvas C)
{
	local float	PosY;

	if ( ASGRI == None )
		return;

	//
	// HUDBase texture
	//
	
	if ( ASGRI.RoundTimeLimit > 0 )
		DrawWidgetAsTile (C, RoundTimeSeparator);

	if (bShowChatBackground)
		PosY = 0.12 * HUDScale;

	if ( Level.Game == None || !ASGameInfo(Level.Game).bDisableReinforcements )
	{
		ReinforceBackground.PosY		= PosY;
		ReinforceBackgroundDisc.PosY	= PosY;
		ReinforcePulse.PosY				= PosY;
		ReinforceIcon.PosY				= PosY;
		ReinforceSprNum.PosY			= PosY;
		PosY += 0.06 * HUDScale;

		/* Reinforcements count down */
		ReinforceBackground.Tints[TeamIndex] = HudColorBlack;
		ReinforceBackground.Tints[TeamIndex].A = 150;
		DrawWidgetAsTile (C, ReinforceBackground);
		DrawWidgetAsTile (C, ReinforceBackgroundDisc);
		ReinforcePulse.Tints[TeamIndex] = HudColorHighLight;
		if ( ASGRI.ReinforcementCountDown < 1 )	// Pulse when reinforcements arrive
			DrawWidgetAsTile( C, ReinforcePulse );
		DrawWidgetAsTile (C, ReinforceIcon);
	}

	/* second attack wave comparison */
	if ( ASGRI != None && (ASGRI.CurrentRound % 2 == 0) && !ASGRI.IsPracticeRound() && IsVSRelevant() )
	{
		VSBackground.PosY		= PosY;
		VSBackgroundDisc.PosY	= PosY;
		VSIcon.PosY				= PosY;
		PosY += 0.06 * HUDScale;

		VSBackground.Tints[TeamIndex] = HudColorBlack;
		VSBackground.Tints[TeamIndex].A = 150;
		DrawWidgetAsTile (C, VSBackground);
		DrawWidgetAsTile (C, VSBackgroundDisc);
		DrawWidgetAsTile (C, VSIcon);	
	}

	/* Teleport */
	if ( ASPRI !=None && ASPRI.bTeleportToSpawnArea && TeleportSprNum.Value >= 0 )
	{
		TeleportBackground.PosY		= PosY;
		TeleportBackgroundDisc.PosY	= PosY;
		TeleportPulse.PosY			= PosY;
		TeleportIcon.PosY			= PosY;
		TeleportSprNum.PosY			= PosY;
		PosY += 0.06 * HUDScale;

		TeleportBackground.Tints[TeamIndex] = HudColorBlack;
		TeleportBackground.Tints[TeamIndex].A = 150;
		DrawWidgetAsTile (C, TeleportBackground);
		DrawWidgetAsTile (C, TeleportBackgroundDisc);
		TeleportPulse.Tints[TeamIndex] = HudColorHighLight;
		DrawWidgetAsTile( C, TeleportPulse );
		DrawWidgetAsTile (C, TeleportIcon);
	}

	//
	// Numeric
	//

	/* Round Time Limit */
	if ( ASGRI.RoundTimeLimit > 0 )
	{
		DrawNumericWidgetAsTiles (C, RoundTimeMinutes, DigitsBig);
		DrawNumericWidgetAsTiles (C, RoundTimeSeconds, DigitsBig);
	}

	/* reinforcements */
	if ( Level.Game == None || !ASGameInfo(Level.Game).bDisableReinforcements )
		DrawNumericWidgetAsTiles (C, ReinforceSprNum, DigitsBig);

	/* second attack wave comparison */
	if ( ASGRI != None && (ASGRI.CurrentRound % 2 == 0) && !ASGRI.IsPracticeRound() && IsVSRelevant() )
		DrawTeamVS( C );

	/* Teleport */
	if ( ASPRI !=None && ASPRI.bTeleportToSpawnArea && TeleportSprNum.Value >= 0 )
		DrawNumericWidgetAsTiles (C, TeleportSprNum, DigitsBig);
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
	
	local Weapon Weapons[ACTUAL_WEAPON_BAR_SIZE];
	local byte ExtraWeapon[ACTUAL_WEAPON_BAR_SIZE];
	local Inventory Inv;
	local Weapon W, PendingWeapon;

	if (ResScaleX / ResScaleY >= 1.1)
	{
		if (bSmallBar)
		{
			for (i=0; i < ACTUAL_WEAPON_BAR_SIZE; i++)
			{
				UTBarBorder[i].TextureScale = 0.53;
				UTBarWeaponIcon[i].TextureScale = 0.53;
				UTBarBorderAmmoIndicator[i].TextureScale = 0.53;
			}
			bSmallBar = False;
		}
	}
	else if (!bSmallBar)
	{
		for (i=0; i < ACTUAL_WEAPON_BAR_SIZE; i++)
		{
			UTBarBorder[i].TextureScale = 0.48;
			UTBarWeaponIcon[i].TextureScale = 0.48;
			UTBarBorderAmmoIndicator[i].TextureScale = 0.48;
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
	for( i=0; i<ACTUAL_WEAPON_BAR_SIZE; i++ )
	{
		W = Weapons[i];

		UTBarBorder[i].Tints[0] = HudColorRed;
		UTBarBorder[i].Tints[1] = HudColorBlue;
		UTBarBorder[i].OffsetY = 0;
		UTBarWeaponIcon[i].OffsetY = Default.UTBarWeaponIcon[i].OffsetY;
		
		if( W == none )
		{
			UTBarWeaponStates[i].HasWeapon = false;
			if ( bShowMissingWeaponInfo )
			{
				//UTBarWeaponIcon[i].OffsetX =  IconOffset;
				
				if ( UTBarWeaponIcon[i].Tints[TeamIndex] != HudColorBlack )
				{
					UTBarWeaponIcon[i].WidgetTexture = Default.UTBarWeaponIcon[i].WidgetTexture;
					UTBarWeaponIcon[i].TextureCoords = default.UTBarWeaponIcon[i].TextureCoords;
					if (bSmallBar)
						UTBarWeaponIcon[i].TextureScale = 0.48;
					else UTBarWeaponIcon[i].TextureScale = 0.53;
					UTBarWeaponIcon[i].Tints[TeamIndex] = HudColorBlack;
					UTBarWeaponIconAnim[i] = 0;
				}
				DrawWidgetAsTile( C, UTBarBorder[i] );
				DrawWidgetAsTile( C, UTBarWeaponIcon[i] ); // FIXME- have combined version
			}
		}
		else
		{
			if( !UTBarWeaponStates[i].HasWeapon )
			{
				// just picked this weapon up!
				UTBarWeaponStates[i].PickupTimer = Level.TimeSeconds;
				UTBarWeaponStates[i].HasWeapon = true;
			}

			UTBarBorderAmmoIndicator[i].OffsetY = 0;
			
			UTBarWeaponIcon[i].WidgetTexture = W.IconMaterial;
			UTBarWeaponIcon[i].TextureCoords = W.IconCoords;
			
			//Cheese
			if (Abs(W.IconCoords.Y1 - W.IconCoords.Y2) > 64)
			{
				UTBarWeaponIcon[i].TextureScale = default.UTBarWeaponIcon[i].TextureScale / ((Abs(W.IconCoords.Y1 - W.IconCoords.Y2) + 1)/ 32);
				IconOffset *= (default.UTBarWeaponIcon[i].TextureScale / UTBarWeaponIcon[i].TextureScale);
				UTBarWeaponIcon[i].OffsetY = -30 * (default.UTBarWeaponIcon[i].TextureScale / UTBarWeaponIcon[i].TextureScale);
			}
			else
			{
				if (bSmallBar)
					UTBarWeaponIcon[i].TextureScale = 0.48;
				else UTBarWeaponIcon[i].TextureScale = 0.53;
				UTBarWeaponIcon[i].OffsetY = default.UTBarWeaponIcon[i].OffsetY;
			}
			
			UTBarBorderAmmoIndicator[i].Scale = FMin(W.AmmoStatus(), 1);
			UTBarWeaponIcon[i].Tints[TeamIndex] = HudColorNormal;
			
			if( UTBarWeaponIconAnim[i] == 0 )
			{
                if ( UTBarWeaponStates[i].PickupTimer > Level.TimeSeconds - 0.6 )
	            {
		           if ( UTBarWeaponStates[i].PickupTimer > Level.TimeSeconds - 0.3 )
						UTBarWeaponIcon[i].TextureScale = UTBarWeaponIcon[i].TextureScale * (1 + 1.3 * (Level.TimeSeconds - UTBarWeaponStates[i].PickupTimer));	
                   else
					    UTBarWeaponIcon[i].TextureScale = UTBarWeaponIcon[i].TextureScale * (1 + 1.3 * (UTBarWeaponStates[i].PickupTimer + 0.6 - Level.TimeSeconds));	
					if (bSmallBar)
						UTBarWeaponIcon[i].OffsetX = default.UTBarWeaponIcon[i].OffsetX * (0.48 / UTBarWeaponIcon[i].TextureScale);
					else UTBarWeaponIcon[i].OffsetX = default.UTBarWeaponIcon[i].OffsetX * (0.53 / UTBarWeaponIcon[i].TextureScale);
                }
                else
				{
					UTBarWeaponIcon[i].TextureScale = default.UTBarWeaponIcon[i].TextureScale;
					UTBarWeaponIcon[i].OffsetX = default.UTBarWeaponIcon[i].OffsetX;
                    UTBarWeaponIconAnim[i] = 1;
				}
			}

			if (W == PendingWeapon)
			{
				// Change color to highlight and possibly changeTexture or animate it
				UTBarBorder[i].Tints[TeamIndex] = HudColorHighLight;
				UTBarBorder[i].OffsetY = -10;
				UTBarBorderAmmoIndicator[i].OffsetY = -10;
				UTBarWeaponIcon[i].OffsetY += -10;
			}
			if ( ExtraWeapon[i] == 1 )
			{
				if ( W == PendingWeapon )
				{
					UTBarBorder[i].Tints[0] = HudColorRed;
					UTBarBorder[i].Tints[1] = HudColorBlue;
					UTBarBorder[i].OffsetY = 0;
					UTBarBorder[i].TextureCoords.Y1 = 80;
					DrawWidgetAsTile( C, UTBarBorder[i] );
					UTBarBorder[i].TextureCoords.Y1 = 39;
					UTBarBorder[i].OffsetY = -10;
					UTBarBorder[i].Tints[TeamIndex] = HudColorHighLight;
				}
				else
				{
					UTBarBorder[i].OffsetY = -52;
					UTBarBorder[i].TextureCoords.Y2 = 48;
					DrawWidgetAsTile( C, UTBarBorder[i] );
					UTBarBorder[i].TextureCoords.Y2 = 93;
					UTBarBorder[i].OffsetY = 0;
				}
			}
			DrawWidgetAsTile( C, UTBarBorder[i] );
			DrawWidgetAsTile( C, UTBarBorderAmmoIndicator[i] );
			DrawWidgetAsTile( C, UTBarWeaponIcon[i] );
		}
	}
}

defaultproperties
{
     UTBarWeaponIcon(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=39,X2=241,Y2=77),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-435,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=245,Y1=39,X2=329,Y2=79),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-338,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=179,Y1=127,X2=241,Y2=175),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-241,OffsetY=-25,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=250,Y1=110,X2=330,Y2=145),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-145,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=78,X2=244,Y2=124),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=-48,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=246,Y1=182,X2=331,Y2=210),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=48,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=246,Y1=80,X2=332,Y2=106),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=145,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=169,Y1=172,X2=245,Y2=208),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=241,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=253,Y1=146,X2=333,Y2=181),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=338,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarWeaponIcon(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=246,Y1=182,X2=331,Y2=210),TextureScale=0.530000,DrawPivot=DP_MiddleMiddle,PosX=0.500000,PosY=1.000000,OffsetX=435,OffsetY=-30,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     UTBarBorder(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-480,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorder(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=39,X2=94,Y2=93),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-480,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(2)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(3)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(4)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=-96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(5)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(6)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=96,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(7)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=192,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(8)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=288,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     UTBarBorderAmmoIndicator(9)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(Y1=94,X2=94,Y2=109),TextureScale=0.530000,DrawPivot=DP_LowerLeft,PosX=0.500000,PosY=1.000000,OffsetX=384,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldManIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=360,Y1=4,X2=470,Y2=193),TextureScale=0.380000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     ShieldBeltIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=240,Y1=4,X2=350,Y2=193),TextureScale=0.380000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldBodyArmorIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=4,Y1=4,X2=114,Y2=193),TextureScale=0.380000,DrawPivot=DP_UpperRight,PosX=0.995000,PosY=0.005500,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldThighPadsIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HUDShields',RenderStyle=STY_Alpha,TextureCoords=(X1=123,Y1=4,X2=233,Y2=193),TextureScale=0.380000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ShieldBootsIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBoots',RenderStyle=STY_Alpha,TextureCoords=(X1=4,Y1=4,X2=114,Y2=193),TextureScale=0.380000,DrawPivot=DP_UpperRight,PosX=0.996000,PosY=0.006000,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=200),Tints[1]=(B=255,G=255,R=255,A=200))
     ChatBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.ChatBG',RenderStyle=STY_Alpha,TextureCoords=(X1=2,Y1=2,X2=512,Y2=128),TextureScale=0.500000,ScaleMode=SM_Right,Scale=1.100000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     HUDTex=Texture'UTRHUDTextures.HUDContent.HudBase'
     HUDPulseTex=FinalBlend'UTRHUDTextures.Generic.HUDPulse'
     bShowChatBackground=True
     bShowPortraitOnTalk=True
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
     RoundTimeSeparator=(PosY=1.000000,OffsetX=90,OffsetY=-28,Tints[0]=(B=55,G=55),Tints[1]=(B=55,G=55))
     RoundTimeMinutes=(PosY=1.000000,OffsetX=10,OffsetY=-27,Tints[0]=(B=55,G=55),Tints[1]=(B=55,R=55))
     RoundTimeSeconds=(PosY=1.000000,OffsetX=100,OffsetY=-27,Tints[0]=(B=55,G=55),Tints[1]=(B=55,R=55))
     ScoreTeam(0)=(PosX=0.102000,PosY=0.888000,OffsetX=0,OffsetY=0,Tints[0]=(B=215,G=215,A=250),Tints[1]=(B=0,G=0,A=250))
     ScoreTeam(1)=(DrawPivot=DP_MiddleRight,PosX=0.102000,PosY=0.941000,OffsetX=0,OffsetY=0,Tints[0]=(G=235,R=205,A=250),Tints[1]=(G=0,R=0,A=250))
     TeamScoreBackGround(0)=(TextureScale=0.560000,DrawPivot=DP_MiddleMiddle,PosX=0.060000,PosY=0.892000,OffsetX=0,OffsetY=0,Tints[0]=(B=0,G=0,R=0,A=150))
     TeamScoreBackGround(1)=(TextureScale=0.560000,DrawPivot=DP_MiddleMiddle,PosX=0.060000,PosY=0.944200,OffsetX=0,OffsetY=0,Tints[0]=(B=0,G=0,R=0,A=150))
     TeamSymbols(0)=(DrawPivot=DP_MiddleMiddle,PosX=0.036000,PosY=0.894000,OffsetX=0,OffsetY=0,Scale=1.000000)
     TeamSymbols(1)=(DrawPivot=DP_MiddleMiddle,PosX=0.036000,PosY=0.946000,OffsetX=0,OffsetY=0,Scale=1.000000)
     DigitsBig=(DigitTexture=Texture'UTRHUDTextures.HUDContent.HudBase')
     DigitsBigPulse=(DigitTexture=FinalBlend'UTRHUDTextures.Generic.fbHUDAlertSlow')
     AdrenalineCount=(TextureScale=0.400000,DrawPivot=DP_UpperRight,OffsetX=-196,OffsetY=134)
     mySpread=(OffsetX=200,OffsetY=1460)
     myRank=(OffsetX=200,OffsetY=1420)

     // we want to move this to the upper right
     MyScore=(DrawPivot=DP_MiddleRight,PosY=1.000000,OffsetX=174,OffsetY=-29)
     TimerHours=(OffsetY=200)
     TimerMinutes=(OffsetY=200)
     TimerSeconds=(OffsetY=200)
     TimerDigitSpacer(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',OffsetY=160)
     TimerDigitSpacer(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',OffsetY=160)
     TimerIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureCoords=(Y2=395),OffsetY=95)
     TimerBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',DrawPivot=DP_MiddleLeft,OffsetX=5,OffsetY=160)
     LevelActionPositionY=0.300000

     // we want to move these to the bottom left
     DigitsHealth=(TextureScale=0.400000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-198,OffsetY=75)
     DigitsShield=(TextureScale=0.400000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-198,OffsetY=13)
     
     UDamageIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase')
     AdrenalineIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureScale=0.260000,OffsetX=-220,OffsetY=202)
     AdrenalineBackground=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureCoords=(Y1=110,X2=166,Y2=163),TextureScale=0.480000,OffsetX=-96,OffsetY=102)
     AdrenalineAlert=(TextureScale=0.500000,DrawPivot=DP_MiddleLeft,OffsetX=-160,OffsetY=122)
     MyScoreIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase')
     HudHealthALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse',TextureScale=0.480000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-96,OffsetY=52)
     HudVehicleHealthALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse',DrawPivot=DP_UpperRight)
     HudAmmoALERT=(WidgetTexture=FinalBlend'UTRHUDTextures.Generic.HUDPulse')
     HudBorderShield=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureScale=0.480000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-96,OffsetY=1)
     HudBorderHealth=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureScale=0.480000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-96,OffsetY=52)
     HudBorderVehicleHealth=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',DrawPivot=DP_UpperRight,PosX=1.000000,OffsetY=15)
     HudBorderAmmo=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase')
     HudBorderShieldIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureCoords=(X1=123,Y1=163,X2=163,Y2=224),TextureScale=0.340000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-175,OffsetY=6)
     HudBorderHealthIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',TextureScale=0.410000,DrawPivot=DP_UpperRight,PosX=1.000000,PosY=0.000000,OffsetX=-132,OffsetY=64)
     HudBorderVehicleHealthIcon=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',DrawPivot=DP_UpperRight,PosX=1.139000,OffsetY=15)
     RechargeBar=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase')
     HudColorHighLight=(G=160)
     LevelActionLoading=".:. L O A D I N G .:."
     LevelActionPaused=".:. PAUSED .:."
     LevelActionFontName="UTRFonts.Nimbus29"
     InitialViewingString="Press [Fire] to View a different Player"
     ProgressFontName="UTRFonts.Dungeon18"
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
