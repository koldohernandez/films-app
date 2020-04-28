import 'package:flutter/material.dart';

import 'package:films_app/src/models/films_model.dart';
import 'package:films_app/src/pages/film_details_page.dart';


class HorizontalSwiper extends StatelessWidget 
{

  final List<Film> listaItems;
  final Function siguientePagina;

  static Size _screenSize;

  final PageController _pageController = PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );


  HorizontalSwiper({Key key, @required this.listaItems, @required this.siguientePagina }) : super(key: key);


  @override
  Widget build(BuildContext context) 
  {

    _screenSize = MediaQuery.of(context).size;


    // Listener del PageController con el que controlaremos cuando llegamos al final de la lista (200 pixels antes, concretamente)
    // para volver a cargar las siguientes peliculas...
    _pageController.addListener( () {

      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200) {
        // ... llamando a la función (pasada por referencia a este widget desde otro widget padre) que le indique
        // a nuestro 'data provider' que necesitamos más datos que debe poner en el Stream. 
        // Como el widget padre (en la HomePage)
        // es un StreamBuilder escuchando el flujo de datos de las peliculas populares, las recargará dentro de este widget.
        siguientePagina();
      }

    });


    return Container(
      margin: EdgeInsets.only(top: 15.0),
      height: _screenSize.height * 0.3,

      // Para optimizar la app, vamos a cargar los elementos del PageView bajo demanda. 
      // El PageView carga todos los elementos que tenemos en memoria pero para hacer lo bajo demanda, utilizamos el PageView.builder
      /*child: PageView(
        pageSnapping: false, // hace que ruede de forma más suave y que no deje la siguiente tarjeta
        controller: _pageController,
        children: _listTarjetas(context)
      ),*/
      child: PageView.builder(
        pageSnapping: false, // hace que ruede de forma más suave y que no deje la siguiente tarjeta
        controller: _pageController,
        itemCount: listaItems.length,
        itemBuilder: (context, index) => _addTarjeta(context, listaItems[index])
      )
    );
  }


  // Optimización
  // 
  // Original: Método utilizado con el PageView (renderiza todo lo que tenemos en memoria) => con muchísimos elementos, posible fuente de error (punto de fuga de memoria)
  List<Widget> _listTarjetas(BuildContext context)
  {
    return listaItems.map( (item) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage(
                image: NetworkImage(item.getPosterImg()),
                placeholder: AssetImage('assets/images/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              item.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );
    }).toList();
  }


  // Método optimizado: 
  // Utilizando el PageView.builder, que crea los elementos de la lista bajo demanda. 
  // De esta forma mejoramos el rendimiento en dispositivos de gama baja o media (en algunos casos)
  Widget _addTarjeta(BuildContext context, Film item)
  {

    item.uniqueId = '${item.id}-popular';

    final card = Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            Hero(
              tag: item.uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(item.getPosterImg()),
                  placeholder: AssetImage('assets/images/no-image-vertical.jpg'),
                  fit: BoxFit.cover,
                  height: 160.0,
                ),
              ),
            ),
            SizedBox(height: 5.0),
            Text(
              item.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
      );


    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(FilmDetailsPage.path, arguments: item), // pasamos parámetros de una página a otra con el atributo arguments
      child: card
    );
    
  }




}