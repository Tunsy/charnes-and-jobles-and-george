<%
	/*response.setHeader("Cache-Control","no-cache");
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
		
	}
	*/
	session = request.getSession(false);

%>