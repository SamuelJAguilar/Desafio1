import { IsString, IsNotEmpty, IsNumber, Min, IsPositive } from 'class-validator';

export class CreateTicketDto {
  @IsString()
  @IsNotEmpty({ message: 'El nombre del ticket es requerido' })
  name: string;

  @IsNumber()
  @IsPositive({ message: 'El precio debe ser mayor a 0' })
  @Min(1, { message: 'El precio mínimo es 1' })
  price: number;
}