import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mi_app2/screens/dashboard_screen.dart';
import 'package:mi_app2/screens/despensa_screen.dart';
import 'package:mi_app2/screens/detail_movie_screen.dart';
import 'package:mi_app2/screens/favorites_movies_screen.dart';
import 'package:mi_app2/screens/popular_movies_screen.dart';
import 'package:mi_app2/screens/register_screen.dart';
import 'package:mi_app2/screens/splash_screen.dart';
import 'package:mi_app2/settings/app_value_notifier.dart';
import 'package:mi_app2/settings/theme.dart';
import 'package:mi_app2/screens/products_firebase_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyBv7GJUi0sjvnOz7cfJbf70QYcPhbwvJVQ",
          appId: "1:576187361770:android:a72af3e728edfb91c92a93",
          messagingSenderId: "576187361770",
          projectId: "prueba-3d4cf"));
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: const SplashCreen(),
            routes: {
              "/dash": (BuildContext context) => const DashboardScreen(),
              "/despensa": (BuildContext context) => const DespensaScreen(),
              "/register": (BuildContext context) => const RegisterScreen(),
              "/movies": (BuildContext context) => const PopularMoviesScreen(),
              "/favorite": (BuildContext context) => const FavoritesMoviesScreen(),
              "/detail": (BuildContext context) => const DetailMovieScreen(),
              "/products": (BuildContext context) => const ProductsFirebaseScreen(),
            },
          );
        });
  }
}


/*class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int contador = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: Text(
            'Practica 1',
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
        drawer: Drawer(),
        floatingActionButton: FloatingActionButton(rr
          backgroundColor: Colors.red,
          onPressed: () {
            contador++;
            print(contador);
            setState(() {});
          },
          child: Icon(Icons.ads_click),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.network(
                'https://sg.com.mx/sites/default/files/2018-04/LogoITCelaya.png',
                height: 250,
              ),
            ),
            Text('Hola mundo $contador')
          ],
        )),
      ),
    );
  }
}*/
