/*************************************************************
*
*
*
*************************************************************/

class UT2341ShockRifleCombo extends Actor;

//#exec OBJ LOAD FILE=XEffectMat.utx

var ShockComboFlare Flare;
var Rotator NetRot;
replication
{
	//Rotation isn't replicated under these conditions
	reliable if (Role == ROLE_Authority)
		NetRot;
}
simulated function PreBeginPlay()
{
	Super.PreBeginPlay();
	
	if (Role == ROLE_Authority)
		NetRot = Rotation;
}

simulated event PostNetBeginPlay()
{
    Super.PostNetBeginPlay();

    if (Level.NetMode != NM_DedicatedServer)
        Spawn(class'FX_ShockRifleComboVortex',self,,,NetRot);
}

auto simulated state Combo
{
Begin:
    Sleep(0.9);
    LightType = LT_None;
}

defaultproperties
{
     LightType=LT_Steady
     LightEffect=LE_QuadraticNonIncidence
     LightHue=165
     LightSaturation=100
     LightBrightness=255.000000
     LightRadius=10.000000
     DrawType=DT_None
     bDynamicLight=True
     bNetTemporary=True
     RemoteRole=ROLE_SimulatedProxy
     LifeSpan=2.000000
     bCollideActors=True
     ForceType=FT_Constant
     ForceRadius=300.000000
     ForceScale=-500.000000
}
