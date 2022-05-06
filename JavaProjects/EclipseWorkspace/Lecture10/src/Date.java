import tester.*;

// to represent a Date
class Date {
	int year;
	int month;
	int day;
	
	Date(int year, int month, int day) {
		this.year = new Utils().checkRange(year, 1500, 2100, "Invalid year: ");
		this.month = new Utils().checkRange(month, 1, 12, "Invalid month: ");
		this.day = new Utils().checkRange(day, 1, 31, "Invalid day: ");
	}
	Date(int month, int day) {
		this(2022, month, day);
	}
}

class Utils {
	int checkRange(int value, int min, int max, String message) {
		if(value >= min && value <= max) {
			return value;
		}
		else {
			throw new IllegalArgumentException(message + Integer.toString(value));
		}
	}
}

class ExamplesDates {
	ExamplesDates() {}
	
	// Good dates
	Date d20100228 = new Date(2010, 2, 28);   // Feb 28, 2010
	Date d20091012 = new Date(2009, 10, 12);  // Oct 12, 2009
	 
	boolean testConstructorException(Tester t) {
		return t.checkConstructorException(
			     // the expected exception
			     new IllegalArgumentException("Invalid year: 53000"),
			     // the *name* of the class (as a String) whose constructor we invoke
			     "Date",
			     // the arguments for the constructor
			     53000, 12, 30);
	}

}