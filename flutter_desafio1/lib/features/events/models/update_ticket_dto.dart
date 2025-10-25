class UpdateTicketDto {
  final String? name;
  final double? price;

  UpdateTicketDto({
    this.name,
    this.price,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    if (name != null) data['name'] = name;
    if (price != null) data['price'] = price;
    
    return data;
  }
}