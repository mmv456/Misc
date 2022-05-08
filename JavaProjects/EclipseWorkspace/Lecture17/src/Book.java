import tester.*;


// Represents authors of books
class Author {
	String first;
	String last;
	int yob;
	IList<Book> book;
	Author(String fst, String lst, int yob) {
		this.first = fst;
		this.last = lst;
		this.yob = yob;
		this.book = new MtList<Book>();
	}

	boolean sameAuthor(Author that) {
		return this.first == that.first && 
				this.last == that.last && 
				this.yob == that.yob;
	}

	// EFFECT: modifies this Author's book field to refer to the given book
	void addBook(Book b) {
		if(!b.author.sameAuthor(this)) {
			throw new RuntimeException("book was not written by this author");
		}
		else {
			this.book = new ConsList<Book>(b, this.book);
		}
		
	}
}

// Represent books
class Book {
	String title;
	int price;
	int quantity;
	Author author;
	Book(String title, int price, int quantity, Author ath) {
		this.title = title;
		this.price = price;
		this.quantity = quantity;
		this.author = ath;
	}

	boolean sameBook(Book that) {
		return this.title == that.title && 
				this.price == that.price && 
				this.quantity == that.quantity &&
				this.author == that.author;
	}
}

interface IList<T> {
	
}
class MtList<T> implements IList<T> {
	MtList(){}
}
class ConsList<T> implements IList<T>{
	T first;
	IList<T> rest;
	ConsList(T first, IList<T> rest) {
		this.first = first;
		this.rest = rest;
	}
}


class ExampleBooks {
	Author knuth;
	Book taocp1, taocp2;

	// EFFECT: Sets up the initial conditions for our tests, by re-initializing
	// knuth, taocp1 and taocp2
	void initTestConditions() {
		this.knuth = new Author("Donald", "Knuth", 1938);
		this.taocp1 =
				new Book("The Art of Computer Programming (volume 1)", 100, 2, this.knuth);
		this.taocp2 =
				new Book("The Art of Computer Programming (volume 2)", 120, 3, this.knuth);
	}
	boolean testTaocp1(Tester t) {
		// 1. Set up the initial conditions
		this.initTestConditions();
		// 2. Modify them
		this.knuth.addBook(this.taocp1);
		// 3. Check that the expected changes have occurred
		return
				t.checkExpect(this.knuth.book, this.taocp1) &&
				t.checkExpect(this.knuth.book.author, this.knuth);
	}
	boolean testTaocp2(Tester t) {
		// 1. Set up the initial conditions
		this.initTestConditions();
		// 2. Modify them
		this.knuth.addBook(this.taocp2);
		// 3. Check that the expected changes have occurred
		return
				t.checkExpect(this.knuth.book, this.taocp2) &&
				t.checkExpect(this.knuth.book.author, this.knuth);
	}
}