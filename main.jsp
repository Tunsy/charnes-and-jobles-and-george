<html>
<%@include file="css.html"%>
<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"%>

<%@include file="navbar.jsp"%>
<div class="container">
	<div>
		<%
                if(request.getParameter("order") != null && request.getParameter("order").equals("true")){
                    out.print("<div class=\"col s12 msg\"><div class=\"card-panel green lighten-1 col s4 center-align\">Your order has been placed!</div></div>");
                }
             %>


		<script language="javascript" type="text/javascript">
			//Browser Support Code
			function autocompletefunc(){
				var ajaxRequest; // The variable that makes Ajax possible!
				var querystring = "/122b-second-coming/autocomplete.jsp?searchstring=";
				querystring = querystring.concat(document.searchbar.search.value);
				querystring = querystring.replace(/\s/g, '+');
				try {
					// Opera 8.0+, Firefox, Safari
					ajaxRequest = new XMLHttpRequest();
				} catch (e) {
					// Internet Explorer Browsers
					try {
						ajaxRequest = new ActiveXObject("Msxml2.XMLHTTP");
					} catch (e) {
						try {
							ajaxRequest = new ActiveXObject("Microsoft.XMLHTTP");
						} catch (e) {
							// Something went wrong
							alert("Your browser broke!");
							return false;
						}
					}
				}
				// Create a function that will receive data sent from the server
				ajaxRequest.onreadystatechange = function() {
					if (ajaxRequest.readyState == 4) {
						document.getElementById("autocompletebox").innerHTML = this.responseText;
						//document.write(document.searchbar.search.value);
						//document.write(querystring);
						//document.write(this.responseText);
						// modal with 5 rows.
					}
				};
				ajaxRequest.open("POST", querystring, true);
				ajaxRequest.send();
			}
		</script>

		<nav class="navcontainer">
			<div class="nav-wrapper bluenav">
				<form name="searchbar" action="booklist.jsp" class="search-container center-align">
					<input type="hidden" name="page" value="1" />
					<input type="hidden" name="orderby" value="title" />
					<input type="hidden" name="reverse" value="false" />
					<input type="hidden" name="total" value="10" />
					<div class="input-field">
						<input list="autocompletebox" id="search" type="search" onInput="autocompletefunc()" name="title" required> <label
							class="label-icon" for="search"> <i
							class="material-icons"> search </i>
						</label> <i class="material-icons"> close </i>
						<datalist id="autocompletebox">
						</datalist>
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