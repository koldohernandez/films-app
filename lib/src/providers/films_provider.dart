import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:films_app/src/models/films_model.dart';


class FilmsProvider
{

  String _apiKey = 'e56f01f0bc74713b407820c80829d2eb';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';

  int _pagina = 0;
  bool _isLoading = false;

  List<Film> _popularesList = new List();


  /*
    STREAMS
  */
  final _popularesStreamController = StreamController<List<Film>>.broadcast();
  Function(List<Film>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Film>> get popularesStream => _popularesStreamController.stream;


  void disposeStreams()
  {
    _popularesStreamController?.close(); // cerramos el stream cuando cerramos la página
  }



  /*
    MÉTODOS DEL PROVIDER
   */
  Future<List<Film>> getEnCines() async
  {

    final url = new Uri.https(
      _url, '3/movie/now_playing', {
       'api_key'  : _apiKey,
       'language' : _language,
      }
    );

    return await _procesarPeticion(url);

  }


  Future<List<Film>> getPopulares() async
  {

    if (_isLoading) return [];

    _isLoading = true;
    _pagina++;

    //print('Cargando la página $_pagina');

    final url = new Uri.https(
      _url, '3/movie/popular', {
       'api_key'  : _apiKey,
       'language' : _language,
       'page'     : _pagina.toString(),
      }
    );

    final respuesta = await _procesarPeticion(url);

    // Añadimos la información al stream
    _popularesList.addAll(respuesta);
    popularesSink(_popularesList);

    _isLoading = false;

    //print('-- Fin de la carga de la página $_pagina');

    return respuesta;
  }


  Future<List<Film>> _procesarPeticion(Uri url) async
  {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    
    final films = Films.fromJSONList(decodedData['results']);

    return films.items;
  }
  

  Future<List<Film>> buscarPelicula(String pelicula) async
  {

    final url = new Uri.https(
      _url, '3/search/movie', {
       'api_key'  : _apiKey,
       'language' : _language,
       'query'    : pelicula

      }
    );

    return await _procesarPeticion(url);

  }

}