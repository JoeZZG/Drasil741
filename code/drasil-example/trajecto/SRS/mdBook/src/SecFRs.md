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

|Symbol                    |Description                      |Units                          |
|:-------------------------|:--------------------------------|:------------------------------|
|\\({B\_{0}}\\)            |Magnetic flux density in region 0|\\({\text{T}}\\)               |
|\\({B\_{1}}\\)            |Magnetic flux density in region 1|\\({\text{T}}\\)               |
|\\({B\_{2}}\\)            |Magnetic flux density in region 2|\\({\text{T}}\\)               |
|\\({B\_{3}}\\)            |Magnetic flux density in region 3|\\({\text{T}}\\)               |
|\\({B\_{4}}\\)            |Magnetic flux density in region 4|\\({\text{T}}\\)               |
|\\({B\_{5}}\\)            |Magnetic flux density in region 5|\\({\text{T}}\\)               |
|\\({d\_{\text{orient}}}\\)|Detector orientation             |--                             |
|\\({E\_{\text{x}0}}\\)    |X-electric field in region 0     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{x}1}}\\)    |X-electric field in region 1     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{x}2}}\\)    |X-electric field in region 2     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{x}3}}\\)    |X-electric field in region 3     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{x}4}}\\)    |X-electric field in region 4     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{x}5}}\\)    |X-electric field in region 5     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}0}}\\)    |Y-electric field in region 0     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}1}}\\)    |Y-electric field in region 1     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}2}}\\)    |Y-electric field in region 2     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}3}}\\)    |Y-electric field in region 3     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}4}}\\)    |Y-electric field in region 4     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\({E\_{\text{y}5}}\\)    |Y-electric field in region 5     |\\(\frac{\text{N}}{\text{C}}\\)|
|\\(h\\)                   |Region height                    |\\({\text{m}}\\)               |
|\\(m\\)                   |Particle mass                    |\\({\text{kg}}\\)              |
|\\(N\\)                   |Number of field regions          |--                             |
|\\({N\_{\text{col}}}\\)   |Number of grid columns           |--                             |
|\\(q\\)                   |Particle charge                  |\\({\text{C}}\\)               |
|\\({t\_{\text{final}}}\\) |Final simulation time            |\\({\text{s}}\\)               |
|\\({v\_{\text{x}0}}\\)    |Initial x-velocity               |\\(\frac{\text{m}}{\text{s}}\\)|
|\\({v\_{\text{y}0}}\\)    |Initial y-velocity               |\\(\frac{\text{m}}{\text{s}}\\)|
|\\(w\\)                   |Region width                     |\\({\text{m}}\\)               |
|\\({x\_{0}}\\)            |Initial x-position               |\\({\text{m}}\\)               |
|\\({x\_{\text{det}}}\\)   |Detector line x-position         |\\({\text{m}}\\)               |
|\\({x\_{\text{detMax}}}\\)|Maximum x-coordinate of detector |\\({\text{m}}\\)               |
|\\({x\_{\text{detMin}}}\\)|Minimum x-coordinate of detector |\\({\text{m}}\\)               |
|\\({x\_{\text{grid}}}\\)  |Grid origin x-coordinate         |\\({\text{m}}\\)               |
|\\({y\_{0}}\\)            |Initial y-position               |\\({\text{m}}\\)               |
|\\({y\_{\text{det}}}\\)   |Detector line y-position         |\\({\text{m}}\\)               |
|\\({y\_{\text{detMax}}}\\)|Maximum y-coordinate of detector |\\({\text{m}}\\)               |
|\\({y\_{\text{detMin}}}\\)|Minimum y-coordinate of detector |\\({\text{m}}\\)               |
|\\({y\_{\text{grid}}}\\)  |Grid origin y-coordinate         |\\({\text{m}}\\)               |

**<p align="center">Required Inputs</p>**
