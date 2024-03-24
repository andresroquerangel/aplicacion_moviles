// Importa los paquetes necesarios
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mi_app2/model/actor_model.dart';
import 'package:mi_app2/model/popular_model.dart';
import 'package:mi_app2/network/api_actors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:mi_app2/network/api_favorites.dart';

// Define tu clase DetailMovieScreen
class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  ApiActor? apiActor;
  ApiFavorites? apiFavorites;
  bool? isFavorite;

  @override
  void initState() {
    super.initState();
    apiActor = ApiActor();
    apiFavorites = ApiFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    setState(() {
      isFavorite = popularModel.favorite;
    });
    final videoID = YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=${popularModel.videoUrl}');
    final controller = YoutubePlayerController(
        initialVideoId: videoID != null ? videoID! : '',
        flags: const YoutubePlayerFlags(autoPlay: false));
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    'https://image.tmdb.org/t/p/w500/${popularModel.backdropPath}',
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.7), // Opacidad del 50%
            ),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width * 0.34,
                          child: Hero(
                            tag: 'poster_${popularModel.id}',
                            child: Image.network(
                                'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}'), // Widget a animar
                          )
                          /*Image.network(
                          'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}',
                        ),*/
                          ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popularModel.title!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              IconButton(
                                  onPressed: () {
                                    if (isFavorite == null) {
                                      apiFavorites!
                                          .addToFavorites(popularModel.id!);
                                      setState(() {
                                        isFavorite = true;
                                        popularModel.favorite = true;
                                      });
                                    } else {
                                      if (isFavorite == true) {
                                        apiFavorites!.removeFromFavorites(
                                            popularModel.id!);
                                        setState(() {
                                          isFavorite = null;
                                          popularModel.favorite = null;
                                        });
                                      }
                                    }
                                  },
                                  icon: Icon(
                                      (isFavorite == null
                                          ? Icons.favorite_border
                                          : Icons.favorite),
                                      size: 30,
                                      color: Colors.red)),
                              RatingBar(
                                initialRating: popularModel.voteAverage! / 2,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                ratingWidget: RatingWidget(
                                  full: const Icon(Icons.star,
                                      color: Colors.amber),
                                  half: const Icon(Icons.star_half,
                                      color: Colors.amber),
                                  empty: const Icon(Icons.star_border,
                                      color: Colors.amber),
                                ),
                                itemSize: 15.0,
                                onRatingUpdate: (rating) {},
                              ),
                              Text(
                                popularModel.genres!.join(", "),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Actores',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 100,
                        child: FutureBuilder(
                          future: apiActor!.getActorsMovie(popularModel.id!),
                          builder: (context,
                              AsyncSnapshot<List<ActorModel>?> snapshot) {
                            if (snapshot.hasData) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: List.generate(snapshot.data!.length,
                                      (index) {
                                    final actor = snapshot.data![index];
                                    if (actor.knownForDepartment == 'Acting') {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            (actor.profilePath != null)
                                                ? CircleAvatar(
                                                    radius: 30,
                                                    backgroundImage:
                                                        NetworkImage(
                                                      'https://image.tmdb.org/t/p/w500/${actor.profilePath}',
                                                    ),
                                                  )
                                                : const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.white,
                                                    radius: 30,
                                                    child: Icon(
                                                      Icons.person,
                                                      color: Colors.black,
                                                      size: 45,
                                                    ),
                                                  ),
                                            const SizedBox(height: 5),
                                            Text(
                                              actor.originalName!,
                                              style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return const SizedBox.shrink();
                                    }
                                  }),
                                ),
                              );
                            } else {
                              if (snapshot.hasError) {
                                return const Text('Hay error');
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Descripción',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        popularModel.overview!,
                        textAlign: TextAlign.justify,
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 10),
                      videoID == null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.22,
                            )
                          : YoutubePlayer(
                              controller: controller,
                              showVideoProgressIndicator: true,
                            ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
