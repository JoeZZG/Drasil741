-- | Custom module definitions for the Trajecto example.
-- Provides detector hit detection: loops over trajectory to find where
-- the particle crosses the detector line.
module Drasil.Trajecto.ModuleDefs (detHitMod, implVars, detHitDefs) where

import Drasil.Code.CodeExpr (LiteralC(int))
import Language.Drasil (Expr, Space(..), nounPhraseSP,
  label, sub, ExprC(..), DefinedQuantityDict, implVar,
  mkQuantDef, dqdNoUnit, dcc, variable, SimpleQDef)
import Language.Drasil.Display (Symbol(..))
import Language.Drasil.ShortHands
import Language.Drasil.Code (($:=), Func, FuncStmt(..), Mod,
  funcDef, fDecDef, ffor, packmod)

import qualified Drasil.Trajecto.Unitals as U

-- | All extra modules for the trajecto example.
detHitMod :: Mod
detHitMod = packmod "DetectorHit"
  "Provides functions for detecting particle-detector line intersection" []
  [detHitTimeCT, detHitXCT, detHitYCT]

-- | Implementation variables used internally by the detector hit function.
implVars :: [DefinedQuantityDict]
implVars = [traj, dOr, detPosV, detStartV, detLenV,
  ii, numPts, bestT, bestX, bestY,
  xi, yi, prevX, prevY, dtVar, tFinalP, fracVar, crossCoordVar]

-- Local variable helpers
var :: String -> String -> String -> Symbol -> Space -> DefinedQuantityDict
var nam np desc sym sp = implVar nam (nounPhraseSP np) desc sp sym

-- Parameters of the detector hit function
traj :: DefinedQuantityDict
traj = var "traj" "trajectory" "the ODE trajectory array" (label "traj") (Vect (Vect Real))

dOr :: DefinedQuantityDict
dOr = var "d_orient" "detector orientation" "detector orientation flag" (sub lD (label "orient")) Natural

detPosV :: DefinedQuantityDict
detPosV = var "det_pos" "detector position" "coordinate along the detector's perpendicular axis" (sub lD (label "pos")) Real

detStartV :: DefinedQuantityDict
detStartV = var "det_start" "detector start" "start of the detector segment along its parallel axis" (sub lD (label "start")) Real

detLenV :: DefinedQuantityDict
detLenV = var "det_length" "detector length" "length of the detector segment" (sub lD (label "len")) Real

-- Internal variables
ii :: DefinedQuantityDict
ii = var "i" "loop index" "the loop index" lI Natural

numPts :: DefinedQuantityDict
numPts = var "num_pts" "number of trajectory points" "the number of trajectory points"
  (label "num_pts") Natural

bestT :: DefinedQuantityDict
bestT = var "best_t" "best hit time" "the earliest hit time found"
  (sub lT (label "best")) Real

bestX :: DefinedQuantityDict
bestX = var "best_x" "best hit x" "x at the earliest hit"
  (sub lX (label "best")) Real

bestY :: DefinedQuantityDict
bestY = var "best_y" "best hit y" "y at the earliest hit"
  (sub lY (label "best")) Real

xi :: DefinedQuantityDict
xi = var "x_i" "x at step" "x-position at time step i" (sub lX lI) Real

yi :: DefinedQuantityDict
yi = var "y_i" "y at step" "y-position at time step i" (sub lY lI) Real

prevX :: DefinedQuantityDict
prevX = var "prev_x" "previous x" "x-position at the previous time step" (sub lX (label "prev")) Real

prevY :: DefinedQuantityDict
prevY = var "prev_y" "previous y" "y-position at the previous time step" (sub lY (label "prev")) Real

fracVar :: DefinedQuantityDict
fracVar = var "frac" "interpolation fraction" "fractional position along segment where crossing occurs" (label "frac") Real

crossCoordVar :: DefinedQuantityDict
crossCoordVar = var "cross_coord" "crossing coordinate" "interpolated coordinate at the detector crossing" (label "cross_coord") Real

dtVar :: DefinedQuantityDict
dtVar = var "dt" "time step size" "time between consecutive trajectory points"
  (sub lT (label "step")) Real

tFinalP :: DefinedQuantityDict
tFinalP = var "t_final" "final simulation time" "the final time passed to the detector hit function"
  (sub lT (label "final")) Real

---------------------------------------------------------------------------
-- Three detector hit functions, each returning a scalar.
-- They share the same logic but return different components.
-- detHitTime returns -1 if no hit, else the interpolated hit time.
-- detHitX returns 0 if no hit, else x-coordinate of hit.
-- detHitY returns 0 if no hit, else y-coordinate of hit.
---------------------------------------------------------------------------

