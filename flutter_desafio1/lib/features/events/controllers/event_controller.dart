import 'package:flutter/foundation.dart';
import 'package:flutter_desafio1/core/services/event_service.dart';
import 'package:flutter_desafio1/core/services/ticket_service.dart';
import 'package:flutter_desafio1/features/events/models/create_tickets_dto.dart';
import 'package:flutter_desafio1/features/events/models/update_ticket_dto.dart';
import '../models/event_model.dart';
import '../models/create_event_dto.dart';
import '../models/update_event_dto.dart';

class EventController with ChangeNotifier {
  final EventService eventService;
  final TicketService ticketService;

  // Estado de la aplicación
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  EventController({required this.eventService, required this.ticketService});

  // Getters para acceder al estado
  List<Event> get events => _events;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cargar todos los eventos
  Future<void> loadEvents() async {
    _setLoading(true);
    _error = null;

    try {
      _events = await eventService.getAllEvents();
      notifyListeners(); // ← Notifica a la UI que cambió el estado
    } catch (e) {
      _error = 'Error al cargar eventos: $e';
      notifyListeners();
    } finally {
      _setLoading(false);
    }
  }

  // Crear un nuevo evento con tickets
  Future<bool> createEvent(CreateEventWithTicketsDto eventData) async {
    _setLoading(true);
    _error = null;

    try {
      final newEvent = await eventService.createEventWithTickets(eventData);
      _events.add(newEvent);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al crear evento: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar un evento existente
  Future<bool> updateEvent(int eventId, UpdateEventDto updateData) async {
    _setLoading(true);
    _error = null;

    try {
      final updatedEvent = await eventService.updateEvent(eventId, updateData);

      // Encontrar y reemplazar el evento actualizado
      final index = _events.indexWhere((event) => event.id == eventId);
      if (index != -1) {
        _events[index] = updatedEvent;
        notifyListeners();
      }
      return true;
    } catch (e) {
      _error = 'Error al actualizar evento: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> createTicket(int eventId, CreateTicketDto data) async {
  _setLoading(true); // ✅ Agregar loading state
  _error = null;
  
  try {
    print('🆕 Creando nuevo ticket para evento $eventId...');
    
    // ✅ Usar el servicio correctamente
    final newTicket = await ticketService.createTicket(eventId, data);
    
    // ✅ Actualizar la lista local de eventos
    final eventIndex = _events.indexWhere((event) => event.id == eventId);
    if (eventIndex != -1) {
      // Agregar el nuevo ticket al evento local
      _events[eventIndex].ticketTypes.add(newTicket);
      notifyListeners();
      print('✅ Nuevo ticket creado: ${newTicket.name} (ID: ${newTicket.id})');
    } else {
      print('⚠️ Evento $eventId no encontrado en lista local, recargando...');
      await loadEvents(); // Recargar si no encuentra el evento
    }
    
    return true;
  } catch (e) {
    print('❌ Error creando ticket: $e');
    _error = 'Error al crear ticket: $e';
    notifyListeners();
    return false;
  } finally {
    _setLoading(false);
  }
}

 Future<bool> updateTicket(int eventId, int ticketId, UpdateTicketDto data) async {
    _error = null;
    try {
      await ticketService.updateTicket(eventId, ticketId, data);
      return true;
    } catch (e) {
      _error = 'Error al actualizar ticket: $e';
      notifyListeners();
      return false;
    }
  }

  // Eliminar un evento
  Future<bool> deleteEvent(int eventId) async {
    _setLoading(true);
    _error = null;

    try {
      await eventService.deleteEvent(eventId);
      _events.removeWhere((event) => event.id == eventId);
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar evento: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  //Eliminar Ticket
   Future<bool> deleteTicket(int eventId, int ticketId) async {
    _setLoading(true);
    _error = null;

    try {
      print('🗑️ Eliminando ticket ID: $ticketId del evento ID: $eventId');
      
      await ticketService.deleteTicket(eventId, ticketId);
      
      // Actualizar la lista de eventos localmente
      for (var event in _events) {
        final initialCount = event.ticketTypes.length;
        event.ticketTypes.removeWhere((ticket) => ticket.id == ticketId);
        final finalCount = event.ticketTypes.length;
        if (finalCount < initialCount) {
          print('✅ Ticket $ticketId removido del evento ${event.id}');
        }
      }
      
      notifyListeners();
      return true;
    } catch (e) {
      _error = 'Error al eliminar ticket: $e';
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Limpiar errores
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Método privado para manejar loading state
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }
}
