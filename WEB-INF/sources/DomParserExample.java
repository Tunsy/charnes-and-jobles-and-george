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
	static HashMap<String, Book> booksTable;		// key is fid
    static HashMap<String, Author> authorsTable;	// key is stagename
    static HashMap<String, Cast> castTable;		// key is incremented integer
    static int authorID;
    static int isbnCounter;
    static Connection c;
    Document dom;
    


    public DomParserExample(){
        //create
        booksTable = new HashMap<String, Book>();
        authorsTable = new HashMap<String, Author>();
        castTable = new HashMap<String, Cast>();
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

    
    private void parseFilmDocument() throws SQLException{
    	String query = "SELECT isbn FROM book ORDER BY isbn DESC LIMIT 1";
    	Statement statement = c.createStatement();
    	ResultSet rs = statement.executeQuery(query);
		rs.next();
		isbnCounter = rs.getInt(1) + 1;	
    	
        //get the root elememt
        Element docEle = dom.getDocumentElement(); // <movies>
        
        //get a nodelist of <directorfilms> elements
        NodeList nl = docEle.getElementsByTagName("directorfilms");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific directorfilms element
                Element booksElement = (Element) nl.item(i);
                
                //get a list of films (only 1 films element)
                NodeList books = booksElement.getElementsByTagName("films");
                Element bookElement = (Element) books.item(0);	// Get the one <films> element.
                NodeList bookList = bookElement.getElementsByTagName("film");	// NodeList of all <film> elements
                
                Book book = null;
                if (bookList != null){
                    for (int j = 0; j < bookList.getLength();j++){
                    	//Given a specific <film>, create a book object
                        book = getBook((Element) bookList.item(j));
                        //add it to table
                        booksTable.put(book.getFid(), book);
                    }  
                }
            }
        }
    }
    
    private void parseCastDocument(){
    	//get the root elememt
        Element docEle = dom.getDocumentElement(); // <movies>
        //get a nodelist of <directorfilms> elements
        NodeList nl = docEle.getElementsByTagName("dirfilms");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific directorfilms element
                Element dirFilms = (Element) nl.item(i);
                NodeList dirFilmsList = dirFilms.getElementsByTagName("filmc");
                if(dirFilmsList != null && dirFilmsList.getLength() > 0){
                	
                	for(int j = 0; j < dirFilmsList.getLength(); j++){
                		Element m = (Element) dirFilmsList.item(j);
                		Cast c = getCast(m);

                		if (c != null){
                    		Cast dupeCheck = castTable.get(c.getStageName());
                    		if(dupeCheck == null){
                    			castTable.put(c.getStageName(), c);
                    		}
                		}
                	}
                }
            }
        }
    }
    
    private void parseActorDocument() throws SQLException{
    	String query = "SELECT author_id FROM author ORDER BY author_id DESC LIMIT 1";
    	Statement statement = c.createStatement();
    	ResultSet rs = statement.executeQuery(query);
		rs.next();
		authorID = rs.getInt(1) + 1;		
    	
        //get the root elememt
        Element docEle = dom.getDocumentElement(); // <actor>
        
        //get a nodelist of <actor> elements
        NodeList nl = docEle.getElementsByTagName("actor");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific actor element
                Element authorElement = (Element) nl.item(i);
                Author author = getAuthor(authorElement);
                if (author != null){
                	authorsTable.put(author.getStageName(), author);
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
        //for each <film> element get text or int values of 
        //isbn, title, year_published, publisher <cat>
        
    	// Title and ISBN
    	String title = "";
    	
    	title = getTextValue(book,"t");
        int isbn = isbnCounter++;
        
        // year_published
        int year_published = getIntValue(book, "year");	// -1 if improper format in XML

        // publisher
        String publisher = "";

        NodeList publishersList = book.getElementsByTagName("studios");
        if (publishersList != null && publishersList.getLength() > 0){
        	Element publishers = (Element) publishersList.item(0);
        	NodeList publisherList = publishers.getElementsByTagName("studio");
        	if (publisherList != null && publisherList.getLength() > 0){
        		Element publish	= (Element) publisherList.item(0);
        		publisher = publish.getTextContent();
        	}
        }

        // genres
        ArrayList<String> genres = new ArrayList<String>();
        
        NodeList genresList = book.getElementsByTagName("cats");
        if (genresList != null  && genresList.getLength() > 0){
        	Element genresElement = (Element) genresList.item(0);	// The one <cats> element
        	NodeList genreList = genresElement.getElementsByTagName("cat");
        	if (genreList != null  && genreList.getLength() > 0){
        		for (int i = 0; i < genreList.getLength(); i++){
        			String genre = genreList.item(i).getTextContent();	// Get each cat's value
        			genres.add(genre);
        		}
        	}
        	
        }
        
        // fid
        String fid = "";
        fid = getTextValue(book, "fid");
        if (fid != null){
        	fid = fid.toLowerCase();
        }
        //Create a new Book with the value read from the xml nodes
        Book newBook = new Book(isbn, title, year_published, publisher, genres, fid);
        
        return newBook;
    }
    
    private Cast getCast(Element cast){
    	String fid = getTextValue(cast, "f").toLowerCase();
    	String stageName = getTextValue(cast, "a");
    	if (stageName.equals("s a") || stageName.equals("sa")){
    		return null;
    	}
    	Cast c = new Cast(fid, stageName);
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
    	String str = getTextValue(author, "stagename");
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
    	
    	insertBookQuery = "INSERT INTO book (isbn, title, year_published, publisher) VALUES (?, ?, ?, ?)";
    	insertAuthorQuery = "INSERT INTO author (author_id, first_name, last_name, dob, photo_url) VALUES (?, ?, ?, ?, ?)";
    	insertAuthoredQuery = "INSERT INTO authored (isbn, author_id) VALUES (?, ?)";
    	
    	int[] iNoRows = null;
    	c.setAutoCommit(false);
    	insertBookStatement = c.prepareStatement(insertBookQuery);
    	insertAuthorStatement = c.prepareStatement(insertAuthorQuery);
    	insertAuthoredStatement = c.prepareStatement(insertAuthoredQuery);
    	
    	// setup book inserts
    	Iterator it = booksTable.entrySet().iterator();
    	Book book = null;
        while(it.hasNext()) {
        	Map.Entry<String, Book> _book = (Map.Entry<String, Book>) it.next();
        	book = _book.getValue();
            insertBookStatement.setInt(1, book.getIsbn());
            insertBookStatement.setString(2, book.getTitle());
            insertBookStatement.setInt(3, book.getYear_published());
            insertBookStatement.setString(4, book.getPublisher());
            insertBookStatement.addBatch();
        }
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
        //c.commit();
        it = castTable.entrySet().iterator();
        Cast cast = null;
        while(it.hasNext()) {
        	Map.Entry<String, Cast> _cast = (Map.Entry<String, Cast>) it.next();
        	cast = _cast.getValue();
        	if (booksTable.get(cast.getFid()) == null){
        		System.out.println(cast.getFid() + " is not a valid fid, not added to authored table");
        		continue;
        	}
        	if (authorsTable.get(cast.getStageName()) == null){
        		System.out.println(cast.getStageName() + " is not a valid stageName, not added to authored table");
        		continue;
        	}
            insertAuthoredStatement.setInt(1, booksTable.get(cast.getFid()).getIsbn());
            insertAuthoredStatement.setInt(2, authorsTable.get(cast.getStageName()).getAuthorId());
            
            insertAuthoredStatement.addBatch();
        }
    	insertAuthoredStatement.executeBatch();
    	c.commit();
    }
    
    public static void main(String[] args) throws Exception{
        //create an instance
        DomParserExample dpe = new DomParserExample();
        connectSQL();
        
        //parse the xml file and get the dom object
        dpe.parseXmlFile("mains243.xml");
        dpe.parseFilmDocument();
        
        dpe.parseXmlFile("actors63.xml");
        dpe.parseActorDocument();
        
        dpe.parseXmlFile("casts124.xml");
        dpe.parseCastDocument();
        
        //Iterate through the list and print the data
       // dpe.printData(booksTable);
        //dpe.printData(authorsTable);
        //dpe.printData(castTable);
        
        // Insert to database
        dpe.insertToDatabase();
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