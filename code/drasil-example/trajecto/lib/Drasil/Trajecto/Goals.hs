{-# LANGUAGE PostfixOperators #-}
-- | Goal statements for the Trajecto example.
module Drasil.Trajecto.Goals (goals, goalsInputs) where

import Language.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Concepts.Documentation (goalStmtDom)

import Drasil.Trajecto.Unitals (parMass, parCharge,
  xPos0, yPos0, xVel0, yVel0, elecFieldX, elecFieldY, magField, tFinal)
import Drasil.Trajecto.IMods (stateEvolIM, detHitIM)

goals :: [ConceptInstance]
goals = [predictTrajectory, determineDetectorOutcome]

goalsInputs :: [Sentence]
goalsInputs =
  [ S "the particle properties" +:+ sParen (ch parCharge +:+ S "and" +:+ ch parMass) `sC`
    S "initial conditions" +:+
    sParen (ch xPos0 `sC` ch yPos0 `sC` ch xVel0 `sC` ch yVel0) `sC`
    S "the specification of electric and magnetic fields" +:+
    sParen (ch elecFieldX `sC` ch elecFieldY `sC` ch magField) `sC`
    S "and detector geometry including" +:+ ch tFinal ]

predictTrajectory :: ConceptInstance
predictTrajectory = cic "predictTrajectory"
  (S "Predict the trajectory of a charged particle under prescribed" +:+
   S "electric and magnetic fields, computed using" +:+. refS stateEvolIM)
  "predictTrajectory" goalStmtDom

determineDetectorOutcome :: ConceptInstance
determineDetectorOutcome = cic "determineDetectorOutcome"
  (S "Determine impact position and time-of-flight at a specified detector line, computed using" +:+. refS detHitIM)
  "determineDetectorOutcome" goalStmtDom
