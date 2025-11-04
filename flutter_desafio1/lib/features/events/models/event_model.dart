import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double? lat;
  final double? lng;
  final List<TicketType> ticketTypes;
  final DateTime createdAt;
  final DateTime updatedAt;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.lat,
    this.lng,
    required this.ticketTypes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor desde JSON (para recibir datos de la API)
 factory Event.fromJson(Map<String, dynamic> json) {
  try {
       
    // Helpers para parsing seguro
    int safeInt(dynamic value) => (value is int) ? value : (value is num) ? value.toInt() : 0;
    String safeString(dynamic value) => (value is String) ? value : '';
    double? safeDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }
    
    DateTime safeDateTime(dynamic value) {
      try {
        if (value is String) return DateTime.parse(value);
        if (value is DateTime) return value;
        return DateTime.now();
      } catch (e) {
        return DateTime.now();
      }
    }

    // Manejo SEGURO de ticketTypes
    List<TicketType> ticketTypes = [];
    try {
      final ticketTypesData = json['ticketTypes'];
      if (ticketTypesData != null && ticketTypesData is List) {
        for (var ticketData in ticketTypesData) {
          try {
            if (ticketData is Map<String, dynamic>) {
              final ticket = TicketType.fromJson(ticketData);
              ticketTypes.add(ticket);
            }
          } catch (e) {
            print('⚠️ Error parseando ticket individual: $e');
          }
        }
      } else {
        print('ℹ️ ticketTypes es null o no es lista: $ticketTypesData');
      }
    } catch (e) {
      print('⚠️ Error general en ticketTypes: $e');
    }


    final event = Event(
      id: safeInt(json['id']),
      title: safeString(json['title']),
      description: safeString(json['description']),
      date: safeDateTime(json['date']),
      location: safeString(json['location']),
      lat: safeDouble(json['lat']),
      lng: safeDouble(json['lng']),
      ticketTypes: ticketTypes,
      createdAt: safeDateTime(json['createdAt']),
      updatedAt: safeDateTime(json['updatedAt']),
    );
    
    print('✅ Event.fromJson - Éxito. ID: ${event.id}, Tickets: ${ticketTypes.length}');
    return event;
  } catch (e, stack) {
    print('❌ Event.fromJson - ERROR CRÍTICO: $e');
    print('❌ Stack trace: $stack');
    print('❌ JSON recibido: $json');
    
    // Crear evento por defecto para no romper el flujo
    return Event(
      id: 0,
      title: 'Error Event',
      description: 'Error parsing event',
      date: DateTime.now(),
      location: 'Unknown',
      ticketTypes: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

  // Convertir a JSON (para enviar datos a la API)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'date': date.toIso8601String(),
      'location': location,
      'lat': lat,
      'lng': lng,
      'ticketTypes': ticketTypes.map((ticket) => ticket.toJson()).toList(),
    };
  }
}