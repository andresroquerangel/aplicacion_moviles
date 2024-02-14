import 'package:flutter/material.dart';
import 'package:mi_app2/screens/dashboard_screen.dart';
import 'package:mi_app2/screens/splash_screen.dart';
import 'package:mi_app2/settings/app_value_notifier.dart';
import 'package:mi_app2/settings/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppValueNotifier.banTheme,
        builder: (context, value, child) {
          return MaterialApp(
            theme: value
                ? ThemeApp.darkTheme(context)
                : ThemeApp.lightTheme(context),
            home: SplashCreen(),
            routes: {
              "/dash": (BuildContext context) => DashboardScreen(),
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
        floatingActionButton: FloatingActionButton(
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
