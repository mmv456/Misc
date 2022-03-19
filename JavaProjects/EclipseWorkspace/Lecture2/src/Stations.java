import tester.*;

// to represent a train station
interface IStation {
	
}

// to represent a subway station
class TStop implements IStation {
	String name;
	String line;
	double price;
	
	// the constructor
	TStop(String name, String line, double price) {
		this.name = name;
		this.line = line;
		this.price = price;
	}
}

// to represent a stop on a commuter line
class CommStation implements IStation {
	String name;
	String line;
	boolean express;
	
	// the constructor
	CommStation(String name, String line, boolean express) {
		this.name = name;
		this.line = line;
		this.express = express;
	}
}

class ExamplesIStation {
	ExamplesIStation() {}
	
	/*
	 * Harvard Station on the Red Line costs $1.25 to enter
	 * Kenmore Station on the Green Line costs $1.25 to enter
	 * Riverside Station on the Green Line costs $2.50 to enter
	 * 
	 * Back Bay Station on the Framingham Line is an express stop
	 * Wet Newton Stop on the Framingham Line is not an express stop
	 * Wellesley Hills on the Worcester Lien is not an express stop
	 */
	
	IStation harvard = new TStop("Harvard", "red", 1.25);
	IStation kenmore = new TStop("Kenmore", "green", 1.25);
	IStation riverside = new TStop("Riverside", "green", 2.50);
	
	IStation backbay = new CommStation("Back Bay", "Framingham", true);
	IStation wnewton = new CommStation("West Newton", "Framingham", false);
	IStation wellhills = new CommStation("Wellesley Hills", "Worcester", false);
	
	
} 