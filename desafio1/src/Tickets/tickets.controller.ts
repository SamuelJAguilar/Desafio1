import { Controller, Get, Post, Put, Delete, Body, Param } from "@nestjs/common";
import { TicketService } from "./tickets.service";
import { CreateTicketDto } from "./dto/tickets.dto";
import { UpdateTicketDto } from "./dto/update-ticket.dto";

@Controller('events/:eventId/tickets') // ← Ruta anidada
export class TicketController {

    constructor(private readonly ticketService: TicketService) {}
    
    // Obtener todos los tickets de un evento específico
    @Get()
    async getTicketsByEvent(@Param('eventId') eventId: string) {
        return this.ticketService.getTicketsByEventId(Number(eventId));
    }

    // Obtener un ticket específico por ID
    @Get(':ticketId')
    async getTicketById(
        @Param('eventId') eventId: string,
        @Param('ticketId') ticketId: string
    ) {
        return this.ticketService.getTicketById(Number(ticketId));
    }

    // Crear un nuevo ticket para un evento específico
    @Post()
    async createTicket(
        @Param('eventId') eventId: string,
        @Body() createTicketDto: CreateTicketDto
    ) {
        return this.ticketService.createTicket(
            Number(eventId), 
            createTicketDto
        );
    }

    // Actualizar un ticket existente
    @Put(':ticketId')
    async updateTicket(
        @Param('ticketId') ticketId: string,
        @Body() updateTicketDto: UpdateTicketDto
    ) {
        return this.ticketService.updateTicket(
            Number(ticketId), 
            updateTicketDto
        );
    }

    // Eliminar un ticket
    @Delete(':ticketId')
    async deleteTicket(@Param('ticketId') ticketId: string) {
        return this.ticketService.deleteTicket(Number(ticketId));
    }
}