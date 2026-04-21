# Data Constraints {#Sec:DataConstraints}

The [Input Data Constraints Table](./SecDataConstraints.md#Table:InDataConstraints) shows the data constraints on the input variables. The column for physical constraints gives the physical limitations on the range of values that can be taken by the variable. The uncertainty column provides an estimate of the confidence with which the physical quantities can be measured. This information would be part of the input if one were performing an uncertainty quantification exercise. The constraints are conservative to give the user of the model the flexibility to experiment with unusual situations. The column of typical values is intended to provide a feel for a common scenario.

<div id="Table:InDataConstraints"></div>

|Var                       |Physical Constraints           |Software Constraints                                                 |Typical Value                                         |Uncert.      |
|:-------------------------|:------------------------------|:--------------------------------------------------------------------|:-----------------------------------------------------|:------------|
|\\({d\_{\text{orient}}}\\)|--                             |\\(0\leq{}{d\_{\text{orient}}}\leq{}1\\)                             |\\(0\\)                                               |0.0\\(\\%\\) |
|\\(h\\)                   |\\(h\gt{}0\\)                  |--                                                                   |\\(0.1\\) \\({\text{m}}\\)                            |0.0\\(\\%\\) |
|\\(m\\)                   |\\(m\gt{}0\\)                  |\\({m\_{\text{min}}}\leq{}m\leq{}{m\_{\text{max}}}\\)                |\\(911.0\cdot{}10^{-33}\\) \\({\text{kg}}\\)          |10.0\\(\\%\\)|
|\\(N\\)                   |\\(N\gt{}0\\)                  |--                                                                   |\\(1\\)                                               |0.0\\(\\%\\) |
|\\({N\_{\text{col}}}\\)   |\\({N\_{\text{col}}}\gt{}0\\)  |--                                                                   |\\(1\\)                                               |0.0\\(\\%\\) |
|\\(q\\)                   |--                             |\\(-{q\_{\text{max}}}\leq{}q\leq{}{q\_{\text{max}}}\\)               |\\(160.0\cdot{}10^{-21}\\) \\({\text{C}}\\)           |10.0\\(\\%\\)|
|\\({t\_{\text{final}}}\\) |\\({t\_{\text{final}}}\gt{}0\\)|\\({t\_{\text{final}}}\leq{}{t\_{\text{max}}}\\)                     |\\(1.0\cdot{}10^{-6}\\) \\({\text{s}}\\)              |0.0\\(\\%\\) |
|\\({v\_{\text{x}0}}\\)    |--                             |\\(-{v\_{\text{max}}}\leq{}{v\_{\text{x}0}}\leq{}{v\_{\text{max}}}\\)|\\(1.0\cdot{}10^{6}\\) \\(\frac{\text{m}}{\text{s}}\\)|10.0\\(\\%\\)|
|\\({v\_{\text{y}0}}\\)    |--                             |\\(-{v\_{\text{max}}}\leq{}{v\_{\text{y}0}}\leq{}{v\_{\text{max}}}\\)|\\(0\\) \\(\frac{\text{m}}{\text{s}}\\)               |10.0\\(\\%\\)|
|\\(w\\)                   |\\(w\gt{}0\\)                  |--                                                                   |\\(0.1\\) \\({\text{m}}\\)                            |0.0\\(\\%\\) |
|\\({x\_{0}}\\)            |--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |
|\\({x\_{\text{det}}}\\)   |--                             |--                                                                   |\\(0.1\\) \\({\text{m}}\\)                            |0.0\\(\\%\\) |
|\\({x\_{\text{detMax}}}\\)|--                             |--                                                                   |\\(0.1\\) \\({\text{m}}\\)                            |0.0\\(\\%\\) |
|\\({x\_{\text{detMin}}}\\)|--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |
|\\({x\_{\text{grid}}}\\)  |--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |
|\\({y\_{0}}\\)            |--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |
|\\({y\_{\text{det}}}\\)   |--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |
|\\({y\_{\text{detMax}}}\\)|--                             |--                                                                   |\\(0.05\\) \\({\text{m}}\\)                           |0.0\\(\\%\\) |
|\\({y\_{\text{detMin}}}\\)|--                             |--                                                                   |\\(0.0-5\\) \\({\text{m}}\\)                          |0.0\\(\\%\\) |
|\\({y\_{\text{grid}}}\\)  |--                             |--                                                                   |\\(0\\) \\({\text{m}}\\)                              |0.0\\(\\%\\) |

**<p align="center">Input Data Constraints</p>**
