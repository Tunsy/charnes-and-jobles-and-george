package xmlparser;

public class Authored {
	private String bid;
	private String penName;
	
	public Authored(String bid, String penName) {
		super();
		this.bid = bid;
		this.penName = penName;
	}
	
	public String getbid() {
		return bid;
	}
	public String getPenName() {
		return penName;
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		sb.append("Cast Details - ");
		sb.append("bid:" + bid);
		sb.append(", ");
		sb.append("Stage name:" + penName);
		sb.append(".");
		return sb.toString();
	}
	
	@Override
	public boolean equals(Object authored){
		if (authored == null){
			return false;
		}
		if (!Authored.class.isAssignableFrom(authored.getClass())) {
	        return false;
	    }
	    final Authored other = (Authored) authored;
	    if (this.bid != other.bid) {
	        return false;
	    }
	    if (this.penName != other.penName) {
	        return false;
	    }
	    return true;
	}
	@Override
	public int hashCode() {
	    int hash = 3;
	    hash = 53 * hash + (this.bid != null ? this.bid.hashCode() : 0);
	    hash = 53 * hash + (this.penName != null ? this.penName.hashCode() : 1);
	    return hash;
	}
}
