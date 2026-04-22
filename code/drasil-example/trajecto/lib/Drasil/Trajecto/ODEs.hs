-- | ODE information for the Trajecto example.
-- Wires the 4-component Lorentz-force ODE (IM1) into Drasil's code generator.
--
-- State vector s = [x, y, vx, vy], so:
--   ds[0]/dt = s[2]                            (dx/dt  = vx)
--   ds[1]/dt = s[3]                            (dy/dt  = vy)
--   ds[2]/dt = kappa*(Ex_curr + s[3]*B_curr)   (dvx/dt = κ(Ex + vy·B))
--   ds[3]/dt = kappa*(Ey_curr - s[2]*B_curr)   (dvy/dt = κ(Ey − vx·B))
--
-- where Ex_curr, Ey_curr, B_curr are selected from per-region flat arrays
-- via completeCase based on the particle's current (x,y) position.
-- The flat region index k = row*N_col + col, where:
--   col = floor((x - x_grid) / w)
--   row = floor((y - y_grid) / h)
-- Supports up to maxRegions = 6 regions total (N_col up to 3 cols × 2 rows).
-- The step size is derived from t_final / 1000 for scale-independent integration.
module Drasil.Trajecto.ODEs (trajectODEOpts, trajectODEInfo) where

import Language.Drasil (ExprC(..), LiteralC(int, exactDbl, dbl))
import Language.Drasil.Code (odeInfo, odeOptions, quantvar, ODEInfo,
  ODEMethod(RK45), ODEOptions)
import Drasil.Code.CodeExpr (CodeExprC(($//) , ($%)), CodeExpr)

import Data.Drasil.Quantities.Physics (time)

import Drasil.Trajecto.Unitals
  ( chargeToMass
  , ex0, ex1, ex2, ex3, ex4, ex5
  , ey0, ey1, ey2, ey3, ey4, ey5
  , b0, b1, b2, b3, b4, b5
  , xPos0, yPos0, xVel0, yVel0, tFinal
  , particleState
  , xGrid, yGrid, regionWidth, regionHeight, nCols )

-- | ODE solver options: RK45, tolerances 1e-6.
-- Step size = t_final / 1000, computed at runtime, giving ~1000 samples
-- regardless of the physical time scale (electron-scale or macro-scale).
trajectODEOpts :: ODEOptions
trajectODEOpts = odeOptions RK45 (dbl 1.0e-6) (dbl 1.0e-6) (sy tFinal $/ exactDbl 1000)

-- | ODE info for the charged-particle trajectory (IM1).
-- Parameters include the per-region field arrays, grid geometry, and N_col.
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
  , quantvar regionHeight   -- h (region height)
  , quantvar nCols ]        -- N_col (number of columns)
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

-- | Dynamic region lookup: given flat index k, check if particle is in that region.
-- col = k % N_col,  row = k // N_col
-- x ∈ [xGrid + col*w, xGrid + (col+1)*w) ∧ y ∈ [yGrid + row*h, yGrid + (row+1)*h)
inRegionDyn :: Int -> CodeExpr
inRegionDyn k =
  (px $>= xLo) $&& (px $< xHi) $&& (py $>= yLo) $&& (py $< yHi)
  where
    kE   = int (fromIntegral k)
    col  = kE $% sy nCols
    row  = kE $// sy nCols
    xLo  = sy xGrid $+ (col $* sy regionWidth)
    xHi  = sy xGrid $+ ((col $+ int 1) $* sy regionWidth)
    yLo  = sy yGrid $+ (row $* sy regionHeight)
    yHi  = sy yGrid $+ ((row $+ int 1) $* sy regionHeight)

-- | Piecewise field lookup for Ex: up to 6 regions (flat index 0..5), default 0.
currentEx :: CodeExpr
currentEx = completeCase
  [ (sy ex0, inRegionDyn 0)
  , (sy ex1, inRegionDyn 1)
  , (sy ex2, inRegionDyn 2)
  , (sy ex3, inRegionDyn 3)
  , (sy ex4, inRegionDyn 4)
  , (sy ex5, inRegionDyn 5)
  , (exactDbl 0, otherwise')
  ]

-- | Piecewise field lookup for Ey.
currentEy :: CodeExpr
currentEy = completeCase
  [ (sy ey0, inRegionDyn 0)
  , (sy ey1, inRegionDyn 1)
  , (sy ey2, inRegionDyn 2)
  , (sy ey3, inRegionDyn 3)
  , (sy ey4, inRegionDyn 4)
  , (sy ey5, inRegionDyn 5)
  , (exactDbl 0, otherwise')
  ]

-- | Piecewise field lookup for B.
currentB :: CodeExpr
currentB = completeCase
  [ (sy b0, inRegionDyn 0)
  , (sy b1, inRegionDyn 1)
  , (sy b2, inRegionDyn 2)
  , (sy b3, inRegionDyn 3)
  , (sy b4, inRegionDyn 4)
  , (sy b5, inRegionDyn 5)
  , (exactDbl 0, otherwise')
  ]

-- | "Otherwise" condition: always true (catch-all for outside all regions).
otherwise' :: CodeExpr
otherwise' = exactDbl 1 $> exactDbl 0
