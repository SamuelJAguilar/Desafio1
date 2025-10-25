import 'package:flutter/material.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
import '../features/events/screens/home.dart';
import '../features/events/screens/event_detail_screen.dart'; // ← Agrega
import '../core/layout_base.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes => {
        AppRoutes.home: (context) => LayoutBase(child: Home()),
        //AppRoutes.eventDetail: (context) => EventDetailScreen(
          //eventId: ModalRoute.of(context)!.settings.arguments as int,
        //),
      };
}