<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter,
 javax.sql.DataSource"
%>

<%@include file="css.html"%>
<%@include file="navbar.jsp"%>
<%
		Connection c = null; 
	try {
		boolean validInfo = true; 

		int pick = (int)(Math.random() % 2);
	    if (pick == 0){
	        c = ((DataSource) session.getAttribute("dsRead")).getConnection();
	    }
	    else{
	        c = ((DataSource) session.getAttribute("dsWrite")).getConnection();
	    }
		response.setContentType("text/html");
		Connection cw = ((DataSource) session.getAttribute("dsWrite")).getConnection();
		
		
		String ccQuery = "SELECT * FROM creditcards WHERE id = ? AND first_name = ? AND last_name = ? AND expiration = ?";
		PreparedStatement ccStatement = c.prepareStatement(ccQuery);
		ResultSet rs = null;
		java.sql.Date expDate = null;
		try
		{
			expDate = java.sql.Date.valueOf(request.getParameter("expdate").trim());
			ccStatement.setString(1, request.getParameter("ccn"));
	        ccStatement.setString(2, request.getParameter("firstname"));
	        ccStatement.setString(3, request.getParameter("lastname"));
	        ccStatement.setString(4, request.getParameter("expdate").trim());
	        rs = ccStatement.executeQuery();
	        if (!rs.isBeforeFirst()) {
	        	validInfo = false;
	        }
		}
		catch (IllegalArgumentException e) {
			validInfo = false;
	    }
		catch (SQLException e) {
			validInfo = false;
		}
        	
        
		ArrayList<ItemCounter> cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
		
		String query = "INSERT INTO sales (customer_id, isbn, sale_date)"
				+ " values (?, ?, ?)";
		PreparedStatement sale_statement = cw.prepareStatement(query);
		java.sql.Date date = new java.sql.Date(System.currentTimeMillis());
		if(validInfo == true)
		{
			for (int i = 0; i < cart.size(); i++){		
				sale_statement.setInt(1, (int) session.getAttribute("customerID"));
				sale_statement.setInt(2, Integer.parseInt(cart.get(i).isbn()));
				sale_statement.setDate(3, date);
				
				for (int j = 0; j < cart.get(i).quantity(); j++){
					sale_statement.execute();
				}
			}
			session.removeAttribute("shoppingcart");
			session.setAttribute("shoppingcart", new ArrayList<ItemCounter>());
			out.println("Order Successful");
			response.sendRedirect("main.jsp?order=true");
		}
		else
		{
		 	response.sendRedirect("shoppingcart.jsp?page=1&orderby=title&reverse=false&total=10&invalid=true");
		}
	}
	catch (Exception e){
		
	}
	finally{
	c.close();
	cw.close();
}
%>
