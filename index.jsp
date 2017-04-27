<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*"
%>

<html>
  <head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/css/materialize.min.css">
    <link href="style.css" rel="stylesheet">
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>           
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/js/materialize.min.js"></script>  

    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  <body>
    <div class="container">
        <h1 align="center"> Charnes & Jobles & George</h1>
        <div class="col s12 msg">
        <%
            if(request.getParameter("login") != null && request.getParameter("login").equals("-1")){
                out.print("<div class=\"card-panel red darken-2 center-align col s4\">Invalid login!</div>");
            }else if(request.getParameter("login") != null && request.getParameter("login").equals("0")){
                out.print("<div class=\"card-panel green lighten-1 col s4 center-align\">Logout successful!</div>");
                session.removeAttribute("email");
                session.removeAttribute("password");
                session.invalidate();
            }
        %>
        </div>
        <form class="col s12 center-align" action="login.jsp" method="post">
          <div class="row"> 
            <div class="input-field col s4 offset-s4">
              <input placeholder="panteater@uci.edu" id="email" type="text" name="email" class="validate">
              <label for="email">Email</label>
            </div>
          </div>
          <div class="row">
            <div class="input-field col s4 offset-s4">
              <input id="password" type="password" name="password" class="validate">
              <label for="password">Password</label>
            </div>
          </div>
            <button class="btn waves-effect waves-light" type="submit" name="login">Login
            </button>
          </center>
        </form>
     </div>
  </body>
</html>
