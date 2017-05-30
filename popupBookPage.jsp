<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter"%>

<html>
<%@include file="css.html"%>
<body>
<%
	String isbn = request.getParameter("b_isbn").trim();
	String btn = request.getParameter("btn");
	if(btn != null) //btnSubmit is the name of your button, not id of that button.
	{
		
		isbn = request.getParameter("btn").trim();	// Unique button value for each form
		ArrayList<ItemCounter> cart = new ArrayList<ItemCounter>(); 
		cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
		boolean duplicate = false;
		int itemquantity = Integer.parseInt(request.getParameter("item_quantity"));
		ItemCounter book = new ItemCounter(btn);
		for(int i = 0; i < cart.size(); i++)
		{
			if(cart.get(i).isbn().equals(book.isbn()))
			{
				duplicate = true;
				if (cart.get(i).quantity() + itemquantity > 9) {	// Quantity limit = 9
					cart.get(i).setQuantity(9);
					out.print("<div class=\"col s12 msg\"><div class=\"card-panel red darken-2 col s4 center-align\">Error: Quantity limit is 9!</div></div>");
				}else{
					cart.get(i).addQuantity(itemquantity);
				}
				break;
			}
		}
		
		if(!duplicate)
		{
			book.setQuantity(itemquantity);
			cart.add(book);
		}
	
		btn = null;
	}
%>
	<div class="container">
		<div class="row">
			<div class="col s8">
				<ul class="collection with-header">
					<%
                 
					String qstring = request.getQueryString();
                    isbn = request.getParameter("b_isbn");

                    try {               
                        //Class.forName("org.gjt.mm.mysql.Driver");
                        Connection c = DriverManager.getConnection(
                            session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
                        response.setContentType("text/html");               
                        Class.forName("com.mysql.jdbc.Driver").newInstance();
                        
                        //String isbn = "1";
                        String query = "SELECT * FROM book LEFT JOIN (author, authored, genre_in_books, genre) ON (book.isbn = authored.isbn AND authored.isbn = genre_in_books.isbn AND authored.author_id = author.author_id AND genre.id = genre_in_books.genre_id) WHERE book.isbn = ?";
                        PreparedStatement statement = c.prepareStatement(query);
                        statement.setInt(1, Integer.parseInt(isbn));
                        String year = "";
                        String title = "";
                        String publisher = "";
                        ResultSet rs = statement.executeQuery();
                        
                        String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id ORDER BY last_name, first_name ASC";
                        PreparedStatement author_statement = c.prepareStatement(author_query);
                        author_statement.setInt(1, Integer.parseInt(isbn));
                	    ResultSet author_rs = author_statement.executeQuery();
                	    
                	    
                	    
                        if(rs.next()){
                            year = rs.getString("year_published");
                            title = rs.getString("title");
                            publisher = rs.getString("publisher");

                            
                            out.println("<li class=\"collection-header\"><h5>" + title + "<h></li>");
                            out.println("<li class=\"collection-item\">List of authors: <br>");
                            
                        	while(author_rs.next())
                        	{
                        		String a_author_id = author_rs.getString("author_id");
                        		String a_firstName = author_rs.getString("first_name");
                            	String a_lastName = author_rs.getString("last_name");
                            	out.println("<a href = authorpage.jsp?author_id=" + a_author_id + ">" + a_firstName + " " + a_lastName + "</a>");
                            	if(!author_rs.isLast())
                            	{
                            		out.println("<br>");
                            	}
                        	}
                            author_rs.close();			// Finished with author
                            author_statement.close();
                            
	                	    String genre_query = "SELECT genre_name FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id ORDER BY genre_name ASC";
	                        PreparedStatement genre_statement = c.prepareStatement(genre_query);
	                	    genre_statement.setInt(1, Integer.parseInt(isbn));
	                	    ResultSet genre_rs = genre_statement.executeQuery();
	                	    
                            out.print("</li>");
                            out.println("<li class=\"collection-item\">Publisher: " + publisher + "</li>");
                            out.println("<li class=\"collection-item\">Genres: ");
                            

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
                            out.print("</li>");
                            
                            out.println("<li class=\"collection-item\">Year published: " + year + "</li>");
                            out.println("<li class=\"collection-item\">ISBN: " + isbn + "</li>");
                            c.close();
%>
					<script>
						$(document).ready(function() {
							$('select').material_select();
						});
					</script>

					<%
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
				</ul>
				<form
					action="bookpage.jsp?<% out.println(request.getQueryString()); %>"
					method="post" class="center-align">
					<input type="hidden" name="isbn" value="<% out.println(isbn);%>" />
					<div class="input-field" style="width: 50px;margin-left: auto;margin-right: auto;">
						<select name="item_quantity" class="center-align">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
						</select> <label>Qty:</label>
					</div>
					<button type="submit" class=" waves-effect waves-light btn"
						name="btn" value="<%out.println(isbn);%>">
						<i class="material-icons left"> shopping_cart </i>
						Add to Shopping
						Cart
					</button>
				</form>
			</div>
            <div class="col s4 sidepic">
                <% out.println("<img src=\"test\" alt=\"Not a real image\" style=\"width:256px;height:256px;\">"); %>   
            </div>
		</div>
</body>
</html>