-- | Helper: the common body for detector hit functions.
-- The function loops over trajectory points, checks if the particle
-- crosses the detector line between consecutive steps, and returns
-- a specified component.
mkDetHitFunc :: String -> String -> DefinedQuantityDict -> Func
mkDetHitFunc name desc retVar =
  funcDef name desc
    [traj, dOr, detPosV, detStartV, detLenV, tFinalP]
    Real
    (Just desc)
    [
      fDecDef numPts (dim (sy traj)),
      fDecDef bestT (neg (int 1)),
      fDecDef bestX (neg (int 1)),
      fDecDef bestY (neg (int 1)),
      fDecDef dtVar  (sy tFinalP $/ (sy numPts $- int 1)),
      fDecDef prevX  (idx (idx (sy traj) (int 0)) (int 0)),
      fDecDef prevY  (idx (idx (sy traj) (int 0)) (int 1)),

      ffor ii (sy numPts)
        [
          fDecDef xi  (idx (idx (sy traj) (sy ii)) (int 0)),
          fDecDef yi  (idx (idx (sy traj) (sy ii)) (int 1)),

          -- Vertical detector (d_orient == 0): cross x = detPos (either direction)
          -- Interpolate to find exact crossing point
          FCond (sy dOr $= int 0)
            [
              FCond ((sy bestT $< int 0) $&&
                     (((sy prevX $< sy detPosV) $&& (sy xi $>= sy detPosV)) $||
                      ((sy prevX $>= sy detPosV) $&& (sy xi $< sy detPosV))))
                [ fDecDef fracVar ((sy detPosV $- sy prevX) $/ (sy xi $- sy prevX)),
                  fDecDef crossCoordVar (sy prevY $+ (sy fracVar $* (sy yi $- sy prevY))),
                  FCond ((sy crossCoordVar $>= sy detStartV) $&&
                         (sy crossCoordVar $<= (sy detStartV $+ sy detLenV)))
                    [ bestT $:= ((sy ii $- int 1 $+ sy fracVar) $* sy dtVar),
                      bestX $:= sy detPosV,
                      bestY $:= sy crossCoordVar
                    ] []
                ] []
            ]
            -- Horizontal detector (d_orient == 1): cross y = detPos (either direction)
            -- Interpolate to find exact crossing point
            [
              FCond ((sy bestT $< int 0) $&&
                     (((sy prevY $< sy detPosV) $&& (sy yi $>= sy detPosV)) $||
                      ((sy prevY $>= sy detPosV) $&& (sy yi $< sy detPosV))))
                [ fDecDef fracVar ((sy detPosV $- sy prevY) $/ (sy yi $- sy prevY)),
                  fDecDef crossCoordVar (sy prevX $+ (sy fracVar $* (sy xi $- sy prevX))),
                  FCond ((sy crossCoordVar $>= sy detStartV) $&&
                         (sy crossCoordVar $<= (sy detStartV $+ sy detLenV)))
                    [ bestT $:= ((sy ii $- int 1 $+ sy fracVar) $* sy dtVar),
                      bestX $:= sy crossCoordVar,
                      bestY $:= sy detPosV
                    ] []
                ] []
            ],

          prevX $:= sy xi,
          prevY $:= sy yi
        ],

      FRet $ sy retVar
    ]

detHitTimeCT :: Func
detHitTimeCT = mkDetHitFunc "det_t_hit" "Finds time of detector hit" bestT

detHitXCT :: Func
detHitXCT = mkDetHitFunc "det_x_hit" "Finds x-coordinate of detector hit" bestX

detHitYCT :: Func
detHitYCT = mkDetHitFunc "det_y_hit" "Finds y-coordinate of detector hit" bestY

---------------------------------------------------------------------------
-- QDefinitions that use the detector hit functions.
---------------------------------------------------------------------------

detHitDefs :: [SimpleQDef]
detHitDefs =
  [ mkQuantDef U.tHit tHitExpr
  , mkQuantDef U.xHit xHitExpr
  , mkQuantDef U.yHit yHitExpr
  ]

-- Function quantities for apply calls (must differ from qtoc(tHit/xHit/yHit) names
-- to avoid eMap collision that causes self-referencing wrappers in Calculations.py)
detHitTimeFQ :: DefinedQuantityDict
detHitTimeFQ = dqdNoUnit (dcc "det_t_hit" (nounPhraseSP "det_t_hit")
  "time of detector hit function") (variable "det_t_hit") Real

detHitXFQ :: DefinedQuantityDict
detHitXFQ = dqdNoUnit (dcc "det_x_hit" (nounPhraseSP "det_x_hit")
  "x of detector hit function") (variable "det_x_hit") Real

detHitYFQ :: DefinedQuantityDict
detHitYFQ = dqdNoUnit (dcc "det_y_hit" (nounPhraseSP "det_y_hit")
  "y of detector hit function") (variable "det_y_hit") Real

detHitArgs :: [Expr]
detHitArgs =
  [ sy U.particleState
  , sy U.detOrient
  , sy U.detPos
  , sy U.detStart
  , sy U.detLength
  , sy U.tFinal
  ]

tHitExpr :: Expr
tHitExpr = apply detHitTimeFQ detHitArgs

xHitExpr :: Expr
xHitExpr = apply detHitXFQ detHitArgs

yHitExpr :: Expr
yHitExpr = apply detHitYFQ detHitArgs
