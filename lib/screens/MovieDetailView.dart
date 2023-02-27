import 'package:flutter/material.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/Models/MovieCast.dart';
import 'package:the_movie_db_app/globalData/GlobalPaths.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';

import '../services/MoviesService.dart';
import '../widgets/TitleWidget.dart';

class MovieDetailView extends StatefulWidget {
  const MovieDetailView({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  State<MovieDetailView> createState() => _MovieDetailViewState();
}

class _MovieDetailViewState extends State<MovieDetailView> {
  //Card con placeholder de la imagen y el titulo de la pelicula, cuando recibe la imagen de la url sustituye al placeholder.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.movie.title),
          centerTitle: true,
        ),
        body: Container(
            margin: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPoster(widget.movie.posterPath),
                  const Padding(padding: EdgeInsets.only(top: 20)),
                  _builSectionTitle('Title'),
                  _buildInformation(widget.movie.title),
                  _buildDivider(),
                  _builSectionTitle('Original title'),
                  _buildInformation(widget.movie.originalTitle),
                  _buildDivider(),
                  _builSectionTitle('Description'),
                  _buildDescription(widget.movie.overview),
                  _buildDivider(),
                  _builSectionTitle('Average'),
                  _buildInformation(widget.movie.voteAverage.toString()),
                  _buildDivider(),
                  _builSectionTitle('Cast'),
                  _buildMovieCredits(widget.movie.id),
                ],
              ),
            )));
  }

  //Titulo de cada seccion.
  Widget _builSectionTitle(String title) {
    return TitleWidget(title: title);
  }

  //Divider.
  Widget _buildDivider() {
    return const Divider(height: 50, thickness: 1, color: Colors.white);
  }

  //Si la informacion de la peli no tiene foto muestra el placeholder, sino la portada.
  Widget _buildPoster(String posterLink) {
    String _posterLink = posterLink;
    if (_posterLink == '') {
      return Container(
          alignment: Alignment.center,
          child: Image.asset(
            'resources/images/placeholder.png',
            height: 230,
            width: 155,
            fit: BoxFit.contain,
          ));
    } else {
      return FadeInImage.assetNetwork(
        placeholder: 'resources/images/placeholder.png',
        image: GlobaPaths.imageBase + _posterLink,
        fit: BoxFit.contain,
      );
    }
  }

  //Campos de informacion de la pelicula.
  Widget _buildInformation(String info) {
    return Text(
      info,
      textAlign: TextAlign.center,
      style: const TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 25,
          color: CustomColors.secondary),
    );
  }

  //Descripcion de la pelicula.
  Widget _buildDescription(String info) {
    return Text(
      info,
      textAlign: TextAlign.justify,
      style: const TextStyle(fontSize: 25, color: CustomColors.secondary),
    );
  }

  //Espera a recibir la lista de actores de una pelicula y mientras muestra un spinner.
  Widget _buildMovieCredits(int movieId) {
    return FutureBuilder(
      future: _getMovieCredits(movieId),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return _buildMovieCreditsList(snapshot.data);
        } else {
          return const SizedBox(
              width: 80, height: 80, child: CircularProgressIndicator());
        }
      },
    );
  }

  //Carga la lista actores de una pelicula en un ListView horizontal.
  Widget _buildMovieCreditsList(List<MovieCast> lista) {
    return SizedBox(
        height: 280,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return _buildCastInfo(lista[index]);
            }));
  }

  //Actores.
  Widget _buildCastInfo(MovieCast cast) {
    String _imageLink = cast.profilePath;
    //Si el actor no tiene foto en su ficha muestra este card con placeholder.
    if (_imageLink == '') {
      return Card(
        color: const Color(0x00000000),
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            Image.asset(
              'resources/images/placeholder.png',
              height: 230,
              width: 155,
              fit: BoxFit.contain,
            ),
            _buildCastName(cast.name)
          ],
        ),
      );
      //Si tiene foto la muestra.
    } else {
      return Card(
        color: const Color(0x00000000),
        margin: const EdgeInsets.only(right: 20),
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholder: 'resources/images/placeholder.png',
              image: GlobaPaths.imageBase + cast.profilePath,
              height: 230,
              width: 155,
              fit: BoxFit.contain,
            ),
            _buildCastName(cast.name)
          ],
        ),
      );
    }
  }

  //Nombre del actor
  Widget _buildCastName(String castName) {
    return Container(
        constraints: const BoxConstraints(maxWidth: 155),
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(right: 5, left: 5),
        child: Text(
          castName,
          textAlign: TextAlign.center,
          style: const TextStyle(
              overflow: TextOverflow.clip,
              fontSize: 15,
              color: CustomColors.secondary),
        ));
  }

  //Llama a Movies services y le pide una lista de actores de la pelicula.
  Future _getMovieCredits(int movidId) {
    return MoviesService.getCreditsMovie(movidId).then((value) {
      return value;
    });
  }
}
