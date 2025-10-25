class UpdateEventDto {
  final String? title;
  final String? description;
  final DateTime? date;
  final String? location;
  final double? lat;
  final double? lng;
  final List<int>? imageData;
  final String? imageType;
  final String? imageName;

  UpdateEventDto({
    this.title,
    this.description,
    this.date,
    this.location,
    this.lat,
    this.lng,
    this.imageData,
    this.imageType,
    this.imageName,
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
    if (imageData != null) data['imageData'] = imageData;
    if (imageType != null) data['imageType'] = imageType;
    if (imageName != null) data['imageName'] = imageName;
    
    return data;
  }
}