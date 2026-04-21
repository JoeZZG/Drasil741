#include "OutputFormat.hpp"

#include <fstream>
#include <iostream>
#include <string>
#include <vector>

using std::ofstream;
using std::string;
using std::vector;

void write_output(vector<double> &s, double t_hit, double x_hit, double y_hit) {
    ofstream outputfile;
    outputfile.open("output.txt", std::fstream::out);
    outputfile << "s = ";
    outputfile << "[";
    for (int list_i1 = 0; list_i1 < (int)(s.size()) - 1; list_i1++) {
        outputfile << s.at(list_i1);
        outputfile << ", ";
    }
    if ((int)(s.size()) > 0) {
        outputfile << s.at((int)(s.size()) - 1);
    }
    outputfile << "]" << std::endl;
    outputfile << "t_hit = ";
    outputfile << t_hit << std::endl;
    outputfile << "x_hit = ";
    outputfile << x_hit << std::endl;
    outputfile << "y_hit = ";
    outputfile << y_hit << std::endl;
    outputfile.close();
}
