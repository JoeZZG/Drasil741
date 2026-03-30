module Main (main) where

import GHC.IO.Encoding

import Drasil.Generator (exportSmithEtAlSrsWCode)

import Drasil.Trajecto.Body (mkSRS, si)
import Drasil.Trajecto.Choices (choices)

main :: IO ()
main = do
  setLocaleEncoding utf8
  exportSmithEtAlSrsWCode si mkSRS "Trajecto_SRS" choices
