import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/layout/appbar.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/controllers/event_controller.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
import 'package:provider/provider.dart';

class EventDetailScreen extends StatefulWidget {
  final Event event;
  const EventDetailScreen({super.key, required this.event});

  @override
  State<EventDetailScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colorstyles.background,
      body: Padding(
        padding: EdgeInsets.only(top: 20, left: 40, right: 40, bottom: 30),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Columna izquierda - Imagen y descripción
            Expanded(flex: 2, child: _buildLeftColumn(context)),
            SizedBox(width: 20),
            // Columna derecha - Panel de detalles (solo espacio necesario)
            _buildDetailsPanel(),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftColumn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Imagen del evento
        _buildEventImage(),
        SizedBox(height: 20),

        
        Text(
          widget.event.title,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colorstyles.textButton,
          ),
        ),
        SizedBox(height: 16),

        
        _buildDescription(),
        SizedBox(height: 30),

        
        Row(
          children: [
            _buildEditButton(context, widget.event),
            SizedBox(width: 20),
            _buildEliminarButton(context, widget.event)
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsPanel() {
    return Container(
      width: 350,
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
            value: _formatDate(widget.event.date),
          ),
          SizedBox(height: 16),

          // Ubicación
          _buildDetailItem(
            icon: Icons.location_on,
            title: 'Ubicación',
            value: widget.event.location,
          ),

          // Coordenadas (si existen)
          if (widget.event.lat != null && widget.event.lng != null) ...[
            SizedBox(height: 16),
            _buildDetailItem(
              icon: Icons.map,
              title: 'Coordenadas',
              value:
                  '${widget.event.lat!.toStringAsFixed(4)}, ${widget.event.lng!.toStringAsFixed(4)}',
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
      height: 350,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: Image.network(
        'https://corsproxy.io/?https://www.esneca.com/wp-content/uploads/eventos-sociales.jpg',
      ),
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
            color: Colorstyles.textButton,
          ),
        ),
        SizedBox(height: 8),
        Text(
          widget.event.description,
          style: TextStyle(fontSize: 16, height: 1.6, color: Colorstyles.component),
        ),
      ],
    );
  }

  Widget _buildEditButton(context, Event event) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.editEvent, arguments: event);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 156, 28, 18), // Rojo
        foregroundColor: Colors.white, // Texto blanco
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
  Widget _buildEliminarButton(context, Event event) {
    return ElevatedButton(
      onPressed: () {
        _eliminar(context);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromARGB(255, 156, 28, 18), // Rojo
        foregroundColor: Colors.white, // Texto blanco
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit, size: 20),
          SizedBox(width: 8),
          Text(
            'Eliminar Evento',
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
            Icon(
              icon,
              color: Color.fromARGB(255, 156, 28, 18),
              size: 20,
            ), // Rojo
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
            style: TextStyle(fontSize: 15, color: Colors.grey[700]),
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
            Icon(
              Icons.confirmation_number,
              color: Color.fromARGB(255, 156, 28, 18),
              size: 20,
            ), // Rojo
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

        if (widget.event.ticketTypes.isEmpty)
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
            children: widget.event.ticketTypes
                .map(
                  (ticket) => Container(
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
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Future<void> _eliminar(BuildContext context) async {
  // Mostrar diálogo de confirmación
  final confirm = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          'Confirmar Eliminación',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 156, 28, 18),
          ),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar el evento "${widget.event.title}"? Esta acción no se puede deshacer.',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false); // Cancelar
            },
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey[700]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(true); // Confirmar
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 156, 28, 18),
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );

  // Si el usuario confirmó la eliminación
  if (confirm == true) {
    final eventController = context.read<EventController>();
    final eventId = widget.event.id;

    try {
      final eventSuccess = await eventController.deleteEvent(eventId);
      if (eventSuccess) {
        _showFeedback(
          '✅ Evento "${widget.event.title}" eliminado correctamente.',
          isError: false,
        );
        Navigator.pushNamed(context, AppRoutes.home);
      } else {
        _showFeedback(
          '❌ Error al eliminar el evento: ${eventController.error}',
          isError: true,
        );
      }
    } catch (e) {
      _showFeedback('🚨 Falló la operación: ${e.toString()}', isError: true);
    }
  }
}

  void _showFeedback(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre',
    ];
    return '${date.day} de ${months[date.month - 1]}, ${date.year}';
  }
}