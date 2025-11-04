import 'package:flutter/material.dart';
import 'package:flutter_desafio1/core/styles/colorstyles.dart';
import 'package:flutter_desafio1/features/events/controllers/event_controller.dart';
import 'package:flutter_desafio1/features/events/models/create_event_dto.dart';
import 'package:flutter_desafio1/features/events/models/create_tickets_dto.dart';
import 'package:flutter_desafio1/features/events/models/event_model.dart';
import 'package:flutter_desafio1/features/events/models/update_event_dto.dart';
import 'package:flutter_desafio1/features/events/models/update_ticket_dto.dart';
import 'package:flutter_desafio1/routes/app_routes.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

// Clase de estado para manejar un único formulario de Ticket de manera local
class TicketFormState {
  // 💡 AGREGADO: ID del ticket. Es nulo si es un ticket nuevo.
  final int? ticketId;
  final TextEditingController nameController;
  final TextEditingController priceController;
  final Key key = UniqueKey();

  TicketFormState({
    this.ticketId, // Permite que sea nulo para tickets nuevos
    required this.nameController,
    required this.priceController,
  });

  void dispose() {
    nameController.dispose();
    priceController.dispose();
  }
}

class DetailEvent extends StatefulWidget {
  final Event? event;
  final dynamic Function()? cancelar;
  const DetailEvent({super.key, required this.event, required this.cancelar});

  @override
  State<DetailEvent> createState() => _DetailEventState();
}

class _DetailEventState extends State<DetailEvent> {
  // variable para determinar si estamos editando o creando nuevo evento
  bool crearEvent = true;
  // --- CONTROLADORES Y ESTADO ---
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Nuevos controladores para Ubicación y Coordenadas
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _latitudController = TextEditingController();
  final TextEditingController _longitudController = TextEditingController();

  // Lista dinámica para gestionar los formularios de tickets
  List<TicketFormState> _ticketForms = [];
  List<TicketFormState> _ticketsOriginales = [];

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    // 1. Inicializar Evento y Fecha
    if (widget.event != null) {
      crearEvent = false;
      _tituloController.text = widget.event!.title;
      _descriptionController.text = widget.event!.description;
      _selectedDate = widget.event!.date;
      _locationController.text = widget.event!.location;
      _latitudController.text = widget.event!.lat?.toString() ?? '';
      _longitudController.text = widget.event!.lng?.toString() ?? '';

      // 2. Inicializar Tipos de Ticket (desde el evento existente)
      _ticketForms = widget.event!.ticketTypes.map((ticket) {
        return TicketFormState(
          // 💡 IMPORTANTE: Guardamos el ID del ticket existente
          ticketId: ticket.id,
          nameController: TextEditingController(text: ticket.name),
          // Formateamos el precio con dos decimales para el campo de texto
          priceController: TextEditingController(
            text: ticket.price.toStringAsFixed(2),
          ),
        );
      }).toList();
      _ticketsOriginales = widget.event!.ticketTypes.map((ticket) {
        return TicketFormState(
          // 💡 IMPORTANTE: Guardamos el ID del ticket existente
          ticketId: ticket.id,
          nameController: TextEditingController(text: ticket.name),
          // Formateamos el precio con dos decimales para el campo de texto
          priceController: TextEditingController(
            text: ticket.price.toStringAsFixed(2),
          ),
        );
      }).toList();
      
    } else {
      // Si es nuevo evento, usar la fecha de hoy
      _selectedDate = DateTime.now();
    }

    // Aseguramos que haya al menos un formulario de ticket si la lista está vacía
    if (_ticketForms.isEmpty) {
      _addTicketForm();
    }

    // Formatear la fecha inicial para el campo de texto
    _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    _locationController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();

