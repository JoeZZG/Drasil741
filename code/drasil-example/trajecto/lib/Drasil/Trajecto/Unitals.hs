{-# LANGUAGE PostfixOperators #-}
-- | Physical quantities (symbols and units) for the Trajecto example.
module Drasil.Trajecto.Unitals where

import Language.Drasil
import qualified Language.Drasil.Development as D
import Language.Drasil.Display (Symbol(..))
import Language.Drasil.ShortHands
import Language.Drasil.Chunk.Concept.NamedCombinators
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Constraints (gtZeroConstr)
import Data.Drasil.Concepts.Documentation (assumption, goalStmt, physSyst,
  refBy, refName, requirement, srs, typUnc)
import Data.Drasil.Concepts.Theory (dataDefn, genDefn, inModel, thModel)
import qualified Data.Drasil.Quantities.Physics as QP (velocity, acceleration,
  force, time, position)
import Data.Drasil.SI_Units (metre, kilogram, second, newton, coulomb, tesla)
import Data.Drasil.Units.Physics (velU, accelU)

import Language.Drasil (newUnit, (/:))

---------------------------------------------------------
-- Derived units specific to EM quantities
---------------------------------------------------------

-- | Electric field strength unit: N/C
elecFieldU :: UnitDefn
elecFieldU = newUnit "electric field strength" $ newton /: coulomb

-- | Charge-to-mass ratio unit: C/kg
chgPerMassU :: UnitDefn
chgPerMassU = newUnit "charge-to-mass ratio" $ coulomb /: kilogram

---------------------------------------------------------
-- Exported symbol list
---------------------------------------------------------

symbols :: [DefinedQuantityDict]
symbols = map dqdWr
  [ parMass, parCharge
  , xPos, yPos, xPos0, yPos0
  , xVel, yVel, xVel0, yVel0
  , xAccel, yAccel
  , elecFieldX, elecFieldY, magField
  , chargeToMass
  , tFinal, tHit, xDet, xHit, yHit
  , mMin, mMax, qMax, vMax0, eMax, bMax, tMax ]
  ++ map dqdWr [QP.velocity, QP.acceleration, QP.force, QP.time, QP.position]
  ++ map dqdWr constants

acronyms :: [CI]
acronyms = [assumption, dataDefn, genDefn, goalStmt,
  inModel, physSyst, requirement, refBy, refName, srs, thModel, typUnc]

-- | Input variables
inputs :: [DefinedQuantityDict]
inputs = map dqdWr
  [ parMass, parCharge
  , xPos0, yPos0, xVel0, yVel0
  , elecFieldX, elecFieldY, magField
  , tFinal ]

-- | Output variables
outputs :: [DefinedQuantityDict]
outputs = map dqdWr [xPos, yPos, xVel, yVel, tHit, xHit, yHit]

-- | Named constants
constants :: [ConstQDef]
constants = specParamValues

---------------------------------------------------------
-- Particle mass and charge
---------------------------------------------------------

parMass :: UnitalChunk
parMass = uc' "m" (nounPhraseSP "particle mass")
  (S "mass of the charged particle")
  lM Real kilogram

parCharge :: UnitalChunk
parCharge = uc' "q" (nounPhraseSP "particle charge")
  (S "electric charge of the particle")
  lQ Real coulomb

---------------------------------------------------------
-- Position components
---------------------------------------------------------

xPos, yPos :: UnitalChunk

xPos = uc' "x" (nounPhraseSP "x-position of the particle")
  (S "x-component of the particle position")
  lX Real metre

yPos = uc' "y" (nounPhraseSP "y-position of the particle")
  (S "y-component of the particle position")
  lY Real metre

xPos0, yPos0 :: UnitalChunk

xPos0 = uc' "x_0" (nounPhraseSP "initial x-position")
  (S "initial x-component of the particle position")
  (sub lX label0) Real metre

yPos0 = uc' "y_0" (nounPhraseSP "initial y-position")
  (S "initial y-component of the particle position")
  (sub lY label0) Real metre

---------------------------------------------------------
-- Velocity components
---------------------------------------------------------

xVel, yVel :: UnitalChunk

xVel = uc' "vx" (nounPhraseSP "x-velocity of the particle")
  (S "x-component of the particle velocity")
  (sub lV labelx) Real velU

yVel = uc' "vy" (nounPhraseSP "y-velocity of the particle")
  (S "y-component of the particle velocity")
  (sub lV labely) Real velU

xVel0, yVel0 :: UnitalChunk

xVel0 = uc' "vx_0" (nounPhraseSP "initial x-velocity")
  (S "initial x-component of the particle velocity")
  (sub lV (Concat [labelx, label0])) Real velU

yVel0 = uc' "vy_0" (nounPhraseSP "initial y-velocity")
  (S "initial y-component of the particle velocity")
  (sub lV (Concat [labely, label0])) Real velU

---------------------------------------------------------
-- Acceleration components
---------------------------------------------------------

xAccel, yAccel :: UnitalChunk

xAccel = uc' "ax" (nounPhraseSP "x-acceleration of the particle")
  (S "x-component of the particle acceleration")
  (sub lA labelx) Real accelU

yAccel = uc' "ay" (nounPhraseSP "y-acceleration of the particle")
  (S "y-component of the particle acceleration")
  (sub lA labely) Real accelU

---------------------------------------------------------
-- Electromagnetic field quantities
---------------------------------------------------------

elecFieldX :: UnitalChunk
elecFieldX = uc' "Ex" (nounPhraseSP "x-component of the electric field")
  (S "x-component of the electric field vector in the particle's current region")
  (sub cE labelx) Real elecFieldU

elecFieldY :: UnitalChunk
elecFieldY = uc' "Ey" (nounPhraseSP "y-component of the electric field")
  (S "y-component of the electric field vector in the particle's current region")
  (sub cE labely) Real elecFieldU

magField :: UnitalChunk
magField = uc' "B" (nounPhraseSP "out-of-plane magnetic flux density")
  (S "the z-component of the magnetic flux density, perpendicular to the x-y plane")
  cB Real tesla

---------------------------------------------------------
-- Charge-to-mass ratio
---------------------------------------------------------

chargeToMass :: UnitalChunk
chargeToMass = uc' "kappa" (nounPhraseSP "charge-to-mass ratio")
  (S "ratio of the particle's electric charge to its mass")
  lKappa Real chgPerMassU

---------------------------------------------------------
-- Time and detector quantities
---------------------------------------------------------

tFinal :: UnitalChunk
tFinal = uc' "t_final" (nounPhraseSP "final simulation time")
  (S "the end time of the simulation interval")
  (sub lT (label "final")) Real second

tHit :: UnitalChunk
tHit = uc' "t_hit" (nounPhraseSP "time of detector hit")
  (S "the time at which the particle first reaches the detector line")
  (sub lT (label "hit")) Real second

xDet :: UnitalChunk
xDet = uc' "x_det" (nounPhraseSP "detector line x-position")
  (S "the x-coordinate of the detector line")
  (sub lX (label "det")) Real metre

xHit :: UnitalChunk
xHit = uc' "x_hit" (nounPhraseSP "x-coordinate of impact point")
  (S "the x-coordinate of the particle impact point on the detector")
  (sub lX (label "hit")) Real metre

yHit :: UnitalChunk
yHit = uc' "y_hit" (nounPhraseSP "y-coordinate of impact point")
  (S "the y-coordinate of the particle impact point on the detector")
  (sub lY (label "hit")) Real metre

---------------------------------------------------------
-- Symbol helpers
---------------------------------------------------------

label0, labelx, labely :: Symbol
label0 = Integ 0
labelx = label "x"
labely = label "y"

---------------------------------------------------------
-- Specification parameters (software constraint bounds)
---------------------------------------------------------

mMin, mMax, qMax, vMax0, eMax, bMax, tMax :: UnitalChunk

mMin = uc' "m_min" (nounPhraseSP "minimum particle mass")
  (S "lower bound on particle mass")
  (sub lM (label "min")) Real kilogram

mMax = uc' "m_max" (nounPhraseSP "maximum particle mass")
  (S "upper bound on particle mass")
  (sub lM (label "max")) Real kilogram

qMax = uc' "q_max" (nounPhraseSP "maximum charge magnitude")
  (S "upper bound on the absolute value of the particle charge")
  (sub lQ (label "max")) Real coulomb

vMax0 = uc' "v_max" (nounPhraseSP "maximum initial speed")
  (S "upper bound on the initial particle speed")
  (sub lV (label "max")) Real velU

eMax = uc' "E_max" (nounPhraseSP "maximum electric field magnitude")
  (S "upper bound on the electric field magnitude in any region")
  (sub cE (label "max")) Real elecFieldU

bMax = uc' "B_max" (nounPhraseSP "maximum magnetic flux density")
  (S "upper bound on the magnetic flux density magnitude in any region")
  (sub cB (label "max")) Real tesla

tMax = uc' "t_max" (nounPhraseSP "maximum simulation time")
  (S "upper bound on the simulation duration")
  (sub lT (label "max")) Real second

-- | Specification parameter numerical values
specParamValues :: [ConstQDef]
specParamValues =
  [ mkQuantDef mMin  (dbl 1.0e-31)   -- 1e-31 kg
  , mkQuantDef mMax  (dbl 1.0e-25)   -- 1e-25 kg
  , mkQuantDef qMax  (dbl 1.0e-15)   -- 1e-15 C
  , mkQuantDef vMax0 (dbl 1.0e7)     -- 1e7 m/s (< 0.1c)
  , mkQuantDef eMax  (dbl 1.0e6)     -- 1e6 N/C
  , mkQuantDef bMax  (dbl 10.0)      -- 10 T
  , mkQuantDef tMax  (dbl 1.0e-4)    -- 1e-4 s
  ]

---------------------------------------------------------
-- Constrained input quantities
---------------------------------------------------------

massCon :: ConstrConcept
massCon = constrained' parMass
  [gtZeroConstr,
   sfwrRange $ Bounded (Inc, sy mMin) (Inc, sy mMax)]
  (dbl 9.11e-31)

chargeCon :: ConstrConcept
chargeCon = constrained' parCharge
  [physRange $ UpFrom (Exc, exactDbl 0),
   sfwrRange $ UpTo (Inc, sy qMax)]
  (dbl 1.60e-19)

xPos0Con :: ConstrConcept
xPos0Con = constrained' xPos0
  []
  (exactDbl 0)

yPos0Con :: ConstrConcept
yPos0Con = constrained' yPos0
  []
  (exactDbl 0)

xVel0Con :: ConstrConcept
xVel0Con = constrained' xVel0
  [sfwrRange $ Bounded (Inc, neg (sy vMax0)) (Inc, sy vMax0)]
  (dbl 1.0e6)

yVel0Con :: ConstrConcept
yVel0Con = constrained' yVel0
  [sfwrRange $ Bounded (Inc, neg (sy vMax0)) (Inc, sy vMax0)]
  (exactDbl 0)

elecFieldXCon :: ConstrConcept
elecFieldXCon = constrained' elecFieldX
  [sfwrRange $ Bounded (Inc, neg (sy eMax)) (Inc, sy eMax)]
  (exactDbl 0)

elecFieldYCon :: ConstrConcept
elecFieldYCon = constrained' elecFieldY
  [sfwrRange $ Bounded (Inc, neg (sy eMax)) (Inc, sy eMax)]
  (dbl 1.0e3)

magFieldCon :: ConstrConcept
magFieldCon = constrained' magField
  [sfwrRange $ Bounded (Inc, neg (sy bMax)) (Inc, sy bMax)]
  (dbl 1.0e-2)

tFinalCon :: ConstrConcept
tFinalCon = constrained' tFinal
  [gtZeroConstr,
   sfwrRange $ UpTo (Inc, sy tMax)]
  (dbl 1.0e-6)

-- | Input constraints with uncertainty
inConstraints :: [UncertQ]
inConstraints =
  [ uq massCon     (uncty 0.10 Nothing)
  , uq chargeCon   (uncty 0.10 Nothing)
  , uq xPos0Con    exact
  , uq yPos0Con    exact
  , uq xVel0Con    (uncty 0.10 Nothing)
  , uq yVel0Con    (uncty 0.10 Nothing)
  , uq elecFieldXCon (uncty 0.10 Nothing)
  , uq elecFieldYCon (uncty 0.10 Nothing)
  , uq magFieldCon   (uncty 0.10 Nothing)
  , uq tFinalCon   exact
  ]

-- | Output constraints
outConstraints :: [UncertQ]
outConstraints = []
