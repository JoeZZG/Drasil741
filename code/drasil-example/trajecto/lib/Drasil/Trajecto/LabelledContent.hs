-- | Labelled content (figures) for the Trajecto example.
module Drasil.Trajecto.LabelledContent (labelledContent, figPhysSys, sysCtxFig) where

import Language.Drasil
import qualified Language.Drasil.Development as D
import Language.Drasil.Chunk.Concept.NamedCombinators
import Data.Drasil.Concepts.Documentation (physSyst, sysCont)

labelledContent :: [LabelledContent]
labelledContent = [figPhysSys, sysCtxFig]

resourcePath :: String
resourcePath = "../../../../datafiles/trajecto/"

figPhysSys :: LabelledContent
figPhysSys = llccFig "trajectoPhysSys" $
  figWithWidth (D.toSent $ atStartNP (the physSyst)) (resourcePath ++ "trajecto.png") 60

sysCtxFig :: LabelledContent
sysCtxFig = llccFig "sysCtxDiag" $
  fig (titleize sysCont) (resourcePath ++ "SystemContextFigure.png")
