import 'dart:typed_data';

import 'package:flutter/material.dart';
import '../models/event_model.dart';

class ContenedorEvent extends StatelessWidget {
  final Event event;
  final VoidCallback onTap; // ← Callback para cuando se presione

  const ContenedorEvent({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // ← Se ejecuta cuando se toca el contenedor
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromARGB(255, 255, 243, 187),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: event.imageData == null ? Colors.grey[300] : null,
                  image: event.imageData != null 
                    ? DecorationImage(
                        image: MemoryImage(
                          Uint8List.fromList(event.imageData!), // ← Imagen desde BLOB
                        ),
                        fit: BoxFit.cover,
                      )
                    : null,
                ),
                child: event.imageData == null
                    ? Center(
                        child: Text(
                          'Imagen no disponible',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      )
                    : null,
              ),
            ),
            SizedBox(height: 12),
            Text(
              event.title, // ← Título dinámico
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.calendar_month, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Text(
                  _formatDate(event.date), // ← Fecha formateada
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    event.location, // ← Ubicación dinámica
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day} de ${_getMonthName(date.month)}, ${date.year}';
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}