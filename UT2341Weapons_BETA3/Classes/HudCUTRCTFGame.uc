//==============================================================================
// UTR CTF HUD C
//
// Writen by Brian 'Snake.PLiSKiN' Alexander for UTR
// Copyright (c) 2006, Brian Alexander for UTR.  All Rights Reserved.
//
// This program is free software; you can redistribute and/or modify
// it under the terms of the Open Unreal Mod License version 1.1.
// http://wiki.beyondunreal.com/wiki/OpenUnrealModLicense
//==============================================================================
class HudCUTRCTFGame extends HudCTeamGamePlus;

var() float tmpPosX[4], tmpPosY[4], tmpScaleX[4], tmpScaleY[4];

struct FFlagWidget
{
	var EFlagState FlagState;
	var SpriteWidget Widgets[4];
};

var Actor FlagBase[4];
var() SpriteWidget NewFlagWidgets[4];
var SpriteWidget FlagDownWidgets[4];
var SpriteWidget FlagHeldWidgets[4];

simulated function PostBeginPlay()
{
	Super.PostBeginPlay();
	SetTimer(1.0, True);
}

simulated function ShowTeamScorePassA(Canvas C)
{
	local CTFBase B;
	local int i;

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

		DrawWidgetAsTile (C, NewFlagWidgets[0]);
		DrawWidgetAsTile (C, NewFlagWidgets[1]);

		NewFlagWidgets[0].Tints[0] = OLHudColorTeam[0];
		NewFlagWidgets[0].Tints[1] = OLHudColorTeam[0];

		NewFlagWidgets[1].Tints[0] = OLHudColorTeam[1];
		NewFlagWidgets[1].Tints[1] = OLHudColorTeam[1];

		DrawNumericWidgetAsTiles (C, OLScoreTeam[0], DigitsBig);
		DrawNumericWidgetAsTiles (C, OLScoreTeam[1], DigitsBig);

		if ( FlagBase[0] == None )
		{
			ForEach DynamicActors(class'CTFBase', B)
			{
				if ( B.IsA('UTRRedFlagBase') )
					FlagBase[0] = B;
				else if ( B.IsA('UTRBlueFlagBase') )
					FlagBase[1] = B;
				//			else if ( B.IsA('UTRGreenFlagBase') )
				//				FlagBase[2] = B;
				//			else if ( B.IsA('UTRGoldFlagBase') )
				//				FlagBase[3] = B;
				else if ( B.IsA('xRedFlagBase') )
					FlagBase[0] = B;
				else if ( B.IsA('xBlueFlagBase') )
					FlagBase[1] = B;
			}
		}
		if ( FlagBase[0] != None )
		{
			C.DrawColor = HudColorRed;
			Draw2DLocationDot(C, FlagBase[0].Location,0.5 - tmpPosX[0]*HUDScale, tmpPosY[0]*HUDScale, tmpScaleX[0]*HUDScale, tmpScaleY[0]*HUDScale);
		}
		if ( FlagBase[1] != None )
		{
			C.DrawColor = HudColorBlue;
			Draw2DLocationDot(C, FlagBase[1].Location,0.5 + tmpPosX[1]*HUDScale, tmpPosY[1]*HUDScale, tmpScaleX[1]*HUDScale, tmpScaleY[1]*HUDScale);
		}

		if ( PlayerOwner.GameReplicationInfo == None )
			return;
		for (i = 0; i < 2; i++)
		{
			if ( PlayerOwner.GameReplicationInfo.FlagState[i] == EFlagState.FLAG_HeldEnemy )
				DrawWidgetAsTile (C, FlagHeldWidgets[i]);
			else if ( PlayerOwner.GameReplicationInfo.FlagState[i] == EFlagState.FLAG_Down )
				DrawWidgetAsTile (C, FlagDownWidgets[i]);
		}
	}
}

function Timer()
{
	Super.Timer();

	if ( (PawnOwnerPRI == None)
		|| (PlayerOwner.IsSpectating() && (PlayerOwner.bBehindView || (PlayerOwner.ViewTarget == PlayerOwner))) )
		return;

	if ( PawnOwnerPRI.HasFlag != None )
		PlayerOwner.ReceiveLocalizedMessage( class'CTFHUDMessage', 0 );

	if ( (PlayerOwner.GameReplicationInfo != None) && (PlayerOwner.PlayerReplicationInfo.Team != None)
		&& (PlayerOwner.GameReplicationInfo.FlagState[PlayerOwner.PlayerReplicationInfo.Team.TeamIndex] == EFlagState.FLAG_HeldEnemy) )
		PlayerOwner.ReceiveLocalizedMessage( class'CTFHUDMessage', 1 );
}

simulated function UpdateTeamHud()
{
	Super.UpdateTeamHUD();
}

defaultproperties
{
     tmpPosX(0)=0.033500
     tmpPosX(1)=0.019500
     tmpPosY(0)=0.026000
     tmpPosY(1)=0.026000
     tmpScaleX(0)=0.020000
     tmpScaleX(1)=0.020000
     tmpScaleY(0)=0.026000
     tmpScaleY(1)=0.026000
     NewFlagWidgets(0)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=336,Y1=129,X2=397,Y2=170),TextureScale=0.450000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-8,OffsetY=8,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     NewFlagWidgets(1)=(WidgetTexture=Texture'UTRHUDTextures.HUDContent.HudBase',RenderStyle=STY_Alpha,TextureCoords=(X1=397,Y1=129,X2=339,Y2=170),TextureScale=0.450000,PosX=0.500000,OffsetX=8,OffsetY=8,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     FlagDownWidgets(0)=(WidgetTexture=FinalBlend'OLTeamGamesTex.HUD.OLTeamsHUDAlert',RenderStyle=STY_Alpha,TextureCoords=(X1=2,Y1=60,X2=36,Y2=95),TextureScale=0.450000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-19,OffsetY=40,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     FlagDownWidgets(1)=(WidgetTexture=FinalBlend'OLTeamGamesTex.HUD.OLTeamsHUDAlert',RenderStyle=STY_Alpha,TextureCoords=(X1=2,Y1=60,X2=36,Y2=95),TextureScale=0.450000,PosX=0.500000,OffsetX=19,OffsetY=40,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     FlagHeldWidgets(0)=(WidgetTexture=FinalBlend'OLTeamGamesTex.HUD.OLTeamsHUDAlert',RenderStyle=STY_Alpha,TextureCoords=(X2=21,Y2=55),TextureScale=0.300000,DrawPivot=DP_UpperRight,PosX=0.500000,OffsetX=-48,OffsetY=25,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
     FlagHeldWidgets(1)=(WidgetTexture=FinalBlend'OLTeamGamesTex.HUD.OLTeamsHUDAlert',RenderStyle=STY_Alpha,TextureCoords=(X2=21,Y2=55),TextureScale=0.300000,PosX=0.500000,OffsetX=48,OffsetY=25,ScaleMode=SM_Right,Scale=1.000000,Tints[0]=(B=255,G=255,R=255,A=255),Tints[1]=(B=255,G=255,R=255,A=255))
}
