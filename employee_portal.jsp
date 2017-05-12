<%@page
	import="java.sql.*,
java.util.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*"%>

<%@include file="employee_navbar.jsp"%>

<h1 align="center">Employee Dashboard</h1>
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
		else if(request.getParameter("addBookBtn") != null)
		{
			Class.forName("com.mysql.jdbc.Driver").newInstance(); 
			Connection connection = (Connection) session.getAttribute("sqlConnection");
			
			String storedProcedure = "{call add_book(?,?,?,?,?,?,?,?,?,?)}";
			CallableStatement addBookProc = connection.prepareCall(storedProcedure);
			
			int isbn = Integer.parseInt(request.getParameter("isbn"));
			String title = request.getParameter("title");
			String publisher = request.getParameter("publisher");
			int year_published = Integer.parseInt(request.getParameter("yearpublished"));
			
			String genre = request.getParameter("genre");
			
			String first_name = request.getParameter("firstname");
			String last_name = request.getParameter("lastname");
			String dob = request.getParameter("dob");
			String photo_url = request.getParameter("photourl");
			
			addBookProc.setInt(1, isbn);
			addBookProc.setString(2,title);
			addBookProc.setInt(3,year_published);
			addBookProc.setString(4, publisher);
			
			addBookProc.setString(5, first_name);
			addBookProc.setString(6, last_name);
			addBookProc.setString(7, dob);
			addBookProc.setString(8, photo_url);
			
			addBookProc.setString(9, genre);
			addBookProc.registerOutParameter(10, java.sql.Types.VARCHAR);
			
			addBookProc.executeUpdate();
			out.print("<div class=\"card-panel green lighten-1 col s4 center-align\">" + addBookProc.getString(10) + "</div>");
		}
	}
	catch (SQLException ex) {
	    while (ex != null) {
	        ex = ex.getNextException();
	        out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid Date Format!</div>");
	    } // end while
	}// end catch SQLException
	catch (Exception ex) {
		out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid Data Format!</div>");
	} // end

%>
<div class="container">
	<div>
		<form action="employee_addAuthor.jsp"
			class="search-container center-align" method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="addAuthor">Add Author</button>
		</form>
		<form action="employee_addBook.jsp" class="center-align"
			method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="metadata">Add Book</button>
		</form>
		<form action="employee_metadata.jsp" class="center-align"
			method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="metadata">Show Metadata</button>
		</form>
		
	</div>
</div>


