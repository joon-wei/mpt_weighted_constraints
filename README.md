# Markowitz Optimised Portfolio with Weight Constraints
This script calculates an optimised investment portfolio based on Markowitz's modern portfolio theory (MPT), but with an additional constraint on the assets' weight.

Currently, the constraint on portfolio weight x is -1 <= x <= 1, meaning to say the weight of each asset in the portfolio will not exceed -1 (100% short) or 1 (100% long). Targeted expected return is set at 5%.

<p align = "center">
<img src ="https://github.com/joon-wei/mpt_weighted_constraints/assets/168265734/de790a46-a3d2-447f-8dc3-fccc51eb8a40" width = 400>
</p>

By adding an additional inequality constraint to the optimisation problem, the traditonal method of using Lagrange Multipliers cannot work as it becomes a quadratic problem. The use of the R package quadprog is used to solve this.

This method can also be used to modify the weight constraints, such as x > 0, meaning only long positions are allowed in the portfolio. This could be useful for an investor with no access to short selling. 

## Background
Traditionally, the goal of MPT is relatively straightforward, to construct a portfolio which maximises expected returns while minimising risk for a given level of return. The results of this optimisation problem solved by Lagrange multipliers method can be very effective, and in some cases too effective. As the optimisation problem can take advantage of short selling assets, the optimised portfolio generated, within the given data set, will most defintely return a profit even if it is filled with the most poor performing assets. Weights of individual assets can also be extreme (for example: 200% short/long). This may lead to an overfitted model and poor test results, thus this script was created to explore ways on reducing overfitting. This topic is covered more in the full report. (I will upload it next time ...)
