<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter"%>
 
<%@include file="cacheclear.jsp"%>

<%
try {
	Connection c = (Connection) session.getAttribute("sqlConnection");
	response.setContentType("text/html");               
	Class.forName("com.mysql.jdbc.Driver").newInstance();
	
	String str = request.getParameter("searchstring").trim();
	
	if (str != null && !str.equals("")){
		String[] searchstrings = str.split("\\s+");
		String query = "SELECT title FROM book WHERE MATCH (title) AGAINST (? IN BOOLEAN MODE) LIMIT 5;";
		
		//out.println(query);
		PreparedStatement pstatement = c.prepareStatement(query);
		
		String input = "";
		int searchstringIndex;
		for (searchstringIndex = 0; searchstringIndex < searchstrings.length - 1; searchstringIndex++){
			input += "+" + searchstrings[searchstringIndex] + " ";
		}
		input += "+" + searchstrings[searchstringIndex] + "*";
		
		pstatement.setString(1, input);
		//out.println(pstatement);
		ResultSet rs = pstatement.executeQuery();
		while (rs.next()){
		//	out.println(rs.getString(1) + "<br>");
			out.println("<option value=\"" + rs.getString(1) + "\">" + rs.getString(1) + "</option>");	// <option value="rs.getString(1)">
		}			
	}

}catch (SQLException e){
}

%>