import 'package:flutter/material.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_providers.dart';
import 'core/layout/layout_base.dart';
import 'features/events/screens/home.dart';
import 'features/events/screens/event_detail_screen.dart';

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
        initialRoute: '/',
        routes: {
          '/': (context) => LayoutBase(child: Home()),
          '/event-details': (context) {
            final event = ModalRoute.of(context)!.settings.arguments as Event;
            return EventDetailScreen(event: event); // ← SIN LayoutBase
          },
        },
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