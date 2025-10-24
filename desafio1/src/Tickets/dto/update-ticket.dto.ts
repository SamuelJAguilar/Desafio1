import { IsString, IsOptional, IsNumber, Min, IsPositive } from 'class-validator';

export class UpdateTicketDto {
  @IsOptional()
  @IsString()
  name?: string;

  @IsOptional()
  @IsNumber()
  @IsPositive()
  @Min(1)
  price?: number;
}