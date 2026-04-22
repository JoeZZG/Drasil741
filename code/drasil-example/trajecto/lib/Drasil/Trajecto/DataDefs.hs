-- | Data definitions for the Trajecto example.
-- Matches CAS741 SRS: DD1 (κ), DD2 (s₀), DD3 (E), DD4 (B),
--   DD5 (R_i), DD6 (E_i/B_i), DD7 (L_det).
module Drasil.Trajecto.DataDefs
  ( dataDefs
  , qOvermDD, initStateDD, eFieldDD, bFieldDD
  , regionRectDD, fieldsByRegionDD, detectorLineDD
  ) where

import Language.Drasil
import Theory.Drasil (DataDefinition, ddENoRefs)

import Drasil.Trajecto.Unitals
  ( chargeToMass, parCharge, parMass
  , initStateVec, xPos0, yPos0, xVel0, yVel0
  , elecFieldVec, elecFieldX, elecFieldY
  , magFieldVec, magField
  , fieldRegion, fieldRegionE, fieldRegionB
  , detOrient, detPos, detStart, detLength
  , nRegions, regionWidth, regionHeight, xGrid, yGrid )
import Drasil.Trajecto.Assumptions
  ( prescribedFields, eAxisAligned, bPerpPlane
  , rectRegions, gridLayout, piecewiseUniform, lineDetector )

dataDefs :: [DataDefinition]
dataDefs =
  [ qOvermDD, initStateDD, eFieldDD, bFieldDD
  , regionRectDD, fieldsByRegionDD, detectorLineDD ]

---------------------------------------------------------
-- DD1: Charge-to-mass ratio  κ = q / m
---------------------------------------------------------

qOvermDD :: DataDefinition
qOvermDD = ddENoRefs qOvermQD Nothing "qOverm" [qOvermNote]

qOvermQD :: SimpleQDef
qOvermQD = mkQuantDef chargeToMass (sy parCharge $/ sy parMass)

qOvermNote :: Sentence
qOvermNote = foldlSent
  [ ch parCharge +:+ S "is the particle charge and"
  , ch parMass +:+. S "is the particle mass"
  , S "The ratio" +:+ ch chargeToMass +:+
    S "is used to simplify the equations of motion"
  ]

---------------------------------------------------------
-- DD2: Initial state vector  s₀ = ⟨x₀, y₀, v₀x, v₀y⟩
---------------------------------------------------------

initStateDD :: DataDefinition
initStateDD = ddENoRefs initStateQD Nothing "initState" [initStateNote]

initStateQD :: SimpleQDef
initStateQD = mkQuantDef initStateVec
  (rowVec [sy xPos0, sy yPos0, sy xVel0, sy yVel0])

initStateNote :: Sentence
initStateNote = foldlSent
  [ ch xPos0 :+: S "," +:+ ch yPos0 +:+ S "are the initial position components (m) and"
  , ch xVel0 :+: S "," +:+ ch yVel0 +:+ S "are the initial velocity components (m/s)"
  ]

---------------------------------------------------------
-- DD3: Electric field vector  E = ⟨Ex, Ey, 0⟩
---------------------------------------------------------

eFieldDD :: DataDefinition
eFieldDD = ddENoRefs eFieldQD Nothing "eField" [eFieldNote]

eFieldQD :: SimpleQDef
eFieldQD = mkQuantDef elecFieldVec
  (rowVec [sy elecFieldX, sy elecFieldY, exactDbl 0])

eFieldNote :: Sentence
eFieldNote = foldlSent
  [ ch elecFieldVec +:+. S "is the electric field vector"
  , ch elecFieldX +:+ S "and" +:+ ch elecFieldY +:+
    S "are the in-plane components (N/C)."
  , S "The out-of-plane component is zero by"
  , refS eAxisAligned :+: S "," +:+ S "and the fields are user-specified per" +:+ refS prescribedFields
  ]

---------------------------------------------------------
-- DD4: Magnetic flux density vector  B = ⟨0, 0, B⟩
---------------------------------------------------------

bFieldDD :: DataDefinition
bFieldDD = ddENoRefs bFieldQD Nothing "bField" [bFieldNote]

bFieldQD :: SimpleQDef
bFieldQD = mkQuantDef magFieldVec
  (rowVec [exactDbl 0, exactDbl 0, sy magField])

bFieldNote :: Sentence
bFieldNote = foldlSent
  [ ch magFieldVec +:+. S "is the magnetic flux density vector"
  , ch magField +:+. S "is the out-of-plane (z) component (T)"
  , S "The in-plane components are zero by" +:+ refS bPerpPlane :+: S ";" +:+ S "fields are fixed by" +:+ refS prescribedFields
  ]

