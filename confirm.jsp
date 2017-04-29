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
		out.println("Testing shopping cart");
    	ArrayList<String> cart = (ArrayList) session.getAttribute("shoppingcart");
    	for (int i = 0; i < cart.size(); i++)
    		out.println(cart.get(i));
%>