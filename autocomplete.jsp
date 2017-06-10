<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter,
 javax.sql.DataSource"%>
 
<%@include file="cacheclear.jsp"%>

<%
	Connection c = null;
try {

	int pick = (int)(Math.random() % 2);
    if (pick == 0){
        c = ((DataSource) session.getAttribute("dsRead")).getConnection();
    }
    else{
        c = ((DataSource) session.getAttribute("dsWrite")).getConnection();
    }
	response.setContentType("text/html");               
	
	String str = request.getParameter("searchstring").trim();
	
	if (str != null && !str.equals("")){
		String[] searchstrings = str.split("\\s+");
		String query = "SELECT DISTINCT(title) FROM book WHERE MATCH (title) AGAINST (? IN BOOLEAN MODE) LIMIT 5;";
		
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
		String writeOutput = "";
		
		writeOutput += "[";
		int count = 0;
		while (rs.next()){
			writeOutput += "\"" + rs.getString(1) + "\", ";
			count++;
		}
		if (count != 0){
			writeOutput = writeOutput.substring(0, writeOutput.length() - 2);
		}
		writeOutput += "]";
		out.println(writeOutput);
	}

}catch (SQLException e){
}
finally{
	c.close();
}

%>