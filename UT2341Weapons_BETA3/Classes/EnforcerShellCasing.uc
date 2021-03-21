class EnforcerShellCasing extends Actor;

var RangeVector StartVelocityRange;

simulated function PostBeginPlay()
{
	Velocity.X = StartVelocityRange.X.Min + FRand() * (StartVelocityRange.X.Max - StartVelocityRange.X.Min);
	Velocity.Y = StartVelocityRange.Y.Min + FRand() * (StartVelocityRange.Y.Max - StartVelocityRange.Y.Min);
	Velocity.Z = StartVelocityRange.Z.Min + FRand() * (StartVelocityRange.Z.Max - StartVelocityRange.Z.Min);
	Velocity = Velocity >> Rotation;
}

simulated function Landed(vector HitLocation)
{
	Destroy();
}

defaultproperties
{
     StartVelocityRange=(X=(Min=-25.000000,Max=100.000000),Y=(Min=-250.000000,Max=250.000000),Z=(Min=200.000000,Max=300.000000))
     DrawType=DT_StaticMesh
     StaticMesh=StaticMesh'UT2341Weapons_SM.shell.ShellcasingX'
     Physics=PHYS_Falling
     LifeSpan=1.000000
     CollisionRadius=0.000000
     CollisionHeight=0.000000
}
