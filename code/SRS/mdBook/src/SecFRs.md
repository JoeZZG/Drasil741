# Functional Requirements {#Sec:FRs}

This section provides the functional requirements, the tasks and behaviours that the software is expected to complete.

<div id="inputValues"></div>

Input-Values: Input the values from [Tab:ReqInputs](./SecFRs.md#Table:ReqInputs).

<div id="echoInputs"></div>

Echo-Inputs: Echo the given inputs.

<div id="computeTraj"></div>

Compute-Trajectory: Compute the trajectory of the charged particle using the equations of motion derived from the Lorentz force ([IM:stateEvol](./SecIMs.md#IM:stateEvol)).

<div id="reportOutputs"></div>

Report-Outputs: Report the final position, velocity, and whether the particle reaches the detector line, based on [IM:stateEvol](./SecIMs.md#IM:stateEvol) and [IM:detHit](./SecIMs.md#IM:detHit)..

<div id="Table:ReqInputs"></div>

|Symbol                   |Description                       |Units                          |
|:------------------------|:---------------------------------|:------------------------------|
|\\(B\\)                  |Out-of-plane magnetic flux density|\\({\text{T}}\\)               |
|\\({E\_{\text{x}}}\\)    |X-component of the electric field |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}}}\\)    |Y-component of the electric field |\\(\frac{\text{N}}{\text{C}}\\)|
|\\(m\\)                  |Particle mass                     |\\({\text{kg}}\\)              |
|\\(q\\)                  |Particle charge                   |\\({\text{C}}\\)               |
|\\({t\_{\text{final}}}\\)|Final simulation time             |\\({\text{s}}\\)               |
|\\({v\_{\text{x}0}}\\)   |Initial x-velocity                |\\(\frac{\text{m}}{\text{s}}\\)|
|\\({v\_{\text{y}0}}\\)   |Initial y-velocity                |\\(\frac{\text{m}}{\text{s}}\\)|
|\\({x\_{0}}\\)           |Initial x-position                |\\({\text{m}}\\)               |
|\\({y\_{0}}\\)           |Initial y-position                |\\({\text{m}}\\)               |

**<p align="center">Required Inputs</p>**
