#include "ODE.hpp"

#include <vector>

using std::vector;

ODE::ODE(double κ, double E_x, double E_y, double B) : κ(κ), E_x(E_x), E_y(E_y), B(B) {
}

void ODE::operator()(vector<double> s, vector<double> &ds, double t) {
    ds.at(0) = s.at(2);
    ds.at(1) = s.at(3);
    ds.at(2) = κ * (E_x + s.at(3) * B);
    ds.at(3) = κ * (E_y - s.at(2) * B);
}
