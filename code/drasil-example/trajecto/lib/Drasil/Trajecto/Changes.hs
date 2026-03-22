-- | Likely and unlikely changes for the Trajecto example.
module Drasil.Trajecto.Changes (likelyChgs, unlikelyChgs) where

import Language.Drasil
import Data.Drasil.Concepts.Documentation (likeChgDom, unlikeChgDom)
import Drasil.Sentence.Combinators (chgsStart)

import Drasil.Trajecto.Assumptions (twoDMotion, lorentzOnly)

likelyChgs :: [ConceptInstance]
likelyChgs = [lcExtendTo3D]

unlikelyChgs :: [ConceptInstance]
unlikelyChgs = [ucLorentzForce]

lcExtendTo3D :: ConceptInstance
lcExtendTo3D = cic "lcExtendTo3D"
  (foldlSent
    [ chgsStart twoDMotion $
      S "extend Trajecto to support three-dimensional (3D) motion," +:+
      S "including a z-component of position, velocity, acceleration,",
      S "electric field, and magnetic field" ])
  "lcExtendTo3D" likeChgDom

ucLorentzForce :: ConceptInstance
ucLorentzForce = cic "ucLorentzForce"
  (foldlSent
    [ chgsStart lorentzOnly $
      S "the Lorentz force law is a well-established physical principle",
      S "and is unlikely to change" ])
  "ucLorentzForce" unlikeChgDom
