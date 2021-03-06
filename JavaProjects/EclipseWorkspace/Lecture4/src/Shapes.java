import tester.*;

// to represent a geometric shape
interface IShape {
	// to compute the area of this shape
	double area();
	// to compute the distance from this shape to the origin
	double distanceToOrigin();
	// to increase the size of this shape by the given increment
	IShape grow(int inc);
	// is the area of this shape bigger than the area of the given shape?
	boolean isBiggerThan(IShape that);
	// is the given point within this shape?
	boolean contains(CartPt point);
}

// to represent a 2d point by Cartesian coordinates
class CartPt {
	int x;
	int y;
	
	CartPt(int x, int y) {
		this.x = x;
		this.y = y;
	}
	
	// to compute the distance from this point to the origin
	double distanceToOrigin() {
		return Math.sqrt(this.x * this.x + this.y * this.y);
	}
	
	// to compute the distance from this point to that point
	double distanceTo(CartPt that) {
		return Math.sqrt((this.x - that.x) * (this.x - that.x) +
						 (this.y - that.y) * (this.y - that.y));
	}
}

// to represent a circle
class Circle implements IShape {
	CartPt center;
	int radius;
	String color;
	
	Circle(CartPt center, int radius, String color) {
		this.center = center;
		this.radius = radius;
		this.color = color;
	}
	
	/*
	 * TEMPLATE
	 * 
	 * Fields:
	 * ... this.center ...		-- CartPt
	 * ... this.radius ...		-- int
	 * ... this.color ...		-- String
	 * 
	 * Methods:
	 * ... this.area() ...		-- double
	 * ... this.distanceToOrigin() ...	-- double
	 * ... this.grow(int) ...		-- IShape
	 * ... this.isBiggerThan(IShape) ...	-- boolean
	 * ... this.contains(CartPt) ...	-- boolean
	 */
	
	// to compute the area of this shape
	public double area() {
		return Math.PI * this.radius * this.radius;
	}
	
	// to compute the distance from this shape to the origin
	public double distanceToOrigin() {
		return this.center.distanceToOrigin();
	}
	
	// to increase the size of this shape by the given increment
	public IShape grow(int inc) {
		return new Circle(this.center, this.radius + inc, this.color);
	}
	
	// is the area of this shape bigger than the area of the given shape?
	public boolean isBiggerThan(IShape that) {
		return this.area() > that.area();
	}
	
	// is the given point within this shape?
	public boolean contains(CartPt point) {
		return this.center.distanceTo(point) < this.radius;
	}
}

// to represent a square
class Square implements IShape {
	CartPt topLeft;
	int size;
	String color;
	
	Square(CartPt topLeft, int size, String color) {
		this.topLeft = topLeft;
		this.size = size;
		this.color = color;
	}
	
	/*
	 * TEMPLATE
	 * 
	 * Fields:
	 * ... this.topLeft ...		-- CartPt
	 * ... this.size ...		-- int
	 * ... this.color ...		-- String
	 * 
	 * Methods:
	 * ... this.area() ...		-- double
	 * ... this.distanceToOrigin() ...	-- double
	 * ... this.grow(int) ...		-- IShape
	 * ... this.isBiggerThan(IShape) ...	-- boolean
	 * ... this.contains(CartPt) ...	-- boolean
	 */
	
	// to compute the area of this shape
	public double area() {
		return this.size * this.size;
	}
	
	// to compute the distance from this shape to the origin
	public double distanceToOrigin() {
		return this.topLeft.distanceToOrigin();
	}
	
	// to increase the size of this shape by the given increment
	public IShape grow(int inc) {
		return new Square(this.topLeft, this.size + inc, this.color);
	}
	
	// is the area of this shape bigger than the area of the given shape?
	public boolean isBiggerThan(IShape that) {
		return this.area() > that.area();
	}
	
	// is the given point within this shape?
	public boolean contains(CartPt point) {
		return (this.topLeft.x <= point.x) &&
			   (point.x <= this.topLeft.x + this.size) &&
			   (this.topLeft.y <= point.y) &&
			   (point.y <= this.topLeft.y + this.size);
	}
}

