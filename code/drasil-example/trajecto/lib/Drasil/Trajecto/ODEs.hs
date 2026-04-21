-- | ODE information for the Trajecto example.
-- Wires the 4-component Lorentz-force ODE (IM1) into Drasil's code generator.
--
-- State vector s = [x, y, vx, vy], so:
--   ds[0]/dt = s[2]                            (dx/dt  = vx)
--   ds[1]/dt = s[3]                            (dy/dt  = vy)
--   ds[2]/dt = kappa*(Ex_curr + s[3]*B_curr)   (dvx/dt = κ(Ex + vy·B))
--   ds[3]/dt = kappa*(Ey_curr - s[2]*B_curr)   (dvy/dt = κ(Ey − vx·B))
--
-- where Ex_curr, Ey_curr, B_curr are selected from the per-region arrays
-- via completeCase based on the particle's current (x,y) position.
-- The grid has a fixed maximum of 6 regions (3 columns × 2 rows).
-- Unused regions can have zero-valued fields.
module Drasil.Trajecto.ODEs (trajectODEOpts, trajectODEInfo) where

import Language.Drasil (ExprC(..), LiteralC(int, exactDbl, dbl))
import Language.Drasil.Code (odeInfo, odeOptions, quantvar, ODEInfo,
  ODEMethod(RK45), ODEOptions)

import Data.Drasil.Quantities.Physics (time)

import Drasil.Trajecto.Unitals
  ( chargeToMass
  , ex0, ex1, ex2, ex3, ex4, ex5
  , ey0, ey1, ey2, ey3, ey4, ey5
  , b0, b1, b2, b3, b4, b5
  , xPos0, yPos0, xVel0, yVel0, tFinal
  , particleState
  , xGrid, yGrid, regionWidth, regionHeight )

-- | ODE solver options: RK45, tolerances 1e-6, step size 1e-9 s.
trajectODEOpts :: ODEOptions
trajectODEOpts = odeOptions RK45 (dbl 1.0e-6) (dbl 1.0e-6) (dbl 1.0e-9)

-- | ODE info for the charged-particle trajectory (IM1).
-- Parameters include the per-region field arrays and grid geometry.
trajectODEInfo :: ODEInfo
trajectODEInfo = odeInfo
  (quantvar time)           -- independent variable t
  (quantvar particleState)  -- state vector s = [x, y, vx, vy]
  [ quantvar chargeToMass   -- κ = q/m  (derived, DD1)
  , quantvar ex0, quantvar ex1, quantvar ex2
  , quantvar ex3, quantvar ex4, quantvar ex5
  , quantvar ey0, quantvar ey1, quantvar ey2
  , quantvar ey3, quantvar ey4, quantvar ey5
  , quantvar b0, quantvar b1, quantvar b2
  , quantvar b3, quantvar b4, quantvar b5
  , quantvar xGrid          -- grid origin x
  , quantvar yGrid          -- grid origin y
  , quantvar regionWidth    -- w (region width)
  , quantvar regionHeight ] -- h (region height)
  (exactDbl 0)              -- t_init = 0
  (sy tFinal)               -- t_final from user input
  -- Initial conditions: [x0, y0, vx0, vy0] from user input
  [ sy xPos0, sy yPos0, sy xVel0, sy yVel0 ]
  -- ODE RHS: [ds[0]/dt, ds[1]/dt, ds[2]/dt, ds[3]/dt]
  [ idx (sy particleState) (int 2)       -- dx/dt = vx
  , idx (sy particleState) (int 3)       -- dy/dt = vy
  , sy chargeToMass $* (currentEx $+ (idx (sy particleState) (int 3) $* currentB))
  , sy chargeToMass $* (currentEy $- (idx (sy particleState) (int 2) $* currentB))
  ]
  trajectODEOpts

-- | Shorthand: particle x and y from state vector
px, py :: (ExprC e, LiteralC e) => e
px = idx (sy particleState) (int 0)
py = idx (sy particleState) (int 1)

-- | Check if particle is in region at grid position (col, row).
-- x ∈ [xGrid + col*w, xGrid + (col+1)*w) and y ∈ [yGrid + row*h, yGrid + (row+1)*h)
inRegion :: (ExprC e, LiteralC e) => Int -> Int -> e
inRegion col row =
  (px $>= xLo) $&& (px $< xHi) $&& (py $>= yLo) $&& (py $< yHi)
  where
    xLo = sy xGrid $+ (exactDbl (fromIntegral col)     $* sy regionWidth)
    xHi = sy xGrid $+ (exactDbl (fromIntegral (col+1)) $* sy regionWidth)
    yLo = sy yGrid $+ (exactDbl (fromIntegral row)     $* sy regionHeight)
    yHi = sy yGrid $+ (exactDbl (fromIntegral (row+1)) $* sy regionHeight)

-- | Piecewise field lookup for Ex: 6 regions (3 cols × 2 rows), default 0.
currentEx :: (ExprC e, LiteralC e) => e
currentEx = completeCase
  [ (sy ex0, inRegion 0 0)
  , (sy ex1, inRegion 1 0)
  , (sy ex2, inRegion 2 0)
  , (sy ex3, inRegion 0 1)
  , (sy ex4, inRegion 1 1)
  , (sy ex5, inRegion 2 1)
  , (exactDbl 0,  otherwise')
  ]

-- | Piecewise field lookup for Ey.
currentEy :: (ExprC e, LiteralC e) => e
currentEy = completeCase
  [ (sy ey0, inRegion 0 0)
  , (sy ey1, inRegion 1 0)
  , (sy ey2, inRegion 2 0)
  , (sy ey3, inRegion 0 1)
  , (sy ey4, inRegion 1 1)
  , (sy ey5, inRegion 2 1)
  , (exactDbl 0,  otherwise')
  ]

-- | Piecewise field lookup for B.
currentB :: (ExprC e, LiteralC e) => e
currentB = completeCase
  [ (sy b0, inRegion 0 0)
  , (sy b1, inRegion 1 0)
  , (sy b2, inRegion 2 0)
  , (sy b3, inRegion 0 1)
  , (sy b4, inRegion 1 1)
  , (sy b5, inRegion 2 1)
  , (exactDbl 0,  otherwise')
  ]

-- | "Otherwise" condition: always true (catch-all for outside all regions).
otherwise' :: (ExprC e, LiteralC e) => e
otherwise' = exactDbl 1 $> exactDbl 0
