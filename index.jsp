<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<html>
<%@include file="css.html"%>
	<head>
		<script src='https://www.google.com/recaptcha/api.js'></script>
		<title>Charnes & Jobles & George</title>
	</head>
	<body>
	    <div class="container">
	        <h1 align="center"> Charnes & Jobles & George</h1>
	        <div class="col s12 msg">
	        <%      	
	            if(request.getParameter("login") != null && request.getParameter("login").equals("-1")){
	                out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid login!</div>");
	            }else if(request.getParameter("login") != null && request.getParameter("login").equals("0")){
	                out.print("<div class=\"card-panel green lighten-1 col s4 center-align\">Logout successful!</div>");
	                session.removeAttribute("email");
	                session.removeAttribute("password");
	                session.invalidate();
	            }else if (request.getParameter("login") != null && request.getParameter("login").equals("-2")){
	            	out.print("<div class=\"card-panel red darken-2 center-align col s4\">Robots not allowed!</div>");
	            }
	        %>
	        </div>
			<form class="col s12 center-align" action="login.jsp" method="post">
				<div class="row"> 
		            <div class="input-field col s4 offset-s4">
						<input placeholder="panteater@uci.edu" id="email" type="text" name="email" class="validate">
						<label for="email">Email</label>
					</div>
				</div>
				<div class="row">
		            <div class="input-field col s4 offset-s4">
						<input id="password" type="password" name="password" class="validate">
						<label for="password">Password</label>
					</div>
				</div>
				<button class="btn waves-effect waves-light" type="submit" name="login">Login
				</button>
				<div class="g-recaptcha" data-sitekey="6Lf8ByAUAAAAAEmxMjdKh70v-UVOJyX-I5IwY-On"></div>
			</center>
	        </form>
		</div>
	</body>
</html>
