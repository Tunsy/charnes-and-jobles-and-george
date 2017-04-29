<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"%>

<%@include file="pair.jsp"%>

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
	   String pageRefresher = "page=" + request.getParameter("page");
	   qstring = qstring.replace(pageRefresher, "page=1");	// When sorting, forward to page 1
%>
		<table class="bordered">
			<thead>
				<tr>
					<th style="width: 80px">ISBN <a
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
				
				String query = "";
				ResultSet rs;
				
				// Change query based on letter and order
				String advancedsearch = request.getParameter("advancedsearch");
				String browsegenre = request.getParameter("genre");
				String title = request.getParameter("title");
				String orderby = request.getParameter("orderby");
				String letter = request.getParameter("letter");
				String reverse = request.getParameter("reverse");
				
				if (advancedsearch == null){
	         		// Search by title (first letter/all books)
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
	         		// Browse by genre
		         	else if (browsegenre != null && !browsegenre.equals("")){
						query = "SELECT DISTINCT(book.isbn), book.title, book.year_published, book.publisher " +
								"FROM (book LEFT JOIN genre_in_books ON book.isbn = genre_in_books.isbn) LEFT JOIN genre ON id = genre_id " +
								"WHERE genre_name";
		         		if (browsegenre.equals("Genreless")){
		         			query += " IS NULL ";
		         		}
		         		else{
							query += " = '" + browsegenre + "' AND genre_in_books.genre_id = genre.id AND genre_in_books.isbn = book.isbn ";
		         		}
						query += "ORDER BY " + orderby;		         			
		         		if (reverse.equals("true")){
							query += " DESC ";
						}
					}
		         	// Search by simple generic title match
		         	else if (title != null && !title.equals("")){
		         		query = "SELECT * FROM book WHERE title = '" + title + "' ORDER BY " + orderby;
		         		if (reverse.equals("true")){
							query += " DESC ";
						}
		         	}
				}
				else{	// GENERATE ADVANCED SEARCH QUERY
					//String title = request.getParameter("title"); DUPLICATE VARIABLE
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
                String countQuery = "";
                ResultSet rsCount;
                int queryCount = 0;
                
                if (advancedsearch == null){
                	if (letter != null && !letter.equals("") || title != null && !title.equals("")){
						countQuery = query.replace("*", "COUNT(*) AS total");
                	}
                	else if (browsegenre != null && !browsegenre.equals("")){
                		countQuery = query.replace("DISTINCT(book.isbn), book.title, book.year_published, book.publisher", "COUNT(DISTINCT(book.isbn)) AS total");
	                }
                }
                else{
                	countQuery = query.replace("DISTINCT(book.isbn), book.title, book.year_published, book.publisher", "COUNT(DISTINCT(book.isbn)) AS total");
                }
                
                rsCount = statement.executeQuery(countQuery);
                
                if(rsCount.next()){
                    queryCount = rsCount.getInt("total");
                }
                if (queryCount != 0){
	                query += " LIMIT " + (pageid - 1) + "," + total;
	                rs = statement.executeQuery(query);
	                
	                String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id ORDER BY last_name, first_name ASC";
	                PreparedStatement author_statement = c.prepareStatement(author_query);
	                
	                String genre_query = "SELECT genre_name FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id ORDER BY genre_name ASC";
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
	                    
	            	    out.println("<td style=\"width: 300px\">");
	            	    
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
			<form
				action="booklist.jsp?<% out.println(request.getQueryString()); %>"
				method="post">
				<input type="hidden" name="isbn" value=<% out.println(b_isbn); %> />
				<button type="submit" class="waves-effect waves-light btn"
					name="btn" value="default">
					<i class="material-icons left"> shopping_cart </i> Add
				</button>
			</form>

			<%              out.print("</td></tr>");
							if(singleAddBtn != null) //btnSubmit is the name of your button, not id of that button.
							{
								ArrayList<ItemCounter> cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
								boolean duplicate = false;
								if(cart.size() == 0)
								{
									ItemCounter book = new ItemCounter(isbn);
									cart.add(book);
								}
								else
								{
									ItemCounter book = new ItemCounter(isbn);
									
									for(int i = 0; i < cart.size(); i++)
									{
										if(cart.get(i).isbn() == book.isbn())
										{
											duplicate = true;
											cart.get(i).increment();
											break;
										}
									}
									
									if(!duplicate)
									{
										cart.add(book);
									}
								}
								
								
								singleAddBtn = null;
							}
	                }
	                out.println("</TABLE>");
	                //Limit data
					String formatTotal = "total=" + request.getParameter("total");
	                out.println("Limit books per page: ");			
	                out.println("<a href=\"booklist.jsp?" + qstring.replace(formatTotal, "total=5") + "\">5</a>");		// qstring has page=1
	                out.println("<a href=\"booklist.jsp?" + qstring.replace(formatTotal, "total=15") + "\">15</a>");
	                out.println("<a href=\"booklist.jsp?" + qstring.replace(formatTotal, "total=25") + "\">25</a>");
	                out.println("<a href=\"booklist.jsp?" + qstring.replace(formatTotal, "total=50") + "\">50</a>");
	                // Pagination
	                // Disable previous button while on first page
	                out.println("<ul class=\"pagination\">");
	                String formatCurrentPage = "page=" + spageid;	// String version of page
	                String newPagePrev = "page=" + Integer.toString(currentPage-1);
	                String newPageForward = "page=" + Integer.toString(currentPage+1);
	                if(currentPage <= 1){
	                    out.println("<li class=\"disabled\"></li>");
	                }else{
	                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?" + request.getQueryString().replace(formatCurrentPage, newPagePrev) + "\"><i class=\"material-icons\">chevron_left</i> Prev </a></li>");
	                }
	                // Disable next button while on last page
	                if(currentPage >= Math.ceil(queryCount/total)){
	                    out.println("<li class=\"disabled\"></li>");
	                }else{
	                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?"  + request.getQueryString().replace(formatCurrentPage, newPageForward) +  "\">Next <i class=\"material-icons\">chevron_right</i></a></li></ul>");
	                }
                }
                // EMPTY RESULT SET (NO QUERIES)
                else{
                	out.println("<div><p>Search found 0 results.</p></div>");
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