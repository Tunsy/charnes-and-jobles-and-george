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
			
			ArrayList<ItemCounter> cart = session.getAttribute("shoppingcart");
			
			String query = "INSERT INTO sales (customer_id, isbn, sale_date)"
					+ " values (?, ?, ?, ?)";
			PrepareStatement sale_statement = c.prepareStatement(query);
			
			for (int i = 0; i < cart.size(); i++){
				set
			}
			
		}
		catch (Exception e){
			
		}
%>