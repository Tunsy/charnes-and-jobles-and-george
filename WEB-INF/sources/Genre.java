package xmlparser;

public class Genre {
	private int genreId;
	private String genre;
	
	public Genre(int _genreId, String _genre){
		genreId = _genreId;
		genre = _genre;
	}

	public int getGenreId() {
		return genreId;
	}

	public String getGenre() {
		return genre;
	}
	
	@Override
	public boolean equals(Object genrearg){
		if (genrearg == null){
			return false;
		}
		if (!Authored.class.isAssignableFrom(genrearg.getClass())) {
	        return false;
	    }
	    final Genre other = (Genre) genrearg;
	    if (this.genreId != other.genreId) {
	        return false;
	    }
	    if (this.genre != other.genre) {
	        return false;
	    }
	    return true;
	}
	@Override
	public int hashCode() {
	    int hash = 3;
	    hash = 53 * hash + genreId;
	    hash = 53 * hash + (this.genre != null ? this.genre.hashCode() : 1);
	    return hash;
	}
}
