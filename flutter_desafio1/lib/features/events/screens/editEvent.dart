import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/layout/appbar.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/features/events/widgets/details_events.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';

class Editevent extends StatefulWidget {
  final Event? event;
  const Editevent({super.key, required this.event});

  @override
  State<Editevent> createState() => _EditeventState();
}

class _EditeventState extends State<Editevent> {
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
                  'Editar Evento',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 50),
                ),
                Text(
                  'Actualiza la información de tu evento',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 20),
                ),
              ],
            ),
          ),
          Expanded(
            child: DetailEvent(event: widget.event, cancelar:() {
                  Navigator.pushNamed(context, AppRoutes.detail, arguments: widget.event);
                } ),
          ),
        ],
      ),
    );
  }
}