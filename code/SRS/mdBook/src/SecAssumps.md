# Assumptions {#Sec:Assumps}

This section simplifies the original problem and helps in developing the theoretical models by filling in the missing information for the physical system. The assumptions refine the scope by providing more detail.

<div id="piecewiseUniform"></div>

piecewiseUniform: The electric and magnetic fields are uniform within each field region and may change only at region boundaries. (RefBy: [DD:fieldsByRegion](./SecDDs.md#DD:fieldsByRegion).)

<div id="singleParticle"></div>

singleParticle: The particle is treated as a point mass and point charge. (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol), [TM:lorentzForce](./SecTMs.md#TM:lorentzForce), and [TM:eqnMotion](./SecTMs.md#TM:eqnMotion).)

<div id="noInteractions"></div>

noInteractions: Collisions and particle-particle interactions (including space-charge effects) are neglected. (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol).)

<div id="prescribedFields"></div>

prescribedFields: The electric and magnetic fields are user-specified and remain fixed during the simulation. (RefBy: [TM:lorentzForce](./SecTMs.md#TM:lorentzForce), [TM:eqnMotion](./SecTMs.md#TM:eqnMotion), [GD:dyn2D](./SecGDs.md#GD:dyn2D), [DD:eField](./SecDDs.md#DD:eField), and [DD:bField](./SecDDs.md#DD:bField).)

<div id="twoDMotion"></div>

twoDMotion: The particle motion is confined to the x-y plane. (RefBy: [GD:vCrossB2D](./SecGDs.md#GD:vCrossB2D), [IM:stateEvol](./SecIMs.md#IM:stateEvol), [GD:kin2D](./SecGDs.md#GD:kin2D), [GD:dyn2D](./SecGDs.md#GD:dyn2D), and [LC:lcExtendTo3D](./SecLCs.md#lcExtendTo3D).)

<div id="bPerpPlane"></div>

bPerpPlane: The magnetic field is perpendicular to the x-y plane. (RefBy: [GD:vCrossB2D](./SecGDs.md#GD:vCrossB2D), [GD:dyn2D](./SecGDs.md#GD:dyn2D), and [DD:bField](./SecDDs.md#DD:bField).)

<div id="eAxisAligned"></div>

eAxisAligned: The electric field lies in the x-y plane and is aligned with a coordinate axis. (RefBy: [GD:dyn2D](./SecGDs.md#GD:dyn2D) and [DD:eField](./SecDDs.md#DD:eField).)

<div id="rectRegions"></div>

rectRegions: Field-region boundaries are rectangular and parallel to the x and y axes. (RefBy: [DD:regionRect](./SecDDs.md#DD:regionRect).)

<div id="lineDetector"></div>

lineDetector: The detector is modeled as a line located within the field region. (RefBy: [IM:detHit](./SecIMs.md#IM:detHit) and [DD:detectorLine](./SecDDs.md#DD:detectorLine).)

<div id="fullDetection"></div>

fullDetection: The detector line is sufficiently long to record the impact point for any trajectory within the scope of the simulation. (RefBy: [IM:detHit](./SecIMs.md#IM:detHit).)

<div id="lorentzOnly"></div>

lorentzOnly: The particle dynamics are governed only by the Lorentz force; all other forces are neglected. (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol), [TM:eqnMotion](./SecTMs.md#TM:eqnMotion), and [UC:ucLorentzForce](./SecUCs.md#ucLorentzForce).)
