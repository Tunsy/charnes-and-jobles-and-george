<%@page import="java.sql.*,
java.util.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
java.lang.Math"
%>

<%@include file="employee_navbar.jsp"%>

<%
		List<String> tableNames = new ArrayList<>();
		Connection connection = (Connection) session.getAttribute("sqlConnection");
		DatabaseMetaData md = connection.getMetaData();
		ResultSet rs = md.getTables(null, null, "%", null);
		while (rs.next()) {
			tableNames.add(rs.getString(3));
		}
		
		
		for (int i = 0; i < tableNames.size(); i++) {
			Statement statement = connection.createStatement();
			ResultSet results = statement.executeQuery("SELECT * FROM " + tableNames.get(i));

			// Get metadata from stars; print # of attributes in table
			ResultSetMetaData metadatas = results.getMetaData();

			// Table for each database table
			out.println("<table class=\"bordered center-align\" style=\"width: 300px;margin-left: 5%\">");
			
			// Print table names
			out.println("<thead><tr><th>" + tableNames.get(i) + "</th></tr></thead>");

			// Print column names
			if (results.isBeforeFirst()) {
				for (int j = 1; j <= metadatas.getColumnCount(); j++) {
					out.println("<tr>");
					out.println("<td style=\"width:150px\">" + metadatas.getColumnName(j) + "</td>");
					out.println("<td style=\"width:150px\">" + metadatas.getColumnTypeName(j) + "</td>");
					out.println("</tr>");
				}
			}
			out.println("</table>");
			out.println("<br>");
		}
%>