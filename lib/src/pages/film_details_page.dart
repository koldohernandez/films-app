import 'package:flutter/material.dart';

import 'package:films_app/src/models/films_model.dart';

import 'package:films_app/src/providers/cast_provider.dart';
import 'package:films_app/src/models/cast_model.dart';


class FilmDetailsPage extends StatelessWidget 
{

  final String title;
  static String path = 'film_details';

  static Size _screenSize;

  TextStyle _titleStyle;
  TextStyle _subheadStyle;
  Color _bgColor;

  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );

  
  FilmDetailsPage({Key key, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) 
  {

    _screenSize = MediaQuery.of(context).size;

    _bgColor = Theme.of(context).colorScheme.primary;
    _titleStyle = Theme.of(context).textTheme.title;    
    _subheadStyle = Theme.of(context).textTheme.subhead;    
    
    final Film film = ModalRoute.of(context).settings.arguments;


    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(context, film),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20.0),
                _posterTitulo(film),
                _descripcion(film),
                SizedBox(height: 20.0),
                _listarActores(film),
              ]
          ))
        ],
      ),
    );
  }


  Widget _crearAppBar (BuildContext context, Film film)
  {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: _bgColor,
      expandedHeight: 250.0,
      floating: true,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          film.title, 
          style: TextStyle(color: Colors.white, fontSize: 16.0),),
        centerTitle: true,
        background: FadeInImage(
          image: NetworkImage( film.getBackgroundImg() ),
          placeholder: AssetImage('assets/images/loading.gif') ,
          fit: BoxFit.cover,
        ),
      ),
    );
  }


  Widget _posterTitulo(Film film)
  {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: film.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(film.getPosterImg()),
                height: 150.0
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(film.title, style: _titleStyle, overflow: TextOverflow.ellipsis),
                Text(film.originalTitle, style: _subheadStyle, overflow: TextOverflow.ellipsis),
                SizedBox(height: 25.0),
                Row(
                  children: <Widget>[
                    Text(film.releaseDate, style: _subheadStyle),
                    Expanded(
                      child: SizedBox(),
                    ),
                    Icon( Icons.star_border),
                    Text( film.voteCount.toString())
                  ],
                )
              ],
            ),
          ),
        ],
      )
    );
  }


  Widget _descripcion(Film film)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Text(
        film.overview, 
        textAlign: TextAlign.justify,
      )
    );
  }


  Widget _listarActores(Film film)
  {

    final CastProvider actores = new CastProvider();

    // Creamos un FutureBuilder porque vamos a obtener un nº finito de elementos (20, 30). 
    // En caso de tener un nº grande e indeterminado de elementos, usariamos un StreamBuilder (como el widget de Populares)
    return FutureBuilder(
      future: actores.getActores(film.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);

        } else {
          return Container(
            height: _screenSize.height * 0.5,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );

        }

      },
    );

  }


  Widget _crearActoresPageView(List<Actor> actores)
  {
    return SizedBox(
        height: 200.0,
        child: PageView.builder(
          pageSnapping: false,
          controller: _pageController,
          itemCount: actores.length,
          itemBuilder: (BuildContext context, index) => _crearActor(actores[index]),
        )
      );

  }


  Widget _crearActor(Actor actor)
  {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getPhoto()),
              placeholder: AssetImage(actor.noImageURL),
              height: 160.0,
              fit: BoxFit.cover,
            ),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis),
        ]
      ),
    );
  }



}