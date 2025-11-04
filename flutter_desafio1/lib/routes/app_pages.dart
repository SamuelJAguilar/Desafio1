import 'package:flutter/material.dart';
import 'package:flutter_desafio1/features/events/screens/create_new_event.dart';
import 'package:flutter_desafio1/features/events/screens/editEvent.dart';
import 'package:flutter_desafio1/features/events/screens/event_detail_screen.dart';
import 'package:flutter_desafio1/features/events/screens/home.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';

class AppPages {
  static Map<String, WidgetBuilder> get routes {
    return {
      AppRoutes.home: (context) => Home(),
      AppRoutes.detail: (context) => EventDetailScreen(event: ModalRoute.of(context)!.settings.arguments as dynamic),
      AppRoutes.createEvent: (context) => CreateNewEvent(),
      AppRoutes.editEvent: (context) => Editevent(event: ModalRoute.of(context)!.settings.arguments as dynamic),
    
    };
  }
}
