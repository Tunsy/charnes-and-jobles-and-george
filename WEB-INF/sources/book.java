package booksdbTables;

public class Book{
    private int isbn;
    private String title;
    private int year_published;
    private String publisher;

    public Book(int _isbn, String _title, int _year_published, String _publisher){
        isbn = _isbn;
        title = _title;
        year_published = _year_published;
        publisher = _publisher;
    }

    public int getIsbn(){
        return isbn;
    }
}