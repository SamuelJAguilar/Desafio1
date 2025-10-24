import { Controller, Get, Post, Put, Delete, Body, Param } from "@nestjs/common";
import { EventService } from "./evento.service";
import { CreateEventDto } from "./dto/event.dto";
import { CreateEventWithTicketsDto } from "./dto/event-tickets.dto";
import { UpdateEventDto } from "./dto/update-event.dto";

@Controller('events')
export class EventController {

    constructor(private readonly eventoService: EventService) {}
    
    @Get()
    async getAllEvents() {
        return this.eventoService.getAllEvents();
    }

    @Get(':id')
    async getEventById(@Param('id') id: string) { 
        return this.eventoService.getEventById(Number(id)); 
    }

    // Endpoint para crear evento CON tickets
  @Post('with-tickets')
    async createWithTickets(@Body() createEventDto: CreateEventWithTicketsDto) {
        const { ticketTypes, ...eventData } = createEventDto;
        
        return this.eventoService.createEventWithTickets(
            eventData,  // Datos del evento
            ticketTypes // Datos de los tickets
        );
    }

    // Endpoint para crear evento SOLO
    @Post()
    async create(@Body() createEventDto: CreateEventDto) {
        return this.eventoService.createEvent(createEventDto);
    }

    @Delete(':id')
    async delete(@Param('id') id: string) {
        return this.eventoService.deleteEvent(Number(id));
    }

    @Put(':id')
    async update(@Param('id') id: string, @Body() UpdateEventDto: UpdateEventDto) {
        return this.eventoService.updateEvent(Number(id), UpdateEventDto);
    }


}