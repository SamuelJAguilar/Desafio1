import 'package:flutter_desafio1/features/events/models/create_tickets_dto.dart';
import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';
import 'package:flutter_desafio1/features/events/models/update_ticket_dto.dart';

import '../../../core/services/api_service.dart';

class TicketService {
  final ApiService apiService;

  TicketService({required this.apiService});

  // Crear ticket para un evento específico
  Future<TicketType> createTicket(int eventId, CreateTicketDto ticketData) async {
  try {
    print('🎫 Creando ticket para evento $eventId: ${ticketData.name}');
    
    final response = await apiService.post(
      '/events/$eventId/tickets', 
      ticketData.toJson()
    );
    
    print('✅ Ticket creado exitosamente: $response');
    return TicketType.fromJson(response);
  } catch (e) {
    print('❌ Error en createTicket: $e');
    throw Exception('Error creating ticket: $e');
  }
}
  

  // Actualizar ticket
  Future<TicketType> updateTicket(int eventId, int ticketId, UpdateTicketDto updateData) async {
    try {
      final response = await apiService.put(
        '/events/$eventId/tickets/$ticketId', 
        updateData.toJson()
      );
      return TicketType.fromJson(response);
    } catch (e) {
      throw Exception('Error updating ticket: $e');
    }
  }

  // Eliminar ticket
  Future<void> deleteTicket(int eventId, int ticketId) async {
    try {
      print('🎫 Eliminando ticket ID: $ticketId del evento ID: $eventId');
      
      
      await apiService.delete('/events/$eventId/tickets/$ticketId');
      
      print('✅ Ticket $ticketId eliminado exitosamente');
    } catch (e) {
      print('❌ Error eliminando ticket $ticketId: $e');
      throw Exception('Error deleting ticket: $e');
    }
  }
}
