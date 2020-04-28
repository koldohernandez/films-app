import 'package:films_app/src/pages/film_details_page.dart';
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:films_app/src/models/films_model.dart';


class CardSwiper extends StatelessWidget 
{
  
  List<Film> listaItems;


  CardSwiper({Key key, @required this.listaItems}) : super(key: key);


  @override
  Widget build(BuildContext context) 
  {

    // Utilizamos MediaQuerys para obtener la referencia al dispositivo
    // y poder ajustar el tamaño de las tarjetas que se visualizen.
    final _screenSize = MediaQuery.of(context).size;
    

    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 5.0),
      width: _screenSize.width,
      height: _screenSize.height * 0.5, // que ocupe el 40% del alto
      child: Swiper(
        layout: SwiperLayout.STACK,
        itemWidth: _screenSize.width * 0.5,
        itemHeight: _screenSize.height,
        itemBuilder: (BuildContext context, int index){

          listaItems[index].uniqueId = '${listaItems[index].id}-featured';

          return GestureDetector(
            onTap: () => Navigator.of(context).pushNamed(FilmDetailsPage.path, arguments: listaItems[index]),
            child: Hero(
              tag: listaItems[index].uniqueId,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage(
                  image: NetworkImage(listaItems[index].getPosterImg()),
                  placeholder: AssetImage('assets/images/no-image-vertical.jpg'),
                  fit: BoxFit.cover,
                )
              ),
            ),
          );
        },
        itemCount: listaItems.length,
        //pagination: new SwiperPagination(),
        //control: new SwiperControl(),
      ),
    );

  }

}