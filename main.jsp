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
        <h1 align="center">
        	Charnes & Jobles & George
        </h1>
        <div>
			<p>
            	<a href="booklist.jsp?page=1&orderby=title&reverse=false&page=1&letter=all">
            		List of all books
            	</a>
           	</p>
		</div>
		<div>
            <nav class="navcontainer">
                <div class="nav-wrapper bluenav">
                    <form action="search.jsp">
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
                    </form>
                </div>
            </nav>
            <br>
            <div style="width:1800px" class="row">
                <div class="col s3 guided-search">
                    <h5>Browse books by title</h5>
                    <%
                    	for (char i= 'A'; i <= 'Z'; i++)
                    		out.println("<a href=\"booklist.jsp?page=1&orderby=title&reverse=false&letter=" + i + "\">" + i + "</a>"); 
					%>                
                </div>
            </div>
    </div>
</html>