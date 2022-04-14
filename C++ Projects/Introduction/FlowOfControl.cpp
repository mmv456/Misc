#include <iostream>
using std::cout;
using std::cin;

int main3() {
	int firstNumber;
	int secondNumber;
	cout << "Enter a number: ";
	cin >> firstNumber;
	cout << "You entered " << firstNumber << ". Enter another number: ";
	cin >> secondNumber;

	if (firstNumber < secondNumber) {
		cout << "The first number, " << firstNumber << ", is less than the second number, " << secondNumber;
	}
	if (firstNumber == secondNumber) {
		cout << "The first number, " << firstNumber << ", is equal to the second number, " << secondNumber;
	}
	if (firstNumber > secondNumber) {
		cout << "The first number, " << firstNumber << ", is greater than the second number, " << secondNumber;
	}
	return 0;

}