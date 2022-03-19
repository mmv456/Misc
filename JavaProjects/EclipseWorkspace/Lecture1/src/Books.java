// to represent a book in a bookstore
class Book {
	String title;
	Author author;
	Publisher publisher;
	int price;
	
	// the constructor
	Book(String title, Author author, Publisher publisher, int price) {
		this.title = title;
		this.author = author;
		this.publisher = publisher;
		this.price = price;
	}
}

// to represent an author of a book in a bookstore
class Author {
	String name;
	int yob;
	
	// the constructor
	Author(String name, int yob) {
		this.name = name;
		this.yob = yob;
	}
}

// to represent a publisher of a book in a bookstore
class Publisher {
	String name;
	int yearOfFounding;
	
	// the constructor
	Publisher(String name, int yearOfFounding) {
		this.name = name;
		this.yearOfFounding = yearOfFounding;
	}
}

// examples and tests for the classes that represent books and authors
class ExamplesBooks {
	ExamplesBooks() {}
	
	Author pat = new Author("Pat Conroy", 1948);
	Publisher scholastic = new Publisher("Scholastic", 1980);
	Book beaches = new Book("Beaches", this.pat, this.scholastic, 20);
}