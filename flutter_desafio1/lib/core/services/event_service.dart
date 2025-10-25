import 'package:flutter_desafio1/features/events/models/create_event_dto.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';
import 'package:flutter_desafio1/features/events/models/update_event_dto.dart';

import '../../../core/services/api_service.dart';

class EventService {
  final ApiService apiService;

  EventService({required this.apiService});

  // Obtener todos los eventos
  Future<List<Event>> getAllEvents() async {
    try {
      final response = await apiService.get('/events');
      final List<dynamic> eventsJson = response;
      
      return eventsJson.map((eventJson) => Event.fromJson(eventJson)).toList();
    } catch (e) {
      throw Exception('Error fetching events: $e');
    }
  }

  // Obtener evento por ID
  Future<Event> getEventById(int id) async {
    try {
      final response = await apiService.get('/events/$id');
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error fetching event: $e');
    }
  }

  // Crear evento CON tickets
  Future<Event> createEventWithTickets(CreateEventWithTicketsDto eventData) async {
    try {
      final response = await apiService.post('/events/with-tickets', eventData.toJson());
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  // Crear evento SOLO (sin tickets)
  Future<Event> createEvent(Event eventData) async {
    try {
      final response = await apiService.post('/events', eventData.toJson());
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error creating event: $e');
    }
  }

  // Actualizar evento
  Future<Event> updateEvent(int id, UpdateEventDto updateData) async {
    try {
      final response = await apiService.put('/events/$id', updateData.toJson());
      return Event.fromJson(response);
    } catch (e) {
      throw Exception('Error updating event: $e');
    }
  }

  // Eliminar evento
  Future<void> deleteEvent(int id) async {
    try {
      await apiService.delete('/events/$id');
    } catch (e) {
      throw Exception('Error deleting event: $e');
    }
  }

  // Obtener tickets de un evento específico
  Future<List<TicketType>> getEventTickets(int eventId) async {
    try {
      final response = await apiService.get('/events/$eventId/tickets');
      final List<dynamic> ticketsJson = response;
      
      return ticketsJson.map((ticketJson) => TicketType.fromJson(ticketJson)).toList();
    } catch (e) {
      throw Exception('Error fetching tickets: $e');
    }
  }
}