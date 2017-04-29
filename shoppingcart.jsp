<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter"
%>

<html>
<%@include file="css.html"%>
<%@include file="navbar.jsp"%>
  <body>
    <div class="container">
        <%
            try {               
                //Class.forName("org.gjt.mm.mysql.Driver");
                Connection c = DriverManager.getConnection(
                    session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
                response.setContentType("text/html");               
                Class.forName("com.mysql.jdbc.Driver").newInstance();
                Statement statement = c.createStatement();
                String qstring = request.getQueryString();
                if (qstring.equals("")){
                	qstring = "page=1&orderby=title&reverse=false&total=10";
                }
                String replacer = "orderby=" + request.getParameter("orderby");
		%>
			<table class="bordered">
			<thead>
				<tr>
					<th style="width: 80px">ISBN <a
						href=<%
               					out.println("\"shoppingcart.jsp?");
               					if (request.getParameter("reverse").equals("true")){
               						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=book.isbn"));	// Replacer = "orderby=attribute"
               						out.println("\">");
               						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
               					}
               					else if (request.getParameter("reverse").equals("false")){
               						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=book.isbn"));	// Replacer = "orderby=attribute"
               						out.println("\">");
               						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
               					}
               				%></a>
					</th>
					<th style="width: 400px">Title <a
						href=<%
           					out.println("\"shoppingcart.jsp?");
           					if (request.getParameter("reverse").equals("true")){
           						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=title"));	// Replacer = "orderby=attribute"
           						out.println("\">");
           						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
           					}
           					else if (request.getParameter("reverse").equals("false")){
           						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=title"));	// Replacer = "orderby=attribute"
           						out.println("\">");
           						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
           					}
           				%></a>
					</th>
					<th style="width: 220px">Publisher <a
						href=<%
        					out.println("\"shoppingcart.jsp?");
        					if (request.getParameter("reverse").equals("true")){
        						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=publisher"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
        					}
        					else if (request.getParameter("reverse").equals("false")){
        						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=publisher"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
        					}
        				%></a>
					</th>
					<th style="width: 100px">Year <a
						href=<%
        					out.println("\"shoppingcart.jsp?");
        					if (request.getParameter("reverse").equals("true")){
        						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=year_published"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
        					}
        					else if (request.getParameter("reverse").equals("false")){
        						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=year_published"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
        					}
        				%></a>
					</th>
					<th>Author</th>
					<th>Genre</th>
					<th>Price</th>
					<th>Quantity</th>
				</tr>
			</thead>
		<%
                
                String query = "SELECT * FROM book WHERE isbn = ?";
                PreparedStatement book_statement = c.prepareStatement(query);
                
                String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id ORDER BY last_name, first_name ASC";
                PreparedStatement author_statement = c.prepareStatement(author_query);
                
                String genre_query = "SELECT genre_name FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id ORDER BY genre_name ASC";
                PreparedStatement genre_statement = c.prepareStatement(genre_query);
                
                ArrayList<ItemCounter> cart = new ArrayList<ItemCounter>();
                cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
                
                
                for (int i = 0; i < cart.size(); i++) {
                	String b_isbn = cart.get(i).isbn();                   
                    
                	book_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet rs = book_statement.executeQuery();
            	    
            	    
                	author_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet author_rs = author_statement.executeQuery();
            	    
            	    genre_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet genre_rs = genre_statement.executeQuery();
                    
            	    rs.next();
                    String b_title = rs.getString("title");
                    String b_year = rs.getString("year_published");
                    String b_publisher = rs.getString("publisher");
                    out.println("<tr>" + "<td>" + b_isbn + "</td>" + "<td><a href = bookpage.jsp?b_isbn="+ b_isbn + ">" + b_title + "</a></td>" + "<td>" + b_publisher + "</td>" + "<td>" + b_year + "</td>" + "<td style=\"width:200px\">");
                    
                    
                    
                    while (author_rs.next())
                    {
                    	String a_author_id = author_rs.getString("author_id");
                    	String a_firstName = author_rs.getString("first_name");
                    	String a_lastName = author_rs.getString("last_name");
                    	out.println("<a href = authorpage.jsp?author_id=" + a_author_id + ">" + a_firstName + " " + a_lastName + "</a>");
                    	if(!author_rs.isLast())
                    	{
                    		//out.println(", ");
                    		out.println("<br>");
                    	}
                    	
                    }
                    
            	    out.println("</td>");
                    
            	    out.println("<td>");

            	    
            	    if (!genre_rs.isBeforeFirst() ) {    
        			    out.println("None listed"); 
        				}
        			else {
        				out.println("<br>"); 
                    	while(genre_rs.next()) // 
                		{
                    		String genre = genre_rs.getString("genre_name");
                    		out.println(genre);
                    		if(!genre_rs.isLast())
                    		{
                    			out.println("<br>");
                    		}
                		}
        			}
            	    
            	    out.println("</td><td>$10.00</td>");
            	    out.println("<td>" + cart.get(i).quantity() + "</td>");
                }
               		 		
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
    </div>
  </body>
</html>