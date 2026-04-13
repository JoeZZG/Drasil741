{-# LANGUAGE PostfixOperators #-}
-- | General definitions for the Trajecto example.
-- Matches CAS741 SRS: GD1 (2D kinematics), GD2 (v×B cross product), GD3 (2D dynamics).
module Drasil.Trajecto.GenDefs (genDefs, kin2DGD, vCrossB2DGD, dyn2DGD) where

import Language.Drasil
import Theory.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import qualified Data.Drasil.Quantities.Physics as QP (time)
import Data.Drasil.Units.Physics (velU, accelU)

import Drasil.Trajecto.Unitals
  ( chargeToMass, elecFieldX, elecFieldY, magField
  , xPos, yPos, xVel, yVel
  , vCrossBVec )
import Drasil.Trajecto.Assumptions
  ( twoDMotion, bPerpPlane, eAxisAligned, prescribedFields )
import Drasil.Trajecto.DataDefs (qOvermDD)
import Drasil.Trajecto.TMods (lorentzForceTM, eqnMotionTM)

import Data.Drasil.Theories.Physics (velocityTM)

-- | All general definitions (3 GDs matching CAS741 SRS)
genDefs :: [GenDefn]
genDefs = [kin2DGD, vCrossB2DGD, dyn2DGD]

---------------------------------------------------------
-- GD1: Two-dimensional kinematics in Cartesian coordinates
-- dx/dt = vx(t),  dy/dt = vy(t)
---------------------------------------------------------

kin2DGD :: GenDefn
kin2DGD = gdNoRefs (deModel' kin2DRC) (Just velU) Nothing "kin2D" [kin2DNote]

kin2DRC :: RelationConcept
kin2DRC = makeRC "kin2DRC"
  (nounPhraseSP "Two-dimensional kinematics in Cartesian coordinates")
  EmptyS kin2DRel

kin2DRel :: ModelExpr
kin2DRel =
  (deriv (sy xPos) QP.time $= sy xVel)
  $&& (deriv (sy yPos) QP.time $= sy yVel)

kin2DNote :: Sentence
kin2DNote = foldlSent
  [ S "The planar motion assumption"
  , sParen (refS twoDMotion) +:+ S "allows the particle position"
  , S "to be represented by" +:+ ch xPos +:+ S "and" +:+ ch yPos
  , S "with velocity components" +:+ ch xVel +:+ S "and" +:+ ch yVel +:+. S "respectively"
  , S "Velocity is defined in" +:+. refS velocityTM
  ]

---------------------------------------------------------
-- GD2: Cross product v×B for out-of-plane magnetic field
-- v(t)×B = ⟨vy(t)·B, −vx(t)·B, 0⟩
---------------------------------------------------------

vCrossB2DGD :: GenDefn
vCrossB2DGD = gdNoRefs (equationalModel' vCrossB2DQD) (Nothing :: Maybe UnitDefn) Nothing "vCrossB2D" [vCrossB2DNote]

vCrossB2DQD :: ModelQDef
vCrossB2DQD = mkQuantDef' vCrossBVec
  (nounPhraseSP "Cross product v x B for out-of-plane magnetic field")
  vCrossB2DME

vCrossB2DME :: ModelExpr
vCrossB2DME = rowVec [sy yVel $* sy magField, neg (sy xVel $* sy magField), exactDbl 0]

vCrossB2DNote :: Sentence
vCrossB2DNote = foldlSent
  [ S "Under planar motion" +:+ sParen (refS twoDMotion)
  , S "and an out-of-plane magnetic field" +:+ sParen (refS bPerpPlane) `sC`
    S "the velocity has the form v(t) = (vx(t), vy(t), 0)"
  , S "and the magnetic field has the form B = (0, 0, B)."
  , S "The cross product then reduces to the stated component form."
  ]

---------------------------------------------------------
-- GD3: Two-dimensional equations of motion under E and B
-- dvx/dt = (q/m)·(Ex + vy·B),  dvy/dt = (q/m)·(Ey − vx·B)
---------------------------------------------------------

dyn2DGD :: GenDefn
dyn2DGD = gdNoRefs (deModel' dyn2DRC) (Just accelU) Nothing "dyn2D" [dyn2DNote]

dyn2DRC :: RelationConcept
dyn2DRC = makeRC "dyn2DRC"
  (nounPhraseSP "Two-dimensional equations of motion under E and B")
  EmptyS dyn2DRel

dyn2DRel :: ModelExpr
dyn2DRel =
  (deriv (sy xVel) QP.time $= sy chargeToMass $* (sy elecFieldX $+ (sy yVel $* sy magField)))
  $&& (deriv (sy yVel) QP.time $= sy chargeToMass $* (sy elecFieldY $- (sy xVel $* sy magField)))

dyn2DNote :: Sentence
dyn2DNote = foldlSent
  [ S "Assuming planar motion" +:+ sParen (refS twoDMotion) `sC`
    S "prescribed fields" +:+ sParen (refS prescribedFields) `sC`
    S "out-of-plane magnetic field" +:+ sParen (refS bPerpPlane) `sC`
    S "and axis-aligned electric field" +:+. sParen (refS eAxisAligned)
  , S "Here" +:+ ch chargeToMass +:+ S "= q/m is the charge-to-mass ratio defined in"
  , refS qOvermDD +:+. S "."
  , S "The equations are obtained from" +:+ refS lorentzForceTM +:+ S "and"
  , refS eqnMotionTM +:+ S "by applying" +:+. refS vCrossB2DGD
  ]
