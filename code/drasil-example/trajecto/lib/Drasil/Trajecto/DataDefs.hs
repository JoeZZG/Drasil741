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
import qualified Language.Drasil.Sentence.Combinators as S

import Drasil.Trajecto.Unitals
  ( chargeToMass, parCharge, parMass
  , initStateVec, xPos0, yPos0, xVel0, yVel0
  , elecFieldVec, elecFieldX, elecFieldY
  , magFieldVec, magField
  , fieldRegion, fieldRegionE, fieldRegionB
  , detLine, xDet, yDetMin, yDetMax )
import Drasil.Trajecto.Assumptions
  ( prescribedFields, eAxisAligned, bPerpPlane
  , rectRegions, piecewiseUniform, lineDetector )

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
    S "is used to simplify the equations of motion."
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
  , ch xVel0 :+: S "," +:+ ch yVel0 +:+. S "are the initial velocity components (m/s)"
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
  , refS eAxisAligned +:+. S "and the fields are user-specified per" +:+ refS prescribedFields
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
  , S "The in-plane components are zero by" +:+ refS bPerpPlane +:+. S "; fields are fixed by" +:+ refS prescribedFields
  ]

---------------------------------------------------------
-- DD5: Rectangular field region
-- R_i = [x_min^(i), x_max^(i)] × [y_min^(i), y_max^(i)]
---------------------------------------------------------

regionRectDD :: DataDefinition
regionRectDD = ddENoRefs regionRectQD Nothing "regionRect" [regionRectNote]

regionRectQD :: SimpleQDef
regionRectQD = mkQuantDef fieldRegion
  (rowVec [sy xPos0, sy xDet, sy yDetMin, sy yDetMax])

regionRectNote :: Sentence
regionRectNote = foldlSent
  [ S "Each field region is defined as the Cartesian product of two intervals:"
  , S "R_i = [x_min(i), x_max(i)] x [y_min(i), y_max(i)],"
  , S "where x_min(i), x_max(i), y_min(i), y_max(i) are the"
  , S "axis-aligned rectangular boundary coordinates (all in m), per" +:+. refS rectRegions
  ]

---------------------------------------------------------
-- DD6: Piecewise-constant fields by region
-- E(r) = E_i,  B(r) = B_i  ∀ r ∈ R_i
---------------------------------------------------------

fieldsByRegionDD :: DataDefinition
fieldsByRegionDD = ddENoRefs fieldsByRegionQD Nothing "fieldsByRegion" [fieldsByRegionNote]

fieldsByRegionQD :: SimpleQDef
fieldsByRegionQD = mkQuantDef fieldRegionE (sy elecFieldVec)

fieldsByRegionNote :: Sentence
fieldsByRegionNote = foldlSent
  [ S "The electric field" +:+ ch fieldRegionE
  , S "and the magnetic flux density" +:+ ch fieldRegionB
  , S "are constant within each region R_i:"
  , S "E(r) = E_i and B(r) = B_i for all r in R_i, per" +:+. refS piecewiseUniform
  , S "The fields may differ between regions."
  , ch fieldRegionE +:+ S "depends on" +:+ refS eFieldDD +:+. S "and"
  , ch fieldRegionB +:+ S "depends on" +:+. refS bFieldDD
  ]

---------------------------------------------------------
-- DD7: Detector line
-- L_det = { (x,y) | x = x_det, y ∈ [y_min^det, y_max^det] }
---------------------------------------------------------

detectorLineDD :: DataDefinition
detectorLineDD = ddENoRefs detectorLineQD Nothing "detectorLine" [detectorLineNote]

detectorLineQD :: SimpleQDef
detectorLineQD = mkQuantDef detLine
  (rowVec [sy xDet, sy yDetMin, sy yDetMax])

detectorLineNote :: Sentence
detectorLineNote = foldlSent
  [ ch detLine +:+. S "is the detector line segment"
  , S "It is defined as the set of points"
  , S "L_det = the set of (x,y) where x = x_det and y in [y_min(det), y_max(det)], per" +:+. refS lineDetector
  , S "where" +:+ ch xDet +:+ S "is the x-coordinate of the detector,"
  , S "and" +:+ ch yDetMin `sC` ch yDetMax
  , S "are the lower and upper y-bounds of the detector (all in m)."
  ]
