<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*,
 cart.ItemCounter"%>

<h1 align="center">Charnes & Jobles & George</h1>

<%

    String logout = request.getParameter("logout");
    String login = request.getParameter("login");

    if(logout != null){
        request.setAttribute("login", "0");
    }else if(login != null){
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        session.setAttribute("email", email);
        
        if(email == null || password == null){
            request.setAttribute("login", -1);
        }
		
        ArrayList<ItemCounter> shoppingcartitems = new ArrayList<ItemCounter>();
        
        session.setAttribute("shoppingcart", shoppingcartitems);
        
        String loginUser = "root";
        String loginPasswd = "122b";
        String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
        session.setAttribute("sqlUser", loginUser);
        session.setAttribute("sqlPassword", loginPasswd);
        session.setAttribute("sqlURL", loginUrl);
        Class.forName("com.mysql.jdbc.Driver").newInstance();       
        Connection c = DriverManager.getConnection(loginUrl, loginUser, loginPasswd);
		
        
        
        String query = "SELECT email, emailpw, id FROM customers WHERE customers.email = ?";
        PreparedStatement statement = c.prepareStatement(query);
        statement.setString(1, email);
        ResultSet rs = statement.executeQuery();
        
        if (!rs.isBeforeFirst()) {
            request.setAttribute("login", "-1");
            session.removeAttribute("email");
        }
        else{
      		rs.next();
			if (!password.equals(rs.getString(2))){
				request.setAttribute("login", "-1");
				session.removeAttribute("email");
			}
			else{
            	request.setAttribute("login", "1");
            	session.setAttribute("customerID", rs.getString(3));
			}
        }
    }
    

    if(request.getAttribute("login") != null && request.getAttribute("login").equals("1")){
    	response.sendRedirect("main.jsp");
    }else{
        response.sendRedirect("index.jsp?login=" + request.getAttribute("login"));
    }
%>
