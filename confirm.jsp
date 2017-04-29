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
	if(request.getParameter("btn") != null) //btnSubmit is the name of your button, not id of that button.
	{
    	out.println("test");
    	ArrayList<String> cart = (ArrayList) session.getAttribute("shoppingcart");
    	//cart.add(isbn);
	}
	else{
		out.println("else");
	}
%>