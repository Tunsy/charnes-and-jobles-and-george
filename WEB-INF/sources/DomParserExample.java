package xmlparser;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
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
	Hashtable<Integer, Book> booksTable;
    static List booksList;
    static List keys;
    static List authorsList;
    static List castList;
    Document dom;
    


    public DomParserExample(){
        //create
        booksTable = new Hashtable<Integer, Book>();
        booksList = new ArrayList();
        authorsList = new ArrayList();
        castList = new ArrayList();
        keys = new ArrayList();
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

    
    private void parseFilmDocument(){
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
                        booksTable.put(book.getIsbn(), book);
                        keys.add(book.getIsbn());
                        booksList.add(book);
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
                		castList.add(c);
                	}
                }
            }
        }
    }
    
    private void parseActorDocument(){
        //get the root elememt
        Element docEle = dom.getDocumentElement(); // <actor>
        
        //get a nodelist of <actor> elements
        NodeList nl = docEle.getElementsByTagName("actor");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //given a specific actor element
                Element authorElement = (Element) nl.item(i);
                Author author = getAuthor(authorElement);
                authorsList.add(author);
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
        int isbn = Math.abs(title.hashCode() % 999999);
        
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
        
        //Create a new Book with the value read from the xml nodes
        Book newBook = new Book(isbn, title, year_published, publisher, genres, fid);
        
        return newBook;
    }
    
    private Cast getCast(Element cast){
    	String fid = getTextValue(cast, "f");
    	String stageName = getTextValue(cast, "a");
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
        Author currentAuthor = new Author(dob, firstName, lastName, str);
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
    	}
    	return num;
    }
    
    /**
     * Iterate through the list and print the 
     * content to console
     */
    private void printData(List list){
        Iterator it = list.iterator();
        while(it.hasNext()) {
            System.out.println(it.next().toString());
        }
        System.out.println("No of items: '" + list.size() + "'.");
        
    }

    
    public static void main(String[] args){
        //create an instance
        DomParserExample dpe = new DomParserExample();
        
        
        //parse the xml file and get the dom object
        dpe.parseXmlFile("mains243.xml");
        dpe.parseFilmDocument();
        
        dpe.parseXmlFile("actors63.xml");
        dpe.parseActorDocument();
        
        dpe.parseXmlFile("casts124.xml");
        dpe.parseCastDocument();
        
        //Iterate through the list and print the data
        dpe.printData(booksList);
        dpe.printData(authorsList);
        dpe.printData(castList);
    }

}