package xmlparser;

public class Cast {
	private String fid;
	private String stageName;
	
	public Cast(String fid, String stageName) {
		super();
		this.fid = fid;
		this.stageName = stageName;
	}
	
	public String getFid() {
		return fid;
	}
	public String getStageName() {
		return stageName;
	}
	
	public String toString(){
		StringBuffer sb = new StringBuffer();
		sb.append("Cast Details - ");
		sb.append("fid:" + fid);
		sb.append(", ");
		sb.append("Stage name:" + stageName);
		sb.append(".");
		return sb.toString();
	}
	
	@Override
	public boolean equals(Object cast){
		if (cast == null){
			return false;
		}
		if (!Cast.class.isAssignableFrom(cast.getClass())) {
	        return false;
	    }
	    final Cast other = (Cast) cast;
	    if (this.fid != other.fid) {
	        return false;
	    }
	    if (this.stageName != other.stageName) {
	        return false;
	    }
	    return true;
	}
	@Override
	public int hashCode() {
	    int hash = 3;
	    hash = 53 * hash + (this.fid != null ? this.fid.hashCode() : 0);
	    hash = 53 * hash + (this.stageName != null ? this.stageName.hashCode() : 1);
	    return hash;
	}
}
