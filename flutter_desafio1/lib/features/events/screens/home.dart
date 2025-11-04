import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/layout/appbar.dart';
import 'package:flutter_desafio1/core/services/api_service.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';
import 'package:flutter_desafio1/features/events/widgets/contenedorEvent.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<Home> {
  List<Event>? _events;
  late final http.Client _client;
  late final ApiService _apiService;

  @override
  void initState() {
    super.initState();
    // 1. Inicialización de servicios
    _client = http.Client();
    _apiService = ApiService(client: _client);

    // 2. Iniciar la carga de datos
    _fetchEvents();
  }

  _fetchEvents() async {
    try {
      final responseData = await _apiService.get('/events');

      // Mapeo de la respuesta JSON (que esperamos sea una List<Map>) a List<Event>
      final fetchedEvents = (responseData as List)
          .map((json) => Event.fromJson(json))
          .toList();

      if (mounted) {
        setState(() {
          _events = fetchedEvents;
        });
      }
    } catch (e) {}
  }

  @override
  void dispose() {
    _client.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorstyles.background,
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colorstyles.background,
                borderRadius: BorderRadius.circular(0),
                border: Border.all(
                  color: Colors.grey, // Define el color del borde (ej. gris)
                  width: 2.0, // Define el grosor del borde
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        bottom: 20.0,
                        right: 30.0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tu Panel de Eventos",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Aqui tienes un resumen de tus proximos eventos. Crea, gestiona y sigue tu exito, todo en un solo lugar.",
                            style: TextStyle(
                              color: Colorstyles.component,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.createEvent);
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colorstyles.button,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                            ),
                        minimumSize: MaterialStateProperty.all<Size>(
                          const Size(0, 50),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.add,
                            color: Colorstyles.textButton,
                            size: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(width: 5),
                          Text(
                            'Crear Evento',
                            style: TextStyle(
                              color: Colorstyles.textButton,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: gridViewEvents(),
            )   
          ),
        ],
      ),
    );
  }
  Widget gridViewEvents() {
  if(_events != null){
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
        childAspectRatio: 0.90,
      ),
      itemCount: _events!.length,
      itemBuilder: (context, index) {
        return Contenedorevent(selectedEvent: _events![index]);
      },
    );
  } else {
    return Column(
      children:[
        Text(
          'Aun no hay eventos disponibles.',
          style: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text("Que esperas para crear tu primer evento?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 35,
          ),),
      ]
    );
  }
}
}

