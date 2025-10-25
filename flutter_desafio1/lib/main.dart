import 'package:flutter/material.dart';
// import 'package:provider/provider.dart'; // ← COMENTA
// import 'core/providers/app_providers.dart'; // ← COMENTA
import 'core/layout_base.dart';
import 'features/events/screens/home.dart';
// import 'routes/app_pages.dart'; // ← COMENTA
// import 'routes/app_routes.dart'; // ← COMENTA

void main() {
  // COMENTA la inicialización de providers
  // AppProviders.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Centro de Eventos',
      // COMENTA MultiProvider y rutas
      // home: LayoutBase(child: Home()),
      home: Scaffold(
        body: LayoutBase(child: Home()),
      ),
    );
  }
}