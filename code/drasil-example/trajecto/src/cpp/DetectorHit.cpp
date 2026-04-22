#include "DetectorHit.hpp"

#include <vector>

using std::vector;

double func_t_hit(vector<vector<double>> &traj, int d_orient, double d_pos, double d_start, double d_len, double t_final) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = -1;
    double y_best = -1;
    double t_step = t_final / (num_pts - 1);
    double x_prev = traj.at(0).at(0);
    double y_prev = traj.at(0).at(1);
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_prev < d_pos && (x_i >= d_pos && (y_i >= d_start && y_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_prev < d_pos && (y_i >= d_pos && (x_i >= d_start && x_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        x_prev = x_i;
        y_prev = y_i;
    }
    return t_best;
}

double func_x_hit(vector<vector<double>> &traj, int d_orient, double d_pos, double d_start, double d_len, double t_final) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = -1;
    double y_best = -1;
    double t_step = t_final / (num_pts - 1);
    double x_prev = traj.at(0).at(0);
    double y_prev = traj.at(0).at(1);
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_prev < d_pos && (x_i >= d_pos && (y_i >= d_start && y_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_prev < d_pos && (y_i >= d_pos && (x_i >= d_start && x_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        x_prev = x_i;
        y_prev = y_i;
    }
    return x_best;
}

double func_y_hit(vector<vector<double>> &traj, int d_orient, double d_pos, double d_start, double d_len, double t_final) {
    int num_pts = (int)(traj.size());
    double t_best = -1;
    double x_best = -1;
    double y_best = -1;
    double t_step = t_final / (num_pts - 1);
    double x_prev = traj.at(0).at(0);
    double y_prev = traj.at(0).at(1);
    for (int i = 0; i < num_pts; i += 1) {
        double x_i = traj.at(i).at(0);
        double y_i = traj.at(i).at(1);
        if (d_orient == 0) {
            if (t_best < 0 && (x_prev < d_pos && (x_i >= d_pos && (y_i >= d_start && y_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        else {
            if (t_best < 0 && (y_prev < d_pos && (y_i >= d_pos && (x_i >= d_start && x_i <= d_start + d_len)))) {
                t_best = i * t_step;
                x_best = x_i;
                y_best = y_i;
            }
        }
        x_prev = x_i;
        y_prev = y_i;
    }
    return y_best;
}
