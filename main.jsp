<html>
<%@include file="css.html"%>
  
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
    </div>
</html>