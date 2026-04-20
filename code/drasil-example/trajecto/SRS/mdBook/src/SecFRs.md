# Functional Requirements {#Sec:FRs}

This section provides the functional requirements, the tasks and behaviours that the software is expected to complete.

<div id="inputValues"></div>

Input-Values: Input the values from [Tab:ReqInputs](./SecFRs.md#Table:ReqInputs).

<div id="echoInputs"></div>

Echo-Inputs: Echo the given inputs.

<div id="buildRegionGrid"></div>

Build-Region-Grid: Construct the N field regions from the grid origin, region dimensions (w, h), and region count N, and assign each region its specified (Ex_i, Ey_i, B_i) ([DD:regionRect](./SecDDs.md#DD:regionRect)).

<div id="lookupActiveRegion"></div>

Lookup-Active-Region: At each simulation time-step, determine which region R_i contains the particle position (x(t), y(t)) and apply the corresponding fields. If the particle is outside all regions, apply zero fields ([DD:fieldsByRegion](./SecDDs.md#DD:fieldsByRegion)).

<div id="computeTraj"></div>

Compute-Trajectory: Compute the trajectory of the charged particle using the equations of motion derived from the Lorentz force ([IM:stateEvol](./SecIMs.md#IM:stateEvol)).

<div id="reportOutputs"></div>

Report-Outputs: Report the final position, velocity, and whether the particle reaches the detector line, based on [IM:stateEvol](./SecIMs.md#IM:stateEvol) and [IM:detHit](./SecIMs.md#IM:detHit).

<div id="Table:ReqInputs"></div>

|Symbol                                |Description                       |Units                          |
|:-------------------------------------|:---------------------------------|:------------------------------|
|\\(B\\)                               |Out-of-plane magnetic flux density|\\({\text{T}}\\)               |
|\\({d\_{\text{orient}}}\\)            |Detector orientation              |--                             |
|\\({E\_{\text{x}}}\\)                 |X-component of the electric field |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}}}\\)                 |Y-component of the electric field |\\(\frac{\text{N}}{\text{C}}\\)|
|\\(h\\)                               |Region height                     |\\({\text{m}}\\)               |
|\\(m\\)                               |Particle mass                     |\\({\text{kg}}\\)              |
|\\(N\\)                               |Number of field regions           |--                             |
|\\(q\\)                               |Particle charge                   |\\({\text{C}}\\)               |
|\\({t\_{\text{final}}}\\)             |Final simulation time             |\\({\text{s}}\\)               |
|\\({v\_{\text{x}0}}\\)                |Initial x-velocity                |\\(\frac{\text{m}}{\text{s}}\\)|
|\\({v\_{\text{y}0}}\\)                |Initial y-velocity                |\\(\frac{\text{m}}{\text{s}}\\)|
|\\(w\\)                               |Region width                      |\\({\text{m}}\\)               |
|\\({x\_{0}}\\)                        |Initial x-position                |\\({\text{m}}\\)               |
|\\({x\_{\text{det}}}\\)               |Detector line x-position          |\\({\text{m}}\\)               |
|\\({x\_{\text{grid}}}\\)              |Grid origin x-coordinate          |\\({\text{m}}\\)               |
|\\({{x\_{\text{max}}}^{\text{det}}}\\)|Maximum x-coordinate of detector  |\\({\text{m}}\\)               |
|\\({{x\_{\text{min}}}^{\text{det}}}\\)|Minimum x-coordinate of detector  |\\({\text{m}}\\)               |
|\\({y\_{0}}\\)                        |Initial y-position                |\\({\text{m}}\\)               |
|\\({y\_{\text{det}}}\\)               |Detector line y-position          |\\({\text{m}}\\)               |
|\\({y\_{\text{grid}}}\\)              |Grid origin y-coordinate          |\\({\text{m}}\\)               |
|\\({{y\_{\text{max}}}^{\text{det}}}\\)|Maximum y-coordinate of detector  |\\({\text{m}}\\)               |
|\\({{y\_{\text{min}}}^{\text{det}}}\\)|Minimum y-coordinate of detector  |\\({\text{m}}\\)               |

**<p align="center">Required Inputs</p>**
