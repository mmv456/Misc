import tester.*;
import java.util.ArrayList;

interface IFunc<T, U> {
	U apply(T t);
}

class Squared implements IFunc<Integer, Integer> {
	public Integer apply(Integer i) {
		return i*i;
	}
}

class ArrayUtils {
	<T, U> ArrayList<U> buildList(int n, IFunc<Integer, U> func) {
		ArrayList<U> result = new ArrayList<U>();
		for(int i = 0; i < n; i++) {
			result.add(func.apply(i));
		}
		return result;
	}
}