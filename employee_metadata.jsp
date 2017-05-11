<%@page import="java.sql.*,
java.util.ArrayList,
java.util.List,
java.util.Properties,
java.util.Scanner;"
%>

<%@include file="employee_navbar.jsp"%>

<%
		List<String> tableNames = new ArrayList<>();
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

			// Print table names
			out.println("Table: " + tableNames.get(i));

			// Print column names
			if (results.isBeforeFirst()) {
				for (int j = 1; j <= metadatas.getColumnCount(); j++) {
					out.printf("%-20s %s", metadatas.getColumnName(j), metadatas.getColumnTypeName(j));
					out.println("<br>");
				}
			}
		}
%>