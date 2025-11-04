class UpdateEventDto {
  final String? title;
  final String? description;
  final DateTime? date;
  final String? location;
  final double? lat;
  final double? lng;
 

  UpdateEventDto({
    this.title,
    this.description,
    this.date,
    this.location,
    this.lat,
    this.lng,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    
    // Solo incluir campos que no sean null
    if (title != null) data['title'] = title;
    if (description != null) data['description'] = description;
    if (date != null) data['date'] = date!.toIso8601String();
    if (location != null) data['location'] = location;
    if (lat != null) data['lat'] = lat;
    if (lng != null) data['lng'] = lng;
    
    return data;
  }
}