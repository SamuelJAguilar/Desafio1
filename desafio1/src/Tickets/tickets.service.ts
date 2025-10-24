import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.services";
import { TicketType, Prisma } from "@prisma/client";

@Injectable()
export class TicketService {
    constructor(private prisma: PrismaService) { }

    // Obtener todos los tickets
    async getAllTickets(): Promise<TicketType[]> {
        return this.prisma.ticketType.findMany({
            include: {
                event: true // ← Incluir información del evento
            }
        });
    }

    // Obtener tickets por ID
    async getTicketById(id: number): Promise<TicketType | null> {
        return this.prisma.ticketType.findUnique({
            where: { id },
            include: {
                event: true // ← Incluir información del evento
            }
        });
    }

    // Obtener tickets por Evento ID
    async getTicketsByEventId(eventId: number): Promise<TicketType[]> {
        return this.prisma.ticketType.findMany({
            where: { eventId },
            include: {
                event: true
            }
        });
    }
    
    // Crear un nuevo ticket PARA UN EVENTO ESPECÍFICO
    async createTicket(eventId: number, data: Prisma.TicketTypeCreateWithoutEventInput): Promise<TicketType> {
        return this.prisma.ticketType.create({
            data: {
                ...data,
                event: {
                    connect: { id: eventId } // ← Conectar con el evento
                }
            }
        });
    }

    // Actualizar un ticket existente
    async updateTicket(id: number, data: Prisma.TicketTypeUpdateInput): Promise<TicketType> {
        return this.prisma.ticketType.update({
            where: { id },
            data
        });
    }

    // Eliminar un ticket
    async deleteTicket(id: number): Promise<TicketType> {
        return this.prisma.ticketType.delete({
            where: { id }
        });
    }
}