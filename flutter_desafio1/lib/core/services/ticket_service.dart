import 'package:flutter_desafio1/features/events/models/create_event_dto.dart';
import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';
import 'package:flutter_desafio1/features/events/models/update_ticket_dto.dart';

import '../../../core/services/api_service.dart';

class TicketService {
  final ApiService apiService;

  TicketService({required this.apiService});

  // Crear ticket para un evento específico
  Future<TicketType> createTicket(int eventId, CreateTicketDto ticketData) async {
    try {
      final response = await apiService.post(
        '/events/$eventId/tickets', 
        ticketData.toJson()
      );
      return TicketType.fromJson(response);
    } catch (e) {
      throw Exception('Error creating ticket: $e');
    }
  }

  // Actualizar ticket
  Future<TicketType> updateTicket(int ticketId, UpdateTicketDto updateData) async {
    try {
      final response = await apiService.put(
        '/tickets/$ticketId', 
        updateData.toJson()
      );
      return TicketType.fromJson(response);
    } catch (e) {
      throw Exception('Error updating ticket: $e');
    }
  }

  // Eliminar ticket
  Future<void> deleteTicket(int ticketId) async {
    try {
      await apiService.delete('/tickets/$ticketId');
    } catch (e) {
      throw Exception('Error deleting ticket: $e');
    }
  }
}