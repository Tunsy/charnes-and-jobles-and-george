<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"
%>
<html>
<%@include file="css.html"%>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if(session.getAttribute("email") == null){
		session.removeAttribute("email");
		session.invalidate();
		response.sendRedirect("index.jsp");
	}
%>

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
	   // Order by chevrons (arrows)
	   String qstring = request.getQueryString();
	   String replacer = "orderby=" + request.getParameter("orderby");
%>
		<table class="bordered">
			<thead>
				<tr>
					<th style="width: 75px">ISBN <a
						href=<%
               					out.println("\"booklist.jsp?");
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
           					out.println("\"booklist.jsp?");
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
        					out.println("\"booklist.jsp?");
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
        					out.println("\"booklist.jsp?");
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
					<th style="width: 250px">Genre</th>
				</tr>
			</thead>
			<%	
				// Calculate tablesize for pagination
				String spageid = request.getParameter("page");  
				int pageid = Integer.parseInt(spageid);  
				int currentPage;
				int total = Integer.parseInt(request.getParameter("total"));  
				if(pageid != 1){
				    pageid = pageid-1;  
				    pageid = pageid*total+1;  
				}  
				currentPage = (pageid/total)+1;
				
				String query;
				ResultSet rs;
				
				// Change query based on letter and order
				String advancedsearch = request.getParameter("advancedsearch");
				String orderby = request.getParameter("orderby");
				String letter = request.getParameter("letter");
				String reverse = request.getParameter("reverse");
				if (advancedsearch == null){
	         		// Show all books or beginning with a letter
		         	if (letter != null && letter != ""){
		          		if(letter.equals("all")){
						    if(orderby == null){
						        query = "SELECT * from book LIMIT " + (pageid - 1) + "," + total;
						    }else if(orderby != null && request.getParameter("reverse").equals("true")){
						        query = "SELECT * from book " + "ORDER BY " + orderby + " DESC ";
						    }else{
						        query = "SELECT * from book " + "ORDER BY " + orderby;
						    }
						}else{
						    if(orderby == null){
						        query = "SELECT * from book " + "WHERE title LIKE \'" + letter + "%\'";
						    }
						    else {
								query = "SELECT * from book " + "WHERE title LIKE \'" + letter + "%\'" + " ORDER BY " + orderby;
							}    
							if (reverse.equals("true")){
								query += " DESC ";
							}
						}
		         	}
		         	else{	// SIMPLE SEARCH
		         		query = "SELECT * FROM book WHERE title = '" + request.getParameter("title") + "' ORDER BY " + orderby;
		         		if (reverse.equals("true")){
							query += " DESC ";
						}
		         	}
				}
				else{	// GENERATE ADVANCED SEARCH QUERY
					String title = request.getParameter("title");
					String year = request.getParameter("year");
					String publisher = request.getParameter("publisher");
					String author_first_name = request.getParameter("author_first_name");
					String author_last_name = request.getParameter("author_last_name");
					String title_fuzzy = request.getParameter("title_fuzzy_search");
					String publisher_fuzzy = request.getParameter("publisher_fuzzy_search");
					String fname_fuzzy = request.getParameter("first_name_fuzzy_search");
					String lname_fuzzy = request.getParameter("last_name_fuzzy_search");
					
					int numQueryPredicates = 0;

					query = "SELECT DISTINCT(book.isbn), book.title, book.year_published, book.publisher " +
							"FROM book, author, authored " +
							"WHERE ";
					if (title != null && !title.equals("")){							
						if (numQueryPredicates != 0){
							query += " AND ";
						}
						query += "title ";
						if (title_fuzzy != null){	// Fuzzy search on title
							query += "LIKE '%" + title + "%'";
						}
						else{						// Exact string matching on title
							query += "= '" + title + "'";
						}
						numQueryPredicates++;
					}
					if (year != null && !year.equals("")){							
						if (numQueryPredicates != 0){
							query += " AND ";
						}
						query += "year_published = " + year;
						numQueryPredicates++;
					}
					if (publisher != null && !publisher.equals("")){							
						if (numQueryPredicates != 0){
							query += " AND ";
						}
						query += "publisher ";
						if (publisher_fuzzy != null){	// Fuzzy search on publisher
							query += "LIKE '%" + publisher + "%'";
						}
						else{						// Exact string matching on publisher
							query += "= '" + publisher + "'";
						}
						numQueryPredicates++;
					}
					if (author_first_name != null && !author_first_name.equals("")){							
						if (numQueryPredicates != 0){
							query += " AND ";
						}
						query += "author.first_name ";
						if (fname_fuzzy != null){	// Fuzzy search on first_name
							query += "LIKE '%" + author_first_name + "%'";
						}
						else{						// Exact string matching on first_name
							query += "= '" + author_first_name + "'";
						}
						numQueryPredicates++;
					}
					if (author_last_name != null && !author_last_name.equals("")){							
						if (numQueryPredicates != 0){
							query += " AND ";
						}
						query += "author.last_name ";
						if (lname_fuzzy != null){	// Fuzzy search on last_name
							query += "LIKE '%" + author_last_name + "%'";
						}
						else{						// Exact string matching on last_name
							query += "= '" + author_last_name + "'";
						}
						numQueryPredicates++;
					}
					if(numQueryPredicates != 0){
						query += " AND book.isbn = authored.isbn AND author.author_id = authored.author_id ";
						if(orderby != null){
	                        query += "ORDER BY " + orderby;
	                        if(reverse.equals("true")){
	                        	query += " DESC ";
	                        }
	                    }
					}
					else{
						query += "false=true";	// Return 0 rows on empty 
					}
					//	Test print: out.println(query);
				}
                // Get the total query count to limit for pagination
                String countQuery;
                ResultSet rsCount;
                int queryCount = 0;
                
                if (advancedsearch == null){
					countQuery = query.replace("*", "COUNT(*) AS total");
                }
                else{
                	countQuery = query.replace("DISTINCT(book.isbn), book.title, book.year_published, book.publisher", "COUNT(DISTINCT(book.isbn)) AS total");
                }
                
                rsCount = statement.executeQuery(countQuery);
                
                if(rsCount.next()){
                    queryCount = rsCount.getInt("total");
                }
                
                query += " LIMIT " + (pageid - 1) + "," + total;
                rs = statement.executeQuery(query);
                
                String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id";
                PreparedStatement author_statement = c.prepareStatement(author_query);
                
                String genre_query = "SELECT genre_name FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id;";
                PreparedStatement genre_statement = c.prepareStatement(genre_query);
        	    
                String singleAddBtn = request.getParameter("btn");

                // Iterate through each row of rs
                while (rs.next()) {
                	String b_isbn = rs.getString("isbn");                    
                    
                	author_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet author_rs = author_statement.executeQuery();
            	    
            	    genre_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet genre_rs = genre_statement.executeQuery();
                    
                    String b_title = rs.getString("title");
                    String b_year = rs.getString("year_published");
                    String b_publisher = rs.getString("publisher");
                    out.println("<tr>" + "<td>" + b_isbn + "</td>" + "<td><a href = moviepage.jsp?b_isbn="+ b_isbn + ">" + b_title + "</a></td>" + "<td>" + b_publisher + "</td>" + "<td>" + b_year + "</td>" + "<td style=\"width:200px\">");
                    
                    
                    
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
               		out.print("</td><td>");
%>            	    
					<form action="booklist.jsp?<% out.println(request.getQueryString()); %>" method="post">
						<input type="hidden" name="isbn" value=<% out.println(b_isbn);%> />               			
              			<button type="submit" class="waves-effect waves-light btn" name="btn" value="default">
              				<i class="material-icons left">
              					shopping_cart
              				</i>
              				Add
              			</button>
              		</form>

<%               		out.print("</td></tr>");
						if(singleAddBtn != null) //btnSubmit is the name of your button, not id of that button.
						{
							String isbn = request.getParameter("isbn");
							ArrayList<String> cart = (ArrayList) session.getAttribute("shoppingcart");
							cart.add(isbn);
							singleAddBtn = null;
						}
                }
                out.println("</TABLE>");
                //Limit data
                out.println("Limit books per page: ");
                out.println("<a href=\"booklist.jsp?page=" + (currentPage) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=5" + "&letter=" + request.getParameter("letter") + "\">5</a>");
                out.println("<a href=\"booklist.jsp?page=" + (currentPage) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=15" + "&letter=" + request.getParameter("letter") + "\">15</a>");
                out.println("<a href=\"booklist.jsp?page=" + (currentPage) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=25" + "&letter=" + request.getParameter("letter") + "\">25</a>");
                out.println("<a href=\"booklist.jsp?page=" + (currentPage) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=50" + "&letter=" + request.getParameter("letter") + "\">50</a>");
                // Pagination
                // Disable previous button while on first page
                out.println("<ul class=\"pagination\">");
                if(currentPage <= 1){
                    out.println("<li class=\"disabled\"><i class=\"material-icons\">chevron_left</i> Prev </li>");
                }else{
                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=" + (currentPage-1) + "&orderby=" + orderby + "&reverse=" + reverse + "&total=" + total + "&letter=" + letter + "\"><i class=\"material-icons\">chevron_left</i> Prev </a></li>");
                }
                // Disable next button while on last page
                if(currentPage >= Math.ceil(queryCount/total)){
                    out.println("<li class=\"disabled\"> Next <i class=\"material-icons\">chevron_right</i></li>");
                }else{
                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=" + (currentPage+1) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=" + request.getParameter("total") + "&letter=" + request.getParameter("letter") + "\">Next <i class=\"material-icons\">chevron_right</i></a></li></ul>");
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