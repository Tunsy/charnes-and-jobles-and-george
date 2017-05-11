<%@page
	import="java.sql.*,
java.util.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"%>

<%@include file="employee_navbar.jsp"%>

<title>Employee Portal</title>

<%
	try
	{
		if(request.getParameter("addAuthorBtn") != null)
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance(); 
			Connection connection = (Connection) session.getAttribute("sqlConnection");
			
			String first_name = request.getParameter("firstname");
			String last_name = request.getParameter("lastname");
			String dob = request.getParameter("dob");
			String photo_url = request.getParameter("photourl");
			
			String query = "INSERT INTO author (first_name, last_name, dob, photo_url)" + " values (?, ?, ?, ?)";
			
			// create the mysql insert preparedstatement
			PreparedStatement preparedStmt = connection.prepareStatement(query);
			preparedStmt.setString(1, first_name);
			preparedStmt.setString(2, last_name);
			preparedStmt.setString(3, dob);
			preparedStmt.setString(4, photo_url);
	
			// execute the preparedstatement
			preparedStmt.execute();
			
			out.print("<div class=\"card-panel green lighten-1 col s4 center-align\">Add Author Successful!</div>");
		}
	}
	catch (SQLException ex) {
	    while (ex != null) {
	        ex = ex.getNextException();
	        out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid Date Format!</div>");
	    } // end while
	    	
	    
	}// end catch SQLException

%>
<div class="container">
	<div>
		<form action="employee_addAuthor.jsp"
			class="search-container center-align" method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="addAuthor">Add Author</button>
		</form>
		<form action="employee_metadata.jsp" class="center-align"
			method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="metadata">Show Metadata</button>
		</form>
	</div>
</div>


