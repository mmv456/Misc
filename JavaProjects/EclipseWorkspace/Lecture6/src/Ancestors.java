import tester.*;

interface IAT {
	// To compute the number of known ancestors of this ancestor tree
	// (excluding this ancestor tree itself)
	int count();
	
	// To compute the number of known ancestors of this ancestor tree 
	// (*including* this ancestor tree itself)
	int countHelp();
	 
	// To compute how many ancestors of this ancestor tree (excluding this
	// ancestor tree itself) are women older than 40 (in the current year)?
	int femaleAndOver40();
	
	// To compute the number of known ancestors of this ancestor tree are women older 
	// than 40 (*including* this ancestor tree itself)
	int femaleAndOver40Help();
	 
	// To compute whether this ancestor tree is well-formed: are all known
	// people younger than their parents?
	boolean wellFormed();
	
	// To determine if this ancestry tree is older than the given year of birth,
	// and its parents are well-formed
	boolean wellFormedHelp(int childYob);
	
	// To return the younger of this ancestor tree and the given ancestor tree
	IAT youngerIAT(IAT other);
	
	// To return either this ancestor tree (if this ancestor tree is younger
	// than the given yob) or the given ancestry tree
	IAT youngerIATHelp(IAT other, int otherYob);
	
	// To compute the youngest parent of this ancestry tree
	IAT youngestParent();
	 
	// To compute this ancestor tree's youngest grandparent
	IAT youngestGrandparent();
	
	// To compute the names of all the known ancestors in this ancestor tree
	// (including this ancestor tree itself)
	//ILoString ancNames();
	 

}

class Unknown implements IAT {
	Unknown() {}
	
	// To compute the number of known ancestors of this ancestor tree
	// (excluding this ancestor tree itself)
	public int count() {
		return 0;
	}
	
	// To compute the number of known ancestors of this ancestor tree 
	// (*including* this ancestor tree itself)
	public int countHelp() {
		return 0;
	}
	
	// To compute how many ancestors of this ancestor tree (excluding this
	// ancestor tree itself) are women older than 40 (in the current year)?
	public int femaleAndOver40() {
		return 0;
	}
	
	// To compute the number of known ancestors of this ancestor tree are women older 
	// than 40 (*including* this ancestor tree itself)
	public int femaleAndOver40Help() {
		return 0;
	}
	
	// To compute whether this ancestor tree is well-formed: are all known
	// people younger than their parents?
	public boolean wellFormed() {
		return true;
	}
	
	// To determine if this ancestry tree is older than the given year of birth,
	// and its parents are well-formed
	public boolean wellFormedHelp(int childYob) {
		return true;
	}

	// To return the younger of this ancestor tree and the given ancestor tree
	public IAT youngerIAT(IAT other) {
		return other;
	}
	
	// To return either this ancestor tree (if this ancestor tree is younger
	// than the given yob) or the given ancestry tree
	public IAT youngerIATHelp(IAT other, int otherYob) {
		return other;
	}
	
	// To compute the youngest parent of this ancestry tree
	public IAT youngestParent() {
		return new Unknown();
	}
	
	// To compute this ancestor tree's youngest grandparent
	public IAT youngestGrandparent() {
		return new Unknown();
	}
}

class Person implements IAT {
	String name;
	int yob;
	boolean isMale;
	IAT mom;
	IAT dad;
	
	Person(String name, int yob, boolean isMale, IAT mom, IAT dad) {
		this.name = name;
		this.yob = yob;
		this.isMale = isMale;
		this.mom = mom;
		this.dad = dad;
	}
	
	// To compute the number of known ancestors of this ancestor tree
	// (excluding this ancestor tree itself)
	public int count() {
		
	    /* Template:
	     * Fields:
	     * this.name -- String
	     * this.yob -- int
	     * this.isMale -- boolean
	     * this.mom -- IAT
	     * this.dad -- IAT
	     * Methods:
	     * this.count() -- int
	     * Methods of fields:
	     * this.mom.count() -- int
	     * this.dad.count() -- int
	     */
		
		return this.mom.countHelp() + this.dad.countHelp();
	}
	
	// To compute the number of known ancestors of this ancestor tree 
	// (*including* this ancestor tree itself)
	public int countHelp() {
		return 1 + this.mom.countHelp() + this.dad.countHelp();
	}
	
	// To compute how many ancestors of this ancestor tree (excluding this
	// ancestor tree itself) are women older than 40 (in the current year)?
	public int femaleAndOver40() {
		return this.mom.femaleAndOver40Help() + this.dad.femaleAndOver40Help();
	}
	
	// To compute the number of known ancestors of this ancestor tree are women older 
	// than 40 (*including* this ancestor tree itself)
	public int femaleAndOver40Help() {
		if (2022 - this.yob > 40 && !this.isMale) {
			return 1 + this.mom.femaleAndOver40Help() + this.dad.femaleAndOver40Help();
		}
		else {
			return this.mom.femaleAndOver40Help() + this.dad.femaleAndOver40Help();
		}
	}

