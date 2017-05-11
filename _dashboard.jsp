<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<html>
<%@include file="css.html"%>
	<head>
		<title>Charnes & Jobles & George</title>
	</head>
	<body>
	    <div class="container">
	        <h1 align="center"> Employee Dashboard</h1>
	        <div class="col s12 msg">
	        <%      	
	            if(request.getParameter("login") != null && request.getParameter("login").equals("-1")){
	                out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid login!</div>");
	            }else if(request.getParameter("login") != null && request.getParameter("login").equals("0")){
	                out.print("<div class=\"card-panel green lighten-1 col s4 center-align\">Logout successful!</div>");
	                session.removeAttribute("emp_email");
	                session.removeAttribute("emp_password");
	                session.invalidate();
	            }
	        %>
	        </div>
			<form class="col s12 center-align" action="employee_login.jsp" method="post">
				<div class="row"> 
		            <div class="input-field col s4 offset-s4">
						<input placeholder="panteater@uci.edu" id="emp_email" type="text" name="email" class="validate">
						<label for="email">Email</label>
					</div>
				</div>
				<div class="row">
		            <div class="input-field col s4 offset-s4">
						<input id="emp_password" type="password" name="password" class="validate">
						<label for="password">Password</label>
					</div>
				</div>
				<button class="btn waves-effect waves-light" type="submit" name="login">Login
				</button>
			</center>
	        </form>
		</div>
	</body>
</html>
