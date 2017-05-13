<%@include file="employee_navbar.jsp"%>

<!DOCTYPE html>
<html>
<body>
				<!-- Modal Structure -->
				<div style="width:700px; margin:0 auto;">
					<h4 class="center-align" >Enter Book Info</h4>
					<form class="center-align" action="employee_portal.jsp"
						method="post">
						<div>
							<div class="row">
								<div class="input-field col s6">
									<input id="isbn" type="text" name="isbn"
										class="validate" required> <label for="isbn">ISBN</label>
								</div>
								<div class="input-field col s6">
									<input id="title" type="text" name="title"
										class="validate" required> <label for="title">Title</label>
								</div>
							</div>
								<div class="row">
									<div class="input-field col s6">
										<input id="yearpublished" type="text" name="yearpublished" class="validate">
										<label for="yearpublished" required>Year Published</label>
									</div>
									<div class="input-field col s6">
										<input id="publisher" type="text" name="publisher" class="validate">
										<label for="publisher" required>Publisher</label>
									</div>
								</div>
								<div>
									<div class="input-field col s6">
										<input id="genre" type="text" name="genre" class="validate">
										<label for="genre" required>Genre</label>
									</div>
								</div>
							</div>
							
				</div>
				<div style="width:700px; margin:0 auto;">
					<h4 class="center-align">Enter Author Info</h4>
							<div class="row">
								<div class="input-field col s6">
									<input id="firstname" type="text" name="firstname"
										class="validate" default="" required> <label for="firstname">First
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
									<input id="photourl" type="text" name="photourl" class="validate">
									<label for="photourl" default="">Photo URL</label>
								</div>
								<div class="input-field col s6">
									<input id="dob" type="text" name="dob" class="validate">
									<label for="dob" default="">Date of Birth (yyyy-mm-dd)</label>
								</div>
							</div>
				</div>
						<div class="center-align">
							<button class="btn waves-effect waves-light" type="submit"
								name="addBookBtn">Add</button>
						</div>
					</form>
				</div>
</body>
</html>