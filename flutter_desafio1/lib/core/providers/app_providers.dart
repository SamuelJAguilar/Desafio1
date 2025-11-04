import 'package:flutter_desafio1/core/services/event_service.dart';
import 'package:flutter_desafio1/core/services/ticket_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../../features/events/controllers/event_controller.dart';

class AppProviders {
  static List<ChangeNotifierProvider> get providers => [
        ChangeNotifierProvider<EventController>(
          create: (context) {
            print('🔄 Creando EventController...');
            final apiService = ApiService(client: http.Client());
            final eventService = EventService(apiService: apiService);
            final ticketService = TicketService(apiService: apiService);
            
            final controller = EventController(
              eventService: eventService,
              ticketService: ticketService,
            );
            
            print('✅ EventController creado - ticketService: ${controller.ticketService != null ? "OK" : "NULL"}');
            return controller;
          },
          lazy: false, // ✅ Forzar creación inmediata
        ),
      ];
}