import 'package:flutter/material.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/screens/MovieDetailView.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';
import 'package:the_movie_db_app/widgets/MovieCard.dart';
import 'package:the_movie_db_app/widgets/TitleWidget.dart';

import '../services/MoviesService.dart';

class SearchView extends StatefulWidget {
  const SearchView({ Key? key }) : super(key: key);

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  static TextEditingController _textController = TextEditingController();
  static String _titleSearched = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movies searcher'),
        centerTitle: true,
        backgroundColor: CustomColors.secondary,
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchTextField(),
              const Padding(padding: EdgeInsets.all(10)),
              _buildSearchButton(),
              const Padding(padding: EdgeInsets.all(10)),
              _buildSearchedMovie(),
            ]
          ),
        ),
      )
    );
  }

  //Campo titulo para buscar las peliculas.
  Widget _buildSearchTextField() {
    return TextFormField(
      keyboardType: TextInputType.text,
      obscureText:false,
      controller: _textController,
      textAlign: TextAlign.left,
      style: const TextStyle(color: Colors.white),
      decoration: const InputDecoration(
        hintText: 'Search movies by title',
        hintStyle: TextStyle(color: Colors.grey),
        enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            borderSide: BorderSide(color: CustomColors.secondary)
        ),
      )
    );
  }

  //Boton de busqueda de pelicula.
  Widget _buildSearchButton(){
    return TextButton(
      child: const Text(
        'Search',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 18
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: CustomColors.secondary,
        primary: CustomColors.secondary,
        padding: const EdgeInsets.all(10),
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: (){
        setState(() {
          _titleSearched = _textController.text;
        });
      },
    );
  }

  //Espera a recibir la lista de objetos Movie y mientras muestra un spinner.
  Widget _buildSearchedMovie(){
    if(_titleSearched == ''){
      return Container();
    } else {
      return FutureBuilder(
      future: _searchMovie(_titleSearched),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if(snapshot.hasData){
            return _buildSearchedMoviesList(snapshot.data);
          } else {
            return const SizedBox(
                width: 80,
                height: 80,
                child: CircularProgressIndicator()
            );
          }
        },
      );
    }
  }

  //Espera a recibir la lista de objetos Movie y la carga en un ListView.
  Widget _buildSearchedMoviesList(List<Movie> lista){
    if(lista.length == 0){
      return TitleWidget(title: 'No results');
    } else {
      return SizedBox(
        height: 550,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: lista.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (BuildContext context, int index) {
            return _buildResultMovies(lista[index]);
          }
        )
      );
    }
  }

  //Lista de titulos de resultados de peliculas buscadas.
  Widget _buildResultMovies(Movie movie){
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              movie.title,
              textAlign: TextAlign.start,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18
              ),
            ),
          ],
        ),
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  MovieDetailView(movie: movie,))
          );
        },
      ),
    );
  }

  //Llama a Movies services y le pide una lista de objetos Movie, segun el titulo indicado.
  Future _searchMovie(String movieTitle) async{
    return MoviesService.getMovieByTitle(movieTitle).then((value) {
      return value;
    });
  }
}