<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"
%>

<html>
<%@include file="navbar.jsp"%>
<%@include file="css.html"%>

<%
	String isbn = request.getParameter("isbn");
	if(isbn != null) //btnSubmit is the name of your button, not id of that button.
	{
		out.println(request.getParameter("btn"));
		
    	out.println(isbn);
    	ArrayList<String> cart = (ArrayList) session.getAttribute("shoppingcart");
    	cart.add(isbn);
	}
	else{
		out.println("else");
	}
%>