-- | Main SRS body for the Trajecto example.
module Drasil.Trajecto.Body (mkSRS, si) where

import Language.Drasil hiding (organization, section)
import qualified Language.Drasil.Development as D
import Language.Drasil.Code (Mod(Mod), asVC)
import Theory.Drasil (TheoryModel)
import Drasil.SRSDocument
import Drasil.Generator (withCommonKnowledge)
import qualified Drasil.DocLang.SRS as SRS
import Drasil.System (SmithEtAlSRS, mkSmithEtAlICO)
import Language.Drasil.Chunk.Concept.NamedCombinators
import qualified Language.Drasil.Sentence.Combinators as S
import Drasil.Document.Contents (foldlSP, foldlSPCol)

import Data.Drasil.Concepts.Documentation
  ( endUser, physics, softwareSys, sysCont, user )
import Data.Drasil.Concepts.Education (calculus, undergraduate)
import Data.Drasil.Concepts.Math (mathcon')
import Data.Drasil.Concepts.Physics (physicCon')
import Data.Drasil.Concepts.PhysicalProperties (physicalcon)
import Data.Drasil.Concepts.Software (program)
import Data.Drasil.Concepts.Theory (inModel)

import Drasil.Trajecto.Assumptions (assumptions)
import Drasil.Trajecto.Changes (likelyChgs, unlikelyChgs)
import Drasil.Trajecto.Concepts
  ( defs, chargedParticle, electricField, magneticField, detectorLine, regionGrid )
import Drasil.Trajecto.DataDefs (dataDefs)
import Drasil.Trajecto.GenDefs (genDefs)
import Drasil.Trajecto.Goals (goals, goalsInputs)
import Drasil.Trajecto.IMods (iMods)
import Drasil.Trajecto.LabelledContent (figPhysSys, sysCtxFig, labelledContent)
import Drasil.Trajecto.MetaConcepts (progName)
import Drasil.Trajecto.References (citations)
import Drasil.Trajecto.Requirements (funcReqs, nonfuncReqs, funcReqsTables)
import Drasil.Trajecto.TMods (tMods)
import Drasil.Trajecto.Unitals
  ( symbols, acronyms, inputs, outputs, inConstraints, outConstraints
  , constants, elecFieldU, chgPerMassU )
import Drasil.Trajecto.ModuleDefs (detHitMod, implVars)

---------------------------------------------------------
-- Author
---------------------------------------------------------

authorName :: Person
authorName = person "Zhuo" "Zhang"

---------------------------------------------------------
-- SRS Declaration
---------------------------------------------------------

mkSRS :: SRSDecl
mkSRS =
  [ TableOfContents
  , RefSec $ RefProg intro
      [ TUnits
      , tsymb [TSPurpose, TypogConvention [Vector Bold], SymbOrder, VectorUnits]
      , TAandA
      ]
  , IntroSec $ IntroProg (justification progName) (phrase progName)
      [ IPurpose $ purpDoc progName Verbose
      , IScope scope
      , IChar [] charsOfReader []
      , IOrgSec inModel (SRS.inModel [] []) Nothing
      ]
  , GSDSec $ GSDProg
      [ SysCntxt [sysCtxIntro progName, LlC sysCtxFig, sysCtxDesc]
      , UsrChars [userCharacteristicsIntro progName]
      , SystCons [] []
      ]
  , SSDSec $ SSDProg
      [ SSDProblem $ PDProg purp []
          [ TermsAndDefs Nothing terms
          , PhySysDesc progName physSystParts figPhysSys []
          , Goals goalsInputs
          ]
      , SSDSolChSpec $ SCSProg
          [ Assumptions
          , TMs [] (Label : stdFields)
          , GDs [] ([Label, Units] ++ stdFields) ShowDerivation
          , DDs [] ([Label, Symbol, Units] ++ stdFields) ShowDerivation
          , IMs [] ([Label, Input, Output, InConstraints, OutConstraints] ++ stdFields) ShowDerivation
          , Constraints EmptyS inConstraints
          , CorrSolnPpties outConstraints corrSolProps
          ]
      ]
  , ReqrmntSec $ ReqsProg
      [ FReqsSub funcReqsTables
      , NonFReqsSub
      ]
  , LCsSec
  , UCsSec
  , TraceabilitySec $ TraceabilityProg $ traceMatStandard si
  , AuxConstntSec $ AuxConsProg progName []
  , Bibliography
  ]

---------------------------------------------------------
-- System Information
---------------------------------------------------------

si :: SmithEtAlSRS
si = mkSmithEtAlICO progName [authorName]
  [purp] [] [] []
  tMods genDefs dataDefs iMods
  inputs outputs inConstraints
  constants
  symbMap []

---------------------------------------------------------
-- Purpose
---------------------------------------------------------

purp :: Sentence
purp = foldlSent_
  [ S "predict the trajectory of a", phrase chargedParticle
  , S "moving through piecewise-uniform", phrase electricField
  , S "and", phrase magneticField, S "regions"
  ]

---------------------------------------------------------
-- Scope
---------------------------------------------------------

scope :: Sentence
scope = foldlSent_
  [ S "the analysis of two-dimensional", phrase chargedParticle
  , S "motion in the x-y plane under the Lorentz force"
  ]

---------------------------------------------------------
-- Terminology
---------------------------------------------------------

terms :: [ConceptChunk]
terms = defs

---------------------------------------------------------
-- Physical system parts
---------------------------------------------------------

physSystParts :: [Sentence]
physSystParts =
  [ D.toSent (atStartNP (a_ chargedParticle)) +:+ S "(the simulated particle)"
  , D.toSent (atStartNP (the electricField)) +:+ S "in each field region (may differ between regions)"
  , D.toSent (atStartNP (the magneticField)) +:+ S "perpendicular to the x-y plane in each field region"
  , D.toSent (atStartNP (the regionGrid)) +:+ S "of N equal-sized rectangular field regions"
  , D.toSent (atStartNP (the detectorLine)) +:+ S "(horizontal or vertical) at a specified location"
  ]

---------------------------------------------------------
-- Standard fields for theory/general/data/instance model tables
---------------------------------------------------------

stdFields :: Fields
stdFields = [DefiningEquation, Description Verbose IncludeUnits, Notes, Source, RefBy]

---------------------------------------------------------
-- Concept instances
---------------------------------------------------------

concIns :: [ConceptInstance]
concIns = assumptions ++ goals ++ funcReqs ++ nonfuncReqs ++ likelyChgs ++ unlikelyChgs

---------------------------------------------------------
-- Idea and concept dictionaries
---------------------------------------------------------

ideaDicts :: [IdeaDict]
ideaDicts =
  nw progName : map nw mathcon' ++ map nw physicCon'

abbreviationsList :: [IdeaDict]
abbreviationsList = map nw symbols ++ map nw acronyms

conceptChunks :: [ConceptChunk]
conceptChunks = physicalcon ++ defs

---------------------------------------------------------
-- Chunk database
---------------------------------------------------------

symbMap :: ChunkDB
symbMap = withCommonKnowledge []
  symbolsWCodeSymbols ideaDicts conceptChunks
  [elecFieldU, chgPerMassU]
  dataDefs iMods genDefs tMods
  concIns citations
  (labelledContent ++ funcReqsTables)

-- | Include symbols from extra modules (detector hit function) alongside
-- the standard symbols, following the glassbr pattern.
symbolsWCodeSymbols :: [DefinedQuantityDict]
symbolsWCodeSymbols = map asVC (concatMap (\(Mod _ _ _ _ l) -> l) [detHitMod])
  ++ implVars ++ symbols

---------------------------------------------------------
-- Introduction helpers
---------------------------------------------------------

justification :: CI -> Sentence
justification prog = foldlSent
  [ S "The motion of a charged particle through electromagnetic fields is a"
  , S "fundamental phenomenon arising in particle accelerators, mass spectrometers,"
  , S "and plasma confinement devices. It is therefore useful to have a"
  , phrase program, S "to simulate charged particle trajectories"
  , S "in piecewise-uniform fields"
  ]

charsOfReader :: [Sentence]
charsOfReader =
  [ phrase undergraduate +:+ S "level" +:+ phrase physics
  , phrase undergraduate +:+ S "level" +:+ phrase calculus
  ]

---------------------------------------------------------
-- System context helpers
---------------------------------------------------------

sysCtxIntro :: CI -> Contents
sysCtxIntro prog = foldlSP
  [ refS sysCtxFig, S "shows the" +:+. phrase sysCont
  , S "A rectangle represents the", phrase softwareSys, sParen (short prog) `sC`
    S "and a circle represents the", phrase user
  , S "providing inputs and receiving outputs"
  ]

sysCtxDesc :: Contents
sysCtxDesc = foldlSPCol
  [ S "The", phrase user, S "provides the particle properties, field region grid,"
  , S "per-region electromagnetic fields, detector specification, and simulation time;"
  , S "the", phrase softwareSys, S "computes and reports the particle trajectory"
  , S "and detector hit outcome"
  ]

userCharacteristicsIntro :: CI -> Contents
userCharacteristicsIntro prog = foldlSP
  [ S "The", phrase endUser `S.of_` short prog
  , S "should have an understanding of undergraduate-level" +:+ phrase physics
  ]

---------------------------------------------------------
-- Properties of a Correct Solution helpers
---------------------------------------------------------

corrSolProps :: [Contents]
corrSolProps =
  [ foldlSP
      [ S "For a pure magnetic field (no electric field, i.e., Ex = Ey = 0),"
      , S "the speed of the particle must remain constant over time,"
      , S "since the magnetic force is always perpendicular to the velocity"
      , S "and therefore does no work on the particle."
      , S "A correct solution must satisfy"
      , S "|v(t)| = |v(0)|"
      , S "for all times t in the simulation"
      ]
  , foldlSP
      [ S "When the electric field is non-zero, the work-energy theorem requires that"
      , S "the change in kinetic energy equals the work done by the electric force:"
      , S "delta_KE = q * Ex * delta_x + q * Ey * delta_y."
      , S "A correct solution must respect this energy balance over each time step"
      ]
  , foldlSP
      [ S "In the absence of all fields (Ex = Ey = 0 and B = 0),"
      , S "Newton's first law requires that the particle travel in a straight line"
      , S "at constant velocity."
      , S "A correct solution must show no change in either velocity component"
      , S "and linear growth in both position components"
      ]
  , foldlSP
      [ S "When the particle crosses from region R_i to region R_j,"
      , S "the position and velocity must be continuous at the boundary."
      , S "Only the acceleration changes (due to the different fields in the new region)."
      , S "A correct solution must preserve continuity of the state vector"
      , S "at every region boundary crossing."
      ]
  ]
