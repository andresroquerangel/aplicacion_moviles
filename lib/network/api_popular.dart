import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mi_app2/model/popular_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=1e68617243e6c01e3d7606f2ca48595b&language=es-MX&page=1";
  final dio = Dio();

  final URL_GENRE =
      "https://api.themoviedb.org/3/genre/movie/list?api_key=1e68617243e6c01e3d7606f2ca48595b&language=es-MX";
  var listGenresMap = null;

  Future<List<PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(URL);
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
}
