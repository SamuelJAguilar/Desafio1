class TicketType {
  final int id;
  final String name;
  final double price;
  final int eventId;

  TicketType({
    required this.id,
    required this.name,
    required this.price,
    required this.eventId,
  });

  factory TicketType.fromJson(Map<String, dynamic> json) {
    return TicketType(
      id: json['id'],
      name: json['name'],
      price: json['price'].toDouble(),
      eventId: json['eventId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
    };
  }
}