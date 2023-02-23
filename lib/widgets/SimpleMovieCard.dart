import 'package:flutter/material.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';

import '../screens/MovieDetailView.dart';

class SimpleMovieCard extends StatefulWidget {
  const SimpleMovieCard({ Key? key, required this.movie }) : super(key: key);
  final Movie movie;

  @override
  State<SimpleMovieCard> createState() => _SimpleMovieCardState();
}

class _SimpleMovieCardState extends State<SimpleMovieCard> {
final double _lateralMargin = 20;

  //Card con un placeholder de la imagen y cuando recibe la imagen de la url sustituye al placeholder. Al pulsar lleva a los detalles de la pelicula.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
      color: const Color(0x00000000),
        margin: EdgeInsets.only(right: _lateralMargin),
        child: FadeInImage.assetNetwork(
          placeholder: 'resources/images/placeholder.png',
          image: GlobaPaths.imageBase+widget.movie.posterPath,
          height: 270,
          width: 190,
          fit: BoxFit.contain,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) =>  MovieDetailView(movie: widget.movie,))
        );
      },    
    );
  }
}