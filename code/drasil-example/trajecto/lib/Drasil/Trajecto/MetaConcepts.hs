module Drasil.Trajecto.MetaConcepts (progName) where

import Language.Drasil
import Data.Drasil.Domains (physics)

progName :: CI
progName = commonIdeaWithDict "trajecto"
  (pn "Charged Particle Trajectory Simulator") "Trajecto" [physics]
