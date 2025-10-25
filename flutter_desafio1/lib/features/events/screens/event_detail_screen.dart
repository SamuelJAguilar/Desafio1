import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/event_model.dart';
import '../../../core/layout/layout_base.dart'; // ← Agregar import

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return LayoutBase(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda - Imagen y descripción
            Expanded(
              flex: 2,
              child: _buildLeftColumn(),
            ),
            SizedBox(width: 20),
            // Columna derecha - Panel de detalles (solo espacio necesario)
            _buildDetailsPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del evento
        _buildEventImage(),
        SizedBox(height: 20),
        
        // Título
        Text(
          event.title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 16),
        
        // Descripción
        _buildDescription(),
        SizedBox(height: 30),
        
        // Botón de editar
        _buildEditButton(),
      ],
    );
  }

  Widget _buildDetailsPanel() {
    return Container(
      width: 350, // ← Ancho fijo, no expansible
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50], // Gris muy claro
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ← Solo espacio necesario
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título del panel
          Text(
            'Detalles',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          
          // Fecha
          _buildDetailItem(
            icon: Icons.calendar_month,
            title: 'Fecha',
            value: _formatDate(event.date),
          ),
          SizedBox(height: 16),
          
          // Ubicación
          _buildDetailItem(
            icon: Icons.location_on,
            title: 'Ubicación',
            value: event.location,
          ),
          
          // Coordenadas (si existen)
          if (event.lat != null && event.lng != null) ...[
            SizedBox(height: 16),
            _buildDetailItem(
              icon: Icons.map,
              title: 'Coordenadas',
              value: '${event.lat!.toStringAsFixed(4)}, ${event.lng!.toStringAsFixed(4)}',
            ),
          ],
          
          // Tipos de entrada
          SizedBox(height: 20),
          _buildTicketTypesSection(),
        ],
      ),
    );
  }

  Widget _buildEventImage() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: event.imageData == null ? Colors.grey[200] : null,
        image: event.imageData != null
            ? DecorationImage(
                image: MemoryImage(Uint8List.fromList(event.imageData!)),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: event.imageData == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event, size: 60, color: Colors.grey[500]),
                  SizedBox(height: 10),
                  Text(
                    'Imagen no disponible',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Descripción del Evento',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 8),
        Text(
          event.description,
          style: TextStyle(
            fontSize: 16,
            height: 1.6,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildEditButton() {
    return ElevatedButton(
      onPressed: () {
        // Editar evento (lo implementaremos después)
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 156, 28, 18), // Rojo
        foregroundColor: Colors.white, // Texto blanco
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 20),
          SizedBox(width: 8),
          Text(
            'Editar Evento',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color.fromARGB(255, 156, 28, 18), size: 20), // Rojo
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 4),
        Padding(
          padding: EdgeInsets.only(left: 28),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTicketTypesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.confirmation_number, color: Color.fromARGB(255, 156, 28, 18), size: 20), // Rojo
            SizedBox(width: 8),
            Text(
              'Entradas Disponibles',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        
        if (event.ticketTypes.isEmpty)
          Padding(
            padding: EdgeInsets.only(left: 28),
            child: Text(
              'No hay tipos de entrada disponibles',
              style: TextStyle(color: Colors.grey[600]),
            ),
          )
        else
          Column(
            mainAxisSize: MainAxisSize.min, // ← Solo espacio necesario
            children: event.ticketTypes.map((ticket) => Container(
              margin: EdgeInsets.only(bottom: 8, left: 28),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    ticket.name,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '\$${ticket.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 156, 28, 18), // Rojo
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }
}