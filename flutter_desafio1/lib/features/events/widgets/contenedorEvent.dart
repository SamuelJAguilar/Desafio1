import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
import 'package:intl/intl.dart';

class Contenedorevent extends StatefulWidget {
  final Event? selectedEvent;
  const Contenedorevent({super.key, required this.selectedEvent});

  @override
  State<Contenedorevent> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Contenedorevent> {
  bool _isHovering = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(context, AppRoutes.detail,
              arguments: widget.selectedEvent);
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: 350,
            decoration: BoxDecoration(
              color: _isHovering? Colors.white : Colorstyles.component,
              border: Border.all(color: Colorstyles.component),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: 10,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      'https://corsproxy.io/?https://www.esneca.com/wp-content/uploads/eventos-sociales.jpg',
                    ),
                  ),
                  Text(
                    widget.selectedEvent!.title,
                    style: TextStyle(
                      color: Colorstyles.textComponent,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 18,
                        color: Colorstyles.button,
                      ),
                      Expanded(
                        child: Text(
                          widget.selectedEvent!.location,
                          style: TextStyle(
                            color: Colorstyles.textInformation,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 5,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 18,
                        color: Colorstyles.button,
                      ),
                      Expanded(
                        child: Text(
                          DateFormat(
                            'EEEE, d MMMM yyyy',
                          ).format(widget.selectedEvent!.date.toLocal()),
                          style: TextStyle(
                            color: Colorstyles.textInformation,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
