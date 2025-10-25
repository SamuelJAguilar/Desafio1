import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_providers.dart';
import 'core/layout/layout_base.dart';
import 'features/events/screens/home.dart';


void main() {
  AppProviders.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.providers,
      child: MaterialApp(
        title: 'Centro de Eventos',

        home: LayoutBase(child: Home()), 
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => LayoutBase(
              child: Center(child: Text('Página no encontrada')),
            ),
          );
        },
      ),
    );
  }
}