-- | Data definitions for the Trajecto example.
module Drasil.Trajecto.DataDefs (dataDefs, qOvermDD) where

import Language.Drasil
import Theory.Drasil (DataDefinition, ddENoRefs)

import Drasil.Trajecto.Unitals (chargeToMass, parCharge, parMass)

dataDefs :: [DataDefinition]
dataDefs = [qOvermDD]

---------------------------------------------------------
-- DD1: Charge-to-mass ratio
-- κ = q / m
---------------------------------------------------------

qOvermDD :: DataDefinition
qOvermDD = ddENoRefs qOvermQD Nothing "qOverm" [qOvermNote]

qOvermQD :: SimpleQDef
qOvermQD = mkQuantDef chargeToMass (sy parCharge $/ sy parMass)

qOvermNote :: Sentence
qOvermNote = foldlSent
  [ S "The charge-to-mass ratio simplifies the equations of motion" +:+
    S "by combining the particle's charge", ch parCharge `sC`
    S "and mass", ch parMass +:+ S "into a single parameter" ]
