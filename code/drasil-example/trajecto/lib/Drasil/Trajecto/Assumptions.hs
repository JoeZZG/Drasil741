{-# LANGUAGE PostfixOperators #-}
-- | Assumptions for the Trajecto example.
module Drasil.Trajecto.Assumptions
  ( assumptions
  , piecewiseUniform, singleParticle, noInteractions, prescribedFields
  , twoDMotion, bPerpPlane, eAxisAligned, rectRegions
  , lineDetector, fullDetection, lorentzOnly, gridLayout
  ) where

import Language.Drasil
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Concepts.Documentation (assumpDom)

assumptions :: [ConceptInstance]
assumptions =
  [ piecewiseUniform, singleParticle, noInteractions, prescribedFields
  , twoDMotion, bPerpPlane, eAxisAligned, rectRegions, gridLayout
  , lineDetector, fullDetection, lorentzOnly ]

piecewiseUniform, singleParticle, noInteractions, prescribedFields,
  twoDMotion, bPerpPlane, eAxisAligned, rectRegions, gridLayout,
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
   S "are neglected; this follows from" +:+ refS singleParticle !.)
  "noInteractions" assumpDom

prescribedFields = cic "prescribedFields"
  (S "The electric and magnetic fields are user-specified and remain" +:+
   S "fixed during the simulation" !.)
  "prescribedFields" assumpDom

twoDMotion = cic "twoDMotion"
  (S "The particle motion is confined to the" +:+ S "x-y plane" !.)
  "twoDMotion" assumpDom

bPerpPlane = cic "bPerpPlane"
  (S "The magnetic field is perpendicular to the x-y plane," +:+
   S "consistent with" +:+ refS twoDMotion !.)
  "bPerpPlane" assumpDom

eAxisAligned = cic "eAxisAligned"
  (S "The electric field lies in the x-y plane and is aligned with a coordinate axis," +:+
   S "consistent with" +:+ refS twoDMotion !.)
  "eAxisAligned" assumpDom

rectRegions = cic "rectRegions"
  (S "All field regions are axis-aligned rectangles of identical width w and height h." +:+
   S "The N regions are tiled adjacently (sharing edges with no gaps or overlaps)" +:+
   S "so that their union forms a single axis-aligned rectangle" !.)
  "rectRegions" assumpDom

gridLayout = cic "gridLayout"
  (S "The field regions are numbered 1 through N and arranged in a single row" +:+
   S "(left-to-right) or single column (bottom-to-top) within the grid rectangle." +:+
   S "The arrangement direction is determined by the region grid specification," +:+
   S "and region geometry is constrained by" +:+ refS rectRegions !.)
  "gridLayout" assumpDom

lineDetector = cic "lineDetector"
  (S "The detector is modelled as a line segment that is either horizontal" +:+
   S "or vertical, located at the boundary of or within the region grid" !.)
  "lineDetector" assumpDom

fullDetection = cic "fullDetection"
  (S "The detector line is sufficiently long to record the impact point" +:+
   S "for any trajectory within the scope of the simulation" !.)
  "fullDetection" assumpDom

lorentzOnly = cic "lorentzOnly"
  (S "The particle dynamics are governed only by the Lorentz force;" +:+
   S "all other forces are neglected" !.)
  "lorentzOnly" assumpDom
