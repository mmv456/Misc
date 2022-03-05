//import tester.*;

// to represent a dog
class Dog {
	
	String name;
	String breed;
	int yob;
	String state;
	boolean hypoallergenic;
	
	Dog(String name, String breed, int yob, String state, boolean hypoallergenic) {
		this.name = name;
		this.breed = breed;
		this.yob = yob;
		this.state = state;
		this.hypoallergenic = hypoallergenic;
	}
}

// to represent examples and tests for dogs
class ExamplesDogs {
	Dog huffle = new Dog("Hufflepuff", "Wheaten Terrier", 2012, "TX", true);
	Dog pearl = new Dog("Pearl", "Labrador Retriever", 2016, "MA", false);
	Dog jai = new Dog("Jai", "Golden Doodle", 2019, "MA", false);
	Dog thunderbolt = new Dog("Thunderbolt", "Black Lab", 2004, "MA", true);
}