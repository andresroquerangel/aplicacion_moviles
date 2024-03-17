import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mi_app2/model/actor_model.dart';

class ApiActor {
  final dio = Dio();

  var listGenresMap = null;

  Future<List<ActorModel>?> getActorsMovie(int id_movie) async {
    final URL =
        'https://api.themoviedb.org/3/movie/${id_movie}/credits?api_key=1e68617243e6c01e3d7606f2ca48595b&language=es-MX';
    Response response = await dio.get(URL);
    if (response.statusCode == 200) {
      final listActorsMap = response.data['cast'] as List;
      return listActorsMap.map((actor) => ActorModel.fromMap(actor)).toList();
    }
    return null;
  }
}
