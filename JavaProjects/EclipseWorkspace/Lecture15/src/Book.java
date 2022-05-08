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



interface IList<T> {
	IList<T> filter(IPred<T> pred);
	IList<T> sort(IComp<T> comp);
	IList<T> insert(IComp<T> comp, T t);
	<U> IList<U> map(IFunc<T,U> f);
}

class MtList<T> implements IList<T> {
	public IList<T> filter(IPred<T> pred) {
		return this;
	}
	public IList<T> sort(IComp<T> comp) {
		return this;
	}
	public IList<T> insert(IComp<T> comp, T t) {
		return new ConsList<T>(t, this);
	}
	public <U> IList<U> map(IFunc<T,U> f) {
		return new MtList<U>();
	}
}

class ConsList<T> implements IList<T> {
	T first;
	IList<T> rest;

	ConsList(T first, IList<T> rest) {
		this.first = first;
		this.rest = rest;
	}
	 
	public IList<T> filter(IPred<T> pred) {
		if(pred.apply(this.first)) {
			return new ConsList<T>(this.first, this.rest.filter(pred));
		}
		else {
			return this.rest.filter(pred);
		}
	}
	public IList<T> sort(IComp<T> comp) {
		return this.rest.sort(comp).insert(comp, this.first);
	}
	public IList<T> insert(IComp<T> comp, T t) {
		if(comp.compare(t, this.first)) {
			return new ConsList<T>(t, this);
		}
		else {
			return new ConsList<T>(this.first, this.rest.insert(comp, t));
		}
	}
	public <U> IList<U> map(IFunc<T,U> f) {
		return new ConsList<U>(f.apply(this.first), this.rest.map(f));
	}
}




interface IPred<T> {
	boolean apply(T t);
}
class TitleLengthLess5 implements IPred<Book> {
	public boolean apply(Book b) {
		return b.title.length() <= 5;
	}
}
class AuthorLengthLess5 implements IPred<Author> {
	public boolean apply(Author a) {
		return a.first.length() <= 5;
	}
}

interface IComp<T> {
	boolean compare(T t1, T t2);
}
class TitleCompare implements IComp<Book> {
	public boolean compare(Book b1, Book b2) {
		return b1.title.compareTo(b2.title) < 0;
	}
}
class AuthorCompare implements IComp<Author> {
	public boolean compare(Author a1, Author a2) {
		return a1.first.compareTo(a2.first) < 0;
	}
}




interface IFunc<A, R>{
	R apply(A arg); // R is the return type, A is the argument it acts on
}
class BookToString implements IFunc<Book, String> {
	public String apply(Book b) {
		return b.title;
	}
}



class ExamplesGenerics {
	IList<String> abc = new ConsList<String>("a",
	                      new ConsList<String>("b",
	                        new ConsList<String>("c", new MtList<String>())));

}