<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*"
%>

<html>
  <head>
    <link rel="stylesheet" href="https://fonts.googleapis.com/icon?family=Material+Icons">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/css/materialize.min.css">
    <link href="style.css" rel="stylesheet">
    <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.1.min.js"></script>           
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.97.3/js/materialize.min.js"></script>  
    <title>BooksList</title>
    <!--Let browser know website is optimized for mobile-->
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  </head>
  <body>
    <div class="container">
        <h1 align="center"> Charnes & Jobles & George</h1>
        <div class="row">
            <div>
              <ul class="collection with-header">
                 <%
                    try {               
                        //Class.forName("org.gjt.mm.mysql.Driver");
                        Connection c = DriverManager.getConnection(
                            session.getAttribute("sqlURL").toString(), session.getAttribute("sqlUser").toString(), session.getAttribute("sqlPassword").toString());
                        response.setContentType("text/html");               
                        Class.forName("com.mysql.jdbc.Driver").newInstance();
                        Statement statement = c.createStatement();


                        //String isbn = request.getParameter("isbn");
                        String isbn = "1";
                        List<String> authors = new ArrayList<String>();
                        String query = "SELECT * FROM book LEFT JOIN (author, authored, genre_in_books, genre) ON (book.isbn = authored.isbn AND authored.isbn = genre_in_books.isbn AND authored.author_id = author.author_id AND genre.id = genre_in_books.genre_id) WHERE book.isbn = " + isbn;
                        ResultSet rs = statement.executeQuery(query);
                        String year = "";
                        String title = "";
                        String publisher = "skee";
                        String genre = "";
                        while(rs.next()){
                            authors.add(rs.getString("first_name") + " " + rs.getString("last_name"));
                            year = rs.getString("year_published");
                            title = rs.getString("title");
                            publisher = rs.getString("publisher");
                            genre = rs.getString("genre_name");
                        }

                        out.println("<li class=\"collection-header\"><h4>" + title + "<h4></li>");
                        out.println("<li class=\"collection-item\">Author: ");
                        for(int i = 0; i < authors.size(); i++){
                            out.print(authors.get(i));
                            if(i < authors.size() - 1)
                              out.print(", ");
                        }
                        out.print("</li>");
                        out.println("<li class=\"collection-item\">Publisher: " + publisher + "</li>");
                        out.println("<li class=\"collection-item\">Genres: " + genre + "</li>");
                        out.println("<li class=\"collection-item\">Year published: " + year + "</li>");
                        out.println("<li class=\"collection-item\">ISBN: " + isbn + "</li>");

                    } catch (SQLException ex) {
                        while (ex != null) {
                            System.out.println("SQL Exception:  " + ex.getMessage());
                            ex = ex.getNextException();
                        } // end while
                    } // end catch SQLException

                    catch (java.lang.Exception ex) {
                        out.println("<HTML>" + "<HEAD><TITLE>" + "BooksDB: Error" + "</TITLE></HEAD>\n<BODY>"
                                + "<P>SQL error in doGet: " + ex.getMessage() + "</P></BODY></HTML>");
                        return;
                    }
                  %>  
                  

                 
                  
                  
                 
              </ul>
            </div>
        </div>
      </div>
    </body>
  </html>