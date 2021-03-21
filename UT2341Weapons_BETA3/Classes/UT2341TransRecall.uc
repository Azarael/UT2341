class UT2341TransRecall extends TransRecall;

simulated function PlayFiring()
{
	Weapon.PlayAnim(FireAnim, FireAnimRate, TweenTime);
}

simulated function bool AllowFire()
{
	return true;
}

defaultproperties
{
     FireAnim="FireB"
     FireRate=0.500000
}
