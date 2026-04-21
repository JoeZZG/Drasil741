#include "Calculations.hpp"

#include <vector>

#include "ODE.hpp"
#include "Populate.hpp"
#include "boost/numeric/odeint/integrate/integrate_const.hpp"
#include "boost/numeric/odeint/stepper/generation.hpp"
#include "boost/numeric/odeint/stepper/runge_kutta_dopri5.hpp"

using std::vector;

vector<vector<double>> func_s(double κ, double E_x0, double E_x1, double E_x2, double E_x3, double E_x4, double E_x5, double x_grid, double w, double y_grid, double h, double B_0, double B_1, double B_2, double B_3, double B_4, double B_5, double E_y0, double E_y1, double E_y2, double E_y3, double E_y4, double E_y5, double x_0, double y_0, double v_x0, double v_y0, double t_final) {
    vector<vector<double>> s;
    ODE ode = ODE(κ, E_x0, E_x1, E_x2, E_x3, E_x4, E_x5, E_y0, E_y1, E_y2, E_y3, E_y4, E_y5, B_0, B_1, B_2, B_3, B_4, B_5, x_grid, y_grid, w, h);
    vector<double> currVals{x_0, y_0, v_x0, v_y0};
    Populate pop = Populate(s);
    
    boost::numeric::odeint::runge_kutta_dopri5<vector<double>> rk = boost::numeric::odeint::runge_kutta_dopri5<vector<double>>();
    auto stepper = boost::numeric::odeint::make_controlled(1.0e-6, 1.0e-6, rk);
    boost::numeric::odeint::integrate_const(stepper, ode, currVals, 0.0, t_final, 1.0e-9, pop);
    
    return s;
}

double func_t_hit(double d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax, vector<double> &s) {
    return func_t_hit(s, d_orient, x_det, y_det, y_detMin, y_detMax, x_detMin, x_detMax);
}

double func_x_hit(double d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax, vector<double> &s) {
    return func_x_hit(s, d_orient, x_det, y_det, y_detMin, y_detMax, x_detMin, x_detMax);
}

double func_y_hit(double d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax, vector<double> &s) {
    return func_y_hit(s, d_orient, x_det, y_det, y_detMin, y_detMax, x_detMin, x_detMax);
}
