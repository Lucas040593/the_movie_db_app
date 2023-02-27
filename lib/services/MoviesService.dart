import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/Models/MovieCast.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';
import 'package:the_movie_db_app/secret/themoviedb_api.dart';

class MoviesService {
  //Obtener la lista de peliculas populares.
  static Future<List<Movie>?> getPopularMovies(int page) async {
    final response = await http.get(Uri.parse(GlobaPaths.apiBase +
        'movie/popular?page=$page&api_key=' +
        themoviedbApi));
    if (response.statusCode == 200) {
      List parsedList = json.decode(response.body)['results'];
      return parsedList.map((m) => Movie.fromJson(m)).toList();
    } else {
      print('Error al recuperar las peliculas mas populares de la API');
      return null;
    }
  }

  //Obtener una pelicula.
  static Future<Movie?> getOneMovie(int movieId) async {
    final response = await http.get(Uri.parse(
        GlobaPaths.apiBase + 'movie/$movieId?api_key=' + themoviedbApi));
    if (response.statusCode == 200) {
      return Movie.fromJson(json.decode(response.body));
    } else {
      print('Error al buscar la pelicula en la API');
      return null;
    }
  }

  //Obtener los actores de una pelicula.
  static Future<List<MovieCast>?> getCreditsMovie(int movieId) async {
    final response = await http.get(Uri.parse(GlobaPaths.apiBase +
        'movie/$movieId/credits?api_key=' +
        themoviedbApi));
    if (response.statusCode == 200) {
      List parsedList = json.decode(response.body)['cast'];
      return parsedList.map((m) => MovieCast.fromJson(m)).toList();
    } else {
      print('Error al buscar los actores de la pelicula en la API');
      return null;
    }
  }

  //Obtener pelicula por titulo.
  static Future<List<Movie>?> getMovieByTitle(String movieTitle) async {
    final response = await http.get(Uri.parse(GlobaPaths.apiBase +
        'search/movie?query=$movieTitle&api_key=' +
        themoviedbApi));
    if (response.statusCode == 200) {
      List parsedList = json.decode(response.body)['results'];
      return parsedList.map((m) => Movie.fromJson(m)).toList();
    } else {
      print('Error al buscar los actores de la pelicula en la API');
      return null;
    }
  }
}
