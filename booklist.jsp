<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"
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

                // Order by chevrons
                out.println("<table class=\"bordered\">");
                out.println("<thead><tr><th style=\"width:100px\">ISBN<a href=\"booklist.jsp?page=1&orderby=isbn&reverse=false&total=10&letter=" + request.getParameter("letter") + "\">" +
            		"<i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=isbn&reverse=true&total=10&letter=" + request.getParameter("letter") + "\">" +
                	"<i class=\"material-icons\">keyboard_arrow_up</i></th></a>" + 
                	"<th>Title<a href=\"booklist.jsp?page=1&orderby=title&reverse=false&total=10&letter=" + request.getParameter("letter") + "\">" +
            		"<i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=title&reverse=true&total=10&letter=" + request.getParameter("letter") + "\">" +
                	"<i class=\"material-icons\">keyboard_arrow_up</i></th></a>" +
            		"<th style=\"width:200px\">Publisher<a href=\"booklist.jsp?page=1&orderby=publisher&reverse=false&total=10&letter=" + request.getParameter("letter") +"\">" +
                	"<i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=publisher&reverse=true&total=10&letter=" + request.getParameter("letter") +"\">" +
                	"<i class=\"material-icons\">keyboard_arrow_up</i></th></a>" +
                	"<th style=\"width:100px\">Year<a href=\"booklist.jsp?page=1&orderby=year_published&reverse=false&total=10&letter=" + request.getParameter("letter") +"\">" +
                	"<i class=\"material-icons\">keyboard_arrow_down</i></a><a href=\"booklist.jsp?page=1&orderby=year_published&reverse=true&total=10&letter=" + request.getParameter("letter") +"\">" +
                	"<i class=\"material-icons\">keyboard_arrow_up</i></th></a>" +
                	"<th>Author</th></tr></thead>");

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
                //out.println(countQuery);
                rsCount = statement.executeQuery(countQuery);
                if(rsCount.next()){
                    queryCount = rsCount.getInt("total");
                    //out.println(queryCount);
                }
                query += " LIMIT " + (pageid - 1) + "," + total;    
                rs = statement.executeQuery(query);
                
                String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id";
                PreparedStatement author_statement = c.prepareStatement(author_query);
                            

                // Iterate through each row of rs
                while (rs.next()) {
                	String b_isbn = rs.getString("isbn");                    
                    
                	author_statement.setInt(1, Integer.parseInt(b_isbn));
            	    ResultSet author_rs = author_statement.executeQuery();
                    
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
                    
            	    out.println("</td></tr>");
                    
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
                    out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=" + (currentPage-1) + "&orderby=" + orderby + "&reverse=" + request.getParameter("reverse") + "&total=" + request.getParameter("total") + "&letter=" + request.getParameter("letter") + "\"><i class=\"material-icons\">chevron_left</i> Prev </a></li>");
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