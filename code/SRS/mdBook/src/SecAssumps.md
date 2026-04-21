# Assumptions {#Sec:Assumps}

This section simplifies the original problem and helps in developing the theoretical models by filling in the missing information for the physical system. The assumptions refine the scope by providing more detail.

<div id="piecewiseUniform"></div>

piecewiseUniform: The electric and magnetic fields are uniform within each field region and may change only at region boundaries. (RefBy: [DD:fieldsByRegion](./SecDDs.md#DD:fieldsByRegion).)

<div id="singleParticle"></div>

singleParticle: The particle is treated as a point mass and point charge. (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol), [TM:lorentzForce](./SecTMs.md#TM:lorentzForce), [TM:eqnMotion](./SecTMs.md#TM:eqnMotion), and [A:noInteractions](./SecAssumps.md#noInteractions).)

<div id="noInteractions"></div>

noInteractions: Collisions and particle-particle interactions (including space-charge effects) are neglected; this follows from [A:singleParticle](./SecAssumps.md#singleParticle). (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol).)

<div id="prescribedFields"></div>

prescribedFields: The electric and magnetic fields are user-specified and remain fixed during the simulation. (RefBy: [TM:lorentzForce](./SecTMs.md#TM:lorentzForce), [TM:eqnMotion](./SecTMs.md#TM:eqnMotion), [GD:dyn2D](./SecGDs.md#GD:dyn2D), [DD:eField](./SecDDs.md#DD:eField), [DD:fieldsByRegion](./SecDDs.md#DD:fieldsByRegion), and [DD:bField](./SecDDs.md#DD:bField).)

<div id="twoDMotion"></div>

twoDMotion: The particle motion is confined to the x-y plane. (RefBy: [GD:vCrossB2D](./SecGDs.md#GD:vCrossB2D), [IM:stateEvol](./SecIMs.md#IM:stateEvol), [GD:kin2D](./SecGDs.md#GD:kin2D), [GD:dyn2D](./SecGDs.md#GD:dyn2D), [LC:lcExtendTo3D](./SecLCs.md#lcExtendTo3D), [A:eAxisAligned](./SecAssumps.md#eAxisAligned), and [A:bPerpPlane](./SecAssumps.md#bPerpPlane).)

<div id="bPerpPlane"></div>

bPerpPlane: The magnetic field is perpendicular to the x-y plane, consistent with [A:twoDMotion](./SecAssumps.md#twoDMotion). (RefBy: [GD:vCrossB2D](./SecGDs.md#GD:vCrossB2D), [GD:dyn2D](./SecGDs.md#GD:dyn2D), and [DD:bField](./SecDDs.md#DD:bField).)

<div id="eAxisAligned"></div>

eAxisAligned: The electric field lies in the x-y plane and is aligned with a coordinate axis, consistent with [A:twoDMotion](./SecAssumps.md#twoDMotion). (RefBy: [GD:dyn2D](./SecGDs.md#GD:dyn2D) and [DD:eField](./SecDDs.md#DD:eField).)

<div id="rectRegions"></div>

rectRegions: All field regions are axis-aligned rectangles of identical width w and height h. The N regions are tiled adjacently (sharing edges with no gaps or overlaps) so that their union forms a single axis-aligned rectangle. (RefBy: [A:gridLayout](./SecAssumps.md#gridLayout) and [DD:regionRect](./SecDDs.md#DD:regionRect).)

<div id="gridLayout"></div>

gridLayout: The field regions are numbered 1 through N and arranged in a single row (left-to-right) or single column (bottom-to-top) within the grid rectangle. The arrangement direction is determined by the region grid specification, and region geometry is constrained by [A:rectRegions](./SecAssumps.md#rectRegions). (RefBy: [DD:regionRect](./SecDDs.md#DD:regionRect).)

<div id="lineDetector"></div>

lineDetector: The detector is modelled as a line segment that is either horizontal or vertical, located at the boundary of or within the region grid. (RefBy: [IM:detHit](./SecIMs.md#IM:detHit) and [DD:detectorLine](./SecDDs.md#DD:detectorLine).)

<div id="fullDetection"></div>

fullDetection: The detector line is sufficiently long to record the impact point for any trajectory within the scope of the simulation. (RefBy: [IM:detHit](./SecIMs.md#IM:detHit).)

<div id="lorentzOnly"></div>

lorentzOnly: The particle dynamics are governed only by the Lorentz force; all other forces are neglected. (RefBy: [IM:stateEvol](./SecIMs.md#IM:stateEvol), [TM:eqnMotion](./SecTMs.md#TM:eqnMotion), and [UC:ucLorentzForce](./SecUCs.md#ucLorentzForce).)
