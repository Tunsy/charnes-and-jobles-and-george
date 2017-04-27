<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"
%>

<html>
  <head>
  	
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/css/materialize.min.css">
    <link href="style.css" rel="stylesheet">
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>           
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/js/materialize.min.js"></script>  
    <title>BooksList</title>
    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  
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

                // Order by chevrons
                out.println("<table class=\"bordered\">");
                out.println("<thead><tr><th>ISBN<a href=\"booklist.jsp?page=1&orderby=isbn&reverse=false&letter=" + request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=isbn&reverse=true&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_up</i></th></a><th>Title<a href=\"booklist.jsp?page=1&orderby=title&reverse=false&letter="
                	+ request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=title&reverse=true&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_up</i></th></a><th>Publisher<a href=\"booklist.jsp?page=1&orderby=publisher&reverse=false&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=publisher&reverse=true&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_up</i></th></a><th>Year<a href=\"booklist.jsp?page=1&orderby=year_published&reverse=false&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=year_published&reverse=true&letter=" +
                	request.getParameter("letter") +
                	"\"><i class=\"material-icons\">keyboard_arrow_up</i></th></a>" + 
                	request.getParameter("letter") +
                	"<th>Author</th></tr></thead>");

                // Calculate tablesize for pagination
                String spageid=request.getParameter("page");  
                int pageid=Integer.parseInt(spageid);  
                int currentPage;
                int total=15;  
                if(pageid!=1){
                    pageid=pageid-1;  
                    pageid=pageid*total+1;  
                }  
                currentPage = (pageid/15)+1;
                
                String orderby = request.getParameter("orderby");
                String query;
                ResultSet rs;
                
                // Change query based on letter and order
                if(request.getParameter("letter").equals("all")){
                    if(orderby == null){
                        query = "SELECT * from book LIMIT " + (pageid - 1) + "," + total;
                    }else if(orderby != null && request.getParameter("reverse").equals("true")){
                        query = "SELECT * from book " + "ORDER BY " + orderby + " DESC ";
                    }else{
                        query = "SELECT * from book " + "ORDER BY " + orderby;
                    }
                }else{
                    if(orderby == null){
                        query = "SELECT * from book " + "WHERE title LIKE \'" + request.getParameter("letter") + "%\'";
                    }else if(orderby != null && request.getParameter("reverse").equals("true")){
                        query = "SELECT * from book " + "WHERE title LIKE \'" + request.getParameter("letter") + "%\'" + " ORDER BY " + orderby + " DESC ";
                    }else{
                        query = "SELECT * from book " + "WHERE title LIKE \'" + request.getParameter("letter") + "%\'" + " ORDER BY " + orderby;
                    }
                }
                
                // Get the total query count to limit for pagination
                String countQuery;
                ResultSet rsCount;
                int queryCount = 0;
                countQuery = query.replace("*", "COUNT(*) AS total");
                out.println(countQuery);
                rsCount = statement.executeQuery(countQuery);
                if(rsCount.next()){
                    queryCount = rsCount.getInt("total");
                    out.println(queryCount);
                }
                query += " LIMIT " + (pageid - 1) + "," + total;    
                rs = statement.executeQuery(query);
                
                String author_query = "SELECT author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id";
                PreparedStatement author_statement = c.prepareStatement(author_query);
                            

                // Iterate through each row of rs
                while (rs.next()) {
                	String b_isbn = rs.getString("isbn");                    
                    
                	author_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet author_rs = author_statement.executeQuery();
                    
                    String b_title = rs.getString("title");
                    String b_year = rs.getString("year_published");
                    String b_publisher = rs.getString("publisher");
                    out.println("<tr>" + "<td>" + b_isbn + "</td>" + "<td>" + b_title + "</td>" + "<td>" + b_publisher + "</td>" + "<td>" + b_year + "</td>" + "<td style=\"width:200px\">");
                    while (author_rs.next())
                    {
                    	String a_firstName = author_rs.getString("first_name");
                    	String a_lastName = author_rs.getString("last_name");
                    	out.println(a_firstName + " " + a_lastName);
                    	if(!author_rs.isLast())
                    	{
                    		//out.println(", ");
                    		out.println("<br>");
                    	}
                    	
                    }
                    
            	    out.println("</td> + </tr>");
                    
                }
                out.println("</TABLE>");
                
                // Pagination
                // Disable previous button while on first page
                out.println("<ul class=\"pagination\">");
                if(currentPage <= 1){
                    out.println("<li class=\"disabled\"><i class=\"material-icons\">chevron_left</i> Prev </li>");
                }else{
                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=" + (currentPage-1) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&letter=" + request.getParameter("letter") + "\"><i class=\"material-icons\">chevron_left</i> Prev </a></li>");
                }
                // Disable next button while on last page
                if(currentPage >= Math.ceil(queryCount/15)){
                    out.println("<li class=\"disabled\"> Next <i class=\"material-icons\">chevron_right</i></li>");
                }else{
                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=" + (currentPage+1) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&letter=" + request.getParameter("letter") + "\">Next <i class=\"material-icons\">chevron_right</i></a></li></ul>");
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