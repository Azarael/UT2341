class UT2341TransAttachment extends xWeaponAttachment;

var bool bShowDisk;
replication
{
	reliable if (Role == ROLE_Authority)
		bShowDisk;
}

//===========================================================================
// Hide the trans disk if it was fired.
//===========================================================================
simulated function PostNetBeginPlay()
{
	if (!bShowDisk)
		SetBoneScale(1, 0, 'Module');
	else 	SetBoneScale(1, 1, 'Module');
}
simulated function PostNetReceive()
{
	if (!bShowDisk)
		SetBoneScale(1, 0, 'Module');
	else 	SetBoneScale(1, 1, 'Module');
}

simulated function SetDiskShow(bool bShow)
{
	bShowDisk = bShow;
	if (!bShowDisk)
		SetBoneScale(1, 0, 'Module');
	else 	SetBoneScale(1, 1, 'Module');
}

defaultproperties
{
     bShowDisk=True
     Mesh=SkeletalMesh'UT2341Weapons_Anims.UTTranslocator3rd'
     RelativeLocation=(Y=5.000000,Z=5.000000)
     DrawScale=0.100000
     bNetNotify=True
}
