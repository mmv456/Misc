import tester.*;

class Book {
	String title;
	String author;
	int year;
	double price;
	
	Book(String title, String author, int year, double price) {
		this.title = title;
		this.author = author;
		this.year = year;
		this.price = price;
	}
	
	// compute the sale price of this Book using the given discount rate (as a percentage)
	double salePrice(int discount) {
		return this.price - (this.price * discount) / 100;
	}
	
	// was this book published before the given year?
	boolean publishedBefore(int year) {
		return this.year < year;
	}
	
	// is the price of this book cheaper than the price of the given book?
	boolean cheaperThan(Book that) {
		return this.price < that.price;
	}
	
	// is the title of this book lower than the title of the given book?
	boolean titleLowerThan(Book that) {
		if (this.title.compareTo(that.title) <= 0) {
			return true;
		}
		else {
			return false;
		}
	}
}

interface ILoBook {
	// count the books in this list
	int count();
	
	// calculate the total sale price of all books in this list for a given discount
	double salePrice(int discount);

	// produce a list of all books published before the given date from this list of books 
	ILoBook allBefore(int year);
	
	// produce a list of all books in this list, sorted by their price
	ILoBook sortByPrice();
	
	// insert the given book into this list of books already sorted by price
	ILoBook insertByPrice(Book b);
	
	// produce a list of all books in this list, sorted by their title
	ILoBook sortByTitle();
	
	// insert the given book into this list of books already sorted by title
	ILoBook insertByTitle(Book b);
}

class MtLoBook implements ILoBook {
	MtLoBook() {};
	
	// count the books in this list
	// ex. mtlist.count() -> 0
	public int count() {
		return 0;
	}
	
	// calculate the total sale price of all books in this list for a given discount
	// ex. mtlist.salePrice() -> 0
	public double salePrice(int discount) {
		return 0;
	}
	
	// produce a list of all books published before the given date from this list of books
	// ex. mtlist.allBefore(2000) -> mtlist
	public ILoBook allBefore(int year) {
		return this;
	}
	
	// produce a list of all books in this list, sorted by their price
	// ex. mtlist.sortByPrice() -> mtlist
	public ILoBook sortByPrice() {
		return this;
	}
	
	// insert the given book into this list of books already sorted by price
	public ILoBook insertByPrice(Book b) {
		return new ConsLoBook(b, this);
	}
	
	// produce a list of all books in this list, sorted by their title
	public ILoBook sortByTitle() {
		return this;
	}
	
	// insert the given book into this list of books already sorted by title
	public ILoBook insertByTitle(Book b) {
		return new ConsLoBook(b, this);
	}
}

class ConsLoBook implements ILoBook {
	Book first;
	ILoBook rest;
	
	ConsLoBook(Book first, ILoBook rest) {
		this.first = first;
		this.rest = rest;
	}
	
	/*
	 * TEMPLATE
	 * 
	 * Fields:
	 * ... this.first ...						-- Book
	 * ... this.rest ...						-- ILoBook
	 * 
	 * Methods:
	 * ... this.count() ...						-- int
	 * ... this.salePrice(int discount) ...		-- double
	 * ... this.allBefore(int year) ...			-- ILoBook
	 * ... this.sortByPrice() ...				-- ILoBook
	 * 
	 * Methods for Fields:
	 * ... this.rest.count() ...				-- int
	 * ... this.rest.salePrice(int discount) ...-- double
	 * ... this.rest.allBefore(int year) ...	-- ILoBook
	 * ... this.rest.sortByPrice() ...			-- ILoBook
	 * ... this.insert(Book b) ...				-- ILoBook
	 */
	
	// count the books in this list
	// ex. lista.count() -> 1
	//	   listc.count() -> 3
	public int count() {
		return 1 + this.rest.count();
	}
	
	// calculate the total sale price of all books in this list for a given discount
	// ex. lista.salePrice() -> 25
	//	   listd.salePrice() -> 95
	public double salePrice(int discount) {
		return this.first.salePrice(discount) + this.rest.salePrice(discount);
	}
	
	// produce a list of all books published before the given date from this list of books
	// ex. lista.allBefore(2000) -> lista
	//	   listb.allBefore(2000) -> mtlist
	//	   listc.allBefore(2000) -> new ConsLoBook(lpp, new ConsLoBook(ll, mtlist));
	public ILoBook allBefore(int year) {
		if (this.first.publishedBefore(year)) {
			return new ConsLoBook(this.first, this.rest.allBefore(year));
		}
		else {
			return this.rest.allBefore(year);
		}
	}
	
	// produce a list of all books in this list, sorted by their price
	public ILoBook sortByPrice() {
		return this.rest.sortByPrice().insertByPrice(this.first);
	}
	
	// inserts the book into its correct place by price in the list of books
	// ex. list(1, 2, 3).insert(1.5) -> list(1, 1.5, 2, 3)
	public ILoBook insertByPrice(Book b) {
		if (this.first.cheaperThan(b)) {
			return new ConsLoBook(this.first, this.rest.insertByPrice(b));
		}
		else {
			return new ConsLoBook(b, this);
		}
	}
	
