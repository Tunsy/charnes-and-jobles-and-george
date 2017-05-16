package xmlparser;

import java.util.ArrayList;

public class Book{
    private int isbn;
    private String bid;
    private String title;
    private int year_published;
    private String publisher;
    private ArrayList<Genre> genres = new ArrayList<Genre>();

    public Book(int _isbn, String _title, int _year_published, String _publisher, ArrayList<Genre> _genres, String _bid){
        isbn = _isbn;
        title = _title;
        year_published = _year_published;
        publisher = _publisher;
        genres = _genres;
        bid = _bid;
    }

    public int getIsbn(){
        return isbn;
    }
    
    public String getTitle(){
    	return title;
    }
    
    public int getYear_published(){
    	return year_published;
    }
    
    public String getPublisher(){
    	return publisher;
    }
    
    public ArrayList<Genre> getGenres(){
    	return genres;
    }
    
    public String getbid(){
    	return bid;
    }
    
    public String toString() {
		StringBuffer sb = new StringBuffer();
		sb.append("Book Details - ");
		sb.append("ISBN:" + isbn);
		sb.append(", ");
		sb.append("Title:" + title);
		sb.append(", ");
		sb.append("Year:" + year_published);
		sb.append(", ");
		sb.append("Publisher:" + publisher);
		sb.append(", ");
		sb.append("Genres:");
		for (int i = 0; i < genres.size(); i++){
			sb.append(genres.get(i).getGenre() + ", ");
		}
		sb.append("bid:" + bid);
		sb.append(", ");
		sb.append(".");
		
		return sb.toString();
	}
    
    @Override
	public boolean equals(Object book){
		if (book == null){
			return false;
		}
		if (!Authored.class.isAssignableFrom(book.getClass())) {
	        return false;
	    }
	    final Book other = (Book) book;
	    if (this.bid != other.bid) {
	        return false;
	    }
	    if (this.isbn != other.isbn) {
	        return false;
	    }
	    
	    return true;
	}
	@Override
	public int hashCode() {
	    int hash = 3;
	    hash = 53 * hash + (this.bid != null ? this.bid.hashCode() : 0);
	    hash = 53 * hash + isbn;
	    return hash;
	}
}