import 'package:flutter/material.dart';

import 'package:films_app/src/widgets/card_swiper_widget.dart';
import 'package:films_app/src/widgets/horizontal_swiper_widget.dart';

import 'package:films_app/src/providers/films_provider.dart';
import 'package:films_app/src/search/search_delegate.dart';



class HomePage extends StatelessWidget 
{
  
  final String title;
  static String path = '/';

  static Size _screenSize;

  final FilmsProvider filmProvider = FilmsProvider();
  

  HomePage({Key key, this.title}) : super(key: key);


  @override
  Widget build(BuildContext context) 
  {

    _screenSize = MediaQuery.of(context).size;

    // Cuando se construye el widget, llamamos por primera vez al método que se encarga
    // de enviar las primeras películas al Stream
    filmProvider.getPopulares();

    return Scaffold(
      appBar: AppBar(
        title: Text(this.title),
        actions: <Widget>[
          IconButton(
            icon: Icon( Icons.search ),
            onPressed: () {
              showSearch(
                context: context, 
                delegate: DataSearch()
              );
             },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            _pintarCardSwiper(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  
  Widget _pintarCardSwiper() 
  {
    return FutureBuilder(
      future: filmProvider.getEnCines(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

        if (snapshot.hasData) {
          
          return CardSwiper(
            listaItems: snapshot.data,
          );

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


  Widget _footer(BuildContext context)
  {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text('Populares', style: Theme.of(context).textTheme.subhead)
          ),
          
          
          // El FurureBuilder se ejecuta sólo una vez. Para poder estar escuchando al flujo de datos
          // que nos viene de un Stream necesitamos utilizar un StreamBuilder
          /*FutureBuilder(
            future: filmProvider.getPopulares(),
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            
              if (snapshot.hasData) {
          
                return HorizontalSwiper(
                  listaItems: snapshot.data,
                );

              } else {
                
                return Container(
                  height: _screenSize.height * 0.3,
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              }

            },
          ),*/
          // Creamos el StreamBuilder, que es el widget que pernite estar escuchando un Stream
          StreamBuilder(
            stream: filmProvider.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
            
              if (snapshot.hasData) {
          
                return HorizontalSwiper(
                  listaItems: snapshot.data,
                  siguientePagina: filmProvider.getPopulares,
                );

              } else {
                
                return Container(
                  height: _screenSize.height * 0.3,
                  child: Center(
                    child: CircularProgressIndicator()
                  ),
                );
              }

            },
          ),  

        ],
      ),
    );

  } 

}