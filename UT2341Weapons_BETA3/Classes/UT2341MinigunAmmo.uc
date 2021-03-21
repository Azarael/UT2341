class UT2341MinigunAmmo extends Ammunition;

#EXEC OBJ LOAD FILE=InterfaceContent.utx

simulated function PostNetReceive()
{
	if (AmmoAmount == 0)
		Pawn(Owner).Weapon.OutOfAmmo();
}

defaultproperties
{
     MaxAmmo=199
     InitialAmount=100
     PickupClass=Class'UT2341Weapons_BETA3.UT2341MinigunAmmoPickup'
     IconMaterial=Texture'HUDContent.Generic.HUD'
     IconCoords=(X1=338,Y1=40,X2=393,Y2=79)
     ItemName="Bullets"
     bNetNotify=True
}
