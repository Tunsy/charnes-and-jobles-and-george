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

}
