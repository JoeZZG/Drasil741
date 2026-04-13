-- | Pure expressions for the Trajecto example.
module Drasil.Trajecto.Expressions where

import Language.Drasil

import Drasil.Trajecto.Unitals (chargeToMass, elecFieldX, elecFieldY,
  magField, xVel, yVel)

-- | x-acceleration: ax = κ*(Ex + vy*B)
xAccelExpr :: PExpr
xAccelExpr = sy chargeToMass $* (sy elecFieldX $+ (sy yVel $* sy magField))

-- | y-acceleration: ay = κ*(Ey - vx*B)
yAccelExpr :: PExpr
yAccelExpr = sy chargeToMass $* (sy elecFieldY $- (sy xVel $* sy magField))
