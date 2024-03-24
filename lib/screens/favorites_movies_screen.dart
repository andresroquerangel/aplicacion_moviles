import 'package:flutter/material.dart';
import 'package:mi_app2/model/popular_model.dart';
import 'package:mi_app2/network/api_favorites.dart';

class FavoritesMoviesScreen extends StatefulWidget {
  const FavoritesMoviesScreen({super.key});

  @override
  State<FavoritesMoviesScreen> createState() => _FavoritesMoviesScreenState();
}

class _FavoritesMoviesScreenState extends State<FavoritesMoviesScreen> {
  ApiFavorites? apiFavorites;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    apiFavorites = ApiFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritas'),),
      body: FutureBuilder(
          future: apiFavorites!.getFavoriteMovies(),
          builder: (context, AsyncSnapshot<List<PopularModel>?> snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: .7,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => Navigator.pushNamed(context, "/detail",
                        arguments: snapshot.data![index]).then((value){
                          Navigator.pushReplacementNamed(context, "/favorite");
                        }),
                    child: Hero(
                      tag: 'poster_${snapshot.data![index].id}',
                      child: Image.network(
                          'https://image.tmdb.org/t/p/w500/${snapshot.data![index].posterPath}'), // Widget a animar
                    ),
                  );
                },
              );
            } else {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Ocurrio un error :()'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }
          }),
    );
  }
}
