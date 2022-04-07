import tester.*;

interface List {
	
	// does this list contain a number that's even?
	boolean containsEven();
}

class MTList implements List {
	
	// does this list contain a number that's even?
	public boolean containsEven() {
		return true;
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
	public boolean containsEven() {
		if ((this.first % 2) == 0) {
			return true;
		}
		else {
			return this.rest.containsEven();
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
	
	// Double-Value Lists
	List double_four = new ConsList(4, single_one);
	List double_five = new ConsList(5, single_two);
	List double_one = new ConsList(1, single_three);
	
	// Triple-Value Lists
	List triple_two = new ConsList(2, double_four);
	List triple_nine = new ConsList(9, double_five);
	
	// test the method containsEven
	boolean testContainsEven(Tester t) {
		return t.checkExpect(mt.containsEven(), true) &&
			   t.checkExpect(single_one.containsEven(), false) &&
			   t.checkExpect(double_four.containsEven(), true) &&
			   t.checkExpect(triple_two.containsEven(), true) &&
			   t.checkExpect(triple_nine.containsEven(), true);
	}
}