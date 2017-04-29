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
                	"<th>Author</th>" + "<th>Genre</th>" + "<th>Price</th>" + "<th>Quantity</th></tr></thead>");
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