	// produce a list of all books in this list, sorted by their title
	public ILoBook sortByTitle() {
		return this.rest.sortByTitle().insertByTitle(this.first);
	}
	
	// insert the given book into this list of books already sorted by title
	public ILoBook insertByTitle(Book b) {
		if(this.first.titleLowerThan(b)) {
			return new ConsLoBook(this.first, this.rest.insertByTitle(b));
		}
		else {
			return new ConsLoBook(b, this);
		}
	}
}

class ExamplesLoBooks {
	ExamplesLoBooks() {}
	
	// Books
	Book htdp = new Book("HTDP", "MF", 2001, 60);
	Book lpp = new Book("LPP", "STX", 1942, 25);
	Book ll = new Book("LL", "FF", 1986, 10);
	
	// test the method salePrice for the class Book
	boolean testSalePrice(Tester t) {
		return t.checkExpect(this.htdp.salePrice(10), 54.0) &&
			   t.checkExpect(this.lpp.salePrice(50), 12.5) &&
			   t.checkExpect(this.ll.salePrice(100), 0.0);
	}
	
	// test the method publishedBefore for the class Book
	boolean testPublishedBefore(Tester t) {
		return t.checkExpect(this.htdp.publishedBefore(2000), false) &&
			   t.checkExpect(this.lpp.publishedBefore(2000), true) &&
			   t.checkExpect(this.ll.publishedBefore(2000), true);
	}
	
	// test the method cheaperThan for the class Book
	boolean testCheaperThan(Tester t) {
		return t.checkExpect(this.htdp.cheaperThan(this.lpp), false) &&
			   t.checkExpect(this.ll.cheaperThan(this.lpp), true);
	}
	
	// test the method titleLowerThan for the class Book
	boolean testTitleLowerThan(Tester t) {
		return t.checkExpect(this.lpp.titleLowerThan(this.ll), false) &&
			   t.checkExpect(this.htdp.titleLowerThan(this.lpp), true);
	}
	
	// Lists of Books
	ILoBook mtlist = new MtLoBook();
	ILoBook lista = new ConsLoBook(this.lpp, this.mtlist);
	ILoBook listb = new ConsLoBook(this.htdp, this.mtlist);
	ILoBook listc = new ConsLoBook(this.lpp, 
					new ConsLoBook(this.ll, this.listb));
	ILoBook listd = new ConsLoBook(this.ll, 
					new ConsLoBook(this.lpp, 
					new ConsLoBook(this.htdp, this.mtlist)));
	ILoBook listUnsorted = new ConsLoBook(this.ll, 
						   new ConsLoBook(this.lpp, 
						   new ConsLoBook(this.htdp, this.mtlist)));
	
	// tests for the method count
	boolean testCount(Tester t) {
		return
				t.checkExpect(this.mtlist.count(), 0) &&
				t.checkExpect(this.lista.count(), 1) &&
				t.checkExpect(this.listd.count(), 3);
	}
	
	// tests for the method salePrice
	boolean testLoBookSalePrice(Tester t) {
		return
				// no discount -- full price
				t.checkInexact(this.mtlist.salePrice(0), 0.0, 0.001) &&
				t.checkInexact(this.lista.salePrice(0), 25.0, 0.001) &&
				t.checkInexact(this.listc.salePrice(0), 95.0, 0.001) &&
				t.checkInexact(this.listd.salePrice(0), 95.0, 0.001) &&
				// 50% off sale -- half price
				t.checkInexact(this.mtlist.salePrice(50), 0.0, 0.001) &&
				t.checkInexact(this.lista.salePrice(50), 12.5, 0.001) &&
				t.checkInexact(this.listc.salePrice(50), 47.5, 0.001) &&
				t.checkInexact(this.listd.salePrice(50), 47.5, 0.001);
	}
	
	// tests for the method allBefore
	boolean testAllBefore(Tester t) {
		return
				t.checkExpect(this.mtlist.allBefore(2001), this.mtlist) &&
				t.checkExpect(this.lista.allBefore(2001), this.lista) &&
				t.checkExpect(this.listb.allBefore(2001), this.mtlist) &&
				t.checkExpect(this.listc.allBefore(2001), 
						new ConsLoBook(this.lpp, 
								new ConsLoBook(this.ll, this.mtlist))) &&
				t.checkExpect(this.listd.allBefore(2001), 
						new ConsLoBook(this.ll, 
								new ConsLoBook(this.lpp, this.mtlist)));
	}
	
	// test the method sortByPrice for the lists of books
	boolean testSortByPrice(Tester t) {
		return
				t.checkExpect(this.listc.sortByPrice(), this.listd) &&
				t.checkExpect(this.listUnsorted.sortByPrice(), this.listd);
	}
	
	// test the method sortByTitle for the lists of books
	boolean testSortByTitle(Tester t) {
		return
				t.checkExpect(this.mtlist.sortByTitle(), this.mtlist) &&
				t.checkExpect(new ConsLoBook(this.ll, 
						      new ConsLoBook(this.htdp, this.mtlist)).sortByTitle(), 
							  new ConsLoBook(this.htdp, 
							  new ConsLoBook(this.ll, this.mtlist)));
	}
}