class ExamplesShapes {
	ExamplesShapes() {}
	
	CartPt pt1 = new CartPt(0, 0);
	CartPt pt2 = new CartPt(3, 4);
	CartPt pt3 = new CartPt(7, 1);
	
	IShape c1 = new Circle(new CartPt(50, 50), 10, "red");
	IShape c2 = new Circle(new CartPt(50, 50), 30, "red");
	IShape c3 = new Circle(new CartPt(30, 100), 30, "blue");
	
	IShape s1 = new Square(new CartPt(50, 50), 30, "red");
	IShape s2 = new Square(new CartPt(50, 50), 50, "red");
	IShape s3 = new Square(new CartPt(20, 40), 10, "green");
	
	// test the method distanceToOrigin in the class CartPt
	boolean testDistanceToOrigin(Tester t) {
		return
				t.checkInexact(this.pt1.distanceToOrigin(), 0.0, 0.01) &&
				t.checkInexact(this.pt2.distanceToOrigin(), 5.0, 0.01) &&
				t.checkInexact(this.pt3.distanceToOrigin(), 7.1, 0.01);
	}
	
	// test the method distanceTo in the class CartPt
	boolean testDistanceTo(Tester t) {
		return
				t.checkInexact(this.pt1.distanceTo(pt2), 5.0, 0.001) &&
				t.checkInexact(this.pt2.distanceTo(pt3), 5.0, 0.001);
	}
	
	// test the method area in the class Circle
	boolean testCircleArea(Tester t) {
		return t.checkInexact(this.c1.area(), 314.15, 0.001);
	}
	
	// test the method area in the class Square
	boolean testSquareArea(Tester t) {
		return t.checkInexact(this.s1.area(), 900.0, 0.001);
	}
	
	// test the method distanceToOrigin in the class Circle
	boolean testCircleDistanceToOrigin(Tester t) {
		return t.checkInexact(this.c1.distanceToOrigin(), 70.71, 0.01) &&
			   t.checkInexact(this.c3.distanceToOrigin(), 104.40, 0.01);
	}
	
	// test the method distanceToOrigin in the class Square
	boolean testSquareDistanceToOrigin(Tester t) {
		return t.checkInexact(this.s1.distanceToOrigin(), 70.71, 0.01) &&
			   t.checkInexact(this.s3.distanceToOrigin(), 44.72, 0.01);
	}
	
	// test the method grow in the class Circle
	boolean testCircleGrow(Tester t) {
		return t.checkExpect(this.c1.grow(20), this.c2);
	}
	
	// test the method grow in the class Square
	boolean testSquareGrow(Tester t) {
		return t.checkExpect(this.s1.grow(20), this.s2);
	}
	
	// test the method isBiggerThan in the class Circle
	boolean testCircleIsBiggerThan(Tester t) {
		return t.checkExpect(this.c1.isBiggerThan(c2), false) &&
			   t.checkExpect(this.c2.isBiggerThan(c1), true) &&
			   t.checkExpect(this.c1.isBiggerThan(s1), false) &&
			   t.checkExpect(this.c1.isBiggerThan(s3), true);
	}
	
	// test the method isBiggerThan in the class Square
	boolean testSquareIsBiggerThan(Tester t) {
		return t.checkExpect(this.s1.isBiggerThan(s2), false) &&
			   t.checkExpect(this.s2.isBiggerThan(s1), true) &&
			   t.checkExpect(this.s1.isBiggerThan(c1), true) &&
			   t.checkExpect(this.s3.isBiggerThan(c1), false);
	}
	
	// test the method contains in the class Circle
	boolean testCircleContains(Tester t) {
		return t.checkExpect(this.c1.contains(new CartPt(100,100)), false) &&
			   t.checkExpect(this.c2.contains(new CartPt(40, 60)), true);
	}
	
	// test the method contains in the class Square
	boolean testSquareContains(Tester t) {
		return t.checkExpect(this.s1.contains(new CartPt(100,100)), false) &&
			   t.checkExpect(this.s2.contains(new CartPt(55, 60)), true);
	}
}