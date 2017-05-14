

import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.HashTable;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class DomParserExample {

    //No generics
    List myEmpls;
    Document dom;


    public DomParserExample(){
        //create a list to hold the employee objects
        myEmpls = new ArrayList();
    }

    public void runExample() {
        
        //parse the xml file and get the dom object
        parseXmlFile();
        
        //get each employee element and create a Employee object
        parseDocument();
        
        //Iterate through the list and print the data
        printData();
        
    }
    
    
    private void parseXmlFile(){
        //get the factory
        DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
        
        try {
            
            //Using factory get an instance of document builder
            DocumentBuilder db = dbf.newDocumentBuilder();
            
            //parse using builder to get DOM representation of the XML file
            dom = db.parse("mains243.xml");
            

        }catch(ParserConfigurationException pce) {
            pce.printStackTrace();
        }catch(SAXException se) {
            se.printStackTrace();
        }catch(IOException ioe) {
            ioe.printStackTrace();
        }
    }

    
    private void parseDocument(){
        //get the root elememt
        Element docEle = dom.getDocumentElement(); // <movies>
        
        //get a nodelist of <directorfilms> elements
        NodeList nl = docEle.getElementsByTagName("directorfilms");
        if(nl != null && nl.getLength() > 0) {
            for(int i = 0 ; i < nl.getLength();i++) {
                
                //get the films element
                Element books = (Element) nl.item(i);
                getElementsByTagName("films");
                NodeList bookList = books.getElementsByTagName("film");

                if (bookList != null){
                    for (int j = 0; j < bookList.getLength();j++){
                        Book book = getBook(bookList.get(j));

                    }  
                }
                //get the Employe object
                int isbn = hashFilm(el);
                
                //add it to list
                myEmpls.add(e);
            }
        }
    }


    /**
     * I take an film element and read the values in, create
     * an Book object and return it
     * @param empEl
     * @return
     */
    private int getBook(Element book) {    
        //for each <book> element get text or int values of 
        //title, year_published, publisher
        String title = getTextValue(book,"t");
        int isbn = name.hashCode();
        String year_published = getIntValue(book,"year");
        String publisher = getTextValue(book, "studios");
        Element genresElement = (Element) book.getElementsByTagName("cats");
        NodeList genreList = genresElement.getElementsByTagName("cat");
        ArrayList<String> genres = new ArrayList<String>();
        if (genreList != null){
            for (int i = 0; i < genreList.getLength(); i++){
                String genre = genreList.get(i).getNodeValue();
            }
        }

        
        //Create a new Book with the value read from the xml nodes
        Book newBook = new Book(isbn, title, year_published, publisher);
        
        return newBook;
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
            textVal = el.getFirstChild().getNodeValue();
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
        return Integer.parseInt(getTextValue(ele,tagName));
    }
    
    /**
     * Iterate through the list and print the 
     * content to console
     */
    private void printData(){
        
        System.out.println("No of Employees '" + myEmpls.size() + "'.");
        
        Iterator it = myEmpls.iterator();
        while(it.hasNext()) {
            System.out.println(it.next().toString());
        }
    }

    
    public static void main(String[] args){
        //create an instance
        DomParserExample dpe = new DomParserExample();
        
        //call run example
        dpe.runExample();
    }

}