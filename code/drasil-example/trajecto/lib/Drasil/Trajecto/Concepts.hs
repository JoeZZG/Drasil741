-- | Concepts and terminology for the Trajecto example.
module Drasil.Trajecto.Concepts where

import Language.Drasil

---------------------------------------------------------
-- Terms with definitions (ConceptChunk)
-- These appear in the SRS Section "Terminology and Definitions"
---------------------------------------------------------

defs :: [ConceptChunk]
defs = [ chargedParticle, electricField, magneticField, lorentzForce
       , trajectory, fieldRegion, detectorLine, velocitySelector
       , cartesianCoordSys ]

chargedParticle :: ConceptChunk
chargedParticle = dcc "chargedParticle" (cn' "charged particle")
  "a particle that has a non-zero electric charge and can interact with electric and magnetic fields"

electricField :: ConceptChunk
electricField = dcc "electricField" (cn' "electric field")
  "a physical field that exerts an electric force on charged particles"

magneticField :: ConceptChunk
magneticField = dcc "magneticField" (cn' "magnetic field")
  "a physical field that exerts a magnetic force on moving charged particles"

lorentzForce :: ConceptChunk
lorentzForce = dcc "lorentzForce" (cn' "Lorentz force")
  "the force on a charged particle due to electric and magnetic fields"

trajectory :: ConceptChunk
trajectory = dcc "trajectory" (cn' "trajectory")
  "the path traced by a particle over time"

fieldRegion :: ConceptChunk
fieldRegion = dcc "fieldRegion" (cn' "field region")
  "a spatial region in which the electric field and magnetic field are specified, typically treated as uniform within the region"

detectorLine :: ConceptChunk
detectorLine = dcc "detectorLine" (cn' "detector line")
  "a line at a specified location where the particle impact position is recorded"

velocitySelector :: ConceptChunk
velocitySelector = dcc "velocitySelector" (cn' "velocity selector")
  "a configuration of crossed electric and magnetic fields that allows only particles with a particular velocity to pass through without deflection"

cartesianCoordSys :: ConceptChunk
cartesianCoordSys = dcc "cartesianCoordSys" (cn "Cartesian coordinate system")
  "a coordinate system that specifies each point uniquely in a plane by a set of numerical coordinates, which are the signed distances to the point from two fixed perpendicular oriented lines, measured in the same unit of length"