---------------------------------------------------------
-- DD5: Rectangular field region
-- R_i = [x_grid + (i-1)*w, x_grid + i*w] × [y_grid, y_grid + h]  (row layout)
---------------------------------------------------------

regionRectDD :: DataDefinition
regionRectDD = ddENoRefs regionRectQD Nothing "regionRect" [regionRectNote]

regionRectQD :: SimpleQDef
regionRectQD = mkQuantDef fieldRegion
  (rowVec [sy xGrid, sy yGrid, sy regionWidth, sy regionHeight])

regionRectNote :: Sentence
regionRectNote = foldlSent
  [ S "Each field region R_i (for i = 1 .." +:+ ch nRegions
  , S ") is an axis-aligned rectangle of width" +:+ ch regionWidth
  , S "and height" +:+. ch regionHeight
  , S "The equation above lists the grid parameters that define each region."
  , S "For a row layout (regions tiled left-to-right):"
  , S "R_i = [x_grid + (i-1)*w, x_grid + i*w] x [y_grid, y_grid + h]."
  , S "For a column layout (regions tiled bottom-to-top):"
  , S "R_i = [x_grid, x_grid + w] x [y_grid + (i-1)*h, y_grid + i*h]."
  , S "The grid origin" +:+ sParen (ch xGrid `sC` ch yGrid)
  , S "anchors region 1, per" +:+ refS rectRegions +:+ S "and" +:+ refS gridLayout
  ]

---------------------------------------------------------
-- DD6: Piecewise-constant fields by region
-- E_i = (Ex_i, Ey_i, 0),  B_i = (0, 0, B_i)  per region
---------------------------------------------------------

fieldsByRegionDD :: DataDefinition
fieldsByRegionDD = ddENoRefs fieldsByRegionQD Nothing "fieldsByRegion" [fieldsByRegionNote]

fieldsByRegionQD :: SimpleQDef
fieldsByRegionQD = mkQuantDef fieldRegionE
  (rowVec [sy elecFieldX, sy elecFieldY, sy magField])

fieldsByRegionNote :: Sentence
fieldsByRegionNote = foldlSent
  [ S "Each region R_i has its own independently specified electric field"
  , ch fieldRegionE +:+ S "= (Ex_i, Ey_i, 0) and magnetic flux density"
  , ch fieldRegionB +:+. S "= (0, 0, B_i)"
  , S "The fields are constant within each region per" +:+. refS piecewiseUniform
  , S "The active fields at time t are determined by which region R_i"
  , sParen (refS regionRectDD) +:+ S "contains the particle position (x(t), y(t))."
  , S "If the particle is outside all defined regions,"
  , S "the fields default to zero and the particle undergoes free (force-free) motion."
  , S "The per-region values (Ex_i, Ey_i, B_i) are user-specified inputs per" +:+ refS prescribedFields
  ]

---------------------------------------------------------
-- DD7: Detector line (vertical or horizontal)
-- Parameterised by: orientation flag, perpendicular-axis position,
-- start of segment on parallel axis, and segment length.
-- Vertical  (d_orient=0): at x=det_pos, y ∈ [det_start, det_start+det_length]
-- Horizontal(d_orient=1): at y=det_pos, x ∈ [det_start, det_start+det_length]
---------------------------------------------------------

detectorLineDD :: DataDefinition
detectorLineDD = ddENoRefs detectorLineQD Nothing "detectorLine" [detectorLineNote]

detectorLineQD :: SimpleQDef
detectorLineQD = mkQuantDef detOrient (sy detOrient)

detectorLineNote :: Sentence
detectorLineNote = foldlSent
  [ ch detOrient +:+. S "selects the detector orientation"
  , S "When" +:+ ch detOrient +:+ S "= 0 (vertical), the detector is the vertical line"
  , S "x =" +:+ ch detPos +:+ S "spanning y from" +:+ ch detStart
  , S "to" +:+ ch detStart +:+ S "+" +:+ ch detLength :+: S "."
  , S "When" +:+ ch detOrient +:+ S "= 1 (horizontal), the detector is the horizontal line"
  , S "y =" +:+ ch detPos +:+ S "spanning x from" +:+ ch detStart
  , S "to" +:+ ch detStart +:+ S "+" +:+ ch detLength :+: S "."
  , S "The detector orientation and bounds are user-specified, per" +:+ refS lineDetector
  ]
