import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';
import 'package:the_movie_db_app/provider/Movie_provider.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';

import '../screens/MovieDetailView.dart';

class SimpleMovieCard extends StatefulWidget {
  const SimpleMovieCard({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  State<SimpleMovieCard> createState() => _SimpleMovieCardState();
}

class _SimpleMovieCardState extends State<SimpleMovieCard> {
  final double _lateralMargin = 20;

  //Card con un placeholder de la imagen y cuando recibe la imagen de la url sustituye al placeholder. Al pulsar lleva a los detalles de la pelicula.
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context);

    return GestureDetector(
      child: Card(
        color: const Color(0x00000000),
        margin: EdgeInsets.only(right: _lateralMargin),
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'resources/images/placeholder.png',
              image: GlobaPaths.imageBase + widget.movie.posterPath,
              height: 230,
              width: 155,
              fit: BoxFit.contain,
            ),
            //IconButton para dar like a la película
            Container(
                constraints: const BoxConstraints(maxWidth: 150),
                padding: const EdgeInsets.only(right: 5, left: 5),
                child: Consumer<MovieProvider>(
                  builder: (context, movies, child) {
                    return IconButton(
                      icon: Icon(Icons.favorite),
                      color: widget.movie.check == true
                          ? Colors.red
                          : Colors.white,
                      iconSize: 20,
                      onPressed: () {
                        moviesProvider.setFavorite(widget.movie.id);
                      },
                    );
                  },
                ))
          ],
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MovieDetailView(
                      movie: widget.movie,
                    )));
      },
    );
  }
}
