import tester.*;

class Person {
	String name;
	int phone;
	Person(String name, int phone) {
		this.name = name;
		this.phone = phone;
	}
	// Returns true when the given person has the same name and phone number as this person
	boolean samePerson(Person that) {
		return this.name.equals(that.name) && this.phone == that.phone;
	}

	// EFFECT: changes the person's phone number to the new given phone number
	void changeNum(int newNum) {
		this.phone = newNum;
	}
}

interface ILoPerson {
	// Returns true if this list contains a person with the given name
	boolean contains(String name);
	// Finds the person in this list with the given name and returns their phone number,
	// or -1 if no such person is found
	int findPhoneNum(String name);
	// finds given person in list
	Person find(String name);
	// EFFECT: Change the phone number for the person in this list with the given name
	void changePhone(String name, int newNum);
	// EFFECT: modifies this list and removes the person with the given name from it
	void removePerson(String name);
	void removePersonHelp(String name, ConsLoPerson prev);

}

class MtLoPerson implements ILoPerson {
	public boolean contains(String name) {
		return false;
	}
	// Finds the person in this list with the given name and returns their phone number,
	// or -1 if no such person is found
	public int findPhoneNum(String name) {
		return -1;
	}
	// finds given person in list
	public Person find(String name) {
		throw new RuntimeException("There are no people in an empty list");
	}
	// EFFECT: Change the phone number for the person in this list with the given name
	public void changePhone(String name, int newNum) {
		throw new RuntimeException("There are no people in an empty list");
	}
	// EFFECT: modifies this list and removes the person with the given name from it
	public void removePerson(String name) {
		throw new RuntimeException("There are no people in an empty list");
	}
	public void removePersonHelp(String name, ConsLoPerson prev) {
		throw new RuntimeException("There are no people in an empty list");
	}
}

class ConsLoPerson implements ILoPerson {
	Person first;
	ILoPerson rest;

	ConsLoPerson(Person first, ILoPerson rest) {
		this.first = first;
		this.rest = rest;
	}

	public boolean contains(String name) {
		return this.first.name.equals(name) || this.rest.contains(name);
	}
	// Finds the person in this list with the given name and returns their phone number,
	// or -1 if no such person is found
	public int findPhoneNum(String name) {
		if (this.contains(name)) {
			return this.find(name).phone;
		}
		else {
			return -1;
		}
	}
	// finds given person in list
	public Person find(String name) {
		if(this.first.name.equals(name)) {
			return first;
		}
		else {
			return this.rest.find(name);
		}
	}
	// EFFECT: Change the phone number for the person in this list with the given name
	public void changePhone(String name, int newNum) {
		this.find(name).changeNum(newNum);
	}
	// EFFECT: modifies this list and removes the person with the given name from it
	public void removePerson(String name) {
		this.rest.removePersonHelp(name, this);
	}
	public void removePersonHelp(String name, ConsLoPerson prev) {
		if(this.first.name.equals(name)) {
			prev.rest = this.rest;
		}
		else {
			this.rest.removePersonHelp(name, this);
		}
	}
}


class ExamplesPhoneLists {

	Person anne, bob, clyde, dana, eric, frank, gail, henry, irene, jenny;
	ILoPerson friends, family, work;

