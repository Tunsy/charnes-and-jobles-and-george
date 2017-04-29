<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"
%>


<% 
	final class ItemCounter
	{
	    private String isbn;
	    private int quantity;
	
	    public ItemCounter(String aIsbn)
	    {
	        isbn   = aIsbn;
	        quantity = 1;
	    }
	
	    public String isbn()   { return isbn; }
	    public int quantity() { return quantity; }
	    public void increment() {quantity++;}
	    
	}
%>
