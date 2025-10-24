import { Module } from '@nestjs/common';
import { eventoModule } from './Eventos/eventos.module';
import { ticketsModule } from './Tickets/tickets.module';
import { PrismaModule } from './prisma/prisma.module';

@Module({
  imports: [eventoModule, ticketsModule, PrismaModule],
  controllers: [],
  providers: [],
})
export class AppModule {}
