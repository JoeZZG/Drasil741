-- | Instance models for the Trajecto example.
module Drasil.Trajecto.IMods (iMods, accelXIM, accelYIM) where

import Language.Drasil
import Theory.Drasil (InstanceModel, imNoRefs, equationalModel, qwUC)
import qualified Language.Drasil.Sentence.Combinators as S

import Drasil.Trajecto.Unitals
  ( xAccel, yAccel, chargeToMass
  , elecFieldX, elecFieldY, magField
  , xVel, yVel )
import Drasil.Trajecto.Expressions (xAccelExpr, yAccelExpr)

iMods :: [InstanceModel]
iMods = [accelXIM, accelYIM]

---------------------------------------------------------
-- IM1: x-component of acceleration
-- ax = κ * (Ex + vy * B)
---------------------------------------------------------

accelXIM :: InstanceModel
accelXIM = imNoRefs
  (equationalModel "accelXIM"
    (nounPhraseSP "x-component of acceleration")
    accelXQD)
  [qwUC chargeToMass, qwUC elecFieldX, qwUC yVel, qwUC magField]
  (dqdWr xAccel)
  []
  Nothing
  "accelX"
  [accelXNote]
  where
    accelXQD :: SimpleQDef
    accelXQD = mkQuantDef xAccel xAccelExpr

accelXNote :: Sentence
accelXNote = foldlSent
  [ S "This gives the acceleration of the particle in the x-direction"
  , S "due to the Lorentz force (see GD:xAccelEM)"
  ]

---------------------------------------------------------
-- IM2: y-component of acceleration
-- ay = κ * (Ey - vx * B)
---------------------------------------------------------

accelYIM :: InstanceModel
accelYIM = imNoRefs
  (equationalModel "accelYIM"
    (nounPhraseSP "y-component of acceleration")
    accelYQD)
  [qwUC chargeToMass, qwUC elecFieldY, qwUC xVel, qwUC magField]
  (dqdWr yAccel)
  []
  Nothing
  "accelY"
  [accelYNote]
  where
    accelYQD :: SimpleQDef
    accelYQD = mkQuantDef yAccel yAccelExpr

accelYNote :: Sentence
accelYNote = foldlSent
  [ S "This gives the acceleration of the particle in the y-direction"
  , S "due to the Lorentz force (see GD:yAccelEM)"
  ]
