#include <iostream>
using std::cout;

double add(double one, double two);
double subtract(double one, double two);
double multiply(double one, double two);
double divide(double one, double two);

int main() {
	cout << "Adding 2 + 3 = " << add(2, 3) << "\n";
	cout << "Subtracting 2 - 3 = " << subtract(2, 3) << "\n";
	cout << "Multiplying 2 * 3 = " << multiply(2, 3) << "\n";
	cout << "Dividing 2 / 3 = " << divide(2, 3) << "\n";
}