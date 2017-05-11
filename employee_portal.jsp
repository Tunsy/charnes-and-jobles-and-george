<%@include file="employee_navbar.jsp"%>

<div class="container">
	<div>
		<form action="employee_addAuthor.jsp"
			class="search-container center-align"
			method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="addAuthor">Add Author</button>
		</form>
		<form action="employee_metadata.jsp"
			class="center-align"
			method='POST'>
			<button type="submit"
				class="waves-effect waves-light btn genre-button" name="btn"
				value="metadata">Show Metadata</button>
		</form>
	</div>
</div>
