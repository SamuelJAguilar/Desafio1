import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';

class EventDetailScreen extends StatefulWidget {
  final int eventId;

  const EventDetailScreen({super.key, required this.eventId});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  Event? _event;

  @override
  void initState() {
    super.initState();
    _loadEvent();
  }

  void _loadEvent() async {
    final eventController = Provider.of<EventController>(context, listen: false);
    
    try {
      // Buscar el evento en la lista cargada primero
      final existingEvent = eventController.events.firstWhere(
        (event) => event.id == widget.eventId,
        orElse: () => Event(
          id: -1, 
          title: '', 
          description: '', 
          date: DateTime.now(), 
          location: '', 
          ticketTypes: [], 
          createdAt: DateTime.now(), 
          updatedAt: DateTime.now()
        ),
      );

      if (existingEvent.id != -1) {
        setState(() {
          _event = existingEvent;
        });
      } else {
        // Si no está en la lista, cargar desde la API
        final event = await eventController.eventService.getEventById(widget.eventId);
        setState(() {
          _event = event;
        });
      }
    } catch (e) {
      // Manejar error silenciosamente por ahora
      print('Error loading event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles del Evento'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _event == null
          ? Center(child: CircularProgressIndicator())
          : _buildEventDetails(),
    );
  }

  Widget _buildEventDetails() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen del evento
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _event!.imageData == null ? Colors.grey[300] : null,
              image: _event!.imageData != null
                  ? DecorationImage(
                      image: MemoryImage(Uint8List.fromList(_event!.imageData!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _event!.imageData == null
                ? Center(
                    child: Text(
                      'Imagen no disponible',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  )
                : null,
          ),
          SizedBox(height: 20),

          // Título
          Text(
            _event!.title,
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),

          // Fecha y ubicación
          Row(
            children: [
              Icon(Icons.calendar_month, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                '${_event!.date.day} de ${_getMonthName(_event!.date.month)}, ${_event!.date.year}',
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[600]),
              SizedBox(width: 8),
              Text(
                _event!.location,
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Descripción
          Text(
            'Descripción',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            _event!.description,
            style: TextStyle(fontSize: 16, height: 1.5),
          ),
          SizedBox(height: 20),

          // Tipos de entrada
          Text(
            'Tipos de Entrada',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          _buildTicketTypes(),

          // Botones de acción
          SizedBox(height: 30),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navegar a editar (lo haremos después)
                },
                child: Text('Editar Evento'),
              ),
              SizedBox(width: 10),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Volver'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketTypes() {
    if (_event!.ticketTypes.isEmpty) {
      return Text(
        'No hay tipos de entrada disponibles',
        style: TextStyle(color: Colors.grey[600]),
      );
    }

    return Column(
      children: _event!.ticketTypes.map((ticket) => Card(
        child: ListTile(
          leading: Icon(Icons.confirmation_number, color: Colors.blue),
          title: Text(ticket.name),
          trailing: Text(
            '\$${ticket.price.toStringAsFixed(2)}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      )).toList(),
    );
  }

  String _getMonthName(int month) {
    const months = [
      'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return months[month - 1];
  }
}