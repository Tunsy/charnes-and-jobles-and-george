<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"
%>

<html>
<%@include file="navbar.jsp"%>
<%@include file="css.html"%>  
  <body>
    <div class="container">
        <h1 align="center"> Charnes & Jobles & George</h1>
        <div class="row">
            <div>
              <ul class="collection with-header">
                 <%
                    try {               
                        //Class.forName("org.gjt.mm.mysql.Driver");
                        Connection c = DriverManager.getConnection(
                            session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
                        response.setContentType("text/html");               
                        Class.forName("com.mysql.jdbc.Driver").newInstance();
                        Statement statement = c.createStatement();


                        String isbn = request.getParameter("b_isbn");
                        //String isbn = "1";
                        List<String> authors = new ArrayList<String>();
                        String query = "SELECT * FROM book LEFT JOIN (author, authored, genre_in_books, genre) ON (book.isbn = authored.isbn AND authored.isbn = genre_in_books.isbn AND authored.author_id = author.author_id AND genre.id = genre_in_books.genre_id) WHERE book.isbn = " + isbn;
                        ResultSet rs = statement.executeQuery(query);
                        String year = "";
                        String title = "";
                        String publisher = "";
                        String genre = "";
                        
                        String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id";
                        PreparedStatement author_statement = c.prepareStatement(author_query);
                        author_statement.setInt(1, Integer.parseInt(isbn));
                	    ResultSet author_rs = author_statement.executeQuery();
                	    
                	    
                	    String genre_query = "SELECT genre.genre_name  FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id;";
                        PreparedStatement genre_statement = c.prepareStatement(genre_query);
                	    genre_statement.setInt(1, Integer.parseInt(isbn));
                	    ResultSet genre_rs = genre_statement.executeQuery();
                	    
                        if(rs.next()){
                            year = rs.getString("year_published");
                            title = rs.getString("title");
                            publisher = rs.getString("publisher");
                            genre = rs.getString("genre_name");
                            
                            out.println("<li class=\"collection-header\"><h4>" + title + "<h4></li>");
                            out.println("<li class=\"collection-item\">Author: ");
                            
                        	while(author_rs.next())
                        	{
                        		String a_author_id = author_rs.getString("author_id");
                        		String a_firstName = author_rs.getString("first_name");
                            	String a_lastName = author_rs.getString("last_name");
                            	out.println("<a href = main.jsp?author_id=" + a_author_id + ">" + a_firstName + " " + a_lastName + "</a>");
                            	if(!author_rs.isLast())
                            	{
                            		//out.println(", ");
                            		out.println("<br>");
                            	}
                        	}
                            
                            out.print("</li>");
                            out.println("<li class=\"collection-item\">Publisher: " + publisher + "</li>");
                            
                            out.println("<li class=\"collection-item\">Genres: ");
                            
                            while(genre_rs.next())
                        	{
                        		String genre_name = genre_rs.getString("genre_name");
                        		
                            	out.println(genre_name);
                            	if(!genre_rs.isLast())
                            	{
                            		//out.println(", ");
                            		out.println("<br>");
                            	}
                        	}
                            
                            out.print("</li>");
                            
                            out.println("<li class=\"collection-item\">Year published: " + year + "</li>");
                            out.println("<li class=\"collection-item\">ISBN: " + isbn + "</li>");
                        }

                        
                        //for(int i = 0; i < authors.size(); i++){
                        //    out.print(authors.get(i));
                        //    if(i < authors.size() - 1)
                        //      out.print(", ");
                        //}
                        //out.print("</li>");
                        //out.println("<li class=\"collection-item\">Publisher: " + publisher + "</li>");
                        //out.println("<li class=\"collection-item\">Genres: " + genre + "</li>");
                        //out.println("<li class=\"collection-item\">Year published: " + year + "</li>");
                        //out.println("<li class=\"collection-item\">ISBN: " + isbn + "</li>");

                    } catch (SQLException ex) {
                        while (ex != null) {
                            System.out.println("SQL Exception:  " + ex.getMessage());
                            ex = ex.getNextException();
                        } // end while
                    } // end catch SQLException

                    catch (java.lang.Exception ex) {
                        out.println("<HTML>" + "<HEAD><TITLE>" + "BooksDB: Error" + "</TITLE></HEAD>\n<BODY>"
                                + "<P>SQL error in doGet: " + ex.getMessage() + "</P></BODY></HTML>");
                        return;
                    }
                  %>                   
              </ul>
              <a class="waves-effect waves-light btn"><i class="material-icons left">shopping_cart</i>Add to shopping cart</a>
            </div>
        </div>
      </div>
    </body>
  </html>