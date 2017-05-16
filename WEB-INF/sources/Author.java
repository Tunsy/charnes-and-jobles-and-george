package xmlparser;

public class Author {
	private String dob;
	private String firstName;
	private String lastName;
	private String stageName;
	private int authorId;
	
	public Author(String _dob, String _firstName, String _lastName, String _stageName, int _authorId){
		this.dob = _dob;
		this.firstName = _firstName;
		this.lastName = _lastName;
		this.stageName = _stageName;
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
	
	public String getStageName(){
		return stageName;
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
		sb.append("Stage name:" + stageName);
		sb.append(".");
		return sb.toString();
	}
}
