-- | Requirements (functional and non-functional) for the Trajecto example.
module Drasil.Trajecto.Requirements (funcReqs, nonfuncReqs, funcReqsTables) where

import Language.Drasil
import Drasil.DocLang (inReqWTab, mkCorrectNFR, mkPortableNFR, mkMaintainableNFR)

import Data.Drasil.Concepts.Documentation (funcReqDom)

import Drasil.Trajecto.Unitals (inputs)
import Drasil.Trajecto.IMods (stateEvolIM, detHitIM)
import Drasil.Trajecto.DataDefs (regionRectDD, fieldsByRegionDD)

---------------------------------------------------------
-- Functional Requirements
---------------------------------------------------------

funcReqs :: [ConceptInstance]
funcReqs = [inputValues, echoInputs, buildRegionGrid, lookupActiveRegion, computeTraj, reportOutputs]

inputValues :: ConceptInstance
inputValuesTable :: LabelledContent
(inputValues, inputValuesTable) = inReqWTab Nothing inputs

funcReqsTables :: [LabelledContent]
funcReqsTables = [inputValuesTable]

echoInputs, buildRegionGrid, lookupActiveRegion, computeTraj, reportOutputs :: ConceptInstance

echoInputs = cic "echoInputs"
  (foldlSent [ S "Echo the given inputs" ])
  "Echo-Inputs" funcReqDom

buildRegionGrid = cic "buildRegionGrid"
  (foldlSent
    [ S "Construct the N field regions from the grid origin,"
    , S "region dimensions (w, h), and region count N, and assign"
    , S "each region its specified (Ex_i, Ey_i, B_i)"
    , sParen (refS regionRectDD) ])
  "Build-Region-Grid" funcReqDom

lookupActiveRegion = cic "lookupActiveRegion"
  (foldlSent
    [ S "At each simulation time-step, determine which region R_i"
    , S "contains the particle position (x(t), y(t)) and apply the"
    , S "corresponding fields. If the particle is outside all regions,"
    , S "apply zero fields"
    , sParen (refS fieldsByRegionDD) ])
  "Lookup-Active-Region" funcReqDom

computeTraj = cic "computeTraj"
  (foldlSent
    [ S "Compute the trajectory of the charged particle using"
    , S "the equations of motion derived from the Lorentz force"
    , sParen (refS stateEvolIM)
    ])
  "Compute-Trajectory" funcReqDom

reportOutputs = cic "reportOutputs"
  (foldlSent
    [ S "Report the final position, velocity, and whether the"
    , S "particle reaches the detector line, based on"
    , refS stateEvolIM +:+ S "and" +:+ refS detHitIM
    ])
  "Report-Outputs" funcReqDom

---------------------------------------------------------
-- Non-functional Requirements
---------------------------------------------------------

nonfuncReqs :: [ConceptInstance]
nonfuncReqs = [correct, maintainable, portable]

correct :: ConceptInstance
correct = mkCorrectNFR "correct" "Correctness"

maintainable :: ConceptInstance
maintainable = mkMaintainableNFR "maintainable" 10 "Maintainability"

portable :: ConceptInstance
portable = mkPortableNFR "portable" ["Windows", "Mac OSX", "Linux"] "Portability"
