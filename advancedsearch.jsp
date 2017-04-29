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
		<form action="booklist.jsp">
			<input type="hidden" name="page" value="1" />
			<input type="hidden" name="orderby" value="title" />
			<input type="hidden" name="reverse" value="false" />
			<input type="hidden" name="letter" value="all" />
			<input type="hidden" name="total" value="10" />
			<div>
				<h5 class="label-icon">
					Title
				</h5>
					<input placeholder="e.g. Don Quixote" style="placeholder" id="title" name="title">
					<input type="checkbox" id="fuzzy-1" name="title_fuzzy_search" value="true">
					<label for="fuzzy-1">
						Fuzzy Search
					</label>
					<br>
				<h5 class="label-icon">
					Year
				</h5>
					<input id="year" name="year">
					<br>
				<h5 class="label-icon">
					Publisher
				</h5>
					<input id="publisher" name="publisher">
					<input type="checkbox" id="fuzzy-2" name="publisher_fuzzy_search" value="true">
					<label for="fuzzy-2">
						Fuzzy Search
					</label>
					<br>
				<h5 class="label-icon">
					Author
				</h5>
					<tr>
						<td>
							<input placeholder="first name" style="placeholder" id="author_first_name" name="author_first_name">
							<input class="row" type="checkbox" id="fuzzy-3" name="first_name_fuzzy_search" value="true">
							<label for="fuzzy-3">
								Fuzzy Search
							</label>
						</td>
						<br>
						<td>
							<input placeholder="last name" style="placeholder" id="author_last_name" name="author_last_name">
							<input type="checkbox" id="fuzzy-4" name="last_name_fuzzy_search" value="true">
							<label for="fuzzy-4">
								Fuzzy Search
							</label>
						</td>
					</tr>
			</div>
			<button class="btn waves-effect waves-light" type="submit" name="advancedsearch" value="true">
				Search
			</button>
		</form>
	</div>
</html>