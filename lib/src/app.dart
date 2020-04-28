import 'package:flutter/material.dart';

import 'package:films_app/src/routes/app_routes.dart';
 

class FilmsApp extends StatelessWidget 
{
  
  final String title = 'Films App';


  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Films App',
      /*localizationsDelegates: [
        // ... app-specific localization delegate[s] here
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'), // English
        const Locale('es'), // Spanish
      ],*/
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: getAppRoutes(),
    );

  }


}
