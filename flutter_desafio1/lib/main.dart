import 'package:flutter/material.dart';
import 'package:flutter_desafio1/routes/app_pages.dart';
import 'package:provider/provider.dart';
import 'core/providers/app_providers.dart';

void main() {
  
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
        routes: AppPages.routes,
        
              
      ),
    );
  }
}