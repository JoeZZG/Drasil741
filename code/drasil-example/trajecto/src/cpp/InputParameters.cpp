#include "InputParameters.hpp"

#include <algorithm>
#include <fstream>
#include <iostream>
#include <limits>
#include <string>

#include "Constants.hpp"

using std::ifstream;
using std::string;

void get_input(string filename, double &m, double &q, double &x_0, double &y_0, double &v_x0, double &v_y0, double &N, double &w, double &h, double &x_grid, double &y_grid, double &E_x, double &E_y, double &B, double &d_orient, double &x_det, double &y_det, double &y_min^det, double &y_max^det, double &x_min^det, double &x_max^det, double &t_final) {
    ifstream infile;
    infile.open(filename, std::fstream::in);
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> m;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> q;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> x_0;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> y_0;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> v_x0;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> v_y0;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> N;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> w;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> h;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> x_grid;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> y_grid;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> E_x;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> E_y;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> B;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> d_orient;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> x_det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> y_det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> y_min^det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> y_max^det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> x_min^det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> x_max^det;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> t_final;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.close();
}

void derived_values(double q, double m, double x_0, double y_0, double v_x0, double v_y0, double E_x, double E_y, double B, double x_grid, double y_grid, double w, double h, double d_orient, double x_det, double y_det, double y_min^det, double y_max^det, double x_min^det, double x_max^det, double &κ, double &s_0, double &E_vect, double &B_vect, double &R_i, double &E_vect_i, double &L_det) {
    κ = q / m;
    
    s_0 = {x_0, y_0, v_x0, v_y0};
    
    E_vect = {E_x, E_y, 0.0};
    
    B_vect = {0.0, 0.0, B};
    
    R_i = {x_grid, y_grid, w, h};
    
    E_vect_i = {E_x, E_y, B};
    
    L_det = {d_orient, x_det, y_det, y_min^det, y_max^det, x_min^det, x_max^det};
}

void input_constraints(double m, double q, double x_0, double y_0, double v_x0, double v_y0, double N, double w, double h, double x_grid, double y_grid, double E_x, double E_y, double B, double d_orient, double x_det, double y_det, double y_min^det, double y_max^det, double x_min^det, double x_max^det, double t_final) {
    if (!(Constants::m_min <= m && m <= Constants::m_max)) {
        std::cout << "Warning: ";
        std::cout << "m has value ";
        std::cout << m;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << Constants::m_min;
        std::cout << " (m_min)";
        std::cout << " and ";
        std::cout << Constants::m_max;
        std::cout << " (m_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::q_max <= q && q <= Constants::q_max)) {
        std::cout << "Warning: ";
        std::cout << "q has value ";
        std::cout << q;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::q_max;
        std::cout << " (-q_max)";
        std::cout << " and ";
        std::cout << Constants::q_max;
        std::cout << " (q_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::v_max <= v_x0 && v_x0 <= Constants::v_max)) {
        std::cout << "Warning: ";
        std::cout << "v_x0 has value ";
        std::cout << v_x0;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::v_max;
        std::cout << " (-v_max)";
        std::cout << " and ";
        std::cout << Constants::v_max;
        std::cout << " (v_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::v_max <= v_y0 && v_y0 <= Constants::v_max)) {
        std::cout << "Warning: ";
        std::cout << "v_y0 has value ";
        std::cout << v_y0;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::v_max;
        std::cout << " (-v_max)";
        std::cout << " and ";
        std::cout << Constants::v_max;
        std::cout << " (v_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::E_max <= E_x && E_x <= Constants::E_max)) {
        std::cout << "Warning: ";
        std::cout << "E_x has value ";
        std::cout << E_x;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::E_max;
        std::cout << " (-E_max)";
        std::cout << " and ";
        std::cout << Constants::E_max;
        std::cout << " (E_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::E_max <= E_y && E_y <= Constants::E_max)) {
        std::cout << "Warning: ";
        std::cout << "E_y has value ";
        std::cout << E_y;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::E_max;
        std::cout << " (-E_max)";
        std::cout << " and ";
        std::cout << Constants::E_max;
        std::cout << " (E_max)";
        std::cout << "." << std::endl;
    }
    if (!(-Constants::B_max <= B && B <= Constants::B_max)) {
        std::cout << "Warning: ";
        std::cout << "B has value ";
        std::cout << B;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << -Constants::B_max;
        std::cout << " (-B_max)";
        std::cout << " and ";
        std::cout << Constants::B_max;
        std::cout << " (B_max)";
        std::cout << "." << std::endl;
    }
    if (!(0.0 <= d_orient && d_orient <= 1.0)) {
        std::cout << "Warning: ";
        std::cout << "d_orient has value ";
        std::cout << d_orient;
        std::cout << ", but is suggested to be ";
        std::cout << "between ";
        std::cout << 0.0;
        std::cout << " and ";
        std::cout << 1.0;
        std::cout << "." << std::endl;
    }
    if (!(t_final <= Constants::t_max)) {
        std::cout << "Warning: ";
        std::cout << "t_final has value ";
        std::cout << t_final;
        std::cout << ", but is suggested to be ";
        std::cout << "below ";
        std::cout << Constants::t_max;
        std::cout << " (t_max)";
        std::cout << "." << std::endl;
    }
    
    if (!(m > 0.0)) {
        std::cout << "Warning: ";
        std::cout << "m has value ";
        std::cout << m;
        std::cout << ", but is suggested to be ";
        std::cout << "above ";
        std::cout << 0.0;
        std::cout << "." << std::endl;
    }
    if (!(N > 0.0)) {
        std::cout << "Warning: ";
        std::cout << "N has value ";
        std::cout << N;
        std::cout << ", but is suggested to be ";
        std::cout << "above ";
        std::cout << 0.0;
        std::cout << "." << std::endl;
    }
    if (!(w > 0.0)) {
        std::cout << "Warning: ";
        std::cout << "w has value ";
        std::cout << w;
        std::cout << ", but is suggested to be ";
        std::cout << "above ";
        std::cout << 0.0;
        std::cout << "." << std::endl;
    }
    if (!(h > 0.0)) {
        std::cout << "Warning: ";
        std::cout << "h has value ";
        std::cout << h;
        std::cout << ", but is suggested to be ";
        std::cout << "above ";
        std::cout << 0.0;
        std::cout << "." << std::endl;
    }
    if (!(t_final > 0.0)) {
        std::cout << "Warning: ";
        std::cout << "t_final has value ";
        std::cout << t_final;
        std::cout << ", but is suggested to be ";
        std::cout << "above ";
        std::cout << 0.0;
        std::cout << "." << std::endl;
    }
}
