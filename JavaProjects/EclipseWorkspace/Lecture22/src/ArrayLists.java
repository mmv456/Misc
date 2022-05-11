import java.util.ArrayList;
import tester.*;

class ArrayUtils {
	// Returns the index of the target string in the given ArrayList, or -1 if the string is not found
	// Assumes that the given ArrayList is sorted alphabetically
	int binarySearch(ArrayList<String> strings, String target) {
		return binarySearchHelp_v1(strings, target, 0, strings.size() - 1);
	}
	int binarySearch_v2(ArrayList<String> strings, String target) {
		return binarySearchHelp_v2(strings, target, 0, strings.size() - 1);
	}
	// Returns the index of the target string in the given ArrayList, or -1 if the string is not found
	// Assumes that the given ArrayList is sorted alphabetically
	int binarySearchHelp_v1(ArrayList<String> strings, String target, int lowIdx, int highIdx) {
		int midIdx = (lowIdx + highIdx) / 2;
		if (lowIdx > highIdx) {
			return -1;
		}
		else if (target.compareTo(strings.get(midIdx)) == 0) {
			return midIdx;                                                         // found it!
		}
		else if (target.compareTo(strings.get(midIdx)) > 0) {
			return this.binarySearchHelp_v1(strings, target, midIdx + 1, highIdx); // too low
		}
		else {
			return this.binarySearchHelp_v1(strings, target, lowIdx, midIdx - 1);  // too high
		}
	}

	// Returns the index of the target string in the given ArrayList, or -1 if the string is not found
	// Assumes that the given ArrayList is sorted aphabetically
	// Assumes that [lowIdx, highIdx) is a semi-open interval of indices
	int binarySearchHelp_v2(ArrayList<String> strings, String target, int lowIdx, int highIdx) {
		int midIdx = (lowIdx + highIdx) / 2;
		if (lowIdx >= highIdx) {
			return -1;                                                           // not found
		}
		else if (target.compareTo(strings.get(midIdx)) == 0) {
			return midIdx;                                                       // found it!
		}
		else if (target.compareTo(strings.get(midIdx)) > 0) {
			return this.binarySearchHelp_v2(strings, target, midIdx + 1, highIdx); // too low
		}
		else {
			return this.binarySearchHelp_v2(strings, target, lowIdx, midIdx); // too high
		}
	}

	void sort(ArrayList<String> strings) {
		for (int i = 0; i < strings.size(); i++) {
			int min = i;

			for (int j = i + 1; j < strings.size(); j++) {
				if (strings.get(min).compareTo(strings.get(j)) > 0) {
					min = j;
				}
			}

			// take the value at index i and switch it with the value at the minimum
			strings.set(i, strings.set(min, strings.get(i)));
		}
	}
}