    // Disponer los controladores de todos los formularios de ticket
    for (var form in _ticketForms) {
      form.dispose();
    }
    super.dispose();
  }

  // Lógica para agregar un nuevo formulario de ticket
  void _addTicketForm() {
    setState(() {
      _ticketForms.add(
        TicketFormState(
          // ticketId es null para tickets nuevos
          nameController: TextEditingController(),
          priceController: TextEditingController(),
        ),
      );
    });
  }

  // Lógica para remover un formulario de ticket
  void _removeTicketForm(TicketFormState form) {
    // Validación: Se requiere al menos un ticket
    if (_ticketForms.length > 1) {
      setState(() {
        form.dispose();
        // Al removerlo de _ticketForms, garantizamos que su ID no se enviará al PUT,
        // lo que le dice al backend (NestJS/Prisma) que debe eliminar este registro.
        _ticketForms.remove(form);
      });
    } else {
      // Opcional: Mostrar un mensaje al usuario de que no puede eliminar el último ticket
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Debe haber al menos un tipo de ticket definido.'),
        ),
      );
    }
  }

  // --- WIDGETS REUTILIZABLES ---

  Future<void> _selectDate(BuildContext context) async {
    final DateTime initialDate = _selectedDate ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      helpText: 'SELECCIONA LA FECHA DEL EVENTO',
      cancelText: 'Cancelar',
      confirmText: 'Aceptar',
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              // Usamos Colorstyles.button para los botones de acción y la selección
              primary: Colorstyles.button,
              // Usamos Colorstyles.textButton para el texto sobre el color primario (día seleccionado)
              onPrimary: Colorstyles.textButton,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
      });
    }
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    IconData? icon,
    TextInputType keyboardType = TextInputType.text,
    bool readOnly = false,
    VoidCallback? onTap,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colorstyles.component,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: TextFormField(
          controller: controller,
          readOnly: readOnly,
          onTap: onTap,
          maxLines: maxLines,
          keyboardType: keyboardType,
          style: const TextStyle(color: Colors.black, fontSize: 18),
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(icon, color: Colorstyles.textInformation)
                : null,
            labelText: label,
            labelStyle: TextStyle(color: Colorstyles.textInformation),
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colorstyles.textInformation),
          ),
        ),
      ),
    );
  }

  // Widget para un único formulario de Ticket
  Widget _buildTicketForm(TicketFormState form, int index) {
    bool canRemove = _ticketForms.length > 1;

    return Padding(
      key: form.key, // Clave única para el widget de ticket
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ticket #${index + 1}${form.ticketId != null ? ' (ID: ${form.ticketId})' : ' (Nuevo)'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              if (canRemove)
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () => _removeTicketForm(form),
                ),
            ],
          ),
          const SizedBox(height: 10),
          // Nombre del Ticket
          _buildField(
            controller: form.nameController,
            label: 'Nombre del Ticket (Ej: VIP, General)',
            icon: Icons.label_important_outline,
          ),
          const SizedBox(height: 10),
          // Precio del Ticket
          _buildField(
            controller: form.priceController,
            label: 'Precio',
            icon: Icons.attach_money,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: 20),
          if (index < _ticketForms.length - 1)
            const Divider(color: Colors.white54, height: 1),
        ],
      ),
    );
  }

  // --- WIDGET PRINCIPAL ---
  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return SingleChildScrollView(
      padding: EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        top: 16.0,
        bottom: 40.0 + bottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- CABECERA ---
          Text(
            crearEvent ? 'Crear Nuevo Evento' : 'Editar Evento',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 30),

          // --- TÍTULO ---
          Text(
            'Título del Evento',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildField(
            controller: _tituloController,
            label: 'Título del Evento',
            maxLines: 1,
          ),
          SizedBox(height: 20),

          // --- DESCRIPCIÓN ---
          Text(
            'Descripción del Evento',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildField(
            controller: _descriptionController,
            label: 'Descripción del evento',
            maxLines: 5,
          ),
          SizedBox(height: 20),

          // --- FECHA DEL EVENTO ---
          Text(
            'Fecha del Evento',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildField(
            controller: _dateController,
            label: 'Fecha seleccionada',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () => _selectDate(context),
          ),
          SizedBox(height: 20),

          // --- UBICACIÓN ---
          Text(
            'Ubicación del Evento',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          _buildField(
            controller: _locationController,
            label: 'Nombre o dirección de ubicación',
            icon: Icons.location_on_outlined,
          ),
          SizedBox(height: 20),

          // --- COORDENADAS (LAT/LNG) ---
          Text(
            'Coordenadas (Opcional)',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildField(
                  controller: _latitudController,
                  label: 'Latitud',
                  icon: Icons.explore_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _buildField(
                  controller: _longitudController,
                  label: 'Longitud',
                  icon: Icons.explore_outlined,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 30),

          // --- GESTIÓN DE TICKETS ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tipos de Ticket (${_ticketForms.length})',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: _addTicketForm,
                icon: Icon(
                  Icons.add,
                  color: const Color.fromARGB(255, 255, 255, 255),
                ),
                label: Text(
                  'Agregar Ticket',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ],
          ),
          const Divider(color: Colors.white54, height: 20),

          // Lista de Formularios de Tickets
          Column(
            children: _ticketForms.asMap().entries.map((entry) {
              return _buildTicketForm(entry.value, entry.key);
            }).toList(),
          ),

          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: widget.cancelar,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colorstyles.button,
                  ),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 20),
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                // 💡 Lógica de Guardar: Llama a POST o PUT
                onPressed: () {
                  if (crearEvent) {
                    _handlePost(context);
                  } else {
                    _handlePut(context); // Llamamos al nuevo método para actualizar
                  }
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colorstyles.button,
                  ),
                ),
                child: Text(
                  'Guardar',
                  style: TextStyle(color: Colorstyles.textButton, fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- LÓGICA DE VALIDACIÓN COMÚN ---

  bool _validateForm({required List<CreateTicketDto> tickets}) {
    // 1. Validación de campos de evento
    if (_tituloController.text.isEmpty) {
      _showFeedback(
        '❌ Por favor, completa el Título del evento.',
        isError: true,
      );
      return false;
    }
    if (_locationController.text.isEmpty) {
      _showFeedback(
        '❌ Por favor, completa la Ubicacion del evento.',
        isError: true,
      );
      return false;
    }
    if (_selectedDate == null) {
      _showFeedback(
        '❌ Por favor, completa la Fecha del evento.',
        isError: true,
      );
      return false;
    }

    // 2. Validación de coordenadas
    final latText = _latitudController.text.trim();
    final lngText = _longitudController.text.trim();
    if ((latText.isNotEmpty && double.tryParse(latText) == null) ||
        (lngText.isNotEmpty && double.tryParse(lngText) == null)) {
      _showFeedback(
        '❌ Las coordenadas deben ser valores numéricos válidos (ej: 40.123).',
        isError: true,
      );
      return false;
    }

    // 3. Validación y recolección de tickets
    tickets
        .clear(); // Limpiamos la lista pasada por referencia antes de llenarla
    for (var form in _ticketForms) {
      final name = form.nameController.text.trim();
      final priceText = form.priceController.text.trim();
      final price = double.tryParse(priceText);

      if (name.isEmpty) {
        _showFeedback(
          '❌ El nombre de un ticket no puede estar vacío.',
          isError: true,
        );
        return false;
      }

      // Validación de precio: debe ser numérico y mayor o igual que cero.
      if (price == null || price < 0) {
        _showFeedback(
          '❌ El precio del ticket "$name" debe ser un número mayor o igual a cero.',
          isError: true,
        );
        return false;
      }
      // NOTA: Para POST (creación), usamos CreateTicketDto.
      tickets.add(CreateTicketDto(name: name, price: price));
    }
    return true;
  }

  // Manejador para CREAR un nuevo evento (POST)
  Future<void> _handlePost(BuildContext context) async {
    final List<CreateTicketDto> tickets = [];

    if (!_validateForm(tickets: tickets)) {
      return;
    }

    final newEventDto = CreateEventWithTicketsDto(
      title: _tituloController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      date: _selectedDate!,
      lat: double.tryParse(_latitudController.text.trim()),
      lng: double.tryParse(_longitudController.text.trim()),
      ticketTypes: tickets,
    );

    final eventController = context.read<EventController>();

    try {
      final success = await eventController.createEvent(newEventDto);

      if (success) {
        _showFeedback(
          '✅ Evento "${newEventDto.title}" creado correctamente.',
          isError: false,
        );
        Navigator.pushNamed(context, AppRoutes.home);
      } else {
        final errorMessage =
            eventController.error ?? 'Error desconocido en la API.';
        _showFeedback('❌ Error al crear evento: $errorMessage', isError: true);
      }
    } catch (e) {
      _showFeedback('🚨 Falló la operación: ${e.toString()}', isError: true);
    }
  }

  // Manejador para ACTUALIZAR un evento existente (PUT)
  Future<void> _handlePut(BuildContext context) async {
    final List<CreateTicketDto> tempTicketsForValidation = [];

    if (!_validateForm(tickets: tempTicketsForValidation)) {
      return;
    }

    final eventController = context.read<EventController>();
    final eventId = widget.event!.id;

    try {
      // 1. Actualizar evento principal
      final updateEventDto = UpdateEventDto(
        title: _tituloController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        date: _selectedDate!,
        lat: double.tryParse(_latitudController.text.trim()),
        lng: double.tryParse(_longitudController.text.trim()),
      );

      final eventSuccess = await eventController.updateEvent(
        eventId,
        updateEventDto,
      );

      if (!eventSuccess) {
        throw Exception('Error actualizando evento: ${eventController.error}');
      }

      // 2. Manejar eliminación de tickets
      final idOriginales = _ticketsOriginales
          .map((f) => f.ticketId)
          .whereType<int>()
          .toSet();
      final idOriginalesActuales = _ticketForms
          .map((f) => f.ticketId)
          .whereType<int>()
          .toSet();
      final idDelets = idOriginales.difference(idOriginalesActuales);

      if (idDelets.isNotEmpty) {
        for (final id in idDelets) {
          final success = await eventController.deleteTicket(eventId, id);
          if (!success) {
            throw Exception(
              'Error eliminando ticket ID: $id - ${eventController.error}',
            );
          }
        }
      }

      // 3. Procesar tickets (actualizar y crear)
      for (final ticket in _ticketForms) {
        final name = ticket.nameController.text.trim();
        final priceText = ticket.priceController.text.trim();
        final price = double.tryParse(priceText) ?? 0;

        if (ticket.ticketId != null) {
          // Actualizar ticket existente
          final updateTicket = UpdateTicketDto(name: name, price: price);
          final success = await eventController.updateTicket(
            eventId,
            ticket.ticketId!,
            updateTicket,
          );
          if (!success) {
            throw Exception(
              'Error actualizando ticket ${ticket.ticketId}: ${eventController.error}',
            );
          }
        } else {
          // Crear nuevo ticket
          final createTicketDto = CreateTicketDto(name: name, price: price);
          final success = await eventController.createTicket(
            eventId,
            createTicketDto,
          );
          if (!success) {
            throw Exception(
              'Error creando nuevo ticket: ${eventController.error}',
            );
          }
        }
      }

      _showFeedback(
        '✅ Evento "${updateEventDto.title}" actualizado correctamente.',
        isError: false,
      );

      await eventController.loadEvents();
      Navigator.pushNamed(context, AppRoutes.home);
      
    } catch (e) {
      _showFeedback('🚨 Falló la operación: ${e.toString()}', isError: true);
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
}
