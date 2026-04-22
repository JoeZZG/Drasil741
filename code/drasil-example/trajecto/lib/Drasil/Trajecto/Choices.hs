module Drasil.Trajecto.Choices where

import Language.Drasil.Code (Choices(..), Comments(..), ExtLib(..),
  Verbosity(..), ConstraintBehaviour(..), ImplementationType(..), Lang(..),
  Modularity(..), Structure(..), ConstantStructure(..), ConstantRepr(..),
  SoftwareDossierFile(..), Visibility(..), defaultChoices, makeArchit, makeData,
  makeConstraints, makeODE, makeDocConfig, makeLogConfig, makeOptFeats)
import Data.Drasil.ExternalLibraries.ODELibraries (scipyODEVecPckg, osloPckg,
  apacheODEPckg, odeintPckg)

import Drasil.Trajecto.ODEs (trajectODEInfo)
import Drasil.Trajecto.ModuleDefs (detHitMod, detHitDefs)

choices :: Choices
choices = defaultChoices {
  lang = [Python],  -- TODO: restore [Python, Cpp, CSharp, Java]
  architecture = makeArchit Modular Program,
  dataInfo = makeData Unbundled (Store Bundled) Const,
  optFeats = makeOptFeats
    (makeDocConfig [CommentFunc, CommentClass, CommentMod] Quiet Hide)
    (makeLogConfig [] "log.txt")
    [SampleInput "../../datafiles/trajecto/sampleInput.txt", ReadME],
  srsConstraints = makeConstraints Warning Exception,
  extLibs = [Math (makeODE [trajectODEInfo] [scipyODEVecPckg, osloPckg, apacheODEPckg, odeintPckg])],
  extraMods = [detHitMod],
  handWiredDefs = detHitDefs
}
