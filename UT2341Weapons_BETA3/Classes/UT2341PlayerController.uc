//===========================================================================
// UT2341PlayerController.
//
// UT99 uses a different calculation for view flash than UT2004.
//===========================================================================
class UT2341PlayerController extends xPlayer;

var float DesiredFlashScale;
var Vector DesiredFlashFog;

function ClientFlash( float scale, vector fog )
{
	DesiredFlashScale = scale;
	DesiredFlashFog = 0.001 * fog;
}

function ViewFlash(float DeltaTime)
{
	local vector goalFog;
	local float goalScale, delta;
    local PhysicsVolume ViewVolume;

    if ( Pawn != None )
    {
		if ( bBehindView )
			ViewVolume = Level.GetPhysicsVolume(CalcViewLocation);
		else
			ViewVolume = Pawn.HeadVolume;
    }

	delta = FMin(0.1, DeltaTime);
	goalScale = 1 + DesiredFlashScale + ConstantGlowScale + ViewVolume.ViewFlash.X;
	goalFog = DesiredFlashFog + ConstantGlowFog + ViewVolume.ViewFog;
	DesiredFlashScale -= DesiredFlashScale * 2 * delta;
	DesiredFlashFog -= DesiredFlashFog * 2 * delta;
	FlashScale.X += (goalScale - FlashScale.X) * 10 * delta;
	FlashFog += (goalFog - FlashFog) * 10 * delta;

	if ( FlashScale.X > 0.981 )
		FlashScale.X = 1;
	FlashScale = FlashScale.X * vect(1,1,1);

	if ( FlashFog.X < 0.003 )
		FlashFog.X = 0;
	if ( FlashFog.Y < 0.003 )
		FlashFog.Y = 0;
	if ( FlashFog.Z < 0.003 )
		FlashFog.Z = 0;
}

defaultproperties
{

}