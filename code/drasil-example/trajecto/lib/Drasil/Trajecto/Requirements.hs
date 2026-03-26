-- | Requirements (functional and non-functional) for the Trajecto example.
module Drasil.Trajecto.Requirements (funcReqs, nonfuncReqs, funcReqsTables) where

import Language.Drasil
import Drasil.DocLang (inReqWTab, mkCorrectNFR, mkPortableNFR, mkMaintainableNFR)
import qualified Language.Drasil.Sentence.Combinators as S

import Data.Drasil.Concepts.Documentation (funcReqDom, output_, value)
import Data.Drasil.Concepts.Computation (inValue)

import Drasil.Trajecto.Unitals (inputs, outputs)
import Drasil.Trajecto.IMods (stateEvolIM, detHitIM)

---------------------------------------------------------
-- Functional Requirements
---------------------------------------------------------

funcReqs :: [ConceptInstance]
funcReqs = [inputValues, echoInputs, computeTraj, reportOutputs]

inputValues :: ConceptInstance
inputValuesTable :: LabelledContent
(inputValues, inputValuesTable) = inReqWTab Nothing inputs

funcReqsTables :: [LabelledContent]
funcReqsTables = [inputValuesTable]

echoInputs, computeTraj, reportOutputs :: ConceptInstance

echoInputs = cic "echoInputs"
  (foldlSent [ S "Echo the given inputs" ])
  "Echo-Inputs" funcReqDom

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
    , refS stateEvolIM +:+ S "and" +:+. refS detHitIM
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
