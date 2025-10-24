import { Module } from "@nestjs/common";
import { TicketController } from "./tickets.controller";
import { PrismaModule } from "src/prisma/prisma.module";
import { TicketService } from "./tickets.service";

@Module({
    controllers: [TicketController],
    providers: [TicketService],
    imports: [PrismaModule],
})
export class ticketsModule {}