-- | ODE information for the Trajecto example.
-- Wires the 4-component Lorentz-force ODE (IM1) into Drasil's code generator
-- following the DblPend pattern.
--
-- State vector s = [x, y, vx, vy], so:
--   ds[0]/dt = s[2]              (dx/dt  = vx)
--   ds[1]/dt = s[3]              (dy/dt  = vy)
--   ds[2]/dt = kappa*(Ex + s[3]*B)   (dvx/dt = κ(Ex + vy·B))
--   ds[3]/dt = kappa*(Ey - s[2]*B)   (dvy/dt = κ(Ey − vx·B))
--
-- NOTE (known limitation): Drasil's ODE pipeline records only s[0] (x-position)
-- per time step in the output list due to a hardcoded idx(…, 0) in
-- appendCurrSolFS.  The full 4-component integration is performed correctly
-- internally, but only the x-trajectory is stored in the returned list.
module Drasil.Trajecto.ODEs (trajectODEOpts, trajectODEInfo) where

import Language.Drasil (ExprC(..), LiteralC(int, exactDbl, dbl))
import Language.Drasil.Code (odeInfo, odeOptions, quantvar, ODEInfo,
  ODEMethod(RK45), ODEOptions)

import Data.Drasil.Quantities.Physics (time)

import Drasil.Trajecto.Unitals
  ( chargeToMass, elecFieldX, elecFieldY, magField
  , xPos0, yPos0, xVel0, yVel0, tFinal
  , particleState )

-- | ODE solver options: RK45, tolerances 1e-6, step size 1e-9 s.
-- A small step size is used because the physical time scale is ~microseconds
-- (t_final ~ 1e-6 s), so a step of 1e-9 s gives ~1000 output points.
trajectODEOpts :: ODEOptions
trajectODEOpts = odeOptions RK45 (dbl 1.0e-6) (dbl 1.0e-6) (dbl 1.0e-9)

-- | ODE info for the charged-particle trajectory (IM1).
trajectODEInfo :: ODEInfo
trajectODEInfo = odeInfo
  (quantvar time)           -- independent variable t
  (quantvar particleState)  -- state vector s = [x, y, vx, vy]
  [ quantvar chargeToMass   -- κ = q/m  (derived, DD1)
  , quantvar elecFieldX     -- Ex (input)
  , quantvar elecFieldY     -- Ey (input)
  , quantvar magField ]     -- B  (input)
  (exactDbl 0)              -- t_init = 0
  (sy tFinal)               -- t_final from user input
  -- Initial conditions: [x0, y0, vx0, vy0] from user input
  [ sy xPos0, sy yPos0, sy xVel0, sy yVel0 ]
  -- ODE RHS: [ds[0]/dt, ds[1]/dt, ds[2]/dt, ds[3]/dt]
  [ idx (sy particleState) (int 2)
  , idx (sy particleState) (int 3)
  , sy chargeToMass $* (sy elecFieldX $+ (idx (sy particleState) (int 3) $* sy magField))
  , sy chargeToMass $* (sy elecFieldY $- (idx (sy particleState) (int 2) $* sy magField))
  ]
  trajectODEOpts
