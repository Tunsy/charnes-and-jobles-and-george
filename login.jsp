<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*"
%>

<%@include file="pair.jsp"
%>

<h1 align="center"> Charnes & Jobles & George</h1>

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

        String query = "SELECT * FROM customers WHERE customers.email = ? AND customers.emailpw = ?";
        PreparedStatement statement = c.prepareStatement(query);
        statement.setString(1, email);
        statement.setString(2, password);
        ResultSet rs = statement.executeQuery();
        if (!rs.isBeforeFirst()) {
            request.setAttribute("login", "-1");
        }else{
            request.setAttribute("login", "1");
        }
    }
    

    if(request.getAttribute("login").equals("1")){
    	response.sendRedirect("main.jsp");
    }else{
        response.sendRedirect("index.jsp?login=" + request.getAttribute("login"));
    }
%>
