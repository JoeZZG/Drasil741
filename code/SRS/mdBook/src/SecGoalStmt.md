# Goal Statements {#Sec:GoalStmt}

Given the particle properties (\\(q\\) and \\(m\\)), initial conditions (\\({x\_{0}}\\), \\({y\_{0}}\\), \\({v\_{\text{x}0}}\\), \\({v\_{\text{y}0}}\\)), the number of field regions \\(N\\), the per-region fields (\\({E\_{\text{x}0}}\\), \\({E\_{\text{y}0}}\\), \\({B\_{0}}\\) for each region), the region grid specification (\\({x\_{\text{grid}}}\\), \\({y\_{\text{grid}}}\\), \\(w\\), \\(h\\)), the detector specification (\\({d\_{\text{orient}}}\\), \\({x\_{\text{det}}}\\), \\({y\_{\text{det}}}\\) and extent), and the simulation time \\({t\_{\text{final}}}\\), the goal statements are:

<div id="predictTrajectory"></div>

predictTrajectory: Predict the trajectory of a charged particle under prescribed electric and magnetic fields, computed using [IM:stateEvol](./SecIMs.md#IM:stateEvol).

<div id="determineDetectorOutcome"></div>

determineDetectorOutcome: Determine impact position and time-of-flight at a specified detector line, computed using [IM:detHit](./SecIMs.md#IM:detHit).
