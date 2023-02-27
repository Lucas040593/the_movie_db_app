import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_movie_db_app/Models/Movie.dart';
import 'package:the_movie_db_app/provider/Movie_provider.dart';
import 'package:the_movie_db_app/screens/SearchView.dart';
import 'package:the_movie_db_app/services/MoviesService.dart';
import 'package:the_movie_db_app/theme/CustomColors.dart';
import 'package:the_movie_db_app/widgets/MovieCard.dart';
import 'package:the_movie_db_app/widgets/TitleWidget.dart';

import '../widgets/SimpleMovieCard.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late List<Movie> _popularMoviesList = [];
  static int _popularMoviesPage = 1;
  late ScrollController _popularMoviesScrollController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _popularMoviesScrollController = ScrollController()
      ..addListener(_scrollPopularMoviesListener);
    final dataProvider = Provider.of<MovieProvider>(context, listen: false);
    dataProvider.getMyData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _popularMoviesScrollController.removeListener(_scrollPopularMoviesListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MovieProvider>(context);
    final theme = Provider.of<ThemeChanger>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Movie App"),
          backgroundColor: CustomColors.main,
          leading: Container(),
          actions: [
            _buildSearchButton(),
            _buildDarkButton(theme),
            _buildLightButton(theme),
          ],
        ),
        body: WillPopScope(
            onWillPop: () async => false,
            child: Container(
              margin: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //Peliculas en cartelera
                    _builSectionTitle('Now Playing Movies'),
                    const Padding(padding: EdgeInsets.all(10)),
                    //Cartelera
                    _buildNowPlayingMovies(moviesProvider),
                    //Peliculas populares
                    const Padding(padding: EdgeInsets.all(20)),
                    _builSectionTitle('Popular Movies'),
                    const Padding(padding: EdgeInsets.all(10)),
                    //Populares
                    _buildPopularMovies(moviesProvider),
                  ],
                ),
              ),
            )));
  }

  //Titulo de cada seccion.
  Widget _builSectionTitle(String title) {
    return TitleWidget(title: title);
  }

  //Boton para ir a la pagina de busqueda.
  Widget _buildSearchButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        child: const Icon(Icons.search),
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SearchView()));
        },
      ),
    );
  }

  //Boton para cambiar theme
  Widget _buildDarkButton(ThemeChanger theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        child: const Icon(Icons.dark_mode),
        onTap: () {
          theme.setTheme(ThemeData(
              scaffoldBackgroundColor: CustomColors.fondoDark,
              fontFamily: 'Montserrat'));
        },
      ),
    );
  }

  //Boton para cambiar theme
  Widget _buildLightButton(ThemeChanger theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 20),
      child: GestureDetector(
        child: const Icon(Icons.sunny),
        onTap: () {
          theme.setTheme(ThemeData(
              scaffoldBackgroundColor: CustomColors.fondoLight,
              fontFamily: 'Montserrat'));
        },
      ),
    );
  }

  //Espera a recibir la lista y mientras muestra un spinner.
  Widget _buildNowPlayingMovies(MovieProvider moviesProvider) {
    return moviesProvider.isLoading
        ? const SizedBox(
            width: 80, height: 80, child: CircularProgressIndicator())
        : _buildNowPlayingMoviesList(moviesProvider.moviesList);
  }

  //Carga la lista en un ListView horizontal.
  Widget _buildNowPlayingMoviesList(List<Movie> lista) {
    return SizedBox(
        height: 280,
        child: ListView.builder(
            shrinkWrap: true,
            itemCount: lista.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return SimpleMovieCard(movie: lista[index]);
            }));
  }

  //Espera a recibir la lista y mientras muestra un spinner.
  Widget _buildPopularMovies(MovieProvider moviesProvider) {
    return moviesProvider.isLoading
        ? const SizedBox(
            width: 80, height: 80, child: CircularProgressIndicator())
        : _buildPopularMoviesList(moviesProvider.moviesListPopular);
  }

  //Carga la lista en un ListView horizontal.
  Widget _buildPopularMoviesList(List<Movie> lista) {
    _popularMoviesList += lista;
    return SizedBox(
        height: 270,
        child: ListView.builder(
            controller: _popularMoviesScrollController,
            shrinkWrap: true,
            itemCount: _popularMoviesList.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (BuildContext context, int index) {
              return MovieCard(movie: _popularMoviesList[index]);
            }));
  }

  //Llama a Movies services y le pide una lista para cargar las peliculas al pasar scroll horizontal.
  Future _getPopularMovies() async {
    return MoviesService.getPopularMovies(_popularMoviesPage).then((value) {
      return value;
    });
  }

  //Controlador del scroll de la lista de peliculas populares, que al llegar al final espera 2 segundos y carga mas peliculas,
  //la espera es para evitar cargar demasiadas peliculas a la vez y saturar las memoria. El numero maximo de paginas es 33350 (segun la API)
  void _scrollPopularMoviesListener() {
    if (_popularMoviesScrollController.position.extentAfter < 500 &&
        _popularMoviesPage < 33350) {
      _popularMoviesPage++;
      _getPopularMovies().then((value) {
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            _popularMoviesList += value;
          });
        });
      });
    }
  }
}
