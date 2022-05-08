import tester.Tester;

interface ILoRunner {
	ILoRunner find(IRunnerPredicate pred);
	ILoRunner sortBy(IRunnerComparator comp);
	ILoRunner insertBy(IRunnerComparator comp, Runner r);
	// Finds the fastest Runner in this list of Runners
	Runner findWinner();
	// Finds the first Runner in this list of Runners
	Runner getFirst();
	Runner findMin(IRunnerComparator comp);
	// Returns the minimum Runner of the given accumulator and every Runner
	// in this list, according to the given comparator
	Runner findMinHelp(IRunnerComparator comp, Runner acc);

}

class MtLoRunner implements ILoRunner {
	MtLoRunner() {	
	}

	public ILoRunner find(IRunnerPredicate pred) {return this;}
	public ILoRunner sortBy(IRunnerComparator comp) {return this;}
	public ILoRunner insertBy(IRunnerComparator comp, Runner r) {return new ConsLoRunner(r, this);}
	// Finds the fastest Runner in this list of Runners
	public Runner findWinner() {
		throw new RuntimeException("No winner of an empty list of Runners");
	}
	// Finds the first Runner in this list of Runners
	public Runner getFirst() {
		throw new RuntimeException("No first of an empty list of Runners");
	}
	public Runner findMin(IRunnerComparator comp) {
		throw new RuntimeException("No minimum of an empty list of Runners");
	}
	// Returns the minimum Runner of the given accumulator and every Runner
	// in this list, according to the given comparator
	public Runner findMinHelp(IRunnerComparator comp, Runner acc) {
		return acc;
	}
}

class ConsLoRunner implements ILoRunner {
	Runner first;
	ILoRunner rest;

	ConsLoRunner(Runner first, ILoRunner rest) {
		this.first = first;
		this.rest = rest;
	}

	public ILoRunner find(IRunnerPredicate pred) {
		if(pred.apply(this.first)) {
			return new ConsLoRunner(this.first, this.rest.find(pred));
		}
		else {
			return this.rest.find(pred);
		}
	}

	public ILoRunner sortBy(IRunnerComparator comp) {
		return this.rest.sortBy(comp).insertBy(comp, this.first);
	}
	public ILoRunner insertBy(IRunnerComparator comp, Runner r) {
		if(comp.compare(this.first, r) < 0) {
			return new ConsLoRunner(this.first, this.rest.insertBy(comp, r));
		}
		else {
			return new ConsLoRunner(r, this);
		}
	}

	/*
	 * public Runner findWinner() { return this.sortBy(new
	 * CompareByTime()).getFirst(); }
	 */

	public Runner findWinner() {
		return this.findMin(new CompareByTime());
	}

	// Finds the first Runner in this list of Runners
	public Runner getFirst() {
		return this.first;
	}

	public Runner findMin(IRunnerComparator comp) {
		return this.rest.findMinHelp(comp, this.first);
	}

	// Returns the minimum Runner of the given accumulator and every Runner
	// in this list, according to the given comparator
	public Runner findMinHelp(IRunnerComparator comp, Runner acc) {
		if(comp.compare(acc, this.first) < 0) {
			return this.rest.findMinHelp(comp, acc);
		}
		else {
			return this.rest.findMinHelp(comp, this.first);
		}
	}
}

class Runner {
	String name;
	int age;
	int bib;
	boolean isMale;
	int pos;
	int time;

	Runner(String name, int age, int bib, boolean isMale, int pos, int time) {
		this.name = name;
		this.age = age;
		this.bib = bib;
		this.isMale = isMale;
		this.pos = pos;
		this.time = time;
	}
}

interface IRunnerPredicate {
	boolean apply(Runner r);
}

class RunnerIsMale implements IRunnerPredicate{
	public boolean apply(Runner r) { return r.isMale; }
}
class RunnerIsFemale implements IRunnerPredicate {
	public boolean apply(Runner r) { return !r.isMale; }
}
class RunnerIsInFirst50 implements IRunnerPredicate {
	public boolean apply(Runner r) { return r.pos <= 50; }
}
class FinishIn4Hours implements IRunnerPredicate {
	public boolean apply(Runner r) { return r.time <= 240; }
}
class RunnerIsYounger40 implements IRunnerPredicate {
	public boolean apply(Runner r) {return r.age <= 40;}
}
//Represents a predicate that is true whenever both of its component predicates are true
class AndPredicate implements IRunnerPredicate {
	IRunnerPredicate left, right;
	AndPredicate(IRunnerPredicate left, IRunnerPredicate right) {
		this.left = left;
		this.right = right;
	}
	public boolean apply(Runner r) {
		return this.left.apply(r) && this.right.apply(r);
	}
}

interface ICompareRunners {
	// Returns true if r1 comes before r2 according to this ordering
	boolean comesBefore(Runner r1, Runner r2);
}
class CompareByTimev0 implements ICompareRunners {
	public boolean comesBefore(Runner r1, Runner r2) {
		return r1.time < r2.time;
	}
}

//To compute a three-way comparison between two Runners
interface IRunnerComparator {
	// Returns a negative number if r1 comes before r2 in this order
	// Returns zero              if r1 is tied with r2 in this order
	// Returns a positive number if r1 comes after  r2 in this order
	int compare(Runner r1, Runner r2);
}
class CompareByTime implements IRunnerComparator {
	public int compare(Runner r1, Runner r2) {
		return r1.time - r2.time;
	}
}
class CompareByName implements IRunnerComparator {
	public int compare(Runner r1, Runner r2) {
		return r1.name.compareTo(r2.name);
	}
}

// examples of runners and tests
class ExamplesRunners {
	Runner johnny = new Runner("Kelly", 97, 999, true, 30, 360);
	Runner frank  = new Runner("Shorter", 32, 888, true, 245, 130);
	Runner bill = new Runner("Rogers", 36, 777, true, 119, 129);
	Runner joan = new Runner("Benoit", 29, 444, false, 18, 155);

	ILoRunner mtlist = new MtLoRunner();
	ILoRunner list1 = new ConsLoRunner(johnny, new ConsLoRunner(joan, mtlist));
	ILoRunner list2 = new ConsLoRunner(frank, new ConsLoRunner(bill, list1));

	boolean testFindMethods(Tester t) {
		return
				t.checkExpect(this.list2.find(new RunnerIsFemale()),
						new ConsLoRunner(this.joan, new MtLoRunner())) &&
				t.checkExpect(this.list2.find(new RunnerIsMale()),
						new ConsLoRunner(this.frank,
								new ConsLoRunner(this.bill,
										new ConsLoRunner(this.johnny, new MtLoRunner()))));
	}

	boolean testFindUnder4Hours(Tester t) {
		return
				t.checkExpect(this.list2.find(new FinishIn4Hours()),
						new ConsLoRunner(this.frank,
								new ConsLoRunner(this.bill,
										new ConsLoRunner(this.joan, new MtLoRunner()))));
	}

	boolean testCombinedQuestions(Tester t) {
		return
				t.checkExpect(this.list2.find(
						new AndPredicate(new RunnerIsMale(), new FinishIn4Hours())),
						new ConsLoRunner(this.frank,
								new ConsLoRunner(this.bill, new MtLoRunner()))) &&
				t.checkExpect(this.list2.find(
						new AndPredicate(new RunnerIsFemale(),
								new AndPredicate(new RunnerIsYounger40(),
										new RunnerIsInFirst50()))),
						new ConsLoRunner(this.joan, new MtLoRunner()));
	}
}