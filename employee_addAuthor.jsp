<%@include file="employee_navbar.jsp"%>

<!DOCTYPE html>
<html>
<body>
				<!-- Modal Structure -->
				<div>
					<form class="col s12 center-align" action="employee_portal.jsp"
						method="post">
						<div>
							<h4>Enter Author Info</h4>
							<div class="row">
								<div class="input-field col s6">
									<input id="firstname" type="text" name="firstname"
										class="validate" default=""> <label for="firstname">First
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
									<label for="photourl" required>Photo URL</label>
								</div>
								<div class="input-field col s6">
									<input id="dob" type="text" name="dob" class="validate" required>
									<label for="dob" required>Date of Birth (yyyy-mm-dd)</label>
								</div>
							</div>
						</div>
						<div>
							<button class="btn waves-effect waves-light" type="submit"
								name="addAuthorBtn">Add</button>
						</div>
					</form>
</body>
</html>
