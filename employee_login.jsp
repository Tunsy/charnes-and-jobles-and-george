<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.util.*,
 javax.naming.InitialContext,
 javax.naming.Context,
 javax.sql.DataSource
"%>

<h1 align="center">Employee Dashboard</h1>

<%

    String logout = request.getParameter("logout");
    String login = request.getParameter("login");

    if(logout != null){
        request.setAttribute("login", "0");
    }else if(login != null){
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        session.setAttribute("emp_email", email);
        
        // Credential check
        if(email == null || password == null){
            request.setAttribute("login", -1);
        }		
        
        String loginUser = "root";
        String loginPasswd = "122b";
        String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
        session.setAttribute("sqlUser", loginUser);
        session.setAttribute("sqlPassword", loginPasswd);
        session.setAttribute("sqlURL", loginUrl);
        Context initialContext = new InitialContext();         
        Context envContext = (Context) initialContext.lookup("java:comp/env");
        DataSource dsRead = (DataSource) envContext.lookup("jdbc/read");
        DataSource dsWrite = (DataSource) envContext.lookup("jdbc/write");
        Connection c;
        int pick = (int)(Math.random() % 2);
        if (pick == 0){
            c = dsRead.getConnection();
        }
        else{
            c = dsWrite.getConnection();
        }
        session.setAttribute("dsRead", dsRead);
        session.setAttribute("dsWrite", dsWrite);
        session.setAttribute("sqlConnection", c);
		       
        String query = "SELECT email, pw, fullname FROM employee WHERE employee.email = ?";
        PreparedStatement statement = c.prepareStatement(query);
        statement.setString(1, email);
        ResultSet rs = statement.executeQuery();
        
        if (!rs.isBeforeFirst()) {
            request.setAttribute("login", "-1");
            session.removeAttribute("emp_email");
        }
        else{
      		rs.next();
			if (!password.equals(rs.getString(2))){
				request.setAttribute("login", "-1");
				session.removeAttribute("emp_email");
			}
			else{
            	request.setAttribute("login", "1");
            	session.setAttribute("employeeFullName", rs.getString(3));
			}
        }
    }
    

    if(request.getAttribute("login") != null && request.getAttribute("login").equals("1")){
    	response.sendRedirect("employee_portal.jsp");
    }else{
        response.sendRedirect("_dashboard.jsp?login=" + request.getAttribute("login"));
    }
%>
