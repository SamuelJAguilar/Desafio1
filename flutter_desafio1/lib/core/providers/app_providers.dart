import 'package:flutter_desafio1/core/services/event_service.dart';
import 'package:flutter_desafio1/core/services/ticket_service.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../../features/events/controllers/event_controller.dart';

class AppProviders {
  static late ApiService apiService;
  static late EventService eventService;
  static late TicketService ticketService;
  static late EventController eventController;

  static void initialize() {
    // Inicializar servicios
    apiService = ApiService(client: http.Client());
    eventService = EventService(apiService: apiService);
    ticketService = TicketService(apiService: apiService);
    
    // Inicializar controladores
    eventController = EventController(eventService: eventService);
  }

  // Método para proporcionar todos los providers a la app
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<EventController>(
          create: (context) => eventController,
        ),
      ];
}