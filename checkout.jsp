<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter"
%>

<%@include file="css.html"%>
<%@include file="navbar.jsp"%>
<%
	try {
		Connection c = DriverManager.getConnection(
		session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
		response.setContentType("text/html");               
		Class.forName("com.mysql.jdbc.Driver").newInstance();
		
		ArrayList<ItemCounter> cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
		
		String query = "INSERT INTO sales (customer_id, isbn, sale_date)"
				+ " values (?, ?, ?)";
		PreparedStatement sale_statement = c.prepareStatement(query);
		java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
		out.println((int) session.getAttribute("customerID"));
		out.println(date);
		
		for (int i = 0; i < cart.size(); i++){		
			sale_statement.setInt(1, (int) session.getAttribute("customerID"));
			sale_statement.setInt(2, Integer.parseInt(cart.get(i).isbn()));
			sale_statement.setDate(3, date);
			
			out.println(cart.get(i).isbn());
			
			for (int j = 0; j < cart.get(i).quantity(); j++){
				sale_statement.execute();
			}
		}
		session.removeAttribute("shoppingcart");
		session.setAttribute("shoppingcart", new ArrayList<ItemCounter>());
	}
	catch (Exception e){
		
	}
%>

<html>
	<p> Order successful </p>
</html>