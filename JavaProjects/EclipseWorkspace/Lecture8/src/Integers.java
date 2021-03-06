import tester.*;

interface List {
	
	// does this list contain a number that's even?
	boolean one_containsEven();
	
	// does this list contain a number that is positive and odd?
	boolean two_containsPositiveOdd();
	
	// does this list contain a number between 5 and 10, inclusive?
	boolean three_between5and10();
	
	// does this list satisfy the three conditions above?
	boolean satisfiesAboveThree();
}

class MTList implements List {
	
	// does this list contain a number that's even?
	public boolean one_containsEven() {
		return false;
	}
	
	// does this list contain a number that is positive and odd?
	public boolean two_containsPositiveOdd() {
		return false;
	}
	
	// does this list contain a number between 5 and 10, inclusive?
	public boolean three_between5and10() {
		return false;
	}
	
	// does this list satisfy the three conditions above?
	public boolean satisfiesAboveThree() {
		return false;
	}
}

class ConsList implements List {
	int first;
	List rest;
	
	// the constructor
	ConsList(int first, List rest) {
		this.first = first;
		this.rest = rest;
	}
	
	// does this list contain a number that's even?
	public boolean one_containsEven() {
		if ((this.first % 2) == 0) {
			return true;
		}
		else {
			return this.rest.one_containsEven();
		}
	}
	
	// does this list contain a number that is positive and odd?
	public boolean two_containsPositiveOdd() {
		if ((this.first % 2 == 1) && (this.first > 0)) {
			return true;
		}
		else {
			return this.rest.two_containsPositiveOdd();
		}
	}
	
	// does this list contain a number between 5 and 10, inclusive?
	public boolean three_between5and10() {
		if ((this.first >= 5) && (this.first <= 10)) {
			return true;
		}
		else {
			return this.rest.three_between5and10();
		}
	}
	
	// does this list satisfy the three conditions above?
	public boolean satisfiesAboveThree() {
		if (this.one_containsEven() && this.two_containsPositiveOdd() && this.three_between5and10()) {
			return true;
		}
		else {
			return false;
		}
	}
}

class ExamplesList {
	ExamplesList() {}
	
	// Empty List
	List mt = new MTList();
	
	// Single-Value Lists
	List single_one = new ConsList(1, mt);
	List single_two = new ConsList(2, mt);
	List single_three = new ConsList(3, mt);
	List single_negative_ten = new ConsList(-10, mt);
	
	// Double-Value Lists
	List double_four = new ConsList(4, single_one);
	List double_five = new ConsList(5, single_two);
	List double_one = new ConsList(1, single_three);
	List double_six = new ConsList(6, single_negative_ten);
	
	// Triple-Value Lists
	List triple_two = new ConsList(2, double_four);
	List triple_nine = new ConsList(9, double_five);
	List triple_negativethree = new ConsList(-3, double_one);
	List triple_five = new ConsList(5, double_six);
	
	// test the method containsEven
	boolean testContainsEven(Tester t) {
		return t.checkExpect(mt.one_containsEven(), false) &&
			   t.checkExpect(single_one.one_containsEven(), false) &&
			   t.checkExpect(double_four.one_containsEven(), true) &&
			   t.checkExpect(triple_two.one_containsEven(), true) &&
			   t.checkExpect(triple_nine.one_containsEven(), true);
	}
	
	// test the method containsPositiveOdd
	boolean testContainsPositiveOdd(Tester t) {
		return t.checkExpect(mt.two_containsPositiveOdd(), false) &&
			   t.checkExpect(single_one.two_containsPositiveOdd(), true) &&
			   t.checkExpect(triple_negativethree.two_containsPositiveOdd(), true);
	}
	
	// test the method between5and10
	boolean testBetween5and10(Tester t) {
		return t.checkExpect(mt.three_between5and10(), false) &&
			   t.checkExpect(single_one.three_between5and10(), false) &&
			   t.checkExpect(double_six.three_between5and10(), true) &&
			   t.checkExpect(triple_nine.three_between5and10(), true);
	}
	
	// test the method satisfiesAboveThree
	boolean testSatisfiesAboveThree(Tester t) {
		return t.checkExpect(mt.satisfiesAboveThree(), false) &&
			   t.checkExpect(single_one.satisfiesAboveThree(), false) &&
			   t.checkExpect(double_one.satisfiesAboveThree(), false) &&
			   t.checkExpect(double_five.satisfiesAboveThree(), true) &&
			   t.checkExpect(triple_two.satisfiesAboveThree(), false) &&
			   t.checkExpect(triple_nine.satisfiesAboveThree(), true);
	}
} 