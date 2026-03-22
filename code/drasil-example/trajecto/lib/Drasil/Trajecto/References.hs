-- | References for the Trajecto example.
module Drasil.Trajecto.References (citations) where

import Language.Drasil
import Data.Drasil.Citations
  ( parnasClements1986, koothoor2013, smithEtAl2007
  , smithLai2005, smithKoothoor2016, velocityWiki, accelerationWiki )

citations :: BibRef
citations =
  [ parnasClements1986
  , koothoor2013
  , smithEtAl2007
  , smithLai2005
  , smithKoothoor2016
  , velocityWiki
  , accelerationWiki
  , lorentzForceWiki
  ]

lorentzForceWiki :: Citation
lorentzForceWiki = cBooklet
  "Lorentz Force"
  [ author [mononym "Wikipedia"]
  , title "Lorentz force"
  , howPublishedU "https://en.wikipedia.org/wiki/Lorentz_force"
  , year 2024
  ]
  "lorentzForceWiki"
