#include "Calculations.hpp"

#include <vector>

#include "ODE.hpp"
#include "Populate.hpp"
#include "boost/numeric/odeint/integrate/integrate_const.hpp"
#include "boost/numeric/odeint/stepper/generation.hpp"
#include "boost/numeric/odeint/stepper/runge_kutta_dopri5.hpp"

using std::vector;

double func_t_hit(double t_final) {
    return t_final;
}

double func_E_vect_i(double E_vect) {
    return E_vect;
}

vector<vector<double>> func_s(double κ, double E_x, double B, double E_y, double x_0, double y_0, double v_x0, double v_y0, double t_final) {
    vector<vector<double>> s;
    ODE ode = ODE(κ, E_x, E_y, B);
    vector<double> currVals{x_0, y_0, v_x0, v_y0};
    Populate pop = Populate(s);
    
    boost::numeric::odeint::runge_kutta_dopri5<vector<double>> rk = boost::numeric::odeint::runge_kutta_dopri5<vector<double>>();
    auto stepper = boost::numeric::odeint::make_controlled(1.0e-6, 1.0e-6, rk);
    boost::numeric::odeint::integrate_const(stepper, ode, currVals, 0.0, t_final, 1.0e-9, pop);
    
    return s;
}
