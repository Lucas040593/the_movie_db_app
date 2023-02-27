import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';
import 'package:the_movie_db_app/secret/themoviedb_api.dart';
import 'package:http/http.dart' as http;

//Clase para cargar peliculas
class MovieProvider with ChangeNotifier {
  List<Movie> moviesList = [];
  List<Movie> moviesListPopular = [];
  List parsedList = [];
  bool isLoading = false;
  int _popularMoviesPage = 1;

  getMyData() async {
    isLoading = true;
    moviesList = (await loadMovies())!;
    moviesListPopular = (await loadPopularMovies(_popularMoviesPage))!;
    isLoading = false;
    notifyListeners();
  }

  //Obtener la lista de peliculas en cartelera.
  Future<List<Movie>?> loadMovies() async {
    final response = await http.get(Uri.parse(
        GlobaPaths.apiBase + 'movie/now_playing?api_key=' + themoviedbApi));
    if (response.statusCode == 200) {
      parsedList = json.decode(response.body)['results'];
      notifyListeners();
      return moviesList = parsedList.map((m) => Movie.fromJson(m)).toList();
    } else {
      print('Error al recuperar las peliculas en cartelera de la API');
      return null;
    }
  }

  //Obtener la lista de peliculas populares.
  Future<List<Movie>?> loadPopularMovies(int page) async {
    final response = await http.get(Uri.parse(GlobaPaths.apiBase +
        'movie/popular?page=$page&api_key=' +
        themoviedbApi));
    if (response.statusCode == 200) {
      List parsedList = json.decode(response.body)['results'];
      notifyListeners();
      return moviesListPopular =
          parsedList.map((m) => Movie.fromJson(m)).toList();
    } else {
      print('Error al recuperar las peliculas mas populares de la API');
      return null;
    }
  }

  //Obtener la película según id
  setFavorite(int id) {
    moviesList.where((element) => element.id == id).first.check = true;
    notifyListeners();
  }
}

//Clase para marcar favorito en cartelera
class ThemeChanger with ChangeNotifier {
  ThemeData _themeData;

  ThemeChanger(this._themeData);

  getTheme() => _themeData;

  setTheme(ThemeData theme) {
    this._themeData = theme;
    notifyListeners();
  }
}
