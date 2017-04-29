<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"
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