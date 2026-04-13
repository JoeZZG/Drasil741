# Properties of a Correct Solution {#Sec:CorSolProps}

The [Output Data Constraints Table](./SecCorSolProps.md#Table:OutDataConstraints) shows the data constraints on the output variables. The column for physical constraints gives the physical limitations on the range of values that can be taken by the variable.

<div id="Table:OutDataConstraints"></div>

|Var    |
|:------|
|\\(s\\)|

**<p align="center">Output Data Constraints</p>**

For a pure magnetic field (no electric field, i.e., Ex = Ey = 0), the speed of the particle must remain constant over time, since the magnetic force is always perpendicular to the velocity and therefore does no work on the particle. A correct solution must satisfy |v(t)| = |v(0)| for all times t in the simulation..

When the electric field is non-zero, the work-energy theorem requires that the change in kinetic energy equals the work done by the electric force: delta_KE = q * Ex * delta_x + q * Ey * delta_y. A correct solution must respect this energy balance over each time step..

In the absence of all fields (Ex = Ey = 0 and B = 0), Newton's first law requires that the particle travel in a straight line at constant velocity. A correct solution must show no change in either velocity component and linear growth in both position components..
