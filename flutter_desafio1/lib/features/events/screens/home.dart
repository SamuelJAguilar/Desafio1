import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/event_controller.dart';
import '../widgets/contenedorEvent.dart';
import 'event_detail_screen.dart'; 

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final eventController = Provider.of<EventController>(context);

    // Cargar eventos cuando se abre la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (eventController.events.isEmpty && !eventController.isLoading) {
        eventController.loadEvents();
      }
    });

    return ListView(
      children: [
        Container(
          padding: EdgeInsets.only(
            left: 100,
            right: 20.0,
            top: 5.0,
            bottom: 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tu Panel de Eventos',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Aquí puedes ver los próximos eventos y detalles. Crea, gestiona y sigue tu éxito, todo en un solo lugar.",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 50, right: 100, top: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // Navegar a pantalla de crear evento (lo haremos después)
                  },
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Colors.white),
                      Text(
                        ' Crear Nuevo Evento',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 156, 28, 18),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Estado de carga
        if (eventController.isLoading)
          Container(
            padding: EdgeInsets.all(100),
            child: Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Cargando eventos...'),
                ],
              ),
            ),
          ),

        // Estado de error
        if (eventController.error != null)
          Container(
            padding: EdgeInsets.all(50),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.error, size: 50, color: Colors.red),
                  SizedBox(height: 20),
                  Text(
                    eventController.error!,
                    style: TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: eventController.loadEvents,
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            ),
          ),

        // Lista de eventos
        if (!eventController.isLoading && eventController.error == null)
          Container(
            padding: EdgeInsets.only(left: 100, right: 100, top: 20),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 350 / 280,
              ),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: eventController.events.length,
              itemBuilder: (context, index) {
                final event = eventController.events[index];
                return ContenedorEvent(
                  event: event,
                  onTap: () {
                  
                  },
                );
              },
            ),
          ),

        // Estado vacío
        if (!eventController.isLoading && 
            eventController.error == null && 
            eventController.events.isEmpty)
          Container(
            padding: EdgeInsets.all(100),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.event_busy, size: 50, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'No hay eventos disponibles',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Navegar a crear evento
                    },
                    child: Text('Crear primer evento'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}