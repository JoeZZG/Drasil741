-- | Instance models for the Trajecto example.
-- Matches CAS741 SRS: IM1 (particle state evolution ODE), IM2 (detector hit).
module Drasil.Trajecto.IMods (iMods, stateEvolIM, detHitIM) where

import Language.Drasil
import Theory.Drasil (InstanceModel, RelationConcept, makeRC, imNoRefs, deModel', qwUC)

import qualified Data.Drasil.Quantities.Physics as QP (time)

import Drasil.Trajecto.Unitals
  ( parMass, parCharge
  , xPos, yPos, xVel, yVel
  , xPos0, yPos0, xVel0, yVel0
  , elecFieldX, elecFieldY, magField
  , chargeToMass, tFinal
  , tHit, xDet, xHit, yHit, yDet, yDetMin, yDetMax, xDetMin, xDetMax, detOrient )
import Drasil.Trajecto.DataDefs
  ( qOvermDD, initStateDD, fieldsByRegionDD, detectorLineDD )
import Drasil.Trajecto.GenDefs (kin2DGD, dyn2DGD)
import Drasil.Trajecto.Assumptions
  ( singleParticle, noInteractions, twoDMotion, lorentzOnly
  , fullDetection, lineDetector )

iMods :: [InstanceModel]
iMods = [stateEvolIM, detHitIM]

---------------------------------------------------------
-- IM1: Particle state evolution in the x-y plane
-- Full ODE system:
--   dx/dt = vx,  dy/dt = vy,
--   dvx/dt = κ·(Ex + vy·B),  dvy/dt = κ·(Ey − vx·B)
-- with initial condition s(0) = ⟨x₀, y₀, v₀x, v₀y⟩
---------------------------------------------------------

stateEvolIM :: InstanceModel
stateEvolIM = imNoRefs
  (deModel' stateEvolRC)
  [ qwUC parMass, qwUC parCharge
  , qwUC xPos0, qwUC yPos0, qwUC xVel0, qwUC yVel0
  , qwUC elecFieldX, qwUC elecFieldY, qwUC magField
  , qwUC tFinal ]
  (dqdWr xPos)
  []
  Nothing
  "stateEvol"
  [stateEvolNote]

stateEvolRC :: RelationConcept
stateEvolRC = makeRC "stateEvolRC"
  (nounPhraseSP "Particle state evolution in the x-y plane")
  EmptyS stateEvolRel

stateEvolRel :: ModelExpr
stateEvolRel =
  (deriv (sy xPos) QP.time $= sy xVel)
  $&& (deriv (sy yPos) QP.time $= sy yVel)
  $&& (deriv (sy xVel) QP.time $= sy chargeToMass $* (sy elecFieldX $+ (sy yVel $* sy magField)))
  $&& (deriv (sy yVel) QP.time $= sy chargeToMass $* (sy elecFieldY $- (sy xVel $* sy magField)))

stateEvolNote :: Sentence
stateEvolNote = foldlSent
  [ S "Bold symbols denote vectors; the state vector s(t) = (x(t), y(t), vx(t), vy(t))"
  , S "collects position and velocity components."
  , ch chargeToMass +:+ S "= q/m is the charge-to-mass ratio" +:+. sParen (refS qOvermDD)
  , S "The initial condition is s(0) = (x0, y0, v0x, v0y)" +:+. sParen (refS initStateDD)
  , S "The fields (Ex(t), Ey(t)) and B(t) are determined by which region R_i"
  , S "contains (x(t), y(t)) at time t" +:+. sParen (refS fieldsByRegionDD)
  , S "If (x(t), y(t)) lies outside all defined regions, the fields default to zero"
  , S "and the particle undergoes free (force-free) motion."
  , S "The model is derived by combining" +:+ refS kin2DGD +:+ S "and" +:+. refS dyn2DGD
  , S "Applicable assumptions:" +:+ refS singleParticle `sC` refS noInteractions
    `sC` refS twoDMotion +:+ S "and" +:+ refS lorentzOnly
  ]

---------------------------------------------------------
-- IM2: First detector intersection (hit time and hit location)
-- Defining condition: x(t_hit) = x_det  ∧  y_min^det ≤ y_hit ≤ y_max^det  ∧  t_hit ≤ t_final
-- t_hit is the minimum t in [0, t_final] satisfying the above; −1 if no such t exists.
-- y_hit = y(t_hit) is the y-coordinate of the impact point.
---------------------------------------------------------

detHitIM :: InstanceModel
detHitIM = imNoRefs
  (deModel' detHitRC)
  [ qwUC detOrient, qwUC xDet, qwUC yDet
  , qwUC yDetMin, qwUC yDetMax, qwUC xDetMin, qwUC xDetMax
  , qwUC tFinal, qwUC xPos, qwUC yPos ]
  (dqdWr tHit)
  []
  Nothing
  "detHit"
  [detHitNote]

detHitRC :: RelationConcept
detHitRC = makeRC "detHitRC"
  (nounPhraseSP "First detector intersection (hit time and hit location)")
  EmptyS detHitRel

-- The relation shows both detector orientations joined by logical OR.
detHitRel :: ModelExpr
detHitRel =
  (  (sy xPos $= sy xDet)
     $&& (sy yHit $>= sy yDetMin)
     $&& (sy yHit $<= sy yDetMax)
  )
  $||
  (  (sy yPos $= sy yDet)
     $&& (sy xHit $>= sy xDetMin)
     $&& (sy xHit $<= sy xDetMax)
  )

detHitNote :: Sentence
detHitNote = foldlSent
  [ S "The detector is modelled as a line segment that may be vertical or horizontal,"
  , S "selected by the orientation flag" +:+ ch detOrient +:+ sParen (refS detectorLineDD) :+: S "."
  , S "Vertical case (D = 0): the detector is at x =" +:+ ch xDet
  , S "with y-bounds [" <> ch yDetMin <> S "," +:+ ch yDetMax <> S "]."
  , S "The hit condition is x(t) = x_det and y(t) in [y_min, y_max]."
  , S "Horizontal case (D = 1): the detector is at y =" +:+ ch yDet
  , S "with x-bounds [" <> ch xDetMin <> S "," +:+ ch xDetMax <> S "]."
  , S "The hit condition is y(t) = y_det and x(t) in [x_min, x_max]."
  , S "In both cases," +:+ ch tHit
  , S "is the minimum t in [0," +:+ ch tFinal <> S "] satisfying the condition."
  , S "If no such t exists,"
  , ch tHit +:+ S "is set to -1 as a sentinel value indicating no hit,"
  , S "and the hit coordinates are undefined."
  , S "The trajectory (x(t), y(t)) is provided by" +:+. refS stateEvolIM
  , S "Applicable assumptions:" +:+ refS fullDetection +:+ S "and" +:+ refS lineDetector
  ]
