import { Module } from "@nestjs/common";
import { EventController } from "./evento.controller";
import { PrismaModule } from "src/prisma/prisma.module";
import { EventService } from "./evento.service";

@Module({
    controllers: [EventController],
    providers: [EventService],
    imports: [PrismaModule],
})
export class eventoModule {}