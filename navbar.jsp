<nav>
	<div class="nav-wrapper">
		<a href="main.jsp" class="brand-logo navlogo"> Charnes & Jobles &
			George</a>
		<ul id="nav-mobile" class="right hide-on-med-and-down">
			<li><a
				href="shoppingcart.jsp?page=1&orderby=title&reverse=false&total=10"><i
					class="material-icons">shopping_cart</i></a></li>
			<!--<% //if((int)session.getAttribute("itemCount") != null && (int)session.getAttribute("itemCount") != 0) %>
                    <span class="new badge">4</span>-->
            <li><a href="booklist.jsp?page=1&orderby=title&reverse=false&letter=all&total=10">All books</a></li>
			<li><a href="main.jsp">Home</a></li>
			<li><a href="index.jsp?login=0">Logout</a></li>
		</ul>
	</div>
</nav>
<%@include file="cacheclear.jsp"%>