class CreateEventWithTicketsDto {
  final String title;
  final String description;
  final DateTime date;
  final String location;
  final double? lat;
  final double? lng;
  final List<CreateTicketDto> ticketTypes;

  CreateEventWithTicketsDto({
    required this.title,
    required this.description,
    required this.date,
    required this.location,
    this.lat,
    this.lng,
    required this.ticketTypes,
  });

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

class CreateTicketDto {
  final String name;
  final double price;

  CreateTicketDto({
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}