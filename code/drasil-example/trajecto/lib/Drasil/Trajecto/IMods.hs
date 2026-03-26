-- | Instance models for the Trajecto example.
-- Matches CAS741 SRS: IM1 (particle state evolution ODE), IM2 (detector hit).
module Drasil.Trajecto.IMods (iMods, stateEvolIM, detHitIM) where

import Language.Drasil
import Theory.Drasil (InstanceModel, imNoRefs, deModel', equationalModel, qwUC)
import qualified Language.Drasil.Sentence.Combinators as S

import qualified Data.Drasil.Quantities.Physics as QP (time)

import Drasil.Trajecto.Unitals
  ( parMass, parCharge
  , xPos, yPos, xVel, yVel
  , xPos0, yPos0, xVel0, yVel0
  , elecFieldX, elecFieldY, magField
  , chargeToMass, tFinal
  , tHit, xDet, xHit, yHit, yDetMin, yDetMax )
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
  $&& (deriv (sy xVel) QP.time $= sy chargeToMass $* (sy elecFieldX $+ sy yVel $* sy magField))
  $&& (deriv (sy yVel) QP.time $= sy chargeToMass $* (sy elecFieldY $- sy xVel $* sy magField))

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
    `sC` refS twoDMotion +:+. S "and" +:+ refS lorentzOnly
  ]

---------------------------------------------------------
-- IM2: First detector intersection (hit time and hit location)
-- t_hit = min { t ∈ [0, t_final] | x(t) = x_det ∧ y(t) ∈ [y_min^det, y_max^det] }
-- x_hit = x_det,  y_hit = y(t_hit)
---------------------------------------------------------

detHitIM :: InstanceModel
detHitIM = imNoRefs
  (equationalModel "detHitIM"
    (nounPhraseSP "First detector intersection (hit time and hit location)")
    detHitQD)
  [ qwUC xDet, qwUC yDetMin, qwUC yDetMax, qwUC tFinal, qwUC xPos, qwUC yPos ]
  (dqdWr tHit)
  []
  Nothing
  "detHit"
  [detHitNote]
  where
    detHitQD :: SimpleQDef
    detHitQD = mkQuantDef tHit detHitExpr

detHitExpr :: Expr
detHitExpr = sy tFinal

detHitNote :: Sentence
detHitNote = foldlSent
  [ S "The detector is modelled as a vertical line segment at"
  , ch xDet +:+ S "with y-bounds" +:+ ch yDetMin +:+ S "and"
  , ch yDetMax +:+. sParen (refS detectorLineDD)
  , S "The hit time is defined as:"
  , S "t_hit = min t in [0, t_final] such that x(t) = x_det and y(t) in [y_min(det), y_max(det)]."
  , S "The hit location is:"
  , S "x_hit = x_det, and y_hit = y(t_hit)," +:+. ch yHit
  , S "If no such t exists within [0, t_final], then no detector hit occurs."
  , S "The trajectory (x(t), y(t)) is provided by" +:+. refS stateEvolIM
  , S "Applicable assumptions:" +:+ refS fullDetection +:+. S "and" +:+ refS lineDetector
  ]
