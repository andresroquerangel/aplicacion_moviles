import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mi_app2/model/popular_model.dart';

class ApiPopular {
  final URL =
      "https://api.themoviedb.org/3/movie/popular?api_key=1e68617243e6c01e3d7606f2ca48595b&language=es-MX&page=1";
  final dio = Dio();

  Future<List <PopularModel>?> getPopularMovie() async {
    Response response = await dio.get(URL);
    if(response.statusCode == 200){
      //print(response.data['result'].runtimeType);

      final listMoviesMap = response.data['results'] as List;
      return listMoviesMap.map((movie) => PopularModel.fromMap(movie)).toList();
    }
    return null;
  }
}
