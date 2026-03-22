{-# LANGUAGE PostfixOperators #-}
-- | Assumptions for the Trajecto example.
module Drasil.Trajecto.Assumptions
  ( assumptions
  , piecewiseUniform, singleParticle, noInteractions, prescribedFields
  , twoDMotion, bPerpPlane, eAxisAligned, rectRegions
  , lineDetector, fullDetection, lorentzOnly
  ) where

import Language.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Concepts.Documentation (assumpDom)

assumptions :: [ConceptInstance]
assumptions =
  [ piecewiseUniform, singleParticle, noInteractions, prescribedFields
  , twoDMotion, bPerpPlane, eAxisAligned, rectRegions
  , lineDetector, fullDetection, lorentzOnly ]

piecewiseUniform, singleParticle, noInteractions, prescribedFields,
  twoDMotion, bPerpPlane, eAxisAligned, rectRegions,
  lineDetector, fullDetection, lorentzOnly :: ConceptInstance

piecewiseUniform = cic "piecewiseUniform"
  (S "The electric and magnetic fields are uniform within each field region" +:+
   S "and may change only at region boundaries" !.)
  "piecewiseUniform" assumpDom

singleParticle = cic "singleParticle"
  (S "The particle is treated as a point mass and point charge" !.)
  "singleParticle" assumpDom

noInteractions = cic "noInteractions"
  (S "Collisions and particle-particle interactions (including space-charge effects)" +:+
   S "are neglected" !.)
  "noInteractions" assumpDom

prescribedFields = cic "prescribedFields"
  (S "The electric and magnetic fields are user-specified and remain" +:+
   S "fixed during the simulation" !.)
  "prescribedFields" assumpDom

twoDMotion = cic "twoDMotion"
  (S "The particle motion is confined to the" +:+ S "x-y plane" !.)
  "twoDMotion" assumpDom

bPerpPlane = cic "bPerpPlane"
  (S "The magnetic field is perpendicular to the x-y plane" !.)
  "bPerpPlane" assumpDom

eAxisAligned = cic "eAxisAligned"
  (S "The electric field lies in the x-y plane and is aligned with a coordinate axis" !.)
  "eAxisAligned" assumpDom

rectRegions = cic "rectRegions"
  (S "Field-region boundaries are rectangular and parallel to the x and y axes" !.)
  "rectRegions" assumpDom

lineDetector = cic "lineDetector"
  (S "The detector is modeled as a line located within the field region" !.)
  "lineDetector" assumpDom

fullDetection = cic "fullDetection"
  (S "The detector line is sufficiently long to record the impact point" +:+
   S "for any trajectory within the scope of the simulation" !.)
  "fullDetection" assumpDom

lorentzOnly = cic "lorentzOnly"
  (S "The particle dynamics are governed only by the Lorentz force;" +:+
   S "all other forces are neglected" !.)
  "lorentzOnly" assumpDom
