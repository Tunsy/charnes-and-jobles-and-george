<%@page import="java.sql.*,
java.util.*,
javax.sql.*,
java.io.IOException,
javax.servlet.http.*,
javax.servlet.*,
java.lang.Math,
javax.sql.DataSource"
%>

<%@include file="employee_navbar.jsp"%>

<%
		List<String> tableNames = new ArrayList<>();
		Connection connection = null;
        int pick = (int)(Math.random() % 2);
        if (pick == 0){
            connection = ((DataSource) session.getAttribute("dsRead")).getConnection();
        }
        else{
            connection = ((DataSource) session.getAttribute("dsWrite")).getConnection();
        }
		DatabaseMetaData md = connection.getMetaData();
		ResultSet rs = md.getTables(null, null, "%", null);
		while (rs.next()) {
			tableNames.add(rs.getString(3));
		}
		
		
		for (int i = 0; i < tableNames.size(); i++) {
			PreparedStatement statement = connection.prepareStatement("SELECT * FROM " + tableNames.get(i));
			ResultSet results = statement.executeQuery();

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
		connection.close();
%>