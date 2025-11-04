import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/layout/appbar.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/features/events/widgets/details_events.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';

class CreateNewEvent extends StatefulWidget {
  const CreateNewEvent({super.key});

  @override
  State<CreateNewEvent> createState() => _CreateNewEventState();
}

class _CreateNewEventState extends State<CreateNewEvent> {
  Event? event;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorstyles.background,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text(
                  'Crear Un Nuevo Evento',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 50),
                ),
                Text(
                  'Completa el Formulario para poner en marcha tu evento',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: DetailEvent(
              event: event,
              cancelar: () {
                Navigator.pushNamed(context, AppRoutes.home);
              },
            ),
          ),
        ],
      ),
    );
  }
}
