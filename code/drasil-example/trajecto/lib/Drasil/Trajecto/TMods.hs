{-# LANGUAGE PostfixOperators #-}
-- | Theoretical models for the Trajecto example.
module Drasil.Trajecto.TMods
  ( tMods, lorentzForceTM, eqnMotionTM ) where

import qualified Data.List.NonEmpty as NE

import Language.Drasil
import Theory.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Theories.Physics (accelerationTM, velocityTM)
import Data.Drasil.Quantities.Physics (force)

import Drasil.Trajecto.Unitals (parMass, parCharge, xVel, yVel,
  elecFieldX, elecFieldY, magField, xAccel, yAccel)
import Drasil.Trajecto.Assumptions (singleParticle, prescribedFields, lorentzOnly)

-- | All theoretical models (order matches the SRS)
tMods :: [TheoryModel]
tMods = [velocityTM, accelerationTM, lorentzForceTM, eqnMotionTM]

---------------------------------------------------------
-- TM4: Lorentz force law (x-component form)
-- Fx = q*(Ex + vy*B)
---------------------------------------------------------

lorentzForceTM :: TheoryModel
lorentzForceTM = tmNoRefs (equationalConstraints' lorentzForceCS)
  "lorentzForce" [lorentzForceNote]

lorentzForceRels :: [ModelExpr]
lorentzForceRels =
  [ -- Fx = q*(Ex + vy*B)  (representative component form)
    sy force $= sy parCharge $* (sy elecFieldX $+ (sy yVel $* sy magField))
  ]

lorentzForceCS :: ConstraintSet ModelExpr
lorentzForceCS = mkConstraintSet
  (dccWDS "lorentzForceCS"
    (nounPhraseSP "Lorentz force law")
    lorentzForceNote)
  (NE.fromList lorentzForceRels)

lorentzForceNote :: Sentence
lorentzForceNote = foldlSent
  [ S "The electromagnetic force on a charged particle is the sum of" +:+
    S "the electric force" +:+ sParen (S "q*E") +:+
    S "and the magnetic force" +:+ (sParen (S "q*(v x B)") !.)
  , S "For 2D planar motion with an out-of-plane magnetic field B," +:+
    S "the x-component of the Lorentz force is" +:+
    S "Fx = q*(Ex + vy*B)."
  , S "Assumes" +:+ refS singleParticle `sC` refS prescribedFields ]

---------------------------------------------------------
-- TM5: Equation of motion under electromagnetic fields
-- ax = (q/m)*(Ex + vy*B)
-- ay = (q/m)*(Ey - vx*B)
---------------------------------------------------------

eqnMotionTM :: TheoryModel
eqnMotionTM = tmNoRefs (equationalConstraints' eqnMotionCS)
  "eqnMotion" [eqnMotionNote]

eqnMotionRels :: [ModelExpr]
eqnMotionRels =
  [ -- ax = (q/m)*(Ex + vy*B)
    sy xAccel $= (sy parCharge $/ sy parMass) $* (sy elecFieldX $+ (sy yVel $* sy magField))
  , -- ay = (q/m)*(Ey - vx*B)
    sy yAccel $= (sy parCharge $/ sy parMass) $* (sy elecFieldY $- (sy xVel $* sy magField))
  ]

eqnMotionCS :: ConstraintSet ModelExpr
eqnMotionCS = mkConstraintSet
  (dccWDS "eqnMotionCS"
    (nounPhraseSP "equation of motion under electromagnetic fields")
    eqnMotionNote)
  (NE.fromList eqnMotionRels)

eqnMotionNote :: Sentence
eqnMotionNote = foldlSent
  [ S "Combining Newton's second law with the Lorentz force law" `sC`
    sParen (refS lorentzForceTM) `sC`
    S "the equations of motion for each velocity component are obtained."
  , S "The quantity q/m is the charge-to-mass ratio."
  , S "Assumes" +:+ refS singleParticle `sC` refS prescribedFields
    `sC` refS lorentzOnly ]

