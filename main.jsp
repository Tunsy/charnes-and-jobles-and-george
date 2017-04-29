<html>
<%@include file="css.html"%>
<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math"
%>
  
<%
	response.setHeader("Cache-Control","no-cache");
	response.setHeader("Cache-Control","no-store");
	response.setHeader("Pragma","no-cache");
	response.setDateHeader ("Expires", 0);
	if(session.getAttribute("email") == null){
		session.removeAttribute("email");
		session.invalidate();
		response.sendRedirect("index.jsp");
	}
%>
<%@include file="navbar.jsp"%>  
    <div class="container">
        <div>
			<p>
            	<a href="booklist.jsp?page=1&orderby=title&reverse=false&page=1&letter=all&total=10">
            		List of all books
            	</a>
           	</p>
		</div>
		<div>
            <nav class="navcontainer">
                <div class="nav-wrapper bluenav">
                    <form action="search.jsp" class="search-container">
                        <div class="input-field">
							<input id="search" type="search" name="search" required>
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
                            Connection c = DriverManager.getConnection(
                            session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
                            response.setContentType("text/html");               
                            Class.forName("com.mysql.jdbc.Driver").newInstance();
                            Statement statement = c.createStatement();

                            String genreQuery = "SELECT genre_name FROM genre";
                            ResultSet genres = statement.executeQuery(genreQuery);

                            while(genres.next()){
                                out.println("<a class=\"waves-effect waves-light btn genre-button\">" + genres.getString("genre_name") + "</a>");
                            }
                            out.println("<a class=\"waves-effect waves-light btn genre-button\">" + "No Genre" + "</a>");
                        %>               
                </div>
            </div>
    </div>
</html>