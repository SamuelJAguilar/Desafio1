import 'package:flutter/material.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
// import 'package:provider/provider.dart';
// import '../controllers/event_controller.dart';
// import '../models/event_model.dart';
import '../widgets/contenedorEvent.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    // COMENTA todo lo de Provider y API
    // final eventController = Provider.of<EventController>(context);
    // WidgetsBinding.instance.addPostFrameCallback((_) { ... });

    return Scaffold(
      body: ListView(
        children: [
          // ... tu UI normal
          Container(
            padding: const EdgeInsets.only(left: 100, right: 100, top: 20),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 350 / 280,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 6, // ← Datos estáticos
              itemBuilder: (context, index) {
                return ContenedorEvent(
                  event: Event( // ← Evento de prueba
                    id: index,
                    title: "Evento ${index + 1}",
                    description: "Descripción de prueba",
                    date: DateTime.now().add(Duration(days: index * 10)),
                    location: "Ubicación ${index + 1}",
                    lat: null,
                    lng: null,
                    imageData: null,
                    imageType: null,
                    imageName: null,
                    ticketTypes: [],
                    createdAt: DateTime.now(),
                    updatedAt: DateTime.now(),
                  ),
                  onTap: () {
                    print("Evento $index clickeado");
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ELIMINA estas clases - ya existen en Flutter
// class SliverGridDelegateWithMaxCrossAxisExtent {
// }

// class NeverScrollableScrollPhysics {
// }