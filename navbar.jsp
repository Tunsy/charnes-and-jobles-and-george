<nav>
	<div class="nav-wrapper">
		<a href="main.jsp" class="brand-logo navlogo"> Charnes & Jobles &
			George</a>
		<ul id="nav-mobile" class="right hide-on-med-and-down">
			<li><a
				href="shoppingcart.jsp?page=1&orderby=title&reverse=false&total=10"><i
					class="material-icons">shopping_cart</i></a></li>
			<!--<% //if((int)session.getAttribute("itemCount") != null && (int)session.getAttribute("itemCount") != 0) %>
                    <span class="new badge">4</span>-->
			<li><a href="main.jsp">Home</a></li>
			<li><a href="index.jsp?login=0">Logout</a></li>
		</ul>
	</div>
</nav>

<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if((String) session.getAttribute("email") == null || ((String) session.getAttribute("email")).equals("null")){
		session.removeAttribute("email");
		session.removeAttribute("shoppingcart");
		session.invalidate();
		session = request.getSession(false);
		String loginUser = "root";
        String loginPasswd = "122b";
        String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
		response.sendRedirect("index.jsp");
		/* RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.forward(request, response); */
	}
%>