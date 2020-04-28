import 'package:flutter/material.dart';

import 'package:films_app/src/pages/home_page.dart';
import 'package:films_app/src/pages/film_details_page.dart';


Map<String, WidgetBuilder> getAppRoutes() 
{

  return <String, WidgetBuilder> {
    
    HomePage.path         : (BuildContext context) => HomePage(title: 'Films Apps - Home'),
    FilmDetailsPage.path   : (BuildContext context) => FilmDetailsPage(title: 'Film Details')

  };

}
