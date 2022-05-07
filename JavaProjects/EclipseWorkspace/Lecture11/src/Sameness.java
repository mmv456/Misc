import tester.*;

// to represent a book
class Book {
	String title;
	Author author;
	Book(String title, Author author) {
		this.title = title;
		this.author = author;
	}

	boolean sameBook(Book that) {
		return this.title.equals(that.title) && this.author.sameAuthor(that.author);
	}
}

// to represent an Author
class Author {
	String first;
	String last;
	Author(String first, String last) {
		this.first = first;
		this.last = last;
	}

	boolean sameAuthor(Author that) {
		return this.first.equals(that.first) && this.last.equals(that.last);
	}
}

// to represent a Cartesian point
class CartPt {
	int x;
	int y;
	CartPt(int x, int y) {
		this.x = x;
		this.y = y;
	}

	boolean sameCartPt(CartPt that) {
		return this.x == that.x && this.y == that.y;
	}
}


interface IShape {
	// is this IShape the same as that IShape?
	boolean sameShape(IShape that);
	// is this shape a Circle?
	boolean isCircle();
	// is this shape a Rect?
	boolean isRect();
	// is this shape a Square?
	boolean isSquare();
}
class Circle implements IShape {
	int x, y;
	int radius;
	Circle(int x, int y, int radius) {
		this.x = x;
		this.y = y;
		this.radius = radius;
	}

	// is this Circle same as that one?
	boolean sameCircle(Circle that) {
		return this.x == that.x && this.y == that.y && this.radius == that.radius;
	}

	// is this Circle the same as that IShape?
	public boolean sameShape(IShape that) {
		if (that.isCircle()) {
			return this.sameCircle((Circle) that);
		}
		else {
			return false;
		}
	}
	
	// is this shape a Circle?
	public boolean isCircle() {
		return true;
	}
	// is this shape a Rect?
	public boolean isRect() {
		return false;
	}
	// is this shape a Square?
	public boolean isSquare() {
		return false;
	}
}
class Rect implements IShape {
	int x, y;
	int w, h;
	Rect(int x, int y, int w, int h) {
		this.x = x;
		this.y = y;
		this.w = w;
		this.h = h;
	}

	// is this Rect same as that one?
	boolean sameRect(Rect that) {
		return this.x == that.x && this.y == that.y && this.w == that.w && this.h == that.h;
	}

	// is this Rect the same as that IShape?
	public boolean sameShape(IShape that) {
		if (that.isRect()) {
			return this.sameRect((Rect) that);
		}
		else {
			return false;
		}
	}
	// is this shape a Circle?
	public boolean isCircle() {
		return false;
	}
	// is this shape a Rect?
	public boolean isRect() {
		return true;
	}
	// is this shape a Square?
	public boolean isSquare() {
		return false;
	}
}

class Square extends Rect {
	Square(int x, int y, int w) {
		super(x, y, w, w);
	}

	// is this Square same as that one?
	boolean sameSquare(Square that) {
		return this.sameRect(that);
	}

	// is this Square the same as that IShape?
	public boolean sameShape(IShape that) {
		if (that.isSquare()) {
			return this.sameSquare((Square) that);
		}
		else {
			return false;
		}
	}
	// is this shape a Circle?
	public boolean isCircle() {
		return false;
	}
	// is this shape a Rect?
	public boolean isRect() {
		return false;
	}
	// is this shape a Square?
	public boolean isSquare() {
		return true;
	}
}






class ExamplesSameness {
	ExamplesSameness() {}

	Author a1 = new Author("Stephen", "King");
	Author a2 = new Author("Stephen", "King");

	Book b1 = new Book("Cell", this.a1);
	Book b2 = new Book("Cell", this.a2);

	CartPt cp1 = new CartPt(1, 2);
	CartPt cp2 = new CartPt(1, 2);

	boolean testSame(Tester t) {
		return t.checkExpect(a1.sameAuthor(a2), true) &&
				t.checkExpect(b1.sameBook(b2), true) &&
				t.checkExpect(cp1.sameCartPt(cp2), true);
	}
	boolean testDifferent(Tester t) {
		return t.checkExpect(a1.sameAuthor(new Author("P", "K")), false) &&
				t.checkExpect(b1.sameBook(new Book("abc", this.a2)), false) &&
				t.checkExpect(new CartPt(3, 4).sameCartPt(new CartPt(6, 7)), false);
	}





	Circle c1 = new Circle(3, 4, 5);
	Circle c2 = new Circle(4, 5, 6);
	Circle c3 = new Circle(3, 4, 5);
	Rect r1 = new Rect(3, 4, 5, 5);
	Rect r2 = new Rect(4, 5, 6, 7);
	Rect r3 = new Rect(3, 4, 5, 5);
	Square s1 = new Square(3, 4, 5);
	Square s2 = new Square(4, 5, 6);
	Square s3 = new Square(3, 4, 5);

	void testShapes(Tester t) {
		t.checkExpect(c1.sameCircle(c2), false);
		t.checkExpect(c2.sameCircle(c1), false);
		t.checkExpect(c1.sameCircle(c3), true);
		t.checkExpect(c3.sameCircle(c1), true);

		t.checkExpect(r1.sameRect(r2), false);
		t.checkExpect(r2.sameRect(r1), false);
		t.checkExpect(r1.sameRect(r3), true);
		t.checkExpect(r3.sameRect(r1), true);

		t.checkExpect(c1.sameShape(c3), true);
		t.checkExpect(c1.sameShape(c2), false);
		t.checkExpect(r1.sameShape(r3), true);
		t.checkExpect(r1.sameShape(r2), false);

		t.checkExpect(c1.sameShape(r1), false);

		// basic checks comparing two Squares should work
		t.checkExpect(s1.sameShape(s2), false);
		t.checkExpect(s2.sameShape(s1), false);
		t.checkExpect(s1.sameShape(s3), true);
		t.checkExpect(s3.sameShape(s1), true);

		// Comparing a Square with a Rect of a different size
		t.checkExpect(s1.sameShape(r2), false);
		t.checkExpect(r2.sameShape(s1), false);
		// Comparing a Square with a Rect of the same size
		t.checkExpect(s1.sameShape(r1), false);
		t.checkExpect(r1.sameShape(s1), false);
	}


}