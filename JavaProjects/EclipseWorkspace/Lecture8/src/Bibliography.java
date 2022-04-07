interface Bibliography {
	
}

class Empty implements Bibliography {
	
}

class Article implements Bibliography {
	String author;
	String title;
	String URL;
	Bibliography documents;
	
	Article(String author, String title, String URL, Bibliography documents) {
		this.author = author;
		this.title = title;
		this.URL = URL;
		this.documents = documents;
	}
	
}

class Book implements Bibliography {
	String author;
	String title;
	String publisher;
	Bibliography documents;
	
	Book(String author, String title, String publisher, Bibliography documents) {
		this.author = author;
		this.title = title;
		this.publisher = publisher;
		this.documents = documents;
	}
}

