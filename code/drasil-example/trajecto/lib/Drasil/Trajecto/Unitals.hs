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
  , elecFieldVec, magFieldVec
  , fieldRegionE, fieldRegionB
  , chargeToMass
  , tFinal, tHit, xDet, xHit, yHit
  , yDetMin, yDetMax
  , mMin, mMax, qMax, vMax0, eMax, bMax, tMax ]
  ++ [ initStateVec, fieldRegion, detLine, vCrossBVec ]
  ++ map dqdWr [QP.velocity, QP.acceleration, QP.force, QP.time, QP.position]
  ++ map dqdWr constants
  ++ [dqdWr particleState]

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

-- | Output variables (ODE state vector: [x, y, vx, vy])
outputs :: [DefinedQuantityDict]
outputs = [dqdWr particleState]

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
-- Vector field quantities (for DataDefs DD3, DD4)
---------------------------------------------------------

elecFieldVec :: UnitalChunk
elecFieldVec = uc' "Evec" (nounPhraseSP "electric field vector")
  (S "the electric field vector in the particle's current region")
  (vec cE) Real elecFieldU

magFieldVec :: UnitalChunk
magFieldVec = uc' "Bvec" (nounPhraseSP "magnetic flux density vector")
  (S "the magnetic flux density vector, perpendicular to the x-y plane")
  (vec cB) Real tesla

---------------------------------------------------------
-- Field region and piecewise-field quantities (DD5, DD6)
---------------------------------------------------------

fieldRegion :: DefinedQuantityDict
fieldRegion = dqdNoUnit
  (dccA "Ri" (nounPhraseSP "rectangular field region")
    "the i-th axis-aligned rectangular field region" Nothing)
  (sub cR lI) Real

fieldRegionE :: UnitalChunk
fieldRegionE = uc' "Ei" (nounPhraseSP "electric field in region i")
  (S "the constant electric field value assigned to region R_i")
  (sub (vec cE) lI) Real elecFieldU

fieldRegionB :: UnitalChunk
fieldRegionB = uc' "Bi" (nounPhraseSP "magnetic flux density in region i")
  (S "the constant magnetic flux density value assigned to region R_i")
  (sub (vec cB) lI) Real tesla

---------------------------------------------------------
-- Detector line (DD7)
---------------------------------------------------------

detLine :: DefinedQuantityDict
detLine = dqdNoUnit
  (dccA "Ldet" (nounPhraseSP "detector line")
    "the vertical line segment defining the particle detector" Nothing)
  (sub cL (label "det")) Real

yDetMin :: UnitalChunk
yDetMin = uc' "y_det_min" (nounPhraseSP "minimum y-coordinate of detector")
  (S "the lower y-bound of the detector line segment")
  (sup (sub lY (label "min")) (label "det")) Real metre

yDetMax :: UnitalChunk
yDetMax = uc' "y_det_max" (nounPhraseSP "maximum y-coordinate of detector")
  (S "the upper y-bound of the detector line segment")
  (sup (sub lY (label "max")) (label "det")) Real metre

---------------------------------------------------------
-- State vector and cross-product result (DD2, GD2)
---------------------------------------------------------

initStateVec :: DefinedQuantityDict
initStateVec = dqdNoUnit
  (dccA "s0" (nounPhraseSP "initial state vector")
    "the combined initial position and velocity of the particle" Nothing)
  (sub lS (Integ 0)) Real

vCrossBVec :: DefinedQuantityDict
vCrossBVec = dqdNoUnit
  (dccA "vCrossB" (nounPhraseSP "cross product of velocity and magnetic field")
    "the result of the cross product of velocity v and magnetic flux density B in 2D" Nothing)
  (Concat [vec lV, label "\xD7", vec cB]) Real

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
  -- q ≠ 0: particle must be charged (q=0 gives no Lorentz force),
  -- but negative charges (e.g. electrons) are physically valid.
  -- Drasil's RealInterval cannot express a single '≠ 0' constraint,
  -- so we drop the erroneous q > 0 physical range and instead show
  -- the symmetric software bound −q_max ≤ q ≤ q_max.
  [sfwrRange $ Bounded (Inc, neg (sy qMax)) (Inc, sy qMax)]
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
outConstraints = [particleState `uq` defaultUncrt]

---------------------------------------------------------
-- ODE state vector: dependent variable [x, y, vx, vy]
---------------------------------------------------------

-- | Combined ODE state vector for the charged particle.
-- Under the current Drasil ODE pipeline, only index 0 (x-position)
-- is recorded per time step; y, vx, vy are computed internally
-- but not individually captured in the output list.
particleState :: ConstrConcept
particleState = cuc' "particleState"
  (nounPhraseSP "dependent variables")
  "column vector of particle position and velocity [x, y, vx, vy]"
  lS metre (Vect Real)
  [] (exactDbl 0)
