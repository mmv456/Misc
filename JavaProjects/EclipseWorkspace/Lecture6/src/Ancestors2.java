import tester.*;

//------------------- Ancestor Trees -------------------- //
interface IAT2 {
	// To compute the number of known ancestors of this ancestor tree
	// (excluding this ancestor tree itself)
	int count();
	// To compute the number of known ancestors of this ancestor tree 
	// (*including* this ancestor tree itself)
	int countHelp();
	 
	// To compute how many ancestors of this ancestor tree (excluding this
	// ancestor tree itself) are women older than 40 (in the current year)?
	int femaleAncOver40();
	// To compute how many ancestors of this ancestor tree (*including* this ancestor tree itself)
	// are women older than 40 (in the current year).
	int femaleAncOver40Help();
	 
	// To compute whether this ancestor tree is well-formed: are all known
	// people younger than their parents?
	boolean wellFormed();
	// To determine if this ancestry tree is older than the given year of birth,
	// and its parents are well-formed
	boolean wellFormedHelp(int childYob);
	
	// To return the younger of this ancestor tree and the given ancestor tree
	IAT2 youngerIAT(IAT2 other);
	// To return either this ancestor tree (if this ancestor tree is younger
	// than the given yob) or the given ancestry tree
	IAT2 youngerIATHelp(IAT2 other, int otherYob);
	
	// To compute the youngest parent of this ancestry tree
	IAT2 youngestParent();
	
	// To compute the youngest ancestor in the given generation of this ancestry tree
	IAT2 youngestAncInGen(int gen);
	
	// To compute this ancestor tree's youngest grandparent
	IAT2 youngestGrandparent();
	
	// To compute the names of all the known ancestors in this ancestor tree
	// (including this ancestor tree itself)
	//ILoString ancNames();
	
}

class Unknown2 implements IAT2 {
   Unknown2() { }
   
	// To compute the number of known ancestors of this Unknown (excluding this Unknown itself)
	public int count() {
		return 0;
	}
	// To compute the number of known ancestors of this Unknown (*including* this Unknown itself)
	public int countHelp() { 
		return 0; 
	}
	
	// To compute how many ancestors of this Unknown (excluding this Unknown itself)
	// are women older than 40 (in the current year).
	public int femaleAncOver40() {
		return 0;
	}
	// To compute how many ancestors of this Unknown (*including* this Unknown itself)
	// are women older than 40 (in the current year).
	public int femaleAncOver40Help() {
		return 0;
	}

	// To compute whether this Unknown is well-formed: are all known
	// people younger than their parents?
	public boolean wellFormed() {
		return true;
	}
	// To determine if this Unknown is older than the given year of birth,
	// and its parents are well-formed
	public boolean wellFormedHelp(int childYob) { 
		return true; 
	}
	
	// To return the younger of this Unknown and the given ancestor tree
	public IAT2 youngerIAT(IAT2 other) {
		return other;
	}
	// To return either this Unknown (if this Unknown is younger
	// than the given yob) or the given ancestry tree
	public IAT2 youngerIATHelp(IAT2 other, int otherYob) {
		return other;
	}
	
	// To compute the youngest parent of this Unknown
	public IAT2 youngestParent() {
		return new Unknown2();
	}
	
	// To compute the youngest ancestor in the given generation of this Unknown
	public IAT2 youngestAncInGen(int gen) {
		if (gen == 0) {
			return this;
		}
		else {
			return new Unknown2();
		}
	}
	
	// To compute this Unknown's youngest grandparent
	public IAT2 youngestGrandparent() {
		return new Unknown2();
	}
}

class Person2 implements IAT2 {
    String name;
    int yob;
    boolean isMale;
    IAT2 mom;
    IAT2 dad;
    Person2(String name, int yob, boolean isMale, IAT2 mom, IAT2 dad) {
        this.name = name;
        this.yob = yob;
        this.isMale = isMale;
        this.mom = mom;
        this.dad = dad;
    }
    
	// To compute the number of known ancestors of this Person (excluding this Person itself)
	public int count() {
		return this.mom.countHelp() + this.dad.countHelp();
	}
	// To compute the number of known ancestors of this Person (*including* this Person itself)
	public int countHelp() { 
		return 1 + this.mom.countHelp() + this.dad.countHelp();
	}
	
	// To compute how many ancestors of this Person (excluding this Person itself)
	// are women older than 40 (in the current year).
	public int femaleAncOver40() {
		return this.mom.femaleAncOver40Help() + this.dad.femaleAncOver40Help();
	}
	// To compute how many ancestors of this Person (*including* this Person itself)
	// are women older than 40 (in the current year).
	public int femaleAncOver40Help() {
		if ((2015 - this.yob > 40) && (!this.isMale)) {
			return 1 + this.mom.femaleAncOver40Help() + this.dad.femaleAncOver40Help();
		}
		else {
			return this.mom.femaleAncOver40Help() + this.dad.femaleAncOver40Help();
		}
	}
	
	// To compute whether this Person is well-formed: is this
	// person younger than their parents?
	public boolean wellFormed() {
		return this.mom.wellFormedHelp(this.yob) &&
			   this.dad.wellFormedHelp(this.yob);
	}
	// To determine if this Unknown is older than the given year of birth,
	// and its parents are well-formed
	public boolean wellFormedHelp(int childYob) { 
		return this.yob <= childYob &&
			   this.mom.wellFormedHelp(this.yob) &&
			   this.dad.wellFormedHelp(this.yob);
	}
	
