<%@include file="css.html"%>
<nav>
	<div class="nav-wrapper">
		<a href="employee_portal.jsp" class="brand-logo navlogo"> Charnes & Jobles &
			George</a>
		<ul id="nav-mobile" class="right hide-on-med-and-down">
			<li><a href="_dashboard.jsp?login=0">Logout</a></li>
		</ul>
	</div>
</nav>
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if((String) session.getAttribute("emp_email") == null || ((String) session.getAttribute("emp_email")).equals("null")){
		session.removeAttribute("emp_email");
		session.invalidate();
		session = request.getSession(false);
		String loginUser = "root";
        String loginPasswd = "122b";
        String loginUrl = "jdbc:mysql://localhost:3306/booksdb";
		response.sendRedirect("_dashboard.jsp");
		/* RequestDispatcher rd = request.getRequestDispatcher("index.jsp");
        rd.forward(request, response); */
	}
%>