#include "DetectorHit.hpp"

#include <vector>

using std::vector;

double func_t_hit(vector<vector<double>> &traj, int d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = 0;
    double y_best = 0;
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_i >= x_det && (y_i >= y_detMin && y_i <= y_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_i >= y_det && (x_i >= x_detMin && x_i <= x_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
    }
    return t_best;
}

double func_x_hit(vector<vector<double>> &traj, int d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = 0;
    double y_best = 0;
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_i >= x_det && (y_i >= y_detMin && y_i <= y_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_i >= y_det && (x_i >= x_detMin && x_i <= x_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
    }
    return x_best;
}

double func_y_hit(vector<vector<double>> &traj, int d_orient, double x_det, double y_det, double y_detMin, double y_detMax, double x_detMin, double x_detMax) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = 0;
    double y_best = 0;
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_i >= x_det && (y_i >= y_detMin && y_i <= y_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_i >= y_det && (x_i >= x_detMin && x_i <= x_detMax))) {
                t_best = 0;
                x_best = x_i;
                y_best = y_i;
            }
        }
    }
    return y_best;
}
