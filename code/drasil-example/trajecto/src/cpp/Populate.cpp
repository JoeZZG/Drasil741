#include "Populate.hpp"

#include <vector>

using std::vector;

Populate::Populate(vector<vector<double>> &s) : s(s) {
}

void Populate::operator()(vector<double> &y, double t) {
    s.push_back(y);
}
