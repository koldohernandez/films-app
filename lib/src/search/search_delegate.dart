import 'package:flutter/material.dart';

import 'package:films_app/src/models/films_model.dart';
import 'package:films_app/src/providers/films_provider.dart';
import 'package:films_app/src/pages/film_details_page.dart';


class DataSearch extends SearchDelegate
{

  /*
  // Modo Ilustrativo con datos estáticos
  // 
  // Listas que contienen los datos estáticos que vamos a mostrar en la lista de resultados y sugerencias
  // sólo para ver cómo funciona el objeto SearchDelegate
  String itemSeleccionado = '';

  List lstEncines = [
    'X-Men',
    'Aladdin',
    'La noche de las Neds'
  ];

  List lstPeliculas = [
    'Ironman 1',
    'Ironman 2',
    'Ironman 3',
    'Superman',
    'Capitana Marvel',
    'Pokemon Detective',
    'John Wick 3'
  ];*/


  FilmsProvider filmsProvider = new FilmsProvider();


  @override
  List<Widget> buildActions(BuildContext context) 
  {
    // Acciones de nuestro AppBar (icon impiar el texto, poer ejemplo)
    return [
      IconButton(
        icon: Icon( Icons.clear ),
        onPressed: () {
         query = '';
        },
      ),
    ];
  }


  @override
  Widget buildLeading(BuildContext context) 
  {
    // Iconos a la izquierda del AppBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      }
    );
  }


  @override
  Widget buildResults(BuildContext context) 
  {
    // Builder que crea los resultados a mostrar
    
    //
    // Modo Ilustrativo con datos estáticos
    //
    // Sólo para ver cómo funcionan las sugerencias y los resultados de búsqueda con datos en lsitas estáticas (ver arriba) 
    // 
    // Pintamos el resultado del elemento seleccionado por el usuario en el método BuildSuggestions
    /*return Center(
      child: Container(
        width: 100.0,
        height: 100.0,
        child: Text('Hola'),
      )
    );*/

    return null;

  }


  @override
  Widget buildSuggestions(BuildContext context) 
  {
    // Sugerencias que aparecen cuando la persona escribe en la caja de búsqueda

    if (query.isEmpty) return Container();


    return FutureBuilder(
      future: filmsProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Film>> snapshot) {
        
        if (snapshot.hasData) {
          
          final lstPeliculas = snapshot.data;

          //print('Encuentra ${lstPeliculas.length} resultados'); 

          return ListView(
            children: lstPeliculas.map( (pelicula) { 

              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/images/no-image-vertical.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ) ,
                title: Text(pelicula.title),
                subtitle: Text( pelicula.originalTitle),
                trailing: Icon (Icons.arrow_forward),
                onTap: () {
                  close( context, null);
                  pelicula.uniqueId = '';
                  Navigator.pushNamed(context, FilmDetailsPage.path, arguments: pelicula);
                }
              );

            }).toList()
          );
        
        } else {
          
          return Center(
            child: CircularProgressIndicator()
          );
        }

      },
    );
    
    //
    // Modo Ilustrativo con datos estáticos
    //
    // Crear los resultados y sugerencias a pelo con unas listas fijas
    /*List resultados = (query.isEmpty ? 
                       lstEncines : 
                       lstPeliculas.where( (p) => p.toString().toLowerCase().startsWith(query.toLowerCase()) 
                      ).toList() );

    return ListView.builder(
      itemCount: resultados.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon (Icons.movie),
          title: Text(resultados[index]),
          trailing: Icon (Icons.arrow_forward),
          onTap: () {
            itemSeleccionado = resultados[index];
            showResults(context); // llamamos a este método para que ejecute el método buildResults del SearchDelegate (pinta en un Widget el elemento seleccionado) 
          },
        );   
      },
    );*/


    }

}