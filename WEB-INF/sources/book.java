package xmlparser;

import java.util.ArrayList;

public class Book{
    private int isbn;
    private String fid;
    private String title;
    private int year_published;
    private String publisher;
    private ArrayList<String> genres = new ArrayList<String>();

    public Book(int _isbn, String _title, int _year_published, String _publisher, ArrayList<String> _genres, String _fid){
        isbn = _isbn;
        title = _title;
        year_published = _year_published;
        publisher = _publisher;
        genres = _genres;
        fid = _fid;
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
    
    public ArrayList<String> getGenres(){
    	return genres;
    }
    
    public String getFid(){
    	return fid;
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
			sb.append(genres.get(i) + ", ");
		}
		sb.append("Fid:" + fid);
		sb.append(", ");
		sb.append(".");
		
		return sb.toString();
	}
}