<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<%@include file="css.html"%>
<%@include file="navbar.jsp"%>
<html>
	<div class="header" align="center">
		<h4>
			Advanced Search
		</h4>
	</div>
	<div class="container">
		<form action="search.jsp">
			<h5 class="label-icon">
				Title
			</h5>
			<div class="input-field padding-bottom-3">
				<input placeholder="e.g. Don Quixote" style="placeholder" id="title" name="title">
				<br>
			</div>
			<h5 class="label-icon">
				Year
			</h5>
			<div class="input-field padding-bottom-3">
				<input id="year" name="year">
				<br>
			</div>
			<h5 class="label-icon">
				Publisher
			</h5>
			<div class="input-field padding-bottom-3">
				<input id="publisher" name="publisher">
				<br>
			</div>
			<h5 class="label-icon">
				Author
			</h5>
			<div class="input-field padding-bottom-3">
				<input placeholder="first name" style="placeholder" id="author_first_name" name="author_first_name">
				<input placeholder="last name" style="placeholder"id="author_last_name" name="author_last_name">
			</div>
			<button class="btn waves-effect waves-light" type="submit">
				Search
			</button>
		</form>
	</div>
</html>