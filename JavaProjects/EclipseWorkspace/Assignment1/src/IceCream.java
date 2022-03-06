interface IceCream {
}

class EmptyServing implements IceCream {
	Boolean cone;
	
	EmptyServing(Boolean cone) {
		this.cone = cone;
	}
}

class Scooped implements IceCream {
	IceCream more;
	String flavor;
	
	Scooped(IceCream more, String flavor) {
		this.more = more;
		this.flavor = flavor;
	}
}

class ExmaplesIceCream {
	
	IceCream cone = new EmptyServing(true);
	
	IceCream mintchip = new Scooped(cone, "Mint Chip");
	IceCream coffee = new Scooped(mintchip, "Coffee");
	IceCream blackraspberry = new Scooped(coffee, "Black Raspberry");
	IceCream caramelswirl = new Scooped(blackraspberry, "Caramel Swirl");
	
	IceCream chocolate = new Scooped(cone, "Chocolate");
	IceCream vanilla = new Scooped(chocolate, "Vanilla");
	IceCream strawberry = new Scooped(vanilla, "Strawberry");
}