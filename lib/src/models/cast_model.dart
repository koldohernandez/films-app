class Actores 
{

  List<Actor> items = new List();


  Actores.fromJSONList (List<dynamic> jsonList) 
  {
    if (jsonList == null) return;

    jsonList.forEach ( (item) {
      final _actor = new Actor.fromJsonMap(item);
      items.add(_actor);
    });
      
  }

}


class Actor 
{

  int castId;
  String character;
  String creditId;
  int gender;
  int id;
  String name;
  int order;
  String profilePath;

  final String noImageURL = 'assets/images/no-image-vertical.jpg';


  Actor({
    this.castId,
    this.character,
    this.creditId,
    this.gender,
    this.id,
    this.name,
    this.order,
    this.profilePath,
  });


  Actor.fromJsonMap(Map<String, dynamic> json)
  {
    castId      = json['cast_id'];
    character   = json['character'];
    creditId    = json['credit_id'];
    gender      = json['gender'];
    id          = json['id'];
    name        = json['name'];
    order       = json['order'];
    profilePath = json['profile_path'];
  }


  String getPhoto()
  {
    if (profilePath == null) return noImageURL;
    return 'https://image.tmdb.org/t/p/w500/$profilePath';
  }

}