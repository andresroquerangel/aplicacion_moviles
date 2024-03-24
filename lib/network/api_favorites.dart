import 'package:dio/dio.dart';
import 'package:mi_app2/model/popular_model.dart';

class ApiFavorites {
  final String apiKey = '558a6043ffaf21488d74cb6f44181b9a';
  final String sessionId = '9f4adcec50f3d8bcf717df8a6786811c14ec828a';
  //final String authorizedRequestToken = '0bbc219aaee7054d0c98f215c889559659d9ec06';

  final URL_GENRE =
      "https://api.themoviedb.org/3/genre/movie/list?api_key=1e68617243e6c01e3d7606f2ca48595b&language=es-MX";

    var listGenresMap = null;
  
  Future<List<PopularModel>?> getFavoriteMovies() async {
    final dio = Dio();
    var response = await dio.get(
      'https://api.themoviedb.org/3/account/21061274/favorite/movies',
      queryParameters: {
        'api_key': apiKey,
        'session_id': sessionId,
      },
    );

    if (response.statusCode == 200) {
      final listMoviesMap = response.data['results'] as List;
      response = await dio.get(URL_GENRE);
      if (response.statusCode == 200) {
        listGenresMap = response.data['genres'] as List;

        await Future.forEach(listMoviesMap.asMap().entries, (entry) async {
          final index = entry.key;
          final movie = entry.value;
          List<dynamic> genreIds = movie['genre_ids'];
          listMoviesMap[index]['genre_ids'] = getGenre(genreIds);
          var url_movie =
              "https://api.themoviedb.org/3/movie/${listMoviesMap[index]['id']}/videos?api_key=558a6043ffaf21488d74cb6f44181b9a&language=es-MX";
          response = await dio.get(url_movie);
          final listMovieTrailer = response.data['results'] as List;
          if (response.statusCode == 200) {
            if (listMovieTrailer.length > 0) {
              listMoviesMap[index]['key'] = listMovieTrailer.last['key'];
            } else {
              listMoviesMap[index]['key'] = '';
            }
          }

          listMoviesMap[index]['favorite']=true;
        });
      }
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }

  List<dynamic> getGenre(List<dynamic> idGenres) {
    idGenres.asMap().forEach((index, id) {
      listGenresMap.forEach((genre) {
        if (id == genre['id']) {
          idGenres[index] = genre['name'];
        }
      });
    });
    return idGenres;
  }

  Future<void> addToFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21061274/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': true,
        },
      );

      if (response.statusCode == 200) {
        print('Película agregada a favoritos');
      } else {
        print('Película agregada a favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> removeFromFavorites(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.post(
        'https://api.themoviedb.org/3/account/21061274/favorite',
        queryParameters: {
          'api_key': apiKey,
          'session_id': sessionId,
        },
        data: {
          'media_type': 'movie',
          'media_id': movieId,
          'favorite': false,
        },
      );

      if (response.statusCode == 200) {
        print('Película eliminada de favoritos');
      } else {
        throw Exception('Error al eliminar la película de favoritos');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<PopularModel?> getMovieDetails(int movieId) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'https://api.themoviedb.org/3/movie/$movieId?api_key=558a6043ffaf21488d74cb6f44181b9a&language=es',
      );

      if (response.statusCode == 200) {
        return PopularModel.fromMap(response
            .data); // Crear un objeto PopularModel desde los datos de la respuesta
      } else {
        throw Exception('Failed to retrieve movie details');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
