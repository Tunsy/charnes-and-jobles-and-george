<html>
<%@include file="css.html"%>
<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"
%>
  
<%@include file="navbar.jsp"%>  
    <div class="container">
        <div>
			<p>
				<form action="booklist.jsp">
					<input type="hidden" name="page" value="1" />
					<input type="hidden" name="orderby" value="title" />
					<input type="hidden" name="reverse" value="false" />
					<input type="hidden" name="letter" value="all" />
					<input type="hidden" name="total" value="10" />
					<button type="submit" class="btn-link">
	            		List of all books						
					</button>
				</form>
           	</p>
		</div>
		<div>
            <nav class="navcontainer">
                <div class="nav-wrapper bluenav">
                    <form action="booklist.jsp" class="search-container">
						<input type="hidden" name="page" value="1" />
						<input type="hidden" name="orderby" value="title" />
						<input type="hidden" name="reverse" value="false" />
						<input type="hidden" name="total" value="10" />
                        <div class="input-field">
                        <input id="search" type="search" name="title" required>
							<label class="label-icon" for="search">
								<i class="material-icons">
									search
								</i>
							</label>
							<i class="material-icons">
								close
							</i>
                        </div>
                        <button class="btn waves-effect waves-light" type="submit">
                        	Search
                        </button>
						<div class="advancedsearch">
		                	<a href="advancedsearch.jsp" font="black">Advanced Search</a>
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
								Connection c = DriverManager.getConnection(
								session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
								response.setContentType("text/html");               
								Class.forName("com.mysql.jdbc.Driver").newInstance();
								Statement statement = c.createStatement();
							
								String genreQuery = "SELECT genre_name FROM genre ORDER BY genre_name ASC";
								ResultSet genres = statement.executeQuery(genreQuery);
						%>
						<form action="booklist.jsp">
							<input type="hidden" name="page" value="1" />
							<input type="hidden" name="orderby" value="title" />
							<input type="hidden" name="reverse" value="false" />
							<input type="hidden" name="total" value="10" />
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