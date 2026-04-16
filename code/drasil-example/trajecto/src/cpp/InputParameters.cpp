#include "InputParameters.hpp"

#include <algorithm>
#include <fstream>
#include <iostream>
#include <limits>
#include <string>

#include "Constants.hpp"

using std::ifstream;
using std::string;

void get_input(string filename, double &m, double &q, double &x_0, double &y_0, double &v_x0, double &v_y0, double &E_x, double &E_y, double &B, double &t_final) {
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
    infile >> E_x;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> E_y;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> B;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile >> t_final;
    infile.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
    infile.close();
}

void derived_values(double q, double m, double x_0, double y_0, double v_x0, double v_y0, double E_x, double E_y, double B, double &κ, double &s_0, double &E_vect, double &B_vect) {
    κ = q / m;
    
    s_0 = {x_0, y_0, v_x0, v_y0};
    
    E_vect = {E_x, E_y, 0.0};
    
    B_vect = {0.0, 0.0, B};
}

void input_constraints(double m, double q, double x_0, double y_0, double v_x0, double v_y0, double E_x, double E_y, double B, double t_final) {
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
