interface Housing {
	
}

class Hut implements Housing {
	int capacity;
	int population;
	
	Hut(int capacity, int population) {
		
		this.capacity = capacity;
		if (population > capacity) {
			this.population = capacity;
		}
		else {
			this.population = population;
		}
	}
}

class Inn implements Housing {
	String name;
	int capacity;
	int population;
	int stalls;
	
	Inn(String name, int capacity, int population, int stalls) {
		this.name = name;
		this.capacity = capacity;
		if (population > capacity) {
			this.population = capacity;
		}
		else {
			this.population = population;
		}
		this.stalls = stalls;
	}
}

class Castle implements Housing {
	String name;
	String family;
	int population;
	int carriages;
	
	Castle(String name, String family, int population, int carriages) {
		this.name = name;
		this.family = family;
		this.population = population;
		this.carriages = carriages;
	}
}

interface Transportation {
	String from;
	String to;
}

class Horse implements Transportation {
	String name;
	String color;
	
	Horse(String from, String to, String name, String color) {
		this.from = from;
		this.to= to;
		this.name = name;
		this.color = color;
	}
}

class Carriage implements Transportation {
	
}

class ExamplesTravel {
	ExamplesTravel() {}
}