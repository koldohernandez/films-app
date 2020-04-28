class Films 
{

  List<Film> items = new List();


  Films.fromJSONList (List<dynamic> jsonList)
  {

    if (jsonList == null) return;

    jsonList.forEach ( (item) {
      final _film = new Film.fromJsonMap(item);
      items.add(_film);
    });

  }

}


class Film 
{
  int voteCount;
  int id;
  bool video;
  double voteAverage;
  String title;
  double popularity;
  String posterPath;
  String originalLanguage;
  String originalTitle;
  List<int> genreIds;
  String backdropPath;
  bool adult;
  String overview;
  String releaseDate;


  String uniqueId;
  
  final String _noImageURL = 'assets/images/no-image-horizontal.png';


  Film({
    this.voteCount,
    this.id,
    this.video,
    this.voteAverage,
    this.title,
    this.popularity,
    this.posterPath,
    this.originalLanguage,
    this.originalTitle,
    this.genreIds,
    this.backdropPath,
    this.adult,
    this.overview,
    this.releaseDate,
  });


  Film.fromJsonMap(Map<String, dynamic> json) 
  {
    voteCount          = json['vote_count'];
    id                 = json['id'];
    video              = json['video'];
    voteAverage        = json['vote_average'] / 1; // / 1 para convertir a double 
    title              = json['title'];
    popularity         = json['popularity'] / 1; // / 1 para convertir a double 
    posterPath         = json['poster_path'];
    originalLanguage   = json['original_language'];
    originalTitle      = json['original_title'];
    genreIds           = json['genre_ids'].cast<int>();
    backdropPath       = json['backdrop_path'];
    adult              = json['adult'];
    overview           = json['overview'];
    releaseDate        = json['release_date'];
  }


  String getPosterImg()
  {
    if (posterPath == null) return _noImageURL;
    return 'https://image.tmdb.org/t/p/w500/$posterPath';
  }


  String getBackgroundImg()
  {
    if (posterPath == null) return _noImageURL;
    return 'https://image.tmdb.org/t/p/w500/$backdropPath';
  }


}
