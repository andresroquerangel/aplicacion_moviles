import 'package:flutter/material.dart';
import 'package:mi_app2/model/popular_model.dart';

class DetailMovieScreen extends StatefulWidget {
  const DetailMovieScreen({super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  @override
  Widget build(BuildContext context) {
    final popularModel =
        ModalRoute.of(context)!.settings.arguments as PopularModel;
    return Center(
      child: Column(children: [
        Text(popularModel.title!),
        Text(popularModel.voteCount!.toString())
      ]),
    );
  }
}
