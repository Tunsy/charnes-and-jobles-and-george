<%@page import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 javax.sql.DataSource"
%>

<html>
<%@include file="css.html"%>  
<%@include file="navbar.jsp"%>
  <body>
    <div class="container">
        <div class="row">
            <div class="col s8">
              <ul class="collection with-header">
                 <%
                    Connection c = null;
                    try {               
                        //Class.forName("org.gjt.mm.mysql.Driver");

                        int pick = (int)(Math.random() % 2);
                        if (pick == 0){
                            c = ((DataSource) session.getAttribute("dsRead")).getConnection();
                        }
                        else{
                            c = ((DataSource) session.getAttribute("dsWrite")).getConnection();
                        }
                        response.setContentType("text/html");
                        String authorid = request.getParameter("author_id");
                        String author_query = "SELECT * FROM author WHERE author.author_id = ?";
                        PreparedStatement statement = c.prepareStatement(author_query);
                        statement.setInt(1, authorid);

                        ResultSet rs = statement.executeQuery();
                        String name = "";
                        String birth = "";
                        String url = "";
                        
                        String book_query = "SELECT * FROM authored,book WHERE authored.isbn = book.isbn AND authored.author_id = ? ORDER BY book.title ASC";
                        PreparedStatement book_statement = c.prepareStatement(book_query);
                        book_statement.setInt(1, authorid);
                        ResultSet books_rs = book_statement.executeQuery();
                        
                        if(rs.next()){
                            name  = rs.getString("first_name") + " " + rs.getString("last_name");
                            birth = rs.getString("dob");
                            url = rs.getString("photo_url");
                            
                            out.println("<li class=\"collection-header\"><h4>" + name + "</h4>");
                            out.println("<li class=\"collection-item\">Books Written: <br>");
                            while(books_rs.next())
                            {
                                String book_title = books_rs.getString("title");
                                String isbn = books_rs.getString("isbn");
                                out.println("<a href = bookpage.jsp?b_isbn=" + isbn + ">" + book_title + "</a>");
                                if(!books_rs.isLast())
                            	{
                            		out.println("<br>");
                            	}
                            }
                            out.print("</li>");

                            out.println("<li class=\"collection-item\">Author ID: " + authorid + "</li>");
                            out.println("<li class=\"collection-item\">Birthday: "+ birth + "</li>");
                            out.println("<li class=\"collection-item\">URL: " + url + "</li>");   
                        }
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
                    finally{
                    c.close();
                }
                  %>                   
              </ul>
            </div>
            <div class="col s4 sidepic">
                <% out.println("<img src=\"test\" alt=\"Not a real image\" style=\"width:256px;height:256px;\">"); %>   
            </div>
        </div>
      </div>
    </body>
  </html>