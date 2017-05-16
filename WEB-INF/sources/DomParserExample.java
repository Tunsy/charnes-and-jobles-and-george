package xmlparser;

import java.io.IOException;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Hashtable;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class DomParserExample {
	//No generics
		static HashMap<String, Book> booksTable;		// key is bid
	    static HashMap<String, Author> authorsTable;	// key is stagename
	    static HashMap<String, ArrayList<Authored>> authoredTable;		// key is incremented integer
	    static HashMap<String, Genre>	genreTable;			// key is genre name (<cat>)
	    static int authorID;
	    static int isbnCounter;
	    static int genreCounter;
	    static Connection c;
	    Document dom;
	    


	    public DomParserExample(){
	        //create
	        booksTable = new HashMap<String, Book>();
	        authorsTable = new HashMap<String, Author>();
	        authoredTable = new HashMap<String, ArrayList<Authored>>();
	        genreTable = new HashMap<String, Genre>();
	    }
    
    private void parseXmlFile(String fileName){
        //get the factory
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        
        try {
            
            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            
            //parse using builder to get DOM representation of the XML file
            dom = db.parse(fileName);
            

        }catch(ParserConfigurationException pce) {
            pce.printStackTrace();
        }catch(SAXException se) {
            se.printStackTrace();
        }catch(IOException ioe) {
            ioe.printStackTrace();
        }
    }

    
    private void parseBookDocument() throws SQLException{
    	String isbnquery = "SELECT isbn FROM book ORDER BY isbn DESC LIMIT 1";
    	Statement isbnstatement = c.createStatement();
    	ResultSet isbnrs = isbnstatement.executeQuery(isbnquery);
		isbnrs.next();
		isbnCounter = isbnrs.getInt(1) + 1;	
    	
		String genreidquery = "SELECT id FROM genre ORDER BY id DESC LIMIT 1";
    	Statement genreidstatement = c.createStatement();
    	ResultSet genreidrs = genreidstatement.executeQuery(genreidquery);
    	genreidrs.next();
		genreCounter = genreidrs.getInt(1) + 1;
		
        //get the root element
        Element docEle = dom.getDocumentElement(); // <library>
        
        //get a nodelist of <bookmakers> elements
        NodeList nl = docEle.getElementsByTagName("bookmakers");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific bookmakers element
                Element booksElement = (Element) nl.item(i);
                
                //get a list of books (only 1 books element)
                NodeList books = booksElement.getElementsByTagName("books");
                Element bookElement = (Element) books.item(0);	// Get the one <books> element.
                NodeList bookList = bookElement.getElementsByTagName("book");	// NodeList of all <book> elements
                
                Book book = null;
                if (bookList != null){
                    for (int j = 0; j < bookList.getLength();j++){
                    	//Given a specific <book>, create a book object
                        book = getBook((Element) bookList.item(j));
                        //add it to table
                        Book tempBook = booksTable.get(book.getbid());
                        if (tempBook != null){
                        	booksTable.put(book.getbid(), book);
                        }
                    }  
                }
            }
        }
    }
    
    private void parseAuthoredDocument(){
    	//get the root element
        Element docEle = dom.getDocumentElement(); // <books>
        //get a nodelist of <bookmakers> elements
        NodeList nl = docEle.getElementsByTagName("bookmakers");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific bookmakers element
                Element bookmakers = (Element) nl.item(i);
                NodeList bookmakersList = bookmakers.getElementsByTagName("filmc");
                if(bookmakersList != null && bookmakersList.getLength() > 0){
                	
                	for(int j = 0; j < bookmakersList.getLength(); j++){
                		Element m = (Element) bookmakersList.item(j);
                		Authored c = getAuthored(m);

                		if (c != null){
                			ArrayList<Authored> authoreds = authoredTable.get(c.getPenName());
                			if (authoreds==null) {
                			    authoreds = new ArrayList<Authored>();
                			    authoredTable.put(c.getPenName(), authoreds);
                			}
                			if (!authoreds.contains(c))
                				authoreds.add(c);
                		}
                	}
                }
            }
        }
    }
    
    private void parseauthorDocument() throws SQLException{
    	String query = "SELECT author_id FROM author ORDER BY author_id DESC LIMIT 1";
    	Statement statement = c.createStatement();
    	ResultSet rs = statement.executeQuery(query);
		rs.next();
		authorID = rs.getInt(1) + 1;		
    	
        //get the root elememt
        Element docEle = dom.getDocumentElement(); // <author>
        
        //get a nodelist of <author> elements
        NodeList nl = docEle.getElementsByTagName("author");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific author element
                Element authorElement = (Element) nl.item(i);
                Author author = getAuthor(authorElement);
                if (author != null){
                	authorsTable.put(author.getPenName(), author);
                }
            }
        }
    }


    /**
     * I take an film element and read the values in, create
     * an Book object and return it
     * @param empEl
     * @return
     */
    private Book getBook(Element book) {    
        //for each <book> element get text or int values of 
        //isbn, title, year_published, publisher <cat>
        
    	// Title and ISBN
    	String title = "";
    	
    	title = getTextValue(book,"t");
    	title = title.toLowerCase();
        int isbn = isbnCounter++;
        
        // year_published
        int year_published = getIntValue(book, "year");	// -1 if improper format in XML

        // publisher
        String publisher = "";

        NodeList publishersList = book.getElementsByTagName("publishers");
        if (publishersList != null && publishersList.getLength() > 0){
        	Element publishers = (Element) publishersList.item(0);
        	NodeList publisherList = publishers.getElementsByTagName("publisher");
        	if (publisherList != null && publisherList.getLength() > 0){
        		Element publish	= (Element) publisherList.item(0);
        		publisher = publish.getTextContent();
        	}
        }

        // genres
        ArrayList<Genre> genres = new ArrayList<Genre>();
        
        NodeList genresList = book.getElementsByTagName("cats");
        if (genresList != null  && genresList.getLength() > 0){
        	Element genresElement = (Element) genresList.item(0);	// The one <cats> element
        	NodeList genreList = genresElement.getElementsByTagName("cat");
        	if (genreList != null  && genreList.getLength() > 0){
        		for (int i = 0; i < genreList.getLength(); i++){
        			String genreName = genreList.item(i).getTextContent();	// Get each cat's value
        			genreName = genreName.toLowerCase().trim();
        			Genre testGenre = genreTable.get(genreName);
        			if (testGenre == null){
        				Genre genre = new Genre(genreCounter++, genreName);
        				genreTable.put(genreName, genre);
        				if (!genres.contains(genre)){
        					genres.add(genre);
        				}
        			}else{
        				if (!genres.contains(testGenre)){
        					genres.add(testGenre);
        				}
        			}
        		}
        	}
        	
        }
        
        // bid
        String bid = "";
        bid = getTextValue(book, "bid");
        if (bid != null){
        	bid = bid.toLowerCase();
        }
        //Create a new Book with the value read from the xml nodes
        Book newBook = new Book(isbn, title, year_published, publisher, genres, bid);
        
        return newBook;
    }
    
    private Authored getAuthored(Element cast){
    	String bid = getTextValue(cast, "b").toLowerCase();
    	String penName = getTextValue(cast, "a");
    	if (penName.equals("s a") || penName.equals("sa")){
    		return null;
    	}
    	Authored c = new Authored(bid, penName);
    	return c;
    }

    private Author getAuthor(Element author) {    
        //for each <author> element get text or int values of 
        //authorid, dob, firstName, lastName
        
    	// DOB
    	NodeList dobList = author.getElementsByTagName("dob");
    	String dob = "";
    	if(dobList != null && dobList.getLength() > 0){
    		dob = dobList.item(0).getTextContent();
    	}
    	
    	if (dob == null || dob == "" || dob.length() != 10){
    		System.out.println("Invalid date format");
    	}
    	
    	String firstName = "";
    	String lastName = "";
    	String str = getTextValue(author, "penname");
    	str = str.toLowerCase();
		String[] split = str.split("\\s+");
		

		if (split.length == 1) {
			firstName = "";
			lastName = split[0];
		} else if (split.length == 2) {
			firstName = split[0];
			lastName = split[1];
		}
        
        //Create a new Book with the value read from the xml nodes
        Author currentAuthor = new Author(dob, firstName, lastName, str, authorID);
        authorID++;
        return currentAuthor;
    }


    /**
     * I take a xml element and the tag name, look for the tag and get
     * the text content 
     * i.e for <employee><name>John</name></employee> xml snippet if
     * the Element points to employee node and tagName is name I will return John  
     * @param ele
     * @param tagName
     * @return
     */
    private String getTextValue(Element ele, String tagName) {
        String textVal = null;
        NodeList nl = ele.getElementsByTagName(tagName);
        if(nl != null && nl.getLength() > 0) {
            Element el = (Element)nl.item(0);
            textVal = nl.item(0).getTextContent();
        }

        return textVal;
    }

    
    /**
     * Calls getTextValue and returns a int value
     * @param ele
     * @param tagName
     * @return
     */
    private int getIntValue(Element ele, String tagName) {
        //in production application you would catch the exception
    	int num;
    	try{
    		num = Integer.parseInt(getTextValue(ele,tagName));
    	}catch(NumberFormatException e){
    		num = -1;
    		System.out.println("Improper format for tag[" + tagName + "] in element" + ele);
    	}
    	return num;
    }
    
    /**
     * Iterate through the list and print the 
     * content to console
     */
    private void printData(HashMap list){
        Iterator it = list.entrySet().iterator();
        while(it.hasNext()) {
            System.out.println(it.next().toString());
        }
        System.out.println("No of items: '" + list.size() + "'.");
        
    }

    private void insertToDatabase() throws SQLException {
    	PreparedStatement insertBookStatement = null;
    	String insertBookQuery = null;
    	
    	PreparedStatement insertAuthorStatement = null;
    	String insertAuthorQuery = null;
    	
    	PreparedStatement insertAuthoredStatement = null;
    	String insertAuthoredQuery = null;
    	
    	PreparedStatement insertGenreStatement = null;
    	String insertGenreQuery = null;
    	
    	PreparedStatement insertGenreInBooksStatement = null;
    	String insertGenreInBooksQuery = null;
    	
    	insertBookQuery = "INSERT INTO book (isbn, title, year_published, publisher) VALUES (?, ?, ?, ?)";
    	insertAuthorQuery = "INSERT INTO author (author_id, first_name, last_name, dob, photo_url) VALUES (?, ?, ?, ?, ?)";
    	insertAuthoredQuery = "INSERT INTO authored (isbn, author_id) VALUES (?, ?)";
    	insertGenreQuery = "INSERT INTO genre (id, genre_name) VALUES (?, ?)";
    	insertGenreInBooksQuery = "INSERT INTO genre_in_books (genre_id, isbn) VALUES (?, ?)";
    	
    	c.setAutoCommit(false);
    	insertBookStatement = c.prepareStatement(insertBookQuery);
    	insertAuthorStatement = c.prepareStatement(insertAuthorQuery);
    	insertAuthoredStatement = c.prepareStatement(insertAuthoredQuery);
    	insertGenreStatement = c.prepareStatement(insertGenreQuery);
    	insertGenreInBooksStatement = c.prepareStatement(insertGenreInBooksQuery);
    	
    	//setup genre inserts
    	Iterator it = genreTable.entrySet().iterator();
    	Genre genre = null;
        while(it.hasNext()) {
        	Map.Entry<String, Genre> _genre = (Map.Entry<String, Genre>) it.next();
        	genre = _genre.getValue();
            insertGenreStatement.setInt(1, genre.getGenreId());
            insertGenreStatement.setString(2, genre.getGenre());
            insertGenreStatement.addBatch();
        }       
        
    	// setup book inserts
    	it = booksTable.entrySet().iterator();
    	Book book = null;
        while(it.hasNext()) {
        	Map.Entry<String, Book> _book = (Map.Entry<String, Book>) it.next();
        	book = _book.getValue();
            insertBookStatement.setInt(1, book.getIsbn());
            insertBookStatement.setString(2, book.getTitle());
            insertBookStatement.setInt(3, book.getYear_published());
            insertBookStatement.setString(4, book.getPublisher());
            insertBookStatement.addBatch();
            
            // setup genre_in_books inserts
            for (Genre bookgenre : book.getGenres()){           	
            	insertGenreInBooksStatement.setInt(1, bookgenre.getGenreId());
            	insertGenreInBooksStatement.setInt(2, book.getIsbn());
            	insertGenreInBooksStatement.addBatch();
            }
            
        }
        
        //setup author inserts
        it = authorsTable.entrySet().iterator();
        Author author = null;
        while(it.hasNext()) {
        	Map.Entry<String, Author> _author = (Map.Entry<String, Author>) it.next();
        	author = _author.getValue();
            insertAuthorStatement.setInt(1, author.getAuthorId());
            insertAuthorStatement.setString(2, author.getFirstName());
            insertAuthorStatement.setString(3, author.getLastName());
            if (author.getDob() == null || author.getDob() == "" || author.getDob().length() != 10){
                insertAuthorStatement.setString(4, null);
            }
            else{
            	insertAuthorStatement.setString(4, author.getDob());
            }
            insertAuthorStatement.setString(5, null);
            insertAuthorStatement.addBatch();
        }
        
        insertBookStatement.executeBatch();
        insertAuthorStatement.executeBatch();
        insertGenreStatement.executeBatch();
        insertGenreInBooksStatement.executeBatch();
        //c.commit();
        it = authoredTable.entrySet().iterator();
        ArrayList<Authored> authoredList = null;
        while(it.hasNext()) {
        	Map.Entry<String, ArrayList<Authored>> _authored = (Map.Entry<String, ArrayList<Authored>>) it.next();
        	authoredList = _authored.getValue();
        	
        	for (Authored authored : authoredList){
	        	if (booksTable.get(authored.getbid()) == null){
	        		System.out.println(authored.getbid() + " is not a valid bid, not added to authored table");
	        		continue;
	        	}
	        	if (authorsTable.get(authored.getPenName()) == null){
	        		System.out.println(authored.getPenName() + " is not a valid penName, not added to authored table");
	        		continue;
	        	}
	            insertAuthoredStatement.setInt(1, booksTable.get(authored.getbid()).getIsbn());
	            insertAuthoredStatement.setInt(2, authorsTable.get(authored.getPenName()).getAuthorId());
	            
	            insertAuthoredStatement.addBatch();
        	}
        }
    	insertAuthoredStatement.executeBatch();
    	c.commit();
    }
    
    public static void main(String[] args) throws Exception{
        //create an instance
    	long start = System.nanoTime();
        DomParserExample dpe = new DomParserExample();
        connectSQL();
        
        //parse the xml file and get the dom object
        dpe.parseXmlFile("book.xml");
        dpe.parseBookDocument();
        
        dpe.parseXmlFile("author.xml");
        dpe.parseauthorDocument();
        
        dpe.parseXmlFile("authored.xml");
        dpe.parseAuthoredDocument();
        
        //Iterate through the list and print the data
       // dpe.printData(booksTable);
        //dpe.printData(authorsTable);
        //dpe.printData(castTable);
        
        // Insert to database
        dpe.insertToDatabase();
        System.out.println("Insert complete");
        System.out.println((System.nanoTime() - start) / 1000000000.0);
    }
    
    public static void connectSQL() throws Exception{
    	String loginUser = "root";
        String loginPasswd = "122b";
        String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
        try {
        	Class.forName("com.mysql.jdbc.Driver").newInstance();       
			c = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
		} catch (SQLException e) {
			e.printStackTrace();
		}
    }

}