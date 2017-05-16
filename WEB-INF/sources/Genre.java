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
}
