package xmlparser;

public class Author {
	private String dob;
	private String firstName;
	private String lastName;
	private String penName;
	private int authorId;
	
	public Author(String _dob, String _firstName, String _lastName, String _penName, int _authorId){
		this.dob = _dob;
		this.firstName = _firstName;
		this.lastName = _lastName;
		this.penName = _penName;
		this.authorId = _authorId;
	}
	
	public String getDob(){
		return dob;
	}
	
	public String getFirstName(){
		return firstName;
	}
	
	public String getLastName(){
		return lastName;
	}
	
	public String getPenName(){
		return penName;
	}
	
	public int getAuthorId(){
		return authorId;
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		sb.append("Author Details - ");
		sb.append("dob:" + dob);
		sb.append(", ");
		sb.append("First name:" + firstName);
		sb.append(", ");
		sb.append("Last name:" + lastName);
		sb.append(", ");
		sb.append("Stage name:" + penName);
		sb.append(".");
		return sb.toString();
	}
}