	// To compute whether this ancestor tree is well-formed: are all known
	// people younger than their parents?
	public boolean wellFormed() {
		return this.mom.wellFormedHelp(this.yob) &&
			   this.dad.wellFormedHelp(this.yob);
	}
	
	// To determine if this ancestry tree is older than the given year of birth,
	// and its parents are well-formed
	public boolean wellFormedHelp(int childYob) {
		return this.yob <= childYob &&
			   this.mom.wellFormedHelp(this.yob) &&
			   this.dad.wellFormedHelp(this.yob);
	}
	
	// To return the younger of this ancestor tree and the given ancestor tree
	public IAT youngerIAT(IAT other) {
		return other.youngerIATHelp(this, this.yob);
	}
	
	// To return either this ancestor tree (if this ancestor tree is younger
	// than the given yob) or the given ancestry tree
	public IAT youngerIATHelp(IAT other, int otherYob) {
		if (this.yob > otherYob) {
			return this;
		}
		else {
			return other;
		}
	}
	
	// To compute the youngest parent of this ancestry tree
	public IAT youngestParent() {
		return this.mom.youngerIAT(this.dad);
	}
	
	// To compute this ancestor tree's youngest grandparent
	public IAT youngestGrandparent() {
		return this.mom.youngestParent().youngerIAT(this.dad.youngestParent());
	}
}

interface ILoString {
	
}

class MtLoString implements ILoString {
	MtLoString() {}
}

class ConsLoString implements ILoString {
	String first;
	ILoString rest;
	
	ConsLoString(String first, ILoString rest) {
		this.first = first;
		this.rest = rest;
	}
}

class ExamplesIAT {
    IAT enid = new Person("Enid", 1904, false, new Unknown(), new Unknown());
    IAT edward = new Person("Edward", 1902, true, new Unknown(), new Unknown());
    IAT emma = new Person("Emma", 1906, false, new Unknown(), new Unknown());
    IAT eustace = new Person("Eustace", 1907, true, new Unknown(), new Unknown());
 
    IAT david = new Person("David", 1925, true, new Unknown(), this.edward);
    IAT daisy = new Person("Daisy", 1927, false, new Unknown(), new Unknown());
    IAT dana = new Person("Dana", 1933, false, new Unknown(), new Unknown());
    IAT darcy = new Person("Darcy", 1930, false, this.emma, this.eustace);
    IAT darren = new Person("Darren", 1935, true, this.enid, new Unknown());
    IAT dixon = new Person("Dixon", 1936, true, new Unknown(), new Unknown());
 
    IAT clyde = new Person("Clyde", 1955, true, this.daisy, this.david);
    IAT candace = new Person("Candace", 1960, false, this.dana, this.darren);
    IAT cameron = new Person("Cameron", 1959, true, new Unknown(), this.dixon);
    IAT claire = new Person("Claire", 1956, false, this.darcy, new Unknown());
 
    IAT bill = new Person("Bill", 1980, true, this.candace, this.clyde);
    IAT bree = new Person("Bree", 1981, false, this.claire, this.cameron);
 
    IAT andrew = new Person("Andrew", 2001, true, this.bree, this.bill);
 
    boolean testCount(Tester t) {
        return
            t.checkExpect(this.andrew.count(), 16) &&
            t.checkExpect(this.david.count(), 1) &&
            t.checkExpect(this.enid.count(), 0) &&
            t.checkExpect(new Unknown().count(), 0);
    }
    
    boolean testFemaleAndOver40(Tester t) {
        return
            t.checkExpect(this.andrew.femaleAndOver40(), 8) &&
            t.checkExpect(this.bree.femaleAndOver40(), 3) &&
            t.checkExpect(this.darcy.femaleAndOver40(), 1) &&
            t.checkExpect(this.enid.femaleAndOver40(), 0) &&
            t.checkExpect(new Unknown().femaleAndOver40(), 0);
    }
    
    
    boolean testWellFormed(Tester t) {
        return
            t.checkExpect(this.andrew.wellFormed(), true) &&
            t.checkExpect(new Unknown().wellFormed(), true) &&
            t.checkExpect(
                new Person("Zane", 2000, true, this.andrew, this.bree).wellFormed(),
                false);
    }
    /*
    boolean testAncNames(Tester t) {
        return
            t.checkExpect(this.david.ancNames(),
                new ConsLoString("David",
                    new ConsLoString("Edward", new MtLoString()))) &&
            t.checkExpect(this.eustace.ancNames(),
                new ConsLoString("Eustace", new MtLoString())) &&
            t.checkExpect(new Unknown().ancNames(), new MtLoString());
    }*/
    boolean testYoungestGrandparent(Tester t) {
        return
            t.checkExpect(this.emma.youngestGrandparent(), new Unknown()) &&
            t.checkExpect(this.david.youngestGrandparent(), new Unknown()) &&
            t.checkExpect(this.claire.youngestGrandparent(), this.eustace) &&
            t.checkExpect(this.bree.youngestGrandparent(), this.dixon) &&
            t.checkExpect(this.andrew.youngestGrandparent(), this.candace) &&
            t.checkExpect(new Unknown().youngestGrandparent(), new Unknown());
    }
    
}