	// To return the younger of this Person and the given ancestor tree
	public IAT2 youngerIAT(IAT2 other) {
		return other.youngerIATHelp(this, this.yob);
	}
	// To return either this Person (if this Person is younger
	// than the given yob) or the given ancestry tree
	public IAT2 youngerIATHelp(IAT2 other, int otherYob) {
		if (this.yob > otherYob) {
			return this;
		}
		else {
			return other;
		}
	}
	
	// To compute the youngest parent of this Person
	public IAT2 youngestParent() {
		return this.mom.youngerIAT(this.dad);
	}
	
	// To compute the youngest ancestor in the given generation of this Unknown
	public IAT2 youngestAncInGen(int gen) {
		if (gen == 0) {
			return this;
		}
		else {
			return this.mom.youngestAncInGen(gen - 1).youngerIAT(this.dad.youngestAncInGen(gen - 1));
		}
	}
	
	// To compute this Unknown's youngest grandparent
	public IAT2 youngestGrandparent() {
		return this.youngestAncInGen(2);
	}
}

//------------------- Strings -------------------- //
interface ILoString2 {
}

class ConsLoString2 implements ILoString2 {
    String first;
    ILoString2 rest;
    ConsLoString2(String first, ILoString2 rest) {
        this.first = first;
        this.rest = rest;
    }
}

class MtLoString2 implements ILoString2 {
    MtLoString2() { }
}


// ------------------- Examples -------------------- //
class ExamplesIAT2 {
	
	//   	?-?	  	  ?-?                                                   ?-?                          ?-?      
	//		 Emma - Eustace						    ?-?          ?-?        Enid - ?         ?-?    ? - Edward
	//			Darcy    -     ?		   ?   -   Dixon         Dana     -   Darren         Daisy - David
	//					Claire		-		Cameron                     Candace       -         Clyde
	//							   Bree			        -				             Bill
	//											      Andrew
	
    IAT2 enid = new Person2("Enid", 1904, false, new Unknown2(), new Unknown2());
    IAT2 edward = new Person2("Edward", 1902, true, new Unknown2(), new Unknown2());
    IAT2 emma = new Person2("Emma", 1906, false, new Unknown2(), new Unknown2());
    IAT2 eustace = new Person2("Eustace", 1907, true, new Unknown2(), new Unknown2());
 
    IAT2 david = new Person2("David", 1925, true, new Unknown2(), this.edward);
    IAT2 daisy = new Person2("Daisy", 1927, false, new Unknown2(), new Unknown2());
    IAT2 dana = new Person2("Dana", 1933, false, new Unknown2(), new Unknown2());
    IAT2 darcy = new Person2("Darcy", 1930, false, this.emma, this.eustace);
    IAT2 darren = new Person2("Darren", 1935, true, this.enid, new Unknown2());
    IAT2 dixon = new Person2("Dixon", 1936, true, new Unknown2(), new Unknown2());
 
    IAT2 clyde = new Person2("Clyde", 1955, true, this.daisy, this.david);
    IAT2 candace = new Person2("Candace", 1960, false, this.dana, this.darren);
    IAT2 cameron = new Person2("Cameron", 1959, true, new Unknown2(), this.dixon);
    IAT2 claire = new Person2("Claire", 1956, false, this.darcy, new Unknown2());
 
    IAT2 bill = new Person2("Bill", 1980, true, this.candace, this.clyde);
    IAT2 bree = new Person2("Bree", 1981, false, this.claire, this.cameron);
 
    IAT2 andrew = new Person2("Andrew", 2001, true, this.bree, this.bill);
 
    boolean testCount(Tester t) {
        return
            t.checkExpect(this.andrew.count(), 16) &&
            t.checkExpect(this.david.count(), 1) &&
            t.checkExpect(this.enid.count(), 0) &&
            t.checkExpect(new Unknown2().count(), 0);
    }
    boolean testFemaleAncOver40(Tester t) {
        return
            t.checkExpect(this.andrew.femaleAncOver40(), 7) &&
            t.checkExpect(this.bree.femaleAncOver40(), 3) &&
            t.checkExpect(this.darcy.femaleAncOver40(), 1) &&
            t.checkExpect(this.enid.femaleAncOver40(), 0) &&
            t.checkExpect(new Unknown2().femaleAncOver40(), 0);
    }
    boolean testWellFormed(Tester t) {
        return
            t.checkExpect(this.andrew.wellFormed(), true) &&
            t.checkExpect(new Unknown2().wellFormed(), true) &&
            t.checkExpect(
                new Person2("Zane", 2000, true, this.andrew, this.bree).wellFormed(),
                false);
    }
    boolean testYoungestGrandparent(Tester t) {
    	return
    		t.checkExpect(this.emma.youngestGrandparent(), new Unknown2()) &&
    		t.checkExpect(this.david.youngestGrandparent(), new Unknown2()) &&
    		t.checkExpect(this.claire.youngestGrandparent(), this.eustace) &&
    		t.checkExpect(this.bree.youngestGrandparent(), this.dixon) &&
    		t.checkExpect(this.andrew.youngestGrandparent(), this.candace) &&
    		t.checkExpect(new Unknown2().youngestGrandparent(), new Unknown2());
    }
//    boolean testAncNames(Tester t) {
//        return
//            t.checkExpect(this.david.ancNames(),
//                new ConsLoString2("David",
//                    new ConsLoString2("Edward", new MtLoString2()))) &&
//            t.checkExpect(this.eustace.ancNames(),
//                new ConsLoString2("Eustace", new MtLoString2())) &&
//            t.checkExpect(new Unknown2().ancNames(), new MtLoString2());
//    }

}