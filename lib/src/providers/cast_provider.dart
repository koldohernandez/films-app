import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:films_app/src/models/cast_model.dart';

class CastProvider 
{

  String _apiKey = 'e56f01f0bc74713b407820c80829d2eb';
  String _url = 'api.themoviedb.org';
  String _language = 'es-ES';


  Future<List<Actor>> getActores(String filmId) async
  {

    print('Id de peli = $filmId');

    final url = new Uri.https(
      _url, '3/movie/$filmId/credits', {
       'api_key'  : _apiKey,
       'language' : _language,
      }
    );

    return await _procesarPeticion(url);
  }
  

  Future<List<Actor>> _procesarPeticion(Uri url) async
  {
    final response = await http.get(url);
    final decodedData = json.decode(response.body);
    
    print(decodedData);

    final actores = Actores.fromJSONList(decodedData['cast']);
    
    print('Nº actores = ${actores.items.length}');

    return actores.items;
  }

}