import { Injectable } from "@nestjs/common";
import { PrismaService } from "src/prisma/prisma.services";
import { Event, Prisma } from "@prisma/client";

@Injectable()
export class EventService {
    constructor(private prisma: PrismaService) { }

    // Obtener todos los eventos CON sus tickets
    async getAllEvents(): Promise<Event[]> {
        return this.prisma.event.findMany({
            include: {
                ticketTypes: true // ← Incluir los tipos de ticket
            }
        });
    }

    // Obtener evento por ID CON sus tickets
    async getEventById(id: number): Promise<Event| null> {
        return this.prisma.event.findUnique({
            where: { id },
            include: {
                ticketTypes: true // ← Incluir los tipos de ticket
            }
        });
    }
    
    // Crear un nuevo evento con sus tickets
    async createEvent(data: Prisma.EventCreateInput): Promise<Event> {
        return this.prisma.event.create({
            data,
            include: {
                ticketTypes: true // ← Devolver también los tickets creados
            }
        });
    }

    // Actualizar un evento existente
    async updateEvent(id: number, data: Prisma.EventUpdateInput): Promise<Event> {
        return this.prisma.event.update({
            where: { id },
            data
        });
    }
    
    // Eliminar un evento (esto eliminará también sus tickets por el Cascade)
    async deleteEvent(id: number): Promise<Event> {
        return this.prisma.event.delete({
            where: { id }
        });
    }

    // Crear un evento junto con múltiples tickets
    async createEventWithTickets(eventData: Prisma.EventCreateInput, ticketsData: Prisma.TicketTypeCreateWithoutEventInput[]): Promise<Event> {
        return this.prisma.event.create({
           data: {
            ...eventData,
            ticketTypes: {
                create: ticketsData // ← Crear tickets relacionados
            }
        },
        include: {
            ticketTypes: true
        }
        });
    }
}