<html>
  <head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?page=1&orderby=title&reverse=false&family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/css/materialize.min.css">
    <link href="style.css" rel="stylesheet">
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>           
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/js/materialize.min.js"></script>  

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  
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
        <h1 align="center"> Charnes & Jobles & George</h1>
        <div>
            <p><a href="booklist.jsp?page=1&orderby=title&reverse=false&page=1&letter=all">List of all books</a></p>
        </div>
        <div>
            <nav class="navcontainer">
                <div class="nav-wrapper bluenav">
                    <form action="search.jsp">
                        <div class="input-field">
                              <input id="search" type="search" name="search" required>
                              <label class="label-icon" for="search"><i class="material-icons">search</i></label>
                              <i class="material-icons">close</i>
                        </div>
                        <button class="btn waves-effect waves-light" type="submit">Search
                         </button>
                    </form>
                </div>
            </nav>
            <br>
            <div class="row">
                <div class="col s3 guided-search">
                    <h5>Browse books by title</h5>
                    <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=A">A</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=B">B</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=C">C</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=D?">D</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=E">E</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=F">F</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=G">G</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=H">H</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=I">I</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=J">J</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=K">K</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=L">L</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=M">M</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=N">N</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=O">O</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=P">P</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=Q">Q</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=R">R</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=0">S</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=T">T</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=U">U</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=V">V</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=W">W</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=X">X</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=Y">Y</a> | <a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=Z">Z</a> 
                </div>
            </div>
    </div>
</html>