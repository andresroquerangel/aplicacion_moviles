// Importa los paquetes necesarios
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mi_app2/model/actor_model.dart';
import 'package:mi_app2/model/popular_model.dart';
import 'package:mi_app2/network/api_actors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// Define tu clase DetailMovieScreen
class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({Key? key}) : super(key: key);

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  ApiActor? apiActor;

  @override
  void initState() {
    super.initState();
    apiActor = ApiActor();
  }

  @override
  Widget build(BuildContext context) {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    final videoID = YoutubePlayer.convertUrlToId(
        'https://www.youtube.com/watch?v=${popularModel.videoUrl}');
    final _controller = YoutubePlayerController(
        initialVideoId: videoID != null ? videoID! : '',
        flags: YoutubePlayerFlags(autoPlay: false));
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
              color: Colors.black.withOpacity(0.5), // Opacidad del 50%
            ),
          ),
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.2),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Image.network(
                          'https://image.tmdb.org/t/p/w500/${popularModel.posterPath}',
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(left: 20, top: 50),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                popularModel.title!,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                ),
                              ),
                              Text(
                                DateTime.parse(popularModel.releaseDate!)
                                    .year
                                    .toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
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
                                style: TextStyle(
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
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Actores',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Column(
                                          children: [
                                            CircleAvatar(
                                              radius: 30,
                                              backgroundImage: NetworkImage(
                                                'https://image.tmdb.org/t/p/w500/${actor.profilePath}',
                                              ),
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              actor.originalName!,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox.shrink();
                                    }
                                  }),
                                ),
                              );
                            } else {
                              if (snapshot.hasError) {
                                return Text('Hay error');
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Descripción',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        popularModel.overview!,
                        textAlign: TextAlign.justify,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(height: 10),
                      videoID == null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.22,
                            )
                          : YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                            ),
                      SizedBox(height: 20),
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
