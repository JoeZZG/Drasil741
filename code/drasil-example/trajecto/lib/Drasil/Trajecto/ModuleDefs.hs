-- | Custom module definitions for the Trajecto example.
-- Provides detector hit detection: loops over trajectory to find where
-- the particle crosses the detector line.
module Drasil.Trajecto.ModuleDefs (detHitMod, implVars, detHitDefs) where

import Drasil.Code.CodeExpr (CodeExpr, LiteralC(int))
import Language.Drasil (Expr, Space(..), nounPhraseSP,
  label, sub, HasSymbol(..), ExprC(..), DefinedQuantityDict, implVar,
  mkQuantDef, dqdNoUnit, dcc, variable, SimpleQDef)
import Language.Drasil.Display (Symbol(..))
import Language.Drasil.ShortHands
import Language.Drasil.Code (($:=), Func, FuncStmt(..), Mod,
  asVC, funcDef, fDecDef, ffor, packmod, quantvar)

import qualified Drasil.Trajecto.Unitals as U

-- | All extra modules for the trajecto example.
detHitMod :: Mod
detHitMod = packmod "DetectorHit"
  "Provides functions for detecting particle-detector line intersection" []
  [detHitTimeCT, detHitXCT, detHitYCT]

-- | Implementation variables used internally by the detector hit function.
implVars :: [DefinedQuantityDict]
implVars = [traj, dOr, xD, yD, yMin, yMax, xMin, xMax,
  ii, numPts, bestT, bestX, bestY,
  xi, yi]

-- Local variable helpers
var :: String -> String -> String -> Symbol -> Space -> DefinedQuantityDict
var nam np desc sym sp = implVar nam (nounPhraseSP np) desc sp sym

-- Parameters of the detector hit function
traj :: DefinedQuantityDict
traj = var "traj" "trajectory" "the ODE trajectory array" (label "traj") (Vect (Vect Real))

dOr :: DefinedQuantityDict
dOr = var "d_orient" "detector orientation" "detector orientation flag" (sub lD (label "orient")) Natural

xD :: DefinedQuantityDict
xD = var "x_det" "detector x" "detector x-position" (sub lX (label "det")) Real

yD :: DefinedQuantityDict
yD = var "y_det" "detector y" "detector y-position" (sub lY (label "det")) Real

yMin :: DefinedQuantityDict
yMin = var "y_detMin" "detector y min" "detector y minimum" (sub lY (label "detMin")) Real

yMax :: DefinedQuantityDict
yMax = var "y_detMax" "detector y max" "detector y maximum" (sub lY (label "detMax")) Real

xMin :: DefinedQuantityDict
xMin = var "x_detMin" "detector x min" "detector x minimum" (sub lX (label "detMin")) Real

xMax :: DefinedQuantityDict
xMax = var "x_detMax" "detector x max" "detector x maximum" (sub lX (label "detMax")) Real

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

---------------------------------------------------------------------------
-- Three detector hit functions, each returning a scalar.
-- They share the same logic but return different components.
-- detHitTime returns -1 if no hit, else 0 (placeholder for time).
-- detHitX returns 0 if no hit, else x-coordinate of hit.
-- detHitY returns 0 if no hit, else y-coordinate of hit.
---------------------------------------------------------------------------

-- | Helper: the common body for detector hit functions.
-- The function loops over trajectory points, checks if the particle
-- position matches the detector line, and returns a specified component.
mkDetHitFunc :: String -> String -> DefinedQuantityDict -> Func
mkDetHitFunc name desc retVar =
  funcDef name desc
    [traj, dOr, xD, yD, yMin, yMax, xMin, xMax]
    Real
    (Just desc)
    [
      fDecDef numPts (dim (sy traj)),
      fDecDef bestT (neg (int 1)),
      fDecDef bestX (int 0),
      fDecDef bestY (int 0),

      ffor ii (sy numPts)
        [
          fDecDef xi  (idx (idx (sy traj) (sy ii)) (int 0)),
          fDecDef yi  (idx (idx (sy traj) (sy ii)) (int 1)),

          -- Vertical detector (d_orient == 0)
          FCond (sy dOr $= int 0)
            [
              FCond ((sy bestT $< int 0) $&&
                     (sy xi $>= sy xD) $&&
                     (sy yi $>= sy yMin) $&&
                     (sy yi $<= sy yMax))
                [ bestT $:= int 0,
                  bestX $:= sy xi,
                  bestY $:= sy yi
                ] []
            ]
            -- Horizontal detector (d_orient == 1)
            [
              FCond ((sy bestT $< int 0) $&&
                     (sy yi $>= sy yD) $&&
                     (sy xi $>= sy xMin) $&&
                     (sy xi $<= sy xMax))
                [ bestT $:= int 0,
                  bestX $:= sy xi,
                  bestY $:= sy yi
                ] []
            ]
        ],

      FRet $ sy retVar
    ]

detHitTimeCT :: Func
detHitTimeCT = mkDetHitFunc "func_t_hit" "Finds time of detector hit" bestT

detHitXCT :: Func
detHitXCT = mkDetHitFunc "func_x_hit" "Finds x-coordinate of detector hit" bestX

detHitYCT :: Func
detHitYCT = mkDetHitFunc "func_y_hit" "Finds y-coordinate of detector hit" bestY

---------------------------------------------------------------------------
-- QDefinitions that use the detector hit functions.
---------------------------------------------------------------------------

detHitDefs :: [SimpleQDef]
detHitDefs =
  [ mkQuantDef U.tHit tHitExpr
  , mkQuantDef U.xHit xHitExpr
  , mkQuantDef U.yHit yHitExpr
  ]

-- Function quantities for apply calls (must match funcDef names)
-- NOTE: We use Real (return type) rather than mkFunction to avoid
-- Drasil's spaceToCodeType generating Float alternatives that crash Python.
detHitTimeFQ :: DefinedQuantityDict
detHitTimeFQ = dqdNoUnit (dcc "func_t_hit" (nounPhraseSP "func_t_hit")
  "time of detector hit function") (variable "func_t_hit") Real

detHitXFQ :: DefinedQuantityDict
detHitXFQ = dqdNoUnit (dcc "func_x_hit" (nounPhraseSP "func_x_hit")
  "x of detector hit function") (variable "func_x_hit") Real

detHitYFQ :: DefinedQuantityDict
detHitYFQ = dqdNoUnit (dcc "func_y_hit" (nounPhraseSP "func_y_hit")
  "y of detector hit function") (variable "func_y_hit") Real

detHitArgs :: [Expr]
detHitArgs =
  [ sy U.particleState
  , sy U.detOrient
  , sy U.xDet
  , sy U.yDet
  , sy U.yDetMin
  , sy U.yDetMax
  , sy U.xDetMin
  , sy U.xDetMax
  ]

tHitExpr :: Expr
tHitExpr = apply detHitTimeFQ detHitArgs

xHitExpr :: Expr
xHitExpr = apply detHitXFQ detHitArgs

yHitExpr :: Expr
yHitExpr = apply detHitYFQ detHitArgs
