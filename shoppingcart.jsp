<%@page
	import="java.sql.*,
 javax.sql.*,
 java.io.IOException,
 javax.servlet.http.*,
 javax.servlet.*,
 java.lang.Math,
 java.util.*,
 cart.ItemCounter,
 javax.sql.DataSource"%>

<html>
<%@include file="css.html"%>
<head>
  <script src='https://www.google.com/recaptcha/api.js'></script>
</head>
<body>
  <%@include file="navbar.jsp"%>
	<div class="container">
		<div class="row">
			<div class="col s10">
				<%
                    int itemCount = 0;
                    double cost = 0;
                    double totalCost = 0;
                    Connection c = null;

                    try {               

                        int pick = (int)(Math.random() % 2);
                        if (pick == 0){
                            c = ((DataSource) session.getAttribute("dsRead")).getConnection();
                        }
                        else{
                            c = ((DataSource) session.getAttribute("dsWrite")).getConnection();
                        }
                        response.setContentType("text/html");
                        String qstring = request.getQueryString();
                        if (qstring.equals("")){
                        	qstring = "page=1&orderby=title&reverse=false&total=10";
                        }
                        String replacer = "orderby=" + request.getParameter("orderby");
        		%>
				<table class="bordered">
					<thead>
						<tr>
							<th style="width: 80px">ISBN <a
								href=<%
                   					out.println("\"shoppingcart.jsp?");
                   					if (request.getParameter("reverse").equals("true")){
                   						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=book.isbn"));	// Replacer = "orderby=attribute"
                   						out.println("\">");
                   						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
                   					}
                   					else if (request.getParameter("reverse").equals("false")){
                   						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=book.isbn"));	// Replacer = "orderby=attribute"
                   						out.println("\">");
                   						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
                   					}
                   				%></a>
							</th>
							<th style="width: 400px">Title <a
								href=<%
           					out.println("\"shoppingcart.jsp?");
           					if (request.getParameter("reverse").equals("true")){
           						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=title"));	// Replacer = "orderby=attribute"
           						out.println("\">");
           						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
           					}
           					else if (request.getParameter("reverse").equals("false")){
           						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=title"));	// Replacer = "orderby=attribute"
           						out.println("\">");
           						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
           					}
           				%></a>
							</th>
							<th style="width: 220px">Publisher <a
								href=<%
        					out.println("\"shoppingcart.jsp?");
        					if (request.getParameter("reverse").equals("true")){
        						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=publisher"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
        					}
        					else if (request.getParameter("reverse").equals("false")){
        						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=publisher"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
        					}
        				%></a>
							</th>
							<th style="width: 100px">Year <a
								href=<%
        					out.println("\"shoppingcart.jsp?");
        					if (request.getParameter("reverse").equals("true")){
        						out.println(qstring.replace("reverse=true","reverse=false").replace(replacer, "orderby=year_published"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\">arrow_drop_down</i>");
        					}
        					else if (request.getParameter("reverse").equals("false")){
        						out.println(qstring.replace("reverse=false","reverse=true").replace(replacer, "orderby=year_published"));	// Replacer = "orderby=attribute"
        						out.println("\">");
        						out.println("<i class=\"material-icons\"> arrow_drop_up </i>");
        					}
        				%></a>
							</th>
							<th>Author</th>
							<th>Genre</th>
							<th>Price</th>
							<th>Quantity</th>
						</tr>
					</thead>
					<%
                
	                String query = "SELECT * FROM book WHERE isbn = ?";
	                PreparedStatement book_statement = c.prepareStatement(query);
	                
	                String author_query = "SELECT author.author_id, author.first_name, author.last_name FROM authored, book, author WHERE book.isbn = ? AND book.isbn = authored.isbn AND author.author_id = authored.author_id ORDER BY last_name, first_name ASC";
	                PreparedStatement author_statement = c.prepareStatement(author_query);
	                
	                String genre_query = "SELECT genre_name FROM book, genre, genre_in_books WHERE book.isbn = ? AND book.isbn = genre_in_books.isbn AND genre_in_books.genre_id = genre.id ORDER BY genre_name ASC";
	                PreparedStatement genre_statement = c.prepareStatement(genre_query);
	                
	                ArrayList<ItemCounter> cart = new ArrayList<ItemCounter>();
	                cart = (ArrayList<ItemCounter>) session.getAttribute("shoppingcart");
	                
                    String sid = request.getParameter("id");
	                String removeItemBtn = request.getParameter("removeItem");
	                if(removeItemBtn != null){
	                    ItemCounter book = new ItemCounter(request.getParameter("isbn"));
	                    
	                    for(int i = 0; i < cart.size(); i++)
	                    {
	                    	if(cart.get(i).isbn().trim().equals(book.isbn()))
	                        {
	                            cart.get(i).setQuantity(0);
	                            cart.remove(i);
	                            break;
	                        }
	                    }
	                }else if(sid != null){
                        int id = Integer.parseInt(sid);
                        if(id >= 0){
                            int itemquantity = Integer.parseInt(request.getParameter("value"));
                            cart.get(id).setQuantity(itemquantity);
                        }
	                }

	                for(int i = 0; i < cart.size(); i++)
	                {
                       	String b_isbn = cart.get(i).isbn().trim();
                       	book_statement.setInt(1, Integer.parseInt(b_isbn));
                   	    ResultSet rs = book_statement.executeQuery();
                   	    
                   	    
                       	author_statement.setInt(1, Integer.parseInt(b_isbn));
                   	    ResultSet author_rs = author_statement.executeQuery();
                   	    
                   	    genre_statement.setInt(1, Integer.parseInt(b_isbn));
                   	    ResultSet genre_rs = genre_statement.executeQuery();
                           
                   	    rs.next();
                           String b_title = rs.getString("title");
                           String b_year = rs.getString("year_published");
                           String b_publisher = rs.getString("publisher");
                           out.println("<tr>" + "<td>" + b_isbn + "</td>" + "<td><a href = bookpage.jsp?b_isbn="+ b_isbn + ">" + b_title + "</a></td>" + "<td>" + b_publisher + "</td>" + "<td>" + b_year + "</td>" + "<td style=\"width:200px\">");
                           
                           
                           
                           while (author_rs.next())
                           {
                           	String a_author_id = author_rs.getString("author_id");
                           	String a_firstName = author_rs.getString("first_name");
                           	String a_lastName = author_rs.getString("last_name");
                           	out.println("<a href = authorpage.jsp?author_id=" + a_author_id + ">" + a_firstName + " " + a_lastName + "</a>");
                           	if(!author_rs.isLast())
                           	{
                           		//out.println(", ");
                           		out.println("<br>");
                           	}
                           	
                           }
                           
                   	    out.println("</td>");
                           
                   	    out.println("<td>");

                   	    
                   	    if (!genre_rs.isBeforeFirst() ) {    
               			    out.println("None listed"); 
               			}
               			else {
               				out.println("<br>"); 
                           	while(genre_rs.next()) // 
                       		{
                           		String genre = genre_rs.getString("genre_name");
                           		out.println(genre);
                           		if(!genre_rs.isLast())
                           		{
                           			out.println("<br>");
                           		}
                       		}
               			}

                        cost = 10 * cart.get(i).quantity();
                        totalCost += cost;
                        out.println("</td> <td>$" + String.format("%.2f", cost) + "</td>");
                        
                       %>
						<form
							action="shoppingcart.jsp?<% out.println(request.getQueryString()); %>"
							method="post">
							<input type="hidden" name="isbn" value=<% out.println(b_isbn); %> />
                            <td>
                                <div class="input-field">
                                    <select name="item_quantity" id="<% out.print(i); %>">
                                        <option value="1">1</option>
                                        <option value="2">2</option>
                                        <option value="3">3</option>
                                        <option value="4">4</option>
                                        <option value="5">5</option>
                                        <option value="6">6</option>
                                        <option value="7">7</option>
                                        <option value="8">8</option>
                                        <option value="9">9</option>
                                    </select>
                                    <label>Qty:</label>
                                </div>
                            </td>

							<td>
								<% 
								itemCount +=cart.get(i).quantity(); 
								%>
							</td>
							<td><button type="submit" class="btn-floating red"
									name="removeItem">
									<i class="material-icons">delete_forever</i></a>
								</button></td>
						</form>
                        <script>
                                $(document).ready(function() {
                                    $('#<% out.print(i); %>').val(<% out.println(cart.get(i).quantity()); %>);
                                    $('select').material_select();
                                });
                        </script>
	
						<%
	                    }
                    } catch (SQLException ex) {
                        while (ex != null) {
                            System.out.println("SQL Exception:  " + ex.getMessage());
                            ex = ex.getNextException();
                        } // end while
                    } // end catch SQLException

                    catch (java.lang.Exception ex) {
                        out.println("<HTML>" + "<HEAD><TITLE>" + "BooksDB: Error" + "</TITLE></HEAD>\n<BODY>"
                                + "<P>SQL error in doGet: " + ex.getClass().getSimpleName() + ex.getMessage() + "</P></BODY></HTML>");
                        return;
                    }
                    finally{
                        c.close();
                    }
                %>
				</table>


			</div>
			<div class="col s2">
				<div class="summary pinned">
					<h5>Summary</h5>
					<div class="divider"></div>
					<p> Items:
						<% 
                            out.print(itemCount); 
                            out.println("</p> <p>Total cost: $" + String.format("%.2f", totalCost) + "</p>");
                         %>
						<!-- Modal Trigger -->
						<a class="waves-effect waves-light btn modal-trigger" href="#checkoutModal">Checkout</a>
                    <% 
                        if(request.getParameter("invalid") != null && (request.getParameter("invalid").equals("true"))){
                            out.print("<div class=\"card-panel red darken-2\">Invalid CCN!</div>");
                        }
                    %>
				</div>

				<!-- Modal Structure -->
				<div id="checkoutModal" class="modal">
					<form class="col s12 center-align" action="checkout.jsp"
						method="post">
						<div class="modal-content">
							<h4>Enter Payment Info</h4>
							<div class="row">
								<div class="input-field col s6">
									<input id="firstname" type="text" name="firstname"
										class="validate" required> <label for="firstname">First
										name</label>
								</div>
								<div class="input-field col s6">
									<input id="lastname" type="text" name="lastname"
										class="validate" required> <label for="lastname">Last
										name</label>
								</div>
							</div>
							<div class="row">
								<div class="input-field col s6">
									<input id="ccn" type="text" name="ccn" class="validate">
									<label for="ccn" required>Credit Card Number</label>
								</div>
								<div class="input-field col s6">
									<input id="expdate" type="text" name="expdate" class="validate">
									<label for="expdate" required>Expiration Date (yyyy-mm-dd)</label>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<button class="btn waves-effect waves-light" type="submit"
								name="order">Order</button>
							<a href="#!"
								class="modal-action modal-close waves-effect waves-green btn-flat">Back</a>
						</div>
					</form>
          <% 
            out.print("<form action=\"https://www.google.com/recaptcha/api/siteverify?secret=6LfxoB8UAAAAAF8uvb_hwdOtG4kfxXP_Yj8Mer7w&response=" + 
              request.getParameter("g-recaptcha-response") + "\">");
          %>
          
                <div class="g-recaptcha" data-sitekey="6LfxoB8UAAAAAIUJisvwlHEZ6CW9gHPnNgJzESES"></div>
          </form>
				</div>
				<script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.98.2/js/materialize.min.js"></script>
                <script>
                      $(document).ready(function(){
                            $('.modal').modal();
                            $('select').change(function () {
                                $(this).val()
                                window.location.replace("./shoppingcart.jsp?page=1&orderby=title&reverse=false&total=1&value=" + $(this).val() + "&id=" + $(this).attr('id'));
                            });
                      });
                </script>
            </div>
          </div>
        </div>
    </div>
  </body>