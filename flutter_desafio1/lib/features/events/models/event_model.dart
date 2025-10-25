import 'package:flutter_desafio1/features/events/models/ticket_type_model.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double? lat;
  final double? lng;
  final List<int>? imageData;
  final String? imageType;
  final String? imageName;
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
    this.imageData,
    this.imageType,
    this.imageName,
    required this.ticketTypes,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor desde JSON (para recibir datos de la API)
  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: DateTime.parse(json['date']),
      location: json['location'],
      lat: json['lat']?.toDouble(),
      lng: json['lng']?.toDouble(),
      imageData: json['imageData'] != null ? List<int>.from(json['imageData']) : null,
      imageType: json['imageType'],
      imageName: json['imageName'],
      ticketTypes: (json['ticketTypes'] as List)
          .map((ticketJson) => TicketType.fromJson(ticketJson))
          .toList(),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
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
      'imageData': imageData,
      'imageType': imageType,
      'imageName': imageName,
      'ticketTypes': ticketTypes.map((ticket) => ticket.toJson()).toList(),
    };
  }
}