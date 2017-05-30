<html>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"%>
<%@include file="css.html" %>
<%@include file="navbar.jsp" %>
<div class="container">
	<div>
		<%
                if(request.getParameter("order") != null && request.getParameter("order").equals("true")){
                    out.print("<div class=\"col s12 msg\"><div class=\"card-panel green lighten-1 col s4 center-align\">Your order has been placed!</div></div>");
                }
             %>

		<script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
		<script language="javascript" type="text/javascript">
			$(function() {
				$("#search").autocomplete({
					source: function (request, response) {
				        jQuery.get("/122b-second-coming/autocomplete.jsp", {
				           searchstring : request.term
				        }, function (data) {
				            response(JSON.parse(data));
				        });
				    },
				    minLength: 1
				});
			});
		</script>

		<nav class="navcontainer">
			<div class="nav-wrapper bluenav">
				<form name="searchbar" action="booklist.jsp"
					class="search-container center-align">
					<input type="hidden" name="page" value="1" /> <input type="hidden"
						name="orderby" value="title" /> <input type="hidden"
						name="reverse" value="false" /> <input type="hidden" name="total"
						value="10" />
					<div class="input-field">
						<input id="search" type="search" autocomplete="off"
							name="title" required> <label
							class="label-icon" for="search"> <i
							class="material-icons"> search </i>
						</label> <i class="material-icons"> close </i>
					</div>
					<div id="searchBtn">
						<button class="btn waves-effect waves-light" type="submit">
							Search</button>
						<a href="advancedsearch.jsp" id="advancedsearch"
							style="margin-left: 800px; margin-right: 0px">Advanced Search</a>
					</div>
				</form>

			</div>
		</nav>
		<br>
		<div class="row">
			<div class="guided-search alphabet">
				<h5 align="center">Browse books by title</h5>
				<ul class="pagination">
					<%
                        	for (char i= 'A'; i <= 'Z'; i++)
                        		out.println("<li class=\"waves-effect\"><a href=\"booklist.jsp?page=1&orderby=title&reverse=false&total=10&letter=" + i + "\">" + i + "</a></li>"); 
    					%>
				</ul>
			</div>
		</div>
		<div class="row">
			<div class="genre-search">
				<h5 align="center">Browse books by genre</h5>
				<%
                        	try {
								Connection c = (Connection) session.getAttribute("sqlConnection");
								response.setContentType("text/html");               
								Class.forName("com.mysql.jdbc.Driver").newInstance();
								Statement statement = c.createStatement();
							
								String genreQuery = "SELECT genre_name FROM genre ORDER BY genre_name ASC";
								ResultSet genres = statement.executeQuery(genreQuery);
						%>
				<form action="booklist.jsp">
					<input type="hidden" name="page" value="1" /> <input type="hidden"
						name="orderby" value="title" /> <input type="hidden"
						name="reverse" value="false" /> <input type="hidden" name="total"
						value="10" />
					<%  
	                            while(genres.next()){
	                                out.println("<button type=\"submit\" class=\"waves-effect waves-light btn genre-button\" name=\"genre\" value=\"" + genres.getString("genre_name") + "\">" + genres.getString("genre_name") + "</button>");
	                            }
	                            out.println("<button type=\"submit\" class=\"waves-effect waves-light btn genre-button\" name=\"genre\" value=\"Genreless\">Genreless</button>");
                        	}
                        	catch (NullPointerException ex){
                        		
                        	}
                        %>
				</form>
			</div>
		</div>
	</div>
</html>