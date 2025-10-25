import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/layout/layout_base.dart';
import 'package:flutter_desafio1/features/events/screens/home.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      // Cuando vayas a '/', muestra HomeScreen dentro de AppLayout
      AppRoutes.home: (context) => LayoutBase(child: Home()),
    
    };
  }
}
