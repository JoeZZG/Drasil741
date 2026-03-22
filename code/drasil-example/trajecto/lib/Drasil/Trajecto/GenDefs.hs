{-# LANGUAGE PostfixOperators #-}
-- | General definitions for the Trajecto example.
module Drasil.Trajecto.GenDefs (genDefs, xAccelGD, yAccelGD) where

import Language.Drasil
import Theory.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Units.Physics (accelU)

import Drasil.Trajecto.Unitals (chargeToMass, elecFieldX, elecFieldY,
  magField, xVel, yVel, xAccel, yAccel)
import Drasil.Trajecto.Assumptions (twoDMotion, bPerpPlane, eAxisAligned,
  prescribedFields)
import Drasil.Trajecto.DataDefs (qOvermDD)

-- | All general definitions
genDefs :: [GenDefn]
genDefs = [xAccelGD, yAccelGD]

---------------------------------------------------------
-- GD1: x-component of 2D equations of motion
-- ax = κ*(Ex + vy*B)
---------------------------------------------------------

xAccelGD :: GenDefn
xAccelGD = gdNoRefs (equationalModel' xAccelGDQD) (getUnit xAccel)
  Nothing "xAccelEM" [xAccelNote]

xAccelGDQD :: ModelQDef
xAccelGDQD = mkQuantDef' xAccel
  (nounPhraseSP "x-acceleration under electromagnetic force")
  xAccelME

xAccelME :: ModelExpr
xAccelME = sy chargeToMass $* (sy elecFieldX $+ sy yVel $* sy magField)

xAccelNote :: Sentence
xAccelNote = foldlSent
  [ S "Derived from the equation of motion by applying" +:+
    S "planar motion", sParen (refS twoDMotion) `sC`
    S "out-of-plane B field", sParen (refS bPerpPlane) `sC`
    S "axis-aligned E field", sParen (refS eAxisAligned) `sC`
    S "and fixed fields", (sParen (refS prescribedFields) !.)
  , S "Here" +:+ ch chargeToMass +:+ S "= q/m is defined in" +:+ refS qOvermDD ]

---------------------------------------------------------
-- GD2: y-component of 2D equations of motion
-- ay = κ*(Ey - vx*B)
---------------------------------------------------------

yAccelGD :: GenDefn
yAccelGD = gdNoRefs (equationalModel' yAccelGDQD) (getUnit yAccel)
  Nothing "yAccelEM" [yAccelNote]

yAccelGDQD :: ModelQDef
yAccelGDQD = mkQuantDef' yAccel
  (nounPhraseSP "y-acceleration under electromagnetic force")
  yAccelME

yAccelME :: ModelExpr
yAccelME = sy chargeToMass $* (sy elecFieldY $- sy xVel $* sy magField)

yAccelNote :: Sentence
yAccelNote = foldlSent
  [ S "Derived from the equation of motion by applying the same" +:+
    S "2D assumptions as for" +:+ refS xAccelGD ]
