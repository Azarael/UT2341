class UT2341SniperAmmo extends Ammunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

defaultproperties
{
     MaxAmmo=50
     InitialAmount=8
     bTryHeadShot=True
     PickupClass=Class'UT2341Weapons_BETA3.UT2341SniperAmmoPickup'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=451,Y1=445,X2=510,Y2=500)
     ItemName="Sniper Rounds"
}
