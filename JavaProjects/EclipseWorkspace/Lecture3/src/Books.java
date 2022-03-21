import tester.*;

// to represent a book in a bookstore
class Book {
	String title;
	Author author;
	int price;
	
	// the constructor
	Book(String title, Author author, int price) {
		this.title = title;
		this.author = author;
		this.price = price;
	}
	
	/*
	 * TEMPLATE:
	 * 
	 * Fields:
	 * ... this.title ...			-- String
	 * ... this.author ...			-- Author
	 * ... this.price ...			-- int
	 * 
	 * Methods:
	 * ... this.salePrice(int) ...	-- int
	 * ... this.sameAuthor(Book) ... -- boolean
	 * ... this.reducePrice() ...	-- Book
	 * 
	 * Methods for fields:
	 * ... this.author.mmm(??) ...	-- ??
	 */
	
	// compute the sale price of this Book using the given discount
	// rate (as a percentage)
	int salePrice(int discount) {
		return this.price - (this.price * discount) / 100;
	}
	
	// Is this book written by the same author as the given book?
	boolean sameAuthor(Book that) {
		/*
		 * TEMPLATE:
		 * 
		 * Methods for fields:
		 * ... this.author.sameAuthor(Author) ...	-- boolean
		 * 
		 * Methods for parameters:
		 * ... that.author.sameAuthor(Author) ...	-- boolean
		 */
		return this.author.sameAuthor(that.author);
	}
	
	// produce a book like this one, but with the price reduced by 20%
	Book reducePrice() {
		return new Book(this.title, this.author, this.salePrice(20));
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
	
	/*
	 * TEMPLATE
	 * 
	 * Fields:
	 * ... this.name ...		-- String
	 * ... this.yob ...			-- int
	 * 
	 * Methods"
	 * ... this.sameAuthor(Author) ...		-- boolean
	 */
	
	// Is this the same author as the given one?
	boolean sameAuthor(Author that) {
		return this.name.equals(that.name)
			&& this.yob == that.yob;
	}
}


// to represent examples of books
class ExamplesBooks {
	ExamplesBooks() {}
	
	// examples of authors
	Author pat = new Author("Pat Conroy", 1948);
	Author dan = new Author("Dan Brown", 1962);
	Author ffk = new Author("FFK", 1990);
	
	// examples of books
	Book beaches = new Book("Beaches", this.pat, 20);
	Book prince = new Book("Prince of Tides", this.pat, 15);
	Book code = new Book("Da Vinci Code", this.dan, 20);
	Book htdp = new Book("HTDP", this.ffk, 60);
	
	// test the method salePrice for the class Book
	boolean testSalePrice(Tester t) {
		return t.checkExpect(this.beaches.salePrice(30), 14) 
			&& t.checkExpect(this.prince.salePrice(20), 12)
			&& t.checkExpect(this.code.salePrice(10), 18);
	}
	
	// test the method sameAuthor in the class Book
	boolean testSameBookAuthor(Tester t) {
		return t.checkExpect(this.beaches.sameAuthor(this.prince), true)
			&& t.checkExpect(this.beaches.sameAuthor(this.code), false);
	}
	
	// test the method reducePrice for the class Book
	boolean testReducePrice(Tester t) {
		return t.checkExpect(this.htdp.reducePrice(),
							 new Book("HTDP", this.ffk, 48))
			&& t.checkExpect(this.beaches.reducePrice(), 
							 new Book("Beaches", this.pat, 16));
	}
}