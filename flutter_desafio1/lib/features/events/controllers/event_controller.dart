import 'package:flutter/foundation.dart';
import 'package:flutter_desafio1/core/services/event_service.dart';
import '../models/event_model.dart';
import '../models/create_event_dto.dart';
import '../models/update_event_dto.dart';


class EventController with ChangeNotifier {
  final EventService eventService;
  
  // Estado de la aplicación
  List<Event> _events = [];
  bool _isLoading = false;
  String? _error;

  EventController({required this.eventService});

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