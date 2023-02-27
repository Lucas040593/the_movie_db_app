import 'package:flutter/material.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';
import 'package:the_movie_db_app/screens/MovieDetailView.dart';

class MovieCard extends StatefulWidget {
  const MovieCard({ Key? key, required this.movie }) : super(key: key);
  final Movie movie;

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
final double _lateralMargin = 20;

  //Card con un placeholder de la imagen y el titulo de la pelicula, cuando recibe la imagen de la url sustituye al placeholder. Al pulsar lleva a los detalles de la
  //pelicula
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        color: const Color(0x00000000),
        margin: EdgeInsets.only(right: _lateralMargin),
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'resources/images/placeholder.png',
              image: GlobaPaths.imageBase+widget.movie.posterPath,
              height: 230,
              width: 155,
              fit: BoxFit.contain,
            ),
            Container(
              constraints: const BoxConstraints(maxWidth: 150),
              margin: const EdgeInsets.only(top: 5),
              padding: const EdgeInsets.only(right: 5, left: 5),
              child: Text(
                widget.movie.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  overflow: TextOverflow.ellipsis,
                  fontSize: 25,
                  color: CustomColors.secondary
                ),
              )
            )
          ],
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