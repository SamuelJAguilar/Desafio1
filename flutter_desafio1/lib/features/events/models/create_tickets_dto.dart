class CreateTicketDto {
  final String name;
  final double price;
  // Puedes añadir más campos (ej: stock, description) si tu backend los requiere.

  CreateTicketDto({
    required this.name,
    required this.price,
  });

  // Método clave para serializar el objeto a JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      // Si tu backend requiere 'eventId', también deberías incluirlo aquí, 
      // pero dado que lo envías en la URL, generalmente no es necesario en el cuerpo (body).
    };
  }
}