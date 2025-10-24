import { 
  ValidateNested, 
  IsArray, 
  ArrayMinSize 
} from 'class-validator';
import { Type } from 'class-transformer';
import { CreateEventDto } from './event.dto';
import { CreateTicketDto } from '../../Tickets/dto/tickets.dto';


export class CreateEventWithTicketsDto extends CreateEventDto {
  @IsArray()
  @ArrayMinSize(1, { message: 'Debe haber al menos 1 tipo de ticket' })
  @ValidateNested({ each: true })
  @Type(() => CreateTicketDto)
  ticketTypes: CreateTicketDto[];
}