	void initData() {
		this.anne = new Person("Anne", 1234);
		this.bob = new Person("Bob", 3456);
		this.clyde = new Person("Clyde", 6789);
		this.dana = new Person("Dana", 1357);
		this.eric = new Person("Eric", 12469);
		this.frank = new Person("Frank", 7294);
		this.gail = new Person("Gail", 9345);
		this.henry = new Person("Henry", 8602);
		this.irene = new Person("Irene", 91302);
		this.jenny = new Person("Jenny", 8675309);

		this.friends =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.gail, new ConsLoPerson(this.frank,
								new ConsLoPerson(this.jenny, new MtLoPerson())))));
		this.family =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.dana,
						new ConsLoPerson(this.frank, new MtLoPerson())));
		this.work =
				new ConsLoPerson(this.bob, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.dana, new ConsLoPerson(this.eric,
								new ConsLoPerson(this.henry, new ConsLoPerson(this.irene,
										new MtLoPerson()))))));
	}

	void initData2() {
		this.anne = new Person("Anne", 1234);
		this.bob = new Person("Bob", 3456);
		this.clyde = new Person("Clyde", 6789);
		this.dana = new Person("Dana", 1357);
		this.eric = new Person("Eric", 12469);
		this.frank = new Person("Frank", 7294);
		this.gail = new Person("Gail", 9345);
		this.henry = new Person("Henry", 8602);
		this.irene = new Person("Irene", 91302);
		this.jenny = new Person("Jenny", 8675309);

		// ... initialize Anne, Bob, etc...
		this.work =
				new ConsLoPerson(this.bob, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.dana, new ConsLoPerson(this.eric,
								new ConsLoPerson(this.frank, new MtLoPerson())))));
		// We're friends with everyone at work, and also with other people
		this.friends =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.gail,
						new ConsLoPerson(this.henry, this.work)));
	}

	// In ExamplePhoneLists
	void testFindPhoneNum(Tester t) {
		this.initData();
		t.checkExpect(this.friends.contains("Frank"), true);
		t.checkExpect(this.work.contains("Zelda"), false);

		this.initData();
		// Should be able to find the correct number of someone in a list
		t.checkExpect(this.friends.findPhoneNum("Frank"), 7294);
		// Should return -1 for someone not in a list
		t.checkExpect(this.work.findPhoneNum("Zelda"), -1);
		// When someone is in two lists, their number should be the same in both
		t.checkExpect(this.friends.findPhoneNum("Anne"),
				this.family.findPhoneNum("Anne"));
	}

	void testChangeNum(Tester t) {
		this.initData();
		t.checkExpect(this.frank.phone, 7294);
		this.frank.changeNum(9021);
		t.checkExpect(this.frank.phone, 9021);
	}

	void testFindPhoneNum2(Tester t) {
		this.initData();
		t.checkExpect(this.friends.findPhoneNum("Frank"), 7294);
		t.checkExpect(this.family.findPhoneNum("Frank"),
				this.friends.findPhoneNum("Frank"));
		t.checkExpect(this.frank.phone, 7294);
		this.family.changePhone("Frank", 9021);
		t.checkExpect(this.friends.findPhoneNum("Frank"), 9021);
		t.checkExpect(this.family.findPhoneNum("Frank"),
				this.friends.findPhoneNum("Frank"));
		t.checkExpect(this.frank.phone, 9021);
	}

	// Tests removing the first person in a list
	void testRemoveFirstPerson(Tester t) {
		this.initData();
		ILoPerson list1 =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.henry, new MtLoPerson())));
		ILoPerson list2 =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.dana,
						new ConsLoPerson(this.gail, new MtLoPerson())));
		// Check initial conditions
		t.checkExpect(list1.contains("Anne"), true);
		t.checkExpect(list2.contains("Anne"), true);
		// Modify list1
		list1.removePerson("Anne");
		// Check that list1 has been modified...
		t.checkExpect(list1.contains("Anne"), false);
		// ...but that list2 has not
		t.checkExpect(list2.contains("Anne"), true);
	}
	// Tests removing a middle person in a list
	void testRemoveMiddlePerson(Tester t) {
		this.initData();
		ILoPerson list1 =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.henry, new MtLoPerson())));
		ILoPerson list2 =
				new ConsLoPerson(this.dana, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.gail, new MtLoPerson())));
		// Check initial conditions
		t.checkExpect(list1.contains("Clyde"), true);
		t.checkExpect(list2.contains("Clyde"), true);
		// Modify list1
		list1.removePerson("Clyde");
		// Check that list1 has been modified...
		t.checkExpect(list1.contains("Clyde"), false);
		// ...but that list2 has not
		t.checkExpect(list2.contains("Clyde"), true);
	}
	// Tests removing the last person in a list
	void testRemoveLastPerson(Tester t) {
		this.initData();
		ILoPerson list1 =
				new ConsLoPerson(this.anne, new ConsLoPerson(this.clyde,
						new ConsLoPerson(this.henry, new MtLoPerson())));
		ILoPerson list2 =
				new ConsLoPerson(this.dana, new ConsLoPerson(this.gail,
						new ConsLoPerson(this.henry, new MtLoPerson())));
		// Check initial conditions
		t.checkExpect(list1.contains("Henry"), true);
		t.checkExpect(list2.contains("Henry"), true);
		// Modify list1
		list1.removePerson("Henry");
		// Check that list1 has been modified...
		t.checkExpect(list1.contains("Henry"), false);
		// ...but that list2 has not
		t.checkExpect(list2.contains("Henry"), true);
	}


	void testRemoveCoworker(Tester t) {
		  this.initData2();
		  // Test that Eric is a coworker and a friend
		  t.checkExpect(this.work.findPhoneNum("Eric"), this.eric.phone);
		  t.checkExpect(this.friends.findPhoneNum("Eric"), this.eric.phone);
		  // Remove Eric from coworkers
		  this.work.removePerson("Eric");
		  // Check that Eric is no longer a coworker
		  t.checkExpect(this.work.findPhoneNum("Eric"), -1);
		  // Check that Eric is still a friend
		  t.checkExpect(this.friends.findPhoneNum("Eric"), this.eric.phone);
		}
}