import java.util.ArrayList;
import tester.*;

interface IFunc<R, A> {
	R apply(A arg);
}

class CountCharacters implements IFunc<Integer, String> {
	public Integer apply(String s) {
		return s.length();
	}
}

class ArrayUtils {
	// EFFECT: Exchanges the values at the given two indices in the given array
	<T> void swap(ArrayList<T> arr, int index1, int index2) {
		arr.set(index2, arr.set(index1, arr.get(index2)));
	}

	<T, U> ArrayList<U> map(ArrayList<T> arr, IFunc<T, U> func) {
		ArrayList<U> result = new ArrayList<U>();
		
		int index = 0;
		
		return this.mapHelper(arr, func, index, result);
	}
	
	<T, U> ArrayList<U> map2(ArrayList<T> arr, IFunc<T, U> func) {
		ArrayList<U> result = new ArrayList<U>();
		
		for (T elem : arr) {
			result.add(func.apply(elem));
		}
		
		return result;
	}
	
	<T, U> ArrayList<U> mapHelper(ArrayList<T> source, IFunc<T, U> func, int curIndex, ArrayList<U> dest) {
		if(curIndex >= source.size()) {
			return dest;
		}
		else {
			dest.add(func.apply(source.get(curIndex)));
			curIndex += 1;
			return this.mapHelper(source, func, curIndex, dest);
		}
	}
}


class ExampleArrayLists {
	void testGet(Tester t) {
		ArrayList<String> someStrings = new ArrayList<String>();
		t.checkException(new IndexOutOfBoundsException("Index: 0, Size: 0"),
				someStrings, "get", 0);
		someStrings.add("First string");
		someStrings.add("Second string");
		t.checkExpect(someStrings.get(0), "First string");
		t.checkExpect(someStrings.get(1), "Second string");
		t.checkException(new IndexOutOfBoundsException("Index: 3, Size: 2"),
				someStrings, "get", 3);
	}

	void testAdd(Tester t) {
		ArrayList<String> someStrings = new ArrayList<String>();
		someStrings.add("First string");
		someStrings.add("Second string");
		t.checkExpect(someStrings.get(0), "First string");
		t.checkExpect(someStrings.get(1), "Second string");

		// Insert this item at index 1, and move everything else back
		someStrings.add(1, "Squeezed in");
		t.checkExpect(someStrings.get(0), "First string");
		t.checkExpect(someStrings.get(1), "Squeezed in");
		t.checkExpect(someStrings.get(2), "Second string");
	}

	void testSwap(Tester t) {
		ArrayList<String> someStrings = new ArrayList<String>();
		someStrings.add("Second string");
		someStrings.add("First string");

		// Do something to fix the list's order

		t.checkExpect(someStrings.get(0), "First string");
		t.checkExpect(someStrings.get(1), "Second string");
	}
}