<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>
<%@include file="css.html"%>

<%@include file="navbar.jsp"%>

<h1 align="center"> Charnes & Jobles & George</h1>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if(session.getAttribute("email") == null){
		session.removeAttribute("email");
		session.invalidate();
		response.sendRedirect("index.jsp");
	}else{
		String searchstring = request.getParameter("search");
	

		Connection c = DriverManager.getConnection(
            session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
        response.setContentType("text/html");               
        Class.forName("com.mysql.jdbc.Driver").newInstance();
        
	
	    String query = "SELECT * FROM book WHERE book.title = ?";
	    PreparedStatement statement = c.prepareStatement(query);
	    statement.setString(1, searchstring);
	    ResultSet rs = statement.executeQuery();
	    
	    if (rs.isBeforeFirst()) {
			out.println("<table class=\"bordered\"><thead><th>ISBN</th><th>Title</th><th>Year</th><th>Publisher</th></tr></thead>");
			out.println("<tbody>");
			while (rs.next()) {
				int isbn = rs.getInt(1);
				String title = rs.getString(2);
				int year = rs.getInt(3);
				String publisher = rs.getString(4);
				out.println("<tr><td>" + isbn + "</td>");
				out.println("<td>" + title + "</td>");
				out.println("<td>" + year + "</td>");
				out.println("<td>" + publisher + "</td></tr>");
			}
		} else {
			out.println("<h6>No data</h6>");
		}		
	